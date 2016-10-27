
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
 
set long 4096
--
-- 1. Use XQuery and fn:collection to count the documents in the %TABLE_NAME% 
-- table.
--
set autotrace on explain
--
select *
  from XMLTABLE(
          'count(fn:collection("oradb:/%USER%/%TABLE_NAME%"))'
       )
/
--
-- 2. Use XQuery to select a single document from the %TABLE_NAME% table
--
select * 
  from XMLTABLE(
          'for $i in fn:collection("oradb:/%USER%/%TABLE_NAME%")/PurchaseOrder[Reference/text()=$REFERENCE]
           return $i'
           passing 'AFRIPP-2015060818343243PDT' as "REFERENCE"
       )
/
--
-- 3. XQuery with multiple predicates, returning a single node (Reference)
--
select * 
  from XMLTABLE(
          'for $i in fn:collection("oradb:/%USER%/%TABLE_NAME%")/PurchaseOrder[CostCenter=$CC and Requestor=$REQUESTOR and count(LineItems/LineItem) > $QUANTITY]/Reference
           return $i'
           passing 'A60' as "CC", 'Diana Lorentz' as "REQUESTOR", 5 as "QUANTITY"
       )
/
--
-- 4. XQuery constructing a new summary document from the documents that match the specified predicates
-- Also demonstrates the use of nested FOR loops, one for the set of PurchaseOrder documents, and one for 
-- the LineItem elements
--
select *
  from XMLTable(
         '<Summary UPC="{$UPC}">
          {
           for $p in fn:collection("oradb:/%USER%/%TABLE_NAME%")/PurchaseOrder
            for $l in $p/LineItems/LineItem[Quantity > $Quantity and Part/text() =$UPC]
            order by $p/Reference
           	return 
           	  <PurchaseOrder reference="{$p/Reference/text()}" lineItem="{fn:data($l/@ItemNumber)}" Quantity="{$l/Quantity}"/>
          }
          </Summary>' 
          passing  '707729113751' as UPC, 3 as "Quantity"
       )
/
--
-- 5. Use XMLSerialize to format the XMLType and serialize it as a CLOB. 
--    Allows result to be viewed in products that do not support XMLType.
--    XMLSerialize allows control over the layout of the serialized 
--    XML.
--
select XMLSERIALIZE(CONTENT COLUMN_VALUE AS CLOB INDENT SIZE=2) 
  from XMLTable(
         '<Summary UPC="{$UPC}">
          {
           for $p in fn:collection("oradb:/%USER%/%TABLE_NAME%")/PurchaseOrder
            for $l in $p/LineItems/LineItem[Quantity > $Quantity and Part/text() =$UPC]
            order by $p/Reference
           	return 
           	  <PurchaseOrder reference="{$p/Reference/text()}" lineItem="{fn:data($l/@ItemNumber)}" Quantity="{$l/Quantity}"/>
          }
          </Summary>' 
          passing  '707729113751' as UPC, 3 as "Quantity"
       )
/
--
-- 6. Using XMLTable to create an in-line relational view from the documents that match the XQuery expression.
--
select * 
  from xmlTable( 
          'for $p in fn:collection("oradb:/%USER%/%TABLE_NAME%")/PurchaseOrder 
            for $l in $p/LineItems/LineItem[Quantity > 3 and Part/text() = "707729113751"] 
              return 
              <Result ItemNumber="{fn:data($l/@ItemNumber)}"> 
                { 
                  $p/Reference, 
                  $p/Requestor, 
                  $p/User, 
                  $p/CostCenter, 
                  $l/Quantity 
                } 
                <Description>{fn:data($l/Part/@Description)}</Description> 
                <UnitPrice>{fn:data($l/Part/@UnitPrice)}</UnitPrice> 
                <PartNumber>{$l/Part/text()}</PartNumber> 
             </Result>' 
             columns 
             SEQUENCE      for ordinality, 
             ITEM_NUMBER       NUMBER(3) path '@ItemNumber', 
             REFERENCE     VARCHAR2( 30) path 'Reference', 
             REQUESTOR     VARCHAR2(128) path 'Requestor', 
             USERID        VARCHAR2( 10) path 'User', 
             COSTCENTER    VARCHAR2(  4) path 'CostCenter', 
             DESCRIPTION   VARCHAR2(256) path 'Description',  
             PARTNO        VARCHAR2( 14) path 'PartNumber',  
             QUANTITY       NUMBER(12,4) path 'Quantity',  
             UNITPRICE      NUMBER(14,2) path 'UnitPrice' 
       ) 
/        
--
-- 7. Joining relational and XML tables using XQuery.
--
select REQUESTOR, DEPARTMENT_NAME 
  from HR.EMPLOYEES e, HR.DEPARTMENTS d,
       XMLTABLE(
         'for $p in fn:collection("oradb:/%USER%/%TABLE_NAME%")/PurchaseOrder
            where $p/User=$EMAIL and $p/Reference=$REFERENCE
            return $p'
          passing 'AFRIPP-2015060818343243PDT' as "REFERENCE", e.EMAIL as "EMAIL"
          COLUMNS
          REQUESTOR path 'Requestor/text()',
          USERNAME  path 'User'
       )
 where e.DEPARTMENT_ID = d.DEPARTMENT_ID
/