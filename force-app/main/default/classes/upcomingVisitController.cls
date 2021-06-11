public class upcomingVisitController {
    @AuraEnabled
    public static Map<String,List<Visits__c>> getVisits(){ 
        Map<String,List<Visits__c>> visitsMap = new Map<String,List<Visits__c>>();
        visitsMap.put('TODAY',[SELECT Id,Name,Planned_Start__c,Status__c,Lead__r.Name,Lead__r.Company,Planned_End__c,Account__r.Name,Account__r.Id,Account__r.Phone,Account__r.Website,Account__r.ShippingStreet,Account__r.ShippingState,Account__r.ShippingCity,Account__r.ShippingCountry,Account__r.ShippingPostalCode FROM Visits__c WHERE OwnerId = :UserInfo.getUserId() AND DAY_ONLY (Planned_Start__c) = :System.today()]);
        visitsMap.put('TOMORROW',[SELECT Id,Name,Planned_Start__c,Status__c,Lead__r.Name,Lead__r.Company,Planned_End__c,Account__r.Name,Account__r.Id,Account__r.Phone,Account__r.Website,Account__r.ShippingStreet,Account__r.ShippingState,Account__r.ShippingCity,Account__r.ShippingCountry,Account__r.ShippingPostalCode FROM Visits__c WHERE OwnerId = :UserInfo.getUserId() AND DAY_ONLY (Planned_Start__c) = :System.today().addDays(1)]);
        return visitsMap;
    }
}