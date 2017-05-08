
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

import java.sql.SQLException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;

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
    
    // TODO: Add File Counter, File Counter by Root Element / Table.

    public FolderCrawler(XMLLoader loader) {
        super();
        this.loader = loader;
        this.cfgManager = this.loader.getCfgMgr();
    }

    private void putColumnValue(String path, Object value) {
        String columnName = (String) this.cfgManager.xpathColumnNameMappings.get(path);
        this.columnValues.put(columnName,value);
    }

    public void setFilename(String rootNode, String currentPath) {
        String filename = null;
        if (currentPath.indexOf(File.separatorChar) > -1) {
            filename = currentPath.substring(currentPath.lastIndexOf(File.separatorChar) + 1);
        } else {
            filename = currentPath;
        }        
        String targetXPath = rootNode + "/" + ConfigurationManager.DOCUMENT_URI;
        if (this.cfgManager.isMappedXPathExpression(targetXPath)) {
          putColumnValue(targetXPath, currentPath);
        }
    
        targetXPath = rootNode + "/" + ConfigurationManager.DOCUMENT_NAME;
        if (this.cfgManager.isMappedXPathExpression(targetXPath)) {
          putColumnValue(targetXPath, filename);
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
                if (this.cfgManager.isMappedXPathExpression(rootElementXPath)) {
                    this.columnValues = new HashMap();
                    setFilename(rootElementXPath,filename);
                    putColumnValue(rootElementXPath, new FileInputStream(filename));
                    this.loader.processValues(rootElementXPath, this.columnValues);
                }
            }
        } else {
            for (int i = 0; i < children.length; i++) {
                if (VERBOSE_TRACE) {
                  this.loader.log("FolderCrawler.processFile(): Processing folder : " + filename);
                }                                             
                processFile(dir.getAbsolutePath() + File.separator + children[i]);
            }
        }

    }

    public void crawlFolderList() throws SQLException, BinXMLException, XMLParseException,
                                                           IOException, ProcessingAbortedException, SAXException {
        Element folderList = this.cfgManager.getFolderList();
        NodeList nl = folderList.getElementsByTagName(ConfigurationManager.FOLDER_ELEMENT);
        for (int i = 0; i < nl.getLength(); i++) {
            Element e = (Element) nl.item(i);
            String foldername = e.getFirstChild().getNodeValue();
            this.loader.log("FolderCrawler.crawlFolderList() : Processing " + foldername);
            processFile(foldername);
            this.loader.setReaderComplete();
            this.loader.setProcessingComplete();
        }
    }
}
