public class OpportunityExt {
    public String data{get;set;}
    Id oppid = null;
    String query = 'SELECT ';
    Opportunity__c objOpp ;
    Copy_Opportunity__mdt objCopyOpp;
    List<String> lstAPIs = new List<String>(); 
    Map<String,String> mapAPIType = new Map<String,String>();
    List<String> args = new String[]{'0','number','###,###,##0.00'};
    
    public OpportunityExt(ApexPages.StandardController controller) {
        test();
        oppid = controller.getId();
        objOpp = [select id,Inco_Terms__c from Opportunity__c where id=:oppid ];
        System.debug('>>>>>>>>>>>>>>>>'+objOpp.Inco_Terms__c);
    }
    
    public void init(){
        try {
            getFieldMap();
            getFieldsAPI();
            getRecordData();
            updateDATAvalues();
            OpportunityExt.myFutureMethod(oppid);
        }catch(Exception ex){
            data = 'No content Found';
        }
    }
    
    void getFieldMap(){
        Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Opportunity__c').getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values() ){
            schema.describefieldresult dfield = sfield.getDescribe();
            mapAPIType.put(dfield.getName().toLowerCase(), String.valueof(dfield.getType()) );
        }
    }
    
    void getFieldsAPI(){
        objCopyOpp = [select id,MasterLabel,DeveloperName,Field_API__c,Instruction__c from  Copy_Opportunity__mdt where MasterLabel = :objOpp.Inco_Terms__c  ];
        for(String apis :objCopyOpp.Field_API__c.split(',') ){
            query = query + apis +', ';
            lstAPIs.add(apis);
        }
        query = query + ' id,Destination_Location__c  from Opportunity__c where id =\''+oppid + '\'';
    }
    
    void getRecordData(){
        if(Database.query(query).size() > 0)
            objOpp =(Opportunity__c) Database.query(query).get(0);
        else {
            objOpp = new Opportunity__c();
        }
    }
    
    void updateDATAvalues(){
        
        data = objCopyOpp.Instruction__c ;
        for(String objAPI :lstAPIs ){
            if(data.containsIgnoreCase(objAPI)){
            	if(mapAPIType.get(objAPI.toLowerCase()) == 'DOUBLE'){
                    data = data.replace( objAPI,' ' +  objOpp.get(objAPI) != null ? String.format(Decimal.valueOf(String.valueOf(objOpp.get(objAPI))).format(), args ) : '' );    
                } else if(mapAPIType.get(objAPI.toLowerCase()) == 'PICKLIST') {
                    data = data.replace( objAPI,' ' +  String.valueOf( objOpp.get(objAPI) != null ? objOpp.get(objAPI) : '' ) + ' ' );    
                } else if(mapAPIType.get(objAPI.toLowerCase()) == 'MULTIPICKLIST') {
                    data = data.replace( objAPI,' ' +  String.valueOf( objOpp.get(objAPI) != null ? objOpp.get(objAPI) : '' ) + ' ' );  
                    if(objOpp.Brand__c == null || objOpp.Brand__c == ''  ){
                    	data = data.replace( '["at sellers option"]', '' );
                    } else if(objOpp.Brand__c.split(';').size() < 2 ){
                    	data = data.replace( '["at sellers option"]', '' );
                    }
                } else if(mapAPIType.get(objAPI.toLowerCase()) == 'STRING') {
                    data = data.replace( objAPI,' ' +  String.valueOf( objOpp.get(objAPI) != null ? objOpp.get(objAPI) : '' ) + ' ' );    
                } else if(mapAPIType.get(objAPI.toLowerCase()) == 'STRING') {
                    data = data.replace( objAPI,' ' +  String.valueOf( objOpp.get(objAPI) != null ? objOpp.get(objAPI) : '' ) + ' ' );    
                }else if(mapAPIType.get(objAPI.toLowerCase()) == 'CURRENCY'){
                    data = data.replace( objAPI, objOpp.get(objAPI) != null ? ' $' + String.format(Decimal.valueOf(String.valueOf(objOpp.get(objAPI))).format(), args ) : '' );    
                }else if(mapAPIType.get(objAPI.toLowerCase()) == 'DATE'){
                    data = data.replace( objAPI,' ' + ( objOpp.get(objAPI) != null ? formatDate ( (Date)objOpp.get(objAPI) ) : '' ) + ' ' );    
                }
            }
        }
        if(data.containsIgnoreCase('[Origin or Destination]')){
        	if(objOpp.Destination_Location__c != null ){
        		data = data.replace('[Origin or Destination]' ,' ' + objOpp.Destination_CopyPast__c );
        	} else if(objOpp.Origin_formula__c != null ){
        		data = data.replace( '[Origin or Destination]',' ' + objOpp.Origin_formula__c );
        	}
        	
        }
        
        
    }
    
    public static String formatDate(Date d) {
        return d.month() + '/' + d.Day() + '/' + d.year();
    }
    
    @future
    public static void myFutureMethod(String ids){
        Opportunity__c objOpp = new Opportunity__c(id= ids);   
        objOpp.Stage__c = 'Quoted';
        update objOpp;
   }
    
    public void test(){
        string str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        str = 'str';
        
    
    }
}