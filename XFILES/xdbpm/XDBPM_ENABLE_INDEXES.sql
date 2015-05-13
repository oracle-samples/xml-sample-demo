
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

set define off
set pages  250
--
column COLUMN_EXPRESSION FORMAT A132
set pages 20 lines 256 pages 20
--
select aie.INDEX_NAME, aie.INDEX_OWNER,  ai.FUNCIDX_STATUS, aie.COLUMN_EXPRESSION
  from ALL_IND_EXPRESSIONS aie, ALL_INDEXES ai
 where aie.INDEX_NAME = ai.INDEX_NAME
   and aie.INDEX_OWNER = ai.OWNER
--   and FUNCIDX_STATUS = 'DISABLED'
--   where COLUMN_EXPRESSION = '"XDBPM"."XDB_XMLINDEX_SEARCH"."GETPATHIDPARENT"("PATHID")'
--      or COLUMN_EXPRESSION = '"XDBPM"."XDB_XMLINDEX_SEARCH"."GETPATHIDLENGTH"("PATHID")'
 order by FUNCIDX_STATUS DESC, aie.INDEX_OWNER, aie.INDEX_NAME  
/
set serveroutput on
--
call XDBPM.XDB_XMLINDEX_SEARCH.enableIndexes()
/
set serveroutput off
--
select aie.INDEX_NAME, aie.INDEX_OWNER, ai.FUNCIDX_STATUS, aie.COLUMN_EXPRESSION
  from ALL_IND_EXPRESSIONS aie, ALL_INDEXES ai
 where aie.INDEX_NAME = ai.INDEX_NAME
   and aie.INDEX_OWNER = ai.OWNER
--   and FUNCIDX_STATUS = 'DISABLED'
--   where COLUMN_EXPRESSION = '"XDBPM"."XDB_XMLINDEX_SEARCH"."GETPATHIDPARENT"("PATHID")'
--      or COLUMN_EXPRESSION = '"XDBPM"."XDB_XMLINDEX_SEARCH"."GETPATHIDLENGTH"("PATHID")'
 order by FUNCIDX_STATUS DESC, aie.INDEX_OWNER, aie.INDEX_NAME 
/
