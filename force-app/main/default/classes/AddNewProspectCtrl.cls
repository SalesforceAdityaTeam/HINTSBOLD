public class AddNewProspectCtrl {
    @AuraEnabled
    public Static String saveRecords(Contact objcon, Account objacc, Account selectedAcc){
        Integer len = 3;
        try{
            String str = string.valueof(Math.abs(Crypto.getRandomLong()));
            String randomNumber = str.substring(0, len);
            
            if(selectedAcc.Id == null){
                 Account acc = new Account(
                    Name = objacc.Name,
                    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect-Parent').getRecordTypeId(),
                    SFAccountCusNum__c = '99999-' + randomNumber ,
                    Status__c = 'P'
                 );   
                INSERT acc;
                selectedAcc = acc;
                objacc.Parent_Account__c =acc.id ;
                objacc.ParentId = acc.id;
                objacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect-Child').getRecordTypeId();
                INSERT objacc;
            }else {
                objacc.Parent_Account__c =selectedAcc.Id ;
                objacc.ParentId = selectedAcc.Id;
                objacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect-Child').getRecordTypeId();
                INSERT objacc;
            }
            objcon.AccountId = objacc.Parent_Account__c;
            INSERT objcon;
        
            return selectedAcc.Id;
        }catch(Exception ex){
            return String.valueOf(ex);
        }
        
    }
    
     @AuraEnabled
    public static String saveRecordsLoc(Location__C LOc,Account parentAccount, Location__c searchLocation  ){
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
        System.debug('>>>>>>>>>>>>>>>>>>>objAL>>>>'+objAL);
        return objAL.Id;
    }
}