@isTest(SeeAllData=true)
private class ShowLocationClassTest {
	
@isTest static void checkOutTest() {
	Account acc=new Account(name='test acc');
        acc.ShippingGeo__Latitude__s = 79.005905;
        acc.ShippingGeo__Longitude__s = 21.162689399999998;
        insert acc;
         Visits__c visit=new Visits__c(Name='abc');
        visit.Account__c = acc.id;
        insert visit;
	ShowLocationClass.checkOut( '21.162689399999998', '79.005905' ,visit.Id ); 
}

@isTest static void fetchAccountTest() {

	ShowLocationClass.fetchAccount(); 
}

@isTest static void getAccountTest() {

	ShowLocationClass.getAccount( '21.162689399999998', '79.005905' ,10 ); 
}

@isTest static void fetchLeadTest() {

	ShowLocationClass.fetchLead(); 
}

@isTest static void getLeadTest() {

	ShowLocationClass.getLead('21.162689399999998', '79.005905' ,10 ); 
}

}