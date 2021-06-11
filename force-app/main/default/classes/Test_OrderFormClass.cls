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
    Account a=new Account(Name='Aeth');
    insert a;
    account acc=[select id from account];
    Visits__c v=new Visits__c(Name='Abc',account__c=acc.id);
    insert v;
      Inventory__c inv = new Inventory__c();
    inv.Account__c=v.Account__c;
    inv.Visit__c=v.Id;
        
   // inv.Date__c=system.today();
    insert inv;
    system.debug('inventory'+inv);
    Inventory_Line_Item__c ilitem = new Inventory_Line_Item__c();
    Inventory__c invn=[select id from Inventory__c];
    ilitem.Inventory__c=invn.Id;
     ilitem.Product__c = '01t3h000000vwyzAAA';
                ilitem.Qty__c = 1;
   OrderFormClass.createInventory( '{"Id":"01u3h000000gee2AAA","Product2Id":"01t3h000000vwyzAAA","Pricebook2Id":"01s3h000000yiPqAAI","UnitPrice":1000,"Qty":1,"CP":1000,"visitId":"a083h000000a4oTAAQ","Productc":{"Name":"Argan Oil of Morocco","ProductCode":"GC5060","Id":"01t3h000000vwyzAAA"},"Pricebookc":{"Id":"01s3h000000yiPqAAI"}},{"Id":"01u3h000000gee3AAA","Product2Id":"01t3h000001ZdPqAAK","Pricebook2Id":"01s3h000000yiPqAAI","UnitPrice":80,"Qty":1,"CP":null,"visitId":"a083h000000a4oTAAQ","Productc":{"Name":"Axis Blue Chip","Id":"01t3h000001ZdPqAAK"},"Pricebookc":{"Id":"01s3h000000yiPqAAI"}}' ); 

    OrderFormClass.Pricebookc pri=new OrderFormClass.Pricebookc('01s3h000000yiPqAAI');
  double d=1000.0;
    double d1=1000.0;
   OrderFormClass.Productc prd=new OrderFormClass.Productc('Argan Oil of Morocco','GC5060','01t3h000000vwyzAAA');
  // Productc prd=new Productc('Argan Oil of Morocco','GC5060','01t3h000000vwyzAAA');
    OrderFormClass.invWrap inwr=new OrderFormClass.invWrap('01u3h000000gee2AAA','01t3h000000vwyzAAA','01s3h000000yiPqAAI',d,1,'a083h000000a4oTAAQ',prd,pri);
   system.debug('inwr'+inwr);
    //        public invWrap(string a,string b,string c,Double d,integer e,string i,Productc f,Pricebookc g) 
      //         public invWrap(string a,string b,string c,Double d,integer e,string i,Productc f,Pricebookc g)                                                   
   }

@isTest static void CreatorderTest() {
Account a=new Account(Name='Aeth');
    insert a;
    account acc=[select id from account];
    Visits__c v=new Visits__c(Name='Abc',account__c=acc.id);
    insert v;
    system.debug('v'+v);
    order ord=new order();
    Visits__c vis=[select id,account__c from Visits__c ];
    ord.AccountId=vis.account__c;
            ord.BillingCity='Pune';
            ord.BillingCountry='India';
            ord.BillingGeocodeAccuracy=null;
            ord.BillingLatitude=21.1626831;
            ord.BillingLongitude=79.005899;
            ord.BillingPostalCode='122334';
            ord.BillingState='MH';
            ord.BillingStreet='Amaravati';
            ord.Visit__c = v.Id;
            ord.ShippingCity='Pune';
            ord.ShippingCountry='India';
            
            ord.ShippingGeocodeAccuracy=null;
            ord.ShippingLatitude=21.1626831;
            ord.ShippingLongitude=79.005899;
            ord.ShippingPostalCode='23455';
            ord.ShippingState='Maha';
            ord.ShippingStreet='Amaravati';
            ord.Status='Draft';
            ord.Order_Status__c='New';
            ord.Pricebook2Id = '01s3h000000yiPqAAI';
            //ord.Pricebook2Id
            
            ord.EffectiveDate=system.today();
            insert ord; 
    system.debug('ord'+ord);
    //soql
   
    OrderItem ol=new OrderItem();
     order o=[select id from order];
     ol.Product2Id='01t3h000000vwyzAAA';
                ol.Quantity=4;
                ol.OrderId=o.id;
                ol.UnitPrice=1000;
                ol.PricebookEntryId='01u3h000000gee2AAA';
                // ol.TotalPrice
               // ol.Discount__c = o.Discount;
               // ol.Sales_Price__c = ol.UnitPrice*ol.Quantity *(1-ol.Discount__c/100);
               insert ol;
    system.debug('ol'+ol);
	OrderFormClass.Creatorder( '{"Id":"01u3h000000gee2AAA","Product2Id":"01t3h000000vwyzAAA","Pricebook2Id":"01s3h000000yiPqAAI","UnitPrice":1000,"Qty":1,"CP":1000,"visitId":"a083h000000a4oTAAQ","Productc":{"Name":"Argan Oil of Morocco","ProductCode":"GC5060","Id":"01t3h000000vwyzAAA"},"Pricebookc":{"Id":"01s3h000000yiPqAAI"}}' ); 
OrderFormClass.Pricebookc prck= new OrderFormClass.Pricebookc('01s3h000000yiPqAAI');
    system.debug('prck'+prck);
    double d=1000.0;
    double d1=1000.0;
    OrderFormClass.Productc prdc=new  OrderFormClass.Productc('Argan Oil of Morocco','GC5060','01t3h000000vwyzAAA');
  system.debug('prdc'+prdc);
    // OrderFormClass.invWraps inwr=new  OrderFormClass.invWraps('01u3h000000gee2AAA','01t3h000000vwyzAAA','01s3h000000yiPqAAI',d,1,'a083h000000a4oTAAQ',d1,prdc,prck);
    OrderFormClass.invWraps inwr=new OrderFormClass.invWraps('01u3h000000gee2AAA','01t3h000000vwyzAAA','01s3h000000yiPqAAI',d,1,'a083h000000a4oTAAQ',d1,prdc,prck);
    system.debug('inwr11'+inwr);
    // public invWraps(string a,string b,string c,Double d,integer e,string i,double k,Productc f,Pricebookc g)
}

}