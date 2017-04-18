
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

import java.sql.SQLException;

import java.text.SimpleDateFormat;

import java.util.Date;

import java.util.Properties;

import oracle.jdbc.OracleConnection;
import oracle.jdbc.OracleDriver;
import oracle.jdbc.pool.OracleDataSource;

import oracle.ucp.jdbc.PoolDataSourceFactory;
import oracle.ucp.jdbc.PoolDataSource;


public class ConnectionManager {

    public static final boolean DEBUG = false;

    private PoolDataSource pds = PoolDataSourceFactory.getPoolDataSource();
    private boolean connectionPoolReady = false;
    private ApplicationSettings connectionProps;
    
    private Logger logger = new PrintStreamLogger();

    public ConnectionManager() {
        super();
    }

    public static ConnectionManager getConnectionManager() throws IOException {
        ConnectionManager mgr = new ConnectionManager();
        mgr.setConnectionProperties(ApplicationSettings.getApplicationSettings());
        return mgr;
    }

    public static ConnectionManager getConnectionManager(ApplicationSettings settings, Logger logger) throws IOException {
        ConnectionManager mgr = new ConnectionManager();
        mgr.setConnectionProperties(settings);
        mgr.setLogger(logger);
        return mgr;
    }

    public void setConnectionProperties(ApplicationSettings settings) {
        this.connectionProps = settings;
    }
    
    public void setLogger(Logger logger){
        this.logger = logger;
        this.connectionProps.setLogger(logger);
    }

    private String getDatabaseURL() {
        if (this.connectionProps.getDriver().equalsIgnoreCase(ApplicationSettings.THIN_DRIVER)) {
            return "jdbc:oracle:thin:@//" + this.connectionProps.getHostname() + ":" + this.connectionProps.getPort() + "/" +
                   this.connectionProps.getServiceName();
        } else {
            return "jdbc:oracle:oci8:@(description=(address=(host=" + this.connectionProps.getHostname() +
                   ")(protocol=tcp)(port=" + this.connectionProps.getPort() + "))(connect_data=(service_name=" +
                   this.connectionProps.getServiceName() + ")(server=" + this.connectionProps.getServerMode() + ")))";
        }
    }

    private String getOracleDataSourceURL() {
        if (DEBUG) this.logger.log("getDatabaseURL() : Driver = " + this.connectionProps.getDriver());
        if (this.connectionProps.getDriver() != null) {
            if (this.connectionProps.getDriver().equalsIgnoreCase(ApplicationSettings.THIN_DRIVER)) {
                return this.connectionProps.getHostname() + ":" + this.connectionProps.getPort() + "/" +
                       this.connectionProps.getServiceName();
            } else {
                return "(description=(address=(host=" + this.connectionProps.getHostname() + ")(protocol=tcp)(port=" +
                       this.connectionProps.getPort() + "))(connect_data=(service_name=" + this.connectionProps.getServiceName() +
                       ")(server=" + this.connectionProps.getServerMode() + ")))";
            }
        } else {
            return null;
        }
    }
    
    public OracleConnection getConnection() throws SQLException, IOException {
        
      if (this.connectionPoolReady) {
        return (OracleConnection) this.pds.getConnection();   
      } 
               
      String driver = this.connectionProps.getDriver();
      if ((driver == null) || (driver.length() == 0)) {
        throw new SQLException("Invalid driver specified in connection properties file.");
      }

      if (driver.equalsIgnoreCase(ApplicationSettings.INTERNAL_DRIVER)) {
        if (DEBUG) this.logger.log("Attempting connection using \"" + driver + "\" driver." );
        OracleDriver ora = new OracleDriver();
        return (OracleConnection) ora.defaultConnection();
      }
    
      String schema = this.connectionProps.getSchema();
      if ((schema == null) || (schema.length() == 0)) {
         throw new SQLException("[ConnectionManager.getConnectionDetails()]: Invalid schema specified in connection properties file.");
      }

      String password = this.connectionProps.getPassword();
      if ((password == null) || (password.length() == 0)) {
        throw new SQLException("[ConnectionManager.getConnectionDetails()]Invalid password specified in connection properties file.");
      }

      String tnsnamesLocation = this.connectionProps.getTNSAdmin();
      if ((tnsnamesLocation != null) && (tnsnamesLocation.length() > 0)) {
          System.setProperty("oracle.net.tns_admin", tnsnamesLocation);
      }

      if (System.getProperty("oracle.net.tns_admin") != null) {
        if (DEBUG) this.logger.log("[ConnectionManager.getConnectionDetails()]: Using connection information from TNSNAMES.ora located in \"" + System.getProperty("oracle.net.tns_admin") + "\"." );
      }
        
      String tnsAlias = this.connectionProps.getTNSAlias();
      if (tnsAlias != null) {
        if (DEBUG) this.logger.log("[ConnectionManager.getConnection()]: Attempting connection to \"" + tnsAlias + "\" using \"" + this.connectionProps.getDriver() + "\" driver as user \"" + schema +"\"." );
        return createConnection(driver,schema,password,tnsAlias);
      }
      else {
        String dataSourceURL = getDatabaseURL();
        if (DEBUG) this.logger.log("[ConnectionManager.getConnection()]: Attempting connection using \"" + dataSourceURL + "\"." );
        return createNewConnection(schema, password, dataSourceURL);
      }
    }  
    
    private OracleConnection createConnection(String driver, String schema, String password, String tnsAlias) throws SQLException,
                                                                                                      IOException {
        
        if (this.connectionProps.useConnectionPool()) {
          return initializeConnectionPool1(schema,password,tnsAlias);
        }
        else {
          return createNewConnection(driver,schema,password,tnsAlias);        }
    }

    private OracleConnection initializeConnectionPool1(String schema, String password, String tnsAlias) throws SQLException, IOException {

        pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
        pds.setUser(schema);
        pds.setPassword(password);
        pds.setURL("jdbc:oracle:thin:@" + tnsAlias);
        this.connectionPoolReady = true;
        return (OracleConnection) pds.getConnection();
    }
   
    private OracleConnection createNewConnection(String driver, String schema, String password, String tnsAlias) throws SQLException {

       OracleDataSource ods = new OracleDataSource();
       ods.setUser(schema);
       ods.setPassword(password);
       ods.setDriverType(driver);
       ods.setTNSEntryName(tnsAlias);
       return (OracleConnection) ods.getConnection();
    }
    
    private OracleConnection initializeConnectionPool2(String schema, String password, String dataSourceURL) throws SQLException, IOException {
       pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
       pds.setUser(schema);
       pds.setPassword(password);
       pds.setURL(dataSourceURL);
       this.connectionPoolReady = true;
       return (OracleConnection) pds.getConnection();
    }

    private OracleConnection createNewConnection(String schema, String password, String dataSourceURL) throws SQLException {

       OracleDataSource ods = new OracleDataSource();
       ods.setUser(schema);
       ods.setPassword(password);
       ods.setURL(dataSourceURL);
       return (OracleConnection) ods.getConnection();

    }
}
