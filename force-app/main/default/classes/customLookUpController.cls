public class customLookUpController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName,String accountId) {
        Set<Id> setval = new Set<Id>();
        String criteria = '';
        String searchKey = searchKeyWord + '%';
        String sQuery = 'select id,name,LookupValue__c from '+ ObjectName + ' where id != null AND  (LookupValue__c LIKE: searchKey) order by createdDate ';
        List < sObject > returnList = new List < sObject > ();
        if(ObjectName == 'Account'){
            if(accountId != null && accountId == 'searchParentOnly'){
                sQuery = 'select id, Name,LookupValue__c from Account where (RecordType.name = \'Parent Account\' OR RecordType.name  = \'Prospect-Parent\') AND LookupValue__c LIKE: searchKey order by Name ASC limit 30 ';
            } else if(accountId == null || accountId == ''){
                sQuery = 'select id,name,LookupValue__c,MaxAVGDays__c from '+ ObjectName + ' where RecordType.name = \'Customer\' AND Status__c = \'A\' ';
            } else if(accountId != null && accountId.startsWith('003')){
                List<Contact> con = [select id,AccountId from contact where id=:accountId];
                accountId = con.size() > 0 ? con.get(0).AccountId : null ;
                sQuery =  'select id, Name,LookupValue__c,MaxAVGDays__c from ' +ObjectName + ' where  ( RecordType.name = \'Customer\' OR RecordType.name = \'Prospect-Child\' ) AND Parent_Account__c =: accountId AND LookupValue__c LIKE: searchKey order by createdDate DESC limit 30'; // Status__c = \'A\'
            } 
        } else if(ObjectName == 'Location__c' && accountId == 'searchLocationOnly'){
            sQuery = 'select id,name,LookupValue__c from Location__c where (LookupValue__c LIKE: searchKey) order by createdDate DESC limit 30 ';
        }
        else if( accountId != null && accountId != ''){
            set<Id> setid = new Set<Id>();
            List<Contact> con = [select id,AccountId from contact where id=:accountId];
            accountId = con.size() > 0 ? con.get(0).AccountId : null ;
            for(Account_Location__c acl : [select id,Location__c from Account_Location__c where SFAccountCusNum__c =:accountId ]){
                setid.add(acl.Location__c);
            }
            if(setid.size()>0){
                sQuery =  'select id, Name,LookupValue__c from ' +ObjectName + ' where (LookupValue__c LIKE: searchKey) AND Id IN :setid  order by createdDate DESC limit 30';
            }
        }
        List < sObject > lstOfRecords = Database.query(sQuery);
        System.debug('>>>>>>>>>>>>>>>>>lstOfRecords>>>'+lstOfRecords);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}