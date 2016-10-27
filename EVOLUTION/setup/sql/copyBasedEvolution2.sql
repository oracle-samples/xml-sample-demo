
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
declare
  V_NEW_XML_SCHEMA1         XMLType := xdburitype('%DEMOCOMMON%/xsd/purchaseOrder.v3.xsd').getXML();
  V_NEW_XML_SCHEMA2         XMLType := xdburitype('%DEMOCOMMON%/xsd/shipmentDetails.xsd').getXML();
begin

	DBMS_XMLSCHEMA_ANNOTATE.disableMaintainDOM(V_NEW_XML_SCHEMA1);

  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA1,'PurchaseOrderType','%ROOT_TYPE%');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA1,'LineItemsType','LINEITEMS_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA1,'LineItemType','LINEITEM_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA1,'ActionsType','ACTIONS_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA1,DBMS_XDB_CONSTANTS.XSD_COMPLEX_TYPE,'ActionsType',DBMS_XDB_CONSTANTS.XSD_ELEMENT,'Action','ACTION_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA1,'PartType','PART_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA1,DBMS_XDB_CONSTANTS.XSD_COMPLEX_TYPE,'PurchaseOrderType',DBMS_XDB_CONSTANTS.XSD_ATTRIBUTE,'DateCreated','TIMESTAMP WITH TIME ZONE');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA1,DBMS_XDB_CONSTANTS.XSD_COMPLEX_TYPE,'PurchaseOrderType',DBMS_XDB_CONSTANTS.XSD_ELEMENT,'Notes','CLOB');

  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA1,'AbstractShippingInstructionsType','SHIPPING_INSTRUCTIONS_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA1,'BasicShippingInstructionsType','BASIC_SHIPPING_INSTRUCTIONS_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA1,'AdvancedShippingInstructionsType','ADV_SHIPPING_INSTRUCTIONS_T');

	DBMS_XMLSCHEMA_ANNOTATE.disableMaintainDOM(V_NEW_XML_SCHEMA2);

  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA2,'ShipmentsType','SHIPMENTS_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA2,'ShipmentType','SHIPMENT_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA2,'LineItemWithShipmentsType','LINE_ITEM_WITH_SHIPMENT_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_NEW_XML_SCHEMA2,DBMS_XDB_CONSTANTS.XSD_COMPLEX_TYPE,'ShipmentType',DBMS_XDB_CONSTANTS.XSD_ELEMENT,'ShipmentDate','TIMESTAMP WITH TIME ZONE');
  
  DBMS_XMLSCHEMA.copyEvolve
  (
     SCHEMAURLS => xdb$string_list_t
                   (
                     '%SCHEMAURL%',
                     '%SCHEMAURL2%'
                    ),
     NEWSCHEMAS =>  XMLSequenceType
                    (
                      V_NEW_XML_SCHEMA1,
                      V_NEW_XML_SCHEMA2
                    ),
     TRANSFORMS =>  XMLSequenceType
                    (
                      xdburitype('%DEMOCOMMON%/xsl/transform.v3.xsl').getXML(),
                      xdburitype('%DEMOCOMMON%/xsl/transform.v3.xsl').getXML()
                    ),
     PARALLELDEGREE => 4                    
  );     
end;                                                       
/
--
@@insertDocument4.sql
--
select OBJECT_VALUE PURCHASE_ORDER
  from %TABLE1%
 where XMLExists
       (
         '$p/PurchaseOrder[Reference/text()="ABULL-20100809203001138PDT"]' 
         passing OBJECT_VALUE as "p"
       )
/
--
