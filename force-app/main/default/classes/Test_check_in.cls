@isTest (SeeAllData=true)
private class Test_check_in {
    @isTest static void checkInTest(){
        Account acc=new Account(name='test acc');
        acc.ShippingGeo__Latitude__s = 79.005905;
        acc.ShippingGeo__Longitude__s = 21.162689399999998;
        insert acc;
        system.debug(acc.id);
         Visits__c visit=new Visits__c(Name='abc');
        visit.Account__c = acc.id;
        system.debug(visit.Account__c);
        insert visit;
        checkInClass.checkIn(visit.id, '21.162689399999998', '79.005905');
    }
    @isTest static void checkOutTest(){
        Account acc=new Account(name='test acc');
        acc.ShippingGeo__Latitude__s = 79.005905;
        acc.ShippingGeo__Longitude__s = 21.162689399999998;
        insert acc;
        system.debug(acc.id);
         Visits__c visit=new Visits__c(Name='abc');
        visit.Account__c = acc.id;
        system.debug(visit.Account__c);
        insert visit;
        checkInClass.checkOut(visit.id);
    }
    @isTest static void  LocationAPIResponseTest(){
        checkInClass.LocationAPIResponse LP= new checkInClass.LocationAPIResponse();
        LP.lat=21.162689399999998;
        LP.lon=79.005905;
    }
}