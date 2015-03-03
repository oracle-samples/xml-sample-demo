xquery version "1.0";
count(fn:collection("oradb:/%USER%/%TABLE1%"))
/
xquery version "1.0";
let $REFERENCE := "AFRIPP-2010060818343243PDT"
for $i in fn:collection("oradb:/%USER%/%TABLE1%")/PurchaseOrder[Reference/text()=$REFERENCE]
  return $i
/
xquery version "1.0";
let $CC := "A60"
let $REQUESTOR := "Diana Lorentz"
let $QUANTITY := 5
for $i in fn:collection("oradb:/%USER%/%TABLE1%")/PurchaseOrder[CostCenter=$CC and Requestor=$REQUESTOR and count(LineItems/LineItem) > $QUANTITY]/Reference
  return $i
/
xquery version "1.0";
let $UPC := "707729113751"
let $Quantity :=  3
return 
  <Summary UPC="{$UPC}">{
    for $p in fn:collection("oradb:/%USER%/%TABLE1%")/PurchaseOrder
      for $l in $p/LineItems/LineItem[Quantity > $Quantity and Part/text() =$UPC] 
        return
          <PurchaseOrder reference="{$p/Reference/text()}" lineItem="{fn:data($l/@ItemNumber)}" Quantity="{$l/Quantity}"/>
  }
  </Summary>
/
xquery version "1.0";
for $p in fn:collection("oradb:/%USER%/%TABLE1%")/PurchaseOrder 
  for $l in $p/LineItems/LineItem[Quantity > 3 and Part/text() = "707729113751"] 
    return 
      <Result ItemNumber="{fn:data($l/@ItemNumber)}">{ 
          $p/Reference, 
          $p/Requestor, 
          $p/User, 
          $p/CostCenter, 
          $l/Quantity 
        } 
        <Description>{fn:data($l/Part/@Description)}</Description> 
        <UnitPrice>{fn:data($l/Part/@UnitPrice)}</UnitPrice> 
        <PartNumber>{$l/Part/text()}</PartNumber> 
      </Result>
/