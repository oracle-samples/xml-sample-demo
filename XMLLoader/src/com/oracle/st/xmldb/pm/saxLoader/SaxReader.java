
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

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.StringWriter;

import java.sql.SQLException;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.annotation.processing.Processor;

import oracle.sql.BFILE;

import oracle.xml.binxml.BinXMLException;
import oracle.xml.parser.v2.SAXParser;
import oracle.xml.parser.v2.XMLDocument;
import oracle.xml.parser.v2.XMLElement;

import org.w3c.dom.Attr;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;

public class SaxReader extends Thread implements ContentHandler
{
    
    // TODO : Add Support for checking Namespace URI as well as local names when defining Key Elements and Target Elements
    // TODO : Add Support for adding xsi:XMLSchema-Instance namespace to generated document only when necessary
    
    // Note that currently a column can only be derived from an element. 
    // TODO : Add support for Attributes as the source for a Column
    
    public static final boolean DEBUG = false;

    private String xsiPrefix = null;
    private String noNamespaceSchemaLocation = null;
    private String schemaLocation = null;
    private Element namespaceMappings = null;
    
    boolean explicitSchemaLocation = false;
    
    private boolean explicitSchemaLocation() {
        return this.explicitSchemaLocation;
    }
    
    public void setSchemaInformation(String xsiPrefix, String noNamespaceSchemaLocation, String schemaLocation) {
        this.xsiPrefix = xsiPrefix;
        this.noNamespaceSchemaLocation = noNamespaceSchemaLocation;
        this.schemaLocation = schemaLocation;
        this.explicitSchemaLocation = this.xsiPrefix != null;
    }
    
    protected void setNamespaceManager(Element namespaceMappings) {
        this.namespaceMappings = namespaceMappings;
    }

    private String currentPath = "/";
    private String currentFilename = null;
    
    private ArrayList xmlSourceList;
    private ArrayList scalarSourceList;
    private ArrayList boundaryList;
    
    public void setXMLSourceList(ArrayList list) {
        this.xmlSourceList = list;
    }

    public void setScalarSourceList(ArrayList list) {
        this.scalarSourceList = list;
    }

    public void setBoundaryList(ArrayList list) {
        this.boundaryList = list;
    }

    private boolean isXMLSource() {
        return this.xmlSourceList.contains(this.currentPath);
    }

    private boolean isScalarSource() {
        return this.scalarSourceList.contains(this.currentPath);
    }

    private boolean isBoundary() {
        return this.boundaryList.contains(this.currentPath);
    }

    private boolean buildingDocument() {
      return this.currentDocument != null;
    }

    private Hashtable columnValues = new Hashtable();

    private void setScalarValue(String value) {
        setScalarValue(this.currentPath,value);
    }

    private void setScalarValue(String key, String value) {
        this.processor.log("SaxReader : Scalar Value for \"" + key + "\" = \"" + value + "\".");
        setColumnValue(key,value);
    }
    
    private void setColumnValue(XMLDocument xml) {
        setColumnValue(this.currentPath,xml);
    }

    private void setColumnValue(String key, Object value) {
      if (columnValues.containsKey(key)) {
        columnValues.remove(key);
      }
      this.columnValues.put(key, value);
    }
    
    private XMLDocument currentDocument;
    private Node        currentNode;
    
    private void createNewDocument() {
        setDocument(new XMLDocument());
    }
    
    private void setDocument(XMLDocument newDocument) {
        this.currentDocument = newDocument;
        this.currentNode = newDocument;
    }

    private XMLElement filelist;

    public void setFileList(Element filelist) {
        this.filelist = (XMLElement)filelist;
    }

    private Hashtable namespaceToPrefix = null;
    private Hashtable prefixToNamespace = null;
    private XMLLoader processor;

    public SaxReader(String threadName, XMLLoader processor) {
        super(threadName);
        this.namespaceToPrefix = new Hashtable();
        this.prefixToNamespace = new Hashtable();
        this.processor = processor;
    }

    public void setOrdinality(int ordinality) {

        this.setScalarValue(XMLLoader.ORDINALITY,Integer.toString(ordinality));
    }
    
    public void startDocument() throws SAXException {
        if (DEBUG) {
            this.processor.log("SaxReader.startDocument() : Start Document Event");
        }
    }

    public void endDocument() throws SAXException {
        // this.processor.setParsingComplete();
    }


    private void checkSchemaLocation(Attributes attrs) {
        
        // Check for SchemaLocation attributes on elements that are not included in the output..
        // NB Should really be managed via a stack..
        
        String location = attrs.getValue(XMLLoader.XML_SCHEMA_INSTANCE_NAMESPACE, XMLLoader.SCHEMA_LOCATION);
        if (location != null) {
          this.schemaLocation = location;
          this.noNamespaceSchemaLocation = null;
          this.xsiPrefix = attrs.getQName(attrs.getIndex(XMLLoader.XML_SCHEMA_INSTANCE_NAMESPACE, XMLLoader.SCHEMA_LOCATION));
          this.xsiPrefix = this.xsiPrefix.substring(0,this.xsiPrefix.indexOf(':'));
          this.processor.log("schemaLocation = \"" + this.schemaLocation + "\". Prefix = \"" + this.xsiPrefix + "\".");
          return;
        }
        
        
        location  = attrs.getValue(XMLLoader.XML_SCHEMA_INSTANCE_NAMESPACE, XMLLoader.NO_NAMESPACE_SCHEMA_LOCATION);

        if (location != null) {
          this.noNamespaceSchemaLocation = location;
          this.schemaLocation = null;
          this.xsiPrefix = attrs.getQName(attrs.getIndex(XMLLoader.XML_SCHEMA_INSTANCE_NAMESPACE, XMLLoader.NO_NAMESPACE_SCHEMA_LOCATION));
          this.xsiPrefix = this.xsiPrefix.substring(0,this.xsiPrefix.indexOf(':'));
          this.processor.log("noNamespaceSchemaLocation = \"" + this.noNamespaceSchemaLocation + "\". Prefix = \"" + this.xsiPrefix + "\".");
          return;
        }
    }
    
    public void startElement(String namespaceURI, String localName, String elementName, Attributes attrs) 
    throws SAXException {
        if (DEBUG) {
            this.processor.log("SaxReader.startElement() : Namespace = " + namespaceURI + ",localName = " + localName + ",Name = " + elementName);
        }

        String prefix = this.namespaceMappings.lookupPrefix(namespaceURI);
        
        String qname = localName;
        if ((prefix != null ) & (prefix != "")) {
          qname = prefix + ":" + localName;
        }

        if (this.currentPath.length() > 1) {
          this.currentPath = this.currentPath + "/" + qname;
        }
        else {
          this.currentPath = this.currentPath + qname;
        }

        if (DEBUG) {
            this.processor.log("SaxReader.startElement() : Current Path = " + this.currentPath);
        }

        if (isXMLSource() ) { 
          createNewDocument();
        }

        if (buildingDocument()) {
          XMLElement nextElement = createNewElement(namespaceURI, localName, elementName, attrs);
          this.currentNode.appendChild(nextElement);
          this.currentNode = nextElement;            
        }
        else {
          if (!explicitSchemaLocation()) {
            // Check for Schema Location Information.
            checkSchemaLocation(attrs);
          }
        }
    }
    
    
    public void endElement(String namespaceURI, String localName, String qName)
    throws SAXException {
        try {
            if (DEBUG) {
                this.processor.log("endElement   : Namespace = " + namespaceURI + ",localName = " + localName + ",qName = " + qName);
            }
            
            if (buildingDocument()) {
                this.currentNode = this.currentNode.getParentNode();

                if (this.currentNode == this.currentDocument) {
                    setColumnValue(this.currentDocument);
                    if (DEBUG) {
                        this.processor.log("Document Complete");
                        this.processor.log(this.currentDocument);
                    }
                    setDocument(null);
                }
            }
            
            if (isBoundary()) {
                if (this.currentDocument != null) {
                    throw new ParsingAbortedException("SaxReader : Found Row Boundary while parsing document.");
                }
              this.processor.processValues(this.currentPath,(Hashtable) this.columnValues.clone());
            }

            if (this.currentPath.lastIndexOf('/') > 1) {
              this.currentPath = this.currentPath.substring(0,this.currentPath.lastIndexOf('/'));
            }
            else {
              this.currentPath = "/";
            }
        } 

        catch (IOException ioe) {
          throw new SAXException(ioe);
        }
        catch (SQLException sqle) {
          throw new SAXException(sqle);
        }
        catch (BinXMLException bine) {
          throw new SAXException(bine);
        }
    }

    protected Hashtable getColumnValues() {
        Hashtable columnValues = new Hashtable();
        return columnValues;
    }

    private void addAttributes(Element element, Attributes attrs) {
        for (int i = 0; i < attrs.getLength(); i++) {
            if (DEBUG) {
                this.processor.log("processAttributes : Local Name = " + attrs.getLocalName(i) + ", Q Name = " +
                                   attrs.getQName(i) + ",Type = " + attrs.getType(i) + ", URI = " + attrs.getURI(i) +
                                   ", Value = " + attrs.getValue(i));
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
            String namespace = (String)keys.nextElement();
            String prefix = (String)namespaceToPrefix.get(namespace);
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
          root.removeAttributeNS(XMLLoader.XML_SCHEMA_INSTANCE_NAMESPACE,this.xsiPrefix + ":" + XMLLoader.SCHEMA_LOCATION);
          root.removeAttributeNS(XMLLoader.XML_SCHEMA_INSTANCE_NAMESPACE,this.xsiPrefix + ":" + XMLLoader.NO_NAMESPACE_SCHEMA_LOCATION);
          
          if (this.schemaLocation != null ) {
              root.setAttributeNS(XMLLoader.XML_SCHEMA_INSTANCE_NAMESPACE,this.xsiPrefix + ":" + XMLLoader.SCHEMA_LOCATION,this.schemaLocation);
          }
          else {
            root.setAttributeNS(XMLLoader.XML_SCHEMA_INSTANCE_NAMESPACE,this.xsiPrefix + ":" + XMLLoader.NO_NAMESPACE_SCHEMA_LOCATION,this.noNamespaceSchemaLocation);              
          }
      }
    }

    private XMLElement createNewElement(String namespaceURI, String localName, String elementName, Attributes attrs) {
        XMLElement newElement = null;
        if (namespaceURI != null) {
            if (this.namespaceToPrefix.containsKey(namespaceURI)) {
                /* Namespace in already in Scope - create Element from Qualified Name */
                newElement = (XMLElement)this.currentDocument.createElement(elementName);
            } else {
                /* Namespace is not already in Scope - create Element with namespace */
                newElement = (XMLElement)this.currentDocument.createElementNS(namespaceURI, elementName);
                newElement.setPrefix((String)this.namespaceToPrefix.get(namespaceURI));
            }
        } else {
            newElement = (XMLElement)this.currentDocument.createElement(localName);
        }
        addAttributes(newElement, attrs);
        if (this.currentNode.equals(this.currentDocument)) {
            addNamespaceDeclarations(newElement);
            patchSchemaLocation(newElement);
        }
        return newElement;
    }

    public void characters(char[] p0, int p1, int p2) throws SAXException {
        if (buildingDocument()) {
            StringWriter sw = new StringWriter();
            sw.write(p0, p1, p2);
            String value = sw.toString();
            Node textNode = this.currentDocument.createTextNode(value);
            this.currentNode.appendChild(textNode);
            if (isScalarSource()) {
                setScalarValue(value);
            }
        }
        else {
            if (isScalarSource()) {
              // Assume that the value for the key column is processed by a single call to this function
              StringWriter sw = new StringWriter();
              sw.write(p0, p1, p2);
              String value = sw.toString();
              setScalarValue(value);
            }
        }
    }

    public void startPrefixMapping(String prefix, String uri) throws SAXException {
        if (DEBUG) {
            this.processor.log("startPrefixMapping() : Prefix = " + prefix + ", URI = " + uri);
        }
        if (uri.equals(XMLLoader.XML_SCHEMA_INSTANCE_NAMESPACE)) {
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
        if (DEBUG) {
            this.processor.log("endPrefixMapping() : Prefix = " + prefix);
        }
        Enumeration e = prefixToNamespace.keys();
        while (e.hasMoreElements()) {
            String thisPrefix = (String)e.nextElement();
            if (thisPrefix.equals(prefix)) {
                String namespace = (String)prefixToNamespace.remove(thisPrefix);
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
    
    public void setFilename(String currentPath) {
        String filename = null;
        if (currentPath.indexOf(File.separatorChar) > -1) {
          filename = currentPath.substring(currentPath.lastIndexOf(File.separatorChar)+1);
        }
        else {
          filename = currentPath;
        }
        setScalarValue(XMLLoader.CURRENT_PATH,currentPath);
        setScalarValue(XMLLoader.CURRENT_FILENAME,filename);
    }

    
    public void processFileList() throws IOException, SAXException, ProcessingAbortedException {
        SAXParser parser;
        parser = new SAXParser();
        parser.setAttribute(SAXParser.STANDALONE, Boolean.valueOf(true));
        parser.setValidationMode(SAXParser.NONVALIDATING);
        parser.setContentHandler(this);
        
        NodeList nl = this.filelist.getElementsByTagName(XMLLoader.FILE_ELEMENT);
        for (int i = 0; i < nl.getLength(); i++) {
            try {
              Element e = (Element)nl.item(i);
              this.currentFilename = e.getFirstChild().getNodeValue();
              this.processor.log("SaxReader.processFileList() : Processing " + this.currentFilename);
              setFilename(this.currentFilename);
              parser.parse(new FileInputStream(this.currentFilename));
            }
            catch (ParsingAbortedException pae) {
              this.processor.log("SaxReader.processFileList() : Processing Complete - Parsing Aborted.");
              throw pae;
            }
        }
    }

    public void run() {
        try {
            processFileList();
        } catch (Exception e) {
            this.processor.logThread(e);
        }
        this.processor.setReaderComplete();
        this.processor.setProcessingComplete();
    }
}
