
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

import java.io.PrintStream;

import java.text.SimpleDateFormat;

import java.util.Calendar;
import java.util.Date;

import java.util.GregorianCalendar;

import java.util.Locale;

import org.w3c.dom.Document;

public abstract class Logger {

    private static String DEFAULT_FORMAT_STRING = "yyyymmddHHmmss";
    private static String XML_FORMAT_STRING = "yyyy-MM-dd'T'HH:mm:ss.SSS";
    private SimpleDateFormat sdf = new SimpleDateFormat(XML_FORMAT_STRING);
    private Locale locale = new Locale(Locale.ENGLISH.toString(), "US");
    protected String logFilePath = null;

    protected PrintStream log = null;

    public Logger() {
    }

    public static String getLogFileSuffix() {
        SimpleDateFormat sdf = new SimpleDateFormat(XML_FORMAT_STRING);
        return (sdf.format(new Date()) + "000").substring(0, 23) + ".log";
    }

    public static String getLogFileSuffix(String formatString) {
        return new SimpleDateFormat(formatString).format(new Date()) + ".log";
    }

    public void setLogger(PrintStream log) {
        this.log = log;
    }

    public String getTimestamp() {
        Calendar now = new GregorianCalendar(this.locale);
        return (this.sdf.format(now.getTime()) + "000").substring(0, 23) + " : ";
    }

    public synchronized void log(String s, Exception e) {
        log(s);
        log(e);
    }

    public abstract void log(String s);

    public abstract void log(Document xml);

    public abstract void log(Object object);

    public abstract void log(Exception e);

    public abstract void close();

}
