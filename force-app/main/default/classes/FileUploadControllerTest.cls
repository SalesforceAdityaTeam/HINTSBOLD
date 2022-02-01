@ISTest
public Class FileUploadControllerTest{
    
    public static TestMethod void t(){
        BPF__c o = new BPF__c();
        INSERT o;
        FileUploadController.attachBlob(o.Id,null,'asda.txt','txt','jshdfkjhasdf');
    }

}