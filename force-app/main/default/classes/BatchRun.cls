public Class BatchRun {

    Public batchRun() {
    }
    
    public PageReference redirect(){
        try{new ReminderEmailForMarketInfoBatch().execute(null);}catch(Exception ex){}
        PageReference pageRef = new PageReference('https://na132.salesforce.com/home/home.jsp');
        return pageRef;
        
    }
}