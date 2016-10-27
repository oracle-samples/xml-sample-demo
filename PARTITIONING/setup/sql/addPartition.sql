
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
set autotrace off
--
ALTER TABLE %TABLE1%
  ADD PARTITION P04 VALUES ('B0','B10','B20','B30','B40','B50')
/
--
@@insertDocument.sql
--
select TABLE_NAME, PARTITION_NAME
  from USER_TAB_PARTITIONS
 order by TABLE_NAME, PARTITION_NAME
/
select OBJECT_VALUE PURCHASE_ORDER
  from %TABLE1%
 where XMLExists
       (
         '$p/PurchaseOrder[Reference/text()="ABULL-20100809203001137PDT"]' 
         passing OBJECT_VALUE as "p"
       )
/
--
@@rowsByPartition.sql
--
