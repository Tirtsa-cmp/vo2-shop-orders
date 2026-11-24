trigger OrderTrigger on Order__c (before insert, before update,after insert,
    after update,
    after delete,
    after undelete){
        OrderTriggerHandler.handleTrigger(Trigger.operationType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);

}