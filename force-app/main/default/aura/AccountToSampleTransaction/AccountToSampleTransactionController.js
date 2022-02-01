({
	navigate : function(component, event, helper) {
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:SampleTransaction",
            componentAttributes :{
            	varaccountid : component.get("v.recordId")
        	}
        });
        navigateEvent.fire();
    }
})