public class ApprovalStatusBarcl{
  @auraEnabled
  public static Map<String,List<WrapStatusBar>> loadStatus(String sRecId){
    List<Approval_Combination__c> lstCombination = [SELECT Supplier__c,Supplier__r.name,Factcode__r.name,Status__c FROM Approval_Combination__c WHERE Approval__c =: sRecId ORDER BY LastModifiedDate DESC ];
    Map<Integer, String> mapStatus = getPickListValuesIntoList();
      Map<String,List<WrapStatusBar>> lstStatusBar1 = new Map<String,List<WrapStatusBar>>();
    
    if(!lstCombination.isEmpty()){
        Integer iActiveStatus = 0;
        Integer i=0;
        for( Approval_Combination__c oCombination : lstCombination){
            i++;
      List<WrapStatusBar> lstStatusBar = new List<WrapStatusBar>();
      for(Integer iKey : mapStatus.keySet()){
        String sStatusValue = mapStatus.get(iKey);
        String sStatusType = 'incomplete';
        if(sStatusValue == oCombination.Status__c){
          sStatusType = 'active';
          iActiveStatus = iKey;
        }
        lstStatusBar.add(new WrapStatusBar(sStatusValue, sStatusType, iKey));
      }
            for(WrapStatusBar oBar : lstStatusBar){
        if(oBar.iStatusNumber < iActiveStatus){
          oBar.sStatusType = 'complete';
        }
        if(oBar.iStatusNumber > iActiveStatus){
          oBar.sStatusType = 'incomplete';
        }
      }
            String combo='';
            combo+=i;
            if(oCombination.Supplier__r.name!=null){combo+=oCombination.Supplier__r.name+'/';}
            if(oCombination.Factcode__r.name!=null){combo+=oCombination.Factcode__r.name;}
            //lstStatusBar1.put(oCombination.Supplier__r.name + oCombination.Factcode__r.name ,lstStatusBar);
            lstStatusBar1.put(combo,lstStatusBar);
            System.debug(' Inside Loopppppp '+oCombination.Supplier__r.name);
      }
      
    }
    return lstStatusBar1;
  }
  
  public static Map<Integer, String> getPickListValuesIntoList(){
    Schema.DescribeFieldResult fieldResult = Approval_Combination__c.Status__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    Map<Integer, String> mapStatus = new Map<Integer, String>();
    Integer count = 1;
    for( Schema.PicklistEntry pickListVal : ple){
      mapStatus.put(count, pickListVal.getLabel());
      count++;
    }
    return mapStatus;
  }
  
  public class WrapStatusBar{
    @auraEnabled
    public String sStatusValue;
    @auraEnabled
    public String sStatusType;
    @auraEnabled
    public Integer iStatusNumber;
      
    
    public WrapStatusBar(String sValue, String sType, Integer iNumber){
      sStatusValue = sValue;
      sStatusType = sType;
      iStatusNumber = iNumber;
    }
  }
}