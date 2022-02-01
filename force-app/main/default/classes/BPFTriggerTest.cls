@IsTest
public Class BPFTriggerTest{
    
    public static testMethod void test1(){
        BPF__c objBPF = new BPF__c(
            Stage__c = 'BPF Trader In Process',
            Ultimate_Beneficial_Owner_UBO_1__c = ' Tess Test 1',
            Ultimate_Beneficial_Owner_UBO_2__c = ' Tess Test 2',
            Ultimate_Beneficial_Owner_UBO_3__c = ' Tess Test 3',
            Ultimate_Beneficial_Owner_UBO_4__c = ' Tess Test 4'
        );
        INSERT objBPF;
        
        objBPF.Stage__c = 'BPF Signed';
        try{
            UPDATE objBPF;
        }catch(Exception ex){}
        
        
    }
}