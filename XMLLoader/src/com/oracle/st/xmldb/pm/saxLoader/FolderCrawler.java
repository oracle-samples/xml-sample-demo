
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

    private Hashtable columnValues = new Hashtable();
    private XMLLoader processor;
    private SAXParser p = new SAXParser();
    private String xpathExpression;

    public void setProcessor(XMLLoader loader) {
        this.processor = loader;
    }

    private ArrayList xmlSourceList;

    public void setXMLXPathList(ArrayList list) {
        this.xmlSourceList = list;
    }

    private boolean isXMLSource(String xpathExpression) {
        return this.xmlSourceList.contains(xpathExpression);
    }

    public FolderCrawler() {
        super();
    }


    private void setScalarValue(String key, String value) {
        // this.processor.log("SaxReader : Scalar Value for \"" + key + "\" = \"" + value + "\".");
        setColumnValue(key, value);
    }


    private void setColumnValue(String key, Object value) {
        if (columnValues.containsKey(key)) {
            columnValues.remove(key);
        }
        this.columnValues.put(key, value);
    }


    public void setFilename(String currentPath) {
        String filename = null;
        if (currentPath.indexOf(File.separatorChar) > -1) {
            filename = currentPath.substring(currentPath.lastIndexOf(File.separatorChar) + 1);
        } else {
            filename = currentPath;
        }
        setScalarValue(ConfigurationManager.DOCUMENT_URI, currentPath);
        setScalarValue(ConfigurationManager.DOCUMENT_NAME, filename);
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

        if (processor.isProcessingComplete()) {
            processor.log("FolderCrawler.processFile() : Processing Complete - Crawl Aborted.");
            throw new ProcessingAbortedException();
        }
        // processor.log("Processing : " + filename);
        ContentHandler c = new rootElementReader();
        p.setContentHandler(c);
        File dir = new File(filename);
        String[] children = dir.list();
        if (children == null) {
            if (filename.endsWith(".xml")) {
                setFilename(filename);
                String rootElementXPath = "/" + getRootElementName(filename);
                if (isXMLSource(rootElementXPath)) {
                    setColumnValue(rootElementXPath, new FileInputStream(filename));
                    this.processor.processValues(rootElementXPath, (HashMap) this.columnValues.clone());
                }
            }
        } else {
            for (int i = 0; i < children.length; i++) {
                processFile(dir.getAbsolutePath() + File.separator + children[i]);
            }
        }

    }

    public void crawlFolderList(Element folderList) throws SQLException, BinXMLException, XMLParseException,
                                                           IOException, ProcessingAbortedException, SAXException {
        NodeList nl = folderList.getElementsByTagName(ConfigurationManager.FOLDER_ELEMENT);
        for (int i = 0; i < nl.getLength(); i++) {
            Element e = (Element) nl.item(i);
            String foldername = e.getFirstChild().getNodeValue();
            this.processor.log("FolderCrawler.crawlFolderList() : Processing " + foldername);
            processFile(foldername);
            this.processor.setReaderComplete();
            this.processor.setProcessingComplete();
        }
    }
}
