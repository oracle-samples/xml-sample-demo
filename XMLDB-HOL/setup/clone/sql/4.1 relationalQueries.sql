
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
-- Execute a simple SQL query over the relational view of XML content
-- showing the use of SQL Group By. XQuery 1.0 did not support the
-- concept of group by
--
select COSTCENTER, count(*)
  From Purchaseorder_Master_View 
  group by COSTCENTER
/
--
-- Simple Query showing a join betwen the master and detail views
-- with relational predicates on both views.
--
select m.REFERENCE, INSTRUCTIONS, ITEMNO, PARTNO, DESCRIPTION, QUANTITY, UNITPRICE
  from %TABLE_NAME%_MASTER_VIEW m, %TABLE_NAME%_DETAIL_VIEW d
 where m.REFERENCE = d.REFERENCE
   and m.REQUESTOR = 'Steven King'
   and d.QUANTITY  > 7 
   And D.Unitprice > 25.00
/
--
-- Simple Query showing a join betwen the master and detail views
-- with relational predicate on detail view.
--
Select M.Reference, L.Itemno, L.Partno, L.Description
  from %TABLE_NAME%_MASTER_VIEW m, %TABLE_NAME%_DETAIL_VIEW l 
 Where M.Reference = L.Reference
   and l.PARTNO in ('717951010490', '43396713994', '12236123248')
/
--
-- SQL Query on detail view making use of SQL Analytics 
-- functionality not provided by XQuery
--
Select Partno, Count(*) "Orders", Quantity "Copies"
  from %TABLE_NAME%_DETAIL_VIEW  
 where PARTNO in ('717951010490', '43396713994', '12236123248')
 group by rollup(PARTNO, QUANTITY)
/
--
-- SQL Query on detail view making use of SQL Analytics 
-- functionality not provided by XQuery
--
Select Partno, Reference, Quantity, QUANTITY - LAG(QUANTITY,1,QUANTITY) over (ORDER BY SUBSTR(REFERENCE,INSTR(REFERENCE,'-') + 1)) as DIFFERENCE
  from %TABLE_NAME%_DETAIL_VIEW  
 Where Partno = '43396713994'
 order by  SUBSTR(REFERENCE,INSTR(REFERENCE,'-') + 1) DESC
/