({
	doInit : function(component, event, helper) {
        var copyText = "https://hoogwegtus.secure.force.com/form/BPFSiteForm?id="+component.get("v.recordId");
		var hiddenInput = document.createElement("input");
        hiddenInput.setAttribute("value", copyText);
        document.body.appendChild(hiddenInput);
        hiddenInput.select();
        document.execCommand("copy");
        document.body.removeChild(hiddenInput); 
        
        var action = component.get("c.updateRecord");
         action.setParams({"recordId": component.get("v.recordId")});
         action.setCallback(this, function(response) {
             var state = response.getState();
             if(state == "SUCCESS"){
        			$A.get("e.force:closeQuickAction").fire();
             }
             else if (state === "ERROR"){
                 var errors = action2.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         console.log( errors[0].message);
                     }
                 }
             }    
                 else {
                     console.log('There was a problem : '+response.getError());
                 }
        });
        $A.enqueueAction(action);
    },
    
})