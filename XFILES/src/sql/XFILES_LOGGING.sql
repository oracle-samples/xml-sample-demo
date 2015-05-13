
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
create or replace package XFILES_LOGGING
as
  procedure writeLogRecord(P_PACKAGE_URL VARCHAR2, P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType);
  procedure writeErrorRecord(P_PACKAGE_URL VARCHAR2, P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType);
  procedure eventErrorRecord(P_PACKAGE VARCHAR2, P_METHOD VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_APP_INFO XMLType, P_STACK_TRACE XMLType);
  procedure logQueryService(P_SOAP_REQUEST XMLType);
  procedure logServletMessage(P_MESSAGE XMLType);
  procedure logPageHit(P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_RESOURCE_PATH VARCHAR2);
  function captureStackTrace return XMLType;
end;  
/
show errors
--
create or replace package body XFILES_LOGGING
as
procedure writeLogRecord(P_PACKAGE_URL VARCHAR2, P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)
as
  PRAGMA AUTONOMOUS_TRANSACTION;
  V_LOG_RECORD XMLType;
begin

  select XMLElement(
           "XFilesLogRecord",
           xmlElement("RequestURL", P_PACKAGE_URL || P_NAME || + '()'),
           xmlElement("USER",sys_context('USERENV', 'CURRENT_USER')),
           xmlElement
           (
             "Timestamps",
             xmlElement("Init",P_INIT_TIME),
             xmlElement("Complete",SYSTIMESTAMP)
           ),
           xmlElement
           (
             "Parameters",
             P_PARAMETERS
           )
         )
    into V_LOG_RECORD
    from dual;

  XFILES_LOGWRITER.ENQUEUE_LOG_RECORD(V_LOG_RECORD);
  commit;

end;
--
procedure writeErrorRecord(P_PACKAGE_URL VARCHAR2, P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)
as
  PRAGMA AUTONOMOUS_TRANSACTION;
  V_LOG_RECORD XMLType;
begin

  select XMLElement(
           "XFilesErrorRecord",
           xmlElement("RequestURL",P_PACKAGE_URL || P_NAME || + '()'),
           xmlElement("USER",sys_context('USERENV', 'CURRENT_USER')),
           xmlElement(
             "Timestamps",
             xmlElement("Init",P_INIT_TIME),
             xmlElement("Complete",SYSTIMESTAMP)
           ),
           xmlElement(
             "Parameters",
             P_PARAMETERS
           ),
           P_STACK_TRACE
         )
    into V_LOG_RECORD
    from dual;
    
  XFILES_LOGWRITER.ENQUEUE_LOG_RECORD(V_LOG_RECORD);
  commit;

end;
--
procedure eventErrorRecord(P_PACKAGE VARCHAR2, P_METHOD VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_APP_INFO XMLType, P_STACK_TRACE XMLType)
as
  PRAGMA AUTONOMOUS_TRANSACTION;
  V_LOG_RECORD XMLType;
begin

  select XMLElement(
           "RepositoryEventError",
           xmlElement("Method",P_PACKAGE || '.' || P_METHOD || + '()'),
           xmlElement("USER",sys_context('USERENV', 'CURRENT_USER')),
           xmlElement(
             "Timestamps",
             xmlElement("Init",P_INIT_TIME),
             xmlElement("Complete",SYSTIMESTAMP)
           ),
           xmlElement(
             "AdditionalInformation",
             P_APP_INFO
           ),
           P_STACK_TRACE
         )
    into V_LOG_RECORD
    from dual;
    
  XFILES_LOGWRITER.ENQUEUE_LOG_RECORD(V_LOG_RECORD);
  commit;

end;
--
procedure logPageHit(P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_RESOURCE_PATH VARCHAR2)
as
  PRAGMA AUTONOMOUS_TRANSACTION;
  V_LOG_RECORD XMLType;
begin

  select XMLElement(
           "Page",
           xmlElement("USER",sys_context('USERENV', 'CURRENT_USER')),
           xmlElement(
             "Timestamps",
             xmlElement("Init",P_INIT_TIME),
             xmlElement("Complete",SYSTIMESTAMP)
           ),
           xmlElement(
             "Target",
             P_RESOURCE_PATH
           )
         )
    into V_LOG_RECORD
    from dual;
    
  XFILES_LOGWRITER.ENQUEUE_LOG_RECORD(V_LOG_RECORD);
  commit;

end;
--
procedure logQueryService(P_SOAP_REQUEST XMLType)
as
  PRAGMA AUTONOMOUS_TRANSACTION;
  V_LOG_RECORD XMLType;
begin

  select XMLElement(
           "XFilesDynamicQuery",
           xmlElement("RequestURL",'/orawsv'),
           xmlElement("USER",sys_context('USERENV', 'CURRENT_USER')),
           xmlElement
           (
             "Timestamps",
             xmlElement("Init",SYSTIMESTAMP)
           ),
           xmlElement
           (
             "SoapRequest",
             P_SOAP_REQUEST
           )
         )
    into V_LOG_RECORD
    from dual;
    
  XFILES_LOGWRITER.ENQUEUE_LOG_RECORD(V_LOG_RECORD);
  commit;

end;
--
procedure logServletMessage(P_MESSAGE XMLType)
as
  PRAGMA AUTONOMOUS_TRANSACTION;
  V_LOG_RECORD XMLType;
begin

  select XMLElement(
           "XFilesServletMessage",
           P_MESSAGE
         )
    into V_LOG_RECORD
    from dual;
    
  XFILES_LOGWRITER.ENQUEUE_LOG_RECORD(V_LOG_RECORD);
  commit;

end;
--
function captureStackTrace
return XMLType
as
  V_STACK_TRACE XMLType;
begin
  select xmlElement(
           "Error",
           xmlElement
           (
             "Stack",
             xmlCDATA(DBMS_UTILITY.FORMAT_ERROR_STACK())
           ),
           xmlElement
           (
             "BackTrace",
             xmlCDATA(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE())
           )
         )
    into V_STACK_TRACE
    from DUAL;
   
    return V_STACK_TRACE;
end;
--
end;
/
show errors
--
