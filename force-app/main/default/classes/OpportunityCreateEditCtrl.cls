public class OpportunityCreateEditCtrl {
	
	@AuraEnabled
    public static Opportunity__c fetchLookUpValues(String varId) { 
        List<String> lstfields = new List<String>();
        for(Schema.SObjectField sfield  : Schema.getGlobalDescribe().get('Opportunity__c').getDescribe().fields.getMap().values() ){
            schema.describefieldresult dfield = sfield.getDescribe();
            lstfields.add(dfield.getName());
        }
        String query = 'Select ' + String.join(lstfields, ',') + ' from Opportunity__c where id=: varId ';
        List<Opportunity__c> lstopp = Database.query(query) ;
    	return lstopp.get(0);
    } 
    
    @AuraEnabled
    public static Decimal generateRate(String destId) { 
        String varLocation = '';
        Decimal rate = 0.0;
        /*for(Location__c l : [select id,addrline5__c from Location__c where id =: destId ]){
            varLocation = l.addrline5__c ;
        }*/
        for(Account acc : [select id,billingCountry from Account where id =: destId]){
        	varLocation = acc.billingCountry ;
        }
        
    	for(Credit_Insurance_Rate__c o : [select id,name,Rate__c from Credit_Insurance_Rate__c where name = :varLocation ]){
           rate = o.Rate__c ;
        }
        return rate;
    } 
}