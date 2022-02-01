@IsTest
Public Class CopyBPFNameCtrlTest{
    public static TestMethod void test1(){
        BPF__c o = new BPF__C(
        );
        INSERT o;
        
        CopyBPFNameCtrl.getName(o.Id);
        
         CopySiteLinkCtrl.updateRecord(o.Id);
    }

}