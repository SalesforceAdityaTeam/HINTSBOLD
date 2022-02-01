({
    doInit : function(component, event, helper){
      var action=component.get("c.getAccApproval");
        action.setParams({
            "ApprovalId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length == 0) {
                    alert("alert");
                    
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                //component.set("v.accApproval", storeResponse);
                component.set("v.recordId",storeResponse.Id);
            }
            else{
                component.set("v.recordId",'');
            }
 
        });
        $A.enqueueAction(action);
    },
    handleClick: function(c,e,h){
        var action=component.get("c.updateRecord");  
        action.setParams({
            "accAppData" : component.get("v.recordId")
        });
        $A.enqueueAction(action);
    },
	handleCreateLoad : function(component, event, helper) {
		
	}
})