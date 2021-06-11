@isTest 
private class Test_OrderFormClass {

	
@isTest static void searchBearsTest() {

	OrderFormClass.searchBears( 'searchTerm' ,'pickval' );
    OrderFormClass.searchBears( '' ,'pickval' );
    OrderFormClass.searchBears( '' ,'' );
     OrderFormClass.searchBears( 'pickval' ,'' );
}

@isTest static void SelectpicvalTest() {

	OrderFormClass.Selectpicval(); 
}

@isTest static void createInventoryTest() {

	OrderFormClass.createInventory( 'jsonString' ); 
}

@isTest static void CreatorderTest() {

	OrderFormClass.Creatorder( 'JsonStrings' ); 
}

}