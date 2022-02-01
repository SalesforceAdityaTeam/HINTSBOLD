public class ScreeningCaseTriggerHelper{
    
    @future(callout=true)
    public static void attachToBPF(String varId, String accid) {
        tr_wc1__KYC_Screening_Case__c objSC = new tr_wc1__KYC_Screening_Case__c(Id = varId );
        List<BPF__C> lst = [select id from BPF__C where AccountName__c =:accid AND stage__c ='BPF Customer Input Completed' ORDER BY LastModifiedDate DESC LIMIT 1 ];
        if(lst.size() > 0 ){
            BPF__C obj = lst[0];
            objSC.BPF__C = obj.Id;
        }
        update objSC;
    }
}