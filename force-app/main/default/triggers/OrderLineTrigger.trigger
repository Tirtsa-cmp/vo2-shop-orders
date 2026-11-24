trigger OrderLineTrigger on Order_Line__c (before insert, before update,after insert,
    after update,
    after delete,
    after undelete)
{

   OrderLineTriggerHandler.handleTrigger(Trigger.operationType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);

}