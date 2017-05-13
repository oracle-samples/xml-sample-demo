package com.oracle.st.xmldb.pm.saxLoader;

import com.oracle.st.xmldb.pm.common.baseApp.ApplicationSettings;
import com.oracle.st.xmldb.pm.common.baseApp.Logger;

import java.io.IOException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import org.xml.sax.SAXException;

public class ConfigurationManager {
    
    private static final boolean TRACE_XPATH_EXPRESSIONS = false;

    public static final String XML_NAMESPACE_NAMESPACE = "http://www.w3.org/2000/xmlns/";
    public static final String XML_SCHEMA_INSTANCE_NAMESPACE = "http://www.w3.org/2001/XMLSchema-instance";

    public static final String SCHEMA_INSTANCE_PREFIX = "schemaInstancePrefix";
    public static final String SCHEMA_LOCATION = "schemaLocation";
    public static final String NO_NAMESPACE_SCHEMA_LOCATION = "noNamespaceSchemaLocation";

    // Maximum Number of Documents to Insert
    public static final String MAX_DOCUMENTS = "maxDocumentsToLoad";
    // Maximum Number of Writer Thread Failures Permitted
    public static final String MAX_ERRORS = "maxErrors";
    // Maximum Number of SQL Failures before a Writer Thread Aborts. SQL Errors are logged to ERROR_TABLE
    public static final String MAX_SQL_ERRORS = "maxSQLErrors";
    public static final String MAX_SQL_INSERTS = "maxSQLInserts";

    public static final String LOG_FILE_NAME = "LogFileName";

    public static final String THREAD_COUNT_ELEMENT = "ThreadCount";
    public static final String COMMIT_CHARGE_ELEMENT = "CommitCharge";

    public static final String ERROR_TABLE_ELEMENT = "ErrorTable";

    public static final String FILE_LIST_ELEMENT = "FileList"; ;
    public static final String FILE_ELEMENT = "File";

    public static final String FOLDER_LIST_ELEMENT = "FolderList"; ;
    public static final String FOLDER_ELEMENT = "Folder";

    public static final String TABLE_LIST_ELEMENT = "Tables";
    public static final String TABLE_ELEMENT = "Table";
    public static final String COLUMN_ELEMENT = "Column";

    public static final String PROCEDURE_LIST_ELEMENT = "Procedures";
    public static final String PROCEDURE_ELEMENT = "Procedure";
    public static final String ARGUMENT_ELEMENT = "Argument";

    public static final String NAMESPACE_DEFINITIONS = "namespaces";

    public static final String NAME_ATTRIBUTE = "name";
    public static final String PATH_ATTRIBUTE = "path";

    public static final String COLUMN_NAME_ATTRIBUTE = "name";
    public static final String PROCEDURE_NAME_ATTRIBUTE = "procedure";

    public static final String CLIENT_SIDE_ENCODING_ELEMENT = "clientSideEncoding";

    public static final String LOG_SERVER_STATS_ELEMENT = "logServerStats";

    public static final String TEXT_NODE     = "text()";
    public static final String POSITION      = "position()";
    public static final String DOCUMENT_URI  = "document-uri()";
    public static final String DOCUMENT_NAME = "document-name()";
    
    protected Element namespaceMappings;

    // List of Tables
    protected ArrayList<String> tableList = new ArrayList();
    
    // List of Procedures
    protected ArrayList<String> procedureList = new ArrayList();

    // XPath Expressions that mark the start of a row
    protected ArrayList<String> rowXPathList = new ArrayList();

    // Tables indexed by row XPath Expression
    protected HashMap<String,String> rowXPathObjectMappings = new HashMap();

    // Column Lists indexed by row XPath Expression
    protected HashMap<String,String> rowColumnLists = new HashMap();

    // XPath to Column Mappings indexed by row XPath Expression
    protected HashMap<String,HashMap<String,String>> rowXPathTargetMappings = new HashMap();
    
    // XPath Expressions that populate columns from nodes that are sibings or parents of the current row
    protected HashMap<String,ArrayList<String>> rowParentXPathLists = new HashMap();
    
    private Logger logger;
    private ApplicationSettings settings;

    public ConfigurationManager(Logger logger, ApplicationSettings settings) throws IOException, SAXException {
        super();
        this.logger = logger;
        this.settings = settings;
        processTableMappings();
        processProcedureMappings();
        this.namespaceMappings = processNamespacePrefixMappings();
        readWriterConfiguration();
    
        if (TRACE_XPATH_EXPRESSIONS) {
            this.logger.log("Table List:");
            this.logger.log(this.tableList);
            this.logger.log("Procedure List:");
            this.logger.log(this.procedureList);
            this.logger.log("Row XPath Expressions:");
            this.logger.log(this.rowXPathList);
            this.logger.log("XPath to Table/Procedure Mappings:");
            this.logger.log(this.rowXPathObjectMappings);
            this.logger.log("XPath to Column/Argument Lists:");
            this.logger.log(this.rowColumnLists);
            this.logger.log("XPath to Column/Argument Mappings:");
            this.logger.log(this.rowXPathTargetMappings);
            this.logger.log("Parent XPath to Column/Argument Mappings:");
            this.logger.log(this.rowParentXPathLists);
        }
    }

    protected int maxDocuments = 0;
    protected int commitCharge = 1;
    protected int maxSQLErrors = 0;
    protected int maxSQLInserts = 0;
    protected String errorTable = null;
    protected boolean clientSideEncoding = false;
    protected boolean logServerStats = false;
    

    private void readWriterConfiguration() {
        this.maxDocuments = Integer.parseInt(this.settings.getSetting(ConfigurationManager.MAX_DOCUMENTS, "-1"));
        this.commitCharge = Integer.parseInt(this.settings.getSetting(ConfigurationManager.COMMIT_CHARGE_ELEMENT, "50"));
        this.maxSQLErrors = Integer.parseInt(this.settings.getSetting(ConfigurationManager.MAX_SQL_ERRORS, "10"));
        this.maxSQLInserts = Integer.parseInt(this.settings.getSetting(ConfigurationManager.MAX_SQL_INSERTS, "0"));
        this.errorTable = this.settings.getSetting(ConfigurationManager.ERROR_TABLE_ELEMENT);
        this.clientSideEncoding = this.settings.getSetting(ConfigurationManager.CLIENT_SIDE_ENCODING_ELEMENT, "false").equalsIgnoreCase("true");
        this.logServerStats = this.settings.getSetting(ConfigurationManager.LOG_SERVER_STATS_ELEMENT, "false").equalsIgnoreCase("true");

    }
    
    @SuppressWarnings("unchecked")
    public void processTableMappings() throws IOException, SAXException {
        
        /*
         * 
         * Process the set of Table Elements. 
         * 
         * A Table Element consists of an XPath Expression that identifies the Element that contains the node that will be 
         * used to generate a rown in a particular table. Note that a given table may be referenced by more than one Table Element.
         * The table element may contain  one or more column elements.
         * 
         * If the Table Element has no children, it assumed that the target table is an XMLType table and the element
         * identified by the XPath expression will be be inserted as the value of row.
         * 
         * If the Table Element contains column elements then each one specifies the mapping between an XPath Expression
         * and a column of the table. The XPath expressions associated with column elements are relative to the XPath Expression
         * specifed in the parent table element. XPath expressions that terminate in functions such as position() or text()) or 
         * atrributes are mapped to scalar columns. XPath expressions that map to elements are mapped to XMLType columns. 
         * 
         * This function configures the column list need to insert a row into the specified table. 
         */

        Element tables = this.settings.getElement(TABLE_LIST_ELEMENT);
        if (tables != null && tables.hasChildNodes()) {
            NodeList nlTable = tables.getElementsByTagName(ConfigurationManager.TABLE_ELEMENT);
            
            for (int i = 0; i < nlTable.getLength(); i++) {
                String columnList = null;
                ArrayList mappedXPathList     = new ArrayList();
                ArrayList parentXPathList     = new ArrayList();
                HashMap<String,String> xpathColumnMappings = new HashMap(); 

                Element table = (Element) nlTable.item(i);
                
                // Get the Table name and it to the set of known tables.
                String tableName    = table.getAttributeNS("", ConfigurationManager.NAME_ATTRIBUTE);
                if (!this.tableList.contains(tableName)) {
                    this.tableList.add(tableName);
                }
                
                // Get the XPath Expression that identifies the start of a new row.
                String rowXPathExpression = table.getAttributeNS("", ConfigurationManager.PATH_ATTRIBUTE);
                this.logger.log("ConfigurationManager.processTableMappings(): Table \"" + tableName + "\" Row Boundary \"" + rowXPathExpression + "\".");
                if (!this.rowXPathList.contains(rowXPathExpression)) {
                    this.rowXPathList.add(rowXPathExpression);
                }
                
                // Check if there are column mappings for this table.
                if (table.hasChildNodes()) {  
                    // Mapping a relational table. Process the set of column mappings for this table.
                    NodeList nlColumn = table.getElementsByTagName(ConfigurationManager.COLUMN_ELEMENT);
                    for (int j = 0; j < nlColumn.getLength(); j++) {
                        Element column = (Element) nlColumn.item(j);
                        String columnXPathExpression = null;

                        // Get the column name and add it the list of columns for this row.
                        String columnName = column.getAttributeNS("", ConfigurationManager.NAME_ATTRIBUTE);
                        if (columnList == null) {
                            columnList = "\"" + columnName + "\"";
                        } else {
                            columnList = columnList + "," + "\"" + columnName + "\"";
                        }

                        // Get the Xpath expression for this column.
                        String columnXPath = column.getAttributeNS("", ConfigurationManager.PATH_ATTRIBUTE);
                        if (!columnXPath.equals("")) {
                            if (columnXPath.startsWith("/")) {
                                parentXPathList.add(columnXPath);
                                columnXPathExpression = columnXPath;
                            }
                            // TODO: Relative Path Support for parent XPath Expressions
                            else {
                              columnXPathExpression = rowXPathExpression + "/" + columnXPath;
                            }
                        }
                        else {
                          columnXPathExpression = rowXPathExpression;
                        }
                        xpathColumnMappings.put(columnXPathExpression, columnName);
                        this.logger.log("ConfigurationManager.processTableMappings(): Table \"" + tableName + "\" Column \"" + columnName + "\". XPath \"" + columnXPathExpression + "\".");
                    }
                } else {
                    // Mapping a XMLTYPE table
                    columnList = "OBJECT_VALUE";
                    xpathColumnMappings.put(rowXPathExpression, "OBJECT_VALUE");
                    this.logger.log("ConfigurationManager.processTableMappings(): XMLType Table \"" + tableName + "\". XML = \"" + rowXPathExpression + "\".");
                }
                this.rowColumnLists.put(rowXPathExpression, columnList);
                this.rowXPathObjectMappings.put(rowXPathExpression, tableName);  
                this.rowXPathTargetMappings.put(rowXPathExpression, xpathColumnMappings);
                this.rowParentXPathLists.put(rowXPathExpression,parentXPathList);
            }
        }
    }

    public void processProcedureMappings() throws IOException, SAXException {
        
        /*
         * 
         * Process the set of Table Elements. 
         * 
         * A Table Element consists of an XPath Expression that identifies the Element that contains the node that will be 
         * used to generate a rown in a particular table. Note that a given table may be referenced by more than one Table Element.
         * The table element may contain  one or more column elements.
         * 
         * If the Table Element has no children, it assumed that the target table is an XMLType table and the element
         * identified by the XPath expression will be be inserted as the value of row.
         * 
         * If the Table Element contains column elements then each one specifies the mapping between an XPath Expression
         * and a column of the table. The XPath expressions associated with column elements are relative to the XPath Expression
         * specifed in the parent table element. XPath expressions that terminate in functions such as position() or text()) or 
         * atrributes are mapped to scalar columns. XPath expressions that map to elements are mapped to XMLType columns. 
         * 
         * This function configures the column list need to insert a row into the specified table. 
         */

        Element procedureList = this.settings.getElement(PROCEDURE_LIST_ELEMENT);

        if (procedureList != null && procedureList.hasChildNodes()) {
            NodeList nlProcedure = procedureList.getElementsByTagName(ConfigurationManager.PROCEDURE_ELEMENT);
            for (int i = 0; i < nlProcedure.getLength(); i++) {
                String argumentList = null;
        
                ArrayList mappedXPathList       = new ArrayList();
                ArrayList parentXPathList       = new ArrayList();
                HashMap   xpathArgumentMappings = new HashMap(); 

                Element procedure = (Element) nlProcedure.item(i);
                
                // Get the Procedure name and it to the set of known tables.
                String procedureName = procedure.getAttributeNS("", ConfigurationManager.NAME_ATTRIBUTE);
                if (!this.procedureList.contains(procedureName)) {
                    this.procedureList.add(procedureName);
                }
                
                // Get the XPath Expression that identifies the start of a new row.
                String rowXPathExpression = procedure.getAttributeNS("", ConfigurationManager.PATH_ATTRIBUTE);
                this.logger.log("ConfigurationManager.processTableMappings(): Table \"" + procedureName + "\" Row Boundary \"" + rowXPathExpression + "\".");
                if (!this.rowXPathList.contains(rowXPathExpression)) {
                    this.rowXPathList.add(rowXPathExpression);
                }
                
                // Mapping a relational table. Process the set of column mappings for this table.
                NodeList nlColumn = procedure.getElementsByTagName(ConfigurationManager.COLUMN_ELEMENT);
                for (int j = 0; j < nlColumn.getLength(); j++) {
                  Element column = (Element) nlColumn.item(j);
                  String columnXPathExpression = null;

                  // Get the column name and add it the list of columns for this row.
                  String columnName = column.getAttributeNS("", ConfigurationManager.NAME_ATTRIBUTE);
                  if (argumentList == null) {
                    argumentList = "\"" + columnName + "\"";
                  } else {
                    argumentList = argumentList + "," + "\"" + columnName + "\"";
                  }

                  // Get the Xpath expression for this column.
                  String columnXPath = column.getAttributeNS("", ConfigurationManager.PATH_ATTRIBUTE);
                  if (!columnXPath.equals("")) {
                    if (columnXPath.startsWith("/")) {
                      parentXPathList.add(columnXPath);
                      columnXPathExpression = columnXPath;
                    }
                    // TODO: Relative Path Support for parent XPath Expressions
                    else {
                      columnXPathExpression = rowXPathExpression + "/" + columnXPath;
                    }
                  }
                  else {
                    columnXPathExpression = rowXPathExpression;
                  }
                  xpathArgumentMappings.put(columnXPathExpression, columnName);
                  this.logger.log("ConfigurationManager.processTableMappings(): Table \"" + procedureName + "\" Column \"" + columnName + "\". XPath \"" + columnXPathExpression + "\".");
                }
                this.rowColumnLists.put(rowXPathExpression, argumentList);
                this.rowXPathObjectMappings.put(rowXPathExpression, procedureName);  
                this.rowXPathTargetMappings.put(rowXPathExpression,xpathArgumentMappings);
                this.rowParentXPathLists.put(rowXPathExpression,parentXPathList);
            }
        }
    }

    protected Element processNamespacePrefixMappings() {
        Element mappings = this.settings.getElement(NAMESPACE_DEFINITIONS);
        if (mappings == null) {
            mappings = this.settings.getParameterDocument().createElement(NAMESPACE_DEFINITIONS);
        }
        return mappings;
    }

    protected boolean processFileList() {
        Element fl = getFileList();
        if (fl != null) {
          NodeList nl = fl.getElementsByTagName(ConfigurationManager.FILE_ELEMENT);
          return nl.getLength() > 0;
        }
        else {
            return false;
        
        }
    }
    
    protected int getThreadCount() {
        return Integer.parseInt(this.settings.getSetting(THREAD_COUNT_ELEMENT, "4"));
    }
    
    protected Element getFileList() {
        return this.settings.getElement(FILE_LIST_ELEMENT);
    }
    
    protected Element getFolderList() {
      return this.settings.getElement(FOLDER_LIST_ELEMENT);
    } 

    protected boolean isRowXPathExpression(String path) {
        if (TRACE_XPATH_EXPRESSIONS) {
            this.logger.log("ConfigurationManager.isRowXpathExpression(): XPath Expression \"" + path + "\".");
            this.logger.log("ConfigurationManager.isRowXpathExpression(): Row XPath List");
            this.logger.log(this.rowXPathList);
            this.logger.log("\"ConfigurationManager.isRowXpathExpression():" + (this.rowXPathList.contains(path)? true: false));
        }
        return this.rowXPathList.contains(path);
    }
    
    /*

    protected boolean isMappedXPathExpression(String path) {
        if (TRACE_XPATH_EXPRESSIONS) {
            this.logger.log("ConfigurationManager.isMappedXPathExpression(): XPath Expression \"" + path + "\".");
            this.logger.log("ConfigurationManager.isMappedXPathExpression(): Column XPath List");
            this.logger.log(this.xpathTargetMappings.keySet());
            this.logger.log("\"ConfigurationManager.isMappedXPathExpression():" + (this.xpathTargetMappings.containsKey(path)? true: false));
        }
      return this.xpathTargetMappings.containsKey(path);
    }
    
    protected boolean isParentXPathExpression(String path) {
        if (TRACE_XPATH_EXPRESSIONS) {
            this.logger.log("ConfigurationManager.isParentXPathExpression(): XPath Expression \"" + path + "\".");
            this.logger.log("ConfigurationManager.isParentXPathExpression(): Parent XPath List");
            this.logger.log(this.parentXPathList);
            this.logger.log("\"ConfigurationManager.isParentXPathExpression():" + (this.parentXPathList.contains(path)? true: false));
        }
      return parentXPathList.contains(path);
    }
   
    */
}
