public with sharing class EfficientPaginationController {
    @AuraEnabled
    public static List<Account> fetchRecords(Boolean previousType,Boolean nextType,String firstName, String lastName, Integer recordCount){
        try {
            List<Account> accountList=new List<Account>();
            if(previousType==true){
                accountList = [SELECT Id, Name, Rating, Industry, AnnualRevenue  FROM Account WHERE Name < :firstName ORDER BY Name DESC LIMIT :recordCount];
            }else if(nextType==true){
                accountList=[SELECT Id, Name, Rating, Industry, AnnualRevenue from Account WHERE Name >: lastName ORDER BY Name ASC LIMIT: recordCount];
            }else{
                accountList=[SELECT Id, Name, Rating, Industry, AnnualRevenue from Account ORDER BY Name ASC LIMIT: recordCount];
            }
            if(accountList.size()>0){
                return accountList;
            }
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static Integer getRecordCount(){
        Integer count=[SELECT COUNT() from Account];
        return count;
    }
}