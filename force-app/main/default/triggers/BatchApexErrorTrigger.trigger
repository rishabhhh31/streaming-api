trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        HandleBatchApexHandler.afterInsert(Trigger.new);
    }
}