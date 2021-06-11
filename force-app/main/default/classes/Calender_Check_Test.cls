@isTest
public class Calender_Check_Test {


  @testSetup
  static void setupTestData(){
    test.startTest();
    Contact contact_Obj = new Contact(LastName = 'LastName421');
    Insert contact_Obj; 
    test.stopTest();
  }
  
      static testMethod void test_getAllLead(){
         // CalenderCheck obj01 = new CalenderCheck();
   // obj061.lead = lead_Obj[0];
      CalenderCheck.getAllLead('test data');    

      }
  //  static testMethod void test_getEvents(){
    //    CalenderCheck.getEvents('test data');
    //}
    
	@isTest static void getLoggedInUserTimeZoneTest() {
	CalenderCheck.getLoggedInUserTimeZone( ); 
}
//@isTest static void testApexMethodIntegerPrmTest() {
//customObj__c cstm = new customObj__c ( requiredDate__c = Date.today()  ,requiredStr__c = 'requiredStr__c' ,requiredDatetime__c = Datetime.newInstanceGmt(2020,6,1,12,1,5)  );
 //Insert cstm;

	//CalenderCheck.testApexMethodIntegerPrm( 10 ,'str_input' ,Date.today() ,Datetime.newInstanceGmt(2020,6,1,12,1,5) , cstm); 
//}
//@isTest static void getAllAccountsTest() {
//	CalenderCheck.getAllAccounts( 'searchText' ,'selectedType' ); 
//}
//@isTest static void getGradesTest() {
//	CalenderCheck.getGrades(); 
//}
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
	CalenderCheck.getEventsForLoggedInUser(  ); 
}
@isTest static void getNewEventTest() {
	CalenderCheck.getNewEvent(  ); 
}
@isTest static void saveNewEventWithSurveysTest() {
  
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
    
}
@isTest static void updateOlderEventTest() {
   
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
/*@isTest static void unsuppExTest() {
account acc = new account (Name = 'Name'  );
 Insert acc;

Contact con = new Contact ( LastName = 'LastName'  );
 Insert con;

	CalenderCheck.unsuppEx(  con, acc,'name' ); 


}*/

    
    
    
    
    
    
}