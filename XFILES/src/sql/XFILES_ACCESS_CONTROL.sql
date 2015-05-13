
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
-- Create the documents that provide access control. 
-- One document makes it possbile to detect whether or not the current user is authenticated. 
-- The other returns the name of the current user and can only be accessed by authenticated user.
--
declare
  V_RESULT BOOLEAN;
begin

  if (DBMS_XDB.existsResource(XFILES_CONSTANTS.DOCUMENT_AUTH_STATUS)) then
    DBMS_XDB.deleteResource(XFILES_CONSTANTS.DOCUMENT_AUTH_STATUS);
  end if;

  if (DBMS_XDB.existsResource(XFILES_CONSTANTS.DOCUMENT_WHOAMI)) then
    DBMS_XDB.deleteResource(XFILES_CONSTANTS.DOCUMENT_WHOAMI);
  end if;
  
  commit;
  
  V_RESULT := DBMS_XDB.createResource(XFILES_CONSTANTS.DOCUMENT_WHOAMI,XMLType('<CurrentUser/>'));
  V_RESULT := DBMS_XDB.createResource(XFILES_CONSTANTS.DOCUMENT_AUTH_STATUS,XMLType('<Authenticated/>'));
  V_RESULT := DBMS_XDB.createResource(XFILES_CONSTANTS.DOCUMENT_UNAUTHENTICATED,XMLType('<Unauthenticated/>'));
  commit;
   
  DBMS_RESCONFIG.addResConfig(XFILES_CONSTANTS.DOCUMENT_WHOAMI,XFILES_CONSTANTS.RESCONFIG_WHOAMI,null);
  DBMS_RESCONFIG.addResConfig(XFILES_CONSTANTS.DOCUMENT_AUTH_STATUS,XFILES_CONSTANTS.RESCONFIG_AUTH_STATUS,null);
  commit;
 
  DBMS_XDB.setACL(XFILES_CONSTANTS.DOCUMENT_UNAUTHENTICATED,XFILES_CONSTANTS.ACL_DENY_XFILES_USERS);
  DBMS_XDB.setACL(XFILES_CONSTANTS.DOCUMENT_WHOAMI,XFILES_CONSTANTS.ACL_XFILES_USERS);

  DBMS_XDB.setACL(XFILES_CONSTANTS.FOLDER_ROOT || '/WebServices',XFILES_CONSTANTS.ACL_XFILES_USERS);
  DBMS_XDB.setACL(XFILES_CONSTANTS.FOLDER_ROOT || '/XMLSearch',XFILES_CONSTANTS.ACL_XFILES_USERS);
  DBMS_XDB.setACL(XFILES_CONSTANTS.FOLDER_ROOT || '/WebDemo',XFILES_CONSTANTS.ACL_XFILES_USERS);
  commit;
end;
/

