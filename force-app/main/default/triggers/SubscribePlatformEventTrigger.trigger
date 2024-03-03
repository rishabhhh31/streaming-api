trigger SubscribePlatformEventTrigger on Order_Detail__e (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        SubscribePlatformEventHandler.afterInsert(Trigger.new);
    }
}