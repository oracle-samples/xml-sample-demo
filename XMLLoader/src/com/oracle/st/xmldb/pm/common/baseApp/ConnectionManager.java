
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
import java.io.IOException;
import java.io.PrintStream;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;

import java.util.Properties;
import oracle.jdbc.OracleConnection;
import oracle.jdbc.OracleDriver;
import oracle.jdbc.pool.OracleOCIConnectionPool;
import oracle.jdbc.oci.OracleOCIConnection;
import oracle.jdbc.pool.OracleConnectionPoolDataSource;

import org.xml.sax.SAXException;

import org.w3c.dom.Document;
import oracle.jdbc.pool.OracleDataSource;
import oracle.ucp.jdbc.PoolDataSource;
import oracle.ucp.jdbc.PoolDataSourceFactory;


public class ConnectionManager 
{
    protected OracleDataSource ods;
    protected PoolDataSource pds;
    protected OracleOCIConnectionPool ociPool;
    
    protected ApplicationSettings settings;
    protected LogManager log;
    
    public static final boolean DEBUG = true;

    protected OracleConnection connection;

    protected OracleOCIConnectionPool connectionPool;

    protected OracleConnectionPoolDataSource ds;
 
    public ConnectionManager getConnectionManager() {
        return this;
    }

    protected String getDatabaseURL()
    {
        // System.out.println("getDatabaseURL() : Driver = " + this.settings.getDriver());
        if( this.settings.getDriver() != null) {
          if( this.settings.getDriver().equalsIgnoreCase( ApplicationSettings.THIN_DRIVER ) ) {
              return "jdbc:oracle:thin:@//" + this.settings.getHostname() + ":" + this.settings.getPort() + "/" + this.settings.getServiceName();
          }
          else {
              return "jdbc:oracle:oci8:@(description=(address=(host=" + this.settings.getHostname() + ")(protocol=tcp)(port=" + this.settings.getPort() + "))(connect_data=(service_name=" + this.settings.getServiceName() + ")(server=" + this.settings.getServerMode() + ")))";
          }
        }
        else {
          return null;
        }
    }   
    
    private OracleConnection createConnection()
    throws SQLException, IOException {
        OracleConnection conn = null;
        try
        {
            if ( this.settings.getDriver().equalsIgnoreCase(ApplicationSettings.INTERNAL_DRIVER )) {
              if ( DEBUG ) {
                 this.log.log( "ConnectionManager.createConnection(): Connecting using Internal (KRPB) Driver " );
              }
              OracleDriver ora = new OracleDriver();
              conn = (OracleConnection) ora.defaultConnection();
            }
            else {
              String user = this.settings.getSchema();
              String password = this.settings.getPassword();
              String connectionString = user + "/" + "*********" + "@" + getDatabaseURL();
              if ( DEBUG ) {
                 this.log.log( "ConnectionManager.createConnection(): Connecting as " + connectionString );
              }
              conn = (OracleConnection) DriverManager.getConnection( getDatabaseURL(), user, password );
            }
            if( DEBUG ) {
              this.log.log( "ConnectionManager.createConnection(): Database Connection Established" );
            }
        }
        catch( SQLException sqle )
        {
            int err = sqle.getErrorCode();
            this.log.log( "ConnectionManager.createConnection(): Failed to connect" );
            this.log.log(sqle);
            throw sqle;
        }
        return conn;
    }
    
    private void openConnection()
    throws SQLException, IOException {
      DriverManager.registerDriver( new oracle.jdbc.driver.OracleDriver() );
      if (this.settings.isPooled()) {
        createConnectionPool();
      }
      else {
        this.connection = createConnection();
      }       
    }
    
    public OracleConnection getNewConnection()
    throws SQLException, 
                                                      IOException {
      return createConnection();
    }

    public ConnectionManager(LogManager log)
    throws SAXException, IOException, SQLException  {
      this.log = log;
      this.settings = new ApplicationSettings(this.log);
      openConnection();
    }
    
    public ConnectionManager()     
    throws SAXException, IOException, SQLException {
        this.log = new PrintStreamLogger();
        this.settings = new ApplicationSettings(this.log);
        openConnection();
    }
    
    public ConnectionManager(Document connectionSettings)     
    throws SAXException, IOException, SQLException {
        this.log = new PrintStreamLogger();
        this.settings = new ApplicationSettings(connectionSettings, this.log);
        openConnection();
    }

    public ConnectionManager(Document connectionSettings,LogManager log)     
    throws SAXException, IOException, SQLException  {
        this.log = log;
        this.settings = new ApplicationSettings(connectionSettings,this.log);
        openConnection();
    }

    public ConnectionManager(ApplicationSettings connectionSettings)     
    throws SAXException, IOException, SQLException  {
        this.log = new PrintStreamLogger();
        this.settings = connectionSettings;
        openConnection();
    }

    public ConnectionManager(ApplicationSettings connectionSettings,LogManager log)     
    throws SAXException, IOException, SQLException  {
        this.log = log;
        this.settings = connectionSettings;
        openConnection();
    }

    public ConnectionManager(String connectionLocation)     
    throws SAXException, IOException, SQLException {
        this.log = new PrintStreamLogger();
        this.settings = new ApplicationSettings(connectionLocation,this.log);
        openConnection();
    }

    public ConnectionManager(String connectionLocation, LogManager log)
    throws SAXException, IOException, SQLException  {
      this.log = log;
      this.settings = new ApplicationSettings(connectionLocation,this.log);
      openConnection();
    }
    
   public void closeConnection(Connection conn)
   throws SQLException {
      if (this.settings.isPooled()) {
       conn.close();
      }
    } 

   public void resetConnection() 
   throws SQLException, IOException  {
     if (!this.connection.isClosed()) {
         closeConnection(this.connection);                
     }
     openConnection();
   }
   

    public Connection getPooledConnection(String schema, String passwd) 
    throws SQLException {
        return this.pds.getConnection(schema,passwd);
    }


    public Connection getConnection(String schema, String passwd) 
    throws SQLException  {
      if (this.settings.isPooled())  {
        return this.getPooledConnection(schema,passwd);
      }
      else
      {
        return this.connection;
      }
    }

    public Connection getConnection() 
    throws SQLException  {
      if (this.settings.isPooled())  {
        return this.getPooledConnection(null,null);
      }
      else
      {
        return this.connection;
      }
    }


    public void createConnectionPool() 
    throws SQLException {
        
        if ( DEBUG ) {
          this.log.log( "ConnectionManager.getConnection(): Creating PDS Connection Pool (UCP)." );
        }

        this.pds = PoolDataSourceFactory.getPoolDataSource();
        this.pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
        this.pds.setUser(this.settings.getSchema());
        this.pds.setPassword(this.settings.getPassword());
        this.pds.setURL(this.getDatabaseURL());

    }
    
    public Connection getODSPooledConnection(String schema, String passwd) 
    throws SQLException {
        return this.ods.getConnection();
    }

    public OracleConnection getConnectionODS(String schema, String passwd)
    throws SQLException {
      if (this.settings.isPooled()) {
        return (OracleConnection) getODSPooledConnection(schema,passwd);
      }
      else {
        return this.connection;
      }
    }

    public void createODSConnectionPool() 
    throws SQLException {
        
        if ( DEBUG ) {
          this.log.log( "ConnectionManager.getConnection(): Creating ODS Connection Pool." );
        }

        this.ods = new OracleDataSource();
        this.ods.setConnectionCachingEnabled(true);    // Turns on caching
        this.ods.setUser(this.settings.getSchema());
        this.ods.setPassword(this.settings.getPassword());
        this.ods.setURL(this.getDatabaseURL());

    }
    
    public Connection getOCIPooledConnection(String schema, String passwd) 
    throws SQLException {
        return this.ociPool.getConnection(schema,passwd);
    }

    public Connection getOCIConnection(String schema, String passwd)
    throws SQLException  {
      if (this.settings.isPooled())  {
        return (OracleOCIConnection) ociPool.getConnection(schema,passwd);
      }
      else
      {
        return this.connection;
      }
    }
    
    public void createOCIConnectionPool()
    throws SQLException {

        if ( DEBUG ) {
          this.log.log( "ConnectionManager.getConnection(): Creating OCI Connection Pool." );
        }

       OracleOCIConnectionPool pool;
       Properties poolConfig  = new Properties( );
       poolConfig.put (OracleOCIConnectionPool.CONNPOOL_MIN_LIMIT, "1");
       poolConfig.put (OracleOCIConnectionPool.CONNPOOL_MAX_LIMIT, "1");
       poolConfig.put (OracleOCIConnectionPool.CONNPOOL_INCREMENT, "0");
       this.ociPool = new OracleOCIConnectionPool(this.settings.getSchema(),this.settings.getPassword(), getDatabaseURL(),poolConfig);
    }

}

