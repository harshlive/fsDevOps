({
	doInit : function(component, event, helper) {
		var action = component.get("c.getPerformanceRecs");
        action.setCallback(this, function(response){
            component.set('v.performanceList', response.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})