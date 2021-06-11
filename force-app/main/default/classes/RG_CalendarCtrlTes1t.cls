@isTest 
private class RG_CalendarCtrlTes1t {
	@isTest static void getLoggedInUserTimeZoneTest() {
	RG_CalendarCtrl.getLoggedInUserTimeZone( ); 
}
@isTest static void testApexMethodIntegerPrmTest() {
customObj__c cstm = new customObj__c ( requiredDate__c = Date.today()  ,requiredStr__c = 'requiredStr__c' ,requiredDatetime__c = Datetime.newInstanceGmt(2020,6,1,12,1,5)  );
 Insert cstm;

	
}
@isTest static void getAllAccountsTest() {
	RG_CalendarCtrl.getAllAccounts( 'searchText' ,'selectedType' ); 
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
@isTest static void getEventsForLoggedInUserTest() {
	RG_CalendarCtrl.getEventsForLoggedInUser(  ); 
}
@isTest static void getNewEventTest() {
	RG_CalendarCtrl.getNewEvent(  ); 
}


@isTest static void updateEventTest() {
	
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
	RG_CalendarCtrl.deleteEvent( visit.id ); 
}
@isTest static void unsuppExTest() {
Account acc = new Account ( Name = 'Name'  );
 Insert acc;

Contact con = new Contact ( LastName = 'LastName'  );
 Insert con;

	
}

}