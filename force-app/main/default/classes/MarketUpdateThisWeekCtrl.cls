public class MarketUpdateThisWeekCtrl {
    
    public Date dt = System.today().toStartofWeek();
    Date dtend = dt.addDays(7);
    
    public List<Market_Information__c> lstMarket_Information {get;set;}
    
    public MarketUpdateThisWeekCtrl() {
        lstMarket_Information = [select id,CanadaOrOtherSupply__c,Commentry__c,Dairy_Product_Type__c,EUSupply__c,FutureCommentry__c,OceaniaSupply__c,Position__c,Pricing__c,Send_Date__c,Strategy__c,name from Market_Information__c where Send_Date__c >=:dt AND Send_Date__c <=: dtend ];
    }
}