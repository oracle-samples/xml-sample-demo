
/* ================================================  
 *    
 * Copyright (c) 2015 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================ 
 */

package com.oracle.st.xmldb.pm.saxLoader;

import com.oracle.st.xmldb.pm.common.baseApp.ApplicationSettings;
import com.oracle.st.xmldb.pm.common.baseApp.ConnectionManager;
import com.oracle.st.xmldb.pm.common.baseApp.LogManager;

import com.oracle.st.xmldb.pm.common.baseApp.PrintStreamLogger;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;

import java.sql.Connection;
import java.sql.SQLException;

import java.text.DecimalFormat;

import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Hashtable;

import java.util.Locale;
import java.util.TimeZone;
import java.util.Vector;

import oracle.xml.binxml.BinXMLException;

import oracle.xml.parser.v2.XMLElement;
import oracle.xml.parser.v2.XMLParseException;

import org.w3c.dom.Document;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import org.xml.sax.SAXException;

public class XMLLoader {
    
    public static final boolean DEBUG = false;

    public static final String XML_NAMESPACE_NAMESPACE       = "http://www.w3.org/2000/xmlns/";
    public static final String XML_SCHEMA_INSTANCE_NAMESPACE = "http://www.w3.org/2001/XMLSchema-instance";

    public static final String SCHEMA_INSTANCE_PREFIX        = "schemaInstancePrefix";
    public static final String SCHEMA_LOCATION               = "schemaLocation";
    public static final String NO_NAMESPACE_SCHEMA_LOCATION  = "noNamespaceSchemaLocation";

    // Maximum Number of Documents to Insert
    public static final String MAX_DOCUMENTS                 = "maxDocumentsToLoad";
    // Maximum Number of Writer Thread Failures Permitted
    public static final String MAX_ERRORS                    = "maxErrors";
    // Maximum Number of SQL Failures before a Writer Thread Aborts. SQL Errors are logged to ERROR_TABLE
    public static final String MAX_SQL_ERRORS                = "maxSQLErrors";
    public static final String MAX_SQL_INSERTS               = "maxSQLInserts";

    public static final String BUFFER_SIZE                   = "bufferSize";

    public static final String LOG_FILE_NAME                 = "LogFileName";

    public static final String THREAD_COUNT_ELEMENT          = "ThreadCount";
    public static final String COMMIT_CHARGE_ELEMENT         = "CommitCharge";

    public static final String ERROR_TABLE_ELEMENT           = "ErrorTable";

    public static final String FILE_LIST_ELEMENT             = "FileList";;
    public static final String FILE_ELEMENT                  = "File";

    public static final String FOLDER_LIST_ELEMENT           = "FolderList";;
    public static final String FOLDER_ELEMENT                = "Folder";

    public static final String TABLE_LIST_ELEMENT            = "Tables";
    public static final String TABLE_ELEMENT                 = "Table";
    public static final String COLUMN_ELEMENT                = "Column";

    public static final String PROCEDURE_LIST_ELEMENT        = "Procedures";
    public static final String PROCEDURE_ELEMENT             = "Procedure";
    public static final String ARGUMENT_ELEMENT              = "Argument";

    public static final String NAMESPACE_DEFINITIONS         = "Namespaces";

    public static final String NAME_ATTRIBUTE                = "name";
    public static final String PATH_ATTRIBUTE                = "path";
    public static final String TYPE_ATTRIBUTE                = "type";
    public static final String XML_SOURCE_TYPE               = "xml";

    public static final String COLUMN_NAME_ATTRIBUTE         = "name";

    public static final String PROCEDURE_NAME_ATTRIBUTE      = "procedure";

    public static final String CLIENT_SIDE_ENCODING_ELEMENT  = "clientSideEncoding";

    public static final String LOG_SERVER_STATS_ELEMENT      = "logServerStats";
    public static final String MODE_ELEMENT                  = "mode";
    
    public static final String CURRENT_FILENAME = "#FILENAME";
    public static final String CURRENT_PATH     = "#PATH";
    public static final String ORDINALITY       = "#ORDINALITY";
    
    protected ConnectionManager connectionManager;
    protected ApplicationSettings settings;
    protected SaxReader saxReader;

    private Element namespaceMappings;
    
    private ArrayList boundaryList = new ArrayList();

    private ArrayList xmlSourceList         = new ArrayList();
    private ArrayList scalarSourceList      = new ArrayList();
    
    private Hashtable tableColumnMappings          = new Hashtable();
    private Hashtable tableColumnXPathMappings     = new Hashtable();
    private Hashtable xpathToTableNameMapping      = new Hashtable();

    private Hashtable procedureArgumentMappings          = new Hashtable();
    private Hashtable procedureArgumentXPathMappings     = new Hashtable();
    private Hashtable xpathToProcedureNameMapping        = new Hashtable();
    
    protected int readCount = 0;
    protected int writeCount = 0;

    protected int dbWriterCount = 0;
    protected int dbWriterAborts = 0;

    private Locale locale = new Locale(Locale.ENGLISH.toString(), "US");
    private static String XML_FORMAT_STRING = "yyyy-MM-dd'T'HH:mm:ss.SSS";
    private SimpleDateFormat sdf = new SimpleDateFormat(XML_FORMAT_STRING);
    
    private Calendar startTime;
    private Calendar endTime;
    
    private Vector writerQueue = new Vector();
    
    private int maxDocuments = 0;
    private int maxErrors = 0;
    private int maxSQLErrors = 0;
    private int maxSQLInserts = 0;
    private int bufferSize = 1;
    private int commitCharge = 1;
    private String errorTable = null;
    private boolean clientSideEncoding = false;
    private boolean logServerStats = false;
    
    public XMLLoader() 
    throws SQLException, IOException, SAXException {
       this.settings = new ApplicationSettings();
       this.setLogger();
       this.connectionManager = new ConnectionManager(settings,this.logger);
    }
    
    protected LogManager logger;

    protected void setLogger()
    throws SQLException, IOException, SAXException {
        String logFile = this.settings.getSetting(LOG_FILE_NAME);
        if (logFile != null) {
           OutputStream os = new FileOutputStream(logFile);
           this.logger = new PrintStreamLogger(new PrintStream(os));
        }
        else {
          this.logger = new PrintStreamLogger();
        }
    }

    protected void log(String string) {
      synchronized(this.logger) {
        this.logger.log(string);
      }
    }
    
    protected void log(Document doc) {
      synchronized(this.logger) {
        this.logger.log(doc);
      }
    }

    protected void log(Exception e) {
      synchronized(this.logger) {
        this.logger.log(e);
      }
    }

    protected void logThread(String message) {
      synchronized(this.logger) {
        this.logger.log(Thread.currentThread().getName() + ". " + message);
      }
    }

    protected void logThread(Document xml) {
      synchronized(this.logger) {
        this.logger.log(Thread.currentThread().getName() + ". Document : " + this.writeCount);
        this.logger.log(xml);
      }
    }

    protected  void logThread(Document xml, Exception e) {
      synchronized(this.logger) {
        this.logThread(e);
        this.logger.log("Current Document :");
        this.logger.log(xml);
      }
    }

    protected void logThread(Exception e) {
      synchronized(this.logger) {
        this.logger.log(Thread.currentThread().getName() + ". Exception : ");
        this.logger.log(e);
      }
    }
    
    protected void logThread(String message, Exception e) {
      synchronized(this.logger) {
        this.logger.log(Thread.currentThread().getName() + ". " + message  + "Exception : ");
        this.logger.log(e);
      }
    }

    private void setStartTime() {
       this.startTime = new GregorianCalendar(this.locale);
    }

    private void setEndTime() {
       this.endTime = new GregorianCalendar(this.locale);
    }

    public String getStartTime()
    {
       return (this.sdf.format(this.startTime.getTime()) + "000").substring(0,23);
    }

    public String getEndTime()
    {
       return (this.sdf.format(this.endTime.getTime()) + "000").substring(0,23);
    }
    
    private int threadCount;

    protected void setWriterCount(int count) {
      this.threadCount = count;
    }
    
    protected int getWriterCount() {
      return this.threadCount;
    }
    
    protected Vector threadPool = new Vector();
    
    protected Object processorStatus = new Object();
    private boolean processingComplete = true;
    
    protected Object parserStatus = new Object();
    private boolean parsingComplete = true;
        
    protected Vector loaderStatistics = new Vector();
    
    protected void writeStatistics()
    throws Exception  {
        SimpleDateFormat elapsedTimeFormatter = new SimpleDateFormat("HH:mm:ss.SSS");
        GregorianCalendar cal = new GregorianCalendar();
        elapsedTimeFormatter.setTimeZone(TimeZone.getTimeZone("GMT+0"));
        long elapsedTime = this.endTime.getTimeInMillis() - this.startTime.getTimeInMillis();
        cal.setTimeInMillis(elapsedTime); 
        String result = elapsedTimeFormatter.format(cal.getTime()); 

        String horizontalBar = "========================================================================================================================================================================================================================";

        String titleBar = "| " 
                        + String.format("%1$-" + 20 + "s","Thread Name")                                   + " |"
                        + String.format("%1$"  + 24 + "s","Start Time")                                    + " |"
                        + String.format("%1$"  + 24 + "s","End Time")                                      + " |" 
                        + String.format("%1$"  + 13 + "s","Elapsed Time")                                  + " |" 
                        + String.format("%1$"  +  8 + "s","Tasks")                                         + " |" 
                        + String.format("%1$"  +  8 + "s","Success")                                       + " |" 
                        + String.format("%1$"  +  8 + "s","Failed")                                        + " |" 
                        + String.format("%1$"  +  8 + "s","Docs/sec")                                      + " |" 
                        + String.format("%1$"  + 14 + "s","Bytes Read")                                    + " |" 
                        + String.format("%1$"  + 14 + "s","Bytes Sent")                                    + " |" 
                        + String.format("%1$"  + 14 + "s","Bytes Rcvd")                                    + " |" 
                        + String.format("%1$"  +  8 + "s","R/Trips")                                       + " |" 
                        + String.format("%1$"  + 12 + "s","DB CPU")                                        + " |" 
                        + String.format("%1$"  + 12 + "s","Client CPU")                                    + " |";
        
        this.log(horizontalBar);
        this.log(titleBar);
        this.log(horizontalBar);
        synchronized(logger) {
          while (this.loaderStatistics.size() > 0) {
            WriterStatistics stats = (WriterStatistics) this.loaderStatistics.remove(0);
            stats.printStats(logger);
            this.writeCount = this.writeCount + stats.getSuccessCount();
          }
        }
        this.log(horizontalBar);   
        
        DecimalFormat df = (DecimalFormat) DecimalFormat.getInstance();
        df.applyPattern("###,###,##0");
        double throughput  = ((double) this.writeCount/elapsedTime) * 1000;   
        
        this.log("Processing Complete : Start Time           = " + this.getStartTime()); 
        this.log("                      End Time             = " + this.getEndTime());
        this.log("                      Elapsed Time         = " + result); 
        this.log("                      Total Documents Read = " + this.readCount);
        this.log("                      Documents Written    = " + this.writeCount);
        this.log("                      Throughput           = " + df.format(throughput) + " docs/sec");
        this.log("                      Threads Started      = " + this.dbWriterCount);
        this.log("                      Threads Aborted      = " + this.dbWriterAborts);
    }

    protected void recordStatistics(WriterStatistics stats)
    {
      synchronized(loaderStatistics) {
         this.loaderStatistics.addElement(stats);
         this.loaderStatistics.notify();
      }
    }  
    
    public void processProcedureMappings(Element procedureList) throws IOException, SAXException {

        if (procedureList != null && procedureList.hasChildNodes()) {
            NodeList nlProcedure = procedureList.getElementsByTagName(XMLLoader.PROCEDURE_ELEMENT);
            for (int i = 0; i < nlProcedure.getLength(); i++) {
                String argumentList = null;
                Element procedure = (Element) nlProcedure.item(i);
                String procedureName = procedure.getAttributeNS("", XMLLoader.NAME_ATTRIBUTE);
                String source = procedure.getAttributeNS("", XMLLoader.PATH_ATTRIBUTE);
                if (!this.boundaryList.contains(source)) {
                  this.boundaryList.add(source);
                }                    
                this.xpathToProcedureNameMapping.put(source,procedureName);
                Hashtable argumentXPathMappings = new Hashtable();
                NodeList nlArgument = procedure.getElementsByTagName(XMLLoader.ARGUMENT_ELEMENT);
                for (int j = 0; j < nlArgument.getLength(); j++) {
                  Element argument = (Element) nlArgument.item(j);
                  String argumentName = argument.getAttributeNS("", XMLLoader.NAME_ATTRIBUTE);
                  String argumentType = argument.getAttributeNS("", XMLLoader.TYPE_ATTRIBUTE);
                  source              = argument.getAttributeNS("", XMLLoader.PATH_ATTRIBUTE);
                  argumentXPathMappings.put(argumentName,source);
                  if (argumentList == null) {
                    argumentList = "\"" + argumentName + "\"";
                  }
                  else {
                    argumentList = argumentList + "," + "\"" + argumentList + "\"";
                  }
                  this.log("SaxProcessor : Procedure \"" + procedureName + "\" Argument \"" + argumentName + "\". Source = \"" + source + "\". Type = " + argumentType + ".");
                  if (argumentType.equalsIgnoreCase(XMLLoader.XML_SOURCE_TYPE)) {
                    if (!this.xmlSourceList.contains(source)) {
                      this.xmlSourceList.add(source);
                    }
                  }
                  else {
                    if (!this.scalarSourceList.contains(source)) {
                      this.scalarSourceList.add(source);
                    }                        
                  }
                }
                this.procedureArgumentMappings.put(procedureName,argumentList);
                this.procedureArgumentXPathMappings.put(procedureName,argumentXPathMappings);
            }
        }
    }
    
    public String stripNamespacePrefixes(String source) {
        while (source.indexOf(':') > 0) {
            String lhs = source.substring(0,source.indexOf(':')-1);
            String rhs = source.substring(source.indexOf(':')+1);
            source = lhs.substring(0,lhs.lastIndexOf('/')+1) + rhs;
        }
        return source;
    }
    
    public void processTableMappings(Element tableList) throws IOException, SAXException {

        if (tableList != null && tableList.hasChildNodes()) {
            NodeList nlTable = tableList.getElementsByTagName(XMLLoader.TABLE_ELEMENT);
            for (int i = 0; i < nlTable.getLength(); i++) {
                String columnList = null;
                Element table = (Element) nlTable.item(i);
                String tableName = table.getAttributeNS("", XMLLoader.NAME_ATTRIBUTE);
                String source = table.getAttributeNS("", XMLLoader.PATH_ATTRIBUTE);
                // source = stripNamespacePrefixes(source);
                if (!this.boundaryList.contains(source)) {
                  this.boundaryList.add(source);
                }                    
                this.xpathToTableNameMapping.put(source,tableName);
                Hashtable columnXPathMappings = new Hashtable();
                if (table.hasChildNodes()) {
                    NodeList nlColumn = table.getElementsByTagName(XMLLoader.COLUMN_ELEMENT);
                    for (int j = 0; j < nlColumn.getLength(); j++) {
                      Element column = (Element) nlColumn.item(j);
                      String columnName = column.getAttributeNS("", XMLLoader.NAME_ATTRIBUTE);
                      String columnType = column.getAttributeNS("", XMLLoader.TYPE_ATTRIBUTE);
                      source            = column.getAttributeNS("", XMLLoader.PATH_ATTRIBUTE);
                      columnXPathMappings.put(columnName,source);
                      if (columnList == null) {
                        columnList = "\"" + columnName + "\"";
                      }
                      else {
                        columnList = columnList + "," + "\"" + columnName + "\"";
                      }
                      this.log("SaxProcessor : Table \"" + tableName + "\" Column \"" + columnName + "\". Source = \"" + source + "\". Type = " + columnType + ".");
                      if (columnType.equalsIgnoreCase(XMLLoader.XML_SOURCE_TYPE)) {
                        if (!this.xmlSourceList.contains(source)) {
                          this.xmlSourceList.add(source);
                        }
                      }
                      else {
                        if (!this.scalarSourceList.contains(source)) {
                          this.scalarSourceList.add(source);
                        }                        
                      }
                    }
                }
                else {
                  columnList = "OBJECT_VALUE";
                  columnXPathMappings.put(columnList,source);
                  this.log("SaxProcessor : XMLType Table \"" + tableName + "\". Source = \"" + source + "\".");
                  if (!this.xmlSourceList.contains(source)) {
                    this.xmlSourceList.add(source);
                  }                    
                }
                this.tableColumnMappings.put(tableName,columnList);
                this.tableColumnXPathMappings.put(tableName,columnXPathMappings);
            }
        }
    }
    
    protected Element processNamespacePrefixMappings() {
        Element mappings = this.settings.getElement(NAMESPACE_DEFINITIONS);
        if (mappings == null) {
          mappings = this.settings.getParameterDocument().createElement(NAMESPACE_DEFINITIONS);
        }
        return mappings;         
    }
    
    protected SaxReader createSaxReader() 
    throws SAXException, IOException {
       String threadName = "SaxReader";
       SaxReader saxReader = new SaxReader(threadName,this);
       saxReader.setFileList(this.settings.getElement(FILE_LIST_ELEMENT));
       saxReader.setXMLSourceList(this.xmlSourceList);
       saxReader.setNamespaceManager(this.namespaceMappings);
       saxReader.setScalarSourceList(this.scalarSourceList);
       saxReader.setBoundaryList(this.boundaryList);
       saxReader.setSchemaInformation(this.settings.getSetting(XMLLoader.SCHEMA_INSTANCE_PREFIX,null),
                                      this.settings.getSetting(XMLLoader.NO_NAMESPACE_SCHEMA_LOCATION,null),
                                      this.settings.getSetting(XMLLoader.SCHEMA_LOCATION,null));
       return saxReader; 
    }
    
    public void addToWriterQueue(Thread thread) {
        if (!isProcessingComplete()) {
            synchronized(writerQueue) {
              this.writerQueue.addElement(thread);
              this.writerQueue.notifyAll();
            }
        }
    }
    
    private void setWriterSettings() {
        this.commitCharge        = Integer.parseInt(this.settings.getSetting(COMMIT_CHARGE_ELEMENT,"50"));
        this.maxErrors           = Integer.parseInt(this.settings.getSetting(MAX_ERRORS,"10"));
        this.bufferSize          = Integer.parseInt(this.settings.getSetting(BUFFER_SIZE,"32"));
        this.maxSQLErrors        = Integer.parseInt(this.settings.getSetting(MAX_SQL_ERRORS,"10"));
        this.maxSQLInserts       = Integer.parseInt(this.settings.getSetting(MAX_SQL_INSERTS,"0"));
        this.maxDocuments        = Integer.parseInt(this.settings.getSetting(MAX_DOCUMENTS,"-1"));
        this.errorTable          = this.settings.getSetting(ERROR_TABLE_ELEMENT);
        this.clientSideEncoding  = this.settings.getSetting(CLIENT_SIDE_ENCODING_ELEMENT,"false").equalsIgnoreCase("true");
        this.logServerStats      = this.settings.getSetting(LOG_SERVER_STATS_ELEMENT,"false").equalsIgnoreCase("true");
    }
    
    private DatabaseWriter createDatabaseWriter() 
    throws SQLException, IOException, BinXMLException   {
        DecimalFormat df = (DecimalFormat) DecimalFormat.getInstance();
        df.applyPattern("000000");
        this.dbWriterCount = this.dbWriterCount + 1;
        String threadName = "Writer_" + df.format(this.dbWriterCount);
        this.log("Starting new DatabaseWriter thread : " + threadName);
        Connection conn = this.connectionManager.getNewConnection();
        conn.setAutoCommit(false);
        DatabaseWriter writer = new DatabaseWriter(this);
        writer.setName(threadName);
        writer.setParameters(conn, this.errorTable, this.commitCharge, this.maxSQLErrors, this.maxSQLInserts, this.bufferSize, this.clientSideEncoding, this.logServerStats);
        writer.setTableColumnMappings(tableColumnMappings);
        writer.setXPathToTableMappings(this.xpathToTableNameMapping);
        writer.setTableColumnXPathMappings(this.tableColumnXPathMappings);
        this.threadPool.add(writer);      
        return writer;
    }

    public void removeDatabaseWriter(DatabaseWriter writer,boolean normalCompletion) {
        synchronized(this.threadPool) {
          this.threadPool.remove(writer);
          if (!normalCompletion) {
            this.dbWriterAborts = this.dbWriterAborts + 1;
            if (this.dbWriterAborts >= this.maxErrors) {
              setProcessingComplete();
              this.logThread("Maximum number of errors exceeded. Processing Complete.");
            }
          }
        }
        synchronized(this.writerQueue) {
          this.writerQueue.notify();
        }
    }
    
    public DatabaseWriter getDatabaseWriter() 
    throws SQLException, IOException, BinXMLException {
      DatabaseWriter dbw = null;
      while ((dbw == null) && (!this.isProcessingComplete())){
        /*
         * 
         * Check for Available Writer Thread
         * 
         */
        synchronized(this.writerQueue) {
          if ( writerQueue.size() > 0) {
            /*
             * 
             * Allocate an existing Writer from the Pool
             * 
             */
            dbw = (DatabaseWriter) this.writerQueue.remove(0);
          }
          else {
            /*
             * 
             * No Writers Available. Check if maximum number of writer threads have already been created
             * 
             */
            if (this.threadPool.size() < getWriterCount()) {
              /*
               * 
               * Create and start a new Writer Thread
               * 
               */
              dbw = createDatabaseWriter();
              dbw.start();
            }
            else {
              /*
               * 
               * Wait for a writer thread to become available
               * 
               */
              try {
                this.writerQueue.wait();
              }
              catch (InterruptedException ie) {
              }
            }
          }                
        }         
      }
      return dbw;
    }
    
    protected void processValues(String path, Hashtable columnValues)
    throws SAXException, IOException, SQLException, BinXMLException {
      if (this.isProcessingComplete()) {
        throw new ParsingAbortedException();
      }
      this.readCount = this.readCount + 1;
      DatabaseWriter dbw;
      dbw = getDatabaseWriter();
      if (!isProcessingComplete()) {
        synchronized(dbw) {
          dbw.setPath(path);
          dbw.setColumnValues(columnValues);
          dbw.notify();
        }
        if (readCount == this.maxDocuments) {
          this.logThread("Maximum number of documents processed. Processing Complete.");
          setProcessingComplete();
        }
      }
    }
    
    private  void waitForCompletion() {
      while (!isProcessingComplete()) {
        synchronized(this.processorStatus) {
            try {
              this.processorStatus.wait();
            } 
            catch (InterruptedException ie) {
            }                  
        }
      }
      shutdownWriters();
    }

    protected void setProcessingStarted() {
        synchronized(processorStatus) {
           this.processingComplete = false;
        }
    }

    protected void setProcessingComplete() {

       // Set ProcessingComplete TRUE and notify anything waiting on parserStatus.

        synchronized(processorStatus) {
           this.processingComplete = true;
           this.setEndTime();
           this.processorStatus.notify();
        }
    }
    
    protected void setReaderStarted() {
        synchronized(parserStatus) {
          this.parsingComplete = false;
        }
    }
    
    protected void setReaderComplete() {
      
        // Set ParsingCompete TRUE and notify anything waiting on parserStatus.
        
        synchronized(parserStatus) {
          this.parsingComplete = true;
          this.parserStatus.notifyAll();
        }
    }
    protected boolean isProcessingComplete() {
        synchronized(processorStatus) {
          return this.processingComplete;
        }
    }

    protected void shutdownWriters() {

        // Notify all writer threads to terminate and upload statistics
        
        synchronized(this.threadPool) {
          while (this.threadPool.size() > 0) {
            Object writer = threadPool.remove(0);
            synchronized(writer) {
              writer.notify();
            }
          }
        }
        
        synchronized(this.parserStatus) {
            while (!this.parsingComplete) {
                try {
                    this.parserStatus.wait();
                } 
                catch (InterruptedException ie) {
                }     
            }
        }
            
        // Wait for all threads to upload statistics
        
        synchronized(this.loaderStatistics) {
            while(this.loaderStatistics.size() < this.dbWriterCount) {
              try {
                this.loaderStatistics.wait();
              } 
              catch (InterruptedException ie) {
              }     
           }
        }
    }
    
    protected void startFolderCrawler() 
    throws SQLException, BinXMLException, XMLParseException, IOException, ProcessingAbortedException, SAXException {
       FolderCrawler fc = new FolderCrawler();
       fc.setProcessor(this);
       fc.setXMLSourceList(this.xmlSourceList);
       this.setReaderStarted();
       fc.crawlFolderList(this.settings.getElement(FOLDER_LIST_ELEMENT));
    }
    
    protected void startSAXReader() 
    throws SAXException, IOException {
        this.saxReader = createSaxReader();
        this.saxReader.setFileList(this.settings.getElement(FILE_LIST_ELEMENT));
        this.setReaderStarted();
        this.saxReader.start();
    }
    
    public void processFiles() {
       try {
         processTableMappings(this.settings.getElement(TABLE_LIST_ELEMENT));
         processProcedureMappings(this.settings.getElement(PROCEDURE_LIST_ELEMENT));
         this.namespaceMappings = this.processNamespacePrefixMappings();
         setProcessingStarted();
         setWriterCount(Integer.parseInt(this.settings.getSetting(THREAD_COUNT_ELEMENT,"4")));
         setWriterSettings();
         try {
           this.setStartTime();
           if (this.settings.getSetting(MODE_ELEMENT,"SAX").equalsIgnoreCase("SAX")) {
             startSAXReader();
           }
           else {
             startFolderCrawler();
           }
           waitForCompletion();
         }
         catch (ProcessingAbortedException e) {        
         }
         writeStatistics();
         this.logger.close();
       }
       catch (Exception e) {
          this.logThread("SaxProcessor Aborted. ",e);
          this.setProcessingComplete();
       }
    }     
    
    public static void main( String [] args )
    {
      try  {
        XMLLoader app = new XMLLoader();
        app.processFiles();
      }
      catch( Exception e )
      {
         e.printStackTrace();
      }
    }
}
