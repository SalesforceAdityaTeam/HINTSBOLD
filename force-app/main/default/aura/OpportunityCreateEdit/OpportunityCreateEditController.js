({  doInit:  function (component, event, helper){
    var oppid  = component.get("v.recordId");
    if(component.get("v.accid") != null && component.get("v.accid") != 'undefined' && component.get("v.accid") != undefined ){
        helper.assignLookupdetails(component, event, helper);
    }
    if(component.get("v.conid") != null && component.get("v.conid") != 'undefined' && component.get("v.conid") != undefined ){
        component.find("Contact__c").set("v.value",component.get("v.conid") );
        component.set("v.parentId",component.get("v.conid"));
    }
    if(oppid != null && oppid != 'undefined' && oppid != undefined) {
    	var action = component.get("c.fetchLookUpValues");
        action.setParams({
            'varId': component.get("v.recordId")
        });
    	action.setCallback(this, function(response) {
            
            if (response.getState() === "SUCCESS") {
                component.set("v.opp",response.getReturnValue());
                var oppval = component.get("v.opp");
                component.set("v.accid", oppval["Account__c"]);
                component.set("v.destid",oppval["Destination_Location__c"]);
                component.set("v.parentId",oppval["Contact__c"]);
                helper.assignLookupdetails(component, event, helper);
            }
        });
        $A.enqueueAction(action); 
    }
	}, 
    
    handleOnSuccess: function (component, event, helper){
        var params = event.getParams();
        var recordId = params.response.id;
        window.open("https://hoogwegtus.lightning.force.com/lightning/r/Opportunity__c/"+recordId+"/view","_self");
    },
  
  cancel:  function (component, event, helper){
     var recordId = component.get("v.recordId");
      window.open("https://hoogwegtus.lightning.force.com/lightning/r/Opportunity__c/"+recordId+"/view","_self");
  },
  contactSelected: function (component, event, helper){
        var conid = component.find("Contact__c").get("v.value");
        component.set("v.parentId",conid);
    }, 
    
    handleOnSubmit : function(component, event, helper) {
        component.set("v.isSubmited","Yes");
        event.preventDefault();
        var eventFields = event.getParam("fields"); 
        helper.reverseassignment(component, event, helper,eventFields);
        
        if(eventFields["Destination_Location__c"] == undefined){
            eventFields["Destination_Location__c"] = null;
        }
        if(eventFields["Account__c"] == undefined || eventFields["Account__c"] == null || eventFields["Account__c"] == ''){
            eventFields["Account__c"] = null;
            alert("Account is required.");
            component.set("v.isSubmited","no");
        }else {
            component.find('form').submit(eventFields);
        }
    },
 
    handleOnError : function(component, event, helper){
        var error = event.getParams();
        console.log(">>>>>>>>>>>>>"+event.getParam("message"));
        console.log(">>>>>>>>>>>>>"+event.getParam("detail"));
        console.log(">>>>>>>>>>>>>"+event.getParam("output").fieldErrors);
        console.log(">>>>>>>>>>>>>"+event.getParam("errorCode"));
        console.log(">>>>>>>>>>>>>"+event.getParam("output"));
        console.log(">>>>>>>>>>>>>"+JSON.stringify(event.getParam("error")));
        if(event.getParam("detail") == "Please only populate the 'Product Description' or the 'Product Description - Other' field. Both fields cannot be populated."){
            alert(event.getParam("detail"))
        }
        if(event.getParam("detail") == "Sales Order # is required to update the Stage Entered"){
            alert(event.getParam("detail"))
        }
        if(event.getParam("detail") == "End Date should not be a date prior to the Start Date."){
            alert(event.getParam("detail"))
        }
        if(event.getParam("detail") == "Date entered cannot be a date prior to today."){
            alert(event.getParam("detail"))
        }
    },
    
    handleCreateLoad: function (component, event, helper) {
        var cmpTarget = component.find('form');
        if(cmpTarget != null && cmpTarget != 'undefined' && cmpTarget != undefined)
        	$A.util.addClass(cmpTarget, 'updatewithdesign');
    
        var oppid = component.get("v.recordId");
        if(oppid != null && oppid != 'undefined' && oppid != undefined){
           helper.assign(component,event, helper,component.get("v.opp"));
		   helper.calculatefunction(component, event, helper);    
         }
    },
    
    first : function(component, event, helper){
        var a = event.getSource();
        var auraid = a.getLocalId();
        console.log('>>>>>>>auraid>>>>'+auraid);
        var inpval = component.find(auraid).get('v.value');
        var volume  = component.find('Volume__c').get('v.value');
        if(volume == undefined) 
            volume = 1 ;
       console.log(">>>>>>>>>87>");
        if(auraid == 'Drayage_Domestic_Inland_per_lb_MT__c' && inpval != null ) {
            component.find("Drayage_Domestic_Inland_Fixed__c").set("v.disabled", true);
            component.find("Drayage_Domestic_Inland_Fixed__c").set("v.value", 0);
        } else if (auraid == 'Ocean_Freight_per_lb_MT__c' && inpval != null  ) {
            component.find("Ocean_Freight_Fixed__c").set("v.disabled", true);
            component.find("Ocean_Freight_Fixed__c").set("v.value", 0);
        } else if (auraid == 'Pallets_per_lb_MT__c' && inpval != null ) {
            component.find("Pallets_Fixed__c").set("v.disabled", true);
            component.find("Pallets_Fixed__c").set("v.value", 0);
        } else if (auraid == 'Labels_per_lb_MT__c' && inpval != null ) {
            component.find("Labels_Fixed__c").set("v.disabled", true);
            component.find("Labels_Fixed__c").set("v.value", 0);
        } else if (auraid == 'Docs_per_lb_MT__c' && inpval != null ) {
            component.find("Docs_fixed__c").set("v.disabled", true);
            component.find("Docs_fixed__c").set("v.value", 0);
        } else if (auraid == 'Cwt_per_lb_MT__c' && inpval != null ) {
            component.find("Cwt_Fixed__c").set("v.disabled", true);
            component.find("Cwt_Fixed__c").set("v.value", 0);
            component.find("Cwt_per_lb_MT__c").set("v.value", (-1) * component.find("Cwt_per_lb_MT__c").get("v.value"));
        } else if (auraid == 'L_C_Bank_Fee_per_lb_MT__c' && inpval != null ) {
            component.find("L_C_Bank_Fee_Fixed__c").set("v.disabled", true);
            component.find("L_C_Bank_Fee_Fixed__c").set("v.value", 0);
        } else if (auraid == 'Agent_commission_per_lb_MT__c' && inpval != null ) {
            component.find("Agent_commission_Fixed__c").set("v.disabled", true);
            component.find("Agent_commission_Fixed__c").set("v.value", 0 );
        }
        console.log(">>>>>>>>>114>");
        if(auraid == 'Drayage_Domestic_Inland_Fixed__c' && inpval != null ) {
            component.find("Drayage_Domestic_Inland_per_lb_MT__c").set("v.disabled", true);
            component.find("Drayage_Domestic_Inland_per_lb_MT__c").set("v.value", inpval /volume  );
        }  else if (auraid == 'Ocean_Freight_Fixed__c' && inpval != null  ) {
            component.find("Ocean_Freight_per_lb_MT__c").set("v.disabled", true);
            component.find("Ocean_Freight_per_lb_MT__c").set("v.value", inpval /volume);
        } else if (auraid == 'Pallets_Fixed__c' && inpval != null ) {
            component.find("Pallets_per_lb_MT__c").set("v.disabled", true);
            component.find("Pallets_per_lb_MT__c").set("v.value", inpval /volume );
        } else if (auraid == 'Labels_Fixed__c' && inpval != null ) {
            component.find("Labels_per_lb_MT__c").set("v.disabled", true);
            component.find("Labels_per_lb_MT__c").set("v.value", inpval /volume );
        } else if (auraid == 'Docs_fixed__c' && inpval != null ) {
            component.find("Docs_per_lb_MT__c").set("v.disabled", true);
            component.find("Docs_per_lb_MT__c").set("v.value", inpval /volume );
        } else if (auraid == 'Cwt_Fixed__c' && inpval != null ) {
            component.find("Cwt_per_lb_MT__c").set("v.disabled", true);
            component.find("Cwt_per_lb_MT__c").set("v.value", inpval /volume );
            component.find("Cwt_Fixed__c").set("v.value",  (-1) * component.find("Cwt_Fixed__c").get("v.value"));
        } else if (auraid == 'L_C_Bank_Fee_Fixed__c' && inpval != null ) {
            component.find("L_C_Bank_Fee_per_lb_MT__c").set("v.disabled", true);
            component.find("L_C_Bank_Fee_per_lb_MT__c").set("v.value", inpval /volume);
        } else if (auraid == 'Agent_commission_Fixed__c' && inpval != null ) {
            component.find("Agent_commission_per_lb_MT__c").set("v.disabled", true);
            component.find("Agent_commission_per_lb_MT__c").set("v.value", inpval /volume );
        } 
        console.log(">>>>>>>>>141>");
        if(auraid == 'Drayage_Domestic_Inland_per_lb_MT__c' && (inpval == null || inpval == 0)  ) {
            component.find("Drayage_Domestic_Inland_Fixed__c").set("v.disabled", false);
        } else if (auraid == 'Ocean_Freight_per_lb_MT__c' && (inpval == null || inpval == 0)  ) {
            component.find("Ocean_Freight_Fixed__c").set("v.disabled", false);
        } else if (auraid == 'Pallets_per_lb_MT__c' && (inpval == null || inpval == 0)  ) {
            component.find("Pallets_Fixed__c").set("v.disabled", false);
        } else if (auraid == 'Labels_per_lb_MT__c' && (inpval == null || inpval == 0) ) {
            component.find("Labels_Fixed__c").set("v.disabled", false);
        } else if (auraid == 'Docs_per_lb_MT__c' && (inpval == null || inpval == 0) ) {
            component.find("Docs_fixed__c").set("v.disabled", false);
        } else if (auraid == 'Cwt_per_lb_MT__c' && (inpval == null || inpval == 0) ) {
            component.find("Cwt_Fixed__c").set("v.disabled", false);
        } else if (auraid == 'L_C_Bank_Fee_per_lb_MT__c' && (inpval == null || inpval == 0)) {
            component.find("L_C_Bank_Fee_Fixed__c").set("v.disabled", false);
        } else if (auraid == 'Agent_commission_per_lb_MT__c' && (inpval == null || inpval == 0) ) {
            component.find("Agent_commission_Fixed__c").set("v.disabled", false);
        }
        console.log(">>>>>>>>>159>");
        if(auraid == 'Drayage_Domestic_Inland_Fixed__c' && (inpval == null || inpval == 0) ) {
            component.find("Drayage_Domestic_Inland_per_lb_MT__c").set("v.disabled", false);
        } else if (auraid == 'Ocean_Freight_Fixed__c' && (inpval == null || inpval == 0)  ) {
            component.find("Ocean_Freight_per_lb_MT__c").set("v.disabled", false);
        } else if (auraid == 'Pallets_Fixed__c' && (inpval == null || inpval == 0) ) {
            component.find("Pallets_per_lb_MT__c").set("v.disabled", false);
        } else if (auraid == 'Labels_Fixed__c' && (inpval == null || inpval == 0) ) {
            component.find("Labels_per_lb_MT__c").set("v.disabled", false);
        } else if (auraid == 'Docs_fixed__c' && (inpval == null || inpval == 0) ) {
            component.find("Docs_per_lb_MT__c").set("v.disabled", false);
        } else if (auraid == 'Cwt_Fixed__c' && (inpval == null || inpval == 0) ) {
            component.find("Cwt_per_lb_MT__c").set("v.disabled", false);
        } else if (auraid == 'L_C_Bank_Fee_Fixed__c' && (inpval == null || inpval == 0) ) {
            component.find("L_C_Bank_Fee_per_lb_MT__c").set("v.disabled", false);
        } else if (auraid == 'Agent_commission_Fixed__c' && (inpval == null || inpval == 0) ) {
            component.find("Agent_commission_per_lb_MT__c").set("v.disabled", false);
        } 
         console.log(">>>>>>>>>1");
        var avgdays  = component.get("v.selectedChildAccount").MaxAVGDays__c
        if($A.util.isEmpty(avgdays) != true){
            component.find("AvgDaysPastDue__c").set("v.value",avgdays );
        }
        console.log(">>>>>>>>>2");
        var rate = component.find("Rate__cFT").get("v.value")  ;
        if($A.util.isEmpty(rate)){
            var accid = component.get("v.accid");
            if($A.util.isEmpty(accid)){
                accid =  component.get("v.selectedChildAccount").Id ;
            }
        }
            if($A.util.isEmpty(accid) != true){
                var action = component.get("c.generateRate");
                action.setParams({
                    'destId': accid
                  });
            action.setCallback(this, function(response) {
                
            if (response.getState() === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    component.find("Rate__cFT").set("v.value", storeResponse);
                 	helper.calculatefunction(component, event, helper);
                } else {
                    helper.calculatefunction(component, event, helper);
            	}
        	});
        	$A.enqueueAction(action);  
          }
        else {
           helper.calculatefunction(component, event, helper); 
        }
	},
  
  changeAccount : function (component, event, helper) {
      	
        $A.util.addClass( component.find("accountSH") , 'slds-hide');
        $A.util.removeClass( component.find("accountcls")  , 'slds-hide' );
      	component.find("Account__cFT").set("v.value",null );
  },
  
  changeLocation : function (component, event, helper) {
      	$A.util.addClass( component.find("destinationSH") , 'slds-hide');
        $A.util.removeClass( component.find("destinationcls")  , 'slds-hide' );
      	component.find("Destination_Location__cFT").set("v.value",null );
  }
   
 })