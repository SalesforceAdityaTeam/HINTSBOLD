/*
    Test Class :- ReminderEmailForMarketInfoBatchTest
*/

global class ReminderEmailForMarketInfoBatch implements Database.Batchable<sObject>,Schedulable {
    
    global void execute(SchedulableContext SC) {
          database.executebatch(new ReminderEmailForMarketInfoBatch(),1);
       }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        List<String> queryString = new List<String>();
        for(MarketEmailServiceFields__c objCS : [select id,name from MarketEmailServiceFields__c]) {
            queryString.add(objcs.name);
        }
        String str = 'Select id,Name, '+ String.join(queryString,',') +',Dairy_Product_Type__c, owner.email,owner.FirstName from Market_Information__c  ';
        return Database.getQueryLocator(str);
    }
    global void execute(Database.BatchableContext bc, List<Market_Information__c> scope) {
        Boolean IsValid = false;
        EmailTemplate etemp = [select id,subject,htmlvalue from emailtemplate where developername = 'Market_Info_Record_Update' LIMIT 1];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Market_Information__c objmi = scope.get(0);
        
        for(MarketEmailServiceFields__c objCS : [select id,name from MarketEmailServiceFields__c]) {
            if(objmi.get(objCS.name) == null) {
                IsValid = true; break;
            }
        }
            
        if(IsValid) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {objmi.owner.email};
            message.subject = replace(etemp.subject,objmi);
            message.HtmlBody = replace(etemp.htmlvalue,objmi);
            message.setOrgWideEmailAddressId(Label.OWAID);
            mails.add(message);
            objmi.Send_Date__c = System.today();
            try {Messaging.sendEmail(mails);update scope;
            }catch(Exception ex){}
        }
    }
    global void finish(Database.BatchableContext bc) {
    }
    
    public string replace(String content,Market_Information__c objMI ) {
        if(content.containsIgnoreCase('{!Market_Information__c.Id}')){
            content = content.replace('{!Market_Information__c.Id}',objMI.Id);
        }
        if(content.containsIgnoreCase('{!Market_Information__c.OwnerFullName}')){
            content = content.replace('{!Market_Information__c.OwnerFullName}',objMI.owner.FirstName != null ? objMI.owner.FirstName : '');
        }
        if(content.containsIgnoreCase('{!Market_Information__c.Name}')){
            content = content.replace('{!Market_Information__c.Name}',objMI.Name);
        }
        if(content.containsIgnoreCase('{!Market_Information__c.Dairy_Product_Type__c}')){
            content = content.replace('{!Market_Information__c.Dairy_Product_Type__c}',objMI.Dairy_Product_Type__c);
        }
        if(content.containsIgnoreCase('{!Market_Information__c.Dairy_Product_Type__c}')){
            content = content.replace('{!Market_Information__c.Dairy_Product_Type__c}',objMI.Dairy_Product_Type__c);
        }
        if(content.containsIgnoreCase('{!table}')){
            String table = '<table width="100%" border="2"><tr><th>Field</td><th>Value</th></tr>';
            for(MarketEmailServiceFields__c objCS : [select id,name,Label__c from MarketEmailServiceFields__c]) {
                if(objMI.get(objcs.name) == null ){
                    table = table + '<tr><td>'+objCS.Label__c+'</td><td></td></tr>';
                } else {
                    table = table + '<tr><td>'+objCS.Label__c+'</td><td>'+objMI.get(objcs.name)+'</td></tr>';
                }
            }
            table = table + '</table>';
            content = content.replace('{!table}',table);
        }
        return content;
    }
}