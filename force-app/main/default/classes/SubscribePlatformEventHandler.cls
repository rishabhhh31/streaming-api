public with sharing class SubscribePlatformEventHandler {
    public static void afterInsert(List<Order_Detail__e> orderList){
        User us=[SELECT Id from User WHERE Username='rishabh@streamingapi.com'];
        List<Task> taskList=new List<Task>();
        for(Order_Detail__e ord:orderList){
            Task tk=new Task();
            tk.Subject='Task is created for order number '+ord.Order_Number__c;
            tk.Description='Generate the invoice for order number '+ord.Order_Number__c+' : '+ord.Generate_Invoice__c;
            tk.ActivityDate=Date.today();
            tk.OwnerId=us.Id;
            taskList.add(tk);
        }
        try{
            insert taskList;
        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
    }
}