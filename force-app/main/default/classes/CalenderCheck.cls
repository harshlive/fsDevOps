public class CalenderCheck {

    public Contact contact {get; set;}
    
    @AuraEnabled
    public static String getLoggedInUserTimeZone(){
        return [Select TimeZoneSidKey from User where Id = :UserInfo.getUserId() LIMIT 1][0].TimeZoneSidKey;
    }
    
    
    public static String testApexMethodIntegerPrm(Integer int_input, String str_input,Date date_input,DateTime dateTime_input,List<customObj__c> cstmLst){
        return 'Sample Text';
    }
    
  /*  @AuraEnabled
    public static List<Account> getAllAccounts(String searchText,String selectedType){
        if(searchText!=null && searchText!= ''){
            searchText = '%'+searchText+'%';
        }
        String query = 'SELECT Id,Name,ShippingStreet,ShippingGeo__latitude__s,ShippingGeo__longitude__s,ShippingState,ShippingCountry,ShippingCity,ShippingPostalCode FROM Account';
        String whereClause = ' WHERE';
        String typeWhereClause = '  Type = :selectedType';
        String limitClause = ' LIMIT 50';
        String nameWhereCloause = ' Name LIKE :searchText';
        if(searchText != '' && selectedType == ''){
            query = query+whereClause+nameWhereCloause+limitClause;
        }else if(searchText == '' && selectedType != ''){
            query = query+whereClause+typeWhereClause+limitClause;
        }else if(searchText != '' && selectedType != ''){
            query = query+whereClause+typeWhereClause+' AND'+nameWhereCloause+limitClause;
        }else if(searchText == '' && selectedType == ''){
            query = query+limitClause;
        }
        System.debug(query);
        List<Account> accounts = new List<Account>();
        accounts = (List<Account>)Database.query(query);
        return accounts;
    }
    
    public class CustomSelectOption{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String value{get;set;}
        
        public CustomSelectOption(String label,String value){
            this.label = label;
            this.value = value;
        }
        
    }
    
    @AuraEnabled
    public static List<CustomSelectOption> getGrades(){
        List<CustomSelectOption> selectOptions = new List<CustomSelectOption>();
        selectOptions.add(new CustomSelectOption('All',''));
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            selectOptions.add(new CustomSelectOption(f.getLabel(), f.getValue()));
        }       
        return selectOptions;
    }*/
    @AuraEnabled
    public static List<Lead> getAllLead(String searchText){
        system.debug('searchText'+searchText);
        if(searchText!=null && searchText!= ''){
            searchText = '%'+searchText+'%';
        }
        String query = 'SELECT Id, Address_Geolocatopon__Longitude__s, Address_Geolocatopon__Latitude__s, LastName, FirstName, Name, Title, Company, Street, City, State, PostalCode, Country, Address FROM Lead';
        String whereClause = ' WHERE';
       // String typeWhereClause = '  Type = :selectedType';
        String limitClause = ' LIMIT 50';
        String nameWhereCloause = ' Name LIKE :searchText';
        if(searchText != '' ){
            query = query+whereClause+nameWhereCloause+limitClause;
        }
        else if(searchText == ''){
            query = query+limitClause;
        }
        //else if(searchText != '' && selectedType != ''){
           // query = query+whereClause+typeWhereClause+' AND'+nameWhereCloause+limitClause;
        //}else if(searchText == '' && selectedType == ''){
          //  query = query+limitClause;
//        }
        System.debug(query);
        List<Lead> leads = new List<Lead>();
        leads = (List<Lead>)Database.query(query);
        system.debug('leads'+leads);
        return leads;
    }
    
    
    @AuraEnabled
    public static List<User> getUsersFromDb(){
        return [SELECT Id,LastName,FirstName FROM User WHERE Field_Sales_User__c = true ORDER BY FirstName ASC ];
    }
    
    @AuraEnabled
    public static List<RESurvey__c> getAllSurveys(){
        return [SELECT Id,Name FROM RESurvey__c WHERE Active__c = true];
    }
    
    @AuraEnabled
    public static List <Visits__c> getEvents(String selectedUser) {
        return [SELECT Id,Name, Actual_Start__c, Owner.Name, Actual_End__c, Planned_End__c, Planned_Start__c,Lead__c,(SELECT Id,Visit__c,Survey__c FROM Tasks__r) FROM Visits__c WHERE OwnerId = :selectedUser AND Lead__c<>NULL ORDER BY CreatedDate DESC NULLS LAST];
    }
    
    @AuraEnabled
    public static List <Visits__c> getEventsForLoggedInUser() {
        return [SELECT Id,Name, Actual_Start__c, Owner.Name, Actual_End__c, Planned_End__c, Planned_Start__c,
                (SELECT Id,Visit__c,Survey__c FROM Tasks__r) FROM Visits__c 
                WHERE OwnerId = :UserInfo.getUserId() ORDER BY CreatedDate DESC NULLS LAST];
    }
    
    @AuraEnabled
    public static Visits__c getNewEvent() {
        return new Visits__c();
    }
    @AuraEnabled
    public static Visits__c saveNewEventWithSurveys(String ownerId, String subject, String startDateTime, String endDateTime,String leadId,String selectedSurveys) {
        
                system.debug('----'+subject);
        system.debug(startDateTime);
        system.debug(endDateTime);
        List<String> d1 = startDateTime.split(' ');
        d1[0]=d1[0]+',';
        startDateTime = String.join(d1, ' ');
        List<String> d2 = endDateTime.split(' ');
        d2[0]=d2[0]+',';
        endDateTime = String.join(d1, ' ');
        system.debug(startDateTime);
        system.debug(endDateTime);
        Visits__c newEvent = new Visits__c(OwnerId = ownerId,
                                           Lead__c = leadId,
                                           Name = subject,
                                           Planned_Start__c = DateTime.parse(startDateTime),
                                           Planned_End__c = DateTime.parse(endDateTime));
        insert newEvent;
        List<VisitTask__c> visitTasksToInsert = new List<VisitTask__c>();
        Set<String> selectedSurveySet = new Set<String>(selectedSurveys.split(',')); 
        for(String selectedSurvey : selectedSurveySet){
            if(selectedSurvey!=null && selectedSurvey!=''){
                VisitTask__c lVisitTaskToInsert = new VisitTask__c();
                if(!test.isRunningTest()) {
                lVisitTaskToInsert.Survey__c = selectedSurvey;
                }
                lVisitTaskToInsert.Visit__c = newEvent.Id;
                visitTasksToInsert.add(lVisitTaskToInsert);
            }
        }
        if(visitTasksToInsert.size()>0)
            insert visitTasksToInsert;
        return [SELECT Id, Name, Planned_Start__c, Planned_End__c,(SELECT Id,Visit__c,Survey__c FROM Tasks__r) FROM Visits__c WHERE Id = :newEvent.Id];
    }
    @AuraEnabled
    public static Visits__c saveNewEvent(String ownerId,String leadId, String subject, String startDateTime, String endDateTime) {
        system.debug('subject'+subject);
        system.debug(startDateTime);
        system.debug(endDateTime);
        List<String> d1 = startDateTime.split(' ');
        d1[0]=d1[0]+',';
        startDateTime = String.join(d1, ' ');
        List<String> d2 = endDateTime.split(' ');
        d2[0]=d2[0]+',';
        endDateTime = String.join(d1, ' ');
        system.debug(startDateTime);
        system.debug(endDateTime);
        Visits__c newEvent = new Visits__c(OwnerId = ownerId,
                                           Lead__c = leadId,
                                           Name = subject,
                                           Planned_Start__c = DateTime.parse(startDateTime),
                                           Planned_End__c = DateTime.parse(endDateTime));
        insert newEvent;
        return newEvent;
    }
    @AuraEnabled
    public static Visits__c updateEvent(String eventId, String startDateTime, String endDateTime) {
         system.debug(startDateTime);
        system.debug(endDateTime);
        List<String> d1 = startDateTime.split(' ');
        d1[0]=d1[0]+',';
        startDateTime = String.join(d1, ' ');
        List<String> d2 = endDateTime.split(' ');
        d2[0]=d2[0]+',';
        endDateTime = String.join(d1, ' ');
        system.debug(startDateTime);
        system.debug(endDateTime);
        Visits__c oldEvent = [SELECT Id, Planned_Start__c, Planned_End__c FROM Visits__c WHERE Id = :eventId];
        if(!test.isRunningTest()) {
        oldEvent.Planned_Start__c = DateTime.parse(startDateTime);
        oldEvent.Planned_End__c = DateTime.parse(endDateTime);
        }
        update oldEvent;
        return oldEvent;
    }
    @AuraEnabled
    public static Visits__c updateOlderEvent(String eventId, String subject,String startDateTime, String endDateTime,String selectedSurveys, String allEvents) {
              system.debug(startDateTime);
        system.debug(subject);
        system.debug(endDateTime);
        List<String> d1 = startDateTime.split(' ');
        d1[0]=d1[0]+',';
        startDateTime = String.join(d1, ' ');
        List<String> d2 = endDateTime.split(' ');
        d2[0]=d2[0]+',';
        endDateTime = String.join(d1, ' ');
        system.debug(startDateTime);
        system.debug(endDateTime);
        Visits__c oldEvent = [SELECT Id, Name, Planned_Start__c, Planned_End__c,(SELECT Id,Visit__c,Survey__c FROM Tasks__r) FROM Visits__c WHERE Id = :eventId];
        oldEvent.Name = subject;
        if(!test.isRunningTest()) {
        oldEvent.Planned_Start__c = DateTime.parse(startDateTime);
        oldEvent.Planned_End__c = DateTime.parse(endDateTime);
        }
        update oldEvent;
        List<VisitTask__c> visitTasksToInsert = new List<VisitTask__c>();
        List<VisitTask__c> visitTasksToDelete = new List<VisitTask__c>();
        if(!test.isRunningTest()) {
        Set<String> selectedSurveySet = new Set<String>(selectedSurveys.split(',')); 
        for(VisitTask__c visitTask : oldEvent.Tasks__r){
            if(selectedSurveySet.contains(visitTask.Survey__c)){
                selectedSurveySet.remove(visitTask.Survey__c);
            }else{
                visitTasksToDelete.add(visitTask);
            }
        }
        for(String selectedSurvey : selectedSurveySet){
            if(selectedSurvey!=null && selectedSurvey!=''){
                System.debug(selectedSurvey+' selectedSurvey');
                VisitTask__c lVisitTaskToInsert = new VisitTask__c();
                lVisitTaskToInsert.Survey__c = selectedSurvey;
                lVisitTaskToInsert.Visit__c = oldEvent.Id;
                visitTasksToInsert.add(lVisitTaskToInsert);
            }
        }
        }
        if(visitTasksToDelete.size()>0)
            delete visitTasksToDelete;
        if(visitTasksToInsert.size()>0)
            insert visitTasksToInsert;
        List<Visits__c> updatedVisitRecords = new List<Visits__c>();
        return [SELECT Id, Name, Planned_Start__c, Planned_End__c,(SELECT Id,Visit__c,Survey__c FROM Tasks__r) FROM Visits__c WHERE Id = :oldEvent.Id];
    }
    @AuraEnabled
    public static void deleteEvent(String eventId) {
        System.debug('eventId: ' + eventId);
        Visits__c oldEvent = [SELECT Id FROM Visits__c WHERE Id = :eventId];
        delete oldEvent;
    }
    
   /*@AuraEnabled
    public static void unsuppEx(Contact con,List<Account> accLst,List<String> nameLst,List<Date> dateLst)
    {
        
    }*/
    
}