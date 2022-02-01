@IsTest
public class BatchRunTest{

    public static TestMethod void test1(){
        Market_Information__c obj = new Market_Information__c();
        obj.Dairy_Product_Type__c = 'BMP';
        obj.ownerID = UserInfo.getUserId();
        insert obj;
        
        MarketEmailServiceFields__c o = new MarketEmailServiceFields__c ();
        o.name = 'Pricing__c';
        o.label__C = 'Pricing';
        insert o;
        
        BatchRun obj1 = new BatchRun();
        obj1.redirect();
    }
}