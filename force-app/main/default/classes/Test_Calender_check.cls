@isTest
private class Test_Calender_check {
 


	
@isTest static void getLoggedInUserTimeZoneTest() {


	CalenderCheck.getLoggedInUserTimeZone(); 
}

@isTest static void testApexMethodIntegerPrmTest() {
	customObj__c cstmLstobj0 = new customObj__c ( requiredDate__c = Date.today()  ,requiredStr__c = 'requiredStr__c' ,requiredDatetime__c = Datetime.newInstanceGmt(2020,6,1,12,1,5)  );
	 Insert cstmLstobj0;
	customObj__c cstmLstobj1 = new customObj__c ( requiredDate__c = Date.today()  ,requiredStr__c = 'requiredStr__c' ,requiredDatetime__c = Datetime.newInstanceGmt(2020,6,1,12,1,5)  );
	 Insert cstmLstobj1;
	customObj__c cstmLstobj2 = new customObj__c ( requiredDate__c = Date.today()  ,requiredStr__c = 'requiredStr__c' ,requiredDatetime__c = Datetime.newInstanceGmt(2020,6,1,12,1,5)  );
	 Insert cstmLstobj2;
	List<customObj__c> cstmLst = new List<customObj__c> ();
	cstmLst.add(cstmLstobj0);
	cstmLst.add(cstmLstobj1);
	cstmLst.add(cstmLstobj2);



	CalenderCheck.testApexMethodIntegerPrm( 10 ,'str_input' ,Date.today() ,Datetime.newInstanceGmt(2020,6,1,12,1,5) , cstmLst); 
}

@isTest static void getAllLeadTest() {

	CalenderCheck.getAllLead( 'searchText' ); 
}

@isTest static void getUsersFromDbTest() {

	CalenderCheck.getUsersFromDb(); 
}

@isTest static void getAllSurveysTest() {

	CalenderCheck.getAllSurveys(); 
}

@isTest static void getEventsTest() {

	CalenderCheck.getEvents( 'selectedUser' ); 
}

@isTest static void getEventsForLoggedInUserTest() {

	CalenderCheck.getEventsForLoggedInUser(); 
}

@isTest static void getNewEventTest() {

	CalenderCheck.getNewEvent(); 
}

@isTest static void saveNewEventWithSurveysTest() {
Profile p = [SELECT Id FROM Profile where name ='system administrator' limit 1]; 
  User u1 = new User(Alias = 'standa', Email='sap@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles', UserName='sap@testorg.com');

    insert u1 ;
    System.runAs(u1) {
     Lead l=new Lead(Company = 'JohnMiller',OwnerId=u1.id, LastName = 'Mike', Status = 'Open');
    insert l;
       CalenderCheck.saveNewEventWithSurveys( l.OwnerId ,'subject' ,'04/27/2020 12:00 AM' ,'04/27/2020 12:00 AM' ,l.Id ,'selectedSurveys' ); 

    }
	 
	}

@isTest static void saveNewEventTest() {
Profile p = [SELECT Id FROM Profile where name ='system administrator' limit 1]; 
  User u1 = new User(Alias = 'standa', Email='sap@testorg.com',
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', ProfileId = p.Id,
      TimeZoneSidKey='America/Los_Angeles', UserName='sap@testorg.com');

    insert u1 ;
    System.runAs(u1) {
     Lead l=new Lead(Company = 'JohnMiller',OwnerId=u1.id, LastName = 'Mike', Status = 'Open');
    insert l;
        CalenderCheck.saveNewEvent( l.OwnerId ,l.Id ,'abc','04/27/2020 12:00 AM' ,'04/27/2020 12:00 AM' );
    }
	 
    
	
}

@isTest static void updateEventTest() {
 Account acc=new Account(name='test acc');
        acc.ShippingGeo__Latitude__s = 79.005905;
        acc.ShippingGeo__Longitude__s = 21.162689399999998;
        insert acc;
        system.debug(acc.id);
         Visits__c visit=new Visits__c(Name='abc');
        visit.Account__c = acc.id;
        system.debug(visit.Account__c);
        insert visit;
	CalenderCheck.updateEvent( visit.id ,'04/27/2020 12:00 AM' ,'04/27/2020 12:00 AM' ); 
}

@isTest static void updateOlderEventTest() {
 Account acc=new Account(name='test acc');
        acc.ShippingGeo__Latitude__s = 79.005905;
        acc.ShippingGeo__Longitude__s = 21.162689399999998;
        insert acc;
        system.debug(acc.id);
         Visits__c visit=new Visits__c(Name='abc');
        visit.Account__c = acc.id;
        system.debug(visit.Account__c);
        insert visit;
	CalenderCheck.updateOlderEvent( visit.id ,'subject' ,'04/27/2020 12:00 AM' ,'04/27/2020 12:00 AM' ,'selectedSurveys' ,'allEvents' ); 
}

@isTest static void deleteEventTest() {
 Account acc=new Account(name='test acc');
        acc.ShippingGeo__Latitude__s = 79.005905;
        acc.ShippingGeo__Longitude__s = 21.162689399999998;
        insert acc;
        system.debug(acc.id);
         Visits__c visit=new Visits__c(Name='abc');
        visit.Account__c = acc.id;
        system.debug(visit.Account__c);
        insert visit;
	CalenderCheck.deleteEvent( visit.id ); 
}


}