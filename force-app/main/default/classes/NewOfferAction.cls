public class NewOfferAction {
	
    @AuraEnabled
    public Static String saveLineItem(String varId){
        Id recordId = varId;
        Offer__c o = new Offer__c(Name = 'New Offer');
        if( String.valueOf(recordId.getsobjecttype()) == 'Account'){
            o.Account__c = recordId;
        }else {
            Contact c = [select id,AccountId from Contact where Id =: recordId LIMIT 1];
            o.Account__c = c.AccountId;
            o.Contact__c = recordId;
        }
        INSERT o;
        return o.Id;
    }
}