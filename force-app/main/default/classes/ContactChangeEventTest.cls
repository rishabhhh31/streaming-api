@isTest
public with sharing class ContactChangeEventTest {
    @isTest
    static void contactTaskCreationTest(){
        Test.enableChangeDataCapture();
        Contact con=new Contact();
        con.FirstName='Rishabh';
        con.LastName='Jain';
        con.Email='rishabh@gmail.com';
        insert con;
        Test.getEventBus().deliver();
        List<Task> taskList=[SELECT Id from Task];
        Assert.areEqual(1, taskList.size(),'Insertion Failed Test');
        con = [SELECT Email from Contact LIMIT 1];
        con.Email='rishabhjain@gmail.com';
        update con;
        Test.getEventBus().deliver();
        taskList=[SELECT Id from Task];
        Assert.areEqual(2, taskList.size(),'Updation Failed Test');
    }
}