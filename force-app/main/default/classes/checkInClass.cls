public class checkInClass {

    
    @AuraEnabled
    public static string checkIn(String visitRecordId,String latitude,String longitude){
        try{
           Visits__c visit = [SELECT Id,Account__c FROM Visits__c WHERE Id = :visitRecordId];
            system.debug(visit.Account__c);
            visit.Checked_In__c = true;
            visit.Actual_Start__c = System.now();
            if(latitude!=null){
                System.debug(latitude);
                visit.Checked_In_Location__Latitude__s = Double.valueOf(latitude);
            }
            if(longitude!=null){
                visit.Checked_In_Location__Longitude__s = Double.valueOf(longitude);
            }
            
            
      account acc=[select id,ShippingGeo__Latitude__s,ShippingGeo__Longitude__s from account where id =:visit.Account__c];
            system.debug('parent'+acc);
           system.debug('shippingdistance');
                Location loc1 = Location.newInstance(acc.ShippingGeo__Latitude__s,acc.ShippingGeo__Longitude__s);
                system.debug('location1'+loc1);
             Location loc2 = Location.newInstance(visit.Checked_In_Location__Latitude__s,visit.Checked_In_Location__Longitude__s); 
               system.debug('location2'+loc2);
           
              Double dist = Location.getDistance(loc1, loc2, 'km');
            system.debug('difference is'+dist);
            
             /*  if(latitude == null && longitude== null){
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('http://ip-api.com/json');
                req.setMethod('GET');
                HttpResponse res = h.send(req);
                String response = res.getBody();
                LocationAPIResponse locationAPIResponse = (LocationAPIResponse)JSON.deserialize(response,LocationAPIResponse.class);
                visit.Checked_In_Location__Latitude__s = locationAPIResponse.lat;
                visit.Checked_In_Location__Longitude__s = locationAPIResponse.lon;
           }*/
            
            double val=double.valueof(system.label.CompareDistValue);
            system.debug('CustomLabel'+val);
           if(dist<val){
            update visit;
            system.debug('record is updated');
            return 'Success';//accountid,query account,comparison
           }else{
                return 'Error';
            }
           
        }catch(Exception e){
            System.debug(e);
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
    public static Boolean checkOut(String visitRecordId){
        try{
            Visits__c visit = [SELECT Id,Account__c FROM Visits__c WHERE Id = :visitRecordId];
             account acc=[select id,ShippingGeo__c,ShippingGeo__Latitude__s,ShippingGeo__Longitude__s from account where id =:visit.Account__c];
            system.debug('parent'+acc);
        
            visit.Checked_Out__c = true;
            visit.Actual_End__c = System.now();
               
            update visit;
            return true; 
        }catch(Exception e){
            return false;
        }
        
    }
}