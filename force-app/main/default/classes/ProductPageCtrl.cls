public class ProductPageCtrl {
  
    public List<SelectOption> productName{get;set;}
    public String selectedProductName{get;set;}
    
    public List<SelectOption> vendar{get;set;}
    public String selectedVendar{get;set;}
    
    public List<SelectOption> address{get;set;}
    public String SelectedAddress{get;set;}
    
    public List<SelectOption> part{get;set;}
    public String selectedPart{get;set;}
    
    public List<SelectOption> packing{get;set;}
    public String selectedPacking{get;set;}
    
    public List<Item__c > lstResult{get;set;}
    
    public ProductPageCtrl(){
        init();
        populateData();
        lstResult = new List<Item__c>();
    }
    
    
    
    public void init(){
        productName = new List<SelectOption>();
        vendar =  new List<SelectOption>();
        address = new List<SelectOption>();
        part = new List<SelectOption>();
        part.add(new SelectOption('',''));
        packing = new List<SelectOption>();
        packing.add(new SelectOption('',''));
    }
    
    public void populateData(){
        Set<String> set1 = new Set<String>();
        Set<String> set2 = new Set<String>();
        Set<String> set3 = new Set<String>();
        Set<String> set4 = new Set<String>();
        Set<String> set5 = new Set<String>();
        
       for(Item__c obj : [select id,name,Vendor__c,Address_Line4__c,Item_Description__c,Packaging__c,Select__c,Item_Type__c from Item__c ]) {
            set1.add(obj.name);
            set2.add(obj.Vendor__c);
            set3.add(obj.Address_Line4__c);
            set4.add(obj.Item_Description__c);
            set5.add(obj.Packaging__c);
        } 
        set1.remove(null);
        set2.remove(null);
        set3.remove(null);
        set4.remove(null);
        set5.remove(null);
        
        for(String str : set1)
            productName.add(new SelectOption(str,str));
        for(String str : set2)
            vendar.add(new SelectOption(str,str));
        for(String str : set3)
            address.add(new SelectOption(str,str));
        for(String str : set4)
            part.add(new SelectOption(str,str));
        for(String str : set5)
            packing.add(new SelectOption(str,str));
        set1 = new Set<String>();
         set2 = new Set<String>();
        set3 = new Set<String>();
        set4 = new Set<String>();
        set5 = new Set<String>();
    }
    
    public void Search() {
        lstResult = new List<Item__c >();
        List<String> lstName = new List<String>();
        List<String> lstVendor = new List<String>();
        List<String> lstadd = new List<String>();
       for(String str : selectedProductName.split(','))
           lstName.add(str.remove('[').remove(']'));
        
        String query = '';
        query = 'select id,name,Product_Type__c,Vendor__c,Address_Line4__c,city__c,state__c,Zip__c,Product_Description__c,Packaging__c,Select__c from Item__c where (name IN : lstName) ';    
        
        if(selectedPart != null && selectedPart != ''){
            query += ' AND Product_Description__c =:selectedPart ';
        }
        if(selectedPacking != null && selectedPacking != ''){
            query += ' AND Packaging__c =:selectedPacking ';
        }
        query += ' LIMIT 900 ';
        Boolean ttt = (lstName[0] == 'Test Product');
        System.debug(lstName[0]+'>hfgdhgfhfgdhfdghfdgh>>' +query);
        for(Item__c obj : Database.query(query)) {
            lstResult.add(obj);
        }
        System.debug('>>>>>>>>>>>>>'+lstResult);
    }
    
    public void Search2() {
        lstResult = new List<Item__c  >();
        List<String> lstName = new List<String>();
        List<String> lstVendor = new List<String>();
        List<String> lstadd = new List<String>();
       for(String str : selectedProductName.split(','))
           lstName.add(str.remove('[').remove(']'));
            
        for(String str : selectedVendar.split(','))
            lstVendor.add(str.trim().remove('[').remove(']'));

        String query = '';
        query = 'select id,name,Vendor__c,Product_Type__c,Address_Line4__c,city__c,state__c,Zip__c,Product_Description__c,Packaging__c,Select__c from Item__c  where (name IN : lstName)  AND Vendor__c IN : lstVendor  ';    
        
        if(selectedPart != null && selectedPart != ''){
            query += ' AND Product_Description__c =:selectedPart ';
        }
        if(selectedPacking != null && selectedPacking != ''){
            query += ' AND Packaging__c =:selectedPacking ';
        }
        query += ' LIMIT 900 ';
        Boolean ttt = (lstName[0] == 'Test Product');
        System.debug(lstName[0]+'>hfgdhgfhfgdhfdghfdgh>>' +query);
        for(Item__c obj : Database.query(query)) {
            lstResult.add(obj);
        }
        System.debug('>>>>>>>>>>>>>'+lstResult);
    }
    
    public void Search3() {
        lstResult = new List<Item__c >();
        List<String> lstName = new List<String>();
        List<String> lstVendor = new List<String>();
        List<String> lstadd = new List<String>();
       for(String str : selectedProductName.split(','))
           lstName.add(str.remove('[').remove(']'));
            
        for(String str : selectedVendar.split(','))
            lstVendor.add(str.trim().remove('[').remove(']'));
            
        for(String str : SelectedAddress.split(','))
            lstadd.add(str.trim().remove('[').remove(']'));
            
        String query = '';
        query = 'select id,name,Vendor__c,Product_Type__c,Address_Line4__c,city__c,state__c,Zip__c,Product_Description__c,Packaging__c,Select__c from Item__c  where (name IN : lstName)  AND Vendor__c IN : lstVendor  AND Address_Line4__c IN : lstadd  ';    
        
        if(selectedPart != null && selectedPart != ''){
            query += ' AND Product_Description__c =:selectedPart ';
        }
        if(selectedPacking != null && selectedPacking != ''){
            query += ' AND Packaging__c =:selectedPacking ';
        }
        query += ' LIMIT 900 ';
        Boolean ttt = (lstName[0] == 'Test Product');
        System.debug(lstName[0]+'>hfgdhgfhfgdhfdghfdgh>>' +query);
        for(Item__c obj : Database.query(query)) {
            lstResult.add(obj);
        }
    }
    
    public PageReference  save() {
      String oppid =  apexpages.currentpage().getparameters().containsKey('id') ? apexpages.currentpage().getparameters().get('id') : '' ;
      List<Product_Characteristic__c> lst = new List<Product_Characteristic__c>();
      for(Item__c   o :lstResult ) {
          if(o.Select__c) {
              lst.add(new Product_Characteristic__c(Opportunity__c = oppid, Item__c = o.id) );
          }
      }
      if(lst.size() > 0) insert lst;
      PageReference acctPage = new ApexPages.StandardController(new Opportunity__c(id= oppid  )).view();
      acctPage.setRedirect(true);
      return acctPage;
    }
    

}