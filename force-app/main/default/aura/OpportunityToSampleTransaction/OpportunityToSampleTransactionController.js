({
	navigate : function(component, event, helper) {
        alert(component.get("v.recordId"));
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:OpportunityCreateEdit",
            componentAttributes :{
            	varopportunityid : component.get("v.recordId")
        	}
        });
        navigateEvent.fire();
    }
})