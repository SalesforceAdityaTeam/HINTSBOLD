({
	validationcheck : function(component, event, helper) {
        $A.util.addClass(component.find("required1"), "slds-hide");
        
        var isValid = true;
        if(component.get("v.LocparentAccount").Name == undefined ){
            $A.util.removeClass(component.find("required1"), "slds-hide");
            isValid = false;
        }
     /*   if(component.get("v.searchLocation").Name == undefined ){
            if(component.get("v.objLocation").addrline2__c == undefined || component.get("v.objLocation").addrline2__c == '' ){
                $A.util.removeClass(component.find("required2"), "slds-hide");
            	isValid = false;
            }
            if(component.get("v.objLocation").addrline3__c == undefined || component.get("v.objLocation").addrline3__c == '' ){
                $A.util.removeClass(component.find("required3"), "slds-hide");
            	isValid = false;
            }
            if(component.get("v.city") == undefined || component.get("v.city") == '' ){
                $A.util.removeClass(component.find("required4"), "slds-hide");
            	isValid = false;
            }
            if(component.get("v.state") == undefined || component.get("v.state") == '' ){
                $A.util.removeClass(component.find("required5"), "slds-hide");
            	isValid = false;
            }
            if(component.get("v.objLocation").addrpost_code__c == undefined || component.get("v.objLocation").addrpost_code__c == '' ){
                $A.util.removeClass(component.find("required6"), "slds-hide");
            	isValid = false;
            }
            if(component.get("v.objLocation").addrline5__c == undefined || component.get("v.objLocation").addrline5__c == '' ){
                $A.util.removeClass(component.find("required7"), "slds-hide");
            	isValid = false;
            }
        } */
        return isValid;
    }
})