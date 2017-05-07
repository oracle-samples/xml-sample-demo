
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
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;

import java.sql.SQLException;

import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleConnection;
import oracle.jdbc.OraclePreparedStatement;

import oracle.sql.CLOB;

import oracle.xml.parser.v2.XMLDocument;

import org.w3c.dom.Document;

public class RepositoryLogger extends Logger {

    private StringWriter sw;
    private PrintWriter pw;

    private OracleConnection dbConnection = null;
    private OraclePreparedStatement appendLogFile = null;

    private static String CREATE_LOG_FILE =
        "declare " + "res boolean;" + "targetPath varchar2(700);" + "begin" + "  targetPath := :1;" +
        "  if (not dbms_xdb.existsResource(targetPath)) then" + "    res := dbms_xdb.createResource(targetPath,'');" +
        "  end if;" + "end;";

    private static String APPEND_LOG_FILE =
        "declare " + "  pragma autonomous_transaction; " + "  targetPath varchar2(700);" + "  content        BLOB;" +
        "  newContentBlob BLOB;" + "  newContentClob CLOB;" + "  source_offset  integer := 1;" +
        "  target_offset  integer := 1;" + "  warning        integer;" + "  lang_context   integer := 0;   " + "begin" +
        "  targetPath := :1;" + "  newContentClob := :2;" + " " + "  update RESOURCE_VIEW" +
        "     set res = updateXML(res,'/Resource/DisplayName/text()',extractValue(res,'/Resource/DisplayName/text()'))" +
        "   where equals_path(res,targetPath) = 1;" + " " + "  select extractValue(res,'/Resource/XMLLob')" +
        "    into content" + "    from RESOURCE_VIEW" + "   where equals_path(res,targetPath) = 1;" + " " +
        "  dbms_lob.open(content,dbms_lob.lob_readwrite);" +
        "  dbms_lob.createTemporary(newContentBlob,false,DBMS_LOB.CALL);" +
        "  dbms_lob.convertToBlob(newContentBlob,newContentClob,dbms_lob.getLength(newContentClob),source_offset,target_offset,nls_charset_id('AL32UTF8'),lang_context,warning);" +
        "  dbms_lob.append(content,newContentBlob);" + "  dbms_lob.close(content);" +
        "  dbms_lob.freeTemporary(newContentBlob);" + "  commit;" + "end;";

    public void createRepositoryLogFile() throws SQLException {
        OracleCallableStatement stmt =
            (OracleCallableStatement) this.dbConnection.prepareCall(RepositoryLogger.CREATE_LOG_FILE);
        stmt.setString(1, this.logFilePath);
        stmt.execute();
        stmt.close();
        this.dbConnection.commit();
    }

    public RepositoryLogger(OracleConnection conn, String logFilePath) throws SQLException {
        this.dbConnection = conn;
        this.logFilePath = logFilePath;
        createRepositoryLogFile();
        this.appendLogFile =
            (OraclePreparedStatement) this.dbConnection.prepareStatement(RepositoryLogger.APPEND_LOG_FILE);
    }

    private void createPrintWriter() {
        this.sw = new StringWriter();
        this.pw = new PrintWriter(sw);
    }

    public void appendRepositoryLogFile() {
        try {
            this.pw.close();
            Reader reader = new StringReader(this.sw.toString());
            CLOB newContent = CLOB.createTemporary(this.dbConnection, false, CLOB.DURATION_CALL);
            Writer writer = newContent.setCharacterStream(0);
            int n;
            char[] buffer = new char[CLOB.MAX_CHUNK_SIZE];
            while (-1 != (n = reader.read(buffer))) {
                writer.write(buffer, 0, n);
            }
            writer.flush();
            this.appendLogFile.setString(1, this.logFilePath);
            this.appendLogFile.setCLOB(2, newContent);
            this.appendLogFile.execute();
            if (newContent.isOpen()) {
                newContent.close();
            }
            this.dbConnection.commit();
        } catch (SQLException sqle) {
            sqle.printStackTrace(System.out);
        } catch (IOException ioe) {
            ioe.printStackTrace(System.out);
        }
    }

    public synchronized void log(String s) {
        createPrintWriter();
        this.pw.println(s);
        appendRepositoryLogFile();
    }

    public synchronized void log(Document xml) {
        try {
            createPrintWriter();
            ((XMLDocument) xml).print(pw);
            appendRepositoryLogFile();
        } catch (IOException ioe) {
            System.out.println(ioe);
        }
    }

    public synchronized void log(Object object) {
        createPrintWriter();
        this.pw.println(object);
        appendRepositoryLogFile();
    }

    public synchronized void log(Exception e) {
        createPrintWriter();
        e.printStackTrace(pw);
        appendRepositoryLogFile();
    }

    public void close() {
    }
}
