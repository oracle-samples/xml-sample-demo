
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
--
-- Delete any schemas which clash with the schema URL used by the demo..
--
declare
  cursor getSchemas
  is
  select SCHEMA_URL
    from USER_XML_SCHEMAS
   where SCHEMA_URL in ( '%SCHEMAURL%');
begin
  for s in getSchemas() loop
    DBMS_XMLSCHEMA.deleteSchema(s.SCHEMA_URL,DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
  end loop;
end;
/                                                        
--
-- Delete any schemas which clash with the Type Names used by the demo..
--
declare
  cursor getSchemas
  is
  select SCHEMA_URL
    from USER_XML_SCHEMA_COMPLEX_TYPES
   where SQL_TYPE in ( '%ROOT_TYPE%');
begin
  for s in getSchemas() loop
    DBMS_XMLSCHEMA.deleteSchema(s.SCHEMA_URL,DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE);
  end loop;
end;
/
purge recyclebin
/
--
