
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

declare
  cursor findMissingMetadata 
  is
  select ANY_PATH
    from RESOURCE_VIEW rv
   where not exists (
           select 1 
             from XDBEXT.IMAGE_METADATA_TABLE im
            where rv.RESID = im.RESID
         )
     and XMLExists(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $RES/Resource[ContentType="image/pjpeg" or ContentType="image/jpeg"]'
           passing RES as "RES"
         );
  V_IMAGE_METADATA XMLTYPE;
begin
  XDB_OUTPUT.createLogFile('/public/reloadImageMetadata.log',FALSE);
  XDB_OUTPUT.writeLogFileEntry('Processing Images.');
  XDB_OUTPUT.flushLogFile();
  for jpg in findMissingMetadata loop
    begin
      IMAGE_PROCESSOR.insertImageMetadata(jpg.ANY_PATH);
      XDB_OUTPUT.writeLogFileEntry('Metadata extracted for ' || jpg.ANY_PATH);
      XDB_OUTPUT.flushLogFile();
    exception
      when OTHERS then
        XDB_OUTPUT.writeLogFileEntry('Error extracting metadata for ' || jpg.ANY_PATH);
        XDB_OUTPUT.logException();
        XDB_OUTPUT.flushLogFile();
    end;
  end loop;
  XDB_OUTPUT.writeLogFileEntry('Processing Complete.');
  XDB_OUTPUT.flushLogFile();  
  commit;
end;
--
