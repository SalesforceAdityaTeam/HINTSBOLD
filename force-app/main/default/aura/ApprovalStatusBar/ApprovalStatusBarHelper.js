({
	loadData : function(component) {
		var action = component.get("c.loadStatus");
    var sRecordId = component.get("v.recordId");
    action.setParams({
      "sRecId": sRecordId
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if(state == "SUCCESS"){
        var result = response.getReturnValue();
          var arrayMapKeys = [];
                for(var key in result){
                    arrayMapKeys.push({key:key , value: result[key]});
                }
        component.set("v.approvalCombination", arrayMapKeys);
      }
      else{
        console.error(response.getError()[0].message); 
      }
    });
    $A.enqueueAction(action);
	}
})