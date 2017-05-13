
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

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import java.sql.Connection;
import java.sql.SQLException;

import java.text.DecimalFormat;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;

import java.util.Vector;

import oracle.xml.binxml.BinXMLException;
import oracle.xml.parser.v2.SAXParser;
import oracle.xml.parser.v2.XMLParseException;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;

public class FolderCrawler {

    public static final boolean DEBUG = XMLLoader.DEBUG;
    public static final boolean VERBOSE_TRACE = false;

    private HashMap columnValues = new HashMap();
    private XMLLoader loader;
    private SAXParser p = new SAXParser();
    private ConfigurationManager cfgManager;
    
    private int readerCount;
    private int threadCount = 0; 
    private Vector threadPool = new Vector();
    private Vector readerQueue = new Vector();
    
    private HashMap<String,String> xpathTargetMappings = null;
    private int processedFileCount = 0;
    
    // TODO: Add File Counter, File Counter by Root Element / Table.

    public FolderCrawler(XMLLoader loader) {
        super();
        this.loader = loader;
        this.cfgManager = this.loader.getCfgManager();
        this.threadCount = cfgManager.getThreadCount();
    }
    
    public void putFileDetails(String rootXpathExpression, String currentPath) {
        String filename = null;
        if (currentPath.indexOf(File.separatorChar) > -1) {
            filename = currentPath.substring(currentPath.lastIndexOf(File.separatorChar) + 1);
        } else {
            filename = currentPath;
        }        
        String targetXPath = rootXpathExpression + "/" + ConfigurationManager.DOCUMENT_URI;
        String columnName = this.xpathTargetMappings.get(targetXPath);
        if (columnName != null) {
          this.columnValues.put(columnName,currentPath);       
        }
    
        targetXPath = rootXpathExpression + "/" + ConfigurationManager.DOCUMENT_NAME;
        columnName = this.xpathTargetMappings.get(targetXPath);
        if (columnName != null) {
          this.columnValues.put(columnName,filename);       
        }        

        targetXPath = rootXpathExpression + "/" + ConfigurationManager.POSITION;
        columnName = this.xpathTargetMappings.get(targetXPath);
        if (columnName != null) {
          this.columnValues.put(columnName,Integer.toString(this.processedFileCount));
        }        
    }
    
    public String getRootElementName(String filename) throws IOException {
        try {
            p.parse(new FileInputStream(filename));
        } catch (SAXException s) {
            return s.getMessage();
        }
        return null;
    }

    private void processFile(String filename) throws SQLException, BinXMLException, XMLParseException, IOException,
                                                     ProcessingAbortedException, SAXException {

         
        if (this.loader.isProcessingComplete()) {
            this.loader.log("FolderCrawler.processFile(): Processing Complete - Crawl Aborted.");
            throw new ProcessingAbortedException();
        }
        ContentHandler c = new rootElementReader(this.cfgManager);
        p.setContentHandler(c);
        File dir = new File(filename);
        String[] children = dir.list();
        if (children == null) {
            if (filename.endsWith(".xml")) {
                String rootElementXPath = "/" + getRootElementName(filename);
                if (VERBOSE_TRACE) {
                  this.loader.log("FolderCrawler.processFile(): Processing xml file : \"" + filename + "\". Root Element = \"" + rootElementXPath + "\".");
                }                                             
                if (this.cfgManager.isRowXPathExpression(rootElementXPath)) {
                  /*
                  ** 
                  ** Root Element is mapped to a row. Process the File.
                  ** 
                  */
                  this.processedFileCount++;
                  this.xpathTargetMappings = this.cfgManager.rowXPathTargetMappings.get(rootElementXPath);                 
                  if (this.xpathTargetMappings == null) {
                    /*
                    ** 
                    ** No columns mapped from the row. Must be an XMLType table
                    ** 
                    */
                    this.columnValues = new HashMap();
                    this.columnValues.put("OBJECT_VALUE", new FileInputStream(filename));       
                    this.loader.enqueueWriteOperation(rootElementXPath, this.xpathTargetMappings, this.columnValues);
                  }
                  else {                 
                    String columnName = this.xpathTargetMappings.get(rootElementXPath);
                    if (columnName != null) {
                      /* 
                      **
                      ** Root Element is mapped to a column. Other columns must be metadata.
                      ** 
                      */
                      this.columnValues = new HashMap();
                      this.columnValues.put(columnName, new FileInputStream(filename));  
                      putFileDetails(rootElementXPath,filename);
                      this.loader.enqueueWriteOperation(rootElementXPath, this.xpathTargetMappings, this.columnValues);
                    }
                    else {         
                      SAXReader saxReader = getSAXReader();
                      if (!this.loader.isProcessingComplete()) {
                        synchronized (saxReader) {
                          saxReader.setCurrentFilename(filename);
                          saxReader.notify();
                        }
                      }
                    }
                  }
                }
            }
        } else {
            if (VERBOSE_TRACE) {
              this.loader.log("FolderCrawler.processFile(): Processing folder : " + filename);
            }                                             
            for (int i = 0; i < children.length; i++) {
                processFile(dir.getAbsolutePath() + File.separator + children[i]);
            }
        }

    }

    private SAXReader createSAXReader() throws SQLException, IOException, BinXMLException {
        DecimalFormat df = (DecimalFormat) DecimalFormat.getInstance();
        df.applyPattern("000000");
        this.readerCount = this.readerCount + 1;
        String threadName = "Reader_" + df.format(this.readerCount);
        this.loader.log("Starting new SAX Reader thread : " + threadName);
        SAXReader saxReader = new SAXReader(threadName,SAXReader.FILE_BY_FILE_MODE,this.loader);
        saxReader.setCrawler(this);
        this.threadPool.add(saxReader);
        return saxReader;
    }

    public void removeSAXReader(SAXReader reader) {
        synchronized (this.threadPool) {
            this.threadPool.remove(reader);
        }
        synchronized (this.readerQueue) {
            this.readerQueue.notify();
        }
    }
    
    public SAXReader getSAXReader() throws SQLException, IOException, BinXMLException {
        SAXReader saxReader = null;
        while ((saxReader == null) && (!this.loader.isProcessingComplete())) {
          /*
          **
          ** Check for Available Writer Thread
          **
          */
         synchronized (this.readerQueue) {
           if (readerQueue.size() > 0) {
             /*
             **
             ** Allocate an existing Writer from the Pool
             **
             */  
             saxReader = (SAXReader) this.readerQueue.remove(0);
           } else {
              /*
              **
              ** No Readers Available. Check if maximum number of reader threads have already been created
              **
              */
              if (this.threadPool.size() < this.threadCount) {
                /*
                **
                ** Create and start a new Reader Thread
                **
                */
                saxReader = createSAXReader();
                saxReader.start();
              } else {
                /*
                **
                ** Wait for a reader thread to become available
                **
                */
                try {
                  this.readerQueue.wait();
                } catch (InterruptedException ie) {
                }
              }
            }
          }
        }
        return saxReader;
    }

    public void addToWriterQueue(Thread thread) {
        if (!this.loader.isProcessingComplete()) {
            synchronized (readerQueue) {
                this.readerQueue.addElement(thread);
                this.readerQueue.notifyAll();
            }
        }
    }
    
    protected Object processorStatus = new Object();
    
    protected void shutdownReaders() {

        // Notify all writer threads to terminate and upload statistics

        synchronized (this.threadPool) {
            while (this.threadPool.size() > 0) {
                Object writer = threadPool.remove(0);
                synchronized (writer) {
                    writer.notify();
                }
            }
        }
        this.loader.log("FolderCrawler.shutdownReaders(): Readers shutdown.");
    }

    private void waitForCompletion() {
        while (!this.isCrawlComplete()) {
            synchronized (this.processorStatus) {
                try {
                    this.processorStatus.wait();
                } catch (InterruptedException ie) {
                }
            }
        }
        shutdownReaders();
    }
    private boolean crawlComplete;
    
    protected void setCrawlStarted() {
        synchronized (processorStatus) {
            this.crawlComplete = false;
        }
    }

    protected void setCrawlComplete() {

        // Set ProcessingComplete TRUE and notify anything waiting on parserStatus.

        synchronized (processorStatus) {
            this.crawlComplete = true;
            this.processorStatus.notify();
        }
    }

    protected boolean isCrawlComplete() {
        synchronized (this.processorStatus) {
            return this.crawlComplete;
        }
    }
    
    public void crawlFolderList() throws SQLException, BinXMLException, XMLParseException,
                                                           IOException, ProcessingAbortedException, SAXException {
        setCrawlStarted();
        Element folderList = this.cfgManager.getFolderList();
        NodeList nl = folderList.getElementsByTagName(ConfigurationManager.FOLDER_ELEMENT);
        for (int i = 0; i < nl.getLength(); i++) {
            Element e = (Element) nl.item(i);
            String foldername = e.getFirstChild().getNodeValue();
            this.loader.log("FolderCrawler.crawlFolderList(): Processing " + foldername);
            processFile(foldername);
            setCrawlComplete();
            waitForCompletion();
            this.loader.log("FolderCrawler.crawlFolderList(): Folder Crawl Completed.");
            this.loader.setReaderComplete();
            this.loader.setProcessingComplete();
        }
    }
}
