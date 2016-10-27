
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

select * 
  from XMLTABLE
       (
          'for $i in fn:collection("oradb:/%USER%/%TABLE1%")/PurchaseOrder[Reference/text()=$REFERENCE]
           return $i'
           passing 'AFRIPP-2010060818343243PDT' as "REFERENCE"
       )
/
select COLUMN_VALUE XML
  from XMLTABLE
       (
          'for $i in fn:collection("oradb:/%USER%/%TABLE1%")/PurchaseOrder[Requestor=$REQUESTOR and count(LineItems/LineItem) > $QUANTITY]/Reference
           return $i'
           passing 'Diana Lorentz' as "REQUESTOR", 5 as "QUANTITY"
       )
/
select COLUMN_VALUE XML
  from XMLTABLE
       (
          'for $i in fn:collection("oradb:/%USER%/%TABLE1%")/PurchaseOrder[Requestor=$REQUESTOR and count(LineItems/LineItem) > $QUANTITY and CostCenter=$CC]/Reference
           return $i'
           passing 'Diana Lorentz' as "REQUESTOR", 5 as "QUANTITY", 'A60' as "CC"
       )
/
select * 
  from XMLTABLE
       (
          'for $i in fn:collection("oradb:/%USER%/%TABLE1%")/PurchaseOrder[LineItems/LineItem[Part/text()=$UPC and Quantity > $Quantity]]/Reference
           return $i'
           passing '707729113751' as UPC, 3 as "Quantity"
       )
/
select * 
  from XMLTABLE
       (
          'for $i in fn:collection("oradb:/%USER%/%TABLE1%")/PurchaseOrder[LineItems/LineItem[Part/text()=$UPC and Quantity > $Quantity] and CostCenter=$CC]/Reference
           return $i'
           passing '707729113751' as UPC, 3 as "Quantity", 'A50' as "CC"
       )
/
select * 
  from XMLTable
       (
         '<Summary UPC="{$UPC}">
          {
           for $p in fn:collection("oradb:/%USER%/%TABLE1%")/PurchaseOrder
            for $l in $p/LineItems/LineItem[Quantity > $Quantity and Part/text() = $UPC]
           	return 
           	  <PurchaseOrder reference="{$p/Reference/text()}" lineItem="{fn:data($l/@ItemNumber)}" Quantity="{$l/Quantity}"/>
          }
          </Summary>' 
          passing  '707729113751' as UPC, 3 as "Quantity"
)
/
select * 
  from xmlTable 
       ( 
          'for $p in fn:collection("oradb:/%USER%/%TABLE1%")/PurchaseOrder 
            for $l in $p/LineItems/LineItem[Quantity > $Quantity and Part/text() = $UPC] 
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
             passing  '707729113751' as UPC, 3 as "Quantity"
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
