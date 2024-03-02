public with sharing class ContactChangeEventHandler {
    public static void afterInsert(List<ContactChangeEvent> ContactChangeEventList) {
        List<Task> taskList=new List<Task>();
        for(ContactChangeEvent conEvt : ContactChangeEventList){
            EventBus.ChangeEventHeader header=conEvt.ChangeEventHeader;
            Task tk=new Task();
            if(header.changetype=='CREATE'){
                tk.Subject='New Contact Task';
            }
            else if(header.changetype=='UPDATE' && header.changedfields.contains('Email')){
                tk.Subject='Updated Email Contact Task';
            }
            tk.ActivityDate=Date.today();
            tk.OwnerId=header.commituser;
            tk.WhoId=header.recordids[0];
            taskList.add(tk);
            if(taskList.size()>0){
                insert taskList;
            }else{
                System.debug('No task in list');
            }
        }
    }
}