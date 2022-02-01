@IsTest(SeeAlldata=true)
public Class OpportunityExtTest{

    public static TestMethod void Test1(){
    try{
        Opportunity__c opp = [select id from Opportunity__c where Inco_Terms__c ='CIF' LIMIT 1];
        OpportunityExt obj = new OpportunityExt (new ApexPages.StandardController(Opp));
        
    }catch(Exception ex){}
        
        
    }
}