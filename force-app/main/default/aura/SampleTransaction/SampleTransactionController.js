({
	onblur : function(component,event,helper){
        component.set("v.listOfSearchRecords", null );
        component.set("v.SearchKeyWord", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null ); 
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    
    keyPressController : function(component, event, helper) {
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var getInputkeyWord = component.get("v.SearchKeyWord");
         if(getInputkeyWord.length > 0){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedRecords"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i].Id == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
            }  
        }
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );      
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        component.set("v.SearchKeyWord",null);
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedRecords" , listSelectedItems); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    handleSubmit: function(component, event, helper) {
        component.set("v.showSpinner", true);
    },
    handleSuccess: function(component, event,helper) {
        var payload = event.getParams().response;
		console.log(payload.id);
        component.set("v.recordId", payload.id);
        var action = component.get("c.insertRelatedListRecords");
        action.setParams({
            'varId' : payload.id,
            'lstData' : component.get('v.lstSelectedRecords'),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue(); 
                component.set("v.showSpinner", false);
                component.set("v.saved", true );
            }
        });
        $A.enqueueAction(action);
    },
    handleUploadFinished: function(component, event, helper) {
        window.open("https://hoogwegtus.lightning.force.com/lightning/r/Sample_Transaction__c/"+component.get("v.recordId")+"/view","_self");
    },
    handleCancel: function(component, event, helper) {
        window.open("https://hoogwegtus.lightning.force.com/lightning/o/Sample_Transaction__c/list?filterName=Recent","_self");
    },
    handleCreateLoad: function (component, event, helper) {
        var ST = component.find('form');
        if(component.get("v.varopportunityid") != '' && component.get("v.varopportunityid") != null && component.get("v.varopportunityid") != 'undefined' ){
            component.find("Opportunity__c").set("v.value",component.get("v.varopportunityid"));
        }
        if(component.get("v.varaccountid") != '' && component.get("v.varaccountid") != null && component.get("v.varaccountid") != 'undefined' ){
            component.find("Company__c").set("v.value",component.get("v.varaccountid"));
        }
    },
})