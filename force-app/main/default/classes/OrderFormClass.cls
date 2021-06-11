public with sharing class OrderFormClass {  
    @AuraEnabled(Cacheable=true)
    public static list<PricebookEntry> searchBears(String searchTerm,String pickval) {
        system.debug('searchTerm '+searchTerm);
        system.debug('pickval '+pickval);
        searchTerm = searchTerm.trim();
        if (searchTerm == '' && pickval == '') {
            searchTerm = '%'+ searchTerm +'%';
            return [SELECT Id,  Product2.Name,Pricebook2.id, Product2.ProductCode,
                    convertCurrency(UnitPrice) 
                    FROM PricebookEntry where  IsActive = true];
        } 
        else if(searchTerm == '' && pickval != '') {
            return  [SELECT Id, Pricebook2.id,Pricebook2.Name ,Product2.Name, Product2.ProductCode,
                     convertCurrency(UnitPrice)  
                     FROM PricebookEntry where Pricebook2.id  =:pickval];
        }
        else if(searchTerm != '' && pickval == ''){
            searchTerm = '%'+ searchTerm +'%';
            return  [SELECT Id, Pricebook2.id,Pricebook2.Name ,Product2.Name, Product2.ProductCode,
                     convertCurrency(UnitPrice)  
                     FROM PricebookEntry where (Product2.Name LIKE : searchTerm
                                                OR Product2.ProductCode LIKE : searchTerm)];
        }
        else {
            system.debug('Inside last queryResult');
            searchTerm = '%'+ searchTerm +'%';
            system.debug(searchTerm);
            system.debug(pickval);
            system.debug([SELECT Id, Pricebook2.id,Pricebook2.Name ,Product2.Name, Product2.ProductCode,
                          convertCurrency(UnitPrice) 
                          FROM PricebookEntry where (Product2.Name LIKE : searchTerm
                                                     OR Product2.ProductCode LIKE : searchTerm) AND Pricebook2.id  =:pickval]);
            return  [SELECT Id, Pricebook2.id,Pricebook2.Name ,Product2.Name, Product2.ProductCode,
                     convertCurrency(UnitPrice) 
                     FROM PricebookEntry where (Product2.Name LIKE : searchTerm
                                                OR Product2.ProductCode LIKE : searchTerm) AND Pricebook2.id  =:pickval];
        }
        
        
    }
    @AuraEnabled(Cacheable=true)
    public static list<Pricebook2> Selectpicval() {
        return [SELECT Id, Name from Pricebook2 where IsActive = true];
        
    }
    @AuraEnabled
    public static void createInventory(String jsonString) {
        try{  
            system.debug(jsonString);
            List<invWrap> iliList = (List<invWrap>) JSON.deserialize(jsonString, List<invWrap>.class);
            system.debug(iliList);
            Inventory__c inv = new Inventory__c();
            inv.Visit__c = iliList[0].visitId;
            Visits__c visit = [SELECT id,account__c,Actual_Start__c from Visits__c where id =:iliList[0].visitId LIMIT 1];
            system.debug(iliList[0].visitId);
            inv.Account__c = visit.Account__c;
            inv.Date__c = (Date)visit.Actual_Start__c;
            insert inv;
            List<Inventory_Line_Item__c> iliLst = new List<Inventory_Line_Item__c>();
            for(invWrap ili : iliList) {
                Inventory_Line_Item__c ilitem = new Inventory_Line_Item__c();
                ilitem.Product__c = ili.Product2Id;
                ilitem.Qty__c = (Double) ili.Qty;
                ilitem.Inventory__c =inv.Id;
                iliLst.add(ilitem) ;
            }
            insert(iliLst);
        }
        catch(Exception e){
            System.debug('--->'+e);
        }
    }
    public class Pricebookc {
        public string Id{get;set;}
        public Pricebookc(string a){
            Id=a;
        }
    }
    public class Productc {
        public string Name{get;set;}
        public string ProductCode{get;set;}
        public string Id{get;set;}
        public Productc(string a,string b,string c){
            Name = a;
            ProductCode = b;
            Id = c; 
        }
    }
    public class invWrap {
        public string Id{get;set;}
        public string Product2Id{get;set;}
        public string Pricebook2Id{get;set;}
        public Double UnitPrice{get;set;}
        public integer Qty{get;set;}
        public string visitId{get;set;}
        public Productc Product2{get;set;}
        public Pricebookc Pricebook2{get;set;}
        public invWrap(string a,string b,string c,Double d,integer e,string i,Productc f,Pricebookc g){
            Id = a;
            Product2Id = b;
            Pricebook2Id = c; 
            UnitPrice = d;
            Qty = e;   
            visitId = i;
            Product2 = f;
            Pricebook2 = g;            
        }
    }
    @AuraEnabled
    public static string Creatorder(string JsonStrings){
        
        
        try{  
            system.debug(JsonStrings);
            List<invWraps> orderList = (List<invWraps>) JSON.deserialize(JsonStrings, List<invWraps>.class);
            system.debug(orderList);
            Order ord = new Order();
            
            Visits__c visit = [SELECT id,account__c from Visits__c where id =:orderList[0].visitId LIMIT 1];
            
            Account acc = [SELECT Id, BillingCity, BillingStreet, BillingState, BillingPostalCode, 
                           BillingCountry, BillingLatitude, BillingLongitude, BillingAddress, BillingGeocodeAccuracy, ShippingCity, 
                           ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, 
                           ShippingLatitude, ShippingLongitude, ShippingGeocodeAccuracy, ShippingAddress FROM Account
                           where id=:visit.Account__c LIMIT 1];
            system.debug(orderList[0].visitId);
            ord.AccountId=acc.id;
            ord.BillingCity=acc.BillingCity;
            ord.BillingCountry=acc.BillingCountry;
            ord.BillingGeocodeAccuracy=acc.BillingGeocodeAccuracy;
            ord.BillingLatitude=acc.BillingLatitude;
            ord.BillingLongitude=acc.BillingLongitude;
            ord.BillingPostalCode=acc.BillingPostalCode;
            ord.BillingState=acc.BillingState;
            ord.BillingStreet=acc.BillingStreet;
            ord.Visit__c = visit.Id;
            ord.ShippingCity=acc.ShippingCity;
            ord.ShippingCountry=acc.ShippingCountry;
            
            ord.ShippingGeocodeAccuracy=acc.ShippingGeocodeAccuracy;
            ord.ShippingLatitude=acc.ShippingLatitude;
            ord.ShippingLongitude=acc.ShippingLongitude;
            ord.ShippingPostalCode=acc.ShippingPostalCode;
            ord.ShippingState=acc.ShippingState;
            ord.ShippingStreet=acc.ShippingStreet;
            ord.Status='Draft';
            ord.Order_Status__c='New';
            ord.Pricebook2Id = orderList[0].Pricebook2Id;
            //ord.Pricebook2Id
            
            ord.EffectiveDate=system.today();
            insert ord;   
            system.debug(ord.id);
            //  inv.Date__c = (Date)visit.Actual_Start__c;
            
            list<OrderItem> ordlineitem=new list<OrderItem>();
            for(invWraps o:orderList){
                OrderItem ol=new OrderItem();
                ol.Product2Id=o.Product2Id;
                ol.Quantity=(Double)o.Qty;
                ol.OrderId=ord.id;
                ol.UnitPrice=o.UnitPrice;
                ol.PricebookEntryId=o.id;
                // ol.TotalPrice
                ol.Discount__c = o.Discount;
                ol.Sales_Price__c = ol.UnitPrice*ol.Quantity *(1-ol.Discount__c/100);
                ordlineitem.add(ol);
            }    
            system.debug(ordlineitem);
            insert ordlineitem;
            return ord.id;        
        }
        
        catch(Exception e){
            System.debug('--->'+e);
            return  null;
        }
    }
    
    public class Pricebookcs {
        public string Id{get;set;}
        public Pricebookcs(string a){
            Id=a;
        }
    }
    public class Productcs {
        public string Name{get;set;}
        public string ProductCode{get;set;}
        public string Id{get;set;}
        public Productcs(string a,string b,string c){
            Name = a;
            ProductCode = b;
            Id = c; 
        }
    }
    public class invWraps {
        public string Id{get;set;}
        public string Product2Id{get;set;}
        public string Pricebook2Id{get;set;}
        public double UnitPrice{get;set;}
        public double Discount{get;set;}
        public integer Qty{get;set;}
        public string visitId{get;set;}
        public Productc Product2{get;set;}
        public Pricebookc Pricebook2{get;set;}
        public invWraps(string a,string b,string c,Double d,integer e,string i,double k,Productc f,Pricebookc g){
            Id = a;
            Product2Id = b;
            Pricebook2Id = c; 
            UnitPrice = d;
            Qty = e;   
            Discount =k;
            visitId = i;
            Product2 = f;
            Pricebook2 = g;            
        }
    }
}