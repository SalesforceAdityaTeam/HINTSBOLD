@IsTest
public class OfferEmailSendCtrlTest{
  public static testMethod void testOffer(){
    Account oAcc = new Account(Name = 'test');
    insert oAcc;
    Contact oCon = new Contact(LastName = 'test', Email = 'test@test.com', AccountId = oAcc.Id);
    insert oCon;
    Offer__c oOffer = new Offer__c(Account__c = oAcc.Id, Contact__c = oCon.Id, Offer_Introduction__c = 'test', Offer_Close__c = 'test');
    insert oOffer;
    OfferLineItem__c oItem = new OfferLineItem__c(Offer__c = oOffer.Id, Brand_Origin__c = 'test', Destination__c = 'test', For_Offer__c = true, INCO__c = 'test',
                             Packaging_Pallets__c = 'test', Period__c = 'test', Price__c = 'test', Product__c = 'test', Remark__c = 'test', Sequence__c = 'test',
                             Spec_ID__c = 'test', Volume__c = 'test');
    insert oItem;
    ApexPages.currentPage().getParameters().put('Id', oOffer.Id);
    ApexPages.StandardController oStdCtrl = new ApexPages.StandardController(oOffer);
    OfferEmailSendCtrl oCtrl = new OfferEmailSendCtrl(oStdCtrl);
    oCtrl.oFile = new Attachment(Name = 'test.pdf', Body = Blob.valueOf('My Test'));
    oCtrl.addAttachment();
    oCtrl.prepareEmailAttachment();
    oCtrl.sContentDocumentId = oCtrl.lstWrapperFiles[0].sId;
    oCtrl.removeFile();
    oCtrl.sendEmail();
  }
}