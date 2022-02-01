public class AccountApprovalDeep {
    @AuraEnabled
    public static Account_Approval_Deep__c getAccApproval(String ApprovalId){
        Account_Approval_Deep__c aad=[SELECT Id,GFSI_Certificate_Required__c,GFSI_Certificate__c from Account_Approval_Deep__c where Approval__c=:ApprovalId LIMIT 1];
        return aad;
    }
    @AuraEnabled
    public static void updateRecord(Account_Approval_Deep__c accAppData){
        System.debug('Inside update');
        Update accAppData;
        System.debug('Update complete');
    }
}