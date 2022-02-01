@IsTest(SeeAllData=true)
public class OpportunityCreateEditCtrlTest {
	
    public static testMethod void test(){
        try{
        	OpportunityCreateEditCtrl.generateRate(null);
        	OpportunityCreateEditCtrl.fetchLookUpValues(null);    
        }catch(Exception ex){
            
        }
        
        
    }
}