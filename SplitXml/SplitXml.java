

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;

import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQConstants;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQSequence;
import javax.xml.xquery.XQStaticContext;

import oracle.xml.xquery.OXQDataSource;

/**
 * Description:
 * 
 *    Splits a large XML file into many small XML files based on 
 *    an XPath expression that identifies a sequence of XML elements.
 *    Values are written to files where each document is on a single 
 *    line.
 *    
 * Usage:
 * 
 *    java -cp $CP SplitXml inputFile.xml xpath/to/elements 64
 *
 *    The first argument is the input XML file
 *    The second argument is the XPath or XQuery expression that select XML values within the XML file
 *    The third argument is the approximate maximum size (in megabytes) of output files
 */
public class SplitXml {

  public static void main(String[] args) throws Exception {
    
    String file = args[0];
    if (file == null) {
      System.out.println("You must specify a file. ");
      System.exit(1);
    }
    
    String query = args[1];
    if (query == null) {
      System.out.println("You must specify a query. ");
      System.exit(1);
    }

    double splitSize = Double.parseDouble(args[2]);
    if (splitSize <= 0) {
      System.out.println("You must specify a split size (MB). ");
      System.exit(1);
    }
    
    OXQDataSource ds = new OXQDataSource();
    XQConnection con = ds.getConnection();
    XQStaticContext ctx = con.getStaticContext();
    ctx.setBindingMode(XQConstants.BINDING_MODE_DEFERRED);
    con.setStaticContext(ctx);
    
    double filesize = splitSize * 1024d * 1024d; // approximate size per file
    int fileCt = 0; // number of files
    int docs = 0;
    long start = System.currentTimeMillis();
    try (InputStream in = new BufferedInputStream(new FileInputStream(file))) { 
      XQPreparedExpression expr = con.prepareExpression(query);
      expr.bindDocument(XQConstants.CONTEXT_ITEM, in, null, null);
      ByteArrayOutputStream buffer = new ByteArrayOutputStream();
      XQSequence seq = expr.executeQuery();
      while (seq.next()) {
        seq.writeItem(buffer, null); //UTF-8
        docs++;
        buffer.write(3); // write 0x3 as a separator
        if (buffer.size() > filesize) {
          writeFile(file, fileCt++, docs, buffer);
        }        
      }
      if (buffer.size() > 0) {
        writeFile(file, fileCt++, docs, buffer);
      }
      seq.close();
    }
    long stop = System.currentTimeMillis();
    System.out.println("Completed split in " + (stop - start) + " ms");
  }

  private static void writeFile(String file, int count, int docs, ByteArrayOutputStream buffer) throws Exception {
    String splitFile = file + "." + count + ".split";
    System.out.println("Writing file " + splitFile + " with " + docs + " results processed. ");
    try (OutputStream fos = new BufferedOutputStream(new FileOutputStream(splitFile))) {
      fos.write(buffer.toByteArray());
      buffer.reset();
    }
  }

}
