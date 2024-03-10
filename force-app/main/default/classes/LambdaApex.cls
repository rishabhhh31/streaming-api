public with Sharing class LambdaApex {
    @AuraEnabled
    public static String callRestQuery(){ 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://helioswebservice2-dev-ed.develop.my.salesforce.com/services/data/v60.0/query/?q=SELECT+Name+FROM+Account+ORDER+BY+Name+LIMIT+5');
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer '+userinfo.getSessionId());
        Http h = new Http();
        HttpResponse response = h.send(request);
        return response.getBody();
    }
}