
/* ================================================  
 * Oracle XFiles Demonstration.  
 *    
 * Copyright (c) 2014 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */

package com.oracle.st.xdb.pm.zip;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import java.sql.SQLException;

import java.text.SimpleDateFormat;

import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.Hashtable;
import java.util.TimeZone;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipOutputStream;

import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleConnection;
import oracle.jdbc.OraclePreparedStatement;
import oracle.jdbc.OracleResultSet;

import oracle.sql.BLOB;
import oracle.sql.CLOB;

import oracle.sql.RAW;

import oracle.xdb.XMLType;

import oracle.xml.parser.v2.DOMParser;
import oracle.xml.parser.v2.XMLDocument;
import oracle.xml.parser.v2.XMLElement;
import oracle.xml.parser.v2.XMLParseException;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import org.w3c.dom.Text;

import org.xml.sax.SAXException;

public class RepositoryExport extends ArchiveManager {

    // TODO :
  
    // Support Version ACLS
    // Support XMLRef (Schema Based Content).
    // 

    public static boolean DEBUG = true;
    
    public static final String RESOURCE_NAMESPACE             = "http://xmlns.oracle.com/xdb/XDBResource.xsd";
    public static final String RESOURCE_SCHEMA_URL            = "http://xmlns.oracle.com/xdb/XDBResource.xsd";
    public static final String BINARY_CONTENT_SCHEMA_URL      = "http://xmlns.oracle.com/xdb/XDBSchema.xsd#binary";
    public static final String TEXT_CONTENT_SCHEMA_URL        = "http://xmlns.oracle.com/xdb/XDBSchema.xsd#text";
    public static final String ACL_SCHEMA_URL                 = "http://xmlns.oracle.com/xdb/acl.xsd#acl";
    
    public static final String XDBCONFIG_SCHEMA_URL           = "http://xmlns.oracle.com/xdb/xdbconfig.xsd";
    public static final String SCHEMA_SCHEMA_URL              = "http://xmlns.oracle.com/xdb/XDBSchema.xsd";
    public static final String RESCONFIG_SCHEMA_URL           = "http://xmlns.oracle.com/xdb/XDBResConfig.xsd";
    public static final String XSSECCLASS_SCHEMA_URL          = "http://xmlns.oracle.com/xs/securityclass.xsd";
    public static final String XSPRINCIPLE_SCHEMA_URL         = "http://xmlns.oracle.com/xs/principal.xsd";
                  
    public static final String VERSION_ID_ELEMENT             = "VCRUID";
    public static final String SCHEMA_ELEMENT_ELEMENT         = "SchemaElement";
    public static final String CONTAINER_ATTRIBUTE            = "Container";

    public static final String HARD_LINK = "HARD";
    public static final String WEAK_LINK = "WEAK";

    private static final String LIST_FOLDER_CONTENTS =
        "select p.resid" +
        "      ,p.path" +
        "      ,extractValue(p.res,'/Resource/ACLOID')" +
        "      ,p.res.getClobVal()" +
        "      ,extractValue(p.res,'/Resource/XMLLob')" +
        "      ,extractValue(p.res,'/Resource/RefCount')" +
        "      ,extractValue(p.link,'/LINK/LinkType')" + 
        "      ,xr.TABLE_NAME " +
        "      ,xr.OWNER " +
        "      ,xr.OBJECT_ID " +
        "  from path_view p, table(XDB_IMPORT_HELPER.decodeXMLReference(extractValue(RES,'/Resource/XMLRef'))) (+) xr" +
        " where under_path(p.res,1,:1,1) = 1";

    private static final String LOOKUP_ACL =
        "select r.RESID " + 
        "      ,extractValue(r.RES,'/Resource/ACLOID')" +
        "      ,r.RES.getClobVal()" +
        "      ,extractValue(r.RES,'/Resource/RefCount')" +
        // "      ,extractValue(p.LINK,'/LINK/LinkType')" +
        "  from RESOURCE_VIEW r  " +
        " where MAKE_REF(XDB.XDB$ACL,:1) = extractValue(r.RES,'/Resource/XMLRef')";
    
    private static final String CHECK_ACL_LOCATION = 
      " select ANY_PATH " +
      "   from RESOURCE_VIEW " +
      "  where RESID = :1 " +
      "    and under_path(RES,:2) = 1";
    
    private static final String GET_ACL_PATHS = 
      " select xmlElement(\"paths\"," +
      "          xmlAttributes(:1 as \"ACLOID\"), " +
      "          xmlAgg( " +
      "            case " +
      "              when instr(PATH,:2) = 1" +
      "                then xmlElement(\"path\",substr(PATH,:3)) " +
      "                else xmlElement(\"path\",PATH) " +
      "              end" +
      "             " +
      "          ) " +
      "        ) " +
      "   from PATH_VIEW" +
      "  where RESID = :4";

    private static final String GET_VERSION_HISTORY_SQL =
        "        select RESOID\n" + 
        "              ,VERSION\n" + 
        "              ,extractValue(r.RES,'/Resource/ACLOID')" +
        "              ,r.RES.getClobVal() RES\n" + 
        "              ,extractValue(R.RES,'/Resource/XMLLob') XMLLOB\n" + 
        "              ,td.TABLE_NAME\n" + 
        "              ,td.OWNER\n" + 
        "              ,td.OBJECT_ID\n" + 
        "          from (\n" + 
        "                 select RESID.COLUMN_VALUE RESOID\n" + 
        "                       ,extractValue(xr.OBJECT_VALUE,'/Resource/@VersionID') VERSION\n" + 
        "                       ,xr.OBJECT_VALUE RES\n" + 
        "                   from table(xdb_utilities.getVersionsByResid(:1)) RESID \n" + 
        "                       ,XDB.XDB$RESOURCE xr\n" + 
        "                  where RESID.COLUMN_VALUE = xr.OBJECT_ID\n" + 
        "               ) r\n" + 
        "              ,table(XDB_IMPORT_HELPER.decodeXMLReference(extractValue(r.RES,'/Resource/XMLRef'))) td\n" + 
        "         order by VERSION";

     private static final String LOOKUP_TARGET_UNRESTRICTED =
        " select path " + "   from PATH_VIEW " + 
        "  where RESID = :1 " +
        "    and existsNode(link,'/LINK[LinkType=\"Hard\"]') = 1 " +
        "    and rownum < 2";

     private static final String LOOKUP_TARGET_RESTRICTED =
        " select path " + "   from PATH_VIEW " + 
        "  where RESID = :1 " +
        "    and existsNode(link,'/LINK[LinkType=\"Hard\"]') = 1 " +
        "    and rownum < 2" + 
        "    and under_path(res,:2) = 1";
     
     private static final String GET_DATABASE_SUMMARY = 
     "select xdburitype('/sys/databaseSummary.xml').getXML() from dual";

    // RDBMS_11GR1
    private static final int SUPPRESS_CONTENT = 16;

    // RDBMS_10GR2
    // static int SUPPRESS_CONTENT = 1;

    private static final String SET_PRINT_MODE =
        "begin xdb_import_utilities.setPrintMode(:1); end;";

    private static final String CLEAR_PRINT_MODE =
        "begin xdb_import_utilities.clearPrintMode(:1); end;";
    
    private static final String GET_EXTERNAL_REFERENCES =
        "select PATH " + 
        "  from PATH_VIEW " + 
        " where RESID = :1 " + 
        "   and not UNDER_PATH(RES,:2) = 1";
    
    private ZipOutputStream zos;

    // ResourceID of all ACLs that have been included in the export
  
    protected Hashtable exportedACLList;
  
    // ResourceID of any resource which is hard-linked into more than location. Used
    // to prevent a resource being processed more than once. 
   
    private Hashtable hardLinkList;

    private Hashtable weakLinkList;

    private Hashtable xmlSchemaDependancyList;

    private Hashtable xmlTableDependancyList;
    private String lastContentTable;
    
    private OracleConnection databaseConnection;

    private OraclePreparedStatement listFolderContents;
    private OraclePreparedStatement checkACLLocation;
    private OraclePreparedStatement getACLPaths;
    private OraclePreparedStatement lookupVersions;
    private OraclePreparedStatement lookupTarget;
    private OraclePreparedStatement getExternalReferences;

    private int resourceSuffix = 0;

    private String temporaryACLFolder;

  private XMLDocument makeResource(RAW resourceID, RAW aclOID, CLOB clob) 
  throws SQLException, SAXException, IOException {
    DOMParser parser = new DOMParser();
    parser.parse(clob.getCharacterStream(0));
    clob.freeTemporary();
    XMLDocument resource = parser.getDocument();
    XMLElement root = (XMLElement)resource.getDocumentElement();

    root.getParentNode().insertBefore(resource.createProcessingInstruction("Resid", resourceID.stringValue()), root);
    root.getParentNode().insertBefore(resource.createProcessingInstruction("ACLOID", this.temporaryACLFolder + aclOID.stringValue() + ".xml"),root);
    Element element = (Element)root.getChildrenByTagName("ACL").item(0);
    root.removeChild(element);
    return resource;
  }

    private String getRelativePath(String path) {
        if (path.startsWith(this.targetFolder)) {
            if (targetFolder.endsWith("/")) {
                path = path.substring(targetFolder.length());
            } else {
                path = path.substring(targetFolder.length() + 1);
            }
        }
        return path;
    }

    private void addPath(String entryName, String path) 
    throws IOException, SQLException {
        // Create a ZipEntry for the Resource document associated with the Folder
        // System.out.println(zipEntry.getName());
        ZipEntry zipEntry = new ZipEntry(entryName);
        this.zos.putNextEntry(zipEntry);
        zos.write(getRelativePath(path).getBytes());
        zos.flush();
        zos.closeEntry();
    }
    
    
  private void addFolderPath(String entryName, String path) 
  throws IOException, SQLException {
      // Create a ZipEntry for the Resource document associated with the Folder
      writeLogRecord("[" + entryName + "] : \"" + path + "\". Processing Folder.");
      addPath(entryName + ".dir", path);
  }

  private void addPathEntry(String entryName, String path) 
  throws IOException, SQLException {
    // Create a Entry for the Resource document associated with the File
    if (path != null) {
      writeLogRecord("[" + entryName + "] : \"" + path + "\".");
      addPath(entryName + ".path", path);
    }
  }

  private void addLinkEntry(String entryName, String linkPath, String linkTarget, String linkType) 
  throws IOException, SQLException {
      // Create a Entry Link consisting of :
      //
      // targetPath : The existing resource : From
      // path       : The link to be created : To
      // linkType   : Weak or Hard : Type

      this.resourceSuffix++;
      addPathEntry(entryName + "." + this.resourceSuffix, linkPath);
      this.logWriter.print(" Processing Link.");
      XMLDocument linkDescription = new XMLDocument();
      linkDescription.appendChild(linkDescription.createElement("LinkDescription"));
      XMLElement linkPathElement = (XMLElement)linkDescription.createElement("linkPath");
      XMLElement linkTargetElement     = (XMLElement)linkDescription.createElement("linkTarget");
      XMLElement linkTypeElement    = (XMLElement)linkDescription.createElement("linkType");
      linkDescription.getDocumentElement().appendChild(linkPathElement);
      linkDescription.getDocumentElement().appendChild(linkTargetElement);
      linkDescription.getDocumentElement().appendChild(linkTypeElement);
      Text text = linkDescription.createTextNode(getRelativePath(linkPath));
      linkPathElement.appendChild(text);
      text = linkDescription.createTextNode(getRelativePath(linkTarget));
      linkTargetElement.appendChild(text);
      text = linkDescription.createTextNode(linkType);
      linkTypeElement.appendChild(text);

      entryName = entryName + "." + this.resourceSuffix + ".link";

      ZipEntry zipEntry = new ZipEntry(entryName);
      this.zos.putNextEntry(zipEntry);
      linkDescription.print(this.zos);
      linkDescription.freeNode();
      zos.flush();
      zos.closeEntry();
  }
  
  private void processXMLReference(String entryName, String contentSchema, String owner, String table, RAW OID)
  throws IOException, SQLException {

    if (contentSchema != null) {
      String schemaLocation = contentSchema.substring(0, contentSchema.indexOf('#')-1);
      if (!this.xmlSchemaDependancyList.contains(schemaLocation)) {
        this.xmlSchemaDependancyList.put(contentSchema, schemaLocation);
      }
    }
    
    if ((owner == null) || (table == null)) {
      writeLogRecord("[" + entryName + "] : Dangling Ref.");
      return;
    }

      String qualifiedTableName = "\"" + owner + "\".\"" + table + "\"";
      if (!qualifiedTableName.equals(lastContentTable)) {
        if (!xmlTableDependancyList.contains(qualifiedTableName)) {
          xmlTableDependancyList.put(qualifiedTableName, qualifiedTableName);
        }
      }
      this.lastContentTable = qualifiedTableName;

      // addResourceEntry(entryName, resource);

      writeLogRecord("[" + entryName + "] : Schema Based XML from table " + qualifiedTableName + ".");
    
      XMLDocument xmlReference = new XMLDocument();
      xmlReference.appendChild(xmlReference.createElement("xmlReference"));
      XMLElement schemaElement = (XMLElement)xmlReference.createElement("schemaElement");
      XMLElement ownerElement = (XMLElement)xmlReference.createElement("owner");
      XMLElement tableElement     = (XMLElement)xmlReference.createElement("table");
      XMLElement oidElement    = (XMLElement)xmlReference.createElement("OID");
      xmlReference.getDocumentElement().appendChild(schemaElement);
      xmlReference.getDocumentElement().appendChild(ownerElement);
      xmlReference.getDocumentElement().appendChild(tableElement);
      xmlReference.getDocumentElement().appendChild(oidElement);
      Text text = xmlReference.createTextNode(contentSchema);
      schemaElement.appendChild(text);
      text = xmlReference.createTextNode(getRelativePath(owner));
      ownerElement.appendChild(text);
      text = xmlReference.createTextNode(getRelativePath(table));
      tableElement.appendChild(text);
      text = xmlReference.createTextNode(OID.stringValue());
      oidElement.appendChild(text);
      
      entryName = entryName + ".xmlref";
      
      ZipEntry zipEntry = new ZipEntry(entryName);
      this.zos.putNextEntry(zipEntry);
      xmlReference.print(this.zos);
      xmlReference.freeNode();
      zos.flush();
      zos.closeEntry();
  }


  private void writeXMLEntry(String entryName, XMLDocument resource)
  throws IOException, SQLException {
    ZipEntry zipEntry = new ZipEntry(entryName);
    this.zos.putNextEntry(zipEntry);
    resource.print(this.zos);
    resource.freeNode();
    zos.flush();
    zos.closeEntry();
  }

  private void addResourceEntry(String entryName, XMLDocument resource) 
  throws IOException, SQLException {
    // Create a ZipEntry for the Resource document associated with the File or Folder
    
    String qualifiedEntryName = entryName + ".res";
    this.logWriter.print(" Archiving Resource Document.");
    writeXMLEntry(qualifiedEntryName,resource);       
  }

  public long addContent(String entryName, BLOB content) 
  throws IOException, SQLException {
    try {
      long bytesWritten = 0;
      this.resourceStartTime = System.currentTimeMillis();
      writeLogRecord("[" + entryName + "] : ");

      if (content != null) {
        ZipEntry zipEntry = new ZipEntry(entryName + ".lob");
        zos.putNextEntry(zipEntry);

        InputStream is = content.getBinaryStream();
        byte[] buffer = new byte[BLOB.MAX_CHUNK_SIZE * 1024];
        int n;
        int bytesRead = 0;
        long chunkStartTime = System.currentTimeMillis();
        while (-1 != (n = is.read(buffer, 0, buffer.length))) {
          zos.write(buffer, 0, n);
          bytesRead = bytesRead + n;
          bytesWritten = bytesWritten + n;
          if ((System.currentTimeMillis() - chunkStartTime) > 30000) {
            this.logWriter.print("Bytes read : " + bytesRead + ". Bytes written : " + bytesWritten + ". Elapsed time = " + this.printElapsedTime(chunkStartTime,bytesRead));
            writeLogRecord("[" + entryName + "] : ");  
            chunkStartTime = System.currentTimeMillis();
            bytesRead = 0;
          }
        }
        zos.flush();
        zos.closeEntry();
        if (content.isTemporary()) {
          content.freeTemporary();
        }
      }
      this.logWriter.print("Binary content. Bytes written : " + bytesWritten + ". Elapsed time = " + this.printElapsedTime(this.resourceStartTime,bytesWritten));
      return bytesWritten;
    } catch (ZipException ze) {
        logZipException(entryName, ze);
        if (content != null) {
            if (content.isTemporary()) {
                content.freeTemporary();
            }
        }
    }
    return -1;
  }

  private void processACLPaths(RAW resourceID, RAW targetACLOID) 
  throws SQLException, IOException {
    
    this.getACLPaths.setRAW(1,targetACLOID);
    this.getACLPaths.setString(2,this.targetFolder);
 
    if (this.targetFolder.equals("/")) {
      this.getACLPaths.setInt(3,2);
    }
    else {
      this.getACLPaths.setInt(3,this.targetFolder.length()+2);
    }
 
    this.getACLPaths.setRAW(4,resourceID);

    OracleResultSet resultSet = (OracleResultSet) this.getACLPaths.executeQuery();

    while (resultSet.next()) {
      XMLType paths = (XMLType) resultSet.getObject(1);
      XMLDocument pathList = (XMLDocument) paths.getDocument();
      writeXMLEntry(resourceID.stringValue() + ".pathList", pathList);
      paths.close();
    }
    
    resultSet.close();
  }
  
  private void processExportParameters(Element skipList)
  throws SQLException, IOException {
                                     
    XMLDocument doc = new XMLDocument();
    Element root = doc.createElement("exportParameters");
    doc.appendChild(root);
    Element e = doc.createElement("exportVersion");
    Text t = doc.createTextNode("1.0");
    e.appendChild(t);
    root.appendChild(e);
    e = doc.createElement(ArchiveManager.TARGET_FOLDER_PATH);
    t = doc.createTextNode(this.targetFolder);
    e.appendChild(t);
    root.appendChild(e);
    e = doc.createElement(ArchiveManager.TEMPORARY_ACL_FOLDER);
    t = doc.createTextNode(this.temporaryACLFolder);
    e.appendChild(t);
    root.appendChild(e);
    e = (Element) skipList.cloneNode(true);
    e = (Element) doc.adoptNode(e);
    root.appendChild(e);
    writeXMLEntry("ExportParameters.xml", doc);
    
  }
  private void printXMLTableDependancyList()
  throws SQLException, IOException {
                                     
    XMLDocument doc = new XMLDocument();
    Element root = doc.createElement("dependantTables");
    doc.appendChild(root);
    
    Enumeration e = this.xmlTableDependancyList.keys();
    while (e.hasMoreElements()) {
        String qualifiedTableName = (String) e.nextElement();
        Element s = doc.createElement("table");
        Text t = doc.createTextNode(qualifiedTableName);
        s.appendChild(t);
        root.appendChild(s);
        writeLogRecord("Export Dependancy : Table " + qualifiedTableName + ".");
    }
    writeXMLEntry("tableList.xml", doc);
  }
  
  private void printXMLSchemaDependancyList()
  throws SQLException, IOException {
                                     
    XMLDocument doc = new XMLDocument();
    Element root = doc.createElement("dependantschemas");
    doc.appendChild(root);
    
    Enumeration e = this.xmlSchemaDependancyList.keys();
    while (e.hasMoreElements()) {
        String schemaLocation = (String) e.nextElement();
        Element s = doc.createElement("schemaLocationHint");
        Text t = doc.createTextNode(schemaLocation);
        s.appendChild(t);
        root.appendChild(s);
        writeLogRecord("Export Dependancy : XML Schema \"" + schemaLocation + "\".");
    }
    writeXMLEntry("schemaList.xml", doc);
  }
                                   
  private void processDatabaseSummary() 
  throws SQLException, IOException {
    OraclePreparedStatement statement = (OraclePreparedStatement) this.databaseConnection.prepareStatement(GET_DATABASE_SUMMARY);
    statement.execute();
    OracleResultSet rs = (OracleResultSet) statement.getResultSet();
     while (rs.next()) {
       XMLType summary = (XMLType) rs.getObject(1);
       XMLDocument doc = (XMLDocument) summary.getDocument();
       writeXMLEntry("DatabaseSummary.xml", doc);
     }
     rs.close();
     statement.close();
  }

  private void processACL(RAW targetACLOID) 
  throws SAXException, SQLException,IOException {
    
    if (!this.exportedACLList.containsKey(targetACLOID.stringValue())) {
      
      // ACL has not been processed. Retrieve ACL details
      
      clearPrintMode(SUPPRESS_CONTENT);
      String aclOidPath =  this.temporaryACLFolder + targetACLOID.stringValue()  + ".xml";

      OraclePreparedStatement lookupACL = (OraclePreparedStatement)this.databaseConnection.prepareStatement(LOOKUP_ACL);
      lookupACL.setRAW(1,targetACLOID);
      OracleResultSet resultSet = (OracleResultSet) lookupACL.executeQuery();

      while (resultSet.next()) {
        RAW resourceID = resultSet.getRAW(1);
        RAW aclACLOID = resultSet.getRAW(2);
        CLOB clob = resultSet.getCLOB(3);
        // int refCount = resultSet.getNUMBER(4).intValue();
      
        writeLogRecord("[" + resourceID.stringValue() + "] : Processing ACL  [" + targetACLOID.stringValue() + "].");

        exportedACLList.put(targetACLOID.stringValue(), resourceID.stringValue());
        processACL(aclACLOID);
        
        processACLPaths(resourceID,targetACLOID);

        // ACL is written to a temporary folder using the ACLOID as the Link Name

        XMLDocument resource = makeResource(resourceID, aclACLOID, clob);
        addPathEntry(resourceID.stringValue(), aclOidPath);
        addResourceEntry(resourceID.stringValue(), resource);
        resource.freeNode();
        
      }      
      
      resultSet.close();
      lookupACL.close();
    }
  }

    public void processVersionSeries(RAW resourceID, XMLDocument resource, BLOB content, RAW contentID, String tableName, String owner) 
    throws IOException, SQLException, XMLParseException, SAXException {

        // Write the versioned documents into the Zip Archive. Order is Oldest ==> Current
        int versionID = 0;
          
        setPrintMode(SUPPRESS_CONTENT);
        lookupVersions.setRAW(1, resourceID);
        OracleResultSet resultSet = (OracleResultSet)lookupVersions.executeQuery();
        while (resultSet.next()) {
          RAW vResourceID = resultSet.getRAW(1);
          if (!vResourceID.stringValue().equals(resourceID.stringValue())) {
                 
            versionID = resultSet.getNUMBER(2).intValue();
            RAW vACLOID = resultSet.getRAW(3);
            CLOB clob = resultSet.getCLOB(4);
            BLOB vContent = resultSet.getBLOB(5);
            String vTableName = resultSet.getString(6);
            String vOwner = resultSet.getString(7);
            RAW vContentID = resultSet.getRAW(8);

            XMLDocument vResource = makeResource(resourceID, vACLOID, clob);
            String entryName = resourceID.stringValue() + "." + versionID;

            // Create a ZipEntry for the Resource document associated with the File or Folder
            writeLogRecord("[" + entryName + "] :");
            addResourceEntry(entryName, vResource);
              
            if (content != null) {
              addContent(entryName, vContent);
            }
            else {
              // Assumes that all members of the Version History are Schema Based XML associated with the same XML Schema.
              String vContentSchemaHint = getContentSchemaHint(vResource);
              processXMLReference(entryName, vContentSchemaHint, vOwner, vTableName, vContentID);
            }
          }
        }
        
        resultSet.close();

        // Write the resource for current version to the Archive..
        // Check that the current resource has not already been processed.
        // This situation occurs when the document has been checked-out but not yet updated.
        
        String entryName = resourceID.stringValue();
        writeLogRecord("[" + entryName +"] : Processing Current Version.");
        writeLogRecord("[" + entryName +"] :");
        addResourceEntry(entryName, resource);
      
        if (content != null) {
          addContent(entryName, content);
        }
        else {
          String contentSchema = getContentSchemaHint(resource);
          processXMLReference(entryName, contentSchema, owner, tableName, contentID);
        }
    }

    private Hashtable addSubFolder(String path, XMLDocument resource,
                                   Hashtable subFolders) throws IOException,
                                                                SQLException {
        subFolders.put(path, resource);
        return subFolders;
    }

    private void processVersionedDocument(RAW resourceID, XMLDocument resource, BLOB content, RAW contentID, String tableName, String owner) 
    throws IOException, SQLException, SAXException {
        this.logWriter.print(" Processing Version Series.");
        processVersionSeries(resourceID, resource, content, contentID, tableName, owner);
    }

    private void processDocumentLOB(String entryName, String path, XMLDocument resource, BLOB content) 
    throws IOException, SQLException {
        addResourceEntry(entryName, resource);
        addContent(entryName, content);
    }
    
    private String getContentSchemaHint(XMLDocument resource) {
      // NodeList nl = resource.getElementsByTagNameNS(this.SCHEMA_ELEMENT_ELEMENT,this.RESOURCE_NAMESPACE);
      NodeList nl = resource.getElementsByTagName(SCHEMA_ELEMENT_ELEMENT);
      if (nl.getLength() == 0) {
        return null;
      }
      else {
        return nl.item(0).getFirstChild().getNodeValue();      
      }
    }
    
  private void processDocumentRef(String entryName, String path, XMLDocument resource, BLOB content, String owner, String tableName,  RAW contentID) 
  throws IOException, SQLException, SAXException {

    // XML based content. 

    String contentSchema =  getContentSchemaHint(resource);

    if (contentSchema == null) {
      // REF to a row in an non-schema based XMLType table of view created using the XMLREF based version of DBMS_XDB.createResource()
      addPathEntry(entryName, path);      
      addResourceEntry(entryName,resource);
      processXMLReference(entryName,null,owner,tableName,contentID);
      return;
   }

   // Special Handling for XMLDB XML Schema based documents such as XDBConfig, ACL, XMLSchema and Resource Configurations goes here.

    if (contentSchema.equals(ACL_SCHEMA_URL)) {
      // Special Processing For ACL documents
      processACL(contentID);
      addLinkEntry(entryName, path, this.temporaryACLFolder + contentID.stringValue() + ".xml", HARD_LINK);
      return;
    }

    if (contentSchema.indexOf(SCHEMA_SCHEMA_URL) == 0) {
       // Special Processing for Registered XML Schemas
       writeLogRecord("[" + entryName + "] : \"" + path + "\". Skipping XML Schema document.");                          
       return;
    }

    if (contentSchema.indexOf(XDBCONFIG_SCHEMA_URL) == 0) {
      // Specicial processing for XDB Configuration Documents
      writeLogRecord("[" + entryName + "] : \"" + path + "\". Skipping XMLDB Configuration document.");                          
      return;
    }

    if (contentSchema.indexOf(RESCONFIG_SCHEMA_URL) == 0) {
      // Special Processing for Repository Configuration Documents
      writeLogRecord("[" + entryName + "] : \"" + path + "\". Skipping XMLDB Repository Configuration document.");                                                        
      return;
    }

    if (contentSchema.indexOf(XSPRINCIPLE_SCHEMA_URL) == 0) {
      // Special Processing for Repository Configuration Documents
      writeLogRecord("[" + entryName + "] : \"" + path + "\". Skipping Fusion Security Principle document.");                                                        
      return;
    }

    if (contentSchema.indexOf(XSSECCLASS_SCHEMA_URL) == 0) {
      // Special Processing for Repository Configuration Documents
      writeLogRecord("[" + entryName + "] : \"" + path + "\". Skipping Fusion Security Security Class Definition document.");                                                        
      return;
    }

    // Code for user supplied XML Schemas goes here..
    // For user registered XML Schemas try to write the resource + the SCHEMA_NAME, TABLENAME and OID of the content

    addPathEntry(entryName, path);      
    addResourceEntry(entryName,resource);
    processXMLReference(entryName,contentSchema,owner,tableName,contentID);

  }
  
  private Hashtable processResource(OracleResultSet resultSet, Hashtable folderList) 
  throws SAXException, SQLException, IOException {

    RAW resourceID = resultSet.getRAW(1);
    String path = resultSet.getString(2);
    RAW aclOID = resultSet.getRAW(3);
    CLOB clob = resultSet.getCLOB(4);
    BLOB content = resultSet.getBLOB(5);
    int refCount = resultSet.getNUMBER(6).intValue();
    String linkType = resultSet.getString(7);
    String tableName = resultSet.getString(8);
    String owner = resultSet.getString(9);
    RAW contentID = resultSet.getRAW(10);

    // If this is a _WEAK_ link add the path to the list of Weak Links. Weak Links are 
    // written to the archive file only when all other paths have been processed

    if (linkType.equalsIgnoreCase("WEAK")) {
        this.weakLinkList.put(path, resourceID);
        return folderList;
    }

    // Check if there are multiple _HARD_ links to the current resource.
    // Hashtable hardLinkList contains the ResourceID's of resources with more than 1 hard link.

    if (refCount > 1) { 

        // There are multiple HARD LINKS to this resource. 

        if (this.hardLinkList.containsKey(resourceID.stringValue())) {

            // The resource has already been processed simply create a link entry for this 
            // path to the resource.
    
            String linkTarget = (String) this.hardLinkList.get(resourceID.stringValue());
            addLinkEntry(resourceID.stringValue(), path, linkTarget, HARD_LINK);
            return folderList;
        }
        
        // Add this resourceId to the Link List and continue processing the resource normally.
        
        this.hardLinkList.put(resourceID.stringValue(), path);
    }

    processACL(aclOID);
    
    XMLDocument resource = makeResource(resourceID, aclOID, clob);
    XMLElement root = (XMLElement)resource.getDocumentElement();
    boolean isFolder = root.getAttribute(CONTAINER_ATTRIBUTE).equalsIgnoreCase("true");
    
    // NodeList nl = root.getElementsByTagNameNS(this.VERSION_ID_ELEMENT,this.RESOURCE_NAMESPACE);
    NodeList nl = root.getElementsByTagName(VERSION_ID_ELEMENT);
    boolean isVersioned = nl.getLength() > 0;

    if (isFolder) {
        if (!this.ignoreFoldersList.containsKey(path)) {
            folderList = addSubFolder(path, resource, folderList);
        } else {
            writeLogRecord("[" + resourceID.stringValue() + "] : \"" + path + "\". Skipping Folder.");
        }
    } 
    else {
      if (this.ignoreFilesList.containsKey(path)){
        writeLogRecord("[" + resourceID.stringValue() + "] : \"" + path + "\". Skipping Document.");
      }
      else {
        if (this.exportedACLList.containsValue(resourceID.stringValue())) {
          addLinkEntry(resourceID.stringValue(), path, this.temporaryACLFolder + contentID.stringValue() + ".xml", HARD_LINK);
        }
        else {
          // File is not excluded from the export file and has not been previously processed.
          if (isVersioned) {
            // Write the versions to the export file in earliest to most recent order
            addPathEntry(resourceID.stringValue(), path);
            processVersionedDocument(resourceID, resource, content, contentID, tableName, owner);
          } 
          else {
            // Check the type of Content
            // There are two types of content. LOB based content stored in XDB.XDB$RESOURCE and XML content stored
            // in some other location and identified by a REF. Note non-schema based content can be stored in 
            // a LOB in XDB.XDB$RESOURCE and a REF can reference content in schema based or non-schema based 
            // XMLType tables or Views.
            if (content != null) {
              addPathEntry(resourceID.stringValue(), path);
              processDocumentLOB(resourceID.stringValue(), path, resource, content);                                  
            }
            else {
              processDocumentRef(resourceID.stringValue(), path, resource, content, owner, tableName, contentID);
            }
          }
        } 
      }
    }
    resource.freeNode();
    return folderList;
  }

    private Hashtable processResultSet(OracleResultSet resultSet) 
    throws SAXException,SQLException,IOException {
        // Zip each resource found in the folder.
        Hashtable folderList = new Hashtable();
        while (resultSet.next()) {
            processResource(resultSet, folderList);
        }
        resultSet.close();
        return folderList;
    }

    private void processSubFolder(String path, XMLDocument resource) 
    throws IOException,SQLException,SAXException {
        RAW resourceID = new RAW(RAW.hexString2Bytes(resource.getFirstChild().getNodeValue()));
        addFolderPath(resourceID.stringValue(), path);

        // XMLElement refCount = (XMLElement)((XMLElement)resource.getDocumentElement()).getChildrenByTagName("RefCount").item(0);
        // Text refCountValue = (Text) refCount.getFirstChild();
        // boolean isLinkTarget = Integer.parseInt(refCountValue.getData()) > 1;
        // addLinkTarget(resourceID,isLinkTarget,HARD_LINK);

        processFolder(path);

        addPathEntry(resourceID.stringValue(), path);
        addResourceEntry(resourceID.stringValue(), resource);
    }

    private void processFolder(String path) 
    throws IOException, SQLException,SAXException {
        setPrintMode(SUPPRESS_CONTENT);
        this.listFolderContents.setString(1, path);
        OracleResultSet resultSet = (OracleResultSet)this.listFolderContents.executeQuery();

        // First Zip all the Files and build a list of all Folders that are immediate Children of the current Folder
        // This approach reduces the number of open cursors required to complete the operation since we can close
        // the resultSet for the current folder before processing it's subfolders.

        Hashtable folderList = processResultSet(resultSet);

        // Next Zip the contents of any subFolders that were identified

        Enumeration subFolders = folderList.keys();
        while (subFolders.hasMoreElements()) {
            String folderPath = (String)subFolders.nextElement();
            processSubFolder(folderPath, (XMLDocument)folderList.get(folderPath));
        }
    }

    private void processWeakLinks() 
    throws IOException, SQLException {
        Enumeration weakLinks = weakLinkList.keys();
        while (weakLinks.hasMoreElements()) {
            String path = (String)weakLinks.nextElement();
            RAW resourceID = (RAW) weakLinkList.get(path);
            this.lookupTarget.setRAW(1, resourceID);
            OracleResultSet resultSet = (OracleResultSet)lookupTarget.executeQuery();
            while (resultSet.next()) {
                String resourcePath = resultSet.getString(1);
                addLinkEntry(resourceID.stringValue(), path, resourcePath, WEAK_LINK);
            }
            resultSet.close();
        }
    }

    private void setPrintMode(int mode) throws SQLException {
        OracleCallableStatement setPrintMode = (OracleCallableStatement)databaseConnection.prepareCall(SET_PRINT_MODE);
        setPrintMode.setInt(1, mode);
        setPrintMode.executeQuery();
        setPrintMode.close();
    }

    private void clearPrintMode(int mode) throws SQLException {
        OracleCallableStatement setPrintMode = (OracleCallableStatement)databaseConnection.prepareCall(CLEAR_PRINT_MODE);
        setPrintMode.setInt(1, mode);
        setPrintMode.executeQuery();
        setPrintMode.close();
    }

    public void exportFolder(String path, OutputStream os, Element skipList) 
    throws SQLException,IOException,SAXException {
      
      // TODO : Versioned ACLs ?

      this.archiveStartTime = logTimestamp.getTimeInMillis();
      this.writeLogRecord("Export started for path : " + path);
      
      this.listFolderContents = (OraclePreparedStatement)this.databaseConnection.prepareStatement(LIST_FOLDER_CONTENTS);
      this.checkACLLocation = (OraclePreparedStatement)this.databaseConnection.prepareStatement(CHECK_ACL_LOCATION);
      this.getACLPaths = (OraclePreparedStatement)this.databaseConnection.prepareStatement(GET_ACL_PATHS);
      this.lookupVersions = (OraclePreparedStatement)this.databaseConnection.prepareStatement(GET_VERSION_HISTORY_SQL);
      this.getExternalReferences = (OraclePreparedStatement)this.databaseConnection.prepareStatement(GET_EXTERNAL_REFERENCES);
      if (path.equals("/")) {
          this.lookupTarget = (OraclePreparedStatement)this.databaseConnection.prepareStatement(LOOKUP_TARGET_UNRESTRICTED);
      } else {
          this.lookupTarget = (OraclePreparedStatement)this.databaseConnection.prepareStatement(LOOKUP_TARGET_RESTRICTED);
          this.lookupTarget.setString(2, path);
      }

      this.ignoreFoldersList = new Hashtable();
      this.ignoreFilesList = new Hashtable();
      this.exportedACLList = new Hashtable();
      this.hardLinkList = new Hashtable();
      this.weakLinkList = new Hashtable();
      this.xmlSchemaDependancyList = new Hashtable();
      this.xmlTableDependancyList = new Hashtable();

      processSkipList(skipList);

      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HHmmss.S'000Z'");
      sdf.setTimeZone(TimeZone.getTimeZone("GMT+0"));
      GregorianCalendar cal = new GregorianCalendar();
      cal.setTimeInMillis(this.archiveStartTime);
      this.temporaryACLFolder = sdf.format(cal.getTime()) + "/acls";

      this.targetFolder = path;
      this.zos = new ZipOutputStream(os);
      
      processDatabaseSummary();
      processExportParameters(skipList);

      addFolderPath("TemporaryACLFolderLocation",this.temporaryACLFolder);
      
      this.temporaryACLFolder = this.temporaryACLFolder + "/";

      processFolder(targetFolder);
      processWeakLinks();
      printXMLSchemaDependancyList();
      printXMLTableDependancyList();

      this.clearPrintMode(SUPPRESS_CONTENT);
      this.zos.flush();
      this.zos.close();
      this.listFolderContents.close();
      this.checkACLLocation.close();
      this.getACLPaths.close();
      this.lookupVersions.close();
      this.lookupTarget.close();
      this.getExternalReferences.close();

      this.logWriter.flush();
      this.logWriter.println();
      writeLogRecord("Export Completed. Elapsed time = " + this.printElapsedTime(this.archiveStartTime));
    }
    
  public void doRepositoryExport(XMLDocument parameters, OutputStream os) 
  throws Exception {
    Element resourceList   = getFragment(ArchiveManager.INCLUDE_LIST,parameters);
    Element skipList       = getFragment(ArchiveManager.EXCLUDE_LIST,parameters);
    NodeList nl = resourceList.getElementsByTagName(PATH_ELEMENT);
    for (int i=0; i < nl.getLength(); i++) {
      String resourcePath =  ((Element) nl.item(i)).getFirstChild().getNodeValue();
      this.exportFolder(resourcePath,os,skipList);
    }
  }
  
  public void remoteExport(XMLDocument parameters)
  throws Exception {

    String exportFilePath     = getParameterValue(ArchiveManager.ARCHIVE_FILE_PATH,parameters,null);
    this.databaseConnection = (oracle.jdbc.driver.OracleConnection) this.getInternalConnection();  
    try {
      BLOB zipContent = BLOB.createTemporary(this.databaseConnection, true, BLOB.DURATION_SESSION);
      OutputStream os = zipContent.setBinaryStream(1);
      
      doRepositoryExport(parameters,os);
      
      if (zipContent.isOpen()) {
        os.flush();
        os.close();
      }
       
      createResource(exportFilePath,zipContent, ArchiveManager.RAISE_ERROR);
      if (zipContent.isOpen()) {
        zipContent.close();
      }
    }
    catch (Exception e) {
      logError(e);
      e.printStackTrace();
    } 

    this.logWriter.flush();
    this.logWriter.close();
    // writeLog(logWriterPath, logContent, ArchiveManager.RAISE_ERROR);
    if (logContent.isOpen()) {
      logContent.close();
    }
    createResource.close();
  }

   public void localExport(String parameterFilePath) 
  {
    try {
      ExternalConnectionProvider provider = new ExternalConnectionProvider(parameterFilePath);
      XMLDocument parameters = (XMLDocument) provider.getParameterFile();
      this.databaseConnection = this.getExternalConnection(provider,parameters);

      String exportFilePath     = getParameterValue(ArchiveManager.ARCHIVE_FILE_PATH,parameters,null);
      File file = new File(exportFilePath);
      if (file.exists()) {
        file.delete();
      }

    
      FileOutputStream fos = new FileOutputStream(exportFilePath);      
      doRepositoryExport(parameters,fos);
      fos.close();
      logWriter.close();
    }
    catch (Exception e) {
      if (logWriter != null) {
        logWriter.flush();
        logWriter.println();
        e.printStackTrace(logWriter);
        logWriter.flush();
        logWriter.close();
      }
      else {
        e.printStackTrace(System.out);
      }
    }
  }

  public static void repositoryExport(XMLType parameterSettings) 
  throws Exception {
    XMLDocument parameters = (XMLDocument) parameterSettings.getDocument();
    RepositoryExport processor = new RepositoryExport();      
    processor.remoteExport(parameters);
  }

  public static void main(String[] args) 
  throws Exception {
    
    try {
      RepositoryExport processor = new RepositoryExport();      
      processor.localExport(args[1]);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}
