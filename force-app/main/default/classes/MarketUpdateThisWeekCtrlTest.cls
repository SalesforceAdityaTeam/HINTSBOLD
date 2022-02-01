@isTest
public Class MarketUpdateThisWeekCtrlTest {
    public static testMethod void test1() {
        Market_Information__c o = new Market_Information__c();
        o.Dairy_Product_Type__c = 'Butter';
        insert o;
        new MarketUpdateThisWeekCtrl();
    }
}