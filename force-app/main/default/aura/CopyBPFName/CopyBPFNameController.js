({
	
    doInit:  function (component, event, helper){
       var action = component.get("c.getName");
        action.setParams({
            'recid': component.get("v.recordId")
        });
    	action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
               var copyText = response.getReturnValue();
                var hiddenInput = document.createElement("input");
                hiddenInput.setAttribute("value", copyText);
                document.body.appendChild(hiddenInput);
                hiddenInput.select();
                document.execCommand("copy");
                document.body.removeChild(hiddenInput); 
        		$A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action); 
      //  $A.get("e.force:closeQuickAction").fire();
        
    }
})