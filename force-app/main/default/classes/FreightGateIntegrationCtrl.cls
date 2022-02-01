public class FreightGateIntegrationCtrl {
    
    public Id OppId;
    String Unit_of_Measure ;
    Static String URL;
    Static String sessionId;
    Static String Origin;
    Static string Destination;
    Static String originType = 'any';
    Static String destinationType = 'any';
    Static String totalContainers = null;
    Static String productGroup = null ;
    Opportunity__c Opp;
    
    List<FreightGateData__c> lstFreightGateData = new List<FreightGateData__c>();
    
    public FreightGateIntegrationCtrl() {
        OppId = ApexPages.currentPage().getParameters().containsKey('id') ? ApexPages.currentPage().getParameters().get('id') : null;
    }
    
    public PageReference init() {
         Opp = [select Planned_of_Shipments__c,id, Origin__r.UNCode__c,Destination_Location__r.UNCode__c,Unit_of_Measure__c,Planned_of_Total_Containers__c ,Product_Group__c from Opportunity__c where Id =:OppId LIMIT 1 ];
        Origin = opp.Origin__r.UNCode__c ;
        Destination = opp.Destination_Location__r.UNCode__c ;
        Unit_of_Measure  = opp.Unit_of_Measure__c ;
        totalContainers = Opp.Planned_of_Total_Containers__c != null ? String.valueOf(Opp.Planned_of_Total_Containers__c) : null;
        if(Opp.Product_Group__c.contains('Cream') || Opp.Product_Group__c.contains('Fluids')){
            productGroup = 'TK';
        } else if(Opp.Product_Group__c.contains('Butter Products') || Opp.Product_Group__c.contains('Cheeses')){
            productGroup = 'RF';
        } else if(Opp.Product_Group__c != null ){
            productGroup = 'DV';
        }
        String responce = callingFGAPI();
        
        PageReference acctPage = new ApexPages.StandardController(Opp).view();
        acctPage.setRedirect(true);
        return acctPage;
    }
    
    public void getSessionId(){
        FG_Integration__mdt fgDetails = [select id,BaseURL__c,Parameter1__c,Path__c,Parameter2__c from FG_Integration__mdt  where developername = 'SessionCreation' ];
        URL = fgDetails.BaseURL__c;
        String restAPIURL = URL + '/' + fgDetails.Path__c + '?auth_user_name=' + fgDetails.Parameter1__c+ '&auth_password=' +fgDetails.Parameter2__c;
        restAPIURL += '&auth_company=Hoogwegt';
        HttpRequest httpRequest = new HttpRequest();  
        httpRequest.setEndpoint(restAPIURL);
        Http http = new Http();
        httpRequest.setMethod('GET'); 
        HttpResponse httpResponse = http.send(httpRequest); 
        System.debug(httpResponse.getBody()+' httpResponse ' + httpResponse);
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody());
        sessionId = (String)m.get('sessionId');
        
    }
    
    public String callingFGAPI() {
        getSessionId();
        
       // Origin = 'USEEV';
       // Destination = 'PAPAC' ;
        Opportunity__c objOpp = [select id,Volume__c from Opportunity__c where ID=: OppId LIMIT 1]; 
        String restAPIURL = URL + '/api/json/'+ sessionId + '/mixrates?search_origin_code='+Origin +'&search_destination_code='+ Destination ;
        restAPIURL = restAPIURL + '&search_origin_type=any&search_destination_type=any';
        if(totalContainers != null ){
            restAPIURL += '&search_chargable_weight_fcl='+totalContainers;
        }
        if(productGroup != null ){
            restAPIURL += '&search_container_type_id='+productGroup;
        }
        restAPIURL += '&search_rate_type=' + 'fcl' ; // Ocean 
        restAPIURL += '&search_rate_type=' + 'ftl' ; // Truck
        System.debug(' restAPIURL ' + restAPIURL);
        HttpRequest httpRequest = new HttpRequest();  
        httpRequest.setEndpoint(restAPIURL); 
        String response = '';
        try {  
                 Http http = new Http();
                 httpRequest.setMethod('GET'); 
                 httpRequest.setTimeout(60000);
                 HttpResponse httpResponse = http.send(httpRequest); 
                 System.debug(' httpResponse ' + http.send(httpRequest).getBody());
                 if (httpResponse.getStatusCode() == 200 ) { 
                       FGAPI r = FGAPI.parse(httpResponse.getBody());
                       if(r.success != 'false') {
                           lstFreightGateData.addAll(generateObject(r));
                           if(r.Rows.size() > 0) {
                                objOpp.Ocean_Freight_Fixed__c = Decimal.valueof( r.Rows.get(0).buy_rate) ;
                                objOpp.Ocean_Freight_per_lb_MT__c    = objOpp.Ocean_Freight_Fixed__c / objOpp.Volume__c ;
                                objOpp.Ocean_Freight_Cont__c = Decimal.valueof( r.Rows.get(0).buy_rate) ;
                                
                                objOpp.Drayage_Domestic_Inland_Fixed__c= Decimal.valueof( r.Rows.get(0).inland_buy) ;
                                objOpp.Drayage_Domestic_Inland_per_lb_MT__c = objOpp.Drayage_Domestic_Inland_Fixed__c / objOpp.Volume__c  ;
                               
                                objOpp.Dollar_Shipment__c = Decimal.valueof( r.Rows.get(0).ExtendedBuyRate);
                                objOpp.Dollar_Contract__c = objOpp.Dollar_Shipment__c * Opp.Planned_of_Shipments__c ;
                                update objOpp;
                           }
                       }else {
                          lstFreightGateData.add(new FreightGateData__c(Opportunity__c = OppId, Error__c = r.error , Success__c = r.success , Debugs__c = r.debugs )); 
                       }
                       
                       if(lstFreightGateData.size() > 0 )
                            insert lstFreightGateData;
                 } else {  
                       System.debug(' httpResponse ' + httpResponse.getBody() );  
                       throw new CalloutException( httpResponse.getBody() );  
                 }   
        } catch( System.Exception e) {  
                 System.debug('ERROR: '+ e); 
        }   
        System.debug(' ** response ** : ' + response ); 
            return response;
        }
        
        private List<FreightGateData__c> generateObject(FGAPI r){
          
          List<FreightGateData__c> lst = new List<FreightGateData__c>();
          
          for(FGAPI.Rows objRow : r.Rows){
              lst.add(new FreightGateData__c(
                    amendment_request__c = objrow.amendment_request,
                    bullet_rates_with_via__c = objrow.bullet_rates_with_via  ,
                    buy_rate__c = objrow.buy_rate  ,
                    buy_rate_convertedAmount__c = objrow.buy_rate_convertedAmount  ,
                    buy_rate_currency__c = objrow.buy_rate_currency  ,
                    buy_rate_format__c = objrow.buy_rate_format  ,
                    carrier_id_link__c = objrow.carrier_id_link  ,
                    carrier_id_link_action__c = objrow.carrier_id_link_action  ,
                    carrier_id_link_commodity_detail__c = objrow.carrier_id_link_commodity_detail  ,
                    carrier_id_link_database__c = objrow.carrier_id_link_database  ,
                    carrier_id_link_extra__c = objrow.carrier_id_link_extra  ,
                    carrier_id_link_key__c = objrow.carrier_id_link_key  ,
                    carrier_id_link_keyname__c = objrow.carrier_id_link_keyname  ,
                    carrier_id_link_load_as_sub_report__c = objrow.carrier_id_link_load_as_sub_report  ,
                    carrier_id_link_report_id__c = objrow.carrier_id_link_report_id  ,
                    carrier_id_link_report_title__c = objrow.carrier_id_link_report_title  ,
                    carrier_id_link_session_id__c = objrow.carrier_id_link_session_id  ,
                    carrier_id_link_tmp_table__c = objrow.carrier_id_link_tmp_table  ,
                    carrier_id_link_url__c = objrow.carrier_id_link_url  ,
                    carrier_id_link_url_connector__c = objrow.carrier_id_link_url_connector  ,
                    commodity__c = objrow.commodity  ,
                    commodity_action__c = objrow.commodity_action  ,
                    commodity_commodity_detail__c = objrow.commodity_commodity_detail  ,
                    commodity_database__c = objrow.commodity_database  ,
                    commodity_extra__c = objrow.commodity_extra  ,
                    commodity_key__c = objrow.commodity_key  ,
                    commodity_keyname__c = objrow.commodity_keyname  ,
                    commodity_load_as_sub_report__c = objrow.commodity_load_as_sub_report  ,
                    commodity_report_id__c = objrow.commodity_report_id  ,
                    commodity_report_title__c = objrow.commodity_report_title  ,
                    commodity_session_id__c = objrow.commodity_session_id  ,
                    commodity_tmp_table__c = objrow.commodity_tmp_table  ,
                    commodity_url__c = objrow.commodity_url  ,
                    commodity_url_connector__c = objrow.commodity_url_connector  ,
                    container__c = objrow.container  ,
                    contract_expiry__c = objrow.contract_expiry  ,
                    db_id__c = objrow.db_id  ,
                    destination_port_name__c = objrow.destination_port_name  ,
                    destination_port_name_database__c = objrow.destination_port_name_database  ,
                    destination_port_name_icon_path__c = objrow.destination_port_name_icon_path  ,
                    destination_port_name_port_code__c = objrow.destination_port_name_port_code  ,
                    destination_via__c = objrow.destination_via  ,
                    detention_demurrage__c = objrow.detention_demurrage  ,
                    equipment__c = objrow.equipment  ,
                    frequency__c = objrow.frequency  ,
                    hidden_destination_code__c = objrow.hidden_destination_code  ,
                    hidden_origin_code__c = objrow.hidden_origin_code  ,
                    hidden_source__c = objrow.hidden_source  ,
                    incl_surcharges_buy__c = objrow.incl_surcharges_buy  ,
                    incl_surcharges_buy_format__c = objrow.incl_surcharges_buy_format  ,
                    inland_buy__c = objrow.inland_buy  ,
                    inland_buy_format__c = objrow.inland_buy_format  ,
                    named_account__c = objrow.named_account  ,
                    note_id__c = objrow.note_id  ,
                    notes__c = objrow.notes  ,
                    old_id__c = objrow.old_id  ,
                    onforwarding_buy__c = objrow.onforwarding_buy  ,
                    onforwarding_buy_format__c = objrow.onforwarding_buy_format  ,
                    origin_port_name__c = objrow.origin_port_name  ,
                    origin_port_name_database__c = objrow.origin_port_name_database  ,
                    origin_port_name_icon_path__c = objrow.origin_port_name_icon_path  ,
                    origin_port_name_port_code__c = objrow.origin_port_name_port_code  ,
                    origin_via__c = objrow.origin_via  ,
                    qb__c = objrow.qb  ,
                    qb_checked__c = objrow.qb_checked  ,
                    qb_keyname__c = objrow.qb_keyname  ,
                    quick_quote__c = objrow.quick_quote  ,
                    quick_quote_action__c = objrow.quick_quote_action  ,
                    quick_quote_commodity_detail__c = objrow.quick_quote_commodity_detail  ,
                    quick_quote_customer_company__c = objrow.quick_quote_customer_company  ,
                    quick_quote_customer_email__c = objrow.quick_quote_customer_email  ,
                    quick_quote_customer_id__c = objrow.quick_quote_customer_id  ,
                    quick_quote_customer_name__c = objrow.quick_quote_customer_name  ,
                    quick_quote_database__c = objrow.quick_quote_database  ,
                    quick_quote_db_id__c = objrow.quick_quote_db_id  ,
                    quick_quote_destination_code__c = objrow.quick_quote_destination_code  ,
                    quick_quote_destination_type__c = objrow.quick_quote_destination_type  ,
                    quick_quote_fromtmptable__c = objrow.quick_quote_fromtmptable  ,
                    quick_quote_getAllRelatedToIQuote__c = objrow.quick_quote_getAllRelatedToIQuote  ,
                    quick_quote_mode__c = objrow.quick_quote_mode  ,
                    quick_quote_origin_code__c = objrow.quick_quote_origin_code  ,
                    quick_quote_origin_type__c = objrow.quick_quote_origin_type  ,
                    quick_quote_QQQ__c = objrow.quick_quote_QQQ  ,
                    quick_quote_search_q_carrier_id__c = objrow.quick_quote_search_q_carrier_id  ,
                     quick_quote_search_q_commodity_id__c= objrow.quick_quote_search_q_commodity_id  ,
                    quick_quote_search_q_contract_id__c = objrow.quick_quote_search_q_contract_id  ,
                    quick_quote_search_q_destination__c = objrow.quick_quote_search_q_destination  ,
                    quick_quote_search_q_origin__c = objrow.quick_quote_search_q_origin  ,
                    quick_quote_session_id__c = objrow.quick_quote_session_id  ,
                    quick_quote_source__c = objrow.quick_quote_source  ,
                    quick_quote_system__c = objrow.quick_quote_system  ,
                    quick_quote_text__c = objrow.quick_quote_text  ,
                    quick_quote_tmp_table__c = objrow.quick_quote_tmp_table  ,
                    quick_quote_url__c = objrow.quick_quote_url  ,
                    quick_quote_url_connector__c = objrow.quick_quote_url_connector  ,
                    quick_quote_user_id__c = objrow.quick_quote_user_id  ,
                    quote_basket__c = objrow.quote_basket  ,
                    quote_basket_action__c = objrow.quote_basket_action  ,
                    quote_basket_commodity_detail__c = objrow.quote_basket_commodity_detail  ,
                    quote_basket_customer_company__c = objrow.quote_basket_customer_company  ,
                    quote_basket_customer_email__c = objrow.quote_basket_customer_email  ,
                    quote_basket_customer_id__c = objrow.quote_basket_customer_id ,
                    quote_basket_customer_name__c = objrow.quote_basket_customer_name  ,
                    quote_basket_database__c = objrow.quote_basket_database  ,
                    quote_basket_db_id__c = objrow.quote_basket_db_id  ,
                    quote_basket_destination_code__c = objrow.quote_basket_destination_code  ,
                    quote_basket_destination_type__c = objrow.quote_basket_destination_type  ,
                    quote_basket_fromtmptable__c = objrow.quote_basket_fromtmptable  ,
                    quote_basket_mode__c = objrow.quote_basket_mode  ,
                    quote_basket_origin_code__c = objrow.quote_basket_origin_code  ,
                    quote_basket_origin_type__c = objrow.quote_basket_origin_type  ,
                    quote_basket_QQQ__c = objrow.quote_basket_QQQ  ,
                    quote_basket_search_q_carrier_id__c = objrow.quote_basket_search_q_carrier_id  ,
                    quote_basket_search_q_commodity_id__c = objrow.quote_basket_search_q_commodity_id  ,
                    quote_basket_search_q_contract_id__c = objrow.quote_basket_search_q_contract_id  ,
                    quote_basket_search_q_destination__c = objrow.quote_basket_search_q_destination  ,
                    quote_basket_search_q_origin__c = objrow.quote_basket_search_q_origin  ,
                    quote_basket_session_id__c = objrow.quote_basket_session_id  ,
                    quote_basket_source__c = objrow.quote_basket_source  ,
                    quote_basket_system__c = objrow.quote_basket_system  ,
                    quote_basket_text__c = objrow.quote_basket_text  ,
                    quote_basket_tmp_table__c = objrow.quote_basket_tmp_table  ,
                    quote_basket_url__c = objrow.quote_basket_url  ,
                    quote_basket_url_connector__c = objrow.quote_basket_url_connector  ,
                    quote_basket_user_id__c = objrow.quote_basket_user_id  ,
                    routing_via__c = objrow.routing_via  ,
                    routing_via_label__c = objrow.routing_via_label  ,
                    routing_via_mode__c = objrow.routing_via_mode  ,
                    routing_via_routing_advanced__c = objrow.routing_via_routing_advanced  ,
                    routing_via_system__c = objrow.routing_via_system  ,
                    routing_via_text__c = objrow.routing_via_text  ,
                    routing_via_url__c = objrow.routing_via_url  ,
                    routing_via_url_connector__c = objrow.routing_via_url_connector  ,
                    routing_via_ZZ1__c = objrow.routing_via_ZZ1  ,
                    schedule_id_link__c = objrow.schedule_id_link  ,
                    sell_rate__c = objrow.sell_rate  ,
                    sell_rate_convertedAmount__c = objrow.sell_rate_convertedAmount  ,
                    sell_rate_currency__c = objrow.sell_rate_currency  ,
                    sell_rate_format__c = objrow.sell_rate_format  ,
                    service_level__c = objrow.service_level  ,
                    spot_quote__c = objrow.spot_quote  ,
                    spot_quote_commodity_detail__c = objrow.spot_quote_commodity_detail  ,
                    spot_quote_customer_company__c = objrow.spot_quote_customer_company  ,
                    spot_quote_customer_email__c = objrow.spot_quote_customer_email  ,
                    spot_quote_customer_id__c = objrow.spot_quote_customer_id  ,
                    spot_quote_customer_name__c = objrow.spot_quote_customer_name  ,
                    spot_quote_database__c = objrow.spot_quote_database  ,
                    spot_quote_db_id__c = objrow.spot_quote_db_id  ,
                    spot_quote_destination_code__c = objrow.spot_quote_destination_code  ,
                    spot_quote_destination_type__c = objrow.spot_quote_destination_type  ,
                    spot_quote_display_mode__c = objrow.spot_quote_display_mode  ,
                    spot_quote_getAllRelatedToIQuote__c = objrow.spot_quote_getAllRelatedToIQuote  ,
                    spot_quote_input__c = objrow.spot_quote_input  ,
                    spot_quote_mode__c = objrow.spot_quote_mode  ,
                    spot_quote_origin_code__c = objrow.spot_quote_origin_code  ,
                    spot_quote_origin_type__c = objrow.spot_quote_origin_type  ,
                    spot_quote_quote_url__c = objrow.spot_quote_quote_url  ,
                    spot_quote_search_q_carrier_id__c = objrow.spot_quote_search_q_carrier_id  ,
                    spot_quote_search_q_commodity_id__c = objrow.spot_quote_search_q_commodity_id  ,
                    spot_quote_search_q_contract_id__c = objrow.spot_quote_search_q_contract_id  ,
                    spot_quote_search_q_destination__c = objrow.spot_quote_search_q_destination  ,
                    spot_quote_search_q_origin__c = objrow.spot_quote_search_q_origin  ,
                    spot_quote_session_id__c = objrow.spot_quote_session_id  ,
                    spot_quote_system__c = objrow.spot_quote_system  ,
                    spot_quote_text__c = objrow.spot_quote_text  ,
                    spot_quote_tmp_table__c = objrow.spot_quote_tmp_table  ,
                    spot_quote_url__c = objrow.spot_quote_url  ,
                    spot_quote_url_connector__c = objrow.spot_quote_url_connector  ,
                    transit_time__c = objrow.transit_time  ,
                    transit_time_carrierFilter__c = objrow.transit_time_carrierFilter  ,
                    transit_time_database__c = objrow.transit_time_database  ,
                    transit_time_destination__c = objrow.transit_time_destination  ,
                    transit_time_fromDate__c = objrow.transit_time_fromDate  ,
                    transit_time_icon__c = objrow.transit_time_icon  ,
                    transit_time_mode__c = objrow.transit_time_mode  ,
                    transit_time_origin__c = objrow.transit_time_origin  ,
                    transit_time_session__c = objrow.transit_time_session  ,
                    transit_time_text__c = objrow.transit_time_text  ,
                    transit_time_url__c = objrow.transit_time_url  ,
                    transit_time_url_connector__c = objrow.transit_time_url_connector  ,
                    transit_time_url_xtype__c = objrow.transit_time_url_xtype  ,
                    transit_time_weeksOut__c = objrow.transit_time_weeksOut  ,
                    ttl_buy_rate__c = objrow.ttl_buy_rate  ,
                    ttl_buy_rate_act_vol__c = objrow.ttl_buy_rate_act_vol  ,
                    ttl_buy_rate_act_weight__c = objrow.ttl_buy_rate_act_weight  ,
                    ttl_buy_rate_action__c = objrow.ttl_buy_rate_action  ,
                    ttl_buy_rate_db_id__c = objrow.ttl_buy_rate_db_id  ,
                    ttl_buy_rate_dddde__c = objrow.ttl_buy_rate_dddde  ,
                    ttl_buy_rate_report_id__c = objrow.ttl_buy_rate_report_id  ,
                    ttl_buy_rate_search_customer_company__c = objrow.ttl_buy_rate_search_customer_company  ,
                    ttl_buy_rate_search_q_carrier_name__c = objrow.ttl_buy_rate_search_q_carrier_name  ,
                    ttl_buy_rate_search_q_db_id__c = objrow.ttl_buy_rate_search_q_db_id  ,
                    ttl_buy_rate_search_q_destination__c = objrow.ttl_buy_rate_search_q_destination  ,
                    ttl_buy_rate_search_q_origin__c = objrow.ttl_buy_rate_search_q_origin  ,
                    ttl_buy_rate_session_id__c = objrow.ttl_buy_rate_session_id  ,
                    ttl_buy_rate_system__c = objrow.ttl_buy_rate_system  ,
                    ttl_buy_rate_text__c = objrow.ttl_buy_rate_text  ,
                    ttl_buy_rate_tmp_table__c = objrow.ttl_buy_rate_tmp_table  ,
                    ttl_buy_rate_url__c = objrow.ttl_buy_rate_url  ,
                    ttl_buy_rate_url_connector__c = objrow.ttl_buy_rate_url_connector  ,
                    ttl_buy_rate_user_id__c = objrow.ttl_buy_rate_user_id,
                    Extended_Buy_Rate__c = objrow.ExtendedBuyRate,
                    Opportunity__c = OppId
                  ));
          }
          
          return lst;
        }
  
  }