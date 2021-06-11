public class ShowNearbyLocationChild {
    
    @AuraEnabled
    public static id getleads(string jsonString){
        system.debug('Jsonformat----->'+jsonString);
        lead ld = (lead)JSON.deserialize(jsonString, lead.class);
        
        system.debug('deserializeformat------>'+ld);
        //  system.debug('Jsonformat1----->'+value);
        // lead l = (lead)JSON.deserialize(value, lead.class);
        
        // system.debug('deserializeformat1------>'+ld);
        //   if(ld.LastName == null && ld.Company == null){
        //  ld.LastName='abc';
        // ld.Company='abc company';
        
        lead l=new lead();
        // l.LastName=ld.title;
        // l.Company=ld.value;
        insert ld;
        system.debug(ld);
        //}
        return ld.id;
    }
}