@RestResource(urlMapping='/api/webhook/*')
Global with sharing class WebhookHandler {
    @HttpPost
    Global static String handlePost() {
        RestRequest request=RestContext.request;
        RestResponse response=RestContext.response;
        Account acc=(Account)JSON.deserialize(request.requestBody.toString(), Account.class);
        insert acc;
        if(acc.Id != null){
            ResponseToClient rc=new ResponseToClient();
            rc.accId=acc.Id;
            rc.isSuccess = 'success';
            return JSON.serialize(rc);
        }
        return 'Error';
    }
    class ResponseToClient{
        public String isSuccess;
        public String accId;
    }
}
//https://helioswebservice2-dev-ed.develop.my.salesforce-sites.com/services/apexrest/api/webhook