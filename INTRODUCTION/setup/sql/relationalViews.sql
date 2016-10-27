
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

set echo on
--
create or replace view %VIEW1% 
as
  select m.* 
    from %TABLE1% p,
         xmlTable
         (
            '$p/PurchaseOrder'
            passing p.OBJECT_VALUE as "p"
            columns 
            REFERENCE            path  'Reference/text()',
            REQUESTOR            path  'Requestor/text()',
            USERID               path  'User/text()',
            COSTCENTER           path  'CostCenter/text()',
            SHIP_TO_NAME         path  'ShippingInstructions/name/text()',
            SHIP_TO_ADDRESS      path  'ShippingInstructions/address/text()',
            SHIP_TO_PHONE        path  'ShippingInstructions/telephone/text()',
            INSTRUCTIONS         path  'SpecialInstructions/text()'
         ) m
/
pause
--
create or replace view %VIEW2% 
as
  select m.REFERENCE, l.*
    from %TABLE1% p,
         xmlTable
         (
            '$p/PurchaseOrder' 
            passing p.OBJECT_VALUE as "p"
            columns 
            REFERENCE            path  'Reference/text()',
            LINEITEMS    xmlType path  'LineItems/LineItem'
         ) m,
         xmlTable
         (
           '$l/LineItem'
           passing m.LINEITEMS as "l"
           columns
           ITEMNO         path '@ItemNumber', 
           DESCRIPTION    path 'Part/@Description', 
           PARTNO         path 'Part/text()', 
           QUANTITY       path 'Quantity', 
           UNITPRICE      path 'Part/@UnitPrice'
         ) l
/
pause
--
select m.REFERENCE, INSTRUCTIONS, ITEMNO, PARTNO, DESCRIPTION, QUANTITY, UNITPRICE
  from %VIEW1% m, %VIEW2% d
 where m.REFERENCE = d.REFERENCE
   and m.REQUESTOR = 'Steven King'
   and d.QUANTITY  > 7 
   and d.UNITPRICE > 25.00
/
