
/* ================================================  
 * Oracle XFiles Demonstration.  
 *    
 * Copyright (c) 2014 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */

--
-- *******************************************************************
-- *    AQ to PACKAGE to manage queing and dequeing of log records   *
-- *           and inserting data into XFILES_LOG_TABLE              *
-- *******************************************************************
--
-- Create the Package that will provide enqueue and dequeue functionality
--
create or replace package XFILES_LOGWRITER
AUTHID DEFINER
as
  procedure ENQUEUE_LOG_RECORD(LOG_RECORD XMLTYPE);
  procedure DEQUEUE_LOG_RECORD(context raw, reginfo sys.aq$_reg_info, descr sys.aq$_descriptor, payload raw, payloadl number);
  procedure PROCESSLOGRECORD(P_XMLREF REF XMLTYPE, P_USER VARCHAR2, P_TIMESTAMP TIMESTAMP WITH TIME ZONE, P_LOG_RECORD_TYPE VARCHAR2); 
  procedure DELETELOGGINGFOLDERS;
  procedure CREATELOGGINGFOLDERS;
  procedure RESETLOGGINGFOLDERS;
  procedure FOLDER_LOG_RECORD(LOG_RECORD_XML XMLTYPE);
end;
/
show errors
--
-- Package Body must be created using PL/SQL due to use of substition strings
--
create or replace package body XFILES_LOGWRITER
as
--
procedure folder_log_record(LOG_RECORD_XML XMLType)
as
  V_LOG_RECORD_REF  ref XMLType;
  V_USER            VARCHAR2(32);
  V_TIMESTAMP       TIMESTAMP(6) WITH TIME ZONE;
  V_LOG_RECORD_TYPE VARCHAR2(256);  
begin

  -- Insert the Log Record into the Log Record Table. Return the REF.

  insert into &XFILES_SCHEMA..XFILES_LOG_TABLE x 
         values(LOG_RECORD_XML)
         returning ref(x) INTO V_LOG_RECORD_REF;

  -- Generate the Filename from the Log Record.

  select LOG_USER, LOG_TIMESTAMP, LOG_RECORD_TYPE
    INTO V_USER,   V_TIMESTAMP, V_LOG_RECORD_TYPE
    from XMLTABLE
         (
           '/*'
           passing LOG_RECORD_XML
           COLUMNS
           LOG_USER         VARCHAR2(32)                path 'User',
           LOG_TIMESTAMP    TIMESTAMP(6) WITH TIME ZONE path 'Timestamps/Init',
           LOG_RECORD_TYPE  VARCHAR2(32)                path 'fn:local-name(.)'
         );

	PROCESSLOGRECORD(V_LOG_RECORD_REF, V_USER, V_TIMESTAMP, V_LOG_RECORD_TYPE);

end;
--
procedure ENQUEUE_LOG_RECORD(LOG_RECORD XMLTYPE)
as
  PRAGMA AUTONOMOUS_TRANSACTION;

  enq_ct             dbms_aq.enqueue_options_t;
  msg_prop           dbms_aq.message_properties_t;
  enq_msgid          raw(16);

  V_QUEUE_NAME       VARCHAR2(128) := sys_context('USERENV','CURRENT_SCHEMA') || '.LOG_RECORD_Q';

begin
  DBMS_AQ.ENQUEUE(V_QUEUE_NAME, enq_ct, msg_prop, LOG_RECORD, enq_msgid);
  commit;
end;
--
procedure DEQUEUE_LOG_RECORD( context raw,
                              reginfo sys.aq$_reg_info,
                              descr sys.aq$_descriptor,
                              payload raw,
                              payloadl number )
as
  deq_ct                dbms_aq.dequeue_options_t;
  msg_prop              dbms_aq.message_properties_t;
  enq_msgid             raw(16);

  LOG_RECORD            XMLType;
  V_QUEUE_NAME          VARCHAR2(128) := sys_context('USERENV','CURRENT_SCHEMA') || '.LOG_RECORD_Q';

begin
  DBMS_AQ.DEQUEUE(V_QUEUE_NAME, deq_ct, msg_prop, LOG_RECORD, enq_msgid);
  -- insert into &XFILES_SCHEMA..XFILES_LOG_TABLE values(LOG_RECORD);
  folder_log_record(LOG_RECORD);
  commit;
end;
--
procedure DELETELOGGINGFOLDERS
as
begin  
  if (DBMS_XDB.existsResource(XFILES_CONSTANTS.FOLDER_LOGGING)) then
    DBMS_XDB.deleteResource(XFILES_CONSTANTS.FOLDER_LOGGING,2);
  end if;
end;
--
procedure CREATELOGGINGFOLDERS
as 
  V_RESULT                      BOOLEAN;
begin
	V_RESULT := DBMS_XDB.createFolder(XFILES_CONSTANTS.FOLDER_LOGGING);  
  V_RESULT := DBMS_XDB.createFolder(XFILES_CONSTANTS.FOLDER_CURRENT_LOGGING);  
  V_RESULT := DBMS_XDB.createFolder(XFILES_CONSTANTS.FOLDER_ERROR_LOGGING);  
  V_RESULT := DBMS_XDB.createFolder(XFILES_CONSTANTS.FOLDER_CURRENT_ERRORS);  
  V_RESULT := DBMS_XDB.createFolder(XFILES_CONSTANTS.FOLDER_CLIENT_LOGGING);  
  V_RESULT := DBMS_XDB.createFolder(XFILES_CONSTANTS.FOLDER_CURRENT_CLIENT);  
end;
--
procedure RESETLOGGINGFOLDERS
as  
  cursor getLogRecords 
  is
  select ref(l) XMLREF, LOG_USER, LOG_TIMESTAMP, LOG_RECORD_TYPE
    from XFILES_LOG_TABLE l,
         XMLTABLE
         (
           '/*'
           passing OBJECT_VALUE
           COLUMNS
           LOG_USER         VARCHAR2(32)                path 'User',
           LOG_TIMESTAMP    TIMESTAMP(6) WITH TIME ZONE path 'Timestamps/Init',
           LOG_RECORD_TYPE  VARCHAR2(32)                path 'fn:local-name(.)'
         )
   order by LOG_TIMESTAMP DESC;
begin

	-- Remove All Current Log Record Entries
	DELETELOGGINGFOLDERS;
	 
	-- Recreate the Logging folder Structure
  CREATELOGGINGFOLDERS;
  
  for lr in getLogRecords loop
    XFILES_LOGWRITER.PROCESSLOGRECORD(lr.XMLREF, lr.LOG_USER, lr.LOG_TIMESTAMP, lr.LOG_RECORD_TYPE);
  end loop;
  commit;
end;
--
procedure PROCESSLOGRECORD(P_XMLREF REF XMLTYPE, P_USER VARCHAR2, P_TIMESTAMP TIMESTAMP WITH TIME ZONE, P_LOG_RECORD_TYPE VARCHAR2)
as
  V_ZULU_TIMESTAMP      TIMESTAMP(6);           
  V_SAFE_TIMESTAMP      VARCHAR2(64);           

  V_DUPLICATE_COUNT     NUMBER(3);              
  V_RESOURCE_COUNT      NUMBER(4);              
  V_MAX_RESOURCE_COUNT  NUMBER(4) := 1024;

  V_TARGET_FOLDER       VARCHAR2(700);          
  V_LOG_RECORD_ENTRY    VARCHAR2(700);          
  V_FILENAME            VARCHAR2(256);          
                                               
  V_RESULT              BOOLEAN;
begin
	
	-- Convert to Zulu and remove ':' characters from timestamp;
	
  V_ZULU_TIMESTAMP := SYS_EXTRACT_UTC(P_TIMESTAMP);
  V_SAFE_TIMESTAMP := substr(to_char(V_ZULU_TIMESTAMP,'YYYY-MM-DD"T"HH24.MI.SS.FF'),1,23);

  V_DUPLICATE_COUNT  := 0;
  V_FILENAME := '/' || P_USER || '-' || V_SAFE_TIMESTAMP; 
  V_LOG_RECORD_ENTRY := XFILES_CONSTANTS.FOLDER_CURRENT_LOGGING || '/' || V_FILENAME || '.xml';
  while (DBMS_XDB.existsResource(V_LOG_RECORD_ENTRY)) loop
    V_DUPLICATE_COUNT  := V_DUPLICATE_COUNT + 1;
    V_LOG_RECORD_ENTRY :=  XFILES_CONSTANTS.FOLDER_CURRENT_LOGGING || '/' || V_FILENAME || '.' || to_char(V_DUPLICATE_COUNT,'FM0009') || '.xml';
  end loop;
  
  -- Note use of UNSTICKY ref so records can in the table reamain if the resource is deleted.
  
  V_RESULT := DBMS_XDB.createResource(V_LOG_RECORD_ENTRY,P_XMLREF,FALSE);
  
  -- Cycle the Current Log Records Folder and Current Error Records folder based on folder size.

 if (P_LOG_RECORD_TYPE = 'XFilesErrorRecord') then
 
    -- Create a Hard Line to the resource in the Errors Folder structure if the log record is an error report. 
 
    DBMS_XDB.link(V_LOG_RECORD_ENTRY,XFILES_CONSTANTS.FOLDER_CURRENT_ERRORS,SUBSTR(V_LOG_RECORD_ENTRY,INSTR(V_LOG_RECORD_ENTRY,'/',-1)+1));

    select count(*) 
      into V_RESOURCE_COUNT
      from RESOURCE_VIEW
     where under_path(res, XFILES_CONSTANTS.FOLDER_CURRENT_ERRORS) = 1;

    if (V_RESOURCE_COUNT = V_MAX_RESOURCE_COUNT) then
      DBMS_XDB.renameResource(XFILES_CONSTANTS.FOLDER_CURRENT_ERRORS,XFILES_CONSTANTS.FOLDER_ERROR_LOGGING,substr(V_SAFE_TIMESTAMP,1,19));
      V_RESULT := DBMS_XDB.createFolder(XFILES_CONSTANTS.FOLDER_CURRENT_ERRORS);
    end if;
  end if;
  
 
 if (P_LOG_RECORD_TYPE = 'XFilesClientException') then
 
    -- Create a Hard Line to the resource in the Errors Folder structure if the log record is an error report. 
 
    DBMS_XDB.link(V_LOG_RECORD_ENTRY,XFILES_CONSTANTS.FOLDER_CURRENT_CLIENT,SUBSTR(V_LOG_RECORD_ENTRY,INSTR(V_LOG_RECORD_ENTRY,'/',-1)+1));

    select count(*) 
      into V_RESOURCE_COUNT
      from RESOURCE_VIEW
     where under_path(res, XFILES_CONSTANTS.FOLDER_CURRENT_CLIENT) = 1;

    if (V_RESOURCE_COUNT = V_MAX_RESOURCE_COUNT) then
      DBMS_XDB.renameResource(XFILES_CONSTANTS.FOLDER_CURRENT_CLIENT,XFILES_CONSTANTS.FOLDER_CLIENT_LOGGING,substr(V_SAFE_TIMESTAMP,1,19));
      V_RESULT := DBMS_XDB.createFolder(XFILES_CONSTANTS.FOLDER_CURRENT_CLIENT);
    end if;
  end if;
  
  select count(*) 
    into V_RESOURCE_COUNT
    from RESOURCE_VIEW
   where under_path(res, XFILES_CONSTANTS.FOLDER_CURRENT_LOGGING) = 1;

  if (V_RESOURCE_COUNT = V_MAX_RESOURCE_COUNT) then
    DBMS_XDB.renameResource(XFILES_CONSTANTS.FOLDER_CURRENT_LOGGING,XFILES_CONSTANTS.FOLDER_LOGGING,substr(V_SAFE_TIMESTAMP,1,19));
    V_RESULT := DBMS_XDB.createFolder(XFILES_CONSTANTS.FOLDER_CURRENT_LOGGING);
  end if;
  
end;
--
end;
/
show errors
--