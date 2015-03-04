An Oracle White Paper

March 3, 2015

Installing Oracle XML DB example applications

[Executive Overview 2](#executive-overview)

[Installation Instructions 2](#installation-instructions)

[Pre-requisites 2](#pre-requisites)

[Verify that the XFILES application is installed correctly. 3](#verify-that-the-xfiles-application-is-installed-correctly.)

[Download and extract the Installation media 4](#_Toc413168751)

[Windows Installation 5](#_Toc413168752)

[Locate the Install Folder 6](#locate-the-install-folder)

[Set correct permissions on the installer files. 6](#set-correct-permissions-on-the-installer-files.)

[Launch the Installer 7](#_Toc413168755)

[Perform the Installation 7](#_Toc413168756)

[Linux Installation 9](#linux-installation)

[Verify the Installation was successful 11](#verify-the-installation-was-successful)

Executive Overview
==================

The XML DB INTRODUCTION example is a browser based demonstration that provides a brief overview of how to store, index, query and update XML content stored in Oracle Database 12c.

Installation Instructions
=========================

Installation is supported for 11.2.0.4.0 and 12.1.0.2.0. For Oracle Database 12c installation, the example can be installed in conjunction with the Oracle Multitenant option, but example must be installed into a Pluggable Database (PDB).

Pre-requisites
--------------

-   The XFILES application must be installed prior to installing the example code.

-   Interactive installation is only supported under MS-Windows. Script based installation is available for other environments. The target database can be running on any platform as long as that database can be accessed via SQL\*NET.

-   For Interactive installations, the installation directory must be a local drive on the installation machine. The use of network or mapped drives can lead to ‘cross-site’ scripting exceptions being reported by the installation process.

-   SQL\*PLUS must be installed on the machine that is being used to perform the installation.

-   Credentials are required for two users. The first is a user how has been granted the DBA role. The second is the user who will be used to run the example code. In a multitenant environment these must exist in the PDB that hosts the XFILES application.

Verify that the XFILES application is installed correctly.
----------------------------------------------------------

Use a browser to verify that the XFILES application has been installed correctly. Start a browser on the installation machine and enter the following URL: HTTP://hostname:port/XFILES. Hostname should be the ip-address of the machine hosting the Oracle Database and port should be the port number allocated to the database’s native HTTP Server. If everything is installed and configured correctly the database should respond with an HTTP page similar to the one shown below.

![](media/image3.png)

Click the “Login Icon”[ ![](media/image4.png)]. The browser will request HTTP authentication.

![](media/image5.png)

Confirm that the user that will be used to run the example code can login to the XFILES applicaiton. Note that the username and password are both case sensitive, and that a database user name is typically uppercase (unless the user was created using as a quoted identifier). If the user cannot login to XFILES ensure that they have been granted XFILES\_USER role.

<span id="_Toc310240961" class="anchor"><span id="_Toc413168751" class="anchor"></span></span>Download and extract the Installation media
-----------------------------------------------------------------------------------------------------------------------------------------

Download the latest version of the application from GitHub. The application can be found [here](https://github.com/oracle/xml-sample-demo).

![](media/image6.png)

Use the Download Zip button to download the contents of the GitHub repository. The Zip file will be called xml-sample-demo-master.zip.

<span id="_Toc310240962" class="anchor"><span id="_Toc413168752" class="anchor"></span></span>Windows Installation
==================================================================================================================

Unzip the archive. This will create a folder called xml-sample-demo-master with a subfolder INTRODUCTION.

![](media/image7.png)

<span id="_Toc310240963" class="anchor"></span>

Locate the Install Folder
-------------------------

The install folder is a sub-folder of the INSTALLATION folder.

Set correct permissions on the installer files.
-----------------------------------------------

The install folder contains the files needed to perform the installation. The install is performed using a HTML Application file (**install.hta**) which invokes a VBScript (**install.vbs**). In some cases windows may block these files from accessing remote resources. This can prevent the installation from running successfully against a remote database. To ensure that the **install.hta**, and **install.vbs** files are not blocked, right click on each file and select properties

![](media/image8.png)

If the General Tab of the properties dialog of either file contains an “unblock” button, click it to allow the file to execute normally.

<span id="_Toc413168755" class="anchor"></span>

Launch the Installer
--------------------

Launch the Installer by typing install.hta at a command prompt or clicking on the install.hta icon. The exact path to the “install” folder will depend on which example is being installed and which directory was the target for the unzip operation.

![](media/image9.png)

<span id="_Toc310240965" class="anchor"><span id="_Toc413168756" class="anchor"></span></span>Perform the Installation
----------------------------------------------------------------------------------------------------------------------

The installer application provides a simple GUI interface that is used to supply parameters to the installation process.

![](media/image10.png)

Select the correct Oracle Home for the SQL\*PLUS installation. Make sure that all fields contain the appropriate values for your environment, enter the required passwords and click install. The field DBA User must be set to a user who has been granted permissions to connect normally and as DBA. If you are not sure of the correct values for HTTP and FTP port numbers these can be automatically detected using the the “Load Ports” button. The system will report when the installation is complete.

![](media/image11.png)

The results of the installation can be found in the INTRODUCTION.log file.

Linux Installation
==================

A simple install script is provided to allow XFILES to be installed from a Linux command shell. Unzip the archive generated by GitHub

![](media/image12.png)

The demonstration is installed using the INTRODUCTION.sh script found in the folder xml-sample-demo/ /INTRODUCTION/install.

To run the installation script first set the current directory to the install directory. Make sure that the environment variables ORACLE\_HOME and ORACLE\_SID are set correctly.Invoke the XFILES.sh script passing the following arguments on the command line

DBA User. This must be a DBA

The password for the DBA user

The username that will be used to run the example

The password for the user

The URL of the Database’s HTTP Listener.

![](media/image13.png)

Verify the Installation was successful
======================================

Once the script has completed check the INTRODUCTION.log file for any Verify that the installation completed successfully by opening a browser and navigating to the following URL http://hostname:port/XFILES. Login as the user specified during the installation procedure and click on the “Home” button [![](media/image14.png)].

This will display the user’s home folder

![](media/image15.png)

If the demonstration was installed successfully, the home folder should contain a folder call demonstrations which will contain a folder called “Introduction”.

Navigate to the “Introduction” folder and click the index.html file. This should open a new browser tab or window, ready to run the first step of the example.

![](media/image16.png)

| ![](media/image17.png)           | ![](media/image18.png)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
|----------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| White Paper Title                
 [Month] 2013                      
 Author: [OPTIONAL]                
 Contributing Authors: [OPTIONAL]  
                                   
 Oracle Corporation                
 World Headquarters                
 500 Oracle Parkway                
 Redwood Shores, CA 94065          
 U.S.A.                            
                                   
 Worldwide Inquiries:              
 Phone: +1.650.506.7000            
 Fax: +1.650.506.7200              
                                   
 oracle.com                        | Copyright © 2013, Oracle and/or its affiliates. All rights reserved.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                                    This document is provided for information purposes only, and the contents hereof are subject to change without notice. This document is not warranted to be error-free, nor subject to any other warranties or conditions, whether expressed orally or implied in law, including implied warranties and conditions of merchantability or fitness for a particular purpose. We specifically disclaim any liability with respect to this document, and no contractual obligations are formed either directly or indirectly by this document. This document may not be reproduced or transmitted in any form or by any means, electronic or mechanical, for any purpose, without our prior written permission.  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                                    Oracle and Java are registered trademarks of Oracle and/or its affiliates. Other names may be trademarks of their respective owners.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                                    ![](media/image19.png)Intel and Intel Xeon are trademarks or registered trademarks of Intel Corporation. All SPARC trademarks are used under license and are trademarks or registered trademarks of SPARC International, Inc. AMD, Opteron, the AMD logo, and the AMD Opteron logo are trademarks or registered trademarks of Advanced Micro Devices. UNIX is a registered trademark of The Open Group. 0113                                                                                                                                                                                                                                                                                                 |


