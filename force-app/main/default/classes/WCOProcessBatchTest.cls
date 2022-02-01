@IsTest(SeeAllData=true)
public Class WCOProcessBatchTest{

    public static testMethod void test1(){
        BPF__c o = [select id from BPF__c LIMIT 1 ];
        o.Stage__c = 'BPF Customer Input Completed';
        update o;
        
        UPSERT new WCOProcessBatch__c(name = o.Id) NAME;
        
        test.startTest();
            new WCOProcessBatch().execute(null);
        Test.stopTest();
    }
}