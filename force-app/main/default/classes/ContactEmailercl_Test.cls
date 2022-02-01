@IsTest(SeeAllData = true)
public class ContactEmailercl_Test{
  public static testMethod void testEmailer(){
    ApexPages.StandardSetController sc = new ApexPages.StandardSetController(new List<Contact>{new Contact()});
      ContactEmailercl testEmail = new ContactEmailercl(sc);
      ContactEmailercl.getContacts('' + UserInfo.getUserId());
      ContactEmailercl.getEmailTemplates();
      ContactEmailercl.getSelectedEmailTemplate('--Select--');
      Contact objCon = [Select Id From Contact where Email != null Limit 1];
      ContactEmailercl.createEmail('test subject', 'test body', 'true', 'List name', new List<String>{objCon.Id}, null, null);
      
      ContactEmailercl.createList('sEmailSubject', 'sEmailBody', 'true', 'sListName', new List<String>{objCon.Id}, '', [SELECT Id FROM Contact_With_Email__c limit 1].Id);
      ContactEmailercl.getEmailContactList();
  }
  
  public static testMethod void testEmailer2(){
    Contact objCon = [Select Id From Contact where Email != null Limit 1];
    EmailTemplate objEt = [Select Id FROM EmailTemplate lIMIT 1];
    Blob b = Blob.valueOf('Test Data');
    Attachment oAtt = new Attachment();
    oAtt.ParentId = objEt.Id;
    oAtt.Name = 'Test Attachment for Parent';
    oAtt.Body = b;
    insert oAtt;
    try{
      ContactEmailercl.sendEmail(new List<String>{objCon.Id}, null, null, null, null, objEt.Id);
    }
    catch(Exception e){}
  }
  
  public static testMethod void testEmailer3(){
    Contact objCon = [Select Id From Contact where Email != null Limit 1];
    Contact_Email_List__c objList = new Contact_Email_List__c(Name = 'Test');
    insert objList;
    Contact_With_Email__c objJun = new Contact_With_Email__c(Contact__c = objCon.Id, Contact_Email_List__c = objList.Id);
    insert objjun;
    ContactEmailercl.getSelectedEmailList(objList.Id);
    ContactEmailercl.getSearchContact(objList.Id, 'Test');
    ContactEmailercl.addContacts(new List<String>{objCon.Id}, objList.Id, 'Test');
    ContactEmailercl.deleteContact(objCon.Id, objList.Id);
    ContactEmailercl.deleteList(objList.Id);
  }
  
  public static testMethod void testEmailer4(){
    ContactEmailercl.deleteTemplate(ContactEmailercl.createTempEmailTemplate('test subject', 'test body{{{Recipient.Name}}}'));
  }
}