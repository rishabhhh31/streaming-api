public with sharing class HandleBatchApexHandler {
    public static void afterInsert(List<BatchApexErrorEvent> listBatchApexError) {
        Set<Id> asyncApexJobIds = new Set<Id>();
        for(BatchApexErrorEvent evt:listBatchApexError){
            asyncApexJobIds.add(evt.AsyncApexJobId);
        }
        Map<Id,AsyncApexJob> jobs = new Map<Id,AsyncApexJob>([SELECT id, ApexClass.Name FROM AsyncApexJob WHERE Id IN :asyncApexJobIds]
        );
        List<Task> taskList = new List<Task>();
        for(BatchApexErrorEvent evt:listBatchApexError){
            if(jobs.get(evt.AsyncApexJobId).ApexClass.Name=='PlatformEventBatch'){
                for (String item : evt.JobScope.split(',')) {
                    Task tk=new Task();
                    tk.WhatId=(Id)item;
                    tk.Subject=evt.ExceptionType;
                    tk.ActivityDate=Date.today();
                    tk.Description=evt.Message;
                    tk.OwnerId=UserInfo.getUserId();
                    taskList.add(tk);
                }
            }
        }
        insert taskList;
        System.debug(taskList);
    }
}