({
	doInit : function(component, event, helper) {
        var action = component.get("c.saveLineItem");
        action.setParams({
            varId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var recordID  = response.getReturnValue();
              var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": recordID,
                    "slideDevName" : "detail"
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(action);
	}
})