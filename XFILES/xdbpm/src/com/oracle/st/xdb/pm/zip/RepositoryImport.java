
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
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.sql.SQLException;


import java.util.Enumeration;
import java.util.Hashtable;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleResultSet;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.internal.OraclePreparedStatement;

import oracle.sql.BLOB;
import oracle.sql.CLOB;

import oracle.xdb.XMLType;

import oracle.xml.parser.v2.DOMParser;
import oracle.xml.parser.v2.XMLDocument;
import oracle.xml.parser.v2.XMLElement;
import oracle.xml.parser.v2.XMLParseException;

import org.w3c.dom.Document;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import org.xml.sax.SAXException;
public class RepositoryImport extends ArchiveManager
{
  public static boolean DEBUG = false;
  public static final String ERROR_FILE_PATH       = "ErrorFileName";

  private static final String GET_LOB_LOCATOR = 
  "begin " + 
  "  :1 := xdb_import_utilities.getLOBLocator(P_RESOURCE_PATH => :2 );" +
  "end;";

  private static final String IMPORT_RESOURCE = 
  "begin " + 
  "  :1 := xdb_import_utilities.importResource(" +
  "                               P_RESOURCE_PATH      => :2,    " +
  "                               P_RESOURCE_TEXT      => :3  " + 
  "                              ); " +
  "end;";

  private static final String IMPORT_FOLDER = 
  "begin" +
  "  :1 := xdb_import_utilities.importFolder(:2);" +
  "end;";
  
  private static final String IMPORT_LINK = 
  "begin" +
  "  :1 := xdb_import_utilities.importLink(:2); " + 
  "end;";


    private static final String SET_DUPLICATE_POLICY = 
    "begin" +
    "  xdb_import_utilities.setDuplicatePolicy(:1);" +
    "end;";
    
  private static final String LINK_EXISTING_RESOURCE = 
  "begin " +
  "  DBMS_XDB.LINK(:1,:2,:3,DBMS_XDB.LINK_TYPE_HARD);" +
  "end;";
  
  public static final String MATCH_PATH = 
  "begin " + 
  " :1 := XDB_IMPORT_UTILITIES.matchPath(XMLType(:2)); " + 
  "end;"; 

  public static final String PATCH_XML_REFERENCE = 
  "begin " + 
  " :1 := XDB_IMPORT_UTILITIES.patchXMLReference(:2,:3); " + 
  "end;"; 

  public static final String START_IMPORT = 
  "begin " +
  "  XDB_IMPORT_UTILITIES.startImport(:1,:2);" +
  "end;";
  
  public static final String RESET_ACL_FOLDER = 
  "begin " +
  "  XDB_IMPORT_UTILITIES.resetAclFolder(:1);" +
  "end;";

  public static final String REMOVE_ACL_FOLDER = 
  "begin " +
  "  XDB_IMPORT_UTILITIES.removeAclFolder(:1);" +
  "end;";
  
  public static final int CREATE_RESOURCE = 1;
  public static final int UPDATE_RESOURCE = 2;
  public static final int VERSION_RESOURCE = 3;
  public static final int UNCHANGED_RESOURCE = 4;
  
    
  private XMLDocument exportParameters;
  private String temporaryAclFolder;
  private ZipInputStream zis;

  private CLOB clob = null;
  private String resourceID;
  
  private OracleCallableStatement importResource;
  private OracleCallableStatement importFolder;
  private OracleCallableStatement importLink;
  private OracleCallableStatement getLOBLocator;
  private OracleCallableStatement matchPath;
  private OracleCallableStatement linkExistingResource;
  private OracleCallableStatement patchXMLReference;
  
  private Hashtable invalidLinkList = new Hashtable();

  private Hashtable badResourceList = new Hashtable();

  private PrintWriter errorLog;

  private CLOB readXMLDocument() 
  throws IOException, SQLException, SAXException {

    Reader reader = new InputStreamReader(this.zis);
    return this.readXMLDocument(reader);
  }
    
    private CLOB readXMLDocument(Reader reader) 
    throws IOException, SQLException, SAXException {

      this.clob.truncate(0);
      Writer writer = this.clob.setCharacterStream(1);
      int n;
      char[] buffer = new char[CLOB.MAX_CHUNK_SIZE];
      while (-1 != (n = reader.read(buffer))) {
        writer.write(buffer,0,n); 
      }
      writer.flush();  
      return this.clob;
    }


    private void readExportParameters() 
    throws XMLParseException, SAXException, IOException, SQLException {
      this.clob = readXMLDocument();
      DOMParser parser = new DOMParser();
      parser.parse(this.clob.getCharacterStream());
      this.exportParameters = parser.getDocument();
      
      NodeList nl = this.exportParameters.getElementsByTagName(ArchiveManager.TEMPORARY_ACL_FOLDER);
      XMLElement e = (XMLElement) nl.item(0);
      this.temporaryAclFolder =  this.targetFolder + "/" + e.getFirstChild().getNodeValue();
      
      OraclePreparedStatement statement = (OraclePreparedStatement)  this.databaseConnection.prepareStatement(RESET_ACL_FOLDER);
      statement.setString(1,this.temporaryAclFolder);
      statement.execute();
      statement.close();

    }                                          

    private void processAbsolutePath(String path) 
    throws IOException, SQLException  {
      // Processing an "Absolute" path. Read the "Path" entry. Create a link between the existing resource
      // and the path specified in the Path Entry. Skip the "Resource" entry for this item.

      this.zis.closeEntry();

      ZipEntry pathEntry = this.zis.getNextEntry();
      String targetPath = getResourcePath();

      this.linkExistingResource.setString(1,path);
      this.linkExistingResource.setString(2,targetPath.substring(0,targetPath.lastIndexOf("/")));
      this.linkExistingResource.setString(3,targetPath.substring(targetPath.lastIndexOf("/")+1));
      this.linkExistingResource.execute();

      writeLogRecord("[" + pathEntry.getName().substring(0,pathEntry.getName().lastIndexOf(".")) + "] : Linked \"" + path + "\" to \"" + targetPath + "\".");
      
      this.zis.closeEntry();
      ZipEntry resEntry = this.zis.getNextEntry();
      
    }

  private void processMatchingPath(String resourcePath) 
  throws IOException, SQLException  {
    if (resourcePath == null) {
      // Normal processing of the Archive will restore the ACL to the temporary ACL folder.
      // At the end of the import operation an entry will be created under /sys/acls for this ACL
      // as part of the clean up of the temporary ACL folder.
      return;
    }
    if (resourcePath.startsWith("/")) {
      processAbsolutePath(resourcePath);
      return;
    }
    // ACL's true location in the folder heirarchy will be restored as part of the import.
    // Normal processing of the Archive will restore the ACL to the temporary ACL folder and 
    // and then restore it's proper location in the folder heirarchy.
    // TODO : Partial Import.
  }

    
    private String matchPath(String entryName) 
    throws IOException, SQLException, SAXException {

      writeLogRecord("[" + entryName.substring(0,entryName.lastIndexOf(".")) + "] :");

      this.clob = readXMLDocument();
      String targetPath;
      this.matchPath.registerOutParameter(1,OracleTypes.VARCHAR);
      this.matchPath.setCLOB(2,this.clob);
      this.matchPath.execute();

      targetPath = matchPath.getString(1);
      this.logWriter.print(" Matched Path = \"" + targetPath + "\". ");
      return targetPath;
    }
    
    private String getResourcePath()
    throws IOException {
        byte[] byteBuffer = new byte[4000];
        int bytesRead = this.zis.read(byteBuffer,0,byteBuffer.length);
        String resourcePath = new String(byteBuffer,0,bytesRead);
        if (!resourcePath.startsWith("/")) {
          resourcePath = targetFolder + resourcePath;
        }
        return resourcePath;
    }
    
    private void importFolder(String targetFolder)  
    throws IOException, SQLException
    {
      // Folders are created when a zipEntry is name ends in ".dir" 
      // The Entry contains the relative path of the folder to be created

      int result;
      this.resourceStartTime = System.currentTimeMillis();
      writeLogRecord("[" + this.resourceID + "] : \"" + targetFolder + "\". ");


      this.importFolder.registerOutParameter(1,OracleTypes.NUMBER);
      this.importFolder.setString(2,targetFolder);
      this.importFolder.execute();

      result = (int) this.importFolder.getNUMBER(1).intValue();
      switch (result) {
        case RepositoryImport.CREATE_RESOURCE :
          this.logWriter.print("Folder Created.");        
          break;
        case RepositoryImport.UNCHANGED_RESOURCE :
          this.logWriter.print("Folder Skipped.");        
          break;
        default :
          this.logWriter.print("Unexpected return code (" + result + ").");        
      }
      this.logWriter.print(" Elapsed time = " + this.printElapsedTime(this.resourceStartTime));
    }
    
  private void processXMLReference(String resourcePath)  
  throws IOException, SQLException, XMLParseException, SAXException 
  {
      
    this.clob = readXMLDocument();
      
    try 
    {
      writeLogRecord("[" + this.resourceID + "] : \"" + resourcePath + "\".");
      this.patchXMLReference.registerOutParameter(1,OracleTypes.NUMBER);
      this.patchXMLReference.setString(2,resourcePath);
      this.patchXMLReference.setCLOB(3,this.clob);
      this.patchXMLReference.execute();

      int result = (int) this.patchXMLReference.getNUMBER(1).intValue();

      switch (result) {
         case 0 :
           this.logWriter.print(" Created Link to existing resource. Elapsed time = " + this.printElapsedTime(this.resourceStartTime));
           this.databaseConnection.commit();
           break;
         case 1 :
           this.logWriter.print(" Restored XML Reference. Elapsed time = " + this.printElapsedTime(this.resourceStartTime));
           this.databaseConnection.commit();
           break;
         case 2 :
           this.logWriter.print(" Target XML Table not present in database. Elapsed time = " + this.printElapsedTime(this.resourceStartTime));
           this.databaseConnection.rollback();
           break;
         case 3 :
           this.logWriter.print(" Target XML content not present in database. Elapsed time = " + this.printElapsedTime(this.resourceStartTime));
           this.databaseConnection.rollback();
           break;
        }
    }
    catch (SQLException sqle) {
      if (sqle.getErrorCode() == 31001) {
        this.logWriter.print(" Link Deferred.");        
        char[] buffer = new char[CLOB.MAX_CHUNK_SIZE];
        int n;
        StringWriter sw = new StringWriter();
        Reader reader = this.clob.getCharacterStream();
        buffer = new char[CLOB.MAX_CHUNK_SIZE];
        while (-1 != (n = reader.read(buffer))) {
          sw.write(buffer,0,n); 
        }
        sw.flush();
        StringBuffer link = sw.getBuffer();
        this.invalidLinkList.put(resourcePath,link);
      }
      else {
        this.logWriter.print(" Unexpected Error.");        
        char[] buffer = new char[CLOB.MAX_CHUNK_SIZE];
        int n;

        Reader reader = this.clob.getCharacterStream();
        this.logWriter.println();
        this.logWriter.flush();                              
        // writer = new OutputStreamWriter(System.out);
        buffer = new char[CLOB.MAX_CHUNK_SIZE];
        while (-1 != (n = reader.read(buffer))) {
          this.logWriter.write(buffer,0,n); 
        }
        this.logWriter.flush();                              
        sqle.printStackTrace(this.logWriter);
        throw sqle;
      }
    }
    this.clob.truncate(0);
  }

    private void importLink( String resourcePath)  
    throws IOException, SQLException, XMLParseException, SAXException {

      // Folders are created when a zipEntry is name ends in ".dir" 
      // The Entry contains the relative path of the folder to be created

      Reader reader = new InputStreamReader(this.zis);
      importLink(resourcePath,reader);
    }

  private void importLink(String resourcePath, Reader reader)  
  throws IOException, SQLException, XMLParseException, SAXException 
  {
      
    this.clob = readXMLDocument(reader);
      
    try 
    {
      writeLogRecord("[" + this.resourceID + "] : \"" + resourcePath + "\".");        

      this.importLink.registerOutParameter(1,OracleTypes.NUMBER);
      this.importLink.setCLOB(2,this.clob);
      this.importLink.execute();

      int result = (int) this.importLink.getNUMBER(1).intValue();
      
      switch (result) {
        case RepositoryImport.CREATE_RESOURCE :
          this.logWriter.print(" Link Created.");
          break;
        case RepositoryImport.UPDATE_RESOURCE :
          this.logWriter.print(" Link Updated.");
          break;
        case RepositoryImport.UNCHANGED_RESOURCE :
          this.logWriter.print(" Link Unchanged.");
          break;
        default :
           this.logWriter.print(" Unexpected return code (" + result + ").");        
      }
      this.databaseConnection.commit();
      this.logWriter.print(" Elapsed time = " + this.printElapsedTime(this.resourceStartTime));
    }
    catch (SQLException sqle) {
      if (sqle.getErrorCode() == 31001) {
        char[] buffer = new char[CLOB.MAX_CHUNK_SIZE];
        int n;
        this.logWriter.print(" Link Deferred.");        
        StringWriter sw = new StringWriter();
        reader = this.clob.getCharacterStream();
        buffer = new char[CLOB.MAX_CHUNK_SIZE];
        while (-1 != (n = reader.read(buffer))) {
          sw.write(buffer,0,n); 
        }
        sw.flush();
        StringBuffer link = sw.getBuffer();
        this.invalidLinkList.put(resourcePath,link);
      }
      else {
        this.logWriter.print(" Unexpected Error.");        
        char[] buffer = new char[CLOB.MAX_CHUNK_SIZE];
        int n;

        reader = this.clob.getCharacterStream();
        this.logWriter.println();
        this.logWriter.flush();                              
        // writer = new OutputStreamWriter(System.out);
        buffer = new char[CLOB.MAX_CHUNK_SIZE];
        while (-1 != (n = reader.read(buffer))) {
          this.logWriter.write(buffer,0,n); 
        }
        this.logWriter.flush();                              
        sqle.printStackTrace(this.logWriter);
        throw sqle;
      }
    }
    this.clob.truncate(0);
  }

    private void processContent(String resourcePath)
    throws SQLException, IOException
    {
       int n;     
       long bytesWritten = 0;
       byte[] buffer = new byte[BLOB.MAX_CHUNK_SIZE * 1024];

       writeLogRecord("[" + this.resourceID + "] : \"" + resourcePath + "\". ");  

       this.getLOBLocator.registerOutParameter(1,OracleTypes.BLOB);
       this.getLOBLocator.setString(2,resourcePath);
       this.getLOBLocator.execute();

       BLOB content = this.getLOBLocator.getBLOB(1);

       content.truncate(0);
       OutputStream os = content.setBinaryStream(0);

       long bytesRead = 0;
       long chunkStartTime = System.currentTimeMillis();

       while (-1 != (n = this.zis.read(buffer))) {
         os.write(buffer,0,n);
         bytesRead = bytesRead + n;
         bytesWritten = bytesWritten + n;
         if ((System.currentTimeMillis() - chunkStartTime) > 30000) {
           logWriter.print("Bytes read : " + bytesRead + ". Bytes written : " + bytesWritten + ". Elapsed time = " + this.printElapsedTime(chunkStartTime,bytesRead));
           writeLogRecord("[" + this.resourceID + "] : \"" + resourcePath + "\". ");  
           chunkStartTime = System.currentTimeMillis();
           bytesRead = 0;
         }
       }         
       os.flush();
       os.close();
       this.logWriter.print("Content Loaded. Size="  + bytesWritten + " bytes. Elapsed Time=" + this.printElapsedTime(this.resourceStartTime,bytesWritten));
       this.databaseConnection.commit();
    }
    
    private int importResource(String resourcePath)
    throws SQLException, IOException
    {
    	  int result = -1;
        int n;
        char[] buffer = new char[CLOB.MAX_CHUNK_SIZE];
 
        this.clob.truncate(0);
        Reader reader = new InputStreamReader(zis);
        Writer writer = this.clob.setCharacterStream(1);

        while (-1 != (n = reader.read(buffer))) 
        {
          writer.write(buffer,0,n); 
        }
        writer.flush();              
        
        try 
        {
           writeLogRecord("[" + this.resourceID + "] : \"" + resourcePath + "\".");
 
           this.importResource.registerOutParameter(1,OracleTypes.NUMBER);
           this.importResource.setString(2,resourcePath);
           this.importResource.setCLOB(3,this.clob);
           this.importResource.execute();
 
 					 result = (int) this.importResource.getNUMBER(1).intValue();
           this.clob.truncate(0);
 
           switch (result) {
             case RepositoryImport.CREATE_RESOURCE :
               this.logWriter.print(" Resource Created.");
               break;
             case RepositoryImport.UPDATE_RESOURCE :
               this.logWriter.print(" Resource Updated.");
               break;
             case RepositoryImport.VERSION_RESOURCE :
               this.logWriter.print(" Resource Versioned.");
               break;
             case RepositoryImport.UNCHANGED_RESOURCE :
               this.logWriter.print(" Resource Skipped.");
               break;
             default :
                this.logWriter.print("Unexpected return code (" + result + ").");        
          }
          this.logWriter.print(" Elapsed Time=" + this.printElapsedTime(this.resourceStartTime));

        }
        catch (SQLException sqle) 
        {
            errorLog.write("[" + this.resourceID + "] : \"" + resourcePath + "\". " + sqle.getLocalizedMessage());
            reader = clob.getCharacterStream();
            this.errorLog.println();
            // writer = new OutputStreamWriter(System.out);
            buffer = new char[CLOB.MAX_CHUNK_SIZE];
            while (-1 != (n = reader.read(buffer))) 
            {
              this.errorLog.write(buffer,0,n); 
            }
            sqle.printStackTrace(this.errorLog);
            this.errorLog.flush();                              
            throw sqle;
        }
        
        return result;
    }
    
    private void reportInvalidLinks() {
        Enumeration keys = invalidLinkList.keys();
        while (keys.hasMoreElements()) {
            String resourcePath = (String) keys.nextElement();
            StringBuffer link = (StringBuffer) invalidLinkList.remove(resourcePath);
            writeLogRecord("Importer.invalidLink() Unable to recreate link : " + resourcePath);        
            this.logWriter.println();
            this.logWriter.println(new String(link));
        }
    }
    
    private void processDeferredLinks() 
    throws IOException, SQLException, XMLParseException, SAXException 
    {
        writeLogRecord("Importer.processDeferredLinks() : Processing deferred links");        
        // Recurse over invalid links until all invalid links are gone or none of the remaining once
        // can be created.
        int invalidLinkCount = -1;
        this.resourceID = null;
        while (invalidLinkCount != invalidLinkList.size()) {
          invalidLinkCount = invalidLinkList.size();
          Enumeration keys = invalidLinkList.keys();
            while (keys.hasMoreElements()) {
                String resourcePath = (String) keys.nextElement();
                StringBuffer linkDefinition = (StringBuffer) invalidLinkList.remove(resourcePath);
                StringReader reader = new StringReader(new String(linkDefinition));
                importLink(resourcePath,reader);
            }
        }
        if (invalidLinkList.size() > 0) {
            Enumeration keys = invalidLinkList.keys();
            while (keys.hasMoreElements()) {
              String resourcePath = (String) keys.nextElement();
              writeLogRecord("Importer.processDeferredLinks() : Failed to recreate link " + resourcePath);        
              StringBuffer link = (StringBuffer) invalidLinkList.remove(resourcePath);
              StringReader reader = new StringReader(new String(link));
              importLink(resourcePath,reader);
              this.logWriter.println();
              this.logWriter.flush();                              
              char[] buffer = new char[CLOB.MAX_CHUNK_SIZE];
              int n;
              while (-1 != (n = reader.read(buffer))) {
                 this.logWriter.write(buffer,0,n); 
              }
              this.logWriter.flush();                              
           }
        }
    }
    
    private void importArchive()
    throws SQLException, IOException, XMLParseException, SAXException
    {

       this.importFolder = (OracleCallableStatement) this.databaseConnection.prepareCall(IMPORT_FOLDER);
       this.importLink = (OracleCallableStatement) this.databaseConnection.prepareCall(IMPORT_LINK);
       this.importResource = (OracleCallableStatement) this.databaseConnection.prepareCall(IMPORT_RESOURCE);
       this.getLOBLocator = (OracleCallableStatement) this.databaseConnection.prepareCall(GET_LOB_LOCATOR);
       this.matchPath = (OracleCallableStatement) this.databaseConnection.prepareCall(MATCH_PATH);
       this.linkExistingResource = (OracleCallableStatement) this.databaseConnection.prepareCall(LINK_EXISTING_RESOURCE);
       this.patchXMLReference = (OracleCallableStatement) this.databaseConnection.prepareCall(PATCH_XML_REFERENCE);
             
       this.clob = CLOB.createTemporary(this.databaseConnection,true,CLOB.DURATION_SESSION);

       ZipEntry zipEntry = null;      
       boolean skipContent = false;
       String currentResourcePath = null;
      
       // exportParameters.xml
       zipEntry = this.zis.getNextEntry();
       this.zis.closeEntry();
       
       
       zipEntry = this.zis.getNextEntry();
       readExportParameters();
       this.zis.closeEntry();
      
       String badResourceID = null;
       
       while (null != (zipEntry = this.zis.getNextEntry()))  {
         try {
            this.logWriter.flush();
            this.resourceStartTime = System.currentTimeMillis();
         
            String zipEntryName = zipEntry.getName();  
         
            if (zipEntryName.equals("schemaList.xml")) {
              zis.closeEntry();
              continue;
            }
         
            if (zipEntryName.equals("tableList.xml")) {
              zis.closeEntry();
              continue;
            }

            this.resourceID = zipEntryName.substring(0,zipEntryName.indexOf("."));
           
           if (this.resourceID.equals(badResourceID)) {
             writeLogRecord("[" + this.resourceID + "] : \"" + currentResourcePath + "\". Skipping " + zipEntryName);
             zis.closeEntry();
             continue;             
           }
           
            if (zipEntryName.endsWith(".pathList")) {
              currentResourcePath = matchPath(zipEntryName);
              processMatchingPath(currentResourcePath);
            }
         
            if (zipEntryName.endsWith(".dir")) {
              // If the folder does not exist use XDB_UTILITIES.mkdir to create the folder and any parent folders;
              // The Resource Document(s) that describes the folder will appear after all the resources in the folder.
              // This helps ensure that the target repository reflects the state of the source repository.
              this.resourceStartTime = System.currentTimeMillis();    
              currentResourcePath = getResourcePath();
              importFolder(currentResourcePath);
              this.databaseConnection.commit();
            }

            if (zipEntryName.endsWith(".path")) {
              // .path extension : Get the Path for the Resource from the Zip Entry.
              currentResourcePath = getResourcePath();
            }
         
           if (skipEntry(this.resourceID, currentResourcePath)) {
             if (zipEntryName.endsWith(".res") || zipEntryName.endsWith(".link")) {             
                writeLogRecord("[" + this.resourceID + "] : \"" + currentResourcePath + "\". Filtered by Exclude List.");
             }
             zis.closeEntry();
             continue;
           }

            if (zipEntryName.endsWith(".res")) {
              // .res extension : Create a 'contentless' resource from the Zip Entry.
              int result = importResource(currentResourcePath);
              skipContent = (result == RepositoryImport.UNCHANGED_RESOURCE);
            }

            if (zipEntryName.endsWith(".lob"))  {
              // .lob extension : Add the content to the resource
              if (skipContent) {
                zis.closeEntry();
                continue;
              }
              else {
                processContent(currentResourcePath);
              }
              skipContent = false;                           
            }

            if (zipEntryName.endsWith(".xmlref")) {
             if (skipContent) {
               zis.closeEntry();
               continue;
             }
             else {
               processXMLReference(currentResourcePath);
             }
             skipContent = false;                                      
            }

            if (zipEntryName.endsWith(".link")) {
              importLink(currentResourcePath);
            }

            zis.closeEntry();
         } catch (SQLException sqle ) {
           writeLogRecord("[" + this.resourceID + "] : \"" + currentResourcePath + "\". " + sqle.getLocalizedMessage());
           badResourceID = this.resourceID;
           badResourceList.put(resourceID, currentResourcePath);
           this.databaseConnection.rollback();
           switch (sqle.getErrorCode()) {
            case 31011 :
               // Generic XML Parsing Error
               continue;
             case 31020 : 
               // XML Parsing failed due to external references
               continue;
            default : 
             throw sqle;
           }
         }
       }
       processDeferredLinks();
       
       // this.clob.freeTemporary();

       this.importResource.close();
       this.importFolder.close();
       this.importLink.close();
       this.getLOBLocator.close();
       this.matchPath.close();
       this.linkExistingResource.close();
       this.patchXMLReference.close();              
    }

    public void importArchive(XMLDocument parameters, InputStream is)
    throws IOException, SQLException, XMLParseException, SAXException
    {
      this.databaseConnection.setAutoCommit(false);
      this.archiveStartTime = System.currentTimeMillis();      

      String targetFolderPath  = getParameterValue(ArchiveManager.TARGET_FOLDER_PATH,parameters,null);
      this.targetFolder = targetFolderPath;
      if (!targetFolder.endsWith("/" )) {
        targetFolder = targetFolder + '/';
      }

      this.ignoreFoldersList = new Hashtable();
      this.ignoreFilesList = new Hashtable();
      Element skipList       = getFragment(ArchiveManager.EXCLUDE_LIST,parameters);
      if (skipList != null) {
        processSkipList(skipList);
      }
      
      this.writeLogRecord("Import started for path : " + targetFolderPath);

      String duplicatePolicy  = getParameterValue(ArchiveManager.DUPLICATE_POLICY,parameters,null);

      OracleCallableStatement startImport = (OracleCallableStatement) this.databaseConnection.prepareCall(START_IMPORT);
      startImport.setString(1,duplicatePolicy);
      
      if (targetFolder.equals("/")) {
        startImport.setString(2,"/");        
      }
      else {
        startImport.setString(2,targetFolder.substring(0,targetFolder.length()-1));
      }
      startImport.execute();
      startImport.close();
      
      this.zis = new ZipInputStream(is);
      importArchive();
      this.zis.close();
      
      OraclePreparedStatement statement = (OraclePreparedStatement)  this.databaseConnection.prepareStatement(REMOVE_ACL_FOLDER);
      statement.setString(1,this.temporaryAclFolder);
      statement.execute();
      statement.close();
      
      if (badResourceList.size() > 0) {
        writeLogRecord("Import Failed for the following resources :-");
        Enumeration keys = badResourceList.keys();
        while (keys.hasMoreElements()) {
          String key = (String) keys.nextElement();
          String path = (String) badResourceList.get(key);
          writeLogRecord("[" + key + "] : \"" + path + "\".");
        }
      }

      this.logWriter.flush();
      this.logWriter.println();
      writeLogRecord("Import Completed. Elapsed Time = " + this.printElapsedTime(this.resourceStartTime));
      this.logWriter.flush();
      this.logWriter.close();
      this.errorLog.flush();
      this.errorLog.close();
    }
 
    private boolean skipEntry(String resourceId, String currentResourcePath) {
      if (this.ignoreFilesList.containsKey(currentResourcePath)){
        return true;
      }
      Enumeration keys = this.ignoreFoldersList.keys();
      while (keys.hasMoreElements()) {
        String key = (String) keys.nextElement();
        if (currentResourcePath.indexOf(key) == 0) {
          return true;
        }
      }
      return false;
    }
  public void localImport(String parameterFilePath) 
  {
    try {
      ExternalConnectionProvider provider = new ExternalConnectionProvider(parameterFilePath);
      XMLDocument parameters = (XMLDocument) provider.getParameterFile();
      this.databaseConnection = this.getExternalConnection(provider,parameters);

      String filename = getParameterValue(RepositoryImport.ERROR_FILE_PATH,parameters,"importErrors.log");
      File file = new File(filename);
      if (file.exists()) {
       file.delete();
      }
      this.errorLog =  new PrintWriter(new FileOutputStream(filename));
      
      String exportFilePath     = getParameterValue(ArchiveManager.ARCHIVE_FILE_PATH,parameters,null);    
      FileInputStream fis = new FileInputStream(exportFilePath);      
      importArchive(parameters,fis);
    }
    catch (Exception e) {
      if (errorLog != null) {
        errorLog.flush();
        errorLog.close();
      }
    
      if (logWriter != null) {
        logWriter.flush();
        logWriter.println();
        writeLogRecord("Fatal error while processing Archive File : Error encountered while processing [" + this.resourceID + "].");        
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
  
  private void remoteImport(XMLDocument parameters) 
  throws SQLException, SAXException, IOException {
    targetFolder  = getParameterValue(ArchiveManager.TARGET_FOLDER_PATH,parameters,null);
    String exportFilePath    = getParameterValue(ArchiveManager.ARCHIVE_FILE_PATH,parameters,null);

    try {
      String statementText = "select xdburitype(:1).getBlob() from dual";
      OraclePreparedStatement getZipContent = (OraclePreparedStatement) this.databaseConnection.prepareCall(statementText);
      getZipContent.setString(1,exportFilePath);
      OracleResultSet rs = (OracleResultSet) getZipContent.executeQuery();
      while (rs.next()) {
        BLOB zipContent = rs.getBLOB(1);
        importArchive(parameters,zipContent.getBinaryStream());
        if (zipContent.isOpen()) {
          zipContent.close();
        }
      }
      rs.close();
      getZipContent.close();
    }
    catch (Exception e) {
      logError(e);
      e.printStackTrace();
    }

    this.logWriter.flush();
    this.logWriter.close();
    // writeLog(logFilePath,logContent, ZipManager.RAISE_ERROR);
    if (logContent.isOpen()) {
      logContent.close();
    }
    createResource.close();
  }

  public static void repositoryImport(XMLType parameterSettings) 
  throws Exception {
    Document parameters = parameterSettings.getDocument();
  }
  
  public static void main(String[] args) 
  throws Exception {
    
    try {
      RepositoryImport processor = new RepositoryImport();      
      processor.localImport(args[1]);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}

