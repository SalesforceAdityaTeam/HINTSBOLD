public class CopySiteLinkCtrl {
	
    @AuraEnabled
    public static String updateRecord(Id recordId){
        BPF__c b = [select id,stage__c from BPF__c where Id = :recordId LIMIT 1 ];
        if(b.stage__c == 'BPF Renewal' || b.Stage__c == 'BPF Trader In Process'){
            b = new BPF__c(Id=recordId, stage__c = 'BPF Trader Completed');
        	update b;
        }	
        return 'success';
    }
}