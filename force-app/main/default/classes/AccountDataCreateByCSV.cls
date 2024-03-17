public class AccountDataCreateByCSV {
    @AuraEnabled
    public static List<Account> createAccountRecords(String base64Data) {
        String data = JSON.deserializeUntyped(base64Data).toString();
        List<Account> accList = new List<Account>();
        List<String> lstCSVLines = data.split('\n');
        for(Integer i = 1; i < lstCSVLines.size(); i++){
            Account acc = new Account();
            String csvLine = lstCSVLines[i];
            List<String> csvRowData = new List<String>();
            for(String column : csvLine.split(',')){
                column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                csvRowData.add(column);
            }
            acc.Name = csvRowData[0];
            acc.Rating = csvRowData[1];
            acc.Industry = csvRowData[2];
            accList.add(acc);
        }
        if(!accList.isEmpty()){
            insert accList;
        }
        return accList;
    }
}