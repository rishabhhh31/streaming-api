public Without Sharing class ExecuteCodeCtrl {
    @AuraEnabled
    public static String executeCode(String script) {
        String baseURL = URL.getOrgDomainUrl().toExternalForm() + '/services/data/v58.0/tooling/executeAnonymous/?';
        Http h = new Http();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(baseUrl + 'anonymousBody=' + EncodingUtil.urlEncode(script, 'UTF-8'));
        req.setMethod('GET');
        req.setTimeout(120000);
        req.setHeader('Authorization','Bearer ' + UtilsGetSessionId.getSessionIdFromVFPage(Page.GetSessionId));
        HttpResponse res = h.send(req);
        System.debug(res.getBody());
        if (res.getStatusCode() != 200 && res.getStatusCode() != 201) {
            throw newMessageException('Error: Code did not execute. Please check your code | Status code : ' + res.getStatus());
        } else {
            WrapperClass wrap = parse(res.getBody());
            if(wrap.success){
                return 'Code runs successfully.';
            } else{
               String errorMessage = wrap.compileProblem != null ? wrap.compileProblem : (wrap.exceptionMessage != null ? wrap.exceptionMessage : '');
               throw newMessageException('Error: Code did not execute. Please check your code | Issue : ' + errorMessage);
            }
        }
    }
    private static AuraHandledException newMessageException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
      }
    public class WrapperClass {
        public Integer line;
        public Integer column;
        public Boolean compiled;
        public Boolean success;
        public String compileProblem;
        public String exceptionStackTrace;
        public String exceptionMessage;
    }
    public static WrapperClass parse(String json) {
        return (WrapperClass) System.JSON.deserialize(json, WrapperClass.class);
    }
}