
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

--
-- Delete any tables which clash with the name used by the demo..
--
declare
  cursor getTables
  is
  select OBJECT_NAME
    from USER_OBJECTS
   where OBJECT_NAME in ( '%TABLE1%')
     and OBJECT_TYPE = 'TABLE';
begin
  for t in getTables() loop
    execute immediate 'DROP TABLE "' || t.OBJECT_NAME || '" PURGE';
  end loop;
end;
/      
purge recyclebin
/
declare
  ORACLE_TEXT_ERROR exception;
  PRAGMA EXCEPTION_INIT (ORACLE_TEXT_ERROR, -20000);
begin
  CTX_DDL.DROP_SECTION_GROUP('XQFT');
exception
  when ORACLE_TEXT_ERROR then
    NULL;
end;
/
declare
  ORACLE_TEXT_ERROR exception;
  PRAGMA EXCEPTION_INIT (ORACLE_TEXT_ERROR, -20000);
begin
  CTX_DDL.DROP_PREFERENCE('STORAGE_PREFS');
exception
  when ORACLE_TEXT_ERROR then
    NULL;
end;
/
