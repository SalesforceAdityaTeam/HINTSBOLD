trigger ApprovalTrigger on Approval__c (after insert) {
    Set<Id> ids=new Set<Id>();
    for(Approval__c app:Trigger.new){
        ids.add( app.Id );
    }
    System.debug('Test in trigger');
    List<Approval__c> approval=[SELECT ID,Name,Customer_or_Prospect_Company_Name__r.Additional_Info_on_Halal_Certificate__c, Customer_or_Prospect_Company_Name__r.Aflatoxin_M1__c, Customer_or_Prospect_Company_Name__r.Allergen_declaration__c,	Customer_or_Prospect_Company_Name__r.Antibiotics__c,	Customer_or_Prospect_Company_Name__r.Customer_Buying_Specification_Present__c,	Customer_or_Prospect_Company_Name__r.Additives__c,	Customer_or_Prospect_Company_Name__r.Environmental_Sustainable_Requirements__c,	Customer_or_Prospect_Company_Name__r.Ethical__c,	Customer_or_Prospect_Company_Name__r.Free_from_irradiation__c,	Customer_or_Prospect_Company_Name__r.Free_from_veterinary_disease__c,	Customer_or_Prospect_Company_Name__r.GFSI_Certificate__c,	Customer_or_Prospect_Company_Name__r.GFSI_Certificate_Required__c,	Customer_or_Prospect_Company_Name__r.GMO_Free_statement__c,Customer_or_Prospect_Company_Name__r.GMP__c,	Customer_or_Prospect_Company_Name__r.GMP_Certificate_Required__c,	Customer_or_Prospect_Company_Name__r.HACCP_Flow_diagram_incl_CCP__c,	Customer_or_Prospect_Company_Name__r.Halal__c,	Customer_or_Prospect_Company_Name__r.Halal_Certificate_Required__c,	Customer_or_Prospect_Company_Name__r.Heavy_metals__c,	Customer_or_Prospect_Company_Name__r.Kosher__c,	Customer_or_Prospect_Company_Name__r.Kosher_Certificate_Required__c,Customer_or_Prospect_Company_Name__r.Melamine__c,Customer_or_Prospect_Company_Name__r.Microbiological_control_plan__c,Customer_or_Prospect_Company_Name__r.MSDS_Item__c,Customer_or_Prospect_Company_Name__r.No_growth_promotors__c,Customer_or_Prospect_Company_Name__r.Organic__c,Customer_or_Prospect_Company_Name__r.Organic_Certificate_Required__c,Customer_or_Prospect_Company_Name__r.Origin_Requirement__c,	Customer_or_Prospect_Company_Name__r.Packaging_compliance_food_grade__c,	Customer_or_Prospect_Company_Name__r.Pesticides_incl_dioxins__c,	Customer_or_Prospect_Company_Name__r.Photo_s_item_unit_incl_prints__c,	Customer_or_Prospect_Company_Name__r.Specimen_CoA__c,	Customer_or_Prospect_Company_Name__r.Traceability_control_plan__c,	Customer_or_Prospect_Company_Name__r.Vegetarian__c,	Customer_or_Prospect_Company_Name__r.VLOG__c,	Customer_or_Prospect_Company_Name__r.Vlog_Certificate_Required__c,	Customer_or_Prospect_Company_Name__r.Where_Can_I_find_Copy_of_it__c from Approval__c where id=:ids];
    List<Account_Approval_Deep__c> accAppDeep = new List<Account_Approval_Deep__c>();
    for(Approval__c app:approval){
        System.debug('Coming Inside');
        System.debug(app.Customer_or_Prospect_Company_Name__r.Allergen_declaration__c);
        System.debug(app.Name);
        accAppDeep.add(new Account_Approval_Deep__c(Approval__c=app.Id,
                                                    Name=app.Name,
                                                Additional_Info_on_Halal_Certificate__c = app.Customer_or_Prospect_Company_Name__r.Additional_Info_on_Halal_Certificate__c,
                                                Aflatoxin_M1__c = app.Customer_or_Prospect_Company_Name__r.Aflatoxin_M1__c,
                                                Allergen_declaration__c = app.Customer_or_Prospect_Company_Name__r.Allergen_declaration__c,
                                                 Antibiotics__c= app.Customer_or_Prospect_Company_Name__r.Antibiotics__c,
                                                 Customer_Buying_Specification_Present__c= app.Customer_or_Prospect_Company_Name__r.Customer_Buying_Specification_Present__c,
                                                 Customer_Require_Additives__c= app.Customer_or_Prospect_Company_Name__r.Additives__c,
                                                Environmental_Sustainable_Requirements__c = app.Customer_or_Prospect_Company_Name__r.Environmental_Sustainable_Requirements__c,
                                                 Ethical__c= app.Customer_or_Prospect_Company_Name__r.Ethical__c,
                                                Free_from_irradiation__c = app.Customer_or_Prospect_Company_Name__r.Free_from_irradiation__c,
                                                Free_from_veterinary_disease__c = app.Customer_or_Prospect_Company_Name__r.Free_from_veterinary_disease__c,
                                                GFSI_Certificate__c = app.Customer_or_Prospect_Company_Name__r.GFSI_Certificate__c,
                                                GFSI_Certificate_Required__c = app.Customer_or_Prospect_Company_Name__r.GFSI_Certificate_Required__c,
                                                GMO_Free_statement__c = app.Customer_or_Prospect_Company_Name__r.GMO_Free_statement__c,
                                                GMP__c = app.Customer_or_Prospect_Company_Name__r.GMP__c,
                                                GMP_Certificate_Required__c = app.Customer_or_Prospect_Company_Name__r.GMP_Certificate_Required__c,
                                                HACCP_Flow_diagram_incl_CCP__c = app.Customer_or_Prospect_Company_Name__r.HACCP_Flow_diagram_incl_CCP__c,
                                                Halal__c = app.Customer_or_Prospect_Company_Name__r.Halal__c,
                                                Halal_Certificate_Required__c = app.Customer_or_Prospect_Company_Name__r.Halal_Certificate_Required__c,
                                                Heavy_metals__c = app.Customer_or_Prospect_Company_Name__r.Heavy_metals__c,
                                               Kosher__c  = app.Customer_or_Prospect_Company_Name__r.Kosher__c,
                                                Kosher_Certificate_Required__c = app.Customer_or_Prospect_Company_Name__r.Kosher_Certificate_Required__c,
                                                Melamin__c = app.Customer_or_Prospect_Company_Name__r.Melamine__c,
                                                Microbiological_control_plan__c = app.Customer_or_Prospect_Company_Name__r.Microbiological_control_plan__c,
                                                MSDS_Item__c = app.Customer_or_Prospect_Company_Name__r.MSDS_Item__c,
                                                No_growth_promotors__c = app.Customer_or_Prospect_Company_Name__r.No_growth_promotors__c,
                                                Organic__c = app.Customer_or_Prospect_Company_Name__r.Organic__c,
                                                Organic_Certificate_Required__c = app.Customer_or_Prospect_Company_Name__r.Organic_Certificate_Required__c,
                                                Origin_Requirement__c = app.Customer_or_Prospect_Company_Name__r.Origin_Requirement__c,
                                                Packaging_compliance_food_grade__c = app.Customer_or_Prospect_Company_Name__r.Packaging_compliance_food_grade__c,
                                                Pesticides_incl_dioxins__c = app.Customer_or_Prospect_Company_Name__r.Pesticides_incl_dioxins__c,
                                                Photo_s_item_unit_incl_prints__c = app.Customer_or_Prospect_Company_Name__r.Photo_s_item_unit_incl_prints__c,
                                                Specimen_CoA__c = app.Customer_or_Prospect_Company_Name__r.Specimen_CoA__c,
                                                Traceability_control_plan__c = app.Customer_or_Prospect_Company_Name__r.Traceability_control_plan__c,
                                                Vegetarian__c = app.Customer_or_Prospect_Company_Name__r.Vegetarian__c,
                                                VLOG__c = app.Customer_or_Prospect_Company_Name__r.VLOG__c,
                                                Vlog_Certificate_Required__c = app.Customer_or_Prospect_Company_Name__r.Vlog_Certificate_Required__c,
                                                Where_Can_I_find_Copy_of_it__c = app.Customer_or_Prospect_Company_Name__r.Where_Can_I_find_Copy_of_it__c
                                               ));
    }
    Insert accAppDeep;
}