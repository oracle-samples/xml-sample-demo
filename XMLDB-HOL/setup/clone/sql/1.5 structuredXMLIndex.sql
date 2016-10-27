
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
-- Create a Structured XML Index on the %TABLE_NAME% table
-- 
drop index %TABLE_NAME%_IDX
/
begin 
  DBMS_XMLINDEX.dropParameter(
                 'PO_SXI_PARAMETERS');
end;
/
begin 
  DBMS_XMLINDEX.registerParameter(
                 'PO_SXI_PARAMETERS',
                 'GROUP   PO_LINEITEM
                    xmlTable PO_INDEX_MASTER ''/PurchaseOrder''
                       COLUMNS
                         REFERENCE 	     varchar2(30) 	PATH ''Reference/text()'',
                         LINEITEM            xmlType   	PATH ''LineItems/LineItem''
                    VIRTUAL xmlTable PO_INDEX_LINEITEM ''/LineItem''
                       PASSING lineitem
                       COLUMNS
                         ITEMNO         number(38)  	 PATH ''@ItemNumber'',
                         UPC            varchar2(14)   PATH ''Part/text()'', 	
                         DESCRIPTION    varchar2(256)  PATH ''Part/@Description''
                 ');
end;                
/
create index %TABLE_NAME%_IDX
          on %TABLE_NAME% (OBJECT_VALUE)
             indextype is XDB.XMLINDEX
             parameters ('PARAM PO_SXI_PARAMETERS')
/
create unique index REFERENCE_IDX 
       on PO_INDEX_MASTER (REFERENCE)
/ 
create index UPC_IDX 
       on PO_INDEX_LINEITEM (UPC)
/   
call dbms_stats.gather_schema_stats(USER)
/