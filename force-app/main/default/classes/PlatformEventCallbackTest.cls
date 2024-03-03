@isTest
public with sharing class PlatformEventCallbackTest {
    @isTest
    static void eventCallbackFailed(){
        PlatformEventCallback cb=new PlatformEventCallback();
        Order_Detail__e ordDeta=new Order_Detail__e(Order_Number__c='ORD4000',Generate_Invoice__c=true);
        Database.SaveResult results = EventBus.publish(ordDeta,cb);
        Test.getEventBus().fail();
        List<Task> taskList=[SELECT Subject from Task];
        Assert.areEqual('Event is not published successfully.', taskList[0].Subject);
    }
    @isTest
    static void eventCallbackPassed(){
        PlatformEventCallback cb=new PlatformEventCallback();
        Order_Detail__e ordDeta=new Order_Detail__e(Order_Number__c='ORD4000',Generate_Invoice__c=true);
        Database.SaveResult results = EventBus.publish(ordDeta,cb);
        Test.getEventBus().deliver();
        List<Task> taskList=[SELECT Subject from Task];
        Assert.areEqual('Event is published successfully.', taskList[0].Subject);
    }
}