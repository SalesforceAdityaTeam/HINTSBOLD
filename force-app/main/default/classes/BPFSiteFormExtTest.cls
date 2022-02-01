@IsTest
Public Class BPFSiteFormExtTest{

    public static TestMethod void Test(){
        INSERT new Contact(LastName = 'asdas');
        BPF__C o = new BPF__C(Stage__c = '',Ultimate_Beneficial_Owner_UBO_1__c = 'A A',Ultimate_Beneficial_Owner_UBO_2__c = 'D D',Ultimate_Beneficial_Owner_UBO_3__c = 'C C',Ultimate_Beneficial_Owner_UBO_4__c = 'T');
        INSERT o;
        
        BPFSiteFormExt obj1 = new BPFSiteFormExt();
        BPFSiteFormExt obj = new BPFSiteFormExt(new ApexPages.StandardController(o));
        obj.addMoreContact();
        obj.lstContact.add(new Contact(FirstName='asdasdasd', Email = 'test@test.com'));
        obj.lstTradeReferences.add(new TradeReferences__c(Name='asDASD', BPF__c = o.Id));
        obj.showPopup();
        obj.displayPopup = true;
        obj.message = 'Thank you for completing your Business Partner Form';
        obj.objBPF.Stage__c = 'BPF Customer Input Completed';
        obj.closePopup();
        BPFSiteFormExt.UploadImage(Blob.valueOf('asdasda.txt'), o.Id);
        
        obj.cancled();
        
       
        
        
    }
}