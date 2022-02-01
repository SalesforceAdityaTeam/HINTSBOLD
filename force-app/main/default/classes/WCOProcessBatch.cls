public class WCOProcessBatch implements Database.Batchable<sObject>, Schedulable{

   public Database.QueryLocator start(Database.BatchableContext BC){
       String query = 'select name from WCOProcessBatch__c';
       if(Test.isRunningTest()){
           query = 'select name from WCOProcessBatch__c LIMIT 1';
       }
      return Database.getQueryLocator(query);
   }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch( new WCOProcessBatch(), 1 );
   }
    
   public void execute(Database.BatchableContext BC, List<WCOProcessBatch__c> scope){
        WCOProcessBatch__c o  = scope[0];
        
        try{
            BPF__c objBPF = [select id from BPF__C where id = : o.Name AND Stage__c = 'BPF Customer Input Completed' AND Process_WCO__c = false];
            objBPF.Process_WCO__c = true;
            update objBPF;
            DELETE o;
        }catch(Exception ex){
            SYstem.debug('>>>>>>>>>>>>>>ERROR---- '+ ex);
        }
    }

   public void finish(Database.BatchableContext BC){
        Long startingTime = System.now().getTime(); 
        Integer delayInMilliseconds = 1000 * 60 ; 
            while (System.now().getTime() - startingTime < delayInMilliseconds)  {
        }
       WCOProcessBatch batch = new WCOProcessBatch();
       if(!Test.isRunningTest()) Database.executeBatch( batch, 1 );
        
   }
}