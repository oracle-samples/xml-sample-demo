
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
call xdb_utilities.createHomeFolder()
/
declare
  V_RESULT boolean;
begin
  if dbms_xdb.existsResource(XFILES_CONSTANTS.FOLDER_HOME || '/configuration') then 
    dbms_xdb.deleteResource(XFILES_CONSTANTS.FOLDER_HOME || '/configuration',DBMS_XDB.DELETE_RECURSIVE);
  end if;

  V_RESULT := dbms_xdb.createFolder('/home/&XFILES_SCHEMA/configuration');

  commit;

  --
  -- Icons : FAMFAMFAM
  -- 

  if dbms_xdb.existsResource(XFILES_CONSTANTS.FOLDER_HOME || '/icons') then 
    dbms_xdb.deleteResource(XFILES_CONSTANTS.FOLDER_HOME || '/icons',DBMS_XDB.DELETE_RECURSIVE);
  end if;

  V_RESULT := dbms_xdb.createFolder(XFILES_CONSTANTS.FOLDER_HOME || '/icons');
  V_RESULT := dbms_xdb.createFolder(XFILES_CONSTANTS.FOLDER_HOME || '/icons/famfamfam');

  commit;
  
  --
  -- Frameworks : XINHA, JQuery, Bootstrap Dialog, Boostrap etc.
  -- 

  if dbms_xdb.existsResource(XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE) then 
    dbms_xdb.deleteResource(XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE,DBMS_XDB.DELETE_RECURSIVE);
  end if;

  V_RESULT := dbms_xdb.createFolder(XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE);

  if dbms_xdb.existsResource(XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC) then 
    dbms_xdb.deleteResource(XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC,DBMS_XDB.DELETE_RECURSIVE);
  end if;

  V_RESULT := dbms_xdb.createFolder(XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC);

  if dbms_xdb.existsResource(XFILES_CONSTANTS.FOLDER_APPLICATIONS_PRIVATE) then 
    dbms_xdb.deleteResource(XFILES_CONSTANTS.FOLDER_APPLICATIONS_PRIVATE,DBMS_XDB.DELETE_RECURSIVE);
  end if;

  V_RESULT := dbms_xdb.createFolder(XFILES_CONSTANTS.FOLDER_APPLICATIONS_PRIVATE);

  if dbms_xdb.existsResource(XFILES_CONSTANTS.FOLDER_APPLICATIONS_PUBLIC) then 
    dbms_xdb.deleteResource(XFILES_CONSTANTS.FOLDER_APPLICATIONS_PUBLIC,DBMS_XDB.DELETE_RECURSIVE);
  end if;

  V_RESULT := dbms_xdb.createFolder(XFILES_CONSTANTS.FOLDER_APPLICATIONS_PUBLIC);
  
  --
  -- Viewers : Softlinks to XSL Stylesheets that can function as a custom viewer.
  -- 

  if dbms_xdb.existsResource(XFILES_CONSTANTS.FOLDER_VIEWERS_PUBLIC) then 
    dbms_xdb.deleteResource(XFILES_CONSTANTS.FOLDER_VIEWERS_PUBLIC,DBMS_XDB.DELETE_RECURSIVE);
  end if;

  V_RESULT := dbms_xdb.createFolder(XFILES_CONSTANTS.FOLDER_VIEWERS_PUBLIC);
  commit;

end;
/
--
