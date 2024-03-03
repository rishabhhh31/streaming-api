public with sharing class PlatformEventHandler {
    public static void createPlatformEvent(){
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://helioswebservice2-dev-ed.develop.my.salesforce.com/services/data/v60.0/sobjects/Order_Detail__e/');
        request.setHeader('content-type', 'application/json');
        request.setHeader('Authorization', 'Bearer '+UserInfo.getSessionId());
        String body='{"Generate_Invoice__c": true,"Order_Number__c": "ORD2000"}';
        request.setBody(body);
        Http h=new Http();
        HttpResponse response=h.send(request);
        System.debug(response.getBody());
        System.debug(response.getStatusCode());
    }
    public static void publishPlatformEvent(){
        PlatformEventCallback cb=new PlatformEventCallback();
        List<Order_Detail__e> orderDetailList = new List <Order_Detail__e>();
        orderDetailList.add(new Order_Detail__e(Order_Number__c='ORD4000',Generate_Invoice__c=true));
        orderDetailList.add(new Order_Detail__e(Order_Number__c='ORD5000',Generate_Invoice__c=true));
        List<Database.SaveResult> results = EventBus.publish(orderDetailList,cb);
        for(Database.SaveResult res:results){
            if(res.isSuccess()){
                System.debug('Successfully published event.');
            }else {
                for(Database.Error err : res.getErrors()) {
                    System.debug('Error returned: ' +err.getStatusCode()+' - '+err.getMessage());
                }
            } 
        }
    }
}