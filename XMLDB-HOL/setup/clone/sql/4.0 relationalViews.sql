
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
-- Create a Master View, from elements that occur at most once per document
--
create or replace view %TABLE_NAME%_MASTER_VIEW 
as
  select m.* 
    from %TABLE_NAME% p,
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
            SHIP_TO_STREET       path  'ShippingInstructions/Address/street/text()',
            SHIP_TO_CITY         path  'ShippingInstructions/Address/city/text()',
            SHIP_TO_COUNTY       path  'ShippingInstructions/Address/county/text()',
            SHIP_TO_POSTCODE     path  'ShippingInstructions/Address/postcode/text()',
            SHIP_TO_STATE        path  'ShippingInstructions/Address/state/text()',
            SHIP_TO_PROVINCE     path  'ShippingInstructions/Address/province/text()',
            SHIP_TO_ZIP          path  'ShippingInstructions/Address/zipCode/text()',
            SHIP_TO_COUNTRY      path  'ShippingInstructions/Address/country/text()',
            SHIP_TO_PHONE        path  'ShippingInstructions/telephone/text()',
            INSTRUCTIONS         path  'SpecialInstructions/text()'
         ) m
/
--
-- Create a Detail View, from the contents of the LineItem collection. LineItem can
-- more than once is a document. The rows in this view can be joined with the rows
-- in the previous view using REFERENCE, which is common to both views.
--
create or replace view %TABLE_NAME%_DETAIL_VIEW 
as
  select m.REFERENCE, l.*
    from %TABLE_NAME% p,
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