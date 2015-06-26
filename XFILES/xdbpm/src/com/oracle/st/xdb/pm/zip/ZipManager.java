
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


import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import java.sql.Connection;

import java.sql.SQLException;

import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleResultSet;
import oracle.jdbc.driver.OracleConnection;

import oracle.jdbc.internal.OraclePreparedStatement;

import oracle.sql.BLOB;

import oracle.xdb.XMLType;


import org.w3c.dom.Document;
import org.w3c.dom.Element;

import org.w3c.dom.NodeList;


import org.xml.sax.SAXException;

public class ZipManager extends ArchiveManager {

  private static String RESOURCE_SQL = 
      "select extractValue(res,'/Resource/@Container'), extractValue(res,'/Resource/XMLLob') " +
      "  from resource_view " +
      " where equals_path(res,:1) = 1";

  private static String RESOURCE_LIST_SQL = 
      "select any_path, extractValue(res,'/Resource/XMLLob') " +
      "  from resource_view " +
      " where under_path(res,1,:1) = 1" + 
      "   and existsNode(res,'/Resource[@Container=\"false\"]') = 1";

  private static String RESTRICTED_FOLDER_LIST_SQL = 
      "select any_path" +
      "  from resource_view " +
      " where under_path(res,1,:1) = 1" + 
      "   and existsNode(res,'/Resource[@Container=\"true\"]') = 1";

  private static String UNRESTRICTED_FOLDER_LIST_SQL = 
      "select any_path" +
      "  from resource_view " +
      " where under_path(res,:1) = 1" + 
      "   and existsNode(res,'/Resource[@Container=\"true\"]') = 1";
  
  private String parentFolderPath;
  
  ZipOutputStream zos; 
      
  public static void zip(XMLType parameterSettings)
  throws Exception {
    Document parameters = parameterSettings.getDocument();
    String zipFilePath    = getParameterValue(ArchiveManager.ARCHIVE_FILE_PATH,parameters,null);
    String logFilePath    = getParameterValue(ArchiveManager.LOG_FILE_PATH,parameters,null);
    Element resourceList  = getFragment(ArchiveManager.RESOURCE_LIST,parameters);
    boolean isRecursive   = getBooleanValue(ArchiveManager.RECURSIVE_OPERATION,parameters,Boolean.FALSE.toString());

    ZipManager zipManager = new ZipManager();
    zipManager.doZip(zipFilePath,logFilePath,resourceList,isRecursive);
  }

  public static void unzip(XMLType parameterSettings) 
  throws Exception {
    Document parameters = parameterSettings.getDocument();
    String zipFilePath     = getParameterValue(ArchiveManager.ARCHIVE_FILE_PATH,parameters,null);
    String logFilePath     = getParameterValue(ArchiveManager.LOG_FILE_PATH,parameters,null);
    String targetFolder    = getParameterValue(ArchiveManager.TARGET_FOLDER_PATH,parameters,null);
    String duplicatePolicy = getParameterValue(ArchiveManager.DUPLICATE_POLICY,parameters,null);
    ZipManager zipManager = new ZipManager();
    zipManager.doUnzip(zipFilePath,logFilePath,targetFolder,duplicatePolicy);
  }

  public static void unzip(String zipFilePath, String logFilePath, String targetFolder,String duplicateAction) 
  throws Exception {
    ZipManager zipManager = new ZipManager();
    zipManager.doUnzip(zipFilePath,logFilePath,targetFolder,duplicateAction);
  }


  public ZipManager() {
  }
    
  private void setParentFolderPath(String zipFilePath) {
      this.parentFolderPath = zipFilePath.substring(0,zipFilePath.lastIndexOf('/'));
  }
  
  
  private String getRelativePath(String resourcePath) {
      return resourcePath.substring(this.parentFolderPath.length() + 1);
  }
  
  private String getParentFolderPath() {
    return parentFolderPath;
  }
                  
  private void zipResource(ZipOutputStream zos, String resourcePath, BLOB content)
  throws SQLException, IOException {
    
    System.out.println(getRelativePath(resourcePath));
    ZipEntry zipEntry = new ZipEntry(getRelativePath(resourcePath));
    zos.putNextEntry(zipEntry);
    InputStream is = content.getBinaryStream();
    byte[] buffer = new byte[BLOB.MAX_CHUNK_SIZE];
    int n;
    while (-1 != (n = is.read(buffer, 0, buffer.length))) {
      zos.write(buffer, 0, n);
    }
    zos.flush();
    zos.closeEntry();
    if (content.isOpen()) {
      content.close();
    }
  }

  private void zipFolder(ZipOutputStream zos, String resourcePath, OraclePreparedStatement getResourceList) 
  throws SQLException, IOException {
    
    ZipEntry zipEntry = new ZipEntry(getRelativePath(resourcePath) + "/");
    zos.putNextEntry(zipEntry);
    zos.closeEntry();      
  
    OracleResultSet rs = (OracleResultSet) getResourceList.executeQuery();
    while (rs.next()) {
      zipResource(zos,rs.getString(1),rs.getBLOB(2));  
    }
  }
  private void doZip(String zipFilePath, String logFilePath, Element resourceList, boolean isRecursive) 
  throws SQLException, IOException {
      
    setParentFolderPath(zipFilePath);

    OracleConnection connection = getInternalConnection();  
    OraclePreparedStatement getResource;
    OraclePreparedStatement getResourceList;
    OraclePreparedStatement getSubFolderList;

    getResource = (OraclePreparedStatement) connection.prepareStatement(RESOURCE_SQL);
    getResourceList = (OraclePreparedStatement) connection.prepareStatement(RESOURCE_LIST_SQL);        

    if (isRecursive) {
      getSubFolderList = (OraclePreparedStatement) connection.prepareStatement(UNRESTRICTED_FOLDER_LIST_SQL);        
    }
    else {
      getSubFolderList = (OraclePreparedStatement) connection.prepareStatement(RESTRICTED_FOLDER_LIST_SQL);                  
    }

    BLOB zipContent = BLOB.createTemporary(connection, true, BLOB.DURATION_SESSION);
    ZipOutputStream zos = new ZipOutputStream(zipContent.setBinaryStream(1));
    
    try {
      NodeList nl = resourceList.getChildNodes();
      for ( int i=0; i < nl.getLength(); i++) {
        String resourcePath = ((Element) nl.item(i)).getFirstChild().getNodeValue();
        getResource.setString(1,resourcePath);
        OracleResultSet rs = (OracleResultSet) getResource.executeQuery();
        while (rs.next()) {
          boolean isContainer = rs.getString(1).equalsIgnoreCase(Boolean.TRUE.toString());
          if (isContainer) {
            getResourceList.setString(1,resourcePath);
            zipFolder(zos,resourcePath,getResourceList);
            getSubFolderList.setString(1,resourcePath);
            OracleResultSet rs1 = (OracleResultSet) getSubFolderList.executeQuery();
            while (rs1.next()) {
              String subFolderPath = rs1.getString(1);       
              getResourceList.setString(1,subFolderPath);
              zipFolder(zos,subFolderPath,getResourceList);          
            }
          }
          else {
            zipResource(zos,resourcePath,rs.getBLOB(2));
          }
        }
      }
      zos.close();
      createResource(zipFilePath,zipContent, ArchiveManager.RAISE_ERROR);
    }  
    catch (Exception e) {
      logError(e);
      e.printStackTrace();
    }
    this.logWriter.flush();
    this.logWriter.close();
    writeLog(logFilePath,logContent, ArchiveManager.RAISE_ERROR);
    if (logContent.isOpen()) {
      logContent.close();
    }
    createResource.close();
  }
  
  private void mkdir(OracleCallableStatement createFolders,String path) 
  throws SQLException {
    createFolders.setString(1,path);
    createFolders.execute();
  }
  
  private void processInputStream(Connection connection, InputStream is, String targetFolder, String duplicateAction)
  throws SQLException, IOException {
    BLOB newContent = BLOB.createTemporary(connection,true,BLOB.DURATION_SESSION);

    String statementText = "begin xdb_utilities.mkdir(:1,TRUE); end;";
    OracleCallableStatement createDirectory = (OracleCallableStatement) connection.prepareCall(statementText);

    ZipInputStream zis = new ZipInputStream(is);
    ZipEntry zipEntry = null;
    String targetPath;
  
    while (null != (zipEntry = zis.getNextEntry()))
    {
      targetPath = targetFolder + "/" + zipEntry.getName();
      String targetDirectory = targetPath.substring(0,targetPath.lastIndexOf('/'));
      mkdir(createDirectory,targetDirectory);
      if (!zipEntry.isDirectory()) {
        newContent.truncate(0);
        OutputStream os = newContent.setBinaryStream(1);
        byte[] buffer = new byte[BLOB.MAX_CHUNK_SIZE];
        int n;
        while (-1 != (n = zis.read(buffer,0,buffer.length)))
        {
          os.write(buffer,0,n);
        }
        os.flush();
        os.close();
        createResource(targetPath,newContent,duplicateAction);
        zis.closeEntry();
      }
    }
    newContent.freeTemporary();
    createDirectory.close();
  }
   
  private void doUnzip(String zipFilePath, String targetFolder, String logFilePath, String duplicateAction)
  throws SQLException, SAXException, IOException {
    OracleConnection connection = getInternalConnection();
    try {
      String statementText = "select xdburitype(:1).getBlob() from dual";
      OraclePreparedStatement getZipContent = (OraclePreparedStatement) connection.prepareCall(statementText);
      getZipContent.setString(1,zipFilePath);
      OracleResultSet rs = (OracleResultSet) getZipContent.executeQuery();
      while (rs.next()) {
        BLOB zipContent = rs.getBLOB(1);
        processInputStream(connection,zipContent.getBinaryStream(),targetFolder,duplicateAction);
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
    writeLog(logFilePath,logContent, ArchiveManager.RAISE_ERROR);
    if (logContent.isOpen()) {
      logContent.close();
    }
    createResource.close();
  }

}