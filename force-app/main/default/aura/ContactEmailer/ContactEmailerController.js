({
    startComp : function(component, event, helper) {
        var isNewList = component.get("v.isNewList");
        if(isNewList == "true"){
            component.set("v.isSavedList", false);
            var handleSubmit = component.get('c.handleSubmit');
            $A.enqueueAction(handleSubmit);
        }
        if(isNewList == "false"){
            component.set("v.isSavedList", true);
            var findEmailList = component.get('c.findEmailList');
            $A.enqueueAction(findEmailList);
        }
        
    },
    findEmailList : function(component, event, helper) {
        var action = component.get("c.getEmailContactList");
         action.setCallback(this, function(response) {
            console.log("="+response.getState());
            if(response.getState() == 'SUCCESS' ){
                component.set("v.emailContactList", response.getReturnValue());
            }
            else {
                alert('Something went wrong. Please try again later.');
            }
        });
        $A.enqueueAction(action);
	},
    openEmailer : function(component, event, helper) {
       var listId = component.get("v.sSavedListId");
       var action = component.get("c.getSelectedEmailList");
       action.setParams({
            sRecId: listId
        });
        console.log("testss");
        action.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS' ){
                var wrap = response.getReturnValue();
                console.log(wrap);
                component.set("v.contactIds", wrap.sContacts);
                component.set("v.listName", wrap.sName);
                component.set("v.sTemplateId", wrap.sTemplateId);
                component.set("v.sSubject", wrap.sEmailSubject);
                component.set("v.sBody", wrap.sEmailBody);
                component.set("v.contactIds", wrap.sContacts);
                component.set("v.contactList", wrap.lstContacts);
                component.find("selectAll").set("v.value", true);
                var selectAll = component.get('c.handleSelectAllContact');
        		$A.enqueueAction(selectAll);
            }
            else {
                alert('Something went wrong. Please try again later.');
            }
        });
        $A.enqueueAction(action);
       
	},
	handleSubmit : function(component, event, helper) {
        var contactIds = component.get("v.contactIds");
        var isNewList = component.get("v.isNewList");
        var action = component.get("c.getContacts");
        action.setParams({
            sContactIds: contactIds
        });
        action.setCallback(this, function(response) {
            console.log("="+response.getState());
            if(response.getState() == 'SUCCESS' ){
                component.set("v.contactList", response.getReturnValue());
                component.find("selectAll").set("v.value", true);
                var selectAll = component.get('c.handleSelectAllContact');
        		$A.enqueueAction(selectAll);
            }
            else {
                alert('Something went wrong. Please try again later.');
            }
        });
        $A.enqueueAction(action);
	},
    
    //Select all contacts
    handleSelectAllContact: function(component, event, helper) {
        var getID = component.get("v.contactList");
        var checkvalue = component.find("selectAll").get("v.value");        
        var checkContact = component.find("checkContact"); 
        
        if(checkvalue == true){
            if(!Array.isArray(checkContact)){
                checkContact.set("v.value",true);
            }
            else{
                for(var i=0; i<checkContact.length; i++){
                  checkContact[i].set("v.value",true);
                }
            }
            
        }
        else{
            if(!Array.isArray(checkContact)){
                checkContact.set("v.value",false);
            }
            else{
                for(var i=0; i<checkContact.length; i++){
                  checkContact[i].set("v.value",false);
                }
            }
        }
    },
     
    //Process the selected contacts
    handleSelectedContacts: function(component, event, helper) {
        var sSubject = component.get("v.sSubject");
        var sBody = component.get("v.sBody");
        var listName = component.get("v.listName");
        if(listName == null){
          alert("Please provide list name.");
          return false;
        }
        if(sSubject == null){
          alert("Please provide email subject.");
          return false;
        }
        if(sBody == null){
          alert("Please provide email body.");
          return false;
        }
        
        var selectedContacts = [];
        var checkvalue = component.find("checkContact");
         
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedContacts.push(checkvalue.get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedContacts.push(checkvalue[i].get("v.text"));
                }
            }
        }
        var isNewList = component.get("v.isNewList");
        var emailTemplateId = component.get("v.sTemplateId");
        var sSavedListId = component.get("v.sSavedListId");
        console.log('selectedContacts-' + selectedContacts);
        var action = component.get("c.createEmail");
        action.setParams({
            sEmailSubject: sSubject,
            sEmailBody: sBody,
            isNew: isNewList,
            sListName: listName,
            lstContacts: selectedContacts,
            sEmailTemplateId: emailTemplateId,
            sSavedEmailListId: sSavedListId
        });
        action.setCallback(this, function(response) {
            console.log("list created="+response.getReturnValue());
            if(response.getState() == 'SUCCESS' ){
                component.set("v.sSavedListId", response.getReturnValue());
                
                var actionTemp = component.get("c.createTempEmailTemplate");
                actionTemp.setParams({
                    sEmailSubject: sSubject,
                    sEmailBody: sBody,
                });
                    actionTemp.setCallback(this, function(responses) {
                           console.log("email template created="+responses.getReturnValue());
                            if(responses.getState() == 'SUCCESS' ){
                                component.set("v.sNewTemplateId", responses.getReturnValue());
                                component.set("v.selectedContactList", selectedContacts);
                                component.set("v.base64", null);
                                component.set("v.contentType", null);
                                component.set("v.isNewList", false);
                                console.log("ready to start file reading");
                                var fileInput = component.get("v.FileList");
                                console.log("file reading for="+fileInput);
                                if(fileInput != null){
                                    var file = fileInput[0];
                                    var fr = new FileReader();
                                    var self = this;
                                    fr.onload = function() {
                                        component.set("v.Spinner", true); 
                                        var fileContents = fr.result;
                                        var base64Mark = 'base64,';
                                        var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                                
                                        fileContents = fileContents.substring(dataStart);
                                        component.set("v.base64", fileContents);
                                        component.set("v.contentType", file.type);
                                        var sendEmailToSelectedContacts = component.get('c.sendEmailToSelectedContacts');
                                        $A.enqueueAction(sendEmailToSelectedContacts);
                                        component.set("v.Spinner", false); 
                                    };
                                    fr.readAsDataURL(file);
                                }
                                else{
                                    var sendEmailToSelectedContacts = component.get('c.sendEmailToSelectedContacts');
                                    $A.enqueueAction(sendEmailToSelectedContacts);
                                }
                            }
                            else {
                                alert('Something went wrong. Please try again later.');
                            }
                        });
                        $A.enqueueAction(actionTemp);
            }
            else {
                alert('Something went wrong. Please try again later.');
            }
        });
        $A.enqueueAction(action);
    },
    
    
    sendEmailToSelectedContacts: function(component, event, helper){
        var action = component.get("c.sendEmail");
                 action.setParams({
                    lstContacts: component.get("v.selectedContactList"),
                     sTemplateId: component.get("v.sNewTemplateId"),
                     sFileName: component.get("v.fileName"),
                     sBase64Data: component.get("v.base64"),
                     sContentType: component.get("v.contentType"),
                     sOriginalTemplateId: component.get("v.sTemplateId")
                });
                action.setCallback(this, function(responses) {
                   console.log("email sent="+responses.getReturnValue());
                    if(responses.getState() == 'SUCCESS' ){
                        component.set("v.isPopUp", false);
                        component.set("v.fileName", "No File Selected..");
                        component.set("v.FileList", null);
                        console.log("message from class="+responses.getReturnValue());
                        alert(responses.getReturnValue());
                    }
                    else {
                        alert('Something went wrong. Please try again later.');
                    }
                });
                $A.enqueueAction(action);
                console.log("test");
    },
    
    searchEmailTemplates : function(component, event, helper) {
       var checkvalue = component.find("checkContact");
       var isContactSelected = false;
       if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                isContactSelected = true;
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    isContactSelected = true;
                    break;
                }
            }
        }
        if(!isContactSelected){
            alert("You have not selected any Contact. Please select contacts before proceeding.");
            return false;
        }
       var action = component.get("c.getEmailTemplates");
        action.setCallback(this, function(response) {
           console.log("="+response.getState());
            if(response.getState() == 'SUCCESS' ){
                component.set("v.templateList", response.getReturnValue());
                component.set("v.isPopUp", true);
            }
            else {
                alert('Something went wrong. Please try again later.');
            }
        });
        $A.enqueueAction(action);
	},
    
    closePopUp: function(component, event, helper) {
    component.set("v.isPopUp", false);
  },
    
    readSelectedTemplate : function(component, event, helper) {
       var action = component.get("c.getSelectedEmailTemplate");
        var sTemplateId = component.get("v.sTemplateId");
		 action.setParams({
            sId: sTemplateId
        });
        action.setCallback(this, function(response) {
           console.log("="+response.getState());
            if(response.getState() == 'SUCCESS' ){
                var emailTemplate = response.getReturnValue();
                component.set("v.sSubject", emailTemplate.Subject);
                if(emailTemplate.HtmlValue == null){
                   component.set("v.sBody", emailTemplate.Body);
                }
                else{
                    component.set("v.sBody", emailTemplate.HtmlValue);
                }
            }
            else {
                alert('Something went wrong. Please try again later.');
            }
        });
        $A.enqueueAction(action);
	},
    
    sendEmailToContacts : function(component, event, helper) {
        
       
	},
    
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
   },
    
    hideSpinner : function(component,event,helper){
       component.set("v.Spinner", false);
    },
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    searchContacts: function(component, event, helper) {
        var listId = component.get("v.sSavedListId");
        var searchName = component.get("v.searchName");
        console.log(listId);
        if(listId == null || listId == "--Select--"){
            alert("Please select a List first.");
            return;
        }
        if(searchName == null || searchName == "" || searchName.length < 3){
            alert("Search text needs to have 3 or more letters");
            return;
        }
        var action = component.get("c.getSearchContact");
        action.setParams({
            sRecId: listId,
            sSearch: searchName
        });
        action.setCallback(this, function(response) {
           console.log("="+response.getState());
            if(response.getState() == 'SUCCESS' ){
              var res = response.getReturnValue();
              component.set("v.newContactList", res);
                if(res != null && res.length > 0){
                    component.set("v.isSearchResult", true);
                }
                else{
                    component.set("v.isSearchResult", false);
                }
            }
            else {
                alert('Something went wrong. Please try again later.');
            }
        });
        $A.enqueueAction(action);
    },
    
    handleSelectAllNewContact: function(component, event, helper) {
        var getID = component.get("v.newContactList");
        var checkvalue = component.find("newSelectAll").get("v.value");        
        var checkContact = component.find("checkNewContact"); 
        if(checkvalue == true){
            if(!Array.isArray(checkContact)){
                checkContact.set("v.value",true);
            }
            else{
                for(var i=0; i<checkContact.length; i++){
                  checkContact[i].set("v.value",true);
                }
            }
            
        }
        else{
            if(!Array.isArray(checkContact)){
                checkContact.set("v.value",false);
            }
            else{
                for(var i=0; i<checkContact.length; i++){
                  checkContact[i].set("v.value",false);
                }
            }
        }
    },
    
    addAllContacts: function(component, event, helper) {
        var checkvalue = component.find("newSelectAll").get("v.value");        
        var checkContact = component.find("checkNewContact"); 
            if(!Array.isArray(checkContact)){
                checkContact.set("v.value",true);
            }
            else{
                for(var i=0; i<checkContact.length; i++){
                  checkContact[i].set("v.value",true); console.log(checkContact[i].get("v.value"));
                }
            }
        var addSelectedContacts = component.get('c.addSelectedContacts');
        $A.enqueueAction(addSelectedContacts);
    },
    
    addSelectedContacts: function(component, event, helper) {
        var listId = component.get("v.sSavedListId");
        var searchName = component.get("v.searchName");
        var checkvalue = component.find("newSelectAll").get("v.value");        
        var checkContact = component.find("checkNewContact"); 
        var selectedNewContacts = [];        
        if(!Array.isArray(checkContact)){
            if(checkContact.get("v.value") == true){
              selectedNewContacts.push(checkContact.get("v.text"));
            }
        }
        else{
            for(var i=0; i<checkContact.length; i++){
                if(checkContact[i].get("v.value") == true){
                  selectedNewContacts.push(checkContact[i].get("v.text"));
                }
            }
        }
        console.log("selected="+selectedNewContacts);
        if(selectedNewContacts.length == 0){
            alert("Nothing selected.");
            return;
        }
        var action = component.get("c.addContacts");
        action.setParams({
            lstContacts: selectedNewContacts,
            sListId: listId,
            sSearch: searchName
        });
        action.setCallback(this, function(response) {
           console.log("test="+response.getState());
            if(response.getState() == 'SUCCESS' ){
              var wrap = response.getReturnValue();
              component.set("v.contactIds", wrap.sContacts);
              component.set("v.contactList", wrap.lstContacts);
              component.set("v.newContactList", wrap.lstSearchedContacts);
                console.log("test2="+wrap);
                if(wrap.lstSearchedContacts != null && wrap.lstSearchedContacts.length > 0){
                    component.set("v.isSearchResult", true);
                }
                else{
                    component.set("v.isSearchResult", false);
                }
            }
            else {
                alert('Something went wrong. Please try again later.');
            }
        });
        $A.enqueueAction(action);
    },
    deleteRecord: function(component, event, helper) {
        if(confirm("Are you sure?")){
            component.set("v.Spinner", true); 
            helper.deleteContact(component, event);
            component.set("v.Spinner", false); 
        }
    },
    goBack: function(component, event, helper) {
        window.history.go(-1);
    },
    deleteListRecord: function(component, event, helper) {
        var listId = component.get("v.sSavedListId");
        if(listId == '--Select--'){
            alert("No Email List Selected. Please select an List from the Saved Email List dropdown.");
            return;
        }
        if(confirm("Are you sure?")){
            component.set("v.Spinner", true); 
            helper.deleteContactList(component, event);
            component.set("v.Spinner", false); 
        }
    }
})