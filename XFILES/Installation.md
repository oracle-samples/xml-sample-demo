<span id="_Toc408996329" class="anchor"></span>

Executive Overview
==================

The XFILES application is a web-based application that demonstrates the content management features of the Oracle XML DB repository. The application itself is also a simple demonstration of how easy it is to create an application using XML, HTML and AJAX, that leverages the Oracle XML DB HTTP server and the Database Native Web Services features of Oracle XML DB.

<span id="_Toc408995826" class="anchor"><span id="_Toc408996330" class="anchor"></span></span>Installation Instructions
=======================================================================================================================

Installation is supported for 11.2.0.4.0 and 12.1.0.2.0. For Oracle Database 12c installation, XFiles is supported with the Oracle Multitenant option, but the XFILES application must be installed into a Pluggable Database (PDB).

<span id="_Toc408995827" class="anchor"><span id="_Toc408996331" class="anchor"></span></span>Pre-requisites
------------------------------------------------------------------------------------------------------------

Interactive Installation can only be performed from an MS-Windows environment. Script based installation is available for other environments. The target database can be running on any platform that be accessed via SQL\*NET.

For Interactive installations, the installation directory must be a local drive on the installation machine. The use of network or mapped drives can lead to ‘cross-site’ scripting exceptions being reported by the installation process.

SQL\*PLUS must be installed on the machine that is being used to perform the installation.

Credentials for a user who can connect to the database as SYSDBA as well as normal user. The minimum set of grants for this user is SYSDBA, SESSION, RESOURCE and CREATE PUBLIC SYNONYM. Once the XFILES application has been installed you may drop this user of you desire. In a multitenant environment this user only needs to be created in the PDB that will host the XFILES application. SYS cannot be used for this purpose as SYS can only connect as SYSDBA or SYSOPER.

<span id="_Toc408995828" class="anchor"><span id="_Toc408996332" class="anchor"></span></span>Unlock the Anonymous account
--------------------------------------------------------------------------------------------------------------------------

The ANONYMOUS account must be unlocked.

In Oracle Database 12c, in a multitenant environment the ANONYMOUS account must be unlocked in both the ROOT database and the PDB that will host the XFILES application.

<span id="_Toc408995829" class="anchor"><span id="_Toc408996333" class="anchor"></span></span>Provision Shared Servers
----------------------------------------------------------------------------------------------------------------------

The system must be configured with enough shared servers to support the number of concurrent requests. When working a Browser and AJAX, a single user can make multiple simultaneous HTTP requests to the database. For a single user it is recommended to have a minimum of 5 shared servers configured. In Oracle Database 12c, in a multitenant configuration shared servers, are a property of the consolidated database instance and have to be configured while connected to the root database.

![](/raw/master/XFILES/media/image002.png)

<span id="_Toc408995830" class="anchor"><span id="_Toc408996334" class="anchor"></span></span>Create the XFILES application schema
----------------------------------------------------------------------------------------------------------------------------------

A new database schema must be available to host the XFILES Application. Starting with Oracle Database 12c the schema must be granted, connect, resource and the appropriate tablespace permissions. In Oracle Database 11g the schema must be granted connect and resource.

<span id="_Toc408995831" class="anchor"><span id="_Toc408996335" class="anchor"></span></span>Enable the HTTP Server
--------------------------------------------------------------------------------------------------------------------

The database's native HTTP Server must be enabled. In a multitenant environment the HTTP Server must be enabled for the PDB that will host the XFILES application

In Oracle Database 12c use procedure DBMS\_XDB\_CONFIG.setHttpPort to configure the HTTP Port number. In previous version of Oracle Database procedure DBMS\_XDB.setHttpPort is used. After setting the HTTP port execute the command alter system register to make sure that the database is correctly registered with the listener.

![](/raw/master/XFILES/media/image003.png)

<span id="_Toc408995832" class="anchor"><span id="_Toc408996336" class="anchor"></span></span>Verifying that the Database's HTTP server is running
--------------------------------------------------------------------------------------------------------------------------------------------------

Execute the command **lsnrctl status** in target database's Oracle Home.

![](/raw/master/XFILES/media/image004.png)

The output of the lsnrctl command should include the following if the listener is correctly configured for HTTP.

**(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=80))(PROTOCOL\_STACK=(PRESENTATION=HTTP)(SESSION=RAW))) **

Note that the value of the PORT entry should match the port number specified in the call to DBMS\_XDB\_CONFIG.SETHTTPPORT() and that the value of the HOST entry should match the hostname or ip-address that clients will use when connecting to the database’s HTTP service.

<span id="_Toc408995833" class="anchor"><span id="_Toc408996337" class="anchor"></span></span>Verify that the Database’s HTTP service is reachable
--------------------------------------------------------------------------------------------------------------------------------------------------

Use a browser to verify that the HTTP service reachable. Start a browser on the installation machine and enter the following URL: HTTP://hostname:port. Hostname should be the ipaddress of the machine hosting the Oracle Database and port should match the value set using the setHttpPort method.. The database will respond with an HTTP Authentication Request dialog. Enter a valid database username and password and click OK.

Starting with Oracle Database 12c, as a consequence of enabling digest support, the username provided during HTTP Authentication is case sensitive, so standard database usernames, such as SYSTEM or XFILES must be entered in uppercase. In Oracle Database 11g, which uses basic authentication, usernames are case insensitive.

If everything is installed and configured correctly the database should respond with an HTTP page similar to the one shown below.

![](/raw/master/XFILES/media/image005.png)

<span id="_Toc310240961" class="anchor"></span>

<span id="_Toc408995834" class="anchor"><span id="_Toc408996338" class="anchor"></span></span>Enable Basic Authentication for the Web Client service.
-----------------------------------------------------------------------------------------------------------------------------------------------------

Oracle Database 12c supports Digest authentication so this step is only required when working with Oracle Database 11g Release 2 and earlier.

The Microsoft Windows Web Client service is responsible for providing WebDAV support to Windows applications. By default the Web Client service only supports digest Authentication. Digest authentication support is a feature of Oracle Database 12c. When working with older versions of Oracle Database it is necessary to configure the Microsoft Web Client to support Basic Authentication.

The Microsoft article: <http://support.microsoft.com/kb/841215> provide instructions on how to enable basic authentication with the Microsoft Web Client. The instructions for Windows Vista also apply to Windows 7 and Windows 8. Note you must restart the Web Client service after making these changes for them to take effect

<span id="_Toc408995835" class="anchor"><span id="_Toc408996339" class="anchor"></span></span>Download and extract the Installation media
-----------------------------------------------------------------------------------------------------------------------------------------

Download the latest version of the application from GitHub. The application can be found [here](https://github.com/oracle/xml-sample-demo/).

![](/raw/master/XFILES/media/image006.png)

Use the Download Zip button to download the contents of the GitHub repository. The Zip file will be called xml-sample-demo-master.zip.

<span id="_Toc310240962" class="anchor"><span id="_Toc408995836" class="anchor"><span id="_Toc408996340" class="anchor"></span></span></span>Windows Installation
=================================================================================================================================================================

Note that installing the XFILES application also installs the XDBPM utilities. This means that the installation process will drop and recreate the locked database schema XDBPM.

![](/raw/master/XFILES/media/image007.png)

<span id="_Toc310240963" class="anchor"></span>

<span id="_Toc408995837" class="anchor"><span id="_Toc408996341" class="anchor"></span></span>Locate the Install Folder
-----------------------------------------------------------------------------------------------------------------------

The install folder is a sub-folder of the XFILES folder.

<span id="_Toc408995838" class="anchor"><span id="_Toc408996342" class="anchor"></span></span>Set correct permissions on the installer files.
---------------------------------------------------------------------------------------------------------------------------------------------

The install folder contains the files needed to perform the installation. The install is performed using a HTML Application file (**install.hta**) which invokes a VBScript (**install.vbs**). In some cases windows may block these files from accessing remote resources. This can prevent the installation from running successfully against a remote database. To ensure that the **install.hta**, and **install.vbs** files are not blocked, right click on each file and select properties

![](/raw/master/XFILES/media/image008.png)

If the General Tab of the properties dialog of either file contains an “unblock” button, click it to allow the file to execute normally.

<span id="_Toc408995839" class="anchor"><span id="_Toc408996343" class="anchor"></span></span>Launch the Installer
------------------------------------------------------------------------------------------------------------------

Launch the Installer by typing install.hta at a command prompt or clicking on the install.hta icon. Assuming the archive containing the version 5 of installation media has been downloaded to c:\\temp the following shows how to complete this process.

![](/raw/master/XFILES/media/image009.png)

Launching the installer

<span id="_Toc310240965" class="anchor"><span id="_Toc408995840" class="anchor"><span id="_Toc408996344" class="anchor"></span></span></span>Perform the Installation
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

The installer application provides a simple GUI interface that is used to supply parameters to the installation process.

![](/raw/master/XFILES/media/image010.png)

Select the correct Oracle Home for the SQL\*PLUS installation. Make sure that all fields contain the appropriate values for your environment, enter the required passwords and click install. The field DBA User must be set to a user who has been granted permissions to connect normally and as SYSDBA.

The system will report when the installation is complete. The results of the installation can be found in the installation.log file.

![](/raw/master/XFILES/media/image011.png)

The results of the installation can be found in the installation.log file.

<span id="_Toc408995841" class="anchor"><span id="_Toc408996345" class="anchor"></span></span>Verify the Installation was successful
------------------------------------------------------------------------------------------------------------------------------------

Once the Installation has completed successfully you can launch the application by opening a browser and navigate to the following URL http://hostname:port/XFILES. Hostname and port number should match the values used for the installation.

![](/raw/master/XFILES/media/image012.png)

<span id="_Toc408995842" class="anchor"><span id="_Toc408996346" class="anchor"></span></span>Linux Installation
================================================================================================================

A simple install script is provided to allow XFILES to be installed from a Linux command shell. Unzip the archive generated by GitHub

![](/raw/master/XFILES/media/image013.png)

The demonstration is installed using the XFILES.sh script found in the folder xml-sample-demo-master/master/XFILES/install.

To run the installation script first set the current directory to the install directory. Make sure that the environment variables ORACLE\_HOME and ORACLE\_SID are set correctly.Invoke the XFILES.sh script passing the following arguments on the command line

1.  DBA User. This must be a DBA with SYSDBA privlidges

2.  The password for the DBA user

3.  The XFILES application schema

4.  The password for the XFILES application schema

5.  The URL of the Database’s HTTP Listener.

![](/raw/master/XFILES/media/image014.png)

Once the script has completed check the XFILES.log file for any errors and then verify that XFILES was installed correctly by opening a browser and navigating to the XFILES folder, which can be found in the root of the XML DB repository

![](/raw/master/XFILES/media/image015.png) 


