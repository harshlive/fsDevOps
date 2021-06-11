@isTest 
private class CreateInventoryExtTest {
    
    @isTest static void getPricebookOptionsTest() {
        Account acc=new Account(name='test acc');
        acc.ShippingGeo__Latitude__s = 79.005905;
        acc.ShippingGeo__Longitude__s = 21.162689399999998;
        insert acc;
        system.debug(acc.id);
        Visits__c visit=new Visits__c(Name='abc');
        visit.Account__c = acc.id;
        system.debug(visit.Account__c);
        insert visit;
        New CreateInventoryExt(new ApexPages.StandardController( visit )).getPricebookOptions(); 
    }
    
    @isTest static void loadPricebookEntriesTest() {
        Account acc=new Account(name='test acc');
        acc.ShippingGeo__Latitude__s = 79.005905;
        acc.ShippingGeo__Longitude__s = 21.162689399999998;
        insert acc;
        system.debug(acc.id);
        Visits__c visit=new Visits__c(Name='abc');
        visit.Account__c = acc.id;
        system.debug(visit.Account__c);
        insert visit;
        New CreateInventoryExt(new ApexPages.StandardController( visit )).loadPricebookEntries(); 
    }
    
}