({
	handleCreateLoad: function (component, event, helper) {
        var datavar = component.get("v.recordId");
        var action = component.get("c.getOpcoValues");
        action.setParams({
            "VarId": datavar
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS") {
                var d = JSON.stringify(response.getReturnValue());
                component.set("v.objData", response.getReturnValue());
                var objdata = component.get("v.objData");
                component.find("EntityCompany__c").set("v.value", objdata.EntityCompany__c );
                component.find("Related_AddressNumber__c").set("v.value", objdata.Related_AddressNumber__c );
                component.find("accmcredit_limit__c").set("v.value", objdata.accmcredit_limit__c );
                component.find("BillingAddressType__c").set("v.value", objdata.BillingAddressType__c );
                component.find("HoldInvoices__c").set("v.value", objdata.HoldInvoices__c );
                component.find("CreditHoldExempt__c").set("v.value", objdata.CreditHoldExempt__c );
                component.find("AR_Terms__c").set("v.value", objdata.AR_Terms__c );
                component.find("FreightHandlingCode__c").set("v.value", objdata.FreightHandlingCode__c );
                component.find("Ext_SFAccCusNum__c").set("v.value", objdata.Ext_SFAccCusNum__c );
                component.find("Date_LastCreditReview__c").set("v.value", objdata.Date_LastCreditReview__c );
                component.find("DefaultAddress__c").set("v.value", objdata.DefaultAddress__c );
                component.find("CustomerCurrencyCode_ABAmounts__c").set("v.value", objdata.CustomerCurrencyCode_ABAmounts__c );
                component.find("PaymentTermsCode__c").set("v.value", objdata.PaymentTermsCode__c );
                component.find("accmdate_created__c").set("v.value", objdata.accmdate_created__c );
                }
            }
        );
        $A.enqueueAction(action);
    }
})