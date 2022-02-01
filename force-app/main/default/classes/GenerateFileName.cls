public class GenerateFileName{
    Id varid; 
    public List<BPF__History> lstBPFHostory{get;set;}
    
    public GenerateFileName(ApexPages.StandardController controller) {
        String varfilename = '';
         varid = controller.getId() ;
         if(String.valueof(varid.getSObjectType().getDescribe().getName()) == 'BPF__c'){
            BPF__c des = [select Name from BPF__c where id =:varid  LIMIT 1];
            varfilename =  des.name +'.pdf' ;
        }
        geterateHistory(varid);
        varfilename = varfilename.replaceAll(',','');
       try{
           Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+varfilename);
       }catch(Exception ex){}
        
    }
    
    @Future(callout=true)
    public static void RunFromTrigger( String varId){
        ApexPages.StandardController obj = new ApexPages.StandardController(new BPF__c(id=varId));
        GenerateFileName o = new GenerateFileName(obj);
        o.saveasPDF();
    }
     
    public GenerateFileName(BPF__c objb) {
        String varfilename = '';
         this.varid = objb.Id ;
            varfilename =  objb.name +'.pdf' ;
        geterateHistory(varid);
        varfilename = varfilename.replaceAll(',','');
     
    }
    
    public void geterateHistory(Id VarId){
        lstBPFHostory = new List<BPF__History>();
        for(BPF__History obj : [select Field,OldValue,NewValue,CreatedBy.Name,CreatedDate from BPF__History where ParentId =:VarId AND Field = 'Stage__c' ]){
            lstBPFHostory.add(obj);
        }
    }
    
    
    
    public PageReference  saveasPDF(){
        String varfilename = '';
        PageReference ref =  page.GenerateBPF ;//new PageReference('/GenerateBPF?id=' + varid);
        ref.getParameters().put('id',varid);
        
        if(String.valueof(varid.getSObjectType().getDescribe().getName()) == 'BPF__c'){
            BPF__c des = [select Name from BPF__c where id =:varid  LIMIT 1];
            varfilename =  des.name +'.pdf' ;
        }
        varfilename = varfilename.replaceAll(',','');
        
        Id cv = null;
        for(ContentVersion cvv : [select id,ContentDocumentId from ContentVersion where Title = : varfilename LIMIT 1 ] ){
            cv = cvv.ContentDocumentId;
        }
       try{
           if(cv != null){
                ContentDocumentLink cd = [select id from ContentDocumentLink where ContentDocumentId = : cv  LIMIT 1];
            DELETE cd;
        }
       }catch(Exception ex){}
        
        
        ContentVersion cont = new ContentVersion();
        
        
        cont.Title = ' '+ varfilename;
        cont.PathOnClient = varfilename;
        if(Test.isRunningTest()) { 
          cont.VersionData = blob.valueOf('Unit.Test');
        } else {
         cont.VersionData = ref.getContentAsPdf();
        }
        cont.IsMajorVersion = true;
        insert cont; 
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cont.Id].ContentDocumentId;
        
        //Create ContentDocumentLink 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = varid;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        return ref;
        
    }
}