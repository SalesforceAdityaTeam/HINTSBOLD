public with sharing class ContactEmailercl{
  public String sIds{get;set;}
  
  public ContactEmailercl(ApexPages.StandardSetController controller) {
    sIds = '';
    for(SObject oObj : controller.getSelected()){
      sIds += oObj.Id + ',';
    }
    sIds = sIds.removeEnd(',');
    System.debug(sIds);
  }

  @AuraEnabled
  public static List<Contact> getContacts(String sContactIds){
    List<String> lstIds = new List<String>();
    if(!String.isBlank(sContactIds)){
      lstIds = sContactIds.split(',');
    }
    System.debug(sContactIds);
    System.debug(lstIds);
    return [Select Name, Account.Name, Phone, Email FROM Contact WHERE Id in: lstIds];
  }
  
  @AuraEnabled
  public static List<EmailTemplate> getEmailTemplates(){
    return [SELECT Name, Subject FROM EmailTemplate];
  }
  
  @AuraEnabled
  public static EmailTemplate getSelectedEmailTemplate(String sId){
    System.debug(sId);
    if(sId != '--Select--'){
      return [SELECT Name, Subject, HtmlValue, Body FROM EmailTemplate where id=: sId];
    }
    else{
      return new EmailTemplate();
    }
  }
  
  @AuraEnabled
  public static String createEmail(String sEmailSubject, String sEmailBody, String isNew, String sListName, List<String> lstContacts, String sEmailTemplateId, String sSavedEmailListId){
    return createList(sEmailSubject, sEmailBody, isNew, sListName, lstContacts, sEmailTemplateId, sSavedEmailListId);
  }
  
  @AuraEnabled
  public static String createTempEmailTemplate(String sEmailSubject, String sEmailBody){
    String sEtName = UserInfo.getName() + System.now();
    sEtName = sEtName.remove(' ').remove('-').remove(':');
    EmailTemplate oldEt = [SELECT FolderId FROM EmailTemplate LIMIT 1];
    EmailTemplate oEt = new EmailTemplate(Name = sEtName, FolderId = oldEt.FolderId, DeveloperName = sEtName, IsActive = true);
    oEt.TemplateType= 'Custom';
    oEt.Subject = handleLightningTemplate(sEmailSubject);
    oEt.HtmlValue = handleLightningTemplate(sEmailBody);
    insert oEt;
    return oEt.Id;
  }
  
  public static String handleLightningTemplate(String sEmailContent){
    if(sEmailContent != null && sEmailContent.contains('{{{')){
      sEmailContent = sEmailContent.replace('{{{Recipient', '{!Contact');
      sEmailContent = sEmailContent.replace('{{{Contact', '{!Contact');
      sEmailContent = sEmailContent.replace('{{{Sender', '{!$User');
      sEmailContent = sEmailContent.replace('}}}', '}');
    }
    return sEmailContent;
  }
  
  public static String createList(String sEmailSubject, String sEmailBody, String isNew, String sListName, List<String> lstContacts, String sEmailTemplateId, String sSavedEmailListId){
    if(isNew == 'true'){
      List<Contact_With_Email__c> lstCWE = new List<Contact_With_Email__c>();
      Contact_Email_List__c objCEList = new Contact_Email_List__c(Name = sListName);
      objCEList.Email_Template_Id__c = sEmailTemplateId;
      objCEList.Email_Subject__c = sEmailSubject;
      objCEList.Email_Body__c = sEmailBody;
      insert objCEList;
      for(String sId : lstContacts){
        lstCWE.add(new Contact_With_Email__c(Contact__c = sId, Contact_Email_List__c = objCEList.Id));
      }
      insert lstCWE;
      return objCEList.Id;
    }
    if(isNew == 'false' && !String.isBlank(sSavedEmailListId)){
      Contact_Email_List__c objCEList = new Contact_Email_List__c(Name = sListName, Id = sSavedEmailListId);
      objCEList.Email_Template_Id__c = sEmailTemplateId;
      objCEList.Email_Subject__c = sEmailSubject;
      objCEList.Email_Body__c = sEmailBody;
      update objCEList;
      return objCEList.Id;
    }
    return null;
  }
  
  @AuraEnabled
  public static String sendEmail(List<String> lstContacts, String sTemplateId, String sFileName, String sBase64Data, String sContentType, String sOriginalTemplateId){
    if(String.isBlank(sContentType)){
      sContentType = 'text/plain';
    }
    List<Messaging.SingleEmailMessage> lstEmail = new List<Messaging.SingleEmailMessage>();
    List<Messaging.EmailFileAttachment> lstAtt = new List<Messaging.EmailFileAttachment>();
    List<Id> lstIds = new List<Id>();
    if(!String.isBlank(sOriginalTemplateId) && sOriginalTemplateId != '--Select--'){
      List<ContentDocumentLink> lstContentLink = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: sOriginalTemplateId];
      for(ContentDocumentLink oLink : lstContentLink){
        lstIds.add(oLink.ContentDocumentId);
      }
      for(Attachment oAttachment : [SELECT Id, Body, Name, ContentType FROM Attachment WHERE parentId =: sOriginalTemplateId]){
        Messaging.EmailFileAttachment oAtt = new Messaging.EmailFileAttachment();
        oAtt.setFileName(oAttachment.Name);
        oAtt.setBody(oAttachment.Body);
        oAtt.setContentType(oAttachment.ContentType);
        lstAtt.add(oAtt);
      }
    }
    if(!lstIds.isEmpty()){
      for(ContentVersion oVersion : [SELECT Id, Title, FileExtension, VersionData FROM ContentVersion where ContentDocumentId in: lstIds AND IsLatest = true]){
        Messaging.EmailFileAttachment oAtt = new Messaging.EmailFileAttachment();
        oAtt.setFileName(oVersion.Title + '.' + oVersion.FileExtension);
        oAtt.setBody(oVersion.VersionData);
        lstAtt.add(oAtt);
      }
    }
    if(!String.isBlank(sBase64Data)){
      Messaging.EmailFileAttachment oAtt = new Messaging.EmailFileAttachment();
      oAtt.setFileName(sFileName);
      oAtt.setBody(EncodingUtil.base64Decode(sBase64Data));
      oAtt.setContentType(sContentType);
      lstAtt.add(oAtt);
    }
    for(String sId : lstContacts){
      Messaging.SingleEmailMessage oMessage = new Messaging.SingleEmailMessage();
      oMessage.setTargetObjectId(sId);
      oMessage.setTemplateId(sTemplateId);
      oMessage.setSaveAsActivity(true);
      if(lstAtt != null){
        oMessage.setFileAttachments(lstAtt);
      }
      lstEmail.add(oMessage);
    }
    
    Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmail);
    deleteTemplate(sTemplateId);
    if (results[0].success) {
      return 'The email was sent successfully.';
    }
    else {
      return 'The email failed to send: ' + results[0].errors[0].message;
    }
  }
  
  @future
  public static void deleteTemplate(String sTemplateId){
    delete new EmailTemplate(Id = sTemplateId);
  }
  
  @AuraEnabled
  public static List<Contact_Email_List__c> getEmailContactList(){
    return [SELECT Id, Name, Email_Body__c, Email_Subject__c, Email_Template_Id__c FROM Contact_Email_List__c];
  }
  
  @AuraEnabled
  public static ContactEmailWrapper getSelectedEmailList(String sRecId){
    return new ContactEmailWrapper([SELECT Id, Name, Email_Body__c, Email_Subject__c, Email_Template_Id__c, (SELECT Contact__c FROM Contact_With_Email__r) FROM Contact_Email_List__c WHERE Id =: sRecId]);
  }
  
  @AuraEnabled
  public static List<Contact> getSearchContact(String sRecId, String sSearch){
    List<Contact_With_Email__c> lstJunct = [SELECT Contact__c FROM Contact_With_Email__c WHERE Contact_Email_List__c =: sRecId];
    List<Id> lstIds = new List<Id>();
    String sSearchLike = '%'+ sSearch +'%';
    for(Contact_With_Email__c oEmail : lstJunct){
      lstIds.add(oEmail.Contact__c);
    }
    System.debug(sRecId);
    return [Select Name, Account.Name, Phone, Email FROM Contact WHERE (Name LIKE: sSearchLike OR Email =: sSearch) AND Id NOT in: lstIds];
  }
  
  @AuraEnabled
  public static ContactEmailWrapper addContacts(List<String> lstContacts, String sListId, String sSearch){
    System.debug(lstContacts);
    System.debug(sListId);
    System.debug(sSearch);
    if(lstContacts != null && lstContacts.size() > 0 && !String.isBlank(sListId)){
      List<Contact_With_Email__c> lstCWE = new List<Contact_With_Email__c>();
      for(String sId : lstContacts){
        lstCWE.add(new Contact_With_Email__c(Contact__c = sId, Contact_Email_List__c = sListId));
      }
      insert lstCWE;
      ContactEmailWrapper oWrap = new ContactEmailWrapper([SELECT Id, Name, Email_Body__c, Email_Subject__c, Email_Template_Id__c, (SELECT Contact__c FROM Contact_With_Email__r) FROM Contact_Email_List__c WHERE Id =: sListId]);
      String sSearchLike = '%'+ sSearch +'%';
      oWrap.lstSearchedContacts = [Select Name, Account.Name, Phone, Email FROM Contact WHERE (Name LIKE: sSearchLike OR Email =: sSearch) AND Id NOT in: oWrap.lstContacts];
      return oWrap;
    }
    return null;
  }
  
  @AuraEnabled
  public static ContactEmailWrapper deleteContact(String sRecId, String sListId){
    if(!String.isBlank(sRecId)){
      Contact_With_Email__c objCWE = [SELECT ID,Name FROM Contact_With_Email__c WHERE Contact__c =: sRecId and Contact_Email_List__c =: sListId LIMIT 1];
      delete objCWE;
      System.debug(objCWE);
    }
    return new ContactEmailWrapper([SELECT Id, Name, Email_Body__c, Email_Subject__c, Email_Template_Id__c, (SELECT Contact__c FROM Contact_With_Email__r) FROM Contact_Email_List__c WHERE Id =: sListId]);
  }
  
  @AuraEnabled
  public static List<Contact_Email_List__c> deleteList(String sRecId){
    delete new Contact_Email_List__c(Id = sRecId);
    return [SELECT Id, Name, Email_Body__c, Email_Subject__c, Email_Template_Id__c FROM Contact_Email_List__c];
  }
  
  public class ContactEmailWrapper{
    @AuraEnabled public String sName;
    @AuraEnabled public String sEmailSubject;
    @AuraEnabled public String sEmailBody;
    @AuraEnabled public String sContacts;
    @AuraEnabled public String sTemplateId;
    @AuraEnabled public List<Contact> lstContacts;
    @AuraEnabled public List<Contact> lstSearchedContacts;
    public ContactEmailWrapper(Contact_Email_List__c oList){
      sName = oList.Name;
      sEmailSubject = oList.Email_Subject__c;
      sEmailBody = oList.Email_Body__c;
      sTemplateId = oList.Email_Template_Id__c;
      sContacts = '';
      List<Id> lstIds = new List<Id>();
      for(Contact_With_Email__c oCE : oList.Contact_With_Email__r){
        sContacts += oCE.Contact__c + ',';
        lstIds.add(oCE.Contact__c);
      }
      sContacts = sContacts.removeEnd(',');
      lstContacts = [SELECT Name, Account.Name, Phone, Email FROM Contact WHERE Id in: lstIds];
    }
  }
}