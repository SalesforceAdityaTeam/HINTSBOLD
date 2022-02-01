@isTest
private class ReminderEmailForMarketInfoBatchTest {

	private static testMethod void test() {
	    
        Market_Information__c obj = new Market_Information__c();
        obj.Dairy_Product_Type__c = 'BMP';
        obj.ownerID = UserInfo.getUserId();
        insert obj;
        
        MarketEmailServiceFields__c o = new MarketEmailServiceFields__c ();
        o.name = 'Pricing__c';
        o.label__C = 'Pricing';
        insert o;
        
        Test.startTest();
            new ReminderEmailForMarketInfoBatch().execute(null);
        Test.stopTest();
}

    private static testMethod void test2() {
        
        Market_Information__c obj = new Market_Information__c();
        obj.Dairy_Product_Type__c = 'BMP';
        obj.ownerID = UserInfo.getUserId();
        insert obj;
        
        MarketEmailServiceFields__c o = new MarketEmailServiceFields__c ();
        o.name = 'Pricing__c';
        o.label__C = 'Pricing';
        insert o;
        
        String table = '<table width="100%" border="2"><tr><th>Field</td><th>Value</th></tr>';
        table = table + '<tr><td>'+'Pricing__c'+'</td><td>'+'Pricing__c'+'</td></tr>';
         table = table + '</table>';
         table = table + '<br/> Record Id:- https://na132.salesforce.com/'+obj.id ;
         
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
        email.subject = 'Test Contact Email';
        email.plainTextBody  = 'Test Contact Email';
        email.htmlBody  = table;
        MarketInfoRecordUpdate oo = new MarketInfoRecordUpdate();
        oo.handleInboundEmail(email, env );
    }

}