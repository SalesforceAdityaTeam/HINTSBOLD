@RestResource(urlMapping='/BPF/*')
global class RESTApiPublic {
    
    @HttpPost
    global static STring createCase(String bpfId) {
        try{
            BPF__C o = new BPF__c(Id = bpfId, Stage__c = 'BPF Customer Input Completed');
            update o;
        }catch(Exception ex){ System.debug('>>>>>>>>>EXCE>>>>>>>>>'+ex);}
        return '' ;
    } 
}