@isTest 
private class DE_Credit_Payments_CntrlTest {
    
    @isTest static void getCreditInformationTest() {
        Visits__c vs = new visits__c();
        insert vs;
        DE_Credit_Payments_Cntrl.getCreditInformation( vs.Id ); 
    }
    
}