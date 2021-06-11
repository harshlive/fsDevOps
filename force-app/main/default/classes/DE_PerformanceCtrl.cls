public class DE_PerformanceCtrl {
    
    @AuraEnabled
    public static List<DE_Performance__mdt> getPerformanceRecs(){
        return [select masterlabel,order__c , Target__c from DE_Performance__mdt
                order by order__c];
        //return null;
    }

}