
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
create or replace package METADATA_SERVICES
AUTHID CURRENT_USER
as
  procedure UPDATEIMAGEMETADATA(P_RESID VARCHAR2, P_TITLE XMLType, P_DESCRIPTION XMLType);
end;
/
--
show errors
--
create or replace public synonym METADATA_SERVICES for &METADATA_SCHEMA..METADATA_SERVICES
/
create or replace package body METADATA_SERVICES
as 
--
procedure writeLogRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)
as
begin
  XFILES_LOGGING.writeLogRecord('/orawsv/&METADATA_SCHEMA./METADATA_SERVICES/',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS);
end;
--
procedure writeErrorRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)
as
begin
  XFILES_LOGGING.writeErrorRecord('/orawsv/&METADATA_SCHEMA./METADATA_SERVICES/',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);
end;
--
procedure handleException(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE,P_PARAMETERS XMLTYPE)
as
  V_STACK_TRACE XMLType;
  V_RESULT      boolean;
begin
  V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();
  rollback; 
  writeErrorRecord(P_MODULE_NAME,P_INIT_TIME,P_PARAMETERS,V_STACK_TRACE);
end;
--
procedure UPDATEIMAGEMETADATA(P_RESID VARCHAR2, P_TITLE XMLType, P_DESCRIPTION XMLType)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESID             RAW(16) := HEXTORAW(P_RESID);
begin
  select XMLConcat
         (
           xmlElement("Resid",P_RESID),
           xmlElement("Title",P_TITLE),
           xmlElement("Description",P_DESCRIPTION)
         )
    into V_PARAMETERS
    from dual;

  update IMAGE_METADATA_TABLE m
    set OBJECT_VALUE = updateXML
                       (
                          OBJECT_VALUE,
                          '/img:imageMetadata/img:Title',
                          P_TITLE,
                          XDB_METADATA_CONSTANTS.NSPREFIX_IMAGE_METADATA_IMG
                       )
   where m.RESID = V_RESID
     and XMLExists
         (
           'declare namespace img = "http://xmlns.oracle.com/xdb/metadata/ImageMetadata"; (: :)
            /img:imageMetadata/img:Title'
           passing m.OBJECT_VALUE
         );

  if (SQL%ROWCOUNT = 0) then
     update IMAGE_METADATA_TABLE m
        set object_value = insertChildXML
                           (
                              object_value, 
                              '/img:imageMetadata',
                              'img:Title',
                               P_TITLE,
                             XDB_METADATA_CONSTANTS.NSPREFIX_IMAGE_METADATA_IMG
                           )
      where m.RESID = V_RESID; 

  end if;
   
  update IMAGE_METADATA_TABLE m
     set OBJECT_VALUE = updateXML
                        (
                           OBJECT_VALUE,
                           '/img:imageMetadata/img:Description',
                           P_DESCRIPTION,
                           XDB_METADATA_CONSTANTS.NSPREFIX_IMAGE_METADATA_IMG
                        )
   where m.RESID = V_RESID
     and XMLExists
         (
           'declare namespace img = "http://xmlns.oracle.com/xdb/metadata/ImageMetadata"; (: :)
            /img:imageMetadata/img:Description'
           passing m.OBJECT_VALUE
         );
        
  if (SQL%ROWCOUNT = 0) then
    update IMAGE_METADATA_TABLE m
       set object_value = insertChildXML
                          (
                             object_value, 
                             '/img:imageMetadata',
                             'img:Description',
                              P_DESCRIPTION,
                              XDB_METADATA_CONSTANTS.NSPREFIX_IMAGE_METADATA_IMG
                          )
     where m.RESID = V_RESID;
  end if;
  commit;
  writeLogRecord('UPDATEIMAGEMETADATA',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('UPDATEIMAGEMETADATA',V_INIT,V_PARAMETERS);
    raise;
end;
--
end;
/
show errors
--
grant execute on METADATA_SERVICES to public
/
quit
