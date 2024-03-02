public with Sharing class LambdaApex {
    @AuraEnabled
    public static String callRestQuery(){ 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://helioswebservice2-dev-ed.develop.my.salesforce.com/services/data/v60.0/query/?q=SELECT+Name+FROM+Account+ORDER+BY+Name+LIMIT+5');
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer 00DF9000001DvQg!ARIAQOs4rrO_PeveUtG_sSLrw73ldOPA3cqCS2f5D7REAo.QabAnEo6i1nuctTz0EcXi7kPl8B_G7YqfumXuCK6En25W.KVP');
        Http h = new Http();
        HttpResponse response = h.send(request);
        return response.getBody();
    }
}