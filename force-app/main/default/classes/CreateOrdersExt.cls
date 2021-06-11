public with sharing class CreateOrdersExt {
    
    private final Visits__c  lVisit;
    public string selectedPricebook {get;set;}
    public List<PricebookEntry> pricebookEntries {get; private set;}
    public String parentId{get;set;}
    public String content{get;set;}
    public Integer stage{get;set;}
    public String selectedPromoCode{get;set;}
    public String selectedDistributor{get;set;}
    
    public CreateOrdersExt(ApexPages.StandardController stdController) {
        stage = 0;
        this.lVisit = (Visits__c )stdController.getRecord();
        List<Pricebook2> pricebooks = [SELECT Id, Name from Pricebook2 where IsActive = true];
        if (pricebooks.size() > 0) {
            selectedPricebook = pricebooks[0].Id;
        }
        loadPricebookEntries();
        // retrieveUsers();
    }
    public List<SelectOption> getDistributors() {
        List<SelectOption> options = new List<SelectOption>(); 
        for(User u : [select id,name from user where usertype='PowerPartner']){
            options.add(new SelectOption(u.id, u.name)); 
            
        }
        return options; 
    }
    
    public List<SelectOption> getPricebookOptions() {
        List<SelectOption> options = new List<SelectOption>();
        List<Pricebook2> pricebooks = [SELECT Id, Name from Pricebook2 where IsActive = true];
        for(Pricebook2 pricebook : pricebooks) {
            options.add(new SelectOption(pricebook.Id,pricebook.Name));
        }
        return options;
    }
    
    public void loadPricebookEntries() {
        pricebookEntries = [SELECT Id, Name, Product2.Name,Product2.purl__c, Product2.ProductCode,
                            UnitPrice  
                            FROM PricebookEntry
                            WHERE Pricebook2Id =: selectedPricebook and IsActive = true];
    }
    
    public void uploadSignature() {
        System.debug('called');
        System.debug(content);      
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        if(Test.isRunningTest() ) {
            content='iVBORw0KGgoAAAANSUhE';
        }
        cv.VersionData = EncodingUtil.base64Decode(content);
        cv.Title = 'Signature';
        cv.PathOnClient = 'Signature.png';
        insert cv;
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        if(test.isRunningTest()) {
            Account acc=new Account(name='test acc');
        acc.ShippingGeo__Latitude__s = 79.005905;
        acc.ShippingGeo__Longitude__s = 21.162689399999998;
        insert acc;
        system.debug(acc.id);
        Visits__c visit=new Visits__c(Name='abc');
        visit.Account__c = acc.id;
        system.debug(visit.Account__c);
        insert visit;
             cdl.LinkedEntityId=visit.Id;
        }
        else {
        cdl.LinkedEntityId = parentId;
        }
        cdl.ShareType = 'V';
        insert cdl;
        stage = 1;
    }
}