@isTest(SeeAllData=true)
Public Class ScreeningCaseTriggerTest{

    public static TestMethod void test1(){
            
            BPF__c b = [select id,AccountName__c from BPF__C where AccountName__c != null LIMIT 1];
            b.stage__c = 'BPF Customer Input Completed';
            update b;
            
            tr_wc1__KYC_Screening_Case__c o = new tr_wc1__KYC_Screening_Case__c();
            o.tr_wc1__Account__c = b.AccountName__c;
            o.tr_wc1__Thomson_Reuters_Group_Name__c = 'Hoogwegt US Inc - API-CRS';
            o.tr_wc1__Entity_Type__c = 'Organisation';
            o.RecordTypeId = Schema.SObjectType.tr_wc1__KYC_Screening_Case__c.getRecordTypeInfosByName().get('Unarchived Screening Case RT').getRecordTypeId();
            INSERT o;
            
    }
}