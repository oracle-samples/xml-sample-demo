
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
 
DROP INDEX %TABLE_NAME%_IDX
/
declare
  section_group_not_found exception;
  PRAGMA EXCEPTION_INIT( section_group_not_found , -12203 );
begin
  CTX_DDL.DROP_SECTION_GROUP('XQFT');
exception
  when section_group_not_found then
    NULL;
end;
/
declare
  preference_not_found exception;
  PRAGMA EXCEPTION_INIT( preference_not_found , -10700 );
begin
  CTX_DDL.DROP_PREFERENCE('STORAGE_PREFS');
exception
  when preference_not_found then
    NULL;
end;
/
begin
  CTX_DDL.CREATE_SECTION_GROUP('XQFT','PATH_SECTION_GROUP');
  CTX_DDL.SET_SEC_GRP_ATTR('XQFT','XML_ENABLE','T');

  CTX_DDL.create_preference('STORAGE_PREFS', 'BASIC_STORAGE');
  CTX_DDL.set_attribute(
     'STORAGE_PREFS',
     'D_TABLE_CLAUSE',
     'LOB(DOC) STORE AS SECUREFILE (COMPRESS MEDIUM CACHE)'
  );
  CTX_DDL.set_attribute(
     'STORAGE_PREFS',
     'I_TABLE_CLAUSE',
     'LOB(TOKEN_INFO) STORE AS SECUREFILE (NOCOMPRESS CACHE)'
  );
END;
/
CREATE INDEX %TABLE_NAME%_XQFT_IDX 
    ON %TABLE_NAME%(OBJECT_VALUE)
       INDEXTYPE IS CTXSYS.CONTEXT
       PARAMETERS(
         'storage STORAGE_PREFS 
         section group XQFT'
       )
/