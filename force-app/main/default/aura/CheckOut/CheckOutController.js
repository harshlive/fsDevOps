({
    doInit : function(component, event, helper) {
         if(navigator.geolocation){
            navigator.geolocation.getCurrentPosition(function(position){
                var latitude = position.coords.latitude;
                var longitude =position.coords.longitude;
                var action = component.get("c.checkOut");
                action.setParams({ 
                    visitRecordId : component.get("v.recordId"),
                    latitude : latitude+'',
                    longitude : longitude+''
                });
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()==="Success"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Successfully checked out',
                        duration:'2000',
                        type: 'success',
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
                 else if(response.getReturnValue()==="Error"){
                           
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error Message',
            message:'Your current location does not match visit location',
            duration:' 2000',
            type: 'error'
            
        });
        toastEvent.fire();
                     
                        }
                        $A.get("e.force:closeQuickAction").fire();
                    }
                    else if (state === "INCOMPLETE") {
                    }
                        else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " + 
                                                errors[0].message);
                                }
                            } else {
                                console.log("Unknown error");
                            }
                        }
                });
                $A.enqueueAction(action);
            }, function(error) {
                
            });
        }else{
            
        }
    },
    
})