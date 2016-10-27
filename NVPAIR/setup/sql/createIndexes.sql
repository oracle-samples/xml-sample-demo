
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

create index DATA_SET_OBJTYPE_IDX
    on DATA_SET_TABLE (XMLDATA."objectType")
/
create index DATA_ITEM_PROPNAME_IDX
    on DATA_ITEM_TABLE(NESTED_TABLE_ID, SYS_NC_TYPEID$, "name")
/
create index DATA_ITEM_INTVALUE_IDX
    on DATA_ITEM_TABLE(NESTED_TABLE_ID, SYS_NC_TYPEID$, "name", TREAT(SYS_NC_ROWINFO$ AS "INTEGER_T")."value")
/
set autotrace on explain lines 256 pages 50
--
select * 
  from DEPARTMENT_VIEW 
 where DEPARTMENT_ID = 40
/
