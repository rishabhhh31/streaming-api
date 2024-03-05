public with sharing class SalesforceOAuth {
    @AuraEnabled
    public static String getAccessToken(String code) {
        HttpRequest request=new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://resilient-shark-8carn7-dev-ed.trailblaze.my.salesforce.com/services/oauth2/token');
        String body='grant_type=authorization_code&';
        body+='code='+code+'&';
        body+='client_id=3MVG9n_HvETGhr3BwHHbRwCSgGmIz6rPfQDaD.ZrFlUGbT4blhqJb1SQl2TCxTf7.VT.xZCpXkoqe8BhnOQzX&';
        body+='client_secret=8E08A66407FBA554D2A5013E5B42EABCF4D7B7D57150DF64A1843D675B48BE0D&';
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