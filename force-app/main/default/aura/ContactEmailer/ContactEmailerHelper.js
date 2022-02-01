({
	deleteContact : function(component, event) {
        var listId = component.get("v.sSavedListId");
        var conId = event.target.id;
		var action = component.get("c.deleteContact");
        console.log("delete helper");
        action.setParams({
            sRecId: conId,
            sListId: listId
        });
        action.setCallback(this, function(response) {
           console.log("test="+response.getState());
            if(response.getState() == 'SUCCESS' ){
              var wrap = response.getReturnValue();
              component.set("v.contactIds", wrap.sContacts);
              component.set("v.contactList", wrap.lstContacts);
            }
            else {
                alert('Something went wrong. Please try again later.');
            }
        });
        $A.enqueueAction(action);
	},
    deleteContactList : function(component, event) {
        var listId = component.get("v.sSavedListId");
    	var action = component.get("c.deleteList");
        console.log("delete helper");
        action.setParams({
            sRecId: listId
        });
        action.setCallback(this, function(response) {
           console.log("test="+response.getState());
            if(response.getState() == 'SUCCESS' ){
              component.set("v.sSavedListId", "--Select--");
              component.set("v.emailContactList", response.getReturnValue());
              component.set("v.contactIds", null);
              component.set("v.contactList", null);
              component.set("v.newContactList", null);
            }
            else {
                alert('Something went wrong. Please try again later.');
            }
        });
        $A.enqueueAction(action);
    }
})