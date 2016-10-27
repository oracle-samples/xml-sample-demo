
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
-- A set of simple queries to demonstrate how indexing can optimize XQuery operations.
--
set autotrace on explain
--
select * 
  from XMLTABLE
       (
          'count(fn:collection("oradb:/%USER%/%TABLE_NAME%")/PurchaseOrder[Reference/text()=$REFERENCE])'
           passing 'AFRIPP-2015060818343243PDT' as "REFERENCE"
       )
/
select * 
  from XMLTABLE
       (
          'count(fn:collection("oradb:/%USER%/%TABLE_NAME%")/PurchaseOrder[User/text()=$USER])'
           passing 'AFRIPP' as "USER"
       )
/
select * 
  from XMLTABLE
       (
          'count(fn:collection("oradb:/%USER%/%TABLE_NAME%")/PurchaseOrder[LineItems/LineItem[Part/text()=$UPC]])'
           passing '707729113751' as "UPC"
       )
/
select * 
  from XMLTABLE
       (
          'count(fn:collection("oradb:/%USER%/%TABLE_NAME%")/PurchaseOrder[LineItems/LineItem[Part/text() = $UPC and Quantity > $QUANTITY]])'
           passing '707729113751' as "UPC", 8 as "QUANTITY"
       )
/