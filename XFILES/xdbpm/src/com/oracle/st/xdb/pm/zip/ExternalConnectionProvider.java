
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
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;
import oracle.jdbc.OracleConnection;
import oracle.jdbc.pool.OracleOCIConnectionPool;
import oracle.jdbc.oci.OracleOCIConnection;
import oracle.xml.parser.v2.DOMParser;
import oracle.xml.parser.v2.XMLDocument;
import oracle.xml.parser.v2.XMLElement;
import org.xml.sax.SAXException;
import org.w3c.dom.Element;
import org.w3c.dom.Text;
import org.w3c.dom.NodeList;
import java.io.InputStream;

import org.w3c.dom.Document;

public class ExternalConnectionProvider extends Object
{
    public static final boolean DEBUG = true;

    protected OracleConnection connection;

    protected Document parameterFile;

    public static final String CONNECTION = "Connection";
    public static final String DRIVER = "Driver";
    public static final String HOSTNAME = "Hostname";
    public static final String PORT = "Port";
    public static final String SID = "SID";
    public static final String SERVICENAME = "ServiceName";
    public static final String SERVERMODE = "Server";
    public static final String SCHEMA = "Schema";
    public static final String PASSWORD = "Password";
    public static final String POOL = "Pool";
    public static final String THIN_DRIVER = "thin";
    public static final String OCI_DRIVER = "oci8";

    public static final String DEFAULT_CONNECTION_DEFINITION = "c:\\temp\\connection.xml";
    public static final String DEFAULT_DRIVER = OCI_DRIVER;
    public static final String DEFAULT_HOSTNAME = "localhost";
    public static final String DEFAULT_PORT = "1521";
    public static final String DEFAULT_SERVERMODE = "DEDICATED";

    public static final String TARGET_DIRECTORY = "targetDirectory";
   
    private PrintWriter log;

    public ExternalConnectionProvider(String connectionFilename) 
    throws IOException, SAXException {
      loadConnectionSettings(connectionFilename);        
    }

    public void setLogger(PrintWriter logger) {
      this.log = logger;
    }
    
    public Document getParameterFile() {
      return parameterFile;
    }
                
    public Connection getConnection()
    throws Exception
    {
        String user = getSchema();
        String password = getPassword();
        DriverManager.registerDriver( new oracle.jdbc.driver.OracleDriver() );
        String connectionString = user + "/" + password + "@" + getDatabaseURL();
        OracleConnection conn = null;
        this.log.println( "ConnectionProvider.establishConnection(): Connecting as " + connectionString );
        try {
            conn = (OracleConnection) DriverManager.getConnection( getDatabaseURL(), user, password );
            if( DEBUG ) {
                this.log.println( "ConnectionProvider.establishConnection(): Database Connection Established" );
            }
        }
        catch( SQLException sqle ) {
            int err = sqle.getErrorCode();
            this.log.println( "ConnectionProvider.establishConnection(): Failed to connect using " + connectionString );
            sqle.printStackTrace(this.log);
            throw sqle;
        }
        return conn;
    }
    
    public String getSetting(String nodeName)
    {
      return getSetting(nodeName, null);
    }

    public Element getElement(String nodeName)
    {
        Element root = this.parameterFile.getDocumentElement();
        NodeList children = root.getElementsByTagName(nodeName);
        if (children.getLength() != 0)
        {
          return (Element) children.item(0);
        }
      return null;
    } 
    
    public String getSetting(String nodeName, String defaultValue)
    {
      String textValue = null;
      Element root = (XMLElement) this.parameterFile.getDocumentElement();
      NodeList children = root.getElementsByTagName(nodeName);
      if (children.getLength() != 0)
      {
        Element  element = (Element) children.item(0);
        Text text = (Text) element.getFirstChild();
        if (text != null)
        {
            return text.getData();
        }
      }
      return defaultValue;
    }   
    protected String getDriver()
    {
        return getSetting(DRIVER,DEFAULT_DRIVER);
    }
    protected String getHostname()
    {
        return getSetting(HOSTNAME,DEFAULT_HOSTNAME);
    }
    protected String getPort()
    {
        return getSetting(PORT,DEFAULT_PORT);
    }
    protected String getServerMode()
    {
        return getSetting(SERVERMODE,DEFAULT_SERVERMODE);
    }
    protected String getServiceName()
    {
        return getSetting(SERVICENAME);
    }
    protected String getSID()
    {
        return getSetting(SID);
    }
    protected String getSchema()
    {
        return getSetting(SCHEMA);
    }
    protected String getPassword()
    {
        return getSetting(PASSWORD);
    }
    
    public void loadConnectionSettings()
    throws IOException, SAXException
    {
      String filename = System.getProperty( "com.oracle.st.xmldb.pm.ConnectionParameters", DEFAULT_CONNECTION_DEFINITION ) ;
      loadConnectionSettings(filename);
    }
    
    public void loadConnectionSettings(String filename)
    throws IOException, SAXException
    {
      if (DEBUG)
      {
        System.out.println("Using connection Parameters from : " + filename);
      }
      Reader reader = new FileReader(new File(filename));
      DOMParser parser = new DOMParser();
      parser.parse(reader);
      this.parameterFile = parser.getDocument();
    }
    
    protected String getDatabaseURL()
    {
        if( getDriver() != null)
        {
          if( getDriver().equalsIgnoreCase( THIN_DRIVER ) )
          {
            return "jdbc:oracle:thin:@//" + getHostname() + ":" + getPort() + "/" + getServiceName();

          }
          else
          {
              return "jdbc:oracle:oci8:@(description=(address=(host=" + getHostname() + ")(protocol=tcp)(port=" + getPort() + "))(connect_data=(service_name=" + getServiceName() + ")(server=" + getServerMode() + ")))";
          }
        }
        else
        {
          return null;
        }
    }   
}

