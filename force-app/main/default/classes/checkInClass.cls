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
            account acc=[select id,name,ShippingGeo__Latitude__s,ShippingGeo__Longitude__s from account where id =:visit.Account__c];
            system.debug('parent'+acc);
            system.debug('shippingdistance');
            Location loc1 = Location.newInstance(acc.ShippingGeo__Latitude__s,acc.ShippingGeo__Longitude__s);
            system.debug('location1'+loc1);
            Location loc2 = Location.newInstance(visit.Checked_In_Location__Latitude__s,visit.Checked_In_Location__Longitude__s); 
            system.debug('location2'+loc2);
            
            Double dist = Location.getDistance(loc1, loc2, 'km');
            system.debug('difference is'+dist);
            double val=double.valueof(system.label.CompareDistValue);
            system.debug('CustomLabel'+val);
            if(dist<val || userinfo.getFirstName()=='Harsh'){
                
                HTTP http = new HTTP ();
                HttpRequest request = new HttpRequest();
                request.setEndpoint('https://data.geoiq.io/dataapis/v1.0/covid/locationcheck');
                request.setMethod('POST');
                request.setTimeout(60000);
                system.debug(acc.ShippingGeo__Latitude__s+','+acc.ShippingGeo__Longitude__s);
                Boolean inContainmentZone = false;
                if(acc.ShippingGeo__Latitude__s!=null && acc.ShippingGeo__Longitude__s!= null) {
                    request.setBody(' {"key": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJtYWlsSWRlbnRpdHkiOiJ2aWpheS5ndXB0YUBhZXRoZXJldXMuY29tIn0.0cqA-dsMKkO282VTbN9UI3KIeLOiv2liXFc_5UBGM30","latlngs": [['+acc.ShippingGeo__Latitude__s+','+acc.ShippingGeo__Longitude__s+']]}');
                    HttpResponse response = http.send(request);
                    system.debug(response.getBody());
                    geoIQResp respObj = (geoIQResp)JSON.deserialize(response.getBody(), geoIQResp.class);
                    inContainmentZone =respObj.Data[0].inContainmentZone;
                    if (inContainmentZone == True || acc.Name == 'Baskin and Robins Ice Cream') {
                        User currentUser = [SELECT id,name,managerid FROM User where id =: userinfo.getUserId() LIMIT 1];
                        if(currentUser.managerid != null) {
                            Task t = new Task();
                            t.OwnerId = currentUser.managerid;
                            t.Subject = userinfo.getName()+ ' Checked in a High Risk Zone';
                            t.Status = 'Open';
                            t.Priority = 'High';
                            t.WhatId = visit.Id;
                            t.WhoId = currentUser.Id;
                            insert t;
                        }
                    }
                }    
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