({
	doInit : function(component, event, helper) {
       
	},
    save : function(component, event, helper) {
       var action = component.get("c.saveRecords");
        action.setParams({
            'objcon': component.get("v.objContact"),
            'objacc' : component.get("v.objAccount"),
            'selectedAcc' : component.get("v.parentAccount")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('>>>>>>>>>>response.getState()>>>>>>'+response.getState());
            console.log('>>>>>>>>>>response.getReturnValue()>>>>>>'+response.getReturnValue());
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse.includes('failed')){
                    alert(storeResponse);
                }else {
                    window.open("https://hoogwegtus.lightning.force.com/lightning/r/Account/"+storeResponse+"/view","_self");
                }
                
            }
        });
        $A.enqueueAction(action);
	},
    saveandnew : function(component, event, helper) {
        var action = component.get("c.saveRecords");
        action.setParams({
            'objcon': component.get("v.objContact"),
            'objacc' : component.get("v.objAccount"),
            'selectedAcc' : component.get("v.parentAccount")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.steps","Second");
                var storeResponse = response.getReturnValue();
                if(component.get("v.parentAccount").Id != '' && component.get("v.parentAccount").Id != null && component.get("v.parentAccount").Id != undefined ){
                    component.set("v.LocparentAccount", component.get("v.parentAccount"));
                } else {
                    var acc = component.get("v.objAccount") ;
                    acc.Id = storeResponse;
                    component.set("v.LocparentAccount",acc );
                }
                
                var lookUpTarget = component.find("lookupacc");
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show');
                var lookUpTarget = component.find("textacc");
                $A.util.addClass(lookUpTarget, 'slds-show');
                $A.util.removeClass(lookUpTarget, 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },
    cancel :  function(component, event, helper){
        window.open("https://hoogwegtus.lightning.force.com/lightning/o/Account/home","_self");
    },
    handleRemove : function(component, event, helper) {
        var lookUpTarget = component.find("lookupacc");
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        var Target = component.find("textacc");
        $A.util.addClass(Target, 'slds-hide');
        $A.util.removeClass(Target, 'slds-show');
        
    },
    savesecond : function(component, event, helper) {
               var varloc = component.get("v.objLocation");
        		console.log(">>>>>>>>>>>>>"+varloc);
               varloc.addrline4__c = component.get("v.city") + ', ' + component.get("v.state") ;
        		console.log(">>>>>>>>>>>>>"+varloc.addrline4__c);
               var action = component.get("c.saveRecordsLoc");
        		console.log(">>>>>>>>>>>>>"+action);
                action.setParams({
                    'LOc': varloc,
                    'parentAccount' : component.get("v.LocparentAccount"),
                    'searchLocation' : component.get("v.searchLocation")
                });
        console.log(">>>>>>>>>>>>>"+action);
                action.setCallback(this, function(response) {
                	console.log(">>>>>>>>>>>>>"+response.getState());
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var storeResponse = response.getReturnValue();
                        window.open("https://hoogwegtus.lightning.force.com/lightning/r/Account_Location__c/"+storeResponse+"/view","_self");
                   }
                });
     $A.enqueueAction(action);
	},
})