trigger ContactChangeEventTrigger on ContactChangeEvent (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        ContactChangeEventHandler.afterInsert(Trigger.new);
    }     
}