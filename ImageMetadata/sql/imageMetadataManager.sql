
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
def METADATA_SCHEMA = &1
--
create or replace package IMAGE_METADATA_MANAGER 
as
  procedure deleteImageMetadata();
  procedure reloadImageMetadata()
end;
/
show errors 
--
create or replace public synonym IMAGE_METADATA_MANAGER for IMAGE_METADATA_MANAGER
/
create or replace package body IMAGE_METADATA_MANAGER
as
procedure deleteImageMetadata()
as
  cursor getMetadata
  is
  select ANY_PATH, r.RESID, ref(i) XMLREF
    from RESOURCE_VIEW r, IMAGE_METADATA_TABLE i
   where r.RESID =  i.RESID;
begin
  for m in getMetadata() loop
    DBMS_XDB.deleteResourceMetadata(m.ANY_PATH,m.XMLREF,dbms_xdb.DELETE_RES_METADATA_CASCADE );
  end loop;
  commit;
end;
--
procedure reloadImageMetadata()
as

  bad_metadata exception;
  PRAGMA EXCEPTION_INIT( bad_metadata , -29400 );
  
  cursor getImages 
  is
  select ANY_PATH, RESID
    from RESOURCE_VIEW r
   where XMLEXISTS(
           'declare namespace r = "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           /r:Resource[r:ContentType="image/jpeg" or r:ContentType="image/pjpeg" or r:ContentType = "Application/dicom"]'
           passing RES
         )
     and not exists (
               select 1 from IMAGE_METADATA_TABLE i
                where r.RESID = i.RESID
             );
begin
  for i in getImages loop
    begin
      IMAGE_PROCESSOR.insertImageMetadata(i.ANY_PATH);
    exception
      when bad_metadata then
        dbms_output.put_line(i.ANY_PATH);
      when others then
        RAISE;
    end;
  end loop;
  commit;
end;
--
end;
/
show errors
--
GRANT EXECUTE 
   on IMAGE_METADATA_MANAGER 
   to public;
/
quit
   