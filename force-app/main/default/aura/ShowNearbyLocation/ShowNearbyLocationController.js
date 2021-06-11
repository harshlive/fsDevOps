({
    doInit : function(component, event, helper) {
        //  alert('In doInit');
        if(navigator.geolocation){
            navigator.geolocation.getCurrentPosition(function(position){
                var latitude = position.coords.latitude;
                component.set("v.latitude", latitude);
                console.log('latitude',latitude);
                var longitude =position.coords.longitude;
                component.set("v.longitude", longitude);
                console.log('longitude',longitude);
                var action = component.get("c.checkOut");
                action.setParams({ 
                    visitRecordId : component.get("v.recordId"),
                    //  console.log('visitRecordId',visitRecordId);
                    "latitude" : latitude+'',
                    "longitude" : longitude+''
                });
                
                action.setCallback(this, function(response) {
                    
                    var state = response.getState();
                    console.log('state',state);
                    if (state === "SUCCESS") {
                        if(response.getReturnValue()==="Success"){
                            var retResponse = response.getReturnValue();
                            console.log('retResponse',retResponse);
                           
                           

                            component.set("v.showbutton", true);
                            component.set("v.showCustomer", true);
                            console.log('v.showCustomer',component.get("v.showCustomer"));
                            console.log('-------------',component.get("v.showbutton"));
        var actn = component.get("c.getAccount");
        console.log('actions',actn);
        actn.setParams({ "latitude" :component.get("v.latitude"),
                        "longitude" : component.get("v.longitude"),
                        "sliderval" : 5
                       });
        actn.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    var resp =response.getReturnValue() ;
                    console.log('object[0]',resp);
                   // component.set('v.center', {
                 // location: {
                   //  City: 'Pune'
                   // }
                   // });
                 
                     component.set('v.center', {
                   location: {
                             Latitude:component.get("v.latitude"),
                      
                      Longitude:component.get("v.longitude")
                     
                        }
                    });
                     console.log('Latitude',component.get("v.latitude"));
                    console.log('Longitude',component.get("v.longitude"));
                    component.set('v.mapMarkers',resp);
                    component.set('v.zoomLevel',12);
                    component.set('v.markersTitle', 'Salesforce locations');
                    component.set('v.showFooter', true);
                   // component.set('v.title',resp)
                    //cmp.set('v.renderMap', true);
                }
                //  $A.get("e.force:closeQuickAction").fire();
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
        $A.enqueueAction(actn);
                        }
                        //  $A.get("e.force:closeQuickAction").fire();
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
        }
        // alert(component.get("v.value"));
        console.log('abc');
         //component.set("v.showCustomer", true);
        //console.log('handlechange', component.set("v.showCustomer", true));
 //var mybool=cmp.get("v.showCustomer");  
        //console.log('mybool',mybool);
               // if(mybool){
               //  var flag = cmp.get("v.showCustomer");
     //   if(flag === true) {
            //call apex to get filtered account and set map attributes as done in 
           // var actn = cmp.get("c.getAccount");
             //  var flag = cmp.get("v.showCustomer");
       // if(flag === true) {
            //call apex to get filtered account and set map attributes as done in 
           // var actn = cmp.get("c.getAccount");
         
       
        // var slidervalue = cmp.get("v.myval");
        // console.log('slidervalue',slidervalue)
        //cmp.set('v.renderMap', false);
      // var mybool=cmp.get("v.showCustomer");  
       // console.log('mybool',mybool);
                //if(mybool){
       
      /*  var act = component.get("c.fetchAccount");
        console.log('act',act);
        act.setCallback(this, function(response) {
            console.log('response'+response);
            var state = response.getState();
            console.log(state);
            if (state == "SUCCESS") {
                var obj =response.getReturnValue() ;
                console.log('objectlistone'+obj[0].City);
                console.log(obj);
                component.set('v.center', {
                    location: {
                        City: 'Nagpur'
                    }
                });
                component.set('v.mapMarkers',obj[1]);
                component.set('v.zoomLevel',4);
                component.set('v.markersTitle', 'Salesforce locations');
               component.set('v.showFooter', true);
                //component.set('v.renderMap', true);
                
            }    else{
                
                var errors=response.getError();
                console.log('Error',errors);
            }
            
        });
        
        $A.enqueueAction(act);*/
    //}
    },
    
    handleChange: function (cmp,e,h){
        console.log('newcmp');
        cmp.set("v.showbutton", true);
        cmp.set("v.showCustomer", true);
         console.log('-------------',cmp.get("v.showbutton"));
 console.log('v.showCustomer',cmp.get("v.showCustomer"));
      
        var actn = cmp.get("c.getAccount");
        console.log('actions',actn);
        actn.setParams({ "latitude" :cmp.get("v.latitude"),
                        "longitude" : cmp.get("v.longitude"),
                        "sliderval" : cmp.get("v.myval")
                       });
        actn.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    var resp =response.getReturnValue() ;
                    console.log(resp);
                  
                     /* cmp.set('v.center', {
                   location: {
                             Latitude:component.get("v.latitude"),
                      Longitude:component.get("v.longitude")
                    
                        }
                    });*/
                   cmp.set('v.center', {
                   location: {
                             Latitude:cmp.get("v.latitude"),
                      Longitude:cmp.get("v.longitude")
                    
                        }
                    });
 console.log('Latitude',cmp.get("v.latitude"));
                    console.log('Longitude',cmp.get("v.longitude"));
                                 /*       if(resp.location.length>0){
                        cmp.set('v.center',resp[0].location); 
                    }
                    else {
                        cmp.set('v.center', {
                   location: {
                            City: 'Nagpur'
                        }
                    });
                    }*/
                   
                  //  cmp.set('v.center',resp[0].location); 
                    cmp.set('v.mapMarkers',resp);
                    cmp.set('v.zoomLevel', 12);
                    cmp.set('v.markersTitle', 'Salesforce locations');
                    cmp.set('v.showFooter', true);
                    //cmp.set('v.renderMap', true);
                }
                //  $A.get("e.force:closeQuickAction").fire();
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
        $A.enqueueAction(actn);
               // }
    },
   getAccounts: function (cmp,e,h){
      cmp.set("v.showbutton", true);
              console.log('-------------',cmp.get("v.showbutton"));      
        //        if(mybool){
       //cmp.set("v.showCustomer", true);
        //console.log('handlechange', cmp.get("v.showCustomer"));

       var act = cmp.get("c.fetchAccount");
        console.log('act',act);
        
        act.setCallback(this, function(response) {
            console.log('response'+response);
            var state = response.getState();
            console.log(state);
            if (state == "SUCCESS") {
                var obj =response.getReturnValue() ;
                console.log(obj);
                                 /*  if(resp.location.length>0){
                        cmp.set('v.center',resp[0].location); 
                    }
                    else {
                        cmp.set('v.center', {
                   location: {
                            City: 'Nagpur'
                        }
                    });
                    }*/
                   
             //   cmp.set('v.center',resp[0].location); 
 cmp.set('v.center', {
                   location: {
                             Latitude:cmp.get("v.latitude"),
                      Longitude:cmp.get("v.longitude")
                    
                        }
                    });
                console.log('Latitude',cmp.get("v.latitude"));
                console.log('Longitude',cmp.get("v.longitude"));
                cmp.set('v.mapMarkers',obj);
                cmp.set('v.zoomLevel',12);
                cmp.set('v.markersTitle', 'Salesforce locations');
                cmp.set('v.showFooter', true);
                //component.set('v.renderMap', true);
                
            }    else{
                
                var errors=response.getError();
                console.log('Error',errors);
            }
            
        });
        
        $A.enqueueAction(act); 
              //  }
    },
   
   getLeads: function (cmp,e,h){
      cmp.set("v.showbutton", true);
   console.log('leadhandler');
                console.log('-------------',cmp.get("v.showbutton"));
       // console.log('handleonchange',cmp.get("v.showCustomer"));
    // var mybool=cmp.get("v.showCustomer");  
       // console.log('mybool',mybool);
              //  if(mybool){
        var act = cmp.get("c.fetchLead");
        console.log('act',act);
        act.setCallback(this, function(response) {
            console.log('response'+response);
            var state = response.getState();
            console.log(state);
            if (state == "SUCCESS") {
                var obj =response.getReturnValue() ;
                console.log(obj);
                                   /*if(resp.location.length>0){
                        cmp.set('v.center',resp[0].location); 
                    }
                    else {
                        cmp.set('v.center', {
                   location: {
                            City: 'Nagpur'
                        }
                    });
                    }*/ cmp.set('v.center', {
                   location: {
                             Latitude:cmp.get("v.latitude"),
                      Longitude:cmp.get("v.longitude")
                    
                        }
                    });
                
                 console.log('Latitude',cmp.get("v.latitude"));
                    console.log('Longitude',cmp.get("v.longitude"));
               //cmp.set('v.center',resp[0].location); 
                cmp.set('v.mapMarkers',obj);
                cmp.set('v.zoomLevel',12);
                cmp.set('v.markersTitle', 'Salesforce locations');
                cmp.set('v.showFooter', true);
                //component.set('v.renderMap', true);
                
            }    else{
                
                var errors=response.getError();
                console.log('Error',errors);
            }
            
        });
        
        $A.enqueueAction(act); 
        
//}
    }, 
   handleOnChange: function (cmp,e,h){
       console.log('newcmp');
      
cmp.set("v.showbutton", true);
        cmp.set("v.showCustomer", false);
             console.log('-------------',cmp.get("v.showbutton"));
        console.log('v.showCustomer',cmp.get("v.showCustomer"));
        var actn = cmp.get("c.getLead");
        console.log('actions',actn);
        actn.setParams({ "latitude" :cmp.get("v.latitude"),
                        "longitude" : cmp.get("v.longitude"),
                        "sliderval" : cmp.get("v.myval")
                       });
        actn.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    var resp =response.getReturnValue() ;
                    console.log(resp);
                  cmp.set('v.center', {
                   location: {
                             Latitude:cmp.get("v.latitude"),
                      Longitude:cmp.get("v.longitude")
                    
                        }
                    });
                     console.log('Latitude',cmp.get("v.latitude"));
                    console.log('Longitude',cmp.get("v.longitude"));
                  // cmp.set('v.center',resp[0].location); 
                /* if(resp.location.length>0){
                        cmp.set('v.center',resp[0].location); 
                    }
                    else{
                        cmp.set('v.center', {
                   location: {
                            City: 'Nagpur'
                        }
                    });
                    }*/
                    cmp.set('v.mapMarkers',resp);
                    cmp.set('v.zoomLevel',12);
                    cmp.set('v.markersTitle', 'Salesforce locations');
                    cmp.set('v.showFooter', true);
                    //cmp.set('v.renderMap', true);
                }
                //  $A.get("e.force:closeQuickAction").fire();
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
        $A.enqueueAction(actn);
        
    },
    sourceFunct: function (cmp,e,h){
       
    cmp.set("v.showbutton", true);
      
             console.log('-------------',cmp.get("v.showbutton"));
        var flag = cmp.get("v.showCustomer");
        if(flag === true) {
            //call apex to get filtered account and set map attributes as done in 
            var actn = cmp.get("c.getAccount");
        console.log('actions',actn);
        actn.setParams({ "latitude" :cmp.get("v.latitude"),
                        "longitude" : cmp.get("v.longitude"),
                        "sliderval" : cmp.get("v.myval")
                       });
        actn.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    var resp =response.getReturnValue() ;
                    console.log(resp);
             /*  if(resp.location.length>0){
                        cmp.set('v.center',resp[0].location); 
                    }
                    else {
                        cmp.set('v.center', {
                   location: {
                            City: 'Nagpur'
                        }
                    });
                    }*/
                   cmp.set('v.center', {
                   location: {
                             Latitude:cmp.get("v.latitude"),
                      Longitude:cmp.get("v.longitude")
                    
                        }
                    });  
                     console.log('Latitude',cmp.get("v.latitude"));
                    console.log('Longitude',cmp.get("v.longitude"));
                    // cmp.set('v.center',resp[0].location); 
                    cmp.set('v.mapMarkers',resp);
                    cmp.set('v.zoomLevel', 12);
                    cmp.set('v.markersTitle', 'Salesforce locations');
                    cmp.set('v.showFooter', true);
                    //cmp.set('v.renderMap', true);
                }
                //  $A.get("e.force:closeQuickAction").fire();
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
        $A.enqueueAction(actn);
        }
        
        else if(flag === false) {
            //call lead
             var actn = cmp.get("c.getLead");
        console.log('actions',actn);
        actn.setParams({ "latitude" :cmp.get("v.latitude"),
                        "longitude" : cmp.get("v.longitude"),
                        "sliderval" : cmp.get("v.myval")
                       });
        actn.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    var resp =response.getReturnValue() ;
                    console.log(resp);
                  cmp.set('v.center', {
                   location: {
                             Latitude:cmp.get("v.latitude"),
                      Longitude:cmp.get("v.longitude")
                    
                        }
                    });
                     console.log('Latitude',cmp.get("v.latitude"));
                    console.log('Longitude',cmp.get("v.longitude"));
                    // cmp.set('v.center',resp[0].location); 
                   /*if(resp.location.length>0){
                        cmp.set('v.center',resp[0].location); 
                    }
                    else {
                        cmp.set('v.center', {
                   location: {
                            City: 'Nagpur'
                        }
                    });
                    }*/
                    cmp.set('v.mapMarkers',resp);
                    cmp.set('v.zoomLevel',12);
                    cmp.set('v.markersTitle', 'Salesforce locations');
                    cmp.set('v.showFooter', true);
                    //cmp.set('v.renderMap', true);
                }
                //  $A.get("e.force:closeQuickAction").fire();
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
        $A.enqueueAction(actn);
        }
        
        var act = cmp.get("v.button1");
        
        
        
////////////////////////
    //  this.getAccount(cmp,e,h);

  
        // var action = component.get('c.getAccount');
        //$A.enqueueAction(action);
        
         // cmp.set("v.showCustomer", false);
               //console.log('handleonchange',cmp.get("v.showCustomer"));
       // this.getLead(cmp,e,h);
  // var action = component.get('c.getLead');
        //$A.enqueueAction(action);
       // }
    },
    
    handleNearBy:  function (cmp,e,h){
  cmp.set("v.showbutton", false);
        console.log('--------------------------',cmp.get("v.showbutton"));
        console.log('Nearby');
       /* var evt = $A.get("e.force:navigateToComponent");
        console.log('Event '+evt);
     
        evt.setParams({
            componentDef  : "c:ShowNearbyLocationChild" ,
           
        });
   evt.fire();*/

},
    handleMarkerSelect: function (cmp, event, helper) {
        cmp.set("v.showbutton", true);
                 console.log('-------------',cmp.get("v.showbutton"));
      var marker = event.getParam("selectedMarkerValue");
       // var marker = cmp.get('v.selectedMarkerValue');
          console.log('marker',marker);
    }
})