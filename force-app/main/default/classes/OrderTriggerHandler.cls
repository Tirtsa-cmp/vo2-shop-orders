public with sharing class OrderTriggerHandler {
    public handleTrigger(
        System.TriggerOperation operationType,
        List<Order__c> newLines,
        List<Order__c> oldLines,
        Map<Id, Order__c> newLineMap,
        Map<Id, Order__c> oldLineMap
    ) {
        switch on operationType {
            when BEFORE_INSERT {
              
            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {
           
            }
            when AFTER_INSERT {
               
            }
            when AFTER_UPDATE {   OrderService.updateToConfirmed(newLines, oldLineMap);
}
            when AFTER_DELETE {
                       }           when AFTER_UNDELETE {
}
 when else {
                // No action needed for other operations
            }
        }
    }
    

    }
