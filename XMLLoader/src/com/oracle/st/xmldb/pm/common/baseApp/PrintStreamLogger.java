
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
import java.io.PrintStream;

import oracle.xml.parser.v2.XMLDocument;

import org.w3c.dom.Document;

public class PrintStreamLogger extends Logger {

    private PrintStream ps;

    public PrintStreamLogger(PrintStream ps) {
        setLogger(ps);
    }

    public PrintStreamLogger() {
        setLogger(System.out);
    }

    public void setLogger(PrintStream ps) {
        this.ps = ps;
    }

    public synchronized void log(String s) {
        ps.print(getTimestamp());
        ps.println(s);
        ps.flush();
    }


    public synchronized void log(Document xml) {
        try {
            XMLDocument xmldoc = (XMLDocument) xml;
            xmldoc.print(ps);
            ps.flush();
        } catch (IOException ioe) {
            System.out.println(ioe);
        }
    }

    public synchronized void log(Object object) {
        ps.print(getTimestamp());
        ps.println(object);
        ps.flush();
    }

    public synchronized void log(Exception e) {
        e.printStackTrace(ps);
        ps.flush();
    }

    public void close() {
        ps.flush();
        ps.close();
    }
}
