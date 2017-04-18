
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

package com.oracle.st.xmldb.pm.common.baseApp;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;

import oracle.xml.parser.v2.DOMParser;
import oracle.xml.parser.v2.XMLDocument;

import oracle.xml.parser.v2.XMLParseException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

import org.xml.sax.SAXException;

public class ApplicationSettings {

    public static final boolean DEBUG = false;

    public static final String CONNECTION = "Connection";
    public static final String DRIVER = "Driver";
    public static final String HOSTNAME = "Hostname";
    public static final String PORT = "Port";
    public static final String SID = "SID";
    public static final String SERVICENAME = "ServiceName";
    public static final String SERVERMODE = "Server";
    public static final String TNSALIAS = "tnsAlias";
    public static final String TNSADMIN = "tnsAdmin";
    public static final String SCHEMA = "Schema";
    public static final String PASSWORD = "Password";
    public static final String POOL = "Pool";
    public static final String THIN_DRIVER = "thin";
    public static final String OCI_DRIVER = "oci8";
    public static final String INTERNAL_DRIVER = "KPRB";

    public static final String DEFAULT_CONNECTION_DEFINITION = "connectionProperties.xml";
    public static final String DEFAULT_DRIVER = OCI_DRIVER;
    public static final String DEFAULT_HOSTNAME = "localhost";
    public static final String DEFAULT_PORT = "1521";
    public static final String DEFAULT_SERVERMODE = "DEDICATED";

    public static final String TARGET_DIRECTORY = "targetDirectory";

    protected Document parameterDocument;

    protected Logger logger = new PrintStreamLogger();

    public ApplicationSettings() {
        super();
    }

    /*
     * Factory Methods
     * 
     *  Filename & Logger
     *  Default
     *  Filename
     *  Logger
     *  
     */

    public static ApplicationSettings getApplicationSettings(String filename, Logger logger) {
      ApplicationSettings settings = new ApplicationSettings();
      settings.setLogger(logger);
      settings.loadApplicationSettings(filename);
      return settings;
    }
    
    public static ApplicationSettings getApplicationSettings() {
        String filename = System.getProperty("com.oracle.st.xmldb.pm.ConnectionParameters", ApplicationSettings.DEFAULT_CONNECTION_DEFINITION);
        return getApplicationSettings(filename, new PrintStreamLogger());            
    }

    public static ApplicationSettings getApplicationSettings(String filename) {
        return getApplicationSettings(filename, new PrintStreamLogger());            
    }

    public static ApplicationSettings getApplicationSettings(Logger logger) {
        String filename = System.getProperty("com.oracle.st.xmldb.pm.ConnectionParameters", ApplicationSettings.DEFAULT_CONNECTION_DEFINITION);
        return getApplicationSettings(filename, logger);            
    }
    
    public void setLogger(Logger logger) {
        this.logger = logger;
    }

    private void loadApplicationSettings(String filename) {
        if (DEBUG) {
            this.logger.log("Reading Application Settings and Configuration inforomation from: \"" + filename + "\".");
        }
        try {
            Reader reader = new FileReader(new File(filename));
            DOMParser parser = new DOMParser();
            parser.parse(reader);
            Document doc = parser.getDocument();
            setParameterDocument(doc);
        } catch (XMLParseException xmle) {
            this.logger.log(xmle);
            setParameterDocument(new XMLDocument());
        } catch (SAXException saxe) {
            this.logger.log(saxe);
            setParameterDocument(new XMLDocument());
        } catch (IOException ioe) {
            this.logger.log(ioe);
            setParameterDocument(new XMLDocument());
        }
    }

    public String getSetting(String nodeName) {
        return getSetting(nodeName, null);
    }

    public Element getElement(String nodeName) {
        Element root = this.parameterDocument.getDocumentElement();
        NodeList children = root.getElementsByTagName(nodeName);
        if (DEBUG) {
            this.logger.log("parameterDocument.getElement(): Found " + children.getLength() + " " + nodeName +
                            " Nodes.");
        }
        if (children.getLength() != 0) {
            return (Element) children.item(0);
        }
        return null;
    }

    public String getSetting(String nodeName, String defaultValue) {
        String textValue = null;
        Element element = getElement(nodeName);
        // System.out.println("getSetting() : element " + nodeName + " found = " + (element != null) );
        if (element != null) {
            Text text = (Text) element.getFirstChild();
            // System.out.println("getSetting() : text found = " + (text != null) );
            if (text != null) {
                // System.out.println("getSetting() : text value = " + text.getData() );
                return text.getData();
            }
        }
        return defaultValue;
    }

    public void setSetting(String nodeName, String value) throws IOException {
        String textValue = null;
        Element element = getElement(nodeName);
        if (element != null) {
            Text text = (Text) element.getFirstChild();
            text.setData(value);
        }
    }

    public void setDriver(String driver) throws IOException {
        setSetting(DRIVER, driver);
    }

    public void setDriver() throws IOException {
        setSetting(DRIVER, DEFAULT_DRIVER);
    }

    public String getDriver() {
        return getSetting(DRIVER, DEFAULT_DRIVER);
    }

    public String getHostname() {
        return getSetting(HOSTNAME, DEFAULT_HOSTNAME);
    }

    public String getPort() {
        return getSetting(PORT, DEFAULT_PORT);
    }

    public String getServerMode() {
        return getSetting(SERVERMODE, DEFAULT_SERVERMODE);
    }

    public String getServiceName() {
        return getSetting(SERVICENAME);
    }

    public String getSID() {
        return getSetting(SID);
    }

    protected String getTNSAlias() {
        return getSetting(TNSALIAS);
    }

    protected String getTNSAdmin() {
        return getSetting(TNSADMIN);
    }

    public boolean useConnectionPool() {
        String usePool = getSetting(POOL, Boolean.FALSE.toString());
        return !usePool.equalsIgnoreCase(Boolean.FALSE.toString());
    }

    public String getSchema() {
        return getSetting(SCHEMA);
    }

    public String getPassword() {
        return getSetting(PASSWORD);
    }

    public void dumpConnectionSettings() {
        this.logger.log("ConnectionProvider.dumpConnectionSettings(): Connection Settings :-  ");
        this.logger.log(this.parameterDocument);
    }

    public void setParameterDocument(Document doc) {
        this.parameterDocument = doc;
        if (DEBUG)
            dumpConnectionSettings();
    }

    public Document getParameterDocument() {
        return this.parameterDocument;
    }

    public void resetLogger(Logger logger) {
        this.logger = logger;
    }

}
