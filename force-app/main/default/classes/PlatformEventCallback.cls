public with sharing class PlatformEventCallback implements EventBus.EventPublishSuccessCallback, EventBus.EventPublishFailureCallback {
    public void onSuccess(EventBus.SuccessResult results){
        List<String> eventUuidList=results.getEventUuids();
        createTask(true, eventUuidList);
    }
    public void onFailure(EventBus.FailureResult results){
        List<String> eventUuidList=results.getEventUuids();
        createTask(false, eventUuidList);
    }
    public void createTask(Boolean isSuccess, List<String> uuidList){
        User us=[SELECT Id from User WHERE Username='rishabh@streamingapi.com' LIMIT 1];
        String uuidStr='';
        for(String str:uuidList){
            uuidStr+=str+' ';
        }
        Task tk=new Task();
        tk.Description=uuidStr;
        if(isSuccess){
            tk.Subject = 'Event is published successfully.';
        }else{
            tk.Subject = 'Event is not published successfully.';
        }
        tk.ActivityDate=Date.today();
        tk.OwnerId=us.Id;
        insert tk;
    }
}