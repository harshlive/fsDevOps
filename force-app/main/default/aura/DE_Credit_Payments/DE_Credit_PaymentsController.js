({
    doInit : function(component, event, helper) {
        var action = component.get("c.getCreditInformation");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("SUCCESS" + response.getReturnValue());
                component.set("v.credInfo",response.getReturnValue()['CREDIT_INFO']);
                component.set("v.visitInfo",response.getReturnValue()['VISIT_INFO']);
            }
            else if(state === "ERROR") {
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
    }
})