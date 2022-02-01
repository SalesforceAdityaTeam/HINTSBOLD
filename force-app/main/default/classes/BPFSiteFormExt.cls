public class BPFSiteFormExt {
    public String section{get;set;}
    public BPF__c objBPF{get;set;}
    public BPF__C objOLD;
    public List<Contact> lstContact {get;set;}
    public List<TradeReferences__c> lstTradeReferences{get;set;}
    public String accountId{get;set;}
    public String message{get;set;}
    public Boolean isValidate = true;
    Public Static Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Active_Contact').getRecordTypeId();
    Map<String,Id> mapContactIdUBO = new Map<String,Id>();
    
    
    public BPFSiteFormExt(){
    }
    
    public BPFSiteFormExt(ApexPages.StandardController controller) {
        section = 'custApp';
        message = '';
        if(!Test.isRunningTest())
            controller.addFields(new String[]{'UBO_1__c','UBO_2__c','UBO_3__c','UBO_4__c','SignatureName__c','SignatureTitle__c','SignaturePhone__c','SignatureEmail__c','Stage__c','AccountName__r.Parent_Account__c','AccountName__c','Ultimate_Beneficial_Owner_UBO_1__c','Ultimate_Beneficial_Owner_UBO_2__c','Ultimate_Beneficial_Owner_UBO_3__c','Ultimate_Beneficial_Owner_UBO_4__c'});
        this.objBPF =(BPF__C) controller.getRecord();
        initiateContact();
    }
    
    public void initiateContact(){
        
        lstContact = new List<Contact>();
        for(Contact con : [select id,FirstName,LastName,Title,Phone,Email,Role__c,AccountId from Contact where ID IN (select Contact__c from BPFContact__c where BPF__c =:objBPF.Id ) ]){
            lstContact.add(con);
        }
       
        lstContact.add(new Contact(LastName = '.',AccountId = objBPF.AccountName__r.Parent_Account__c,Title = 'Accounts Payable'));
        lstTradeReferences = new List<TradeReferences__c>();
        lstTradeReferences.add(new TradeReferences__c(BPF__c =objBPF.Id ));
        lstTradeReferences.add(new TradeReferences__c(BPF__c =objBPF.Id ));
        lstTradeReferences.add(new TradeReferences__c(BPF__c =objBPF.Id ));
        if( objBPF.Stage__c == 'BPF Customer Input Completed' || objBPF.Stage__c == 'BPF World Check One Response Received' || objBPF.Stage__c == 'Prospect Data Approved' || objBPF.Stage__c == 'Prospect Info Reviewed by CreditSafe' || objBPF.Stage__c == 'BPF Signed' || objBPF.Stage__c == 'Customer' || objBPF.Stage__c == 'BPF Expired'  ){
           message = 'Thank you for completing your Business Partner Form';
           section = 'done';
        }
        
    }
    
    public void addMoreContact(){
        
        for(Contact c : lstContact){
            if(c.LastName == '.'){
                c.LastName = 'BlankLastName';
            }
        }
        lstContact.add(new Contact(LastName= '.',AccountId = objBPF.AccountName__r.Parent_Account__c,Title = 'Accounts Payable'));
    }
   
    
    public void nextSection(){
        
            Set<String> setNames = new Set<String>();
            setNames.add(OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c);
            setNames.add(OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c);
            setNames.add(OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c);
            setNames.add(OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c);
            
            for(Contact c : [select id,name from Contact where Name IN : setNames ORDER BY LastModifiedDate DESC]){
                mapContactIdUBO.put(c.name, c.id);
            }
            
            if(message == '' || message == null){
                message = 'You have saved the form without signing which means it has not yet been approved by you. When ready, please return to this link and complete the form and Sign. Thank you!';
                objBPF.Stage__c = 'BPF Customer Input WIP';
            }
            
            
            List<Contact> LstInsertCon = new List<Contact>();
            for(Contact c : lstContact){
                if(c.FirstName != null & c.id == null){
                    if(c.LastName == null )
                        c.LastName = 'BlankLastName';
                    c.AccountId = objBPF.AccountName__r.Parent_Account__c;
                    c.RecordTypeId = ContactRecordTypeId ;
                    LstInsertCon.add(c);
                }
            }
            
            List<Contact> UBOContact = new List<Contact>();
            List<BPFContact__c> lstBPFCON = new List<BPFContact__c>();
             
            if( OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c != NULL &&  OBJbpf.UBO_1__c == NULL ){
                UBOContact.add(new Contact(
                    Id = mapContactIdUBO.containsKey(OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c) ? mapContactIdUBO.get(OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c) : null,
                    FirstName = ( OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c.split(' ')[0] : '' ) , 
                    LastName =  ( OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c.split(' ')[1] : OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c ) , 
                    Title = 'UBO', 
                    AccountId = objBPF.AccountName__c,
                    RecordTYpeId = ContactRecordTypeId
                ));
            }
            if( OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c != NULL &&  OBJbpf.UBO_2__c == NULL){
                UBOContact.add(new Contact(
                    Id = mapContactIdUBO.containsKey(OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c) ? mapContactIdUBO.get(OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c) : null,
                    FirstName = ( OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c.split(' ')[0] : '' ) , 
                    LastName =  ( OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c.split(' ')[1] : OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c ) , 
                    Title = 'UBO', 
                    AccountId = objBPF.AccountName__c,
                    RecordTYpeId = ContactRecordTypeId
                ));
            }
            if( OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c != NULL &&  OBJbpf.UBO_3__c == NULL){
                UBOContact.add(new Contact(
                    Id = mapContactIdUBO.containsKey(OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c) ? mapContactIdUBO.get(OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c) : null,
                    FirstName = ( OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c.split(' ')[0] : '' ) , 
                    LastName =  ( OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c.split(' ')[1] : OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c ) , 
                    Title = 'UBO', 
                    AccountId = objBPF.AccountName__c,
                    RecordTYpeId = ContactRecordTypeId
                ));
            }
        
            if( OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c != NULL &&  OBJbpf.UBO_4__c == NULL){
                UBOContact.add(new Contact(
                    Id = mapContactIdUBO.containsKey(OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c) ? mapContactIdUBO.get(OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c) : null,
                    FirstName = ( OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c.split(' ')[0] : '' ) , 
                    LastName =  ( OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c.split(' ')[1] : OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c ) , 
                    Title = 'UBO', 
                    AccountId = objBPF.AccountName__c,
                    RecordTYpeId = ContactRecordTypeId
                ));
            }
            
            if(UBOContact.size() > 0)
                UPSERT UBOContact;
                
            for(Contact objconVal : UBOContact){
                lstBPFCON.add(new BPFContact__c(BPF__c = objBPF.Id, Contact__c = objconVal.Id));
                if(OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c == (objconVal.FIrstName +' ' + objconVal.LastName) ){
                    OBJbpf.UBO_1__c = objconVal.Id ; 
                }
                if(OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c == (objconVal.FIrstName +' ' + objconVal.LastName) ){
                    OBJbpf.UBO_2__c = objconVal.Id ;
                }
                if(OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c == (objconVal.FIrstName +' ' + objconVal.LastName) ){
                    OBJbpf.UBO_3__c = objconVal.Id ;
                }
                if(OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c == (objconVal.FIrstName +' ' + objconVal.LastName) ){
                    OBJbpf.UBO_4__c = objconVal.Id ;
                }
            }
            
            UPDATE objBPF;
            
            TRY{
                UPSERT new WCOProcessBatch__c(name = objBPF.Id ) NAME;
            }catch(Exception ex){ system.debug('>>>>>>ERROR>>>>>>'+ex);}
            
            if(LstInsertCon.size()>0  ){
                UPSERT LstInsertCon email;
            }
            
           
            for(Contact c : LstInsertCon)
                lstBPFCON.add(new BPFContact__c(BPF__c = objBPF.Id, Contact__c = c.Id));
            if(lstBPFCON.size() > 0 )
                INSERT lstBPFCON;
            
            List<TradeReferences__c> lstTradeReferencesInsert = new List<TradeReferences__c>();
            For(TradeReferences__c c : lstTradeReferences){
                if(c.Name != null )
                    lstTradeReferencesInsert.add(c);
            }
            if(lstTradeReferences.size() > 0)
                UPSERT lstTradeReferencesInsert;
           
            section = 'done';
    }
    
    public void cancled(){ 
        for(Contact c : lstContact){
            if(c.LastName == null){
                c.LastName = 'BlankLastName';
            }
        }
        displayPopup = false;  
        message = 'No changes you have made on the form have been saved';
        section = 'done';
    }
    
    public boolean displayPopup {get; set;}     
    
    public void closePopup() { 
       displayPopup = false;
       try{
           displayPopup = false;    
            nextSection();
       }catch(Exception ex){}
        
    }    
    
    
    public void showPopup() {
      if(validateFields(objBPF)) {
            displayPopup = true;   
            message = 'Thank you for completing your Business Partner Form';
            objBPF.Stage__c = 'BPF Customer Input Completed';
      }
    }
    
    @RemoteAction
    public static void UploadImage(Blob imageData, string pid)
    {
        string fileNameWitPath = 'Signature - ' + String.valueOf(System.Now()).Replace('/', '-').Replace(' ','-').Replace(':','') + '.png';
        ContentVersion cont = new ContentVersion();
        cont.Title = ' '+ fileNameWitPath;
        cont.PathOnClient = fileNameWitPath;
        cont.VersionData = imageData;//EncodingUtil.Base64Decode(imageData);
        cont.IsMajorVersion = true;
        cont.FirstPublishLocationId = pid;
        insert cont;
        
    
    }
    
    public Boolean validateFields(BPF__c objBPF){
        Boolean Isvalidation = true;
        if(objBPF.Registered_Legal_Name__c == null ){
            objBPF.Registered_Legal_Name__c.addError('Error:You must enter a value'); Isvalidation = false;
        }
        
        if(objBPF.Legalentitytype__c == null ){
            objBPF.Legalentitytype__c.addError('Error:You must enter a value'); Isvalidation = false;
        }
        if(objBPF.Companywebsite__c == null ){
            objBPF.Companywebsite__c.addError('Error:You must enter a value'); Isvalidation = false;
        }
        if(objBPF.LineofBusiness__c == null ){
            objBPF.LineofBusiness__c.addError('Error:You must enter a value'); Isvalidation = false;
        }
        if(objBPF.Companyphonenumber__c == null ){
            objBPF.Companyphonenumber__c.addError('Error:You must enter a value'); Isvalidation = false;
        }
        if(objBPF.YearofIncorporation__c == null ){
            objBPF.YearofIncorporation__c.addError('Error:You must enter a value'); Isvalidation = false;
        }
        if(objBPF.PO_StreetAddress__c == null ){
            objBPF.PO_StreetAddress__c.addError('Error:You must enter a value'); Isvalidation = false;
        }
       
        if(objBPF.PO_City__c == null ){
            objBPF.PO_City__c.addError('Error:You must enter a value'); Isvalidation = false;
        }
       
        if(objBPF.PO_StateProvince__c == null ){
            objBPF.PO_StateProvince__c.addError('Error:You must enter a value'); Isvalidation = false;
        }
       
        if(objBPF.PO_PostalCode__c == null ){
            objBPF.PO_PostalCode__c.addError('Error:You must enter a value'); Isvalidation = false;
        }
       
        if(objBPF.PO_Country__c == null ){
            objBPF.PO_Country__c.addError('Error:You must enter a value'); Isvalidation = false;
        }
       
       
        
        return Isvalidation;
    }
    
}