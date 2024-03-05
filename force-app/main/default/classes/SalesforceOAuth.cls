public with sharing class SalesforceOAuth {
    @AuraEnabled
    public static String getAccessToken(String code) {
        HttpRequest request=new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://resilient-shark-8carn7-dev-ed.trailblaze.my.salesforce.com/services/oauth2/token');
        String body='grant_type=authorization_code&';
        body+='code='+code+'&';
        body+='client_id={clientId}&';
        body+='client_secret={secret}&';
        body+='redirect_uri=https://helioswebservice2-dev-ed.develop.my.site.com/salesforceoauth/s/';
        request.setBody(body);
        request.setHeader('Content-type', 'application/x-www-form-urlencoded');
        Http h=new Http();
        HttpResponse response= h.send(request);
        return response.getBody();
    }
    @AuraEnabled
    public static String newAccount(String access, String name){
        String accString=JSON.serialize(new Account(Name=name, Rating='Hot', Industry='Banking', Active__c='Yes'));
        HttpRequest request=new HttpRequest();
        request.setEndpoint('https://resilient-shark-8carn7-dev-ed.trailblaze.my.salesforce.com/services/data/v60.0/sobjects/Account');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer '+access);
        request.setHeader('content-type','application/json');
        request.setBody(accString);
        Http h=new Http();
        HttpResponse response=h.send(request);
        return response.getBody();
    }
}