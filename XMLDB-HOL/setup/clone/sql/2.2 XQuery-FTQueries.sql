
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
-- Query 1 : Search for an exact match on a phrase. The index cannot be used
-- since the comparison is case sensitive. No results are returned since
-- the source in mixed case and the target is in upper case.
--
select distinct STREET, CITY
  from %TABLE_NAME%,
       XMLTABLE(
         '$P/PurchaseOrder/ShippingInstructions/Address'
         passing OBJECT_VALUE as "P"
         COLUMNS
         STREET VARCHAR2(64) PATH 'street',
         CITY   VARCHAR2(32) PATH 'city'
       )
 where XMLExists(
         '$P/PurchaseOrder/ShippingInstructions/Address[city=$PHRASE]'
         passing OBJECT_VALUE as "P",
                 'OXFORD' as "PHRASE"
       )
/
--
-- Query 2 : Search for an exact match on a phrase. The index cannot be used
-- since the comparison is case sensitive. Results are returned since
-- the source and target are an exact match.
--
select distinct STREET, CITY
  from %TABLE_NAME%,
       XMLTABLE(
         '$P/PurchaseOrder/ShippingInstructions/Address'
         passing OBJECT_VALUE as "P"
         COLUMNS
         STREET VARCHAR2(64) PATH 'street',
         CITY   VARCHAR2(32) PATH 'city'
       )
 where XMLExists(
         '$P/PurchaseOrder/ShippingInstructions/Address[city=$PHRASE]'
         passing OBJECT_VALUE as "P",
                 'Oxford' as "PHRASE"
       )
/
--
-- Query 3 : Search for a contains match on a phrase. The index is not used
-- since the comparison is case sensitive, and contains performs a substring 
-- type match, searching for the target string anywhere in the specified source.
--
-- For word searches this leads to false positives when a word in the source
-- contains the target string. Case sensitivity also leads to false negatives
-- where the target appears in the specified source but in a different case to 
-- the case used to define the target.
--
select distinct STREET, CITY
  from %TABLE_NAME%,
       XMLTABLE(
         '$P/PurchaseOrder/ShippingInstructions/Address'
         passing OBJECT_VALUE as "P"
         COLUMNS
         STREET VARCHAR2(64) PATH 'street',
         CITY   VARCHAR2(32) PATH 'city'
       )
 where XMLExists(
         '$P/PurchaseOrder/ShippingInstructions/Address/street[contains(.,$PHRASE)]'
         passing OBJECT_VALUE as "P",
                 'sport' as "PHRASE"
       )
/
--
-- Query 4 : An XQuery Full-Text "contains text" search on a phrase. The index is used
-- since "contains text" comparisons are case insensitive. However since "contains text"
-- is an exact word search no results are found.
--
select distinct STREET, CITY
  from %TABLE_NAME%,
       XMLTABLE(
         '$P/PurchaseOrder/ShippingInstructions/Address'
         passing OBJECT_VALUE as "P"
         COLUMNS
         STREET VARCHAR2(64) PATH 'street',
         CITY   VARCHAR2(32) PATH 'city'
       )
 where XMLExists(
         '$P/PurchaseOrder/ShippingInstructions/Address/street[. contains text {$PHRASE}]'
         passing OBJECT_VALUE as "P",
                 'sport' as "PHRASE"
       )
/
--
-- Query 5 : An XQuery Full-Text "contains text" search on a phrase with stemming. 
-- The index is used since "contains text" comparisons are case insensitive. 
-- Results are returned since stemming identfied that sport is stem for sporting.
--
select distinct STREET, CITY
  from %TABLE_NAME%,
       XMLTABLE(
         '$P/PurchaseOrder/ShippingInstructions/Address'
         passing OBJECT_VALUE as "P"
         COLUMNS
         STREET VARCHAR2(64) PATH 'street',
         CITY   VARCHAR2(32) PATH 'city'
       )
 where XMLExists(
         '$P/PurchaseOrder/ShippingInstructions/Address/street[. contains text {$PHRASE} using stemming]'
         passing OBJECT_VALUE as "P",
                 'sport' as "PHRASE"
       )
/
--
-- Query 6 : An XQuery Full-Text "contains text" search on a fragment. 
-- The index is used since "contains text" comparisons are case insensitive. 
--
select distinct STREET, CITY
  from %TABLE_NAME%,
       XMLTABLE(
         '$P/PurchaseOrder/ShippingInstructions/Address'
         passing OBJECT_VALUE as "P"
         COLUMNS
         STREET VARCHAR2(64) PATH 'street',
         CITY   VARCHAR2(32) PATH 'city'
       )
 where XMLExists(
         '$P/PurchaseOrder/ShippingInstructions/Address[. contains text {$PHRASE}]'
         passing OBJECT_VALUE as "P",
                 'Oxford' as "PHRASE"
       )
/
--
-- Query 7 : An XQuery Full-Text "contains text" search on a fragment using the ftand operator. 
-- The index is used since "contains text" comparisons are case insensitive. 
-- Results are returned since stemming identifed 'centre' as a stem for 'center'
--
select distinct STREET, CITY
  from %TABLE_NAME%,
       XMLTABLE(
         '$P/PurchaseOrder/ShippingInstructions/Address'
         passing OBJECT_VALUE as "P"
         COLUMNS
         STREET VARCHAR2(64) PATH 'street',
         CITY   VARCHAR2(32) PATH 'city'
       )
 where XMLExists(
         '$P/PurchaseOrder/ShippingInstructions/Address[. contains text {$PHRASE1} ftand {$PHRASE2} using stemming]'
         passing OBJECT_VALUE as "P",
                 'Oxford' as "PHRASE1",
                 'Center' as "PHRASE2"
       )
/
--
-- Query 8 : An XQuery Full-Text "contains text" search on a fragment using the ftand operator.
-- The index is used since the "contains text" comparison is case insensitive. 
-- The Window clause specifies that the words must appear with 2 words of each other.
-- No results are returned because the window is too small.
--
select distinct STREET, CITY
  from %TABLE_NAME%,
       XMLTABLE(
         '$P/PurchaseOrder/ShippingInstructions/Address'
         passing OBJECT_VALUE as "P"
         COLUMNS
         STREET VARCHAR2(64) PATH 'street',
         CITY   VARCHAR2(32) PATH 'city'
       )
 where XMLExists(
         '$P/PurchaseOrder/ShippingInstructions/Address[. contains text {$PHRASE1} ftand {$PHRASE2} using stemming window 2 words]'
         passing OBJECT_VALUE as "P",
                 'Science' as "PHRASE1",
                 'Magdalen' as "PHRASE2"
       )
/
--
-- Query 9 : An XQuery Full-Text "contains text" search on a fragment using the ftand operator. 
-- The index is used since the "contains text" comparison is case insensitive. 
-- The Window clause specifies that the words must appear with 6 words of each other.
-- Results are returned since the window is large enough
--
select distinct STREET, CITY
  from %TABLE_NAME%,
       XMLTABLE(
         '$P/PurchaseOrder/ShippingInstructions/Address'
         passing OBJECT_VALUE as "P"
         COLUMNS
         STREET VARCHAR2(64) PATH 'street',
         CITY   VARCHAR2(32) PATH 'city'
       )
 where XMLExists(
         '$P/PurchaseOrder/ShippingInstructions/Address[. contains text {$PHRASE1} ftand {$PHRASE2} using stemming window 6 words]'
         passing OBJECT_VALUE as "P",
                 'Science' as "PHRASE1",
                 'Magdalen' as "PHRASE2"
       )
/