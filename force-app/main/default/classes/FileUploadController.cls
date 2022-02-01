global without sharing class FileUploadController {
    
    @RemoteAction
    global static String attachBlob(String parentId, String attachmentId, String fileName, String contentType, String base64BlobValue){
      
        if(attachmentId == '' || attachmentId == null){
            ContentVersion cont = new ContentVersion();
            cont.Title = ' '+ fileName;
            cont.PathOnClient = fileName;
            cont.VersionData = EncodingUtil.Base64Decode(base64BlobValue);
            cont.IsMajorVersion = true;
            cont.FirstPublishLocationId = parentId;
            insert cont;
          
            return cont.Id;
            
        }else{
            for(Attachment atm : [select Id, Body from Attachment where Id = :attachmentId]){
                update new Attachment(Id = attachmentId, Body = EncodingUtil.Base64Decode(EncodingUtil.Base64Encode(atm.Body) + base64BlobValue));
            }
            return attachmentId;
        }
    }
}