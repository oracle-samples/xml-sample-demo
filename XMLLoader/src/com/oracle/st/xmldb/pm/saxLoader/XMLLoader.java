
/* ================================================
 *
 * Copyright (c) 2016 Oracle and/or its affiliates.  All rights reserved.
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
import com.oracle.st.xmldb.pm.common.baseApp.Logger;
import com.oracle.st.xmldb.pm.common.baseApp.PrintStreamLogger;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;

import java.sql.Connection;
import java.sql.SQLException;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Locale;
import java.util.TimeZone;
import java.util.Vector;

import oracle.xml.binxml.BinXMLException;
import oracle.xml.parser.v2.XMLParseException;

import org.w3c.dom.Document;

import org.xml.sax.SAXException;

public class XMLLoader extends Logger {

    public static final boolean DEBUG = false;
    
    private ConfigurationManager cfgManager;

    protected ConnectionManager connectionManager;
    protected ApplicationSettings settings = ApplicationSettings.getApplicationSettings();
    protected SAXReader saxReader;

    protected int readCount = 0;
    protected int writeCount = 0;

    protected int dbWriterCount = 0;
    protected int dbWriterAborts = 0;

    protected int maxErrors = 0;

    private Locale locale = new Locale(Locale.ENGLISH.toString(), "US");
    private static String XML_FORMAT_STRING = "yyyy-MM-dd'T'HH:mm:ss.SSS";
    private SimpleDateFormat sdf = new SimpleDateFormat(XML_FORMAT_STRING);

    private Calendar startTime;
    private Calendar endTime;

    private Vector writerQueue = new Vector();
    protected Vector threadPool = new Vector();
    protected int threadCount = 0;
    
    protected Logger logger = new PrintStreamLogger();

    public XMLLoader() throws SQLException, IOException, SAXException {
        
        setLogger();
        this.connectionManager = ConnectionManager.getConnectionManager(settings,logger);
    }

    protected void setLogger() throws SQLException, IOException, SAXException {
        String logFile = this.settings.getSetting(ConfigurationManager.LOG_FILE_NAME);
        if (logFile != null) {
            this.logger.log("Switching Log File to \"" + logFile + "\".");
            OutputStream os = new FileOutputStream(logFile);
            this.logger = new PrintStreamLogger(new PrintStream(os));
        } else {
            this.logger = new PrintStreamLogger();
        }
    }

    public void log(String string) {
        synchronized (this.logger) {
            this.logger.log(Thread.currentThread().getName() + ". " + string);
        }
    }

    public void log(Document doc) {
        synchronized (this.logger) {
            this.logger.log(Thread.currentThread().getName() + ". Document : " + this.writeCount);
            this.logger.log(doc);
        }
    }

    public void log(Exception e) {
        synchronized (this.logger) {
            this.logger.log(Thread.currentThread().getName() + ". Exception : ");
            this.logger.log(e);
        }
    }

    public void log(Object object) {
        synchronized (this.logger) {
            this.logger.log(Thread.currentThread().getName() + ". Object : ");
            this.logger.log(object);
        }
    }

    public void close() {
        synchronized (this.logger) {
            this.logger.close();
        }
    }

    protected void log(Document xml, Exception e) {
        synchronized (this.logger) {
            this.log(e);
            this.logger.log("Current Document :");
            this.logger.log(xml);
        }
    }

    public void log(String message, Exception e) {
        synchronized (this.logger) {
            this.logger.log(Thread.currentThread().getName() + ". " + message + "Exception : ");
            this.logger.log(e);
        }
    }
    
    protected ConfigurationManager getCfgManager() {
        return this.cfgManager;
    }

    private void setStartTime() {
        this.startTime = new GregorianCalendar(this.locale);
    }

    private void setEndTime() {
        this.endTime = new GregorianCalendar(this.locale);
    }

    public String getStartTime() {
        return (this.sdf.format(this.startTime.getTime()) + "000").substring(0, 23);
    }

    public String getEndTime() {
        return (this.sdf.format(this.endTime.getTime()) + "000").substring(0, 23);
    }

    protected Object processorStatus = new Object();
    private boolean processingComplete = true;

    protected Object parserStatus = new Object();
    private boolean parsingComplete = true;

    protected Vector loaderStatistics = new Vector();

    protected void writeStatistics() throws Exception {
        SimpleDateFormat elapsedTimeFormatter = new SimpleDateFormat("HH:mm:ss.SSS");
        GregorianCalendar cal = new GregorianCalendar();
        elapsedTimeFormatter.setTimeZone(TimeZone.getTimeZone("GMT+0"));
        long elapsedTime = this.endTime.getTimeInMillis() - this.startTime.getTimeInMillis();
        cal.setTimeInMillis(elapsedTime);
        String result = elapsedTimeFormatter.format(cal.getTime());

        String horizontalBar =
            "========================================================================================================================================================================================================================";

        String titleBar =
            "| " + String.format("%1$-" + 20 + "s", "Thread Name") + " |" +
            String.format("%1$" + 24 + "s", "Start Time") + " |" + String.format("%1$" + 24 + "s", "End Time") + " |" +
            String.format("%1$" + 13 + "s", "Elapsed Time") + " |" + String.format("%1$" + 8 + "s", "Tasks") + " |" +
            String.format("%1$" + 8 + "s", "Success") + " |" + String.format("%1$" + 8 + "s", "Failed") + " |" +
            String.format("%1$" + 8 + "s", "Docs/sec") + " |" + String.format("%1$" + 14 + "s", "Bytes Read") + " |" +
            String.format("%1$" + 14 + "s", "Bytes Sent") + " |" + String.format("%1$" + 14 + "s", "Bytes Rcvd") + " |" + String.format("%1$" + 8 + "s", "R/Trips") + " |" + String.format("%1$" + 12 + "s", "DB CPU") + " |" +
            String.format("%1$" + 12 + "s", "Client CPU") + " |";

        this.log(horizontalBar);
        this.log(titleBar);
        this.log(horizontalBar);
        synchronized (logger) {
            while (this.loaderStatistics.size() > 0) {
                WriterStatistics stats = (WriterStatistics) this.loaderStatistics.remove(0);
                stats.printStats(this);
                this.writeCount = this.writeCount + stats.getSuccessCount();
            }
        }
        this.log(horizontalBar);

        DecimalFormat df = (DecimalFormat) DecimalFormat.getInstance();
        df.applyPattern("###,###,##0");
        double throughput = ((double) this.writeCount / elapsedTime) * 1000;

        this.log("Processing Complete : Start Time           = " + this.getStartTime());
        this.log("                      End Time             = " + this.getEndTime());
        this.log("                      Elapsed Time         = " + result);
        this.log("                      Total Documents Read = " + this.readCount);
        this.log("                      Documents Written    = " + this.writeCount);
        this.log("                      Throughput           = " + df.format(throughput) + " docs/sec");
        this.log("                      Threads Started      = " + this.dbWriterCount);
        this.log("                      Threads Aborted      = " + this.dbWriterAborts);
    }

    protected void recordStatistics(WriterStatistics stats) {
        synchronized (loaderStatistics) {
            this.loaderStatistics.addElement(stats);
            this.loaderStatistics.notify();
        }
    }

    public String stripNamespacePrefixes(String source) {
        while (source.indexOf(':') > 0) {
            String lhs = source.substring(0, source.indexOf(':') - 1);
            String rhs = source.substring(source.indexOf(':') + 1);
            source = lhs.substring(0, lhs.lastIndexOf('/') + 1) + rhs;
        }
        return source;
    }

    protected SAXReader createSaxReader() throws SAXException, IOException {
        String threadName = "SaxReader";
        SAXReader saxReader = new SAXReader(threadName, SAXReader.FILE_LIST_MODE, this);
        return saxReader;
    }

    public void addToWriterQueue(Thread thread) {
        if (!isProcessingComplete()) {
            synchronized (writerQueue) {
                this.writerQueue.addElement(thread);
                this.writerQueue.notifyAll();
            }
        }
    }

    private DatabaseWriter createDatabaseWriter() throws SQLException, IOException, BinXMLException {
        DecimalFormat df = (DecimalFormat) DecimalFormat.getInstance();
        df.applyPattern("000000");
        this.dbWriterCount = this.dbWriterCount + 1;
        String threadName = "Writer_" + df.format(this.dbWriterCount);
        this.log("Starting new DatabaseWriter thread : " + threadName);
        Connection conn = this.connectionManager.getConnection();
        conn.setAutoCommit(false);
        DatabaseWriter writer = new DatabaseWriter(threadName,this,conn);
        this.threadPool.add(writer);
        return writer;
    }

    public void removeDatabaseWriter(DatabaseWriter writer, boolean normalCompletion) {
        synchronized (this.threadPool) {
            this.threadPool.remove(writer);
            if (!normalCompletion) {
                this.dbWriterAborts = this.dbWriterAborts + 1;
                if (this.dbWriterAborts >= this.maxErrors) {
                    setProcessingComplete();
                    this.log("Maximum number of errors exceeded. Processing Complete.");
                }
            }
        }
        synchronized (this.writerQueue) {
            this.writerQueue.notify();
        }
    }

    public DatabaseWriter getDatabaseWriter() throws SQLException, IOException, BinXMLException {
        DatabaseWriter dbw = null;
        while ((dbw == null) && (!this.isProcessingComplete())) {
          /*
          **
          ** Check for Available Writer Thread
          **
          */
         synchronized (this.writerQueue) {
           if (writerQueue.size() > 0) {
             /*
             **
             ** Allocate an existing Writer from the Pool
             **
             */  
             dbw = (DatabaseWriter) this.writerQueue.remove(0);
           } else {
              /*
              **
              ** No Writers Available. Check if maximum number of writer threads have already been created
              **
              */
              if (this.threadPool.size() < this.threadCount) {
                /*
                **
                ** Create and start a new Writer Thread
                **
                */
                dbw = createDatabaseWriter();
                dbw.start();
              } else {
                /*
                **
                ** Wait for a writer thread to become available
                **
                */
                try {
                  this.writerQueue.wait();
                } catch (InterruptedException ie) {
                }
              }
            }
          }
        }
        return dbw;
    }

    protected void enqueueWriteOperation(String path, HashMap xpathTargetMappings, HashMap columnValues) throws SAXException, IOException, SQLException,
                                                                             BinXMLException {
        if (this.isProcessingComplete()) {
            throw new ParsingAbortedException("XMLLoader.enqueueWriteOperation(): Unexpected Processing Complete Condition.");
        }
        this.readCount = this.readCount + 1;
        DatabaseWriter dbw;
        dbw = getDatabaseWriter();
        if (!isProcessingComplete()) {
            synchronized (dbw) {
                dbw.setColumnValues(path, xpathTargetMappings, columnValues);
                dbw.notify();
            }
            if (readCount == cfgManager.maxDocuments) {
                this.log("XMLLoader.enqueueWriteOperation(): Maximum number of documents processed. Processing Complete.");
                setProcessingComplete();
            }
        }
    }

    private void waitForCompletion() {
        while (!isProcessingComplete()) {
            synchronized (this.processorStatus) {
                try {
                    this.processorStatus.wait();
                } catch (InterruptedException ie) {
                }
            }
        }
        shutdownWriters();
    }

    protected void setProcessingStarted() {
        synchronized (processorStatus) {
            this.processingComplete = false;
        }
    }

    protected void setProcessingComplete() {

        // Set ProcessingComplete TRUE and notify anything waiting on parserStatus.

        synchronized (processorStatus) {
            this.processingComplete = true;
            this.setEndTime();
            this.processorStatus.notify();
        }
    }

    protected void setReaderStarted() {
        synchronized (parserStatus) {
            this.parsingComplete = false;
        }
    }

    protected void setReaderComplete() {

        // Set ParsingCompete TRUE and notify anything waiting on parserStatus.

        synchronized (parserStatus) {
            this.parsingComplete = true;
            this.parserStatus.notifyAll();
        }
    }

    protected boolean isProcessingComplete() {
        synchronized (processorStatus) {
            return this.processingComplete;
        }
    }

    protected void shutdownWriters() {

        // Notify all writer threads to terminate and upload statistics

        synchronized (this.threadPool) {
            while (this.threadPool.size() > 0) {
                Object writer = threadPool.remove(0);
                synchronized (writer) {
                    writer.notify();
                }
            }
        }

        synchronized (this.parserStatus) {
            while (!this.parsingComplete) {
                try {
                    this.parserStatus.wait();
                } catch (InterruptedException ie) {
                }
            }
        }

        // Wait for all threads to upload statistics

        synchronized (this.loaderStatistics) {
            while (this.loaderStatistics.size() < this.dbWriterCount) {
                try {
                    this.loaderStatistics.wait();
                } catch (InterruptedException ie) {
                }
            }
        }
    }

    protected void startFolderCrawler() throws SQLException, BinXMLException, XMLParseException, IOException,
                                               ProcessingAbortedException, SAXException {
        FolderCrawler fc = new FolderCrawler(this);
        this.setReaderStarted();
        fc.crawlFolderList();
    }

    protected void startSAXReader() throws SAXException, IOException {
        this.saxReader = createSaxReader();
        this.saxReader.setFileList(cfgManager.getFileList());
        this.setReaderStarted();
        this.saxReader.start();
    }

    public void processFiles() {
        try {
            this.cfgManager = new ConfigurationManager(this,this.settings);      
            setProcessingStarted();
            this.threadCount = cfgManager.getThreadCount();
            try {
                this.setStartTime();
                if (this.cfgManager.processFileList()) {
                    startSAXReader();
                } else {
                    startFolderCrawler();
                }
                waitForCompletion();
            } catch (ProcessingAbortedException e) {
            }
            writeStatistics();
            this.logger.close();
        } catch (Exception e) {
            this.log("SaxProcessor Aborted. ", e);
            this.setProcessingComplete();
        }
    }

    public static void main(String[] args) {
        try {
            XMLLoader app = new XMLLoader();
            app.processFiles();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
