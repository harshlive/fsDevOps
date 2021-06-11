public class RG_CalendarCtrl {
    public Contact contact {get; set;}
    
    @AuraEnabled
    public static String getLoggedInUserTimeZone(){
        return [Select TimeZoneSidKey from User where Id = :UserInfo.getUserId() LIMIT 1][0].TimeZoneSidKey;
    }
    
    public class AccountWrapper{
        @AuraEnabled
        public String Id{get;set;}
        @AuraEnabled
        public String Name{get;set;}
        @AuraEnabled
        public Decimal ShippingLat{get;set;}
        @AuraEnabled
        public Decimal ShippingLong{get;set;}
        @AuraEnabled
        public String ShippingState{get;set;}
        @AuraEnabled
        public String ShippingCountry{get;set;}
        @AuraEnabled
        public String ShippingCity{get;set;}
        @AuraEnabled
        public String ShippingPostalCode{get;set;}
        @AuraEnabled
        public Integer VisitCount{get;set;}
        @AuraEnabled
        public String LastVisitDate{get;set;}
        @AuraEnabled
        public String NextVisitDate{get;set;}
        @AuraEnabled
        public String OwnerName{get;set;}
        
    }  
    
    @AuraEnabled
    public static List<AccountWrapper> getAllAccounts(String searchText,String selectedType){
        if(searchText!=null && searchText!= ''){
            searchText = '%'+searchText+'%';
        }
        String query = 'SELECT Id,Name,ShippingStreet,ShippingGeo__latitude__s,ShippingGeo__longitude__s,ShippingState,ShippingCountry,ShippingCity,ShippingPostalCode,Owner.Name FROM Account ';
        String whereClause = ' WHERE';
        String typeWhereClause = '  Type = :selectedType';
        String limitClause = ' LIMIT 8';
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
        List<string> AccountIdList = new List<string>();
        accounts = (List<Account>)Database.query(query);
        for(Account acc : accounts) {
            AccountIdList.add(acc.Id);
        }
        List<AccountWrapper> accountWrapperList = new List<AccountWrapper>();
        List<Visits__c> visitList = [SELECT id,account__c, Planned_Start__c, Planned_End__c FROM Visits__c WHERE account__c in :AccountIdList];
        String nextVisitDate;
        String lastVisitDate;
        Map<string,List<visits__c>> visitMap = new Map<string,List<visits__c>>();
        for(Visits__c vst :visitList) {
            if(visitMap.containsKey(vst.account__c)) {
                visitMap.get(vst.account__c).add(vst);
            }
            else {
                List<visits__c> tempVstLst = new List<visits__c>();
                tempVstLst.add(vst);
                visitMap.put(vst.account__c,tempVstLst);
            }
        }
        for(Account acc : accounts) {
            AccountWrapper accWrapper = new AccountWrapper();
            accWrapper.Id = acc.Id;
            accWrapper.Name = acc.Name;
            accWrapper.ShippingLat = acc.ShippingGeo__latitude__s;
            accWrapper.ShippingLong = acc.ShippingGeo__longitude__s;
            accWrapper.ShippingState = acc.ShippingState;
            accWrapper.ShippingCountry = acc.ShippingCountry;
            accWrapper.ShippingCity = acc.ShippingCity;
            accWrapper.ShippingPostalCode = acc.ShippingPostalCode;
            if(visitMap.get(acc.Id) != null) {
                accWrapper.VisitCount = visitMap.get(acc.Id).size();
                List<visits__c> tempLst = [SELECT id,account__c, Planned_Start__c, Planned_End__c 
                                           FROM Visits__c WHERE Planned_Start__c > TODAY AND account__c=:acc.Id 
                                           order by Planned_Start__c ];
                if(tempLst.size()>0) {
                    accWrapper.NextVisitDate = string.valueOfGmt(tempLst[0].Planned_Start__c);
                }
                else {
                    accWrapper.NextVisitDate = 'NA';
                }
                List<visits__c> newtempLst = [SELECT id,account__c, Planned_Start__c, Planned_End__c 
                                              FROM Visits__c WHERE Planned_Start__c < TODAY AND account__c=:acc.Id 
                                              order by Planned_Start__c desc ];
                if(newtempLst.size()>0) {
                    accWrapper.LastVisitDate = string.valueOfGmt(newtempLst[0].Planned_Start__c);
                }
                else {
                    accWrapper.LastVisitDate = 'NA';
                }
            }
            else {
                accWrapper.VisitCount = 0;
                accWrapper.LastVisitDate = 'NA';
                accWrapper.NextVisitDate = 'NA';
            }
            accWrapper.OwnerName = acc.Owner.Name;
            accountWrapperList.add(accWrapper);
        }
        
        return accountWrapperList;
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
        return [SELECT Id,Name, Actual_Start__c, Owner.Name, Actual_End__c, Planned_End__c,Status__c , Planned_Start__c,Account__c,(SELECT Id,Visit__c,Survey__c FROM Tasks__r) FROM Visits__c WHERE OwnerId = :selectedUser  AND Account__c<>NULL ORDER BY CreatedDate DESC NULLS LAST];
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
    public static Visits__c saveNewEventWithSurveys(String ownerId, String subject, String startDateTime, String endDateTime,String accountId,String selectedSurveys) {
        
        Visits__c newEvent = new Visits__c(OwnerId = ownerId,
                                           Account__c = accountId,
                                           Name = subject,
                                           Planned_Start__c = DateTime.parse(startDateTime),
                                           Planned_End__c = DateTime.parse(endDateTime));
        insert newEvent;
        List<VisitTask__c> visitTasksToInsert = new List<VisitTask__c>();
        Set<String> selectedSurveySet = new Set<String>(selectedSurveys.split(',')); 
        for(String selectedSurvey : selectedSurveySet){
            if(selectedSurvey!=null && selectedSurvey!=''){
                VisitTask__c lVisitTaskToInsert = new VisitTask__c();
                if(!Test.isRunningTest()) {
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
    public class visitWrapper{
        @AuraEnabled
        public Visits__c visitRec{get;set;}
        @AuraEnabled
        public Boolean inContainmentZone{get;set;}
        
        public visitWrapper(Visits__c visitRec,Boolean inContainmentZone){
            this.visitRec = visitRec;
            this.inContainmentZone = inContainmentZone;
        }
    }
    @AuraEnabled
    public static visitWrapper saveNewEvent(String ownerId,String accountId, String subject, String startDateTime, String endDateTime) {
        system.debug(startDateTime);
        system.debug(endDateTime);
        Visits__c newEvent = new Visits__c(OwnerId = ownerId,
                                           Account__c = accountId,
                                           Name = subject,
                                           Planned_Start__c = DateTime.parse(startDateTime),
                                           Planned_End__c = DateTime.parse(endDateTime));
        Account acc = [SELECT Id,ShippingGeo__latitude__s,ShippingGeo__longitude__s from Account where id = :accountId];
        HTTP http = new HTTP ();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://data.geoiq.io/dataapis/v1.0/covid/locationcheck');
        request.setMethod('POST');
        request.setTimeout(60000);
        system.debug(acc.ShippingGeo__Latitude__s+','+acc.ShippingGeo__Longitude__s);
        Boolean inContainmentZone = false;
        if(acc.ShippingGeo__Latitude__s!=null && acc.ShippingGeo__Longitude__s!= null) {
            request.setBody(' {"key": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJtYWlsSWRlbnRpdHkiOiJ2aWpheS5ndXB0YUBhZXRoZXJldXMuY29tIn0.0cqA-dsMKkO282VTbN9UI3KIeLOiv2liXFc_5UBGM30","latlngs": [['+acc.ShippingGeo__Latitude__s+','+acc.ShippingGeo__Longitude__s+']]}');
            //eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJtYWlsSWRlbnRpdHkiOiJ2aWpheS5ndXB0YUBhZXRoZXJldXMuY29tIn0.0cqA-dsMKkO282VTbN9UI3KIeLOiv2liXFc_5UBGM30
            HttpResponse response = http.send(request);
            system.debug(response.getBody());
            geoIQResp respObj = (geoIQResp)JSON.deserialize(response.getBody(), geoIQResp.class);
            inContainmentZone =respObj.Data[0].inContainmentZone;
        }
        insert newEvent;
        visitWrapper vwr = new visitWrapper(newEvent,inContainmentZone);
        return vwr;
    }
    
    @AuraEnabled
    public static Visits__c updateEvent(String eventId, String startDateTime, String endDateTime) {
        Visits__c oldEvent = [SELECT Id, Planned_Start__c, Planned_End__c FROM Visits__c WHERE Id = :eventId];
        oldEvent.Planned_Start__c = DateTime.parse(startDateTime);
        oldEvent.Planned_End__c = DateTime.parse(endDateTime);
        update oldEvent;
        return oldEvent;
    }
    @AuraEnabled
    public static Visits__c updateOlderEvent(String eventId, String subject,String startDateTime, String endDateTime,String selectedSurveys, String allEvents) {
        Visits__c oldEvent = [SELECT Id, Name, Planned_Start__c, Planned_End__c,(SELECT Id,Visit__c,Survey__c FROM Tasks__r) FROM Visits__c WHERE Id = :eventId];
        oldEvent.Name = subject;
        oldEvent.Planned_Start__c = DateTime.parse(startDateTime);
        oldEvent.Planned_End__c = DateTime.parse(endDateTime);
        update oldEvent;
        List<VisitTask__c> visitTasksToInsert = new List<VisitTask__c>();
        List<VisitTask__c> visitTasksToDelete = new List<VisitTask__c>();
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
                if(!Test.isRunningTest()) {
                    lVisitTaskToInsert.Survey__c = selectedSurvey;
                }
                lVisitTaskToInsert.Visit__c = oldEvent.Id;
                visitTasksToInsert.add(lVisitTaskToInsert);
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
    
    
    
}