trigger BPFTrigger on BPF__c (After Update, before update) {
        
        
         
        BPF__c OBJbpf = Trigger.new[0];
        if(Trigger.IsUpdate) {
            if(Trigger.IsAfter) {
                if(OBJbpf.Stage__c == 'BPF Signed' && Trigger.oldMap.get(OBJbpf.Id).Stage__c != 'BPF Signed' ){
                    GenerateFileName.RunFromTrigger(OBJbpf.Id);
                }
            }
            
            if(Trigger.IsBefore){
                 Id USERID = [select id,name,profile.name from user where name = 'Customer Form Site Guest User'][0].Id;
                 Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Active_Contact').getRecordTypeId();
                 
         
            if(OBJbpf.LastModifiedById != USERID ){
                
                List<Contact> UBOContact = new List<Contact>();
            
                if( OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c != NULL &&  OBJbpf.UBO_1__c == NULL ){
                    UBOContact.add(new Contact(
                       // Id = mapContactIdUBO.containsKey(OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c) ? mapContactIdUBO.get(OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c) : null,
                        FirstName = ( OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c.split(' ')[0] : '' ) , 
                        LastName =  ( OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c.split(' ')[1] : OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c ) , 
                        Title = 'UBO', 
                        AccountId = objBPF.ParentAccID__c,
                        RecordTYpeId = ContactRecordTypeId
                    ));
                }
                if( OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c != NULL &&  OBJbpf.UBO_2__c == NULL){
                    UBOContact.add(new Contact(
                      //  Id = mapContactIdUBO.containsKey(OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c) ? mapContactIdUBO.get(OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c) : null,
                        FirstName = ( OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c.split(' ')[0] : '' ) , 
                        LastName =  ( OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c.split(' ')[1] : OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c ) , 
                        Title = 'UBO', 
                        AccountId = objBPF.ParentAccID__c,
                        RecordTYpeId = ContactRecordTypeId
                    ));
                }
                if( OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c != NULL &&  OBJbpf.UBO_3__c == NULL){
                    UBOContact.add(new Contact(
                      //  Id = mapContactIdUBO.containsKey(OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c) ? mapContactIdUBO.get(OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c) : null,
                        FirstName = ( OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c.split(' ')[0] : '' ) , 
                        LastName =  ( OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c.split(' ')[1] : OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c ) , 
                        Title = 'UBO', 
                        AccountId = objBPF.ParentAccID__c,
                        RecordTYpeId = ContactRecordTypeId
                    ));
                }
                if( OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c != NULL &&  OBJbpf.UBO_4__c == NULL){
                UBOContact.add(new Contact(
                   // Id = mapContactIdUBO.containsKey(OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c) ? mapContactIdUBO.get(OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c) : null,
                    FirstName = ( OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c.split(' ')[0] : '' ) , 
                    LastName =  ( OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c.split(' ').size() > 1 ? OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c.split(' ')[1] : OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c ) , 
                    Title = 'UBO', 
                    AccountId = objBPF.ParentAccID__c,
                    RecordTYpeId = ContactRecordTypeId
                ));
                }
                if(UBOContact.size() > 0)
                     INSERT UBOContact;
                List<BPFContact__c> lstBPFCON = new List<BPFContact__c>();
                for(Contact objconVal : UBOContact){
                
                    if(OBJbpf.Ultimate_Beneficial_Owner_UBO_1__c == (objconVal.FIrstName +' ' + objconVal.LastName) ){
                        OBJbpf.UBO_1__c = objconVal.Id ;  lstBPFCON.add(new BPFContact__c(Contact__c = objconVal.Id , BPF__c = OBJbpf.Id));
                    }
                    if(OBJbpf.Ultimate_Beneficial_Owner_UBO_2__c == (objconVal.FIrstName +' ' + objconVal.LastName) ){
                        OBJbpf.UBO_2__c = objconVal.Id ; lstBPFCON.add(new BPFContact__c(Contact__c = objconVal.Id , BPF__c = OBJbpf.Id));
                    }
                    if(OBJbpf.Ultimate_Beneficial_Owner_UBO_3__c == (objconVal.FIrstName +' ' + objconVal.LastName) ){
                        OBJbpf.UBO_3__c = objconVal.Id ; lstBPFCON.add(new BPFContact__c(Contact__c = objconVal.Id , BPF__c = OBJbpf.Id));
                    }
                    if(OBJbpf.Ultimate_Beneficial_Owner_UBO_4__c == (objconVal.FIrstName +' ' + objconVal.LastName) ){
                        OBJbpf.UBO_4__c = objconVal.Id ; lstBPFCON.add(new BPFContact__c(Contact__c = objconVal.Id , BPF__c = OBJbpf.Id));
                    }
                }
                
                IF(lstBPFCON.size() > 0 )
                    INSERT lstBPFCON;
            }
        }
        }
            
}