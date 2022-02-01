public class OfferEmailSendCtrl {
  
    public String UpperSection{get;set;}
    public String LowerSection{get;set;}
    public Offer__c obj {get;set;}
    public List<FileWrapper> lstWrapperFiles{get;set;}
    public Attachment oFile{get;set;}
    public String sContentDocumentId{get;set;}
    public String sRecId;
    
    public OfferEmailSendCtrl(ApexPages.StandardController controller) {
            obj = (Offer__c) controller.getRecord();
            lstWrapperFiles = new List<FileWrapper>();
            oFile = new Attachment();
            sRecId = ApexPages.currentPage().getParameters().get('Id');
    }
    
    public void addAttachment(){
      if(oFile.Name == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select file.'));
        return;
      }
      uploadFile(oFile);
      oFile = new Attachment();
    }
    
    public void uploadFile(Attachment att){
      ContentVersion cv = new ContentVersion();
      cv.Title = att.Name;
      cv.PathOnClient = att.Name;
      cv.VersionData = att.Body;
      cv.IsMajorVersion = true;
      Insert cv;
      
      Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
      lstWrapperFiles.add(new FileWrapper(oFile.Name, conDocId, cv.Id));
      //Create ContentDocumentLink 
      ContentDocumentLink cdl = New ContentDocumentLink();
      cdl.LinkedEntityId = sRecId;
      cdl.ContentDocumentId = conDocId;
      cdl.shareType = 'V';
      Insert cdl;
    }
    
    public void removeFile(){
      if(!String.isBlank(sContentDocumentId)){
        Integer iIndexToRemove = -1;
        Integer iIndex = 0;
        for(FileWrapper oWrap : lstWrapperFiles){
          if(oWrap.sId == sContentDocumentId){
            iIndexToRemove = iIndex;
          }
          iIndex++;
        }
        if(iIndexToRemove != -1){
          lstWrapperFiles.remove(iIndexToRemove);
          delete new ContentDocument(Id = sContentDocumentId);
        }
      }
    }
    
    public List<Messaging.EmailFileAttachment> prepareEmailAttachment(){
      List<String> lstIds = new List<String>();
      List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
      for(FileWrapper oWrap : lstWrapperFiles){
        lstIds.add(oWrap.sContentId);
      }
      for(ContentVersion oVersion : [SELECT Id, Title, VersionData FROM ContentVersion WHERE Id in: lstIds]){
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(oVersion.Title);
        efa.setBody(oVersion.VersionData);
        attachments.add(efa);
      }
      return attachments;
    }
      
    public PageReference sendEmail(){
        upsert obj;
        List<Messaging.SingleEmailMessage> lstEmail = new List<Messaging.SingleEmailMessage>();
        List<String> lstcc = new List<String>();
        List<String> lstBCC = new List<String>();
        for(Offer_Contact__c c  : [select id,contact__r.Email,type__c from Offer_Contact__c where offer__c =:ApexPages.currentPage().getParameters().get('Id') ]){
            if(c.Type__c == 'CC')
                lstcc.add(c.contact__r.Email);
            else
                lstBCC.add(c.contact__r.Email);
                
        }
        Offer__c objOff = [select id,Mail_Language__c,Owner.FirstName,Owner.LastName,Offer_Introduction__c,Offer_Close__c,Documents__c,Payment_Condition__c,Commission__c,Additional_Terms_and_Conditions__c,Name,
                            (select id,name,Volume__c,Total_Amount__c,Product__c,Brand_Origin__c,Destination__c,REMARK__c,INCO__c,Packaging_Pallets__c,Price__c,Period__c,Spec_ID__c from Offer_Line_Item__r),contact__c,Contact__r.EMail,Contact__r.FirstName from Offer__c where Id =: ApexPages.currentPage().getParameters().get('Id') LIMIT 1];
        String temp = 'OfferEnglish';
        if(objOff.Mail_Language__c != '' && objOff.Mail_Language__c != null){
            temp = 'Offer'+objOff.Mail_Language__c;
        } 
        EmailTemplate etemp = [select id,htmlvalue,Subject from EmailTemplate where developerName =:temp LIMIT 1]; 
        String middleBody = getTableHTML(objOff.Offer_Line_Item__r);
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
        semail.setToAddresses(new List<String>{objOff.Contact__r.EMail});
        semail.setSubject(getHTMLBody(etemp.Subject,objOff,middleBody));
        semail.setHtmlBody(getHTMLBody(etemp.htmlvalue,objOff,middleBody));
        semail.setFileAttachments(prepareEmailAttachment());
        if(lstcc.size() > 0){
            semail.setCCAddresses(lstcc);
        }
        if(lstBCC.size() > 0){
            semail.setBCCAddresses(lstBCC);
        }
        semail.setUseSignature(true);
        lstEmail.add(semail);
        
        Messaging.sendEmail(lstEmail);
        PageReference acctPage = new ApexPages.StandardController(objOff).view();
        acctPage.setRedirect(true);
        return acctPage;
    }
    
    public string  getHTMLBody(String htmlValue, Offer__c obj, STring midbody){
        String str = htmlValue;
        str = str.replace('{!Contact.FirstName} {!Contact.LastName}', ''+  obj.Contact__r.FirstName);
        str = str.replace('{!Offer__c.Offer_Introduction__c}', ''+  obj.Offer_Introduction__c);
        str = str.replace('{!Offer__c.Offer_Close__c}', ''+  obj.Offer_Close__c);
        str = str.replace('{!Offer__c.Additional_Terms_and_Conditions__c}', ''+  obj.Additional_Terms_and_Conditions__c);
        str = str.replace('{!MiddleSection}', ''+  getTableHTML(obj.Offer_Line_Item__r));
        str = str.replace('{!Offer__c.Name}', ''+ obj.Name);
        str = str.replace('{!Offer__c.OwnerFullName}', ''+  obj.Owner.FirstName + ' ' + obj.Owner.LastName);
        return str;
    }
    
    public String getTableHTML(List<OfferLineItem__c> lst){
        
        String str = '';
        str += '<tr>';
        str += '<td> <b>VOLUME </b></td>';
        str += '<td><b>PRODUCT </b></td>';
        str += '<td><b>BRAND/ORIGIN </b></td>';
        str += '<td><b>SPEC - ID# </b></td>';
        str += '<td><b>PERIOD </b></td>';
        str += '<td><b>PRICE </b></td>';
        str += '<td><b> INCO </b></td>';
        str += '<td><b> DESTINATION </b></td>';
        str += '<td><b> REMARK </b></td>';
        str += '</tr>';
        
        for(OfferLineItem__c obj : lst){
        str += '<tr>';
            
        if(obj.Volume__c!= null)
        str += '<td>'+obj.Volume__c+'</td>';
        else
        str += '<td>'+''+'</td>';
            
        if(obj.Product__c != null)
        str += '<td>'+obj.Product__c+'</td>';
        else
        str += '<td>'+''+'</td>';
            
        if(obj.Brand_Origin__c != null)
        str += '<td>'+obj.Brand_Origin__c+'</td>';
        else
        str += '<td>'+''+'</td>';
            
        if(obj.Spec_ID__c != null)
        str += '<td>'+obj.Spec_ID__c+'</td>';
        else
        str += '<td>'+''+'</td>';
        
            if(obj.Period__c != null)
        str += '<td>'+obj.Period__c+'</td>';
        else
        str += '<td>'+''+'</td>';
            
             if(obj.Price__c != null)
        str += '<td>' +obj.Price__c+'</td>';
        else
        str += '<td>'+''+'</td>';
            
            
        if(obj.INCO__c != null)
        str += '<td>' +obj.INCO__c+'</td>';
        else
        str += '<td>'+''+'</td>';
            
            if(obj.Destination__c != null)
        str += '<td>' +obj.Destination__c+'</td>';
        else
        str += '<td>'+''+'</td>';
            
                if(obj.REMARK__c != null)
        str += '<td>' +obj.REMARK__c+'</td>';
        else
        str += '<td>'+''+'</td>';
        
        str += '</tr>';
        }
       str += ''; 
       return str;
    } 
  public class FileWrapper{
    public String sFileName{get;set;}
    public String sId{get;set;}
    public String sContentId{get;set;}
    public FileWrapper(String sFileName, String sId, String sContentId){
      this.sFileName = sFileName;
      this.sId = sId;
      this.sContentId = sContentId;
    }
  }
}