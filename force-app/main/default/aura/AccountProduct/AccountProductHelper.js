({
	presetDataValue : function(component,isCheck ) {
	    var action = component.get("c.preSetValue");
        action.setParams({
            varId: component.get("v.recordId"),
            lstProd: component.get("v.lstProducts")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS") {
                component.set("v.lstProducts", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                if(response.getReturnValue().length == 0){
                    toastEvent.setParams({
                        message: 'No record found, try another search.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'Warning',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
	},
    savedata : function(component) {
        var isCheck = false;
        var str = JSON.stringify(component.get("v.lstProducts"));
	    var action = component.get("c.saveLineItem");
        action.setParams({
            varId: component.get("v.recordId"),
            lstProd : component.get("v.lstProducts")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS") {                
                var offer = response.getReturnValue();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": offer,
                    "slideDevName" : "detail"
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(action);
	},
    removeDataValue : function(component,rowId) {
        var action = component.get("c.removeLineItem");
        action.setParams({
            lstProd : component.get("v.lstProducts"),
            rowId : rowId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS") {   
                component.set("v.lstProducts", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Record deleted',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'Warning',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
              
            }
        });
        $A.enqueueAction(action);
	},
    addOneMOreValue : function(component,rowId) {
        var action = component.get("c.addOneMOreValue");
        action.setParams({
            lstProd : component.get("v.lstProducts"),
            rowId : rowId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS") {   
                component.set("v.lstProducts", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Record Added',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'Warning',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
              
            }
        });
        $A.enqueueAction(action);
	},
})