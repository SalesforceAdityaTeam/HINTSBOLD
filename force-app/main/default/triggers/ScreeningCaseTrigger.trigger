trigger ScreeningCaseTrigger on tr_wc1__KYC_Screening_Case__c (after insert) {
    tr_wc1__KYC_Screening_Case__c objSC = Trigger.new.get(0);
    ScreeningCaseTriggerHelper.attachToBPF(objSC.Id,objSC.tr_wc1__Account__c);
}