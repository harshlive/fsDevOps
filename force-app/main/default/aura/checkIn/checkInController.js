({
    doInit : function(component, event, helper) {
        console.log('checkFieldval',component.get("v.checkFieldval"));   
        var fieldval=component.get("v.fields").Checked_In__c;
        
        console.log('fieldval',fieldval);
        // 
        if(fieldval == false){
            component.set("v.checkFieldval", true);
            console.log('checkFieldval',component.get("v.checkFieldval"));
            debugger;
            if(navigator.geolocation){
                navigator.geolocation.getCurrentPosition(function(position){
                    var latitude = position.coords.latitude;
                    console.log('latitude',latitude);
                    var longitude =position.coords.longitude;
                    console.log('longitude',longitude);
                    var action = component.get("c.checkIn");
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
                                    message: 'Successfully checked in',
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
                                //  $A.get('e.force:refreshView').fire();
                            }
                            $A.get("e.force:closeQuickAction").fire();
                        }
                        else if (state === "INCOMPLETE") {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Error Message',
                                message:'Error Occured',
                                duration:' 2000',
                                type: 'error'
                                
                            });
                            toastEvent.fire();
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
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    title : 'Error Message',
                                    message:'Error Occured',
                                    duration:' 2000',
                                    type: 'error'
                                    
                                });
                                toastEvent.fire();
                            }
                    });
                    $A.enqueueAction(action);
                }, function(error) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error Message',
                        message:'Error Occured',
                        duration:' 2000',
                        type: 'error'
                        
                    });
                    toastEvent.fire();
                    
                });
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error Message',
                    message:'Error Occured',
                    duration:' 2000',
                    type: 'error'
                    
                });
                toastEvent.fire();
            }
        }
        //  else if(fieldval == true){
        // alert('checked in has been done already');
    },
    
})