
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
import java.io.StringWriter;

import java.sql.SQLException;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;

import java.util.LinkedList;

import oracle.xml.binxml.BinXMLException;
import oracle.xml.parser.v2.SAXParser;
import oracle.xml.parser.v2.XMLDocument;
import oracle.xml.parser.v2.XMLElement;

import org.w3c.dom.Attr;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;

public class SAXReader extends Thread implements ContentHandler {

    // TODO : Add Support for checking Namespace URI as well as local names when defining Key Elements and Target Elements
    // TODO : Add Support for adding xsi:XMLSchema-Instance namespace to generated document only when necessary

    // Note that currently a column can only be derived from an element.
    // TODO : Add support for Attributes as the source for a Column

    public static final boolean DEBUG = XMLLoader.DEBUG;
    public static final boolean VERBOSE_TRACE = false;
    
    public static final int FILE_LIST_MODE = 1;
    public static final int FILE_BY_FILE_MODE = 2;
    
    private int mode;
    
    private String xsiPrefix = null;
    private String noNamespaceSchemaLocation = null;
    private String schemaLocation = null;

    private String    columnList;
    private HashMap<String,Object>   columnValues;
    private String currentXPath = "/";
    private String rowXPathExpression = "/";
    
    private LinkedList<RowState> rowStateStack = new LinkedList();
    
    protected HashMap<String,String> xpathTargetMappings = new HashMap();
    protected ArrayList<String> parentXPathList = new ArrayList();

    private class RowState {
      protected String    rowXPathExpression;
      protected HashMap<String,Object>   columnValues;
    }
    
    private void pushRowState() {   
      RowState rs = new RowState();
      rs.rowXPathExpression  = this.rowXPathExpression;
      rs.columnValues        = this.columnValues;      
      rowStateStack.add(rs);  
      this.rowXPathExpression = this.currentXPath;
    }
    
    private void setRowState(String rowXPathExpression) {
      this.columnValues         = new HashMap();
      this.columnList           = this.cfgManager.rowColumnLists.get(this.rowXPathExpression); 
      this.xpathTargetMappings  = this.cfgManager.rowXPathTargetMappings.get(this.rowXPathExpression);
      this.parentXPathList      = this.cfgManager.rowParentXPathLists.get(this.rowXPathExpression);
    }

    private void popRowState() {
      RowState rs;
      rs = this.rowStateStack.removeLast();
      this.rowXPathExpression   = rs.rowXPathExpression;
      this.columnValues         = rs.columnValues;
      if (this.rowXPathExpression != "/") {
        this.columnList           = this.cfgManager.rowColumnLists.get(this.rowXPathExpression); 
        this.xpathTargetMappings  = this.cfgManager.rowXPathTargetMappings.get(this.rowXPathExpression);
        this.parentXPathList      = this.cfgManager.rowParentXPathLists.get(this.rowXPathExpression);
      }
      else {
        this.columnList = "";
        this.xpathTargetMappings = new HashMap();
        this.parentXPathList = new ArrayList();
      }
    }

    boolean explicitSchemaLocation = false;

    private boolean explicitSchemaLocation() {
        return this.explicitSchemaLocation;
    }

    private HashMap absoluteOrdinality  = new HashMap();
    private HashMap realtiveOrdinality  = new HashMap();

    private String currentFilename = null;

    private boolean buildingDocument() {
        return this.currentDocument != null;
    }
    
    private void putColumnValue(String path, Object value) {
        String columnName = (String) this.xpathTargetMappings.get(path);
        columnValues.put(columnName,value);
        if (this.parentXPathList.contains(path)) {
        }
    }

    private XMLDocument currentDocument = null;
    private Node currentNode;

    private void createNewDocument() {
        setDocument(new XMLDocument());
    }

    private void setDocument(XMLDocument newDocument) {
        this.currentDocument = newDocument;
        this.currentNode = newDocument;
    }

    private XMLElement filelist;

    public void setFileList(Element filelist) {
        this.filelist = (XMLElement) filelist;
    }

    private Hashtable namespaceToPrefix = null;
    private Hashtable prefixToNamespace = null;
    private XMLLoader loader;
    private FolderCrawler crawler;

    private ConfigurationManager cfgManager;
    private SAXParser parser;

    public SAXReader(String threadName, int mode, XMLLoader loader) {
        super(threadName);
        this.namespaceToPrefix = new Hashtable();
        this.prefixToNamespace = new Hashtable();
        this.mode = mode;
        this.loader = loader;
        this.cfgManager = loader.getCfgManager();
        
        for (int i=0;i<this.cfgManager.tableList.size();i++) {
           this.absoluteOrdinality.put(cfgManager.tableList.get(i),0);
           this.realtiveOrdinality.put(cfgManager.tableList.get(i),0);
        }

        parser = new SAXParser();
        parser.setAttribute(SAXParser.STANDALONE, Boolean.valueOf(true));
        parser.setValidationMode(SAXParser.NONVALIDATING);
        parser.setContentHandler(this);
    }

    private void incrementOrdinality(String xpathExpression) {
      String tableName = (String) cfgManager.rowXPathObjectMappings.get(xpathExpression);
 
      int ordinality = (int) this.absoluteOrdinality.get(tableName);
      ordinality++;
      this.absoluteOrdinality.put(tableName,ordinality);
      
      ordinality = (int) this.realtiveOrdinality.get(tableName);
      xpathExpression = xpathExpression + "/" + ConfigurationManager.POSITION;
      if (this.xpathTargetMappings.containsKey(xpathExpression)) {
        putColumnValue(xpathExpression,Integer.toString(ordinality));
      }
      ordinality++;
      this.realtiveOrdinality.put(tableName,ordinality);
    }

    public void startDocument() throws SAXException {
        if (DEBUG) {
            this.loader.log("SaxReader.startDocument() : Start Document Event");
        }
    }

    public void endDocument() throws SAXException {
        // this.loader.setParsingComplete();
    }

    private void checkSchemaLocation(Attributes attrs) {

        // Check for SchemaLocation attributes on elements that are not included in the output..
        // NB Should really be managed via a stack..

        String location = attrs.getValue(ConfigurationManager.XML_SCHEMA_INSTANCE_NAMESPACE, ConfigurationManager.SCHEMA_LOCATION);
        if (location != null) {
            this.schemaLocation = location;
            this.noNamespaceSchemaLocation = null;
            this.xsiPrefix = attrs.getQName(attrs.getIndex(ConfigurationManager.XML_SCHEMA_INSTANCE_NAMESPACE, ConfigurationManager.SCHEMA_LOCATION));
            this.xsiPrefix = this.xsiPrefix.substring(0, this.xsiPrefix.indexOf(':'));
            return;
        }


        location = attrs.getValue(ConfigurationManager.XML_SCHEMA_INSTANCE_NAMESPACE, ConfigurationManager.NO_NAMESPACE_SCHEMA_LOCATION);

        if (location != null) {
            this.noNamespaceSchemaLocation = location;
            this.schemaLocation = null;
            this.xsiPrefix = attrs.getQName(attrs.getIndex(ConfigurationManager.XML_SCHEMA_INSTANCE_NAMESPACE,ConfigurationManager.NO_NAMESPACE_SCHEMA_LOCATION));
            this.xsiPrefix = this.xsiPrefix.substring(0, this.xsiPrefix.indexOf(':'));
            return;
        }
    }

    public void startElement(String namespaceURI, String localName, String elementName,
                             Attributes attrs) throws SAXException {
        String prefix = this.cfgManager.namespaceMappings.lookupPrefix(namespaceURI);
        
        String normalizedQName = localName;
        if ((prefix != null) & (prefix != "")) {
            normalizedQName = prefix + ":" + localName;
        }

        if (this.currentXPath.length() > 1) {
            this.currentXPath = this.currentXPath + "/" + normalizedQName;
        } else {
            this.currentXPath = this.currentXPath + normalizedQName;
        }

        if (VERBOSE_TRACE) {
           this.loader.log("SaxReader.startElement() : Namespace \"" + namespaceURI + "\", localName \"" + localName + "\", Name \"" + elementName + "\", Normalized Prefix \"" + prefix  + "\",  Current Path \"" + this.currentXPath + "\".");
        }
                   
        // Build new ColumnValues HashMap for each rowXpathExpression
        
        if (this.cfgManager.isRowXPathExpression(this.currentXPath)) {
            pushRowState();
            setRowState(this.currentXPath);
        }
        
        if (this.xpathTargetMappings.containsKey(this.currentXPath)) {
            if (VERBOSE_TRACE) {
              this.loader.log("SaxReader.startElement() : matched XPath Expression \"" + this.currentXPath + "\".");
            } 
            if (VERBOSE_TRACE) {
                this.loader.log("Creating document using \"" + this.currentXPath + "\"");
            }
            createNewDocument();
        }
        
        for (int i=0;i<attrs.getLength();i++) {
          String uri = attrs.getURI(i);  
          if (VERBOSE_TRACE) {
             this.loader.log("SaxReader.startElement() : Attribute Namespace \"" + namespaceURI + "\", Prefix = " + prefix  + "\".");
          }
               
          normalizedQName = attrs.getLocalName(i);
          if ((prefix != null) & (prefix != "")) {
            normalizedQName = prefix + ":" + localName;
          }
           
          String localPath = this.currentXPath + "/@" + normalizedQName;
          if (this.xpathTargetMappings.containsKey(localPath)) {
            if (VERBOSE_TRACE) {
              this.loader.log("SaxReader.startElement() : matched XPath Expression = \"" + localPath + "\".");
            } 
            putColumnValue(localPath,attrs.getValue(i)); 
          } 
        }

        if (buildingDocument()) {
            XMLElement nextElement = createNewElement(namespaceURI, localName, elementName, attrs);
            this.currentNode.appendChild(nextElement);
            this.currentNode = nextElement;
        } else {
            if (!explicitSchemaLocation()) {
                // Check for Schema Location Information.
                checkSchemaLocation(attrs);
            }
        }
    }

    private void putParentValues(HashMap columnValues) {
        for (int i=0; i< this.parentXPathList.size(); i++){
            String parentXPathExpression = this.parentXPathList.get(i);
            for (int j=this.rowStateStack.size()-1; j > -1; j--) {
              RowState rs = this.rowStateStack.get(j);
              String rowXPathExpression = rs.rowXPathExpression;
              HashMap<String,String> rowXPathMappings = this.cfgManager.rowXPathTargetMappings.get(rowXPathExpression);
              String columnName = rowXPathMappings.get(parentXPathExpression);
              if (columnName != null) {
                  String columnValue = (String) rs.columnValues.get(columnName);
                  columnName = this.xpathTargetMappings.get(parentXPathExpression);    
                  columnValues.put(columnName,columnValue);
                  break;
              }
            }
        }                                                                                 
    }
     
    public void endElement(String namespaceURI, String localName, String qName) throws SAXException {
        try {
            if (VERBOSE_TRACE) {
                this.loader.log("endElement   : Namespace \"" + namespaceURI + "\", localName \"" + localName + "\", qName \"" + qName + "\".");
            }

            if (buildingDocument()) {
                this.currentNode = this.currentNode.getParentNode();

                if (this.currentNode == this.currentDocument) {
                    putColumnValue(this.currentXPath, this.currentDocument);
                    if (VERBOSE_TRACE) {
                        this.loader.log("Completed \"" + this.currentXPath + "\"");
                        this.loader.log(this.currentDocument);
                    }
                    setDocument(null);
                }
            }

            if (cfgManager.isRowXPathExpression(this.currentXPath)) {
                if (this.currentDocument != null) {
                    throw new ParsingAbortedException("SaxReader : Unexpected row boundary (\"" + this.currentXPath + "\") detected while parsing document.");
                }
                incrementOrdinality(this.currentXPath);
                putFilename(this.currentXPath);
                putParentValues(this.columnValues);
                this.loader.enqueueWriteOperation(this.currentXPath, this.xpathTargetMappings, this.columnValues);
                popRowState();
            }

            if (this.currentXPath.lastIndexOf('/') > 1) {
                this.currentXPath = this.currentXPath.substring(0, this.currentXPath.lastIndexOf('/'));
            } else {
                this.currentXPath = "/";
            }
        }

        catch (IOException ioe) {
            throw new SAXException(ioe);
        } catch (SQLException sqle) {
            throw new SAXException(sqle);
        } catch (BinXMLException bine) {
            throw new SAXException(bine);
        }
    }

    private  HashMap getColumnValues() {
        HashMap columnValues = new HashMap();
        return columnValues;
    }

    private void addAttributes(Element element, Attributes attrs) {
        for (int i = 0; i < attrs.getLength(); i++) {
            if (VERBOSE_TRACE) {
                this.loader.log("processAttributes : Local Name = " + attrs.getLocalName(i) + ", Q Name = " + attrs.getQName(i) + ",Type = " + attrs.getType(i) + ", URI = " + attrs.getURI(i) + ", Value = " + attrs.getValue(i));
            }
            if (attrs.getURI(i).equals("http://www.w3.org/2000/xmlns/")) {
            } else {
                element.setAttribute(attrs.getQName(i), attrs.getValue(i));
            }
        }
    }

    private void addNamespaceDeclarations(Element element) {
        Enumeration keys = this.namespaceToPrefix.keys();
        while (keys.hasMoreElements()) {
            String namespace = (String) keys.nextElement();
            String prefix = (String) namespaceToPrefix.get(namespace);
            Attr attr = null;
            if (prefix.equals("")) {
                attr = this.currentDocument.createAttribute("xmlns");
                attr.setValue(namespace);
                element.setAttributeNode(attr);
            } else {
                if (!prefix.equals(element.getPrefix())) {
                    attr = this.currentDocument.createAttribute("xmlns:" + prefix);
                    attr.setValue(namespace);
                    element.setAttributeNode(attr);
                }
            }
        }
    }

    private void patchSchemaLocation(XMLElement root) {
        if (this.xsiPrefix != null) {
            // Remove any existing prefix definition for this prefix.
            root.removeAttribute("xmlns:" + this.xsiPrefix);
            root.removeAttributeNS(ConfigurationManager.XML_SCHEMA_INSTANCE_NAMESPACE, this.xsiPrefix + ":" + ConfigurationManager.SCHEMA_LOCATION);
            root.removeAttributeNS(ConfigurationManager.XML_SCHEMA_INSTANCE_NAMESPACE, this.xsiPrefix + ":" + ConfigurationManager.NO_NAMESPACE_SCHEMA_LOCATION);

            if (this.schemaLocation != null) {
                root.setAttributeNS(ConfigurationManager.XML_SCHEMA_INSTANCE_NAMESPACE,this.xsiPrefix + ":" + ConfigurationManager.SCHEMA_LOCATION, this.schemaLocation);
            } else {
                root.setAttributeNS(ConfigurationManager.XML_SCHEMA_INSTANCE_NAMESPACE,this.xsiPrefix + ":" + ConfigurationManager.NO_NAMESPACE_SCHEMA_LOCATION,this.noNamespaceSchemaLocation);
            }
        }
    }

    private XMLElement createNewElement(String namespaceURI, String localName, String elementName, Attributes attrs) {
        XMLElement newElement = null;
        if ((namespaceURI != null) && (namespaceURI != "")) {
            newElement = (XMLElement) this.currentDocument.createElementNS(namespaceURI, elementName);
            if (!this.namespaceToPrefix.containsKey(namespaceURI)) {
                newElement.setPrefix((String) this.namespaceToPrefix.get(namespaceURI));
            }
        } else {
            newElement = (XMLElement) this.currentDocument.createElementNS("", localName);
        }
        addAttributes(newElement, attrs);
        if (this.currentNode.isSameNode(this.currentDocument)) {
            addNamespaceDeclarations(newElement);
            patchSchemaLocation(newElement);
        }
        return newElement;
    }

    public void characters(char[] p0, int p1, int p2) throws SAXException {

        String textNodePath = this.currentXPath + "/" + ConfigurationManager.TEXT_NODE;

        if (buildingDocument()) {
            StringWriter sw = new StringWriter();
            sw.write(p0, p1, p2);
            String value = sw.toString();
            Node textNode = this.currentDocument.createTextNode(value);
            this.currentNode.appendChild(textNode);
            if (this.xpathTargetMappings.containsKey(textNodePath)) {
                putColumnValue(textNodePath,value);
            }
        } else {
            if (this.xpathTargetMappings.containsKey(textNodePath)) {
                // Assume that the value for the key column is processed by a single call to this function
                StringWriter sw = new StringWriter();
                sw.write(p0, p1, p2);
                String value = sw.toString();
                putColumnValue(textNodePath,value);
            }
        }
    }

    public void startPrefixMapping(String prefix, String uri) throws SAXException {
        if (VERBOSE_TRACE) {
            this.loader.log("startPrefixMapping() : Prefix = " + prefix + ", URI = " + uri);
        }
        if (uri.equals(ConfigurationManager.XML_SCHEMA_INSTANCE_NAMESPACE)) {
            if (explicitSchemaLocation()) {
                return;
            } else {
                this.xsiPrefix = prefix;
            }
        }
        this.namespaceToPrefix.put(uri, prefix);
        this.prefixToNamespace.put(prefix, uri);
    }

    public void endPrefixMapping(String prefix) throws SAXException {
        if (VERBOSE_TRACE) {
            this.loader.log("endPrefixMapping() : Prefix = " + prefix);
        }
        Enumeration e = prefixToNamespace.keys();
        while (e.hasMoreElements()) {
            String thisPrefix = (String) e.nextElement();
            if (thisPrefix.equals(prefix)) {
                String namespace = (String) prefixToNamespace.remove(thisPrefix);
                namespaceToPrefix.remove(namespace);
            }
        }
    }

    public void ignorableWhitespace(char[] p0, int p1, int p2) throws SAXException {
        // throw new SAXException ("Un-Implemented Method: ingnoreableWhitespace");

    }

    public void processingInstruction(String p0, String p1) throws SAXException {
        throw new SAXException("Un-Implemented Method: processingInstruction");
    }

    public void setDocumentLocator(Locator p0) {
        // throw new SAXException ("Un-Implemented Method: setDocumentLocator");
    }

    public void skippedEntity(String p0) throws SAXException {
        throw new SAXException("Un-Implemented Method: skippedEntity");
    }

    public void setCurrentFilename(String filename) {
        this.currentFilename = filename;
    }
    
    public void putFilename(String rowXPathExpression) {
        String filename = null;
        if (this.currentFilename.indexOf(File.separatorChar) > -1) {
            filename = this.currentFilename.substring(this.currentFilename.lastIndexOf(File.separatorChar) + 1);
        } else {
            filename = this.currentFilename;
        }
        
        String targetXPath = rowXPathExpression + "/" + ConfigurationManager.DOCUMENT_URI;
        if (this.xpathTargetMappings.containsKey(targetXPath)) {
          putColumnValue(targetXPath, currentXPath);
        }
 
        targetXPath = rowXPathExpression + "/" + ConfigurationManager.DOCUMENT_NAME;
        if (this.xpathTargetMappings.containsKey(targetXPath)) {
          putColumnValue(targetXPath, filename);
        }        
    }

    private  void processFileList() {

        try {
          NodeList nl = this.filelist.getElementsByTagName(ConfigurationManager.FILE_ELEMENT);
          for (int i = 0; i < nl.getLength(); i++) {
            try {
                Element e = (Element) nl.item(i);
                setCurrentFilename(e.getFirstChild().getNodeValue());
                this.loader.log("SaxReader.processFileList() : Processing " + this.currentFilename);
                for (int j=0;j<this.cfgManager.tableList.size();j++) {
                   this.realtiveOrdinality.put(cfgManager.tableList.get(j),0);
                }
                this.parser.parse(new FileInputStream(this.currentFilename));
            } catch (ParsingAbortedException pae) {
                this.loader.log("SaxReader.processFileList() : Processing Complete - Parsing Aborted.");
                throw pae;
            }
          }
        } catch (Exception e) {
          this.loader.log(e);
        }
        this.loader.setReaderComplete();
        this.loader.setProcessingComplete();
    }

    protected void setCrawler(FolderCrawler crawler) {
        this.crawler = crawler;
    }

        
    private void waitForFile() throws Exception {
        while (!this.crawler.isCrawlComplete()) {
            synchronized (this) {
                if (this.currentFilename != null) {
                  parser.parse(new FileInputStream(this.currentFilename));
                  this.currentFilename = null;
                  this.crawler.addToWriterQueue(this);
                }
                try {
                  this.wait();
                } catch (InterruptedException ioe) {
                }
            }
        }
        if (this.currentFilename != null) {
            parser.parse(new FileInputStream(this.currentFilename));
        }
    }

    public void run() {
        if (this.mode == SAXReader.FILE_LIST_MODE) {
          processFileList();
        }
        else {
          try {
            waitForFile();
          } catch (Exception e) {
              this.loader.log("Aborted. Unhandled ", e);
          } finally {
            this.crawler.removeSAXReader(this);
          }
        }
    }
}
