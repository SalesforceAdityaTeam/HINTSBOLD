public class SampleTransactionCtrl {
	@AuraEnabled
    public static List <User> fetchLookUpValues(String searchKeyWord,List<User> ExcludeitemsList) {
        String searchKey = '%' + searchKeyWord + '%';
        List <User> returnList = new List <User> ();
 
        List<string> lstExcludeitems = new List<string>();
        for(User item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        }
       
        String sQuery =  'select id, Name from User where Name LIKE: searchKey AND ISActive = true AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
        List <User> lstOfRecords = Database.query(sQuery);
        
        for (User obj:lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static String insertRelatedListRecords(String varId, List<User> lstData) {
        List<Request_Processors__c> lst  = new List<Request_Processors__c>();
        for(User u : lstData){
            lst.add(new Request_Processors__c(RequestProcessor__c = u.Id , Sample_Transaction__c = varId));
        }
        INSERT lst;
        return 'success';
    }
}