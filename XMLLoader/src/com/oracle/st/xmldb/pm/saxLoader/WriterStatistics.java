
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

package com.oracle.st.xmldb.pm.saxLoader;

import com.oracle.st.xmldb.pm.common.baseApp.Logger;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.TimeZone;

public class WriterStatistics {
    
    private String threadName;

    private Calendar startTime;
    private Calendar endTime;

    private int taskCount;
    private int successCount;
    private int errorCount;
    private double byteCount;
    private Exception exception;

    private long bytesSentToServer;
    private long bytesReadFromServer;
    private long networkRoundTrips;
    private long dbCPU;
    private long clientCPU;

    private Locale locale = new Locale(Locale.ENGLISH.toString(), "US");
    private static String XML_FORMAT_STRING = "yyyy-MM-dd'T'HH:mm:ss.SSS";
    private SimpleDateFormat sdf = new SimpleDateFormat(XML_FORMAT_STRING);

    public WriterStatistics(String threadName, Calendar startTime, Calendar endTime, int taskCount, int successCount,
                            int errorCount, double byteCount, Exception e, long bytesSentToServer,
                            long bytesReadFromServer, long networkRoundTrips, long dbCPU, long clientCPU) {
        this.threadName = threadName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.taskCount = taskCount;
        this.successCount = successCount;
        this.errorCount = errorCount;
        this.byteCount = byteCount;
        this.exception = e;
        this.bytesSentToServer = bytesSentToServer;
        this.bytesReadFromServer = bytesReadFromServer;
        this.networkRoundTrips = networkRoundTrips;
        this.dbCPU = dbCPU;
        this.clientCPU = clientCPU;

    }

    private String getThreadname() {
        return this.threadName;
    }

    private String getStartTime() {
        return (this.sdf.format(this.startTime.getTime()) + "000").substring(0, 23);
    }

    private String getEndTime() {
        return (this.sdf.format(this.endTime.getTime()) + "000").substring(0, 23);
    }

    public int getSuccessCount() {
        return this.successCount;
    }

    public void printStats(Logger logger) {

        SimpleDateFormat elapsedTimeFormatter = new SimpleDateFormat("HH:mm:ss.SSS");
        GregorianCalendar cal = new GregorianCalendar();
        elapsedTimeFormatter.setTimeZone(TimeZone.getTimeZone("GMT+0"));
        long elapsedTime = this.endTime.getTimeInMillis() - this.startTime.getTimeInMillis();
        cal.setTimeInMillis(elapsedTime);
        String result = elapsedTimeFormatter.format(cal.getTime());
        DecimalFormat df = (DecimalFormat) DecimalFormat.getInstance();
        df.applyPattern("###,###,##0");

        DecimalFormat df2 = (DecimalFormat) DecimalFormat.getInstance();
        df2.applyPattern("###,##0.000000");

        double throughput = ((double) this.successCount / elapsedTime) * 1000;

        String summary =
            "| " + String.format("%1$-" + 20 + "s", this.getThreadname()) + " |" +
            String.format("%1$" + 24 + "s", this.getStartTime()) + " |" +
            String.format("%1$" + 24 + "s", this.getEndTime()) + " |" + String.format("%1$" + 13 + "s", result) + " |" +
            String.format("%1$" + 8 + "s", df.format(this.taskCount)) + " |" +
            String.format("%1$" + 8 + "s", df.format(this.successCount)) + " |" +
            String.format("%1$" + 8 + "s", df.format(this.errorCount)) + " |" +
            String.format("%1$" + 8 + "s", df.format(throughput)) + " |" +
            String.format("%1$" + 14 + "s", df.format(this.byteCount)) + " |" +
            String.format("%1$" + 14 + "s", df.format(this.bytesSentToServer)) + " |" +
            String.format("%1$" + 14 + "s", df.format(this.bytesReadFromServer)) + " |" +
            String.format("%1$" + 8 + "s", df.format(this.networkRoundTrips)) + " |" +
            String.format("%1$" + 12 + "s", df2.format(((double) this.dbCPU) / 1000000)) + " |" +
            String.format("%1$" + 12 + "s", df2.format(((double) this.clientCPU) / 1000000000)) + " |";

        synchronized (logger) {
            logger.log(summary);
        }
    }

}
