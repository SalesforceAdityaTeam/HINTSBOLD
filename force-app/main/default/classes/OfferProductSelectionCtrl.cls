public class OfferProductSelectionCtrl {
    
    @AuraEnabled
    public Static String saveLineItem(Id varId,  List<OfferLineItem__c> lstProd, Boolean IsApprovedOnly,List < sObject >  relatedContact,List < sObject >  relatedContactBcc){
      
        List<OfferLineItem__c> lstToDelete = new  List<OfferLineItem__c>();
        List<OfferLineItem__c> lstToInsert = new  List<OfferLineItem__c>();
        for(OfferLineItem__c o : lstProd){
            if((o.For_Offer__c ) && o.Product__c != null){
                lstToInsert.add(o);
            }else if(!o.For_Offer__c && o.Id != null ){
                lstToDelete.add(o);
            }
        }
        if(lstToDelete.size() > 0)
            DELETE lstToDelete;
        if(lstToInsert.size() > 0){
            upsert lstToInsert;
        }
        
       
            List<Offer_Contact__c> lst = new List<Offer_Contact__c>();
            for(sObject o : relatedContact){
                Contact c = (Contact) o;
              lst.add(new Offer_Contact__c(contact__c =c.Id , Type__c = 'CC', Offer__C = varId)); 
            }
            
            for(sObject o : relatedContactBcc){
                Contact c = (Contact) o;
              lst.add(new Offer_Contact__c(contact__c =c.Id , Type__c = 'BCC', Offer__C = varId)); 
            }
            INSERT lst;
       
        return varId;
    }
    
    @AuraEnabled
    public Static List<OfferLineItem__c> removeLineItem(List<OfferLineItem__c> lstProd,Integer rowId){
        OfferLineItem__c obj = lstProd.get(rowId);
        if(obj.Id != null ){
            DELETE obj;
        }
        lstProd.remove(rowId);
        return lstProd;
    }
    
    @AuraEnabled
    public Static List<OfferLineItem__c> addOneMOreValue(List<OfferLineItem__c> lstProd,Integer rowId){
        List<OfferLineItem__c> Temp = new List<OfferLineItem__c>();
        rowId = rowId + 1;
        Integer size = lstProd.size();
       for(Integer i= 0 ;i<=size;i++){
            if(i<rowId){
                OfferLineItem__c o = lstProd.get(i);
                o.Sequence__c = String.valueOf(i);
                Temp.add(o); 
                
            }else if(i>rowId){
                OfferLineItem__c o = lstProd.get(i-1);
                o.Sequence__c = String.valueOf(i);
                Temp.add(o);            
            }else{
                Temp.add(new OfferLineItem__c(Offer__c=lstProd[0].Offer__c,Sequence__c = String.valueOf(i)));
            }
        }
        lstProd.clear();
        lstProd.addAll(Temp);
        return lstProd;
    }
    
    @AuraEnabled
    public static List<OfferLineItem__c> preSetValue(Id varId, List<OfferLineItem__c> lstProd, Boolean IsApprovedOnly){
       Set<STring> steString = new Set<String>();
        Boolean IsNull = true;
        integer count=0;
        if(lstProd.size() == 0){
            lstProd = new List<OfferLineItem__c>();
            for(OfferLineItem__c o : [select id,For_Offer__c,Remark__c,Offer__c,Sequence__c,Product__c,Brand_Origin__c,Destination__c,INCO__c,Period__c,Price__c,Volume__c,Spec_ID__c from OfferLineItem__c where Offer__c=:varId AND For_Offer__c = true ORDER BY LASTMODIFIEDDATE DESC] ){
            	
                    lstProd.add(new OfferLineItem__c(
                        id= o.Id,
                        Offer__c = o.Offer__c,
                        Sequence__c = String.valueOf(count++),
                        Product__c = o.Product__c,
                        Brand_Origin__c = o.Brand_Origin__c,
                        Destination__c = o.Destination__c,
                        INCO__c = o.INCO__c,
                        Period__c = o.Period__c,
                        Price__c = o.Price__c,
                        Volume__c = o.Volume__c,
                        Spec_ID__c = o.Spec_ID__c,
                        Remark__c = o.Remark__c,
                        For_Offer__c = o.For_Offer__c
                    ));
          
        }   
        }
        if(IsNull && lstProd.size() == 0 && IsApprovedOnly){
            lstProd = new List<OfferLineItem__c>();
            set<Id> setIdsRecent = new Set<Id>();
            Offer__c o = [select id,Account__c from Offer__c where id =:varId LIMIT 1];
            for( Offer__c off : [select id,Account__c from Offer__c where id !=:varId AND Account__c =:o.Account__c]){
                setIdsRecent.add(off.Id);
            }
            for(OfferLineItem__c app : [select id,For_Offer__c,Remark__c,Product__c,Brand_Origin__c,Destination__c,INCO__c,Period__c,Price__c,Volume__c,Spec_ID__c from OfferLineItem__c where Offer__c IN : setIdsRecent ORDER BY CREATEDDATE DESC]){
           		String s  = app.Product__c + app.Brand_Origin__c ;
                if(!steString.contains(s)) {
                lstProd.add(new OfferLineItem__c(
                    Offer__c = varId,
                    Sequence__c = String.valueOf(count++),
                    Product__c = app.Product__c,
                    Brand_Origin__c = app.Brand_Origin__c,
                    Destination__c = app.Destination__c,
                    INCO__c = app.INCO__c,
                    Period__c = app.Period__c,
                    Price__c = app.Price__c,
                    Volume__c = app.Volume__c,
                    Spec_ID__c = app.Spec_ID__c,
                    Remark__c = app.Remark__c
                ));
            }
                 steString.add(s);
            }
            lstProd.add(new OfferLineItem__c(Offer__c=varId,Sequence__c = String.valueOf(lstProd.size()) )); 
            lstProd.add(new OfferLineItem__c(Offer__c=varId,Sequence__c = String.valueOf(lstProd.size()) ));
        }
        if(!IsApprovedOnly && lstProd.size() == 0 ){
            lstProd.add(new OfferLineItem__c(Offer__c=varId,Sequence__c = String.valueOf(lstProd.size()) )); 
            lstProd.add(new OfferLineItem__c(Offer__c=varId,Sequence__c = String.valueOf(lstProd.size()) ));
        }    
            lstProd.add(new OfferLineItem__c(Offer__c=varId,Sequence__c = String.valueOf(lstProd.size()) )); 
            lstProd.add(new OfferLineItem__c(Offer__c=varId,Sequence__c = String.valueOf(lstProd.size()) )); 
            lstProd.add(new OfferLineItem__c(Offer__c=varId,Sequence__c = String.valueOf(lstProd.size()) ));
        return lstProd;
    }
    
    @AuraEnabled
    public static List<OfferLineItem__c> adjust( List<OfferLineItem__c> lstProd,String rowId, String varDirection){
        
        List<OfferLineItem__c> temp = new List<OfferLineItem__c>();
        
        for(Integer i=0; i< lstProd.size() ; i++){
            if(varDirection == 'up'){
                if((INteger.valueOf(rowId)-1) == i){
                    OfferLineItem__c o = lstProd.get(INteger.valueOf(rowId));
                    o.Sequence__c = String.valueOf(i) ;
                    temp.add(o);
                    OfferLineItem__c oo = lstProd.get(INteger.valueOf(i));
                    i= i+1;
                    oo.Sequence__c = String.valueOf(i) ;
                    temp.add(oo);
                    
                }else {
                    temp.add(lstProd.get(i));
                }
            }else if(varDirection == 'down'){
                if((INteger.valueOf(rowId)) == i){
                    OfferLineItem__c o = lstProd.get((INteger.valueOf(rowId)+1));
                    o.Sequence__c =String.valueOf(i) ;
                    temp.add(o);
                    OfferLineItem__c oo = lstProd.get(i);
                    oo.Sequence__c =String.valueOf(i+1) ;
                    temp.add(oo);
                    
                    i++;
                }else {
                    temp.add(lstProd.get(i));
                }
            }
        }
        lstProd = new List<OfferLineItem__c>();
        lstProd.addAll(temp);
        return lstProd;
    }
}