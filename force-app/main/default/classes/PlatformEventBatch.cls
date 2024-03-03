public with sharing class PlatformEventBatch implements Database.Batchable<SObject>, Database.RaisesPlatformEvents {
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Name from Account');
    }
    public void execute(Database.BatchableContext bc, List<Account> accountList){
        for(Account acc:accountList){
            acc.Name=null;
        }
        update accountList;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('Batch is finished');
    }
}