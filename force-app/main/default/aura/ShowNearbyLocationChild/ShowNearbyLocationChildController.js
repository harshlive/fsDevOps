({
    init: function (cmp, event, helper) {
        cmp.set('v.mapMarkers', [
            {
                location: {
                    Street: '1 Market St',
                    City: 'San Francisco',
                    PostalCode: '94105',
                    State: 'CA',
                    Country: 'USA'
                },
                value: 'location001',
                icon: 'utility:salesforce1',
                title: 'Worldwide Corporate Headquarters',
                description: 'Sales: 1800-NO-SOFTWARE'
            },
            {
                location: {
                    Street: '950 East Paces Ferry Road NE',
                    City: 'Atlanta',
                    PostalCode: '94105',
                    State: 'GA',
                    Country: 'USA'
                },
                value: 'location002',
                icon: 'utility:salesforce1',
                title: 'salesforce.com inc Atlanta'
            },
            {
                location: {
                    Street: '929 108th Ave NE',
                    City: 'Bellevue',
                    PostalCode: '98004',
                    State: 'WA',
                    Country: 'USA'
                },
                value: 'location003',
                icon: 'utility:salesforce1',
                title: 'salesforce.com inc Bellevue'
            },
            {
                location: {
                    Street: '500 Boylston Street 19th Floor',
                    City: 'Boston',
                    PostalCode: '02116',
                    State: 'MA',
                    Country: 'USA'
                },
                value: 'location004',
                icon: 'utility:salesforce1',
                title: 'salesforce.com inc Boston'
            },
            {
                location: {
                    Street: '111 West Illinois Street',
                    City: 'Chicago',
                    PostalCode: '60654',
                    State: 'IL',
                    Country: 'USA'
                },
                value: 'location005',
                icon: 'utility:salesforce1',
                title: 'salesforce.com inc Chicago'
            },
            {
                location: {
                    Street: '2550 Wasser Terrace',
                    City: 'Herndon',
                    PostalCode: '20171',
                    State: 'VA',
                    Country: 'USA'
                },
                value: 'location006',
                icon: 'utility:salesforce1',
                title: 'salesforce.com inc Herndon'
            },
            {
                location: {
                    Street: '111 Monument Circle',
                    City: 'Indianapolis',
                    PostalCode: '46204',
                    State: 'IN',
                    Country: 'USA'
                },
                value: 'location007',
                icon: 'utility:salesforce1',
                title: 'salesforce.com inc Indy'
            },
            {
                location: {
                    Street: '361 Centennial Parkway',
                    City: 'Louisville',
                    PostalCode: '80027',
                    State: 'CO',
                    Country: 'USA'
                },
                value: 'location008',
                icon: 'utility:salesforce1',
                title: 'salesforce.com inc Louisville'
            },
            {
                location: {
                    Street: '685 Third Ave',
                    City: 'New York',
                    PostalCode: '10017',
                    State: 'NY',
                    Country: 'USA'
                },
                value: 'location009',
                icon: 'utility:salesforce1',
                title: 'salesforce.com inc New York'
            },
        ]);
            
            cmp.set('v.center', {
            location: {
            City: 'Denver'
            }
            });
            
            cmp.set('v.zoomLevel', 4);
            cmp.set('v.markersTitle', 'Salesforce locations in United States');
            cmp.set('v.showFooter', true);
            console.log('mapmarker',cmp.get('v.mapMarkers'));
            
            },
            handleChange:function (cmp, event, helper){
            var changeValue = event.getParam("value");
            alert(changeValue);
            },
            
            
            
            handleCreatLead: function (cmp, event, helper){
            
           
            var valuetobecompare=cmp.get('v.selectedMarkerValue');
            var  markerval=cmp.get('v.mapMarkers');
            console.log('valuetobecompare',valuetobecompare);
            console.log('markerval',markerval);
            var selectedMarkerElem;
            //var  jsonString;
            for(var i=0;i<markerval.length;i++){
            if(markerval[i].value == valuetobecompare ){
            selectedMarkerElem = markerval[i];
            
            break;
        }
        
        //console.log('key1',JSON.stringify(jsonString));
        console.log('selectedMarkerElem',selectedMarkerElem);
    }
    var leadRec = { LastName:selectedMarkerElem.title,
   				 Company:selectedMarkerElem.value
    
				};
    var action = cmp.get("c.getleads");
    action.setParams({ "jsonString" :JSON.stringify(leadRec)
});
action.setCallback(this, function(response) {
    var state = response.getState();
    if (state === "SUCCESS") {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Lead is created successfully',
            duration:'2000',
            type: 'success',
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
        
        //  $A.get('e.force:refreshView').fire();
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

},
    
    
    handleMarkerSelect: function (cmp, event, helper){
        // var marker = event.getParam("selectedMarkerValue");
        var marker =event.getParam("selectedMarkerValue");
        cmp.set("v.selectedMarkerValue",marker);
        
        console.log('andjkefheur',cmp.get('v.selectedMarkerValue'));
        console.log('marker',marker);
        
        //
        
        //
        //var JSONlead = {
        // Name: 'marker.title',
        //    Address: responseObj.Address,
        // Company: 'marker.City',
        // Address_Geolocatopon__Latitude__s:
        // Address_Geolocatopon__Longitude__s:
        // Country: 'marker.Country',
        // PostalCode:
        // State:
        // City:'marker.City',
        
        // Street:'marker.Street',
        
        // }
        
    }
//cmp.set('v.selectedMarkerValue', JSONlead);





});