# xml-sample-demo
<span id="_Toc408996329" class="anchor"></span>

Executive Overview
==================

The xml-sample-demo repository contains a set of downloadable and installable demonstrations for Oracle XML DB. Each demonstraiton  can be installed independantly of any of the other demonstrations. Each demonstration has it's own folder within the xml-sample-demo repository. However in order to install and run any of the demonstrations the XFILES application must be installed first.

The XFILES application is a web-based application that demonstrates the content management features of the Oracle XML DB repository. The application itself is also a simple demonstration of how easy it is to create an application using XML, HTML and AJAX, that leverages the Oracle XML DB HTTP server and the Database Native Web Services features of Oracle XML DB. It also provides a live demonstration facility that allows other XML DB demonstrations to be run in a browser. More information on how to download, install and run the application can be found in the installation.md file located in the XFILES folder.

The INTRODUCTION example provides a simple introduction to storing, indexing, updating and querying XML document with Oracle Database. It is based on XML Schema and Object-Relational storage. More information on how to download, install and run the INTRODUCTION example can be found in the installation.md file located in the INTRODUCTION folder.

THe EVOLUTION example provides details of how to manage changes to XML Schemas that have been registered with XMLDB and used to optimize storage, indexing and query operations on XML documents stored in the database. In explains how to use the W3C XML Schema standard's extension mechanism to create an extension XML Schema that defines additive changes to an XML Schema already registered with XMLDB, and how to register the extension XML schema with the database. It also shows how to use in-place and copy based evolution to update an existing XML schema without making use of the extension mechanism. More information on how to download, install and run the EVOLUTION example can be found in the installation.md file located in the EVOLUTION folder.

The PARITITIONING example shows how to partition XML data based on the contents of the XML documents. It is primarily focused on partitioning of Schema based XML that has been stored using the Object-Relational storage mechanism. More information on how to download, install and run the PARITITIONING example can be found in the installation.md file located in the PARITITIONING folder.

The GENERATION example shows how to use SQL/XML functionality to generate XML documents from relational data. It also shows how relational data can be viewed as XML content and queried using XQuery. More information on how to download, install and run the GENERATION example can be found in the installation.md file located in the GENERATION folder.

The NVPair example shows the preferred mechansim for using XML to represent name-value pairs. This demo explains an XML Schema that can be used for name-value pair storage, the supports strong data-typing of the value (enabling enforcement of number, string, date etc), and how to index this model to achieve optimial performance. More information on how to download, install and run the NVPair example can be found in the installation.md file located in the NVPair folder.

The XQUERY example show how to write 'pure' XQUery based applications against XMLDB. It shows how XMLTable allows all of your
queries to be expressed as XQuery with having to make any use of SQL. More information on how to download, install and run the XQUERY example can be found in the installation.md file located in the XQUERY folder.

The FULLTEXT example provides a basic introduction to the XQuery Full-Text standard. It shows how to perform full-text (keywork, phrase, etc) searching of XML content stored in XMLDB. It also explains how to index XML content stored in XMLDB to optimize XQuery Full-Text expressions. More information on how to download, install and run the FULLTEXT example can be found in the installation.md file located in the FULLTEXT folder.

The ImageMetadata example shows how to automate the processing of content stored in the XML DB repository. It provides an example of using an XML Schema to manage additional metadata about documents stored in the repository and how to use a repository event to trigger the automatic processing of these documents . This particular example shows how to automate the extraction of metadata from Images using Oracle Intermedia, and how to make the metadata searchable. More information on how to download, install and run the ImageMetadata example can be found in the installation.md file located in the ImageMetadata folder.
