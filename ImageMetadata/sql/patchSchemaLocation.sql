
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

set echo on
spool sqlOperations.log APPEND
--
DEF HOSTNAME = &1
--
DEF SCHEMA_LOCATION = &2
--
set echo on
--
-- Load a copy of the Image Metadata XML Schema that will be valid when opened from an external tools such as XMLSPY.
--
declare
  res boolean;

  targetDocumentPath varchar2(256) := '&SCHEMA_LOCATION';
  targetDocument xmlType;
  http_port number(8);

begin

  targetDocument := xdbUriType(targetDocumentPath).getXML();
   
  HTTP_PORT := dbms_xdb.gethttpPort();
    
  select updateXML
         (
           targetDocument,
           '/xs:schema/xs:import[@namespace="http://xmlns.oracle.com/ord/meta/exif"]/@schemaLocation',
           'http://' || '&HOSTNAME' || ':' || HTTP_PORT || '/sys/schemas/PUBLIC/xmlns.oracle.com/ord/meta/exif',
           'xmlns:xs="http://www.w3.org/2001/XMLSchema"'
         )
    into targetDocument
    from dual;

  dbms_xdb.deleteResource(targetDocumentPath);
  res := dbms_xdb.createResource(targetDocumentPath,targetDocument);
  dbms_xdb.changeOwner(targetDocumentPath,USER,FALSE);
  commit;
end;
/
quit
