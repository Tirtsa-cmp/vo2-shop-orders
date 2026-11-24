public with sharing class OrderService {
  public static void updateToConfirmed(List<Order__c> newOrder, Map<Id,Order__c> OldOrderMap)
    {

    Set<Id> OrderId = new Set<Id>(); // Set of Order Id
    
    if (newOrder != null)
{
    for (List<Order__c> order: newOrder)
    {
        OrderId.add(order);
    }
}
Set<Id> OldOrderId = new Set<Id>(); // Set of Old Order Id
    
    if (OldOrderMap != null)
{
    for (List<Order__c> oldOrder: OldOrderMap.values())
    {
        OldOrderId.add(oldOrder);
    }
}
 Map<Id, Order__c> ConfirmedOrderMap = [SELECT Id, Order__c FROM Order__c Where Id In :OrderId AND Status__c='Confirmed'];

 List<Order_Line__c> orderLines = [SELECT Id, Order__c,Product__c, Product__r,Quantity__c FROM Order_Line__c WHERE Order__c IN : OrderId AND product__c != null AND Quantity__c != null];

 Map<Id, Decimal> decrementByProductId = new Map<Id, Decimal>();
Map<Id, Decimal> currentStockByProductId = new Map<Id, Decimal>();

for( Order_Line__c line : orderLines)
{
    Decimal decrementProduct = decrementByProductId.contains(line.Product__c)? decrementByProductId.get(line.product__c):0;
    decrementByProductId.put(line.product__c,decrementProduct + line.Quantity__c);
    if (!currentStockByProductId)
    {
        Decimal Stock = line.product__r.Stock_Quantity != null? line.product__r.Stock_Quantity : 0;
        currentStockByProductId.put(line.product, Stock);
    }
    
}

List<Product__c> productToUpdate=new List<Product__c>();
for (Id productId : decrementByProductId.keySet())
{
Decimal newStock = currentStockByProductId.get(productId) - decrementByProductId.get(productId);
productToUpdate.add(new Product(Id = productId, Stock_Quantity__c = newStock));
}
if (productToUpdate != null)
{
    update productToUpdate;
}
}
    }
}