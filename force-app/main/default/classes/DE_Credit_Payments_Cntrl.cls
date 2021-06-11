public class DE_Credit_Payments_Cntrl {
    
    @AuraEnabled 
    public static Map<String,object> getCreditInformation(String recordId){
        Map<String,object> returnDataMap = new Map<String,object>();
        List<DE_Credit_Info__mdt> credInfo = [SELECT Credit_Limit__c , Payment_Due__c , Credit_Utilization__c , Due_Date__c 
                                              FROM DE_Credit_Info__mdt LIMIT 1];
        returnDataMap.put('CREDIT_INFO', credInfo);
        Visits__c lVisit = [SELECT Id, Account__r.Name,Account__r.ShippingStreet,Account__r.ShippingCity FROM Visits__c WHERE Id = :recordId];
        returnDataMap.put('VISIT_INFO', lVisit);
        return returnDataMap;
    }
}