public class CheckOutClass {

    @AuraEnabled
    public static string checkOut(String latitude,String longitude,String visitRecordId){
        try{
            Double Clat;
            Double Clong;
            
             
            Visits__c visit = [SELECT Id,Account__c FROM Visits__c WHERE Id = :visitRecordId];
            visit.Checked_Out__c = true;
            visit.Actual_End__c = System.now();
           
            if(latitude!=null){
                System.debug(latitude);
                Clat = Double.valueOf(latitude);
                system.debug('Clat'+Clat);
            }
            if(longitude!=null){
                Clong = Double.valueOf(longitude);
                system.debug('Clong'+Clong);
            }
             account acc=[select id,ShippingGeo__c,ShippingGeo__Latitude__s,ShippingGeo__Longitude__s from account where id =:visit.Account__c];
            system.debug('parent'+acc);
            
                   Location loc2 = Location.newInstance(Clat,Clong); 
               system.debug('location2'+loc2);
               
             Location loc1 = Location.newInstance(acc.ShippingGeo__Latitude__s,acc.ShippingGeo__Longitude__s);
                system.debug('location1'+loc1);
             
              Double dist = Location.getDistance(loc1, loc2, 'km');
            system.debug('difference is'+dist);
           /*if(latitude == null && longitude== null){
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('http://ip-api.com/json');
                req.setMethod('GET');
                HttpResponse res = h.send(req);
                String response = res.getBody();
                LocationAPIResponse locationAPIResponse = (LocationAPIResponse)JSON.deserialize(response,LocationAPIResponse.class);
              Clat = locationAPIResponse.lat;
             Clong= locationAPIResponse.lon;
           }*/
             double val=double.valueof(system.label.CompareDistValue);
            system.debug('CustomLabel'+val);
               
             if(dist<val){
            update visit;
            return 'Success';
             }
            else{
                return 'Error';
            }
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
   
}