trigger OpportunityTrigger on Opportunity__c (before insert,before update) {
    
    if(Trigger.IsBefore ) {
        rollupdetails();
        if(Trigger.IsUpdate){
            resetAccountContactRule();
        }
    }
  
    public void rollupdetails(){
        
        Map<String,Credit_Insurance_Rate__c> mapNameToRate = new Map<String,Credit_Insurance_Rate__c>();
        for(Credit_Insurance_Rate__c o : [select id,name,Rate__c from Credit_Insurance_Rate__c ]){
            mapNameToRate.put(o.name, o);
        }
        
        for(Opportunity__c objOpp : Trigger.new ) {
            if(objOpp.Rate__c == null ){
                if(mapNameToRate.containsKey(objOpp.Account_BillingCountry__c)){
                    objOpp.Rate__c = mapNameToRate.get(objOpp.Account_BillingCountry__c).Rate__c != null ? mapNameToRate.get(objOpp.Account_BillingCountry__c).Rate__c : 0 ;
                }
            }
            if(objOpp.Volume__c != null && objOpp.Volume__c != 0 && objOpp.Planned_of_Shipments__c != 0 && objOpp.Planned_of_Shipments__c != null ){
                if(objOpp.Unit_of_Measure__c == 'LBS')
                    objOpp.Planned_of_Total_Containers__c = MATH.rint( (objOpp.Volume__c / objOpp.Planned_of_Shipments__c)/ 42000 );
                else if(objOpp.Unit_of_Measure__c == 'MT')
                    objOpp.Planned_of_Total_Containers__c = MATH.rint( (objOpp.Volume__c / objOpp.Planned_of_Shipments__c) / 19.05 );
            }
        }
    }
    
    public void resetAccountContactRule(){
        Opportunity__c obj = Trigger.new.get(0);
        Opportunity__c objOld = Trigger.oldMap.get(obj.id);
        if(obj.Contact__c != null && obj.Contact__c != objOld.contact__c && obj.Account__c != null ){
           if(!obj.FireNullProcess__c){
               obj.Contact__c = null;
           }
        }
        else if(obj.Contact__c != null && obj.Account__c != objOld.Account__c && obj.Account__c != null ){
            if(!obj.FireNullProcess__c){
               obj.Account__c = null;
           }
        }
    }
   
}