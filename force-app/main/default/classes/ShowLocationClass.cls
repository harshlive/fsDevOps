public class ShowLocationClass {
  @AuraEnabled
    public static string checkOut(String latitude,String longitude,String visitRecordId){
        try{
            Double Clat;
            Double Clong;
           Visits__c visit = [SELECT Id,Account__c FROM Visits__c WHERE Id = :visitRecordId];
                     
            if(latitude!=null){
                System.debug(latitude);
                Clat = Double.valueOf(latitude);
                system.debug('Clat'+Clat);
            }
            if(longitude!=null){
                system.debug(longitude);
                Clong = Double.valueOf(longitude);
                system.debug('Clong'+Clong);
            }
           if(latitude == null && longitude== null){
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('http://ip-api.com/json');
                req.setMethod('GET');
                HttpResponse res = h.send(req);
                String response = res.getBody();
                LocationAPIResponse locationAPIResponse = (LocationAPIResponse)JSON.deserialize(response,LocationAPIResponse.class);
              Clat = locationAPIResponse.lat;
             Clong= locationAPIResponse.lon;
           }
            
            return 'Success';
                   }catch(Exception e){
            return 'Error';
        }
        
    }
     public class LocationAPIResponse{
        public Double lat{get;set;}
        public Double lon{get;set;}
        
        public LocationAPIResponse(){
            
        }
    }
      @AuraEnabled
    public static List<LocationWrap> fetchAccount(){
       list<Account> acclist = [SELECT Id, Name,ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingGeo__Longitude__s, ShippingGeo__Latitude__s FROM 
                               Account where ShippingGeo__Longitude__s!= NULL AND ShippingGeo__Latitude__s!= NULL
                             And  ShippingCountry != null And ShippingCity != null];

                                system.debug(acclist);
      
          List<LocationWrap> loc = new List<LocationWrap>();
        for(Account acc :acclist){
            GeoLocation geoInfo = new GeoLocation();
          //geoInfo.Latitude = acc.ShippingGeo__Latitude__s;
         //geoInfo.Longitude = acc.ShippingGeo__Longitude__s;
             //geoInfo.City = acc.BillingCity;
           // geoInfo.Street=acc.ShippingStreet;
            geoInfo.City=acc.ShippingCity;
            geoInfo.State =acc.ShippingState;
            geoInfo.PostalCode=acc.ShippingPostalCode;
           // geoInfo.Country=acc.ShippingCountry;
            LocationWrap locDetail = new LocationWrap();
            locDetail.icon = 'action:add_contact'; 
            locDetail.title = acc.Name;
            
            //locDetail.description = acc.Name;
            locDetail.location = geoInfo;
            
            loc.add(locDetail);
        }
        return loc ;
    }
    public class LocationWrap{
        @AuraEnabled 
        public String icon{get;set;} 
        @AuraEnabled 
        public String title{get;set;} 
        
        @AuraEnabled 
        public GeoLocation location{get;set;} 
    }
    public class GeoLocation{
      
        @AuraEnabled 
        public String City{get;set;}
          //  @AuraEnabled 
      //  public String Street{get;set;}
               @AuraEnabled 
        public string PostalCode{get;set;}
        // @AuraEnabled 
      //  public String Country{get;set;}
                 @AuraEnabled 
        public String State{get;set;}
     

    }
    @AuraEnabled
    public static List<LocationWrap> getAccount(String latitude ,String longitude,integer sliderval){
       try{
               integer value=sliderval;
                   system.debug('slidervalue'+value);
       Decimal lat;
         Decimal lon;
        if(latitude != null){
         lat=Decimal.valueof(latitude);
          system.debug('Return lat'+lat);
            }
        if(longitude != null){
        lon=Decimal.valueof(longitude);
          system.debug('Return lon'+lon);
             }
        list<Account> accountlist=[SELECT Id,ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, Name, ShippingGeo__Longitude__s, ShippingGeo__Latitude__s FROM 
                               Account where ShippingGeo__Longitude__s!= NULL
                                   AND ShippingGeo__Latitude__s!= NULL And  ShippingCountry != null And ShippingCity != null];
        list<Account> filteredlist=new list<Account>();
        system.debug('filterList'+filteredlist);
        for(Account a:accountlist){
            Location loc2 = Location.newInstance(lat,lon); 
               system.debug('location2'+loc2);
               
             Location loc1 = Location.newInstance(a.ShippingGeo__Latitude__s,a.ShippingGeo__Longitude__s);
                system.debug('location1'+loc1);
             
              Decimal dist = Location.getDistance(loc1, loc2, 'km');
            system.debug('difference is'+dist);
            if(dist<=value){
            filteredlist.add(a);
            }
        }
           system.debug(filteredlist);
           List<LocationWrap> loc = new List<LocationWrap>();
           for(Account acc :filteredlist){
            GeoLocation geoInfo = new GeoLocation();
         // geoInfo.Latitude = acc.ShippingGeo__Latitude__s;
           //geoInfo.Longitude = acc.ShippingGeo__Longitude__s;
           // geoInfo.Street=acc.ShippingStreet;
            geoInfo.City=acc.ShippingCity;
            geoInfo.State =acc.ShippingState;
            geoInfo.PostalCode=acc.ShippingPostalCode;
          //  geoInfo.Country=acc.ShippingCountry;
            LocationWrap locDetail = new LocationWrap();
            locDetail.icon = 'action:add_contact'; 
            locDetail.title = acc.Name;
            //locDetail.description = acc.Name;
            locDetail.location = geoInfo;
            
            loc.add(locDetail);
        }
           system.debug(loc);
        return loc;
       }
        catch(Exception  e) {
   //System.debug('Message: ' + e.getMessage()); 
   return null;
        }
    }
   ////////////////////////////////////
    @AuraEnabled
    public static list<LocWrap> fetchLead(){
        list<lead> ldlist=[SELECT Id, Name,Company , City, Street, PostalCode, Country, State, Address_Geolocatopon__Latitude__s, Address_Geolocatopon__Longitude__s FROM Lead where 
                           Address_Geolocatopon__Latitude__s!=null AND Address_Geolocatopon__Longitude__s!=null
                          And  Country != null And City != null];
    system.debug(ldlist);
      
          List<LocWrap> loc = new List<LocWrap>();
        for(Lead ld :ldlist){
            GeoLoc geoInfo = new GeoLoc();
          //  geoInfo.Latitude =ld.Address_Geolocatopon__Latitude__s;
          //  geoInfo.Longitude = ld.Address_Geolocatopon__Longitude__s;
            ///////
           geoInfo.City=ld.City;
           // geoInfo.Street=ld.Street;
                geoInfo.PostalCode=ld.PostalCode;
               // geoInfo.Country=ld.Country;
                geoInfo.State=ld.State;
            ///////
            // geoInfo.City = ld.City;
            LocWrap locDetail = new LocWrap();
            locDetail.icon = 'action:new_lead'; 
            locDetail.title = ld.Name;
            locDetail.description=ld.Company ;
           // locDetail.description = ld.Address;
            locDetail.location = geoInfo;
            ////
           
            ////
            loc.add(locDetail);
        }
        return loc ;
    }
    public class LocWrap{
        @AuraEnabled 
        public String icon{get;set;} 
        @AuraEnabled 
        public String title{get;set;} 
                @AuraEnabled 
        public String description{get;set;} 
      ////
      // @AuraEnabled 
       // public String location{get;set;}
      ////  
        @AuraEnabled 
        public GeoLoc location{get;set;} 
    }
    public class GeoLoc{
     //  @AuraEnabled 
      // public Double Longitude{get;set;}
      // @AuraEnabled 
       //public Double Latitude{get;set;}
      // @AuraEnabled 
      //  public String City{get;set;}
        @AuraEnabled 
        public String City{get;set;}
          //  @AuraEnabled 
      //  public String Street{get;set;}
               @AuraEnabled 
        public string PostalCode{get;set;}
       //  @AuraEnabled 
       // public String Country{get;set;}
                 @AuraEnabled 
        public String State{get;set;}
     
       // public Address Address{get;set;}
    }
    @AuraEnabled
    public static List<LocWrap> getLead(String latitude ,String longitude,integer sliderval){
       try{
        integer value=sliderval;
                   system.debug('slidervalue'+value);
        Decimal lat;
         Decimal lon;
        if(latitude != null){
         lat=Decimal.valueof(latitude);
          system.debug('Return lat'+lat);
            }
        if(longitude != null){
        lon=Decimal.valueof(longitude);
          system.debug('Return lon'+lon);
             }
         list<lead> ldlist=[SELECT Id, Name,Company ,City, Street, PostalCode, Country, State, Address_Geolocatopon__Latitude__s, Address_Geolocatopon__Longitude__s FROM Lead where 
                           Address_Geolocatopon__Latitude__s!=null AND Address_Geolocatopon__Longitude__s!=null
                            And  Country != null And City != null];
    list<lead> filteredlist=new list<lead>();
        system.debug('filterList'+filteredlist);
        for(lead l:ldlist){
            Location loc2 = Location.newInstance(lat,lon); 
               system.debug('location2'+loc2);
               
             Location loc1 = Location.newInstance(l.Address_Geolocatopon__Latitude__s,l.Address_Geolocatopon__Longitude__s);
                system.debug('location1'+loc1);
             
              Decimal dist = Location.getDistance(loc1, loc2, 'km');
            system.debug('difference is'+dist);
            if(dist<=value){
            filteredlist.add(l);
            }
        }
           system.debug(filteredlist);
           List<LocWrap> loc = new List<LocWrap>();
           for(Lead ld :filteredlist){
            GeoLoc geoInfo = new GeoLoc();
        geoInfo.City=ld.City;
           // geoInfo.Street=ld.Street;
                geoInfo.PostalCode=ld.PostalCode;
             //   geoInfo.Country=ld.Country;
                geoInfo.State=ld.State;
                   // geoInfo.Latitude =ld.Address_Geolocatopon__Latitude__s;
          // geoInfo.Longitude = ld.Address_Geolocatopon__Longitude__s;
           //  geoInfo.City = ld.City;
            LocWrap locDetail = new LocWrap();
            locDetail.icon = 'action:new_lead'; 
            locDetail.title = ld.Name;
               locDetail.description=ld.Company ;
            //locDetail.description = ld.Address;
            locDetail.location = geoInfo;
            
            loc.add(locDetail);
        }
        return loc;
       }
        catch(Exception  e) {
   //System.debug('Message: ' + e.getMessage()); 
   return null;
        }
    }
   
}