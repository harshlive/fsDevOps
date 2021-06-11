@isTest
public class CheckOutClassTest {
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
        CheckOutClass.checkOut( '21.162689399999998', '79.005905',visit.id);
    }
   
    @isTest static void  LocationAPIResponseTest(){
        CheckOutClass.LocationAPIResponse LP= new CheckOutClass.LocationAPIResponse();
        LP.lat=21.162689399999998;
        LP.lon=79.005905;
    }

}