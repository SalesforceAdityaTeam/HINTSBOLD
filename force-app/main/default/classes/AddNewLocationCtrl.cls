public class AddNewLocationCtrl {
	
    @AuraEnabled
    public static String saveRecords(Location__C LOc,Account parentAccount, Location__c searchLocation  ){
        Account_Location__c objAL = new Account_Location__c();
        objAL.SFAccountCusNum__c = parentAccount.Id;
        objAL.RecordTypeId =  Schema.SObjectType.Account_Location__c.getRecordTypeInfosByName().get('Request').getRecordTypeId();
        if(searchLocation.Id == null ){
            LOc.addrline1__c = parentAccount.Name;
            LOc.Oppdest__c = LOc.addrline4__c;
            LOc.addrline4__c = LOc.addrline4__c + ', ' + LOc.addrpost_code__c ;
            LOc.Name = parentAccount.Name +',' + LOc.Oppdest__c + Loc.addrline5__c;
            loc.RecordTypeId = Schema.SObjectType.Location__c.getRecordTypeInfosByName().get('Request').getRecordTypeId();
            INSERT loc;    
            
            objAL.Location__c = loc.Id;
        } else {
            objAL.Location__c = searchLocation.Id;
        }
        INSERT objAL;
        return objAL.Id;
    }
    
    @AuraEnabled
    public static Account parentAccount(String recordId){
        return [select id,Name,LookupValue__c from Account where Id =:recordId LIMIT 1];
    }
    
}