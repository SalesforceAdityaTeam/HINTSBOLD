({
	fetchopportunity : function(component, event, helper) {
		var action = component.get("c.getOpportunityObject");
        var oppid = component.get("v.recordId");
        
        action.setParams({
            oppid: oppid
        });
        action.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS' ){
                var opp = response.getReturnValue();
                component.set("v.opportunity",opp);
            }
            else {
                alert('Error in getting data');
            }
        });
        $A.enqueueAction(action);
	},
})