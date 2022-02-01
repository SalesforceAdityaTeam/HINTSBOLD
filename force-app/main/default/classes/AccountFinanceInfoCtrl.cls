public class AccountFinanceInfoCtrl {
    @AuraEnabled
    public Static Account_Opco_Info__c getOpcoValues(String VarId){
        String UserId = UserInfo.getUserId();
        System.debug('>>>>>>>>>>>>>'+UserId);
        System.debug('>>>>>>>>>>>>>'+VarId);
        User u = [select id,CompanyName from User where Id=:UserId ];
        System.debug('>>>>>>>>>>>>>'+u);
        Account_Opco_Info__c obj = new Account_Opco_Info__c();
        for(Account_Opco_Info__c o: [select id,CreditHoldExempt__c,CustomerCurrencyCode_ABAmounts__c,Date_LastCreditReview__c,DefaultAddress__c,EntityCompany__c,Ext_SFAccCusNum__c,
                                    FreightHandlingCode__c,HoldInvoices__c,Name,PaymentTermsCode__c,Related_AddressNumber__c from Account_Opco_Info__c where 
                                     Opco__r.Name =: u.CompanyName AND Account__c =: VarId ]){
                              obj = o;           
                                     }
        System.debug('>>>>>>>>>>>>>'+obj);
        return obj;
    }
}