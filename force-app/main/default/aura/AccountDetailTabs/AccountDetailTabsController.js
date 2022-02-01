({
    tabHandler: function (component, event, helper) {
        component.set("v.oldtabSelected",component.get("v.tabSelected"));
        var tab = event.getSource();
        component.set("v.tabSelected",tab.get('v.id'));
        console.log(tab.get('v.id'));
    },
    handleCreateLoad: function (component, event, helper) {
        component.set("v.Spinner", true); 
        var tab = component.get("v.tabSelected");
        if(tab != component.get("v.oldtabSelected")){
            if(tab == "Trade"){
                helper.Trade(component, event, helper);
            }else if(tab == "Logistics"){
                helper.Logistics(component, event, helper);
            }else if(tab == "Techno"){
                helper.Techno(component, event, helper);
            }else if(tab == "Finance"){
                helper.Finance(component, event, helper);
            }else if(tab == "Summary"){
                helper.Summary(component, event, helper);
            }else if(tab == "Address"){
                helper.Address(component, event, helper);
            }
        }
        component.set("v.Spinner", false); 
        component.set("v.oldtabSelected",component.get("v.tabSelected"));
    },
    onClick: function (component,event,helper){
        component.set("v.Spinner", true); 
        var getdata = component.get("v.IsChanged");
        if(getdata == "true"){
            var tab = component.get("v.tabSelected");
            if(tab == "Trade"){
                helper.Trade(component, event, helper);
            }else if(tab == "Logistics"){
                helper.Logistics(component, event, helper);
            }else if(tab == "Techno"){
                helper.Techno(component, event, helper);
            }else if(tab == "Finance"){
                helper.Finance(component, event, helper);
            }else if(tab == "Summary"){
                helper.Summary(component, event, helper);
            }else if(tab == "Address"){
                helper.Address(component, event, helper);
            }
        }
        component.set("v.Spinner", false); 
    },
    handleSuccess: function(component, event, helper) {
        component.set("v.Spinner", true); 
        helper.savedata(component, event, helper);
        component.set("v.IsEdit",false); 
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": event.getParam("response").id,
            "slideDevName": "detail"
        });
        navEvt.fire();
        component.set("v.Spinner", false); 
    },
    handleClick : function (cmp, event, helper) {
        cmp.set("v.IsEdit",true); 
    },
    cancel : function (cmp, event, helper) {
        cmp.set("v.IsEdit",false); 
    },
    
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
    
});