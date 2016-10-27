
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
set feedback on
set linesize 132
set long 10240
set pages 0
set echo on
column USER format A32
column LINEITEMS format A40
--
select XMLQUERY(
         '$XML/PurchaseOrder/LineItems'
         passing object_value as "XML"
         returning CONTENT
       ) LINEITEMS
  from %TABLE1%
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20100430212831873PDT' as "REF"
       )
/
update %TABLE1%
   set object_value = XMLQuery
                      (
                        'copy $NEWXML := $XML modify (
                           for $PO in $NEWXML/PurchaseOrder return (
                                replace value of node $PO/User with $NEWUSER,
                                replace value of node $PO/Requestor with $NEWNAME,
                                replace value of node $PO/LineItems/LineItem/Part[@Description=$OLDTITLE]/@Description with $NEWTITLE 
                               )
                         )
                        return $NEWXML'
                        passing object_value as "XML",
                        'KCHUNG' as "NEWUSER",
                        'Kelly Chung' as "NEWNAME",
                        'The Mean Season' as "OLDTITLE",
                        'The Wizard of Oz' as "NEWTITLE"
                        returning content
                      )
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]/LineItems/LineItem/Part[@Description=$OLDTITLE]'
          passing object_value as "XML",
                  'AFRIPP-20100430212831873PDT' as "REF",
                  'The Mean Season' as "OLDTITLE"
       )
/
select XMLQUERY(
         '$XML/PurchaseOrder/LineItems'
         passing object_value as "XML"
         returning CONTENT
       ) LINEITEMS
  from %TABLE1%
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20100430212831873PDT' as "REF"
       )
/
pause
update %TABLE1%
   set object_value = XMLQuery(
                        'copy $NEWXML := $XML modify (
                                                delete nodes $NEWXML/PurchaseOrder/LineItems/LineItem[@ItemNumber="2"]
                                               )
                         return $NEWXML'
                        passing object_value as "XML"
                        returning CONTENT
                      )
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20100430212831873PDT' as "REF"
       )
/
select XMLQUERY(
         '$XML/PurchaseOrder/LineItems'
         passing object_value as "XML"
         returning CONTENT
       ) LINEITEMS
  from %TABLE1%
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20100430212831873PDT' as "REF"
       )
/
pause
--
update %TABLE1%
   set object_value = XMLQuery(
                        'copy $NEWXML := $XML modify (
                                                for $TARGET in $NEWXML/PurchaseOrder/LineItems/LineItem[@ItemNumber="1"]
                                                  return insert node $LINEITEM before $TARGET
                                         )
                          return $NEWXML'
                        passing object_value as "XML",
                                xmlType(
                                  '<LineItem ItemNumber="0">
                                     <Part Description="Rififi" UnitPrice="29.95">37429155622</Part>
                                     <Quantity>2</Quantity>
                                   </LineItem>'
                                ) as "LINEITEM"
                        returning CONTENT
                     )
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20100430212831873PDT' as "REF"
       )
/
select XMLQUERY(
         '$XML/PurchaseOrder/LineItems'
         passing object_value as "XML"
         returning CONTENT
       ) LINEITEMS
  from %TABLE1%
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20100430212831873PDT' as "REF"
       )
/
pause
--
update %TABLE1%
   set object_value = XMLQuery(
                        'copy $NEWXML := $XML modify (
                                                for $TARGET in $NEWXML/PurchaseOrder/LineItems
                                                   return (#ora:child-element-name LineItem#) {insert node $LINEITEM into $TARGET}
                                              )
                         return $NEWXML'
                        passing object_value as "XML",
                                xmlType(
                                  '<LineItem ItemNumber="4">
                                     <Part Description="Dreyer Box Set" UnitPrice="79.95">37429158425</Part>
                                     <Quantity>1</Quantity>
                                   </LineItem>'
                                 ) as "LINEITEM"
                       returning CONTENT
                     )
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20100430212831873PDT' as "REF"
       )
/
select XMLQUERY(
         '$XML/PurchaseOrder/LineItems'
         passing object_value as "XML"
         returning CONTENT
       ) LINEITEMS
  from %TABLE1%
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML", 'AFRIPP-20100430212831873PDT' as "REF"
       )
/
pause
--
update %TABLE1%
   set object_value = XMLQuery(
                        'copy $NEWXML := $XML modify (
                                                for $LINEITEMS in $NEWXML/PurchaseOrder/LineItems
                                                  return insert nodes $LINEITEM as last into $LINEITEMS
                                              )
                         return $NEWXML'
                         passing object_value as "XML",
                                 xmlType(
                                  '<LineItem ItemNumber="5">
                                     <Part Description="Hard Boiled" UnitPrice="39.95">715515009041</Part>
                                     <Quantity>3</Quantity>
                                   </LineItem>'
                                 ) as "LINEITEM"
                         returning CONTENT
                      )
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML", 'AFRIPP-20100430212831873PDT' as "REF"
       )
/
select XMLQUERY(
         '$XML/PurchaseOrder/LineItems'
         passing object_value as "XML"
         returning CONTENT
       ) LINEITEMS
  from %TABLE1%
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20100430212831873PDT' as "REF"
       )
/
pause
--
update %TABLE1%
   set object_value = XMLQuery(
                        ' copy $NEWXML := $XML modify (
                                                 for $CURRENT in $NEWXML/PurchaseOrder/LineItems
                                                   return replace node $CURRENT with $LINEITEMS
                                               )
                         return $NEWXML'
                         passing object_value as "XML",
                                 xmlType(
                                   '<LineItems>
                                      <LineItem ItemNumber="1">
                                        <Part Description="The Secret of Roan Inish" UnitPrice="19.95">43396509290</Part>
                                        <Quantity>7</Quantity>
                                      </LineItem>
                                      <LineItem ItemNumber="2">
                                        <Part Description="The Mean Season" UnitPrice="19.95">27616861177</Part>
                                        <Quantity>5</Quantity>
                                      </LineItem>
                                      <LineItem ItemNumber="3">
                                        <Part Description="Irma La Douce" UnitPrice="19.95">27616865908</Part>
                                        <Quantity>4</Quantity>
                                      </LineItem>
                                    </LineItems>'
                                 ) as "LINEITEMS"
                                 returning content
                     )
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML", 
                  'AFRIPP-20100430212831873PDT' as "REF"
       )
/
select XMLQUERY(
         '$XML/PurchaseOrder/LineItems'
         passing object_value as "XML"
         returning CONTENT
       ) LINEITEMS
  from %TABLE1%
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20100430212831873PDT' as "REF"
       )
/
