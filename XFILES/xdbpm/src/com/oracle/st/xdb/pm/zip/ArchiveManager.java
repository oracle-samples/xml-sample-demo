
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
import java.io.PrintWriter;

import java.sql.DriverManager;
import java.sql.SQLException;

import java.text.SimpleDateFormat;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Hashtable;
import java.util.TimeZone;
import java.util.zip.ZipException;

import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleDriver;
import oracle.jdbc.driver.OracleConnection;

import oracle.sql.BLOB;

import oracle.xml.parser.v2.XMLDocument;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

public class ArchiveManager {

  public static final String ARCHIVE_FILE_PATH   = "ZipFileName";
  public static final String LOG_FILE_PATH       = "LogFileName";
  public static final String TARGET_FOLDER_PATH  = "TargetFolder";
  public static final String RECURSIVE_OPERATION = "RecursiveOperation";

  public static final String RAISE_ERROR  = "RAISE";
  public static final String SKIP         = "SKIP";
  public static final String OVERWRITE    = "OVERWRITE";
  public static final String VERSION      = "VERSION";

  public static final String MODE                = "Mode";

  public static final String RESOURCE_LIST       = "ResourceList";
  public static final String INCLUDE_LIST        = "Include";
  public static final String EXCLUDE_LIST        = "Exclude";
  public static final String SKIP_FOLDER         = "Folder";
  public static final String SKIP_FILE           = "File";
  public static final String SKIP_ACLS           = "ACL";

  public static final String PATH_ELEMENT        = "Path";
  public static final String EXPORT_MODE         = "EXPORT";
  public static final String IMPORT_MODE         = "IMPORT";
  public static final String DUPLICATE_POLICY    = "DuplicateAction";
  
  public static final String TEMPORARY_ACL_FOLDER = "temporaryACLFolder";

  protected long archiveStartTime;
  protected long resourceStartTime;
  protected Calendar logTimestamp = new GregorianCalendar();

  private SimpleDateFormat elapsedTimeFormatter = new SimpleDateFormat("HH:mm:ss:SSS");

  protected BLOB logContent;
  protected PrintWriter logWriter;
  protected oracle.jdbc.OracleConnection databaseConnection;

  // List of Files that are explicitly excluded from the export
  
  protected String targetFolder;

  protected Hashtable ignoreFilesList;

  // List of Folders that are explicitly excluded from the export

  protected Hashtable ignoreFoldersList;
  
  protected OracleCallableStatement createResource;
  protected static String CREATE_RESOURCE_SQL = 
      "begin " +
      "  XDB_IMPORT_UTILITIES.createResource(:1,:2,:3); " +
      "end;";

  public ArchiveManager() {
    super();
    this.elapsedTimeFormatter.setTimeZone(TimeZone.getTimeZone("GMT+0")); 
  }

  protected OracleConnection getInternalConnection() throws SQLException {
     DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
     OracleDriver ora = new OracleDriver();
     OracleConnection connection = (OracleConnection) ora.defaultConnection(); 
     this.createResource = (OracleCallableStatement) connection.prepareCall(ArchiveManager.CREATE_RESOURCE_SQL);
     this.logContent = BLOB.createTemporary(connection, true, BLOB.DURATION_SESSION);
     OutputStream los = logContent.setBinaryStream(1);
     this.logWriter = new PrintWriter(los);
     return connection;
  }
  
  protected OracleConnection getExternalConnection(ExternalConnectionProvider provider, Document parameters) 
  throws Exception {
     String logfilename = getParameterValue(ArchiveManager.LOG_FILE_PATH,parameters,"repository.log");
     File file = new File(logfilename);
     if (file.exists()) {
      file.delete();
     }
     this.logWriter =  new PrintWriter(new FileOutputStream(logfilename));
     provider.setLogger(logWriter);
     OracleConnection connection = (OracleConnection) provider.getConnection();
     return connection;
  }
  protected void logError(Exception e) {
    if (this.logWriter != null) {
      this.logWriter.flush();
      this.logWriter.println();
      e.printStackTrace(logWriter);
      this.logWriter.flush();
      this.logWriter.close();
    }
  }

  public void writeLogRecord(String logMessage) {
      this.logTimestamp.setTimeInMillis(System.currentTimeMillis());
      this.logWriter.println();
      this.logWriter.print(this.logTimestamp.getTime() + " : " + logMessage);
      this.logWriter.flush();
  }

  public void logZipException(String resid,
                              ZipException ze) throws SQLException {
      writeLogRecord("Zip Error occured while processing resource " + resid);
      ze.printStackTrace();
  }

  
  protected void writeLog(String documentPath, BLOB content, String duplicatePolicy) 
  throws SQLException, IOException {
    if (content.getLength() > 0) {
      if (documentPath != null) {
          createResource(documentPath,content,duplicatePolicy);
      }
      else {
        InputStream is = content.getBinaryStream();
        byte[] buffer = new byte[BLOB.MAX_CHUNK_SIZE];
        int n;
        while (-1 != (n = is.read(buffer, 0, buffer.length))) {
          System.out.write(buffer, 0, n);
        }
        System.out.flush();
      }
    }
  }

  protected static String getParameterValue(String parameterName, Document parameters, String defaultValue) 
  throws IOException{
    Element root = parameters.getDocumentElement();
    NodeList nl = root.getElementsByTagName(parameterName);     
    Element parameter = (Element) nl.item(0);
    if (parameter.hasChildNodes()) {
      Text text = (Text) parameter.getFirstChild();
      return text.getNodeValue();
    }
    return defaultValue;
  }

  protected static Element getFragment(String fragmentName, Document parameters) {
    Element root = parameters.getDocumentElement();
    NodeList nl = root.getElementsByTagName(fragmentName);
    return (Element) nl.item(0);
  }

  protected static boolean getBooleanValue(String parameterName, Document parameters, String defaultValue)
  throws IOException{
    return getParameterValue(parameterName,parameters,defaultValue).equalsIgnoreCase(Boolean.TRUE.toString());
  }
  
  protected void createResource(String documentPath, BLOB content, String duplicatePolicy)
  throws SQLException 
  {
    this.createResource.setString(1,documentPath);
    this.createResource.setBLOB(2,content);
    this.createResource.setString(3,duplicatePolicy);
    this.createResource.execute();      
  }    
  
  protected void initializeLocalLogging(XMLDocument parameters) 
  throws IOException {
    String localLogFilePath = getParameterValue(ArchiveManager.ARCHIVE_FILE_PATH,parameters,null);
    File file = new File(localLogFilePath);
    if (file.exists()) {
      file.delete();
    }
    this.logWriter = new PrintWriter(file);
  }

  protected String printElapsedTime(long startTime) {
    return this.printElapsedTime(startTime,-1); 
  }
  
  protected String printElapsedTime(long startTime, long bytes) {
    float MB = 1024*1024;
    float KB = 1024;
    float elapsedTimeSeconds;
    GregorianCalendar cal = new GregorianCalendar();
    long elapsedTime = System.currentTimeMillis() - startTime;
    cal.setTimeInMillis(elapsedTime); 
    String result = this.elapsedTimeFormatter.format(cal.getTime()); 
    if ((elapsedTime > 0) && (bytes > 0)) {
      elapsedTimeSeconds = (float) elapsedTime / 1000;
      float throughput = (float)bytes/elapsedTimeSeconds;
      if (throughput >= MB) {
        result = result + ". [" + (throughput/MB) + " MB/s].";
      }
      else {
        if (throughput >= 1024) {
          result = result + ". [" + (throughput/KB) + " KB/s].";
        }
        else {
          result = result + ". [" + throughput + " B/s].";
        }
      }
    }
    return result;
  }

  protected void processSkipList(Element skipList) {
      NodeList children = skipList.getElementsByTagName(SKIP_FOLDER);
      for (int i = 0; i < children.getLength(); i++) {
          Element element = (Element)children.item(i);
          Text text = (Text)element.getFirstChild();
          if (text != null) {
            String path = text.getData();
            if (path.indexOf('/') != 0) {
              path = targetFolder + path;
            }
            ignoreFoldersList.put(path, path);
          }
      }

      children = skipList.getElementsByTagName(SKIP_FILE);
      for (int i = 0; i < children.getLength(); i++) {
          Element element = (Element)children.item(i);
          Text text = (Text)element.getFirstChild();
          if (text != null) {
            String path = text.getData();
            if (path.indexOf('/') != 0) {
              path = targetFolder + path;
            }
            ignoreFilesList.put(path, path);
          }
      }
  }
}
