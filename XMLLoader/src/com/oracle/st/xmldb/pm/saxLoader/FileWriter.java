
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

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Locale;

import oracle.xml.parser.v2.XMLDocument;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class FileWriter extends Thread {

    public static final boolean DEBUG = XMLLoader.DEBUG;

    private Locale locale = new Locale(Locale.ENGLISH.toString(), "US");
    private static String XML_FORMAT_STRING = "yyyy-MM-dd'T'HH:mm:ss.S";
    private SimpleDateFormat sdf = new SimpleDateFormat(XML_FORMAT_STRING);

    private XMLLoader processor;
    private String threadName;

    private double byteCount;
    private int fileCount;

    private Calendar startTime;
    private Calendar endTime;

    private XMLDocument document;

    public FileWriter(XMLLoader processor, String name) {
        this.processor = processor;
        this.threadName = name;
        this.byteCount = 0;
        this.fileCount = 0;
    }

    private void updateByteCount(double bytes) {
        this.byteCount = this.byteCount + bytes;
        this.fileCount++;
    }

    private int getFileCount() {
        return this.fileCount;
    }

    private double getByteCount() {
        return this.byteCount;
    }

    private void setStartTime() {
        this.startTime = new GregorianCalendar(locale);
    }

    private void setEndTime() {
        this.endTime = new GregorianCalendar(locale);
    }

    private String getStartTime() {
        DateFormat df = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.LONG);
        return df.format(this.startTime.getTime());
    }

    private String getEndTime() {
        DateFormat df = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.LONG);
        return df.format(this.endTime.getTime());
    }

    private Calendar getElapsedTime() {
        return null;
    }

    private int getTransferRate() {
        return 0;
    }

    public void run() {

        Exception fatalError = null;
        setStartTime();

        try {

            this.processor.log("Thread " + this.threadName + " started at " + getStartTime());
            while (!this.processor.isProcessingComplete()) {
                if (document != null) {
                    int bytesWritten = writeDocument(document);
                    updateByteCount(bytesWritten);
                }
                synchronized (this) {
                    this.processor.addToWriterQueue(this);
                    try {
                        wait();
                    } catch (InterruptedException ioe) {
                    }
                }
            }
        } catch (Exception e) {
            this.processor.log(e);
        }
        setEndTime();
        this.processor.log("Thread " + this.threadName + " completed at " + getStartTime());
        this.processor.recordStatistics(new WriterStatistics(this.threadName, this.startTime, this.endTime,
                                                             getFileCount(), 0, 0, getByteCount(), fatalError, 0, 0, 0,
                                                             0, 0));
    }

    private int writeDocument(XMLDocument xml) throws Exception, IOException {
        Element root = xml.getDocumentElement();
        NodeList nodes = root.getElementsByTagName("docnum");
        String filename = nodes.item(0).getFirstChild().getNodeValue();
        filename = filename + ".xml";

        FileOutputStream out = new FileOutputStream(filename);
        xml.print(new PrintWriter(out));
        out.close();

        if (DEBUG) {
            this.processor.log(xml);
        }
        return 0;
    }
}
