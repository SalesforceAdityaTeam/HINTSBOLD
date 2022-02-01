({
	handleOnSuccess: function (component, event, helper){
        var params = event.getParams();
        var recordId = params.response.id;
        window.open("https://hoogwegtus.lightning.force.com/lightning/r/BPF__c/"+recordId+"/view","_self");
    },
    handleOnError : function(component, event, helper){
        var error = event.getParams();
        console.log(">>>>>>>>>>>>>"+event.getParam("message"));
        console.log(">>>>>>>>>>>>>"+event.getParam("detail"));
        console.log(">>>>>>>>>>>>>"+event.getParam("output").fieldErrors);
        console.log(">>>>>>>>>>>>>"+event.getParam("errorCode"));
        console.log(">>>>>>>>>>>>>"+event.getParam("output"));
        console.log(">>>>>>>>>>>>>"+JSON.stringify(event.getParam("error")));    
    },
    doInit:  function (component, event, helper){
    	var oppid  = component.get("v.recordId");
        component.find("AccountName__c").set("v.value", oppid);
	}, 
    cancel:  function (component, event, helper){
     var recordId = component.get("v.recordId");
      window.open("https://hoogwegtus.lightning.force.com/lightning/r/Account/"+recordId+"/view","_self");
  },
})