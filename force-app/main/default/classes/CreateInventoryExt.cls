public with sharing class CreateInventoryExt {

    private final Visits__c  lVisit;
    public string selectedPricebook {get;set;}
    public List<PricebookEntry> pricebookEntries {get; private set;}
    
    public CreateInventoryExt(ApexPages.StandardController stdController) {
        this.lVisit = (Visits__c )stdController.getRecord();
        List<Pricebook2> pricebooks = [SELECT Id, Name from Pricebook2 where IsActive = true];
        if (pricebooks.size() > 0) {
            selectedPricebook = pricebooks[0].Id;
        }
        loadPricebookEntries();
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
}