public with sharing class ListViewAPI {
    public static void getListView(){
        System.debug(Url.getOrgDomainUrl());
        String endpoint='https://helioswebservice2-dev-ed.develop.my.salesforce.com/services/data/v60.0/sobjects/Account/listviews/00BF9000007eyMfMAI/results';
        HttpRequest request=new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer '+UserInfo.getSessionId());
        Http h=new Http();
        HttpResponse response=h.send(request);
        if(response.getStatusCode()==200){
            System.debug(JSON.serialize(response.getBody()));
        }
    }
}