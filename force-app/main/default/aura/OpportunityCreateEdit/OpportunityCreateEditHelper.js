({
	calculatefunction : function (component, event, helper){
        var a = event.getSource();
        var auraid = a.getLocalId();
        
        
        var UOM = component.find("Unit_of_Measure__c").get("v.value") != undefined ? component.find("Unit_of_Measure__c").get("v.value") : 'LBS' ;
        var inco_term = component.find("Inco_Terms__c").get("v.value") != undefined ? component.find("Inco_Terms__c").get("v.value") : '' ;
        var volume = parseFloat($A.util.isEmpty(component.find("Volume__c").get("v.value")) != true  ? component.find("Volume__c").get("v.value") : 0 );
        var Planned_of_Total_Containers = parseFloat($A.util.isEmpty(component.find("Planned_of_Total_Containers__c").get("v.value")) != true  ? component.find("Planned_of_Total_Containers__c").get("v.value") : 0 );
                
        var fob_field = component.find("FOB_Price_OUT__c").get("v.value") != undefined ? component.find("FOB_Price_OUT__c").get("v.value") : 0 ;
        var fob = parseFloat(UOM == "LBS" ? fob_field : ( fob_field * 2204.6 ));
        var Planned_of_Shipments = parseFloat($A.util.isEmpty(component.find("Planned_of_Shipments__c").get("v.value")) != true  ? component.find("Planned_of_Shipments__c").get("v.value") : 0 );
        
        
            Planned_of_Total_Containers = volume / Planned_of_Shipments ;
            if(UOM == "LBS")
                Planned_of_Total_Containers = Planned_of_Total_Containers /  42000 ;
            else
                Planned_of_Total_Containers = Planned_of_Total_Containers /  19.05 ;
            Planned_of_Total_Containers = Planned_of_Total_Containers.toFixed(0);
       
        console.log('>>>>>>>>>>>>>>>Planned_of_Total_Containers> '+Planned_of_Total_Containers);
                
        var Drayage_Domestic_Inland  = parseFloat($A.util.isEmpty(component.find("Drayage_Domestic_Inland_Fixed__c").get("v.value")) != true  ? component.find("Drayage_Domestic_Inland_Fixed__c").get("v.value") : 0 );
        var Ocean_Freight  = parseFloat($A.util.isEmpty(component.find("Ocean_Freight_Fixed__c").get("v.value")) != true  ? component.find("Ocean_Freight_Fixed__c").get("v.value") : 0 );
        var Dollar_ShipmentFixed = Drayage_Domestic_Inland + Ocean_Freight  ;
        console.log(">>>>>>>16>>>>>>"+Dollar_ShipmentFixed);
        Dollar_ShipmentFixed = Dollar_ShipmentFixed * Planned_of_Total_Containers ;
        Dollar_ShipmentFixed = Dollar_ShipmentFixed.toFixed(4);
        console.log(">>>>>>>18>>>>>>"+Dollar_ShipmentFixed);
        component.find("Dollar_Shipment__c").set("v.value", Dollar_ShipmentFixed );
        var Cross_doc   = parseFloat($A.util.isEmpty(component.find("Cross_doc_per_lb_MT__c").get("v.value")) != true  ? component.find("Cross_doc_per_lb_MT__c").get("v.value") : 0 );
        
        var Pallets  = parseFloat($A.util.isEmpty(component.find("Pallets_per_lb_MT__c").get("v.value")) != true  ? component.find("Pallets_per_lb_MT__c").get("v.value") : 0 );
        var Labels  = parseFloat($A.util.isEmpty(component.find("Labels_per_lb_MT__c").get("v.value")) != true  ? component.find("Labels_per_lb_MT__c").get("v.value") : 0 );
        var Docs  = parseFloat($A.util.isEmpty(component.find("Docs_per_lb_MT__c").get("v.value")) != true  ? component.find("Docs_per_lb_MT__c").get("v.value") : 0 );
        var Cwt  = parseFloat($A.util.isEmpty(component.find("Cwt_per_lb_MT__c").get("v.value")) != true  ? (component.find("Cwt_per_lb_MT__c").get("v.value") * (-1)): 0 );
        var L_C_Bank_Fee  = parseFloat($A.util.isEmpty(component.find("L_C_Bank_Fee_per_lb_MT__c").get("v.value")) != true  ? component.find("Cwt_per_lb_MT__c").get("v.value") : 0 );
        var Agent_commission  = parseFloat($A.util.isEmpty(component.find("Agent_commission_per_lb_MT__c").get("v.value")) != true  ? component.find("Agent_commission_per_lb_MT__c").get("v.value") : 0 );
          
        var Rate  = parseFloat($A.util.isEmpty(component.find("Rate__cFT").get("v.value")) != true  ? component.find("Rate__cFT").get("v.value") : 0 );
        var avg_days  = parseFloat($A.util.isEmpty(component.find("AvgDaysPastDue__c").get("v.value")) != true  ? component.find("AvgDaysPastDue__c").get("v.value") : 0 );
       
        var Dollar_Contract = Planned_of_Shipments * Dollar_ShipmentFixed ;
        var Transport_Subtotal = 0;
        if(volume != 0){
            Transport_Subtotal = parseFloat( Dollar_Contract / volume);
        }
        
        var Transportation_cost_Total  = parseFloat(Transport_Subtotal + Cross_doc );  // parseFloat(Drayage_Domestic_Inland + Cross_doc + Ocean_Freight + Dollar_Shipment) ; 
        var Misc_Costs_Total = parseFloat(Pallets + Labels + Docs + Cwt + L_C_Bank_Fee + Agent_commission) ;
        
        component.find("Dollar_Contract__c").set("v.value",Dollar_Contract.toFixed(4));
        component.find("Transport_Subtotal__c").set("v.value",Transport_Subtotal.toFixed(4));
        
		component.find("TCT").set("v.value",Transportation_cost_Total.toFixed(4));
		component.find("MCT").set("v.value",Misc_Costs_Total.toFixed(4)); 
		 
        component.find("t11").set("v.value",Transportation_cost_Total.toFixed(4));
		component.find("t21").set("v.value",Misc_Costs_Total.toFixed(4));
        
        var Cargo_Insurance = 0.0;
        var Credit_Insurance = 0.0 ;
        var Finance_Costs = 0.0 ;
        
        Credit_Insurance = ( Rate / 100.0) * (fob + Transportation_cost_Total + Misc_Costs_Total) ;
        component.find("t41").set("v.value",(Credit_Insurance).toFixed(4));
        
        if(avg_days > 0 ){
                Finance_Costs =  fob + Transportation_cost_Total + Misc_Costs_Total + Credit_Insurance  ;
                Finance_Costs = Finance_Costs * (avg_days/365) ;
                Finance_Costs = (6.5/100.00) * Finance_Costs ;
            	Finance_Costs = (Finance_Costs).toFixed(4);
        }
        component.find("t51").set("v.value",Finance_Costs);
        
         if(inco_term == 'CIF' || inco_term == 'CIP') {
             Cargo_Insurance += fob;
             Cargo_Insurance += Transportation_cost_Total;
             Cargo_Insurance += Pallets;
             Cargo_Insurance += Cwt;
             Cargo_Insurance += parseFloat(Finance_Costs);
             Cargo_Insurance += parseFloat(Credit_Insurance);
             Cargo_Insurance = 0.003 * Cargo_Insurance ;
        }
       component.find("t31").set("v.value",(Cargo_Insurance).toFixed(4)); 
			
            var totalT = parseFloat(Transportation_cost_Total);
            totalT += parseFloat(Misc_Costs_Total);
            totalT += parseFloat(Credit_Insurance);
            totalT += parseFloat(Cargo_Insurance);
            totalT += parseFloat(Finance_Costs);
       component.find("t61").set("v.value",(totalT).toFixed(4));
        
       totalT += parseFloat(fob);
       console.log(">>>>>>>>>>>>96>>"+totalT);
        console.log(">>>>>>>>>>>>96>>"+auraid);
        
        console.log(">>>>>>>>>>>>96>>"+component.find("Delivered_Eval_UM__c").get("v.value"));
        
        if(component.find("FOB_Price_OUT__c").get("v.value") != undefined && component.find("FOB_Price_OUT__c").get("v.value") > 0 ) {    
            if(auraid == 'FOB_Price_OUT__c' || component.find("Delivered_Eval_UM__c").get("v.value") == '' ){
                if(inco_term == "EXW" || inco_term == 'CPU' || inco_term == 'FRC'   || inco_term == 'T/T'){
                    component.find("Delivered_Price_Calculated__c").set("v.value",fob);
                } else {
                    component.find("Delivered_Price_Calculated__c").set("v.value",(totalT).toFixed(4) );
                }
           } 
       }
        
          if(component.find("Delivered_Price_Calculated__c").get("v.value") != 0 ){
            if(component.find("Delivered_Eval_UM__c").get("v.value") != undefined){
                helper.calculateBackWord(component, event, helper);
            } 
        } 
    },
    
    calculateBackWord :  function (component, event, helper){
        
        var delivered = parseFloat (component.find("Delivered_Eval_UM__c").get("v.value"));
        var UOM = component.find("Unit_of_Measure__c").get("v.value") != undefined ? component.find("Unit_of_Measure__c").get("v.value") : 'LBS' ;
        var inco_term = component.find("Inco_Terms__c").get("v.value") != undefined ? component.find("Inco_Terms__c").get("v.value") : '' ;
		        
        var Rate  = parseFloat($A.util.isEmpty(component.find("Rate__cFT").get("v.value")) != true  ? component.find("Rate__cFT").get("v.value") : 0 );
        var avg_days  = parseFloat($A.util.isEmpty(component.find("AvgDaysPastDue__c").get("v.value")) != true  ? component.find("AvgDaysPastDue__c").get("v.value") : 0 );
       
        var Transportation_cost_Total  = component.find("t11").get("v.value");
        var Misc_Costs_Total = component.find("t21").get("v.value");
        var Pallets  = parseFloat($A.util.isEmpty(component.find("Pallets_per_lb_MT__c").get("v.value")) != true  ? component.find("Pallets_per_lb_MT__c").get("v.value") : 0 );
        var Cwt  = parseFloat($A.util.isEmpty(component.find("Cwt_per_lb_MT__c").get("v.value")) != true  ? (component.find("Cwt_per_lb_MT__c").get("v.value")): 0 );
        var G = 1;
        
        if(inco_term == 'CIF' || inco_term == 'CIP') {
            G = G + 0.003 ;
            G = G + ( (avg_days * 6.5) / 36500 );
            G = G + ( (avg_days * 19.5) / 36500000 );
            G = G + (Rate / 100) ;
            delivered = delivered - (Pallets * 0.003) ;
        	delivered = delivered - (Cwt * 0.003) ;
            
        } else {
            G = G + (avg_days * 6.5) / 36500 ;
            G = G + (Rate / 100) ;
            
        }
        delivered = delivered - (Transportation_cost_Total * G) ;
        
        delivered = delivered - (Misc_Costs_Total * G) ;
        
        var fob =  delivered / G ;
        
        component.find("FOB_Price__c").set("v.value",fob.toFixed(4));
        
         if(inco_term == "EXW" || inco_term == "CPU"  || inco_term == "FRC"  || inco_term == "T/T"){
                component.find("FOB_Price__c").set("v.value",component.find("Delivered_Eval_UM__c").get("v.value"));
         }
        
        if(UOM == "MT"){
            component.find("FOB_Price__c").set("v.value",(fob / 2204.6).toFixed(4)) ;
        }
         
    },
    
    assign : function (component,event, helper,oppval) {
            
        	component.find("Drayage_Domestic_Inland_per_lb_MT__c").set("v.value",oppval["Drayage_Domestic_Inland_per_lb_MT__c"]);
            component.find("Drayage_Domestic_Inland_Fixed__c").set("v.value",oppval["Drayage_Domestic_Inland_Fixed__c"]);
        	component.find("Cross_doc_per_lb_MT__c").set("v.value",oppval["Cross_doc_per_lb_MT__c"]);
            
        	component.find("Ocean_Freight_per_lb_MT__c").set("v.value",oppval["Ocean_Freight_per_lb_MT__c"]);
            component.find("Ocean_Freight_Fixed__c").set("v.value",oppval["Ocean_Freight_Fixed__c"]);
            component.find("Pallets_per_lb_MT__c").set("v.value",oppval["Pallets_per_lb_MT__c"]);
            component.find("Pallets_Fixed__c").set("v.value",oppval["Pallets_Fixed__c"]);
            
        	component.find("Dollar_Shipment__c").set("v.value",oppval["Dollar_Shipment__c"]);
            component.find("Transport_Subtotal__c").set("v.value",oppval["Transport_Subtotal__c"]);
            component.find("Dollar_Contract__c").set("v.value",oppval["Dollar_Contract__c"]);
           
            component.find("Labels_per_lb_MT__c").set("v.value",oppval["Labels_per_lb_MT__c"]);
            component.find("Labels_Fixed__c").set("v.value",oppval["Labels_Fixed__c"]);
            component.find("Docs_per_lb_MT__c").set("v.value",oppval["Docs_per_lb_MT__c"]);
            component.find("Docs_fixed__c").set("v.value",oppval["Docs_fixed__c"]);
            component.find("Cwt_per_lb_MT__c").set("v.value",oppval["Cwt_per_lb_MT__c"]);
            component.find("Cwt_Fixed__c").set("v.value",oppval["Cwt_Fixed__c"]);
            component.find("L_C_Bank_Fee_per_lb_MT__c").set("v.value",oppval["L_C_Bank_Fee_per_lb_MT__c"]);
            component.find("L_C_Bank_Fee_Fixed__c").set("v.value",oppval["L_C_Bank_Fee_Fixed__c"]);
            component.find("Agent_commission_per_lb_MT__c").set("v.value",oppval["Agent_commission_per_lb_MT__c"]);
            component.find("Agent_commission_Fixed__c").set("v.value",oppval["Agent_commission_Fixed__c"]);
            component.find("t11").set("v.value",oppval["Transportation_cost_Total__c"]);
            component.find("t21").set("v.value",oppval["Misc_Costs_Total__c"]);
            component.find("t41").set("v.value",oppval["Credit_Insurance__c"]);
            component.find("t51").set("v.value",oppval["Finance_Costs__c"]);
            component.find("t31").set("v.value",oppval["Cargo_Insurance__c"]);
        	component.find("t61").set("v.value",oppval["Total_Costs"]);
        	component.find("Volume__c").set("v.value",oppval["Volume__c"]);
        	component.find("FOB_Price_OUT__c").set("v.value",oppval["FOB_Price_OUT__c"]);
        	component.find("Delivered_Eval_UM__c").set("v.value",oppval["Delivered_Eval_UM__c"]);
        	component.find("Delivered_Price_Calculated__c").set("v.value",oppval["Delivered_Price_Calculated__c"]);
        	component.find("FOB_Price__c").set("v.value",oppval["FOB_Price__c"]);
    },
    
    reverseassignment: function(component, event, helper,eventFields){
        
        eventFields["Drayage_Domestic_Inland_per_lb_MT__c"] = component.find("Drayage_Domestic_Inland_per_lb_MT__c").get("v.value");
        eventFields["Drayage_Domestic_Inland_Fixed__c"] = component.find("Drayage_Domestic_Inland_Fixed__c").get("v.value");
        eventFields["Cross_doc_per_lb_MT__c"] = component.find("Cross_doc_per_lb_MT__c").get("v.value");
        
        eventFields["Ocean_Freight_per_lb_MT__c"] = component.find("Ocean_Freight_per_lb_MT__c").get("v.value");
        eventFields["Ocean_Freight_Fixed__c"] = component.find("Ocean_Freight_Fixed__c").get("v.value");
        
        eventFields["Dollar_Shipment__c"] = component.find("Dollar_Shipment__c").get("v.value");
        eventFields["Transport_Subtotal__c"] = component.find("Transport_Subtotal__c").get("v.value");
        eventFields["Dollar_Contract__c"] = component.find("Dollar_Contract__c").get("v.value");
        
        eventFields["Pallets_per_lb_MT__c"] = component.find("Pallets_per_lb_MT__c").get("v.value");
        eventFields["Pallets_Fixed__c"] = component.find("Pallets_Fixed__c").get("v.value");
        eventFields["Labels_per_lb_MT__c"] = component.find("Labels_per_lb_MT__c").get("v.value");
        eventFields["Labels_Fixed__c"] = component.find("Labels_Fixed__c").get("v.value");
        eventFields["Docs_per_lb_MT__c"] = component.find("Docs_per_lb_MT__c").get("v.value");
        eventFields["Docs_fixed__c"] = component.find("Docs_fixed__c").get("v.value");
        eventFields["Cwt_per_lb_MT__c"] = component.find("Cwt_per_lb_MT__c").get("v.value");
        eventFields["Cwt_Fixed__c"] = component.find("Cwt_Fixed__c").get("v.value");
        eventFields["L_C_Bank_Fee_per_lb_MT__c"] = component.find("L_C_Bank_Fee_per_lb_MT__c").get("v.value");
        eventFields["L_C_Bank_Fee_Fixed__c"] = component.find("L_C_Bank_Fee_Fixed__c").get("v.value");
        eventFields["Agent_commission_per_lb_MT__c"] = component.find("Agent_commission_per_lb_MT__c").get("v.value");
        eventFields["Agent_commission_Fixed__c"] = component.find("Agent_commission_Fixed__c").get("v.value");
        eventFields["Transportation_cost_Total__c"] = component.find("t11").get("v.value");
        eventFields["Misc_Costs_Total__c"] = component.find("t21").get("v.value");
        eventFields["Credit_Insurance__c"] = component.find("t41").get("v.value");
        eventFields["Finance_Costs__c"] = component.find("t51").get("v.value");
        eventFields["Cargo_Insurance__c"] = component.find("t31").get("v.value");
        eventFields["Volume__c"] = component.find("Volume__c").get("v.value");
        if(component.get("v.selectedChildAccount").Id != undefined)
        	eventFields["Account__c"] = component.get("v.selectedChildAccount").Id;
        if(component.get("v.selectedDestination").Id != undefined)
        	eventFields["Destination_Location__c"] = component.get("v.selectedDestination").Id;
        eventFields["Total_Costs__c"] = component.find("t61").get("v.value");
        
        eventFields["FOB_Price_OUT__c"] = component.find("FOB_Price_OUT__c").get("v.value");
        eventFields["Delivered_Eval_UM__c"] = component.find("Delivered_Eval_UM__c").get("v.value");
        eventFields["Delivered_Price_Calculated__c"] = component.find("Delivered_Price_Calculated__c").get("v.value");
        eventFields["FOB_Price__c"] = component.find("FOB_Price__c").get("v.value");
       
        if(component.find("Delivered_Eval_UM__c").get("v.value") == ""){
        	eventFields["Delivered_Eval_UM__c"] = null ;
            eventFields["FOB_Price__c"] = null ;
        }
        
        if(component.find("FOB_Price_OUT__c").get("v.value") == ""){
        	eventFields["FOB_Price_OUT__c"] = null ;
            eventFields["Delivered_Price_Calculated__c"] = null ;
        }
        
    },
    
    assignLookupdetails : function (component, event, helper) {
    	var accid = component.find("Account__cFT").get("v.value");
        console.log(">>>>>>>>>241>>>>>"+accid);
        if(accid != undefined ){
            $A.util.addClass( component.find("accountcls") , 'slds-hide');
            $A.util.removeClass( component.find("accountSH")  , 'slds-hide' );
            helper.assignLookupdetailsLocation(component, event, helper);
        } else {
            component.find("Account__cFT").set("v.value", component.get("v.accid"));
            if(component.get("v.accid") != undefined){
            	$A.util.addClass( component.find("accountcls") , 'slds-hide');
            	$A.util.removeClass( component.find("accountSH")  , 'slds-hide' );    
            }
            helper.assignLookupdetailsLocation(component, event, helper);
        }
	},
    
    assignLookupdetailsLocation : function (component, event, helper) {
        var destid = component.find("Destination_Location__cFT").get("v.value");
        if( destid != undefined ){
            $A.util.addClass( component.find("destinationcls") , 'slds-hide');
            $A.util.removeClass( component.find("destinationSH")  , 'slds-hide' );
        } else {
            component.find("Destination_Location__cFT").set("v.value", component.get("v.destid"));
            if(component.get("v.destid") != undefined ) {
                $A.util.addClass( component.find("destinationcls") , 'slds-hide');
            	$A.util.removeClass( component.find("destinationSH")  , 'slds-hide' );
            }
        }
    }
})