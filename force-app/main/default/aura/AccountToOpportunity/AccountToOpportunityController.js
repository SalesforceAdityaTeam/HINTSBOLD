({
	navigate : function(component, event, helper) {
        console.log(component.get("v.recordId"));
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:OpportunityCreateEdit",
            componentAttributes :{
            	accid : component.get("v.recordId")
        	}
        });
        navigateEvent.fire();
    }
})