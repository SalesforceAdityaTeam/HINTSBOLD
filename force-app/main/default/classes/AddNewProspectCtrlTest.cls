@IsTest
public class AddNewProspectCtrlTest {
    public Static TestMethod void test(){
        Account objacc = new Account(name = 'asdasda');
        Contact con = new Contact(Lastname = 'sadasda');
        
        AddNewProspectCtrl.saveRecords(con,objacc,new Account());
        
        Account acc = new Account(name = 'asdasdas');
        Location__C loc = new Location__C(addrline4__c='asdas',addrpost_code__c ='asdasd',Oppdest__c = 'asdas0',addrline5__c ='asdas');
        AddNewProspectCtrl.saveRecordsLoc(loc,acc,new Location__c());
        
    }
}