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

    protected ArrayList tableList               = new ArrayList();
    protected ArrayList rowXPathList            = new ArrayList();
    protected ArrayList mappedXPathList         = new ArrayList();
    
    protected HashMap xpathColumnNameMappings   = new HashMap();
    protected HashMap xpathArgumentNameMappings = new HashMap();
    
    protected HashMap rowColumnLists            = new HashMap();
    protected HashMap xpathTableNameMapping     = new HashMap();

    protected HashMap procedureArgumentLists = new HashMap();
    protected HashMap xpathProcedureNameMapping = new HashMap();

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
                // Hashtable columnXPathExpressions = new Hashtable();

                Element table = (Element) nlTable.item(i);
                
                String tableName    = table.getAttributeNS("", ConfigurationManager.NAME_ATTRIBUTE);
                if (!this.tableList.contains(tableName)) {
                    this.tableList.add(tableName);
                }

                String rowXPathExpression = table.getAttributeNS("", ConfigurationManager.PATH_ATTRIBUTE);
                if (!this.rowXPathList.contains(rowXPathExpression)) {
                    this.rowXPathList.add(rowXPathExpression);
                }
                
                if (table.hasChildNodes()) {
                    NodeList nlColumn = table.getElementsByTagName(ConfigurationManager.COLUMN_ELEMENT);
                    for (int j = 0; j < nlColumn.getLength(); j++) {
                        Element column = (Element) nlColumn.item(j);
                        String columnXPathExpression = rowXPathExpression;

                        String columnName = column.getAttributeNS("", ConfigurationManager.NAME_ATTRIBUTE);
                        if (columnList == null) {
                            columnList = "\"" + columnName + "\"";
                        } else {
                            columnList = columnList + "," + "\"" + columnName + "\"";
                        }

                        String relativeXPath = column.getAttributeNS("", ConfigurationManager.PATH_ATTRIBUTE);
                        if (!relativeXPath.equals("")) {
                            columnXPathExpression = columnXPathExpression + "/" + relativeXPath;
                        }
                        this.xpathColumnNameMappings.put(columnXPathExpression, columnName);
                        if (!this.mappedXPathList.contains(columnXPathExpression)) {
                            this.mappedXPathList.add(columnXPathExpression);
                        }                        
                        this.logger.log("ConfigurationManager.processTableMappings(): Table \"" + tableName + "\" Column \"" + columnName + "\". Row  = \"" + columnXPathExpression + "\".");
                    }
                } else {
                    columnList = "OBJECT_VALUE";
                    this.xpathColumnNameMappings.put(rowXPathExpression, "OBJECT_VALUE");
                    if (!this.mappedXPathList.contains(rowXPathExpression)) {
                        this.mappedXPathList.add(rowXPathExpression);
                    }                        
                    this.logger.log("ConfigurationManager.processTableMappings(): XMLType Table \"" + tableName + "\". Row = \"" + rowXPathExpression + "\".");
                }
                this.xpathTableNameMapping.put(rowXPathExpression, tableName);                
                this.rowColumnLists.put(rowXPathExpression, columnList);
            }
        }
    }

    @SuppressWarnings("unchecked")
    public void processProcedureMappings() throws IOException, SAXException {

        Element procedureList = this.settings.getElement(PROCEDURE_LIST_ELEMENT);

        if (procedureList != null && procedureList.hasChildNodes()) {
            NodeList nlProcedure = procedureList.getElementsByTagName(ConfigurationManager.PROCEDURE_ELEMENT);
            for (int i = 0; i < nlProcedure.getLength(); i++) {
                String argumentList = null;
                Hashtable argumentXPathExpressions = new Hashtable();

                Element procedure = (Element) nlProcedure.item(i);

                String procedureName = procedure.getAttributeNS("", ConfigurationManager.NAME_ATTRIBUTE);
                String procedureXPathExpression = procedure.getAttributeNS("", ConfigurationManager.PATH_ATTRIBUTE);
                if (!this.rowXPathList.contains(procedureXPathExpression)) {
                    this.rowXPathList.add(procedureXPathExpression);
                }

                NodeList nlArgument = procedure.getElementsByTagName(ConfigurationManager.ARGUMENT_ELEMENT);
                for (int j = 0; j < nlArgument.getLength(); j++) {
                    Element argument = (Element) nlArgument.item(j);
                    String argumentXPathExpression = procedureXPathExpression;
                    String argumentName = argument.getAttributeNS("", ConfigurationManager.NAME_ATTRIBUTE);
                    String relativeXPath = argument.getAttributeNS("", ConfigurationManager.PATH_ATTRIBUTE);
                    if (!relativeXPath.equals("")) {
                        argumentXPathExpression = argumentXPathExpression + "/" + relativeXPath;
                    }
                    this.xpathArgumentNameMappings.put(argumentXPathExpression, argumentName);
                    if (!this.mappedXPathList.contains(argumentXPathExpression)) {
                        this.mappedXPathList.add(argumentXPathExpression);
                    }

                    this.logger.log("ConfigurationManager.processProcedureMappings(): Procedure \"" + procedureName + "\" Argument \"" + argumentName + "\". Source = \"" + argumentXPathExpression + "\".");
                }
                this.xpathProcedureNameMapping.put(procedureXPathExpression, procedureName);
                this.procedureArgumentLists.put(procedureXPathExpression, argumentList);
                // this.procedureXPathExpressions.put(procedureXPathExpression, argumentXPathExpressions);
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
        return this.rowXPathList.contains(path);
    }

    protected boolean isMappedXPathExpression(String path) {
      return this.mappedXPathList.contains(path);
    }
    
}
