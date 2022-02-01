@IsTest(SeeAllData=true)
Public Class SampleTransactionCtrTest{

    public static testmethod void test1(){
        
        SampleTransactionCtrl.fetchLookUpValues('Th',new List<User>{new User(Id = UserInfo.getUserId())});
        Sample_Transaction__c o = [select id from Sample_Transaction__c LIMIT 1];
        SampleTransactionCtrl.insertRelatedListRecords(o.Id, new List<User>{new User(Id = UserInfo.getUserId())});
    
    }
}