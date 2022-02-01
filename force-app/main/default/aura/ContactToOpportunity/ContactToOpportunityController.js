({
	navigate : function(component, event, helper) {
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:OpportunityCreateEdit",
            componentAttributes :{
            conid : component.get("v.recordId")
        	}
        });
        navigateEvent.fire();
    }
})