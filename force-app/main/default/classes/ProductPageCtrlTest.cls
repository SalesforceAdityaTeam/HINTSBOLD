@isTest(SeeAllData=true)
public Class ProductPageCtrlTest {

    public static TestMethod void test1() {
        Opportunity__c t = [select id from Opportunity__c LIMIT 1];
        ProductPageCtrl OBJ = NEW ProductPageCtrl();
        obj.init();
        obj.populateData();
        obj.selectedProductName = 'SKCON SKIM CONDENSED';
        obj.selectedVendar = 'LONESTAR DA';
        obj.selectedPart= 'Fluids LSDP';
        obj.selectedPacking  = 'BULK';
        obj.SelectedAddress = 'TX';
        obj.Search();
        obj.Search3();
        ApexPages.currentPage().getParameters().put('id',t.Id);
        obj.save();
        
    }
}