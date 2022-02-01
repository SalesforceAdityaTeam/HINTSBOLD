({
	presetData : function(component, event, helper) {
        component.set("v.spinner", true);
		helper.presetDataValue(component,true);
	},
    savedata : function(component, event, helper) {
        component.set("v.spinner", true);
		helper.savedata(component, event, helper);
	},
    addThreedata : function(component, event, helper) {
        component.set("v.spinner", true);
		helper.presetDataValue(component,false);
	}
    ,
    removedata : function(component, event, helper) {
        var rowId = event.getSource().get("v.name");
        component.set("v.spinner", true);
		helper.removeDataValue(component,rowId);
	},
    addOnedata : function(component, event, helper) {
       var rowId = event.getSource().get("v.name");
        component.set("v.spinner", true);
		helper.addOneMOreValue(component,rowId);
	},
    down : function(component, event, helper) {
        var rowId = event.getSource().get("v.name");
        component.set("v.spinner", true);
        helper.adjust(component,rowId,"down");
    },
     up : function(component, event, helper) {
        var rowId = event.getSource().get("v.name");
        component.set("v.spinner", true);
        helper.adjust(component,rowId,"up");
    },
    handleSuccess : function(component, event, helper) {
        component.set("v.spinner", true);
		helper.savedata(component, event, helper);
    },
	
    saveandsend: function(component, event, helper){
        component.set("v.spinner", true);
    	component.find("formdata").submit();
        
        var isCheck = false;
        var str = JSON.stringify(component.get("v.lstProducts"));
	    var action = component.get("c.saveLineItem");
        action.setParams({
            varId: component.get("v.recordId"),
            lstProd : component.get("v.lstProducts"),
            IsApprovedOnly : isCheck,
            relatedContact : component.get("v.selectedLookUpRecords"),
            relatedContactBcc : component.get("v.selectedLookUpRecordsbcc")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS") {                
                var offer = response.getReturnValue();
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url":"/apex/OfferEmailSend?id="+offer
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
	}    
})