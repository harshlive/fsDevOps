@isTest
private class RG_CalendarCtrl_Test{
  @testSetup
  static void setupTestData(){
    test.startTest();
    Contact contact_Obj = new Contact(LastName = 'LastName421');
    Insert contact_Obj; 
    test.stopTest();
  }
  static testMethod void test_getLoggedInUserTimeZone_UseCase1(){
    List<Contact> contact_Obj  =  [SELECT LastName from Contact];
    System.assertEquals(true,contact_Obj.size()>0);
    RG_CalendarCtrl obj01 = new RG_CalendarCtrl();
    obj01.contact = contact_Obj[0];
    RG_CalendarCtrl.getLoggedInUserTimeZone();
  }
  static testMethod void test_getAllAccounts_UseCase1(){
    List<Contact> contact_Obj  =  [SELECT LastName from Contact];
    System.assertEquals(true,contact_Obj.size()>0);
    RG_CalendarCtrl obj01 = new RG_CalendarCtrl();
    obj01.contact = contact_Obj[0];
    RG_CalendarCtrl.getAllAccounts('test data','test data');
  }
  static testMethod void test_getGrades_UseCase1(){
    List<Contact> contact_Obj  =  [SELECT LastName from Contact];
    System.assertEquals(true,contact_Obj.size()>0);
    RG_CalendarCtrl obj01 = new RG_CalendarCtrl();
    obj01.contact = contact_Obj[0];
    RG_CalendarCtrl.CustomSelectOption obj41 = new RG_CalendarCtrl.CustomSelectOption('test data','test data');
    obj41.label = 'test data';
    obj41.value = 'test data';
    RG_CalendarCtrl.CustomSelectOption.getGrades();
  }
  static testMethod void test_getUsersFromDb_UseCase1(){
    List<Contact> contact_Obj  =  [SELECT LastName from Contact];
    System.assertEquals(true,contact_Obj.size()>0);
    RG_CalendarCtrl obj01 = new RG_CalendarCtrl();
    obj01.contact = contact_Obj[0];
    RG_CalendarCtrl.CustomSelectOption obj41 = new RG_CalendarCtrl.CustomSelectOption('test data','test data');
    obj41.label = 'test data';
    obj41.value = 'test data';
    RG_CalendarCtrl.CustomSelectOption.getUsersFromDb();
  }
  static testMethod void test_getAllSurveys_UseCase1(){
    List<Contact> contact_Obj  =  [SELECT LastName from Contact];
    System.assertEquals(true,contact_Obj.size()>0);
    RG_CalendarCtrl obj01 = new RG_CalendarCtrl();
    obj01.contact = contact_Obj[0];
    RG_CalendarCtrl.CustomSelectOption obj41 = new RG_CalendarCtrl.CustomSelectOption('test data','test data');
    obj41.label = 'test data';
    obj41.value = 'test data';
    RG_CalendarCtrl.CustomSelectOption.getAllSurveys();
  }
    
}