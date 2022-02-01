@isTest
private class OpportunityTriggerTest  {

    private static testMethod void test() {
        
        Account acc = new Account(
            name = 'Test account',
            RecordTypeId  = Schema.SObjectType.account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
             BillingCountry = 'Test' , ShippingCountry = 'Test'
            );
        INSERT acc;
        
        Contact con = new Contact(lastName = 'asdasdas',
        AccountId = acc.id
        );
        INSERT con;
        
        Credit_Insurance_Rate__c CI = new Credit_Insurance_Rate__c(Name = 'Test', Rate__c  = 1.5 );
        INSERT CI;
        
        Origin__c ori = new Origin__c();
        ori.Name = 'Test';
        Ori.Copypaste_Data__c = 'Test';
        Ori.Country__c = 'Test';
        Ori.Location__c = 'Test';
        Ori.Name__c = 'Test';
        Ori.NameWoDiacritics__c = 'Test';
        Ori.Subdivision__c = 'Test';
        Ori.UNCode__c = 'Test';
        Ori.UNFunction__c = 'Test';
        INSERT ori;
        
        Location__c loc = new Location__c(
            name = 'asdasd',
            UNCode__c = 'asdas',
            UNCodeFunction__c = 'asdasd',
            addrline1__c = 'asdasda',
            addrline5__c ='Test'
        );
        INSERT loc;
        
        Opportunity__c opp = new Opportunity__c();
        Opp.Contact__c = con.Id;
        Opp.Account__c = acc.id;
        Opp.Product_Group__c = 'Buttermilk';
       /* Opp.Product_Description__c   = 'Buttermilk'; */
        Opp.Brand__c = 'AMPI';
        Opp.Packaging2__c = '25KG';
        Opp.Volume__c = 50;
        Opp.Unit_of_Measure__c = 'MT';
        Opp.Stage__c = 'WIP';
        Opp.Inco_Terms__c = 'CIF';
        Opp.Planned_of_Shipments__c = 50;
        Opp.Date_Quoted__c = System.now();
        opp.Sales_Order_Num__c = 'ghfghfgh';
        Opp.Planned_of_Total_Containers__c = 546;
        Opp.IndexPrice__c = 'asdasd';
        Opp.FOB_Price_OUT__c = 500;
        Opp.Destination_Location__c = loc.id;
        INSERT Opp;
        
        Opp.FOB_Price_OUT__c = 505;
        Opp.Delivered_Price__c = 505;
        update opp;
        
        
        
    }

}