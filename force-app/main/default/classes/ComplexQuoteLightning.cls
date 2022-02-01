public class ComplexQuoteLightning {
	@AuraEnabled
    public static Opportunity__c getOpportunityObject(Id oppid) {
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Opportunity__c').getDescribe().fields.getMap();
 
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){
            if(commaSepratedFields == null || commaSepratedFields == ''){
                commaSepratedFields = fieldName;
            }else{
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
 
        String query = 'select ' + commaSepratedFields + ',Account__r.BillingCountry  from Opportunity__c where id =:oppid ';
 		Opportunity__c op = new Opportunity__c();
        for(Opportunity__c o : Database.query(query)){
            op = o;break;
        }
        return op;
    }
}