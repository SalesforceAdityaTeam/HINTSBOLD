public class OfferContatcCtrl {
	
   @AuraEnabled
    public static List <sObject> fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList) {
        String searchKey = '%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
        String sQuery = '';
        if(ObjectName == 'Contact'){
            sQuery =  'select id, Name from Contact where Name LIKE: searchKey order by createdDate DESC limit 10';
        }
        System.debug(sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery);
        System.debug(lstOfRecords);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static List<Offer_Contact__c> lineItemPreset(String recordId,String count,List<Offer_Contact__c> lstData){
        if(lstData.size() > 0){
              List<Offer_Contact__c> lst = new List<Offer_Contact__c>();
              lst.AddAll(CreateRecord(lstData,recordId));
              lstData = new List<Offer_Contact__c>();
              lstData.AddAll(lst);
         	  lstData.add(new Offer_Contact__c(Offer__c =recordId,Sequence__c = String.valueOf(lstData.size()))); 
        }else {
            lstData = new List<Offer_Contact__c> ();
            Integer i = 0;
            for(Offer_Contact__c o : [select id,Offer__c,Contact__c,Contact_Name__c from Offer_Contact__c where offer__c =:recordId ]){
                o.Sequence__c  = String.valueOf(i++);
                lstData.add(o);
            }
            lstData.add(new Offer_Contact__c(Offer__c =recordId,Sequence__c = String.valueOf(lstData.size())));
            lstData.add(new Offer_Contact__c(Offer__c =recordId,Sequence__c = String.valueOf(lstData.size())));
            lstData.add(new Offer_Contact__c(Offer__c =recordId,Sequence__c = String.valueOf(lstData.size())));
            lstData.add(new Offer_Contact__c(Offer__c =recordId,Sequence__c = String.valueOf(lstData.size())));
            lstData.add(new Offer_Contact__c(Offer__c =recordId,Sequence__c = String.valueOf(lstData.size())));
        }
        return lstData;
    }
   
    @AuraEnabled
    public static List<Offer_Contact__c>  CreateRecord( List<Offer_Contact__c>  lst, String recordId){
        
        List<Offer_Contact__c> lstINSERT = new List<Offer_Contact__c>();
        for(Offer_Contact__c o: lst){
            if(o.Contact__c != null){
                lstINSERT.add(o);
            }
        }
        UPSERT lstINSERT;
        return lstINSERT;
    }
    
  @AuraEnabled
  public static List<Offer_Contact__c> removeItem(List<Offer_Contact__c> lst,String rowId){
      Offer_Contact__c  obj = lst[Integer.valueOf(rowId)];
      lst.remove(Integer.valueOf(rowId));
      if(obj.Id != null)
          	DELETE obj;
      return lst;
  }
    
}