({
	presetData : function(component, event, helper) {
        component.set("v.spinner", true);
		helper.presetDataValue(component,true);
	},
     savedata : function(component, event, helper) {
        component.set("v.spinner", true);
		helper.savedata(component, event, helper);
	},
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
})