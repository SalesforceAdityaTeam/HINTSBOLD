({
    handleActive: function (cmp, event) {
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case 'trading' :
                this.injectComponent('c:trading', tab);
                break;
            case 'techno' :
                this.injectComponent('c:techno', tab);
                break;
            case 'logistics':
                this.injectComponent('c:logistics', tab);
                break;
            case 'finance':
                this.injectComponent('c:finance', tab);
                break;
            case 'accountss' :
                this.injectComponent('c:accountss', tab);
                break;
            case 'address':
                this.injectComponent('c:address', tab);
                break;
            case 'more':
                this.injectComponent('c:more', tab);
                break;
        }
    },
    injectComponent: function (name, target) {
        $A.createComponent(name, {
           
        }, function (contentComponent, status, error) {
            if (status === "SUCCESS") {
                target.set('v.body', contentComponent);
            } else {
                throw new Error(error);
            }
        });
    }
    ,
    Trade: function(component, event, helper){
    },
    Logistics: function(component, event, helper){
        var cmpTarge=component.find("Logistics_Category__c");
        
        var set1 =component.find("Additional_Label_each_Package__c");
        var set2 =component.find("Additional_Label_each_Pallet__c");
        var set3=component.find("Any_Storage_Transport_Conditions__c");
        var set4=component.find("Requirements_on_Un_loading_Hrs__c");
        var set5=component.find("Country_Requirements__c");
        var set6=component.find("Legalizations_by_CoC__c");
        var set7=component.find("Free_time_at_POD_for_this_customer__c");
        var set8=component.find("Required_Items_Inside_Container__c");
        var set9=component.find("Special_Shipping_Line_Requirements__c");
        var ste10 =  component.find("Any_Technical_Document_for_each_Loading__c");
        if(cmpTarge!= undefined){
            if(cmpTarge!=undefined && cmpTarge.get("v.value")=='EU'){
               component.set("v.logsv",false);
               component.set("v.logvar",true);
            }
           
            if(cmpTarge!=undefined && (cmpTarge.get("v.value")=='Export' || cmpTarge.get("v.value")=='EU & Export')){
                component.set("v.logvar",false);
                component.set("v.logsv",true);
            } 
            if(set1!=undefined && set1.get("v.value")=='No'){
                component.set("v.var2",false);
            	component.set("v.var1",false);
                helper.setDisplayOrHidden(component,set1);
            }
            if(set1!=undefined && set1.get("v.value")=='Yes'){
                component.set("v.var1",true);
                component.set("v.var2",false);
            }
            if(set1!=undefined && set1.get("v.value")=='Maybe'){
                component.set("v.var1",false);
                component.set("v.var2",true);
            }
            if(set2!=undefined && set2.get("v.value")=='No'){
            component.set("v.var3",false);
                helper.setDisplayOrHidden(component,set2);
            }
            if(set2!=undefined && set2.get("v.value")=='Yes'){
                component.set("v.var4",false);
                component.set("v.var3",true);
            }
            if(set2!=undefined && set2.get("v.value")=='Maybe'){
                component.set("v.var4",true);
            }
            
            if(set3!=undefined && set3.get("v.value")=='Yes'){
                component.set("v.var5",true);
            }
             if(set3!=undefined && set3.get("v.value")=='Maybe'){
                component.set("v.var5",true);
            }
            if(set3!=undefined && set3.get("v.value")=='No'){
                component.set("v.var5",false);
                helper.setDisplayOrHidden(component,set3);
            }
            if(set4!=undefined && set4.get("v.value")=='Yes'){
                component.set("v.var6",true);
            }
            if(set4!=undefined && set4.get("v.value")=='Maybe'){
                component.set("v.var6",true);
            }
            if(set4!=undefined && set4.get("v.value")=='No'){
                component.set("v.var6",false);
                helper.setDisplayOrHidden(component,set4);
            }
            if(set5!=undefined && set5.get("v.value")=='Yes'){
                component.set("v.var7",true);
            }
            if(set5!=undefined && set5.get("v.value")=='Maybe'){
                component.set("v.var7",true);
            }
            if(set5!=undefined && set5.get("v.value")=='No'){
                component.set("v.var7",false);
                helper.setDisplayOrHidden(component,set5);
            }
            if(set6!=undefined && set6.get("v.value")=='Yes'){
                component.set("v.var8",true);
            }
            if(set6!=undefined && set6.get("v.value")=='No'){
                component.set("v.var8",false);
                helper.setDisplayOrHidden(component,set6);
            }
            if(set7!=undefined && set7.get("v.value")=='Yes'){
                component.set("v.var9",true);
            }
            if(set7!=undefined && set7.get("v.value")=='No'){
                component.set("v.var9",false);
                helper.setDisplayOrHidden(component,set7);
            }
            if(set8!=undefined && set8.get("v.value")=='Yes'){
                component.set("v.var10",true);
            }
            if(set8!=undefined && set8.get("v.value")=='No'){
                component.set("v.var10",false);
                helper.setDisplayOrHidden(component,set8);
            }
            if(set9!=undefined && set9.get("v.value")=='Yes'){
                component.set("v.var11",true);
            }
            if(set9!=undefined && set9.get("v.value")=='No'){
                component.set("v.var11",false);
                helper.setDisplayOrHidden(component,set9);
            }
            if(ste10 != undefined && ste10.get("v.value") != null  ){
                var varlist = ste10.get("v.value").split(';');
                if(varlist.indexOf('other') > -1)
                	component.set("v.other",true);
                else
                    component.set("v.other",false);
            }
        }
    },
    Techno: function(component, event, helper){
        var GFSI_Certificate_Required=component.find("GFSI_Certificate_Required__c").get("v.value");
        var GMP_Certificate_Required=component.find("GMP_Certificate_Required__c").get("v.value");
        var Halal_Certificate_Required=component.find("Halal_Certificate_Required__c").get("v.value");
        var Kosher_Certificate_Required=component.find("Kosher_Certificate_Required__c").get("v.value");
        var Organic_Certificate_Required=component.find("Organic_Certificate_Required__c").get("v.value");
        var Vlog_Certificate_Required=component.find("Vlog_Certificate_Required__c").get("v.value");
        var Origin_Certificate_Required=component.find("Origin_Certificate_Required__c").get("v.value");
        var Customer_Buying_Specification_Present=component.find("Customer_Buying_Specification_Present__c").get("v.value");
        var Specimen_CoA=component.find("Specimen_CoA__c").get("v.value");
        var Additives=component.find("Additives__c").get("v.value");
        
        if(GFSI_Certificate_Required!=undefined && GFSI_Certificate_Required!='Yes'){
            component.set("v.variable1",false);
        }
        if(GFSI_Certificate_Required!=undefined && GFSI_Certificate_Required!='No'){
            component.set("v.variable1",true);
        }
        if(GMP_Certificate_Required!=undefined && GMP_Certificate_Required!='Yes'){
            component.set("v.variable2",false);
        }
        if(GMP_Certificate_Required!=undefined && GMP_Certificate_Required!='No'){
            component.set("v.variable2",true);
        }
        if(Halal_Certificate_Required!=undefined && Halal_Certificate_Required!='Yes'){
            component.set("v.variable3",false);
        }
        if(Halal_Certificate_Required!=undefined && Halal_Certificate_Required!='No'){
            component.set("v.variable3",true);
        }
        if(Kosher_Certificate_Required!=undefined && Kosher_Certificate_Required!='Yes'){
            component.set("v.variable4",false);
        }
        if(Kosher_Certificate_Required!=undefined && Kosher_Certificate_Required!='No'){
            component.set("v.variable4",true);
        }
        if(Organic_Certificate_Required!=undefined && Organic_Certificate_Required!='Yes'){
            component.set("v.variable5",false);
        }
        if(Organic_Certificate_Required!=undefined && Organic_Certificate_Required!='No'){
            component.set("v.variable5",true);
        }
        if(Vlog_Certificate_Required!=undefined && Vlog_Certificate_Required!='Yes'){
            component.set("v.variable6",false);
        }
        if(Vlog_Certificate_Required!=undefined && Vlog_Certificate_Required!='No'){
            component.set("v.variable6",true);
        }
        if(Origin_Certificate_Required!=undefined && Origin_Certificate_Required!='Yes'){
            component.set("v.variable7",false);
        }
        if(Origin_Certificate_Required!=undefined && Origin_Certificate_Required!='No'){
            component.set("v.variable7",true);
        }
        if(Customer_Buying_Specification_Present!=undefined &&  Customer_Buying_Specification_Present!='Yes'){
            component.set("v.variable8",false);
        }
        if(Customer_Buying_Specification_Present!=undefined &&  Customer_Buying_Specification_Present!='No'){
            component.set("v.variable8",true);
        }
        if(Specimen_CoA!=undefined &&  Specimen_CoA!='Yes'){
            component.set("v.variable9",false);
        }
        if(Specimen_CoA!=undefined &&  Specimen_CoA!='No'){
            component.set("v.variable9",true);
        }
        if(Additives!=undefined && Additives=='Yes'){
            component.set("v.var12",true);
        }
        if(Additives!=undefined && Additives=='No'){
            component.set("v.var12",false);
        }
    },
    Finance: function(component, event, helper){  
    },
    Summary: function(component, event, helper){
        
    },
    Address: function(component, event, helper){
        
    },
    setDisplayOrHidden : function(component,fieldId ){
      /*  var IsEdit = component.get("v.IsEdit");
        alert(IsEdit);
        if(!IsEdit){
            $A.util.addClass(fieldId, 'slds-hide');
        }else{
            $A.util.removeClass(fieldId, 'slds-hide');
        }
        */
    },
    presetDataValue : function(component,isCheck ) {
	    var action = component.get("c.preSetValue");
        action.setParams({
            varId: component.get("v.recordId"),
            lstProd: component.get("v.lstProducts")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS") {
                component.set("v.lstProducts", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                if(response.getReturnValue().length == 0){
                    toastEvent.setParams({
                        message: 'No record found, try another search.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'Warning',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
	},
    savedata : function(component) {
        var isCheck = false;
        var str = JSON.stringify(component.get("v.lstProducts"));
	    var action = component.get("c.saveLineItem");
        action.setParams({
            varId: component.get("v.recordId"),
            lstProd : component.get("v.lstProducts")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS") {                
                var offer = response.getReturnValue();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": offer,
                    "slideDevName" : "detail"
                });
                navEvt.fire();
            }
        });
        $A.enqueueAction(action);
	},
    removeDataValue : function(component,rowId) {
        var action = component.get("c.removeLineItem");
        action.setParams({
            lstProd : component.get("v.lstProducts"),
            rowId : rowId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS") {   
                component.set("v.lstProducts", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Record deleted',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'Warning',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
              
            }
        });
        $A.enqueueAction(action);
	},
    addOneMOreValue : function(component,rowId) {
        var action = component.get("c.addOneMOreValue");
        action.setParams({
            lstProd : component.get("v.lstProducts"),
            rowId : rowId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.spinner", false);
            if (state === "SUCCESS") {   
                component.set("v.lstProducts", response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Record Added',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'Warning',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
              
            }
        });
        $A.enqueueAction(action);
	},
});