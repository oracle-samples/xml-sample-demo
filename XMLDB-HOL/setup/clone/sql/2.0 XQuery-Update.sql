
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
-- 1. Simple XQuery showing the current state of the document
--
select XMLQUERY(
         '<POSummary lineItemCount="{count($XML/PurchaseOrder/LineItems/LineItem)}">{
            $XML/PurchaseOrder/User,
            $XML/PurchaseOrder/Requestor,
            $XML/PurchaseOrder/LineItems/LineItem[2]
          }
          </POSummary>'
         passing object_value as "XML"
         returning CONTENT
       ) INITIAL_STATE
  from %TABLE_NAME%
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20150430212831873PDT' as "REF"
       )
/
--
-- 2. Modifying the content of existing nodes using XQuery Update.
--
update %TABLE_NAME%
   set object_value = XMLQuery
                      (
                        'copy $NEWXML := $XML modify (
                           for $PO in $NEWXML/PurchaseOrder return (
                                replace value of node $PO/User with $USERID,
                                replace value of node $PO/Requestor with $FULLNAME,
                                replace value of node $PO/LineItems/LineItem/Part[@Description=$OLDTITLE]/@Description with $NEWTITLE 
                               )
                         )
                        return $NEWXML'
                        passing object_value as "XML",
                        'KCHUNG' as "USERID",
                        'Kelly Chung' as "FULLNAME",
                        'The Mean Season' as "OLDTITLE",
                        'The Wizard of Oz' as "NEWTITLE"
                        returning content
                      )
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]/LineItems/LineItem/Part[@Description=$OLDTITLE]'
          passing object_value as "XML",
                  'AFRIPP-20150430212831873PDT' as "REF",
                  'The Mean Season' as "OLDTITLE"
       )
/
--
-- 3. Simple XQuery showing the updates to the document
--
select XMLQUERY(
         '<POSummary lineItemCount="{count($XML/PurchaseOrder/LineItems/LineItem)}">{
            $XML/PurchaseOrder/User,
            $XML/PurchaseOrder/Requestor,
            $XML/PurchaseOrder/LineItems/LineItem[2]
          }
          </POSummary>'
         passing object_value as "XML"
         returning CONTENT
       ) UPDATED_NODES
  from %TABLE_NAME%
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20150430212831873PDT' as "REF"
       )
/
--
-- 4. Deleting a node using XQuery update.
--
update %TABLE_NAME%
   set object_value = XMLQuery(
                        'copy $NEWXML := $XML modify (
                                                delete nodes $NEWXML/PurchaseOrder/LineItems/LineItem[@ItemNumber=$ITEMNO]
                                               )
                         return $NEWXML'
                        passing object_value as "XML", 2 as ITEMNO
                        returning CONTENT
                      )
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20150430212831873PDT' as "REF"
       )
/
--
-- 5. Simple XQuery showing the updates to the document
--
select XMLQUERY(
         '<POSummary lineItemCount="{count($XML/PurchaseOrder/LineItems/LineItem)}">{
            $XML/PurchaseOrder/LineItems/LineItem[2]
          }
          </POSummary>'
         passing object_value as "XML"
         returning CONTENT
       ) DELETED_NODE
  from %TABLE_NAME%
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20150430212831873PDT' as "REF"
       )
/
--
-- 6. Inserting a node using XQuery update.
--
update %TABLE_NAME%
   set object_value = XMLQuery(
                        'copy $NEWXML := $XML modify (
                                                for $TARGET in $NEWXML/PurchaseOrder/LineItems/LineItem[@ItemNumber="3"]
                                                  return insert node $LINEITEM after $TARGET
                                         )
                          return $NEWXML'
                        passing object_value as "XML",
                                xmlType(
                                  '<LineItem ItemNumber="4">
                                     <Part Description="Rififi" UnitPrice="29.95">37429155622</Part>
                                     <Quantity>2</Quantity>
                                   </LineItem>'
                                ) as "LINEITEM"
                        returning CONTENT
                     )
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20150430212831873PDT' as "REF"
       )
/
--
-- 7. Simple XQuery showing the updates to the document
--
select XMLQUERY(
         '<POSummary lineItemCount="{count($XML/PurchaseOrder/LineItems/LineItem)}">{
            $XML/PurchaseOrder/LineItems/LineItem[3]
          }
          </POSummary>'
         passing object_value as "XML"
         returning CONTENT
       ) INSERTED_NODE
  from %TABLE_NAME%
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20150430212831873PDT' as "REF"
       )
/
--
-- 8. Undo all the above changes using XQuery Update
--
update %TABLE_NAME%
   set object_value = XMLQuery(
                        ' copy $NEWXML := $XML modify (
                             for $PO in $NEWXML/PurchaseOrder return (
                                  replace value of node $PO/User with $USERID,
                                  replace value of node $PO/Requestor with $FULLNAME,
                                  replace node $PO/LineItems with $LINEITEMS
                            )
                         )
                         return $NEWXML'
                         passing object_value as "XML",
                                 'AFRIPP' as "USERID",
                                 'Adam Fripp' as "FULLNAME",
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
                  'AFRIPP-20150430212831873PDT' as "REF"
       )
/
--
-- 9. Simple XQuery showing the updates to the document
--
select XMLQUERY(
         '<POSummary lineItemCount="{count($XML/PurchaseOrder/LineItems/LineItem)}">{
            $XML/PurchaseOrder/User,
            $XML/PurchaseOrder/Requestor,
            $XML/PurchaseOrder/LineItems/LineItem[2]
          }
          </POSummary>'
         passing object_value as "XML"
         returning CONTENT
       ) FINAL_STATE
  from %TABLE_NAME%
 where xmlExists(
         '$XML/PurchaseOrder[Reference=$REF]'
          passing object_value as "XML",
                  'AFRIPP-20150430212831873PDT' as "REF"
       )
/