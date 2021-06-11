@isTest 
private class RG_CalendarCtrlTest {
	@isTest static void getLoggedInUserTimeZoneTest() {
	RG_CalendarCtrl.getLoggedInUserTimeZone( ); 
}
@isTest static void getAllAccountsTest() {
	RG_CalendarCtrl.getAllAccounts( 'searchText' ,'selectedType' ); 
    RG_CalendarCtrl.getAllAccounts( 'searchText' ,'' );
    RG_CalendarCtrl.getAllAccounts( '' ,'' );
    RG_CalendarCtrl.getAllAccounts( '' ,'selectedType' ); 
}
@isTest static void getGradesTest() {
	RG_CalendarCtrl.getGrades(); 
}
@isTest static void getUsersFromDbTest() {
	RG_CalendarCtrl.getUsersFromDb(); 
}
@isTest static void getAllSurveysTest() {
	RG_CalendarCtrl.getAllSurveys(); 
}
@isTest static void getEventsTest() {
	RG_CalendarCtrl.getEvents( 'selectedUser' ); 
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
        Account acc=new Account(name='test acc');
        acc.ShippingGeo__Latitude__s = 79.005905;
        acc.ShippingGeo__Longitude__s = 21.162689399999998;
        insert acc;
       RG_CalendarCtrl.saveNewEventWithSurveys( l.OwnerId ,'subject' ,'04/27/2020 12:00 AM' ,'04/27/2020 12:00 AM' ,acc.Id ,'selectedSurveys' ); 

    }
}
@isTest static void saveNewEventTest() {
     Account acc=new Account(name='test acc');
        acc.ShippingGeo__Latitude__s = 79.005905;
        acc.ShippingGeo__Longitude__s = 21.162689399999998;
        insert acc;
	RG_CalendarCtrl.saveNewEvent( userinfo.getUserId() ,acc.id ,'subject' ,'04/27/2020 12:00 AM' ,'04/27/2020 12:00 AM'); 
}
@isTest static void updateEventTest() {
	//RG_CalendarCtrl.updateEvent( 'eventId' ,'startDateTime' ,'endDateTime' );
    Account acc=new Account(name='test acc');
        acc.ShippingGeo__Latitude__s = 79.005905;
        acc.ShippingGeo__Longitude__s = 21.162689399999998;
        insert acc;
        system.debug(acc.id);
         Visits__c visit=new Visits__c(Name='abc');
        visit.Account__c = acc.id;
        system.debug(visit.Account__c);
        insert visit; 
	RG_CalendarCtrl.updateEvent( visit.id ,'04/27/2020 12:00 AM' ,'04/27/2020 12:00 AM' ); 
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
	RG_CalendarCtrl.updateOlderEvent( visit.id ,'subject' ,'04/27/2020 12:00 AM' ,'04/27/2020 12:00 AM' ,'selectedSurveys' ,'allEvents' ); 
}

    @isTest static void getEventsForLoggedInUserTest() {

	RG_CalendarCtrl.getEventsForLoggedInUser(); 
}

}