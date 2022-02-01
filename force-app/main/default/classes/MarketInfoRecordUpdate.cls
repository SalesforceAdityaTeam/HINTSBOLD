global class MarketInfoRecordUpdate implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          
          Map<String,String> labelAPI = new Map<String,String>();
          for(MarketEmailServiceFields__c objCS : [select id,name,Label__c from MarketEmailServiceFields__c]) {
              labelAPI.put(objCS.Label__c,objCS.name);
          }
          System.debug('>>>>>>>>>>>>'+email.htmlBody);
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          XmlStreamReader r = new XmlStreamReader(email.htmlBody);
          Integer retry = 0;
          Boolean inRow = false, inCol = false;
          String Key='',val='';
          Map<String,String> mapstring = new Map<String,String>();
          
            while(r.hasNext() && retry < 3) {
                try {
                    r.next();
                    retry = 0;
                    if(r.geteventtype()==xmltag.start_element && r.getlocalname()=='tr') { 
                        inRow = true;
                    }
                    if(r.geteventtype()==xmltag.end_element && r.getlocalname()=='tr') {
                        inrow = incol = false;if(Key!='') mapstring.put(key,val);Key='';val='';
                    }
                    if(r.geteventtype()==xmltag.start_element && r.getlocalname()=='td') {
                        incol = true;
                    }
                    if(r.geteventtype()==xmltag.end_element && r.getlocalname()=='td') {
                        incol = false;
                    }
                    if(inRow && inCol && r.geteventtype()==xmltag.characters) {
                        if(Key != '')
                            val = r.gettext();
                        else 
                            key = r.gettext();
                    }
                } catch(exception e) {
                    retry++;
                }
            }
        String recordId = '';
        for(String s : email.plainTextBody.split('\n')){
            if(s.contains('https://na132.salesforce.com/')){
                recordId = s.remove('Record Id:- https://na132.salesforce.com/'); for (String str : recordId.split(' ')){if(str.length() == 18){ recordId = str; }
        }}}
        Market_Information__c obj = new Market_Information__c();
        obj.put('id',recordId);
        for(String str : mapstring.keySet()) {
            obj.put(labelAPI.get(str),mapstring.get(str)!=null ? mapstring.get(str) : ''); 
        }
        try{update obj;}catch(Exception ex){System.debug('Exception'+ex);} 
        return result; 
      }
}