
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

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.io.Writer;

import java.lang.management.ManagementFactory;
import java.lang.management.ThreadMXBean;

import java.sql.Connection;
import java.sql.SQLException;

import java.text.SimpleDateFormat;

import java.util.GregorianCalendar;
import java.util.TimeZone;

import oracle.jdbc.OracleConnection;

import oracle.jdbc.OraclePreparedStatement;

import oracle.jdbc.OracleResultSet;

import oracle.sql.CLOB;

import org.xml.sax.SAXException;

public abstract class BaseApplication {

    public static final int BYTES_SENT_BY_SERVER_11_2_0_3_0 = 589;
    public static final int BYTES_READ_BY_SERVER_11_2_0_3_0 = 590;
    public static final int NETWORK_ROUNDTRIPS_11_2_0_3_0 = 591;

    public static final int BYTES_SENT_BY_SERVER_11_2_0_4_0 = 630;
    public static final int BYTES_READ_BY_SERVER_11_2_0_4_0 = 631;
    public static final int NETWORK_ROUNDTRIPS_11_2_0_4_0 = 632;

    public static final int BYTES_SENT_BY_SERVER_12_1_0_1_0 = 779;
    public static final int BYTES_READ_BY_SERVER_12_1_0_1_0 = 780;
    public static final int NETWORK_ROUNDTRIPS_12_1_0_1_0 = 781;

    public static final int BYTES_SENT_BY_SERVER_12_1_0_2_0 = 985;
    public static final int BYTES_READ_BY_SERVER_12_1_0_2_0 = 986;
    public static final int NETWORK_ROUNDTRIPS_12_1_0_2_0 = 987;

    public static final int BYTES_SENT_BY_SERVER_12_2_0_1_0 = 1707;
    public static final int BYTES_READ_BY_SERVER_12_2_0_1_0 = 1708;
    public static final int NETWORK_ROUNDTRIPS_12_2_0_1_0 = 1709;

    public static final int BYTES_SENT_BY_SERVER_12_2_0_2_0 = 1707;
    public static final int BYTES_READ_BY_SERVER_12_2_0_2_0 = 1708;
    public static final int NETWORK_ROUNDTRIPS_12_2_0_2_0 = 1709;

    public Logger logger;
    public ConnectionManager connectionManager;
    public ApplicationSettings settings;

    private OraclePreparedStatement getStats;

    public BaseApplication() throws SAXException, IOException, SQLException {
    }

    public String getSetting(String name, String defaultValue) {
        return this.settings.getSetting(name, defaultValue);
    }

    public String getSetting(String name) {
        return this.settings.getSetting(name);
    }

    public String getDriver() {
        return this.settings.getDriver();
    }

    public abstract void doSomething(String[] args) throws Exception;

    public void writeToClob(CLOB clob, InputStream is) throws SQLException, IOException {
        InputStreamReader reader = new InputStreamReader(is);
        Writer writer = clob.setCharacterStream(0);

        char[] buffer = new char[clob.getChunkSize()];
        for (int charsRead = reader.read(buffer); charsRead > -1; charsRead = reader.read(buffer)) {
            writer.write(buffer, 0, charsRead);
        }
        writer.close();
        reader.close();
    }

    public void initStatistics(Connection conn) throws SQLException {

        String dbVersion = null;
        OraclePreparedStatement ops =
            (OraclePreparedStatement) conn.prepareCall("select VERSION from V$INSTANCE");
        OracleResultSet rs = (OracleResultSet) ops.executeQuery();
        while (rs.next()) {
            dbVersion = rs.getString(1);
        }
        rs.close();
        ops.close();

        this.getStats =
            (OraclePreparedStatement) conn.prepareCall("select\n" +
                                                                  "(select VALUE from V$MYSTAT where statistic#=:1) BYTES_SENT,\n" +
                                                                  "(select VALUE from V$MYSTAT where statistic#=:2) BYTES_READ,\n" +
                                                                  "(select VALUE from V$MYSTAT where statistic#=:3) ROUND_TRIPS,\n" +
                                                                  "(select VALUE from v$sess_time_model where stat_name = 'DB CPU' and SID =  sys_context('USERENV','SID')) DB_CPU\n" +
                                                                  "from dual");
        switch (dbVersion) {
          case  "11.2.0.3.0" :
            getStats.setInt(1, BaseApplication.BYTES_SENT_BY_SERVER_11_2_0_3_0);
            getStats.setInt(2, BaseApplication.BYTES_READ_BY_SERVER_11_2_0_3_0);
            getStats.setInt(3, BaseApplication.NETWORK_ROUNDTRIPS_11_2_0_3_0);
            break;  
          case "11.2.0.4.0":
            getStats.setInt(1, BaseApplication.BYTES_SENT_BY_SERVER_11_2_0_3_0);
            getStats.setInt(2, BaseApplication.BYTES_READ_BY_SERVER_11_2_0_3_0);
            getStats.setInt(3, BaseApplication.NETWORK_ROUNDTRIPS_11_2_0_3_0);
            break;
            case "12.1.0.1.0":
            getStats.setInt(1, BaseApplication.BYTES_SENT_BY_SERVER_12_1_0_1_0);
            getStats.setInt(2, BaseApplication.BYTES_READ_BY_SERVER_12_1_0_1_0);
            getStats.setInt(3, BaseApplication.NETWORK_ROUNDTRIPS_12_1_0_1_0);
            break;
          case "12.1.0.2.0":
            getStats.setInt(1, BaseApplication.BYTES_SENT_BY_SERVER_12_1_0_2_0);
            getStats.setInt(2, BaseApplication.BYTES_READ_BY_SERVER_12_1_0_2_0);
            getStats.setInt(3, BaseApplication.NETWORK_ROUNDTRIPS_12_1_0_2_0);
            break;
          case "12.2.0.1.0":
            getStats.setInt(1, BaseApplication.BYTES_SENT_BY_SERVER_12_2_0_1_0);
            getStats.setInt(2, BaseApplication.BYTES_READ_BY_SERVER_12_2_0_1_0);
            getStats.setInt(3, BaseApplication.NETWORK_ROUNDTRIPS_12_2_0_1_0);
            break;
        }

    }

    public void closeStatistics() throws SQLException {
        this.getStats.close();
    }

    public long[] getStatistics() throws SQLException {
        OracleResultSet rs;
        long bytesReadByServer = 0;
        long bytesSentByServer = 0;
        long networkRoundTrips = 0;
        long dbCPU = 0;
        long clientCPU = 0;

        rs = (OracleResultSet) this.getStats.executeQuery();
        while (rs.next()) {
            bytesSentByServer = rs.getNUMBER(1).longValue();
            bytesReadByServer = rs.getNUMBER(2).longValue();
            networkRoundTrips = rs.getNUMBER(3).longValue();
            dbCPU = rs.getNUMBER(4).longValue();
        }
        rs.close();

        ThreadMXBean bean = ManagementFactory.getThreadMXBean();
        clientCPU = bean.isCurrentThreadCpuTimeSupported() ? bean.getCurrentThreadCpuTime() : 0L;

        return new long[] {
               bytesReadByServer, bytesSentByServer, networkRoundTrips, dbCPU, clientCPU, System.currentTimeMillis() };

    }

    public void printStatistics(String title, long[] start, long[] end) {
        printStatistics(title, start, end, System.out);
    }

    public void printStatistics(String title, long[] start, long[] end, PrintStream ps) {

        SimpleDateFormat elapsedTimeFormatter = new SimpleDateFormat("HH:mm:ss.SSS");
        GregorianCalendar cal = new GregorianCalendar();
        elapsedTimeFormatter.setTimeZone(TimeZone.getTimeZone("GMT+0"));
        long elapsedTime = end[5] - start[5];
        cal.setTimeInMillis(elapsedTime);
        String formattedElapsedTime = elapsedTimeFormatter.format(cal.getTime());

        ps.println(title);
        ps.println("Bytes Sent From Client = " + String.format("%1$" + 14 + "s", (end[0] - start[0])));
        ps.println("Bytes Sent to Client   = " + String.format("%1$" + 14 + "s", (end[1] - start[1])));
        ps.println("Network Roundtrips     = " + String.format("%1$" + 14 + "s", (end[2] - start[2])));
        ps.println("DB CPU                 = " +
                   String.format("%1$" + 14 + "s", (((double) end[3] - start[3]) / 1000000)));
        ps.println("Client CPU             = " +
                   String.format("%1$" + 14 + "s", (((double) end[4] - start[4]) / 1000000000)));
        ps.println("Elapsed Time           = " + String.format("%1$" + 14 + "s", formattedElapsedTime));
    }

}
