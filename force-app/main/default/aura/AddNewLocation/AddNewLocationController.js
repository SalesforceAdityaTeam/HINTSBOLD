({
	doInit : function(component, event, helper) {
        
        var recordid = component.get("v.recordId");
        if(recordid != undefined && recordid != null && recordid != '' ){
            var action = component.get("c.parentAccount");
                action.setParams({
                    'recordId' : recordid
                });
            action.setCallback(this, function(response) {
                    var state = response.getState();
                     if (state === "SUCCESS") {
                         var storeResponse = response.getReturnValue();
                         component.set("v.parentAccount", storeResponse);
                         var lookUpTarget = component.find("lookupacc");
                         $A.util.addClass(lookUpTarget, 'slds-hide');
                         $A.util.removeClass(lookUpTarget, 'slds-show');
                         
                         var lookUpTarget = component.find("textacc");
                         $A.util.addClass(lookUpTarget, 'slds-show');
                         $A.util.removeClass(lookUpTarget, 'slds-hide');
                   }
                });
                $A.enqueueAction(action);
        }
        
        $A.util.addClass(component.find("required1"), "slds-hide");
	},
    save : function(component, event, helper) {
       var isValid = helper.validationcheck(component, event, helper); 
        if(isValid){
            
               var varloc = component.get("v.objLocation");
               varloc.addrline4__c = component.get("v.city") + ', ' + component.get("v.state") ;
            
               var action = component.get("c.saveRecords");
            
                action.setParams({
                    'LOc': varloc,
                    'parentAccount' : component.get("v.parentAccount"),
                    'searchLocation' : component.get("v.searchLocation")
                });
            
                action.setCallback(this, function(response) {
                
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var storeResponse = response.getReturnValue();
                        window.open("https://hoogwegtus.lightning.force.com/lightning/r/Account_Location__c/"+storeResponse+"/view","_self");
                   }
                });
                $A.enqueueAction(action);
        }         
       
	},
    saveandnew : function(component, event, helper) {
    	 
       var isValid = helper.validationcheck(component, event, helper); 
        if(isValid){
               var varloc = component.get("v.objLocation");
               varloc.addrline4__c = component.get("v.city") + ', ' + component.get("v.state") ;
               var action = component.get("c.saveRecords");
                action.setParams({
                    'LOc': varloc,
                    'parentAccount' : component.get("v.parentAccount"),
                    'searchLocation' : component.get("v.searchLocation")
                });
                action.setCallback(this, function(response) {
                    alert(response.getState());
                    var state = response.getState();
                    $A.get('e.force:refreshView').fire();
                });
                $A.enqueueAction(action);
        }
        
        component.set("v.city","");
        component.set("v.state","");
        component.set("v.parentAccount","{'sobjectType': 'Account'}");
        component.set("v.searchLocation","{'sobjectType': 'Location__c'}");
        component.set('v.objLocation.addrline2__c','');
        component.set('v.objLocation.addrline3__c','');
        component.set('v.objLocation.addrpost_code__c','');
        component.set('v.objLocation.addrline5__c','');
        component.set('v.objLocation.UNCode__c','');
        
	},
    handleRemove : function(component, event, helper) {
        var lookUpTarget = component.find("lookupacc");
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        var Target = component.find("textacc");
        $A.util.addClass(Target, 'slds-hide');
        $A.util.removeClass(Target, 'slds-show');
        
    },
    cancel :  function(component, event, helper){
        window.open("https://hoogwegtus.lightning.force.com/lightning/o/Account/home","_self");
    }
})