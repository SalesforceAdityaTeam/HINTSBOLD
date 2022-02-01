@IsTest
public class AddNewLocationCtrlTest {
	
    public static TestMethod void Test(){
        Account acc = new Account(name = 'asdasdas');
        Location__C loc = new Location__C(addrline4__c='asdas',addrpost_code__c ='asdasd',Oppdest__c = 'asdas0',addrline5__c ='asdas');
        AddNewLocationCtrl.saveRecords(loc,acc,new Location__c());
        try{ AddNewLocationCtrl.parentAccount(null);}catch(Exception ex){} 
    }
}