@IsTest
Public Class GenerateFileNameTest{

    public static TestMethod void test(){
        BPF__c o = new BPF__c();
        INSERT o;
        Test.startTest();
        GenerateFileName obj = new GenerateFileName(new ApexPages.StandardController (o));
        
        obj.saveasPDF();
        Test.stopTest();
    }

}