public class AccountProductCtrl {
	
    @AuraEnabled
    public static List<Account_Product__c> preSetValue(Id varId, List<Account_Product__c> lstProd){
        Boolean IsNull = true;
        integer count=0;
        if(lstProd.size() == 0){
            lstProd = new List<Account_Product__c>();
            for(Account_Product__c o : [select id,Account__c,Purchase_Volume__c,Name,General_Connents__c,Application__c,Sequence__c from Account_Product__c where Account__c=:varId ORDER BY LASTMODIFIEDDATE DESC] ){
            	lstProd.add(new Account_Product__c(
                    id= o.Id,
                    Sequence__c = String.valueOf(count++),
                    Account__c = o.Account__c,
                    Purchase_Volume__c = o.Purchase_Volume__c,
                    Name = o.Name,
                    General_Connents__c = o.General_Connents__c,
                    Application__c = o.Application__c
                ));
        }   
        }
        if(lstProd.size() == 0){
            lstProd.add(new Account_Product__c(Account__c=varId,Sequence__c = String.valueOf(lstProd.size()) )); 
            lstProd.add(new Account_Product__c(Account__c=varId,Sequence__c = String.valueOf(lstProd.size()) ));
        }    
            lstProd.add(new Account_Product__c(Account__c=varId,Sequence__c = String.valueOf(lstProd.size()) )); 
            lstProd.add(new Account_Product__c(Account__c=varId,Sequence__c = String.valueOf(lstProd.size()) )); 
            lstProd.add(new Account_Product__c(Account__c=varId,Sequence__c = String.valueOf(lstProd.size()) ));
        return lstProd;
    }
    
    @AuraEnabled
    public Static String saveLineItem(Id varId,  List<Account_Product__c> lstProd){
        List<Account_Product__c> lstToInsert = new  List<Account_Product__c>();
        for(Account_Product__c o : lstProd){
            if(o.Name != null){
                lstToInsert.add(o);
            }
        }
        if(lstToInsert.size() > 0){
            upsert lstToInsert;
        }
        return varId;
    }
    
     @AuraEnabled
    public Static List<Account_Product__c> removeLineItem(List<Account_Product__c> lstProd,Integer rowId){
        Account_Product__c obj = lstProd.get(rowId);
        if(obj.Id != null ){
            DELETE obj;
        }
        lstProd.remove(rowId);
        return lstProd;
    }
    
    @AuraEnabled
    public Static List<Account_Product__c> addOneMOreValue(List<Account_Product__c> lstProd,Integer rowId){
        List<Account_Product__c> Temp = new List<Account_Product__c>();
        rowId = rowId + 1;
        Integer size = lstProd.size();
       for(Integer i= 0 ;i<=size;i++){
            if(i<rowId){
                Account_Product__c o = lstProd.get(i);
                o.Sequence__c = String.valueOf(i);
                Temp.add(o); 
                
            }else if(i>rowId){
                Account_Product__c o = lstProd.get(i-1);
                o.Sequence__c = String.valueOf(i);
                Temp.add(o);            
            }else{
                Temp.add(new Account_Product__c(Account__c=lstProd[0].Account__c,Sequence__c = String.valueOf(i)));
            }
        }
        lstProd.clear();
        lstProd.addAll(Temp);
        return lstProd;
    }
}