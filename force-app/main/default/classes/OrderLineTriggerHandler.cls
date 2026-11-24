public with sharing class OrderLineTriggerHandler {
    public static void handleTrigger(
        System.TriggerOperation operationType,
        List<Order_Line__c> newLines,
        List<Order_Line__c> oldLines,
        Map<Id, Order_Line__c> newLineMap,
        Map<Id, Order_Line__c> oldLineMap
    ) {
        switch on operationType {
            when BEFORE_INSERT {
                OrderLineService.updateOrderLines(newLines, null);
            }
            when BEFORE_UPDATE {
                OrderLineService.updateOrderLines(newLines, oldLineMap);
                OrderLineService.orderIsDraft(newLines, oldLineMap);

            }
            when BEFORE_DELETE {
            OrderLineService.orderIsDraft(null, oldLineMap);

            }
            when AFTER_INSERT {
                OrderLineService.DmlChangeOrderLine(newLines, null);
            }
            when AFTER_UPDATE {
 OrderLineService.DmlChangeOrderLine(newLines, oldLinesMap);            }
            when AFTER_DELETE {
 OrderLineService.DmlChangeOrderLine(null, oldLinesMap);            }
           when AFTER_UNDELETE {
    OrderLineService.DmlChangeOrderLine(newLines, null);
}
 when else {
                // No action needed for other operations
            }
        }
    }
    
}