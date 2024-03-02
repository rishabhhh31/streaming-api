public with sharing class CustomChangeDataChannel {
    @AuraEnabled
    public static String createCustomChannel(){
        HttpRequest request=new HttpRequest();
        request.setEndpoint('https://helioswebservice2-dev-ed.develop.my.salesforce.com/services/data/v60.0/tooling/sobjects/PlatformEventChannel');
        request.setMethod('POST');
        request.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        String jsonString=generateJSON();
        request.setBody(jsonString);
        request.setHeader('content-type','application/json');
        Http h=new Http();
        HttpResponse response = h.send(request);
        return response.getBody();        
    }
    public static String generateJSON() {
        Map<String, Object> jsonData = new Map<String, Object>();
        Map<String, Object> metadata = new Map<String, Object>();
        jsonData.put('FullName', 'ERP_Channel__chn');
        metadata.put('channelType', 'data');
        metadata.put('label', 'Channel for the ERP System');
        jsonData.put('Metadata', metadata);
        String jsonString = JSON.serialize(jsonData);
        return jsonString;
    }
    public static String generateJSONMember() {
        Map<String, Object> jsonData = new Map<String, Object>();
        Map<String, Object> metadata = new Map<String, Object>();
        metadata.put('eventChannel', 'ERP_Channel__chn');
        metadata.put('selectedEntity', 'ContactChangeEvent');
        jsonData.put('FullName', 'ERP_Channel_chn_ContactChangeEvent');
        jsonData.put('Metadata', metadata);
        String jsonString = JSON.serialize(jsonData);
        return jsonString;
    }
    public static String generateJSONFilter() {
        Map<String, Object> jsonData = new Map<String, Object>();
        Map<String, Object> metadata = new Map<String, Object>();
        metadata.put('eventChannel', 'ERP_Channel__chn');
        metadata.put('selectedEntity', 'AccountChangeEvent');
        metadata.put('filterExpression', 'Active__c=\'Yes\'');
        jsonData.put('FullName', 'ERP_Channel_chn_AccountChangeEvent');
        jsonData.put('Metadata', metadata);
        String jsonString = JSON.serialize(jsonData);
        return jsonString;
    }
    public static String generateJSONEnrichField() {
        Map<String, Object> jsonData = new Map<String, Object>();
        Map<String, Object> metadata = new Map<String, Object>();
        metadata.put('eventChannel', 'ERP_Channel__chn');
        metadata.put('selectedEntity', 'AccountChangeEvent');
        List<Map<String, String>> enrichedFields = new List<Map<String, String>>();

        Map<String, String> enrichedField1 = new Map<String, String>();
        enrichedField1.put('name', 'Rating');
        enrichedFields.add(enrichedField1);
        
        Map<String, String> enrichedField2 = new Map<String, String>();
        enrichedField2.put('name', 'Industry');
        enrichedFields.add(enrichedField2);

        metadata.put('enrichedFields', enrichedFields);
        jsonData.put('FullName', 'ERP_Channel_chn_AccountChangeEvent');
        jsonData.put('Metadata', metadata);
        String jsonString = JSON.serialize(jsonData);
        return jsonString;
    }
    @AuraEnabled
    public static String createChannelMembers(){
        HttpRequest request=new HttpRequest();
        request.setEndpoint('https://helioswebservice2-dev-ed.develop.my.salesforce.com/services/data/v60.0/tooling/sobjects/PlatformEventChannelMember');
        request.setMethod('POST');
        request.setHeader('Authorization','Bearer 00DF9000001DvQg!ARIAQHjCAHt5l.sA31R8x.3Jj_BJpOa4e_61Y8uOZN6FE7J0kQXR.tPSyxdbZE9nlzM_OoqczMXlc0BQStaBI5ft5nM_virE');
        String jsonString=generateJSONMember();
        request.setBody(jsonString);
        request.setHeader('content-type','application/json');
        Http h=new Http();
        HttpResponse response = h.send(request);
        return response.getBody(); 
    }
    @AuraEnabled
    public static String createEnrichField(){
        HttpRequest request=new HttpRequest();
        request.setEndpoint('https://helioswebservice2-dev-ed.develop.my.salesforce.com/services/data/v60.0/tooling/sobjects/PlatformEventChannelMember/0v8F9000000blmoIAA');
        request.setMethod('PATCH');
        request.setHeader('Authorization','Bearer 00DF9000001DvQg!ARIAQHjCAHt5l.sA31R8x.3Jj_BJpOa4e_61Y8uOZN6FE7J0kQXR.tPSyxdbZE9nlzM_OoqczMXlc0BQStaBI5ft5nM_virE');
        String jsonString=generateJSONEnrichField();
        request.setBody(jsonString);
        request.setHeader('content-type','application/json');
        Http h=new Http();
        HttpResponse response = h.send(request);
        System.debug(response.getStatusCode());
        return response.getBody(); 
    }
    @AuraEnabled
    public static Integer createFilterChannel(){
        HttpRequest request=new HttpRequest();
        request.setEndpoint('https://helioswebservice2-dev-ed.develop.my.salesforce.com/services/data/v60.0/tooling/sobjects/PlatformEventChannelMember/0v8F9000000blmoIAA');
        request.setMethod('PATCH');
        request.setHeader('Authorization','Bearer 00DF9000001DvQg!ARIAQFbxtFfE.EtNHtaN5DbrlMoBQJ6KrvJ3H9.TNVAzVIOo9NXd1XEOpPUrOf9obsEb19fHCozWdeovF4Z8eQ9qYoMnoaP7');
        String jsonString=generateJSONFilter();
        request.setBody(jsonString);
        request.setHeader('content-type','application/json');
        Http h=new Http();
        HttpResponse response = h.send(request);
        System.debug(response.getStatus());
        return response.getStatusCode(); 
    }
}