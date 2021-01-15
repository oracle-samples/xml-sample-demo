# Splitting XML

This is an example of how to split a large XML file without a
delimiter using the streaming features of the Oracle XQuery Processor
for Java.

1. Install Java (this was tested with [JDK 8](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html))
   

2. Setup the environment 
``` 
  export JAVA_HOME=...path to installed JDK home directory...
  export DB_HOME=...path to Oracle database home directory...
  export CLASSPATH=$DB_HOME/lib/xmlparserv2_sans_jaxp_services.jar:$DB_HOME/xdk/jlib/apache-xmlbeans.jar:$DB_HOME/jlib/oxquery.jar:$DB_HOME/jlib/xqjapi.jar:.
```

3. Compile the example
```
  > $JAVA_HOME/bin/javac SplitXml.java
```

4. Run the example
```
  > $JAVA_HOME/bin/java SplitXml big_file.xml foo/bar/bat 0.00005
  Writing file big_file.xml.0.split with 2 results processed. 
  Writing file big_file.xml.1.split with 4 results processed. 
  Writing file big_file.xml.2.split with 6 results processed. 
  Writing file big_file.xml.3.split with 8 results processed. 
  Writing file big_file.xml.4.split with 10 results processed. 
  Completed split in 743 ms
```

The example uses a streaming
[XPath](https://www.w3schools.com/xml/xpath_intro.asp) evaluation over
the input file.  It writes the values returned by the XPath expression
to a file with a delimiter character (0x3) between each value.  0x3 is
chosen to avoid a chacater that will occur in the content of the XML
values.  While control characters can occur in XML, the serialization
process will escape them rather than writing them directly. 

# Loading the files into Oracle Database

The output of the above example produces one or more files.  These
files can be loaded into Oracle Database using either an external
table or SQL*Loader.  

- **SQL Loader** has the advantage that it can be run using the Oracle
  instant client from outside the database.  External tables require
  that the data is located in a storage system that is visible to the
  databse.

- **External tables** have the advantage that they can process the
  input files in parallel.  That is, they can load multiple values
  **within** and across files at once.  And external tables expose the
  data to SQL without actually loading it.  For example, you may wish
  to query the data without storing it in the database.  Or, you may
  wish to transform the data using SQL/XML before storing it.

The next two examples show how data produced by this example can be
loaded into Oracle Database.

## Loading using an External Table

You can load the split files using an external table. For example:

```
CREATE DIRECTORY xmldir AS 
  '/path/to/directory/containing/split/files'

CREATE TABLE xmltab_external(c clob)
ORGANIZATION external
(
  TYPE oracle_loader
  DEFAULT DIRECTORY xmldir
  ACCESS PARAMETERS
  (
    RECORDS
    DELIMITED BY X'03'
    CHARACTERSET AL32UTF8
    READSIZE 100000000
    SKIP 0
    FIELDS NOTRIM
    MISSING FIELD VALUES ARE NULL
    (c CHAR(100000000))
  )
  LOCATION ('*.split')
) PARALLEL 10 REJECT LIMIT UNLIMITED
;

CREATE TABLE xmltab 
  PARALLEL 10 AS 
  SELECT xmltype(c) data 
  FROM xmltab_external; 
```

## Loading using sqlldr

You can load the split files using SQL*Loader.

First, create a target table:
```
CREATE TABLE testxml (x xmltype);
```

Create a control file test.ctl:
```
 LOAD DATA 
 CHARACTERSET UTF8
 BYTEORDERMARK NOCHECK
 INFILE 'big_file.xml.*.split' "STR x'03'"
 INTO TABLE testxml APPEND
 FIELDS TERMINATED BY X'02'
 (x char(6000000))
```

Pass it to sqlldr:
```
sqlldr scott/tiger control=test.ctl readsize=10000000 direct=y
```

# References

* [Oracle XQuery Processor For Java](https://docs.oracle.com/en/database/oracle/oracle-database/19/adxdk/using-xquery-processor-for-Java.html)
* [SQL*Loader](https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-sql-loader.html)
* [External Tables](https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-external-tables-concepts.html#GUID-44323E01-7D72-45EC-915A-99E596769D9E)

