public class FGAPI {

    public String success {get;set;} 
    public Integer TotalRowCount {get;set;} 
    public List<Rows> Rows {get;set;} 
    public String SessionID {get;set;} 
    public String use_tmp_table_name {get;set;} 
    public String debugs {get;set;}
    public String error {get;set;} 
    public String helpText {get;set;} 

    public FGAPI(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'success') {
                        success = parser.getText();
                    } else if (text == 'TotalRowCount') {
                        TotalRowCount = parser.getIntegerValue();
                    } else if (text == 'Rows') {
                        Rows = arrayOfRows(parser);
                    } else if (text == 'SessionID') {
                        SessionID = parser.getText();
                    } else if (text == 'use_tmp_table_name') {
                        use_tmp_table_name = parser.getText();
                    } else if (text == 'debugs') {
                        debugs = parser.getText();
                    } else if (text == 'helpText') {
                        helpText = parser.getText();
                    } else if (text == 'error') {
                        error = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'FGAPI consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Rows {
        public String qb {get;set;} 
        public String qb_keyname {get;set;} 
        public String qb_checked {get;set;} 
        public String quote_basket {get;set;} 
        public String quote_basket_url {get;set;} 
        public String quote_basket_url_connector {get;set;} 
        public String quote_basket_system {get;set;} 
        public String quote_basket_database {get;set;} 
        public String quote_basket_session_id {get;set;} 
        public String quote_basket_tmp_table {get;set;} 
        public String quote_basket_fromtmptable {get;set;} 
        public String quote_basket_db_id {get;set;} 
        public String quote_basket_user_id {get;set;} 
        public String quote_basket_action {get;set;} 
        public String quote_basket_source {get;set;} 
        public String quote_basket_QQQ {get;set;} 
        public String quote_basket_search_q_origin {get;set;} 
        public String quote_basket_search_q_destination {get;set;} 
        public String quote_basket_search_q_carrier_id {get;set;} 
        public String quote_basket_search_q_contract_id {get;set;} 
        public String quote_basket_search_q_commodity_id {get;set;} 
        public String quote_basket_origin_type {get;set;} 
        public String quote_basket_destination_type {get;set;} 
        public String quote_basket_customer_id {get;set;} 
        public String quote_basket_customer_name {get;set;} 
        public String quote_basket_customer_company {get;set;} 
        public String quote_basket_customer_email {get;set;} 
        public String quote_basket_commodity_detail {get;set;} 
        public String quote_basket_origin_code {get;set;} 
        public String quote_basket_destination_code {get;set;} 
        public String quote_basket_mode {get;set;} 
        public String quote_basket_text {get;set;} 
        public String quick_quote {get;set;} 
        public String quick_quote_url {get;set;} 
        public String quick_quote_url_connector {get;set;} 
        public String quick_quote_system {get;set;} 
        public String quick_quote_database {get;set;} 
        public String quick_quote_session_id {get;set;} 
        public String quick_quote_tmp_table {get;set;} 
        public String quick_quote_fromtmptable {get;set;} 
        public String quick_quote_db_id {get;set;} 
        public String quick_quote_user_id {get;set;} 
        public String quick_quote_action {get;set;} 
        public String quick_quote_source {get;set;} 
        public String quick_quote_QQQ {get;set;} 
        public String quick_quote_getAllRelatedToIQuote {get;set;} 
        public String quick_quote_search_q_origin {get;set;} 
        public String quick_quote_search_q_destination {get;set;} 
        public String quick_quote_search_q_carrier_id {get;set;} 
        public String quick_quote_search_q_contract_id {get;set;} 
        public String quick_quote_search_q_commodity_id {get;set;} 
        public String quick_quote_origin_type {get;set;} 
        public String quick_quote_destination_type {get;set;} 
        public String quick_quote_customer_id {get;set;} 
        public String quick_quote_customer_name {get;set;} 
        public String quick_quote_customer_company {get;set;} 
        public String quick_quote_customer_email {get;set;} 
        public String quick_quote_commodity_detail {get;set;} 
        public String quick_quote_origin_code {get;set;} 
        public String quick_quote_destination_code {get;set;} 
        public String quick_quote_mode {get;set;} 
        public String quick_quote_text {get;set;} 
        public String spot_quote {get;set;} 
        public String spot_quote_url {get;set;} 
        public String spot_quote_url_connector {get;set;} 
        public String spot_quote_system {get;set;} 
        public String spot_quote_database {get;set;} 
        public String spot_quote_session_id {get;set;} 
        public String spot_quote_tmp_table {get;set;} 
        public String spot_quote_db_id {get;set;} 
        public String spot_quote_display_mode {get;set;} 
        public String spot_quote_quote_url {get;set;} 
        public String spot_quote_getAllRelatedToIQuote {get;set;} 
        public String spot_quote_input {get;set;} 
        public String spot_quote_search_q_origin {get;set;} 
        public String spot_quote_search_q_destination {get;set;} 
        public String spot_quote_search_q_carrier_id {get;set;} 
        public String spot_quote_search_q_contract_id {get;set;} 
        public String spot_quote_search_q_commodity_id {get;set;} 
        public String spot_quote_origin_type {get;set;} 
        public String spot_quote_destination_type {get;set;} 
        public String spot_quote_customer_id {get;set;} 
        public String spot_quote_customer_name {get;set;} 
        public String spot_quote_customer_company {get;set;} 
        public String spot_quote_customer_email {get;set;} 
        public String spot_quote_commodity_detail {get;set;} 
        public String spot_quote_origin_code {get;set;} 
        public String spot_quote_destination_code {get;set;} 
        public String spot_quote_mode {get;set;} 
        public String spot_quote_text {get;set;} 
        public String origin_port_name {get;set;} 
        public String origin_port_name_database {get;set;} 
        public String origin_port_name_port_code {get;set;} 
        public String origin_port_name_icon_path {get;set;} 
        public String origin_via {get;set;} 
        public String destination_port_name {get;set;} 
        public String destination_port_name_database {get;set;} 
        public String destination_port_name_port_code {get;set;} 
        public String destination_port_name_icon_path {get;set;} 
        public String destination_via {get;set;} 
        public String container {get;set;} 
        public String carrier_id_link {get;set;} 
        public String carrier_id_link_url {get;set;} 
        public String carrier_id_link_url_connector {get;set;} 
        public String carrier_id_link_database {get;set;} 
        public String carrier_id_link_session_id {get;set;} 
        public String carrier_id_link_tmp_table {get;set;} 
        public String carrier_id_link_report_id {get;set;} 
        public String carrier_id_link_report_title {get;set;}  
        public String carrier_id_link_commodity_detail {get;set;} 
        public String carrier_id_link_load_as_sub_report {get;set;} 
        public String carrier_id_link_key {get;set;} 
        public String carrier_id_link_keyname {get;set;} 
        public String carrier_id_link_action {get;set;} 
        public String carrier_id_link_extra {get;set;} 
        public String sell_rate {get;set;} 
        public String sell_rate_currency {get;set;} 
        public String sell_rate_format {get;set;} 
        public String sell_rate_convertedAmount {get;set;} 
        public String buy_rate {get;set;} 
        public String buy_rate_currency {get;set;} 
        public String buy_rate_format {get;set;} 
        public String buy_rate_convertedAmount {get;set;} 
        public String ttl_buy_rate {get;set;} 
        public String ttl_buy_rate_url {get;set;} 
        public String ttl_buy_rate_url_connector {get;set;} 
        public String ttl_buy_rate_system {get;set;} 
        public String ttl_buy_rate_action {get;set;} 
        public String ttl_buy_rate_session_id {get;set;} 
        public String ttl_buy_rate_tmp_table {get;set;} 
        public String ttl_buy_rate_db_id {get;set;} 
        public String ttl_buy_rate_search_q_db_id {get;set;} 
        public String ttl_buy_rate_user_id {get;set;} 
        public String ttl_buy_rate_report_id {get;set;} 
        public String ttl_buy_rate_act_weight {get;set;} 
        public String ttl_buy_rate_dddde {get;set;} 
        public String ttl_buy_rate_search_customer_company {get;set;} 
        public String ttl_buy_rate_act_vol {get;set;} 
        public String ttl_buy_rate_search_q_origin {get;set;} 
        public String ttl_buy_rate_search_q_destination {get;set;} 
        public String ttl_buy_rate_search_q_carrier_name {get;set;} 
        public String ttl_buy_rate_text {get;set;} 
        public String incl_surcharges_buy {get;set;} 
        public String incl_surcharges_buy_format {get;set;} 
        public String inland_buy {get;set;} 
        public String inland_buy_format {get;set;} 
        public String onforwarding_buy {get;set;} 
        public String onforwarding_buy_format {get;set;} 
        public String contract_expiry {get;set;} 
        public String commodity {get;set;} 
        public String commodity_url {get;set;} 
        public String commodity_url_connector {get;set;} 
        public String commodity_database {get;set;} 
        public String commodity_session_id {get;set;} 
        public String commodity_tmp_table {get;set;} 
        public String commodity_report_id {get;set;} 
        public String commodity_report_title {get;set;}  
        public String commodity_commodity_detail {get;set;} 
        public String commodity_load_as_sub_report {get;set;} 
        public String commodity_key {get;set;} 
        public String commodity_keyname {get;set;} 
        public String commodity_action {get;set;} 
        public String commodity_extra {get;set;} 
        public String detention_demurrage {get;set;} 
        public String frequency {get;set;} 
        public String transit_time {get;set;} 
        public String transit_time_url {get;set;} 
        public String transit_time_url_xtype {get;set;} 
        public String transit_time_url_connector {get;set;} 
        public String transit_time_mode {get;set;} 
        public String transit_time_origin {get;set;} 
        public String transit_time_destination {get;set;} 
        public String transit_time_fromDate {get;set;} 
        public String transit_time_carrierFilter {get;set;} 
        public Integer transit_time_weeksOut {get;set;} 
        public String transit_time_icon {get;set;} 
        public String transit_time_text {get;set;} 
        public String transit_time_session {get;set;} 
        public String transit_time_database {get;set;} 
        public String bullet_rates_with_via {get;set;} 
        public String routing_via {get;set;} 
        public String routing_via_text {get;set;} 
        public String routing_via_url {get;set;} 
        public String routing_via_url_connector {get;set;} 
        public String routing_via_routing_advanced {get;set;} 
        public String routing_via_mode {get;set;} 
        public String routing_via_system {get;set;} 
        public String routing_via_label {get;set;} 
        public String routing_via_ZZ1 {get;set;} 
        public String service_level {get;set;} 
        public String notes {get;set;} 
        public String note_id {get;set;} 
        public String amendment_request {get;set;} 
        public String hidden_origin_code {get;set;} 
        public String hidden_destination_code {get;set;} 
        public String hidden_source {get;set;} 
        public String old_id {get;set;} 
        public String named_account {get;set;} 
        public String schedule_id_link {get;set;} 
        public String equipment {get;set;} 
        public String db_id {get;set;}
         public String ExtendedBuyRate {get;set;}

        public Rows(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'qb') {
                            qb = parser.getText();
                        } else if (text == 'qb_keyname') {
                            qb_keyname = parser.getText();
                        } else if (text == 'qb_checked') {
                            qb_checked = parser.getText();
                        } else if (text == 'quote_basket') {
                            quote_basket = parser.getText();
                        } else if (text == 'quote_basket_url') {
                            quote_basket_url = parser.getText();
                        } else if (text == 'quote_basket_url_connector') {
                            quote_basket_url_connector = parser.getText();
                        } else if (text == 'quote_basket_system') {
                            quote_basket_system = parser.getText();
                        } else if (text == 'quote_basket_database') {
                            quote_basket_database = parser.getText();
                        } else if (text == 'quote_basket_session_id') {
                            quote_basket_session_id = parser.getText();
                        } else if (text == 'quote_basket_tmp_table') {
                            quote_basket_tmp_table = parser.getText();
                        } else if (text == 'quote_basket_fromtmptable') {
                            quote_basket_fromtmptable = parser.getText();
                        } else if (text == 'quote_basket_db_id') {
                            quote_basket_db_id = parser.getText();
                        } else if (text == 'quote_basket_user_id') {
                            quote_basket_user_id = parser.getText();
                        } else if (text == 'quote_basket_action') {
                            quote_basket_action = parser.getText();
                        } else if (text == 'quote_basket_source') {
                            quote_basket_source = parser.getText();
                        } else if (text == 'quote_basket_QQQ') {
                            quote_basket_QQQ = parser.getText();
                        } else if (text == 'quote_basket_search_q_origin') {
                            quote_basket_search_q_origin = parser.getText();
                        } else if (text == 'quote_basket_search_q_destination') {
                            quote_basket_search_q_destination = parser.getText();
                        } else if (text == 'quote_basket_search_q_carrier_id') {
                            quote_basket_search_q_carrier_id = parser.getText();
                        } else if (text == 'quote_basket_search_q_contract_id') {
                            quote_basket_search_q_contract_id = parser.getText();
                        } else if (text == 'quote_basket_search_q_commodity_id') {
                            quote_basket_search_q_commodity_id = parser.getText();
                        } else if (text == 'quote_basket_origin_type') {
                            quote_basket_origin_type = parser.getText();
                        } else if (text == 'quote_basket_destination_type') {
                            quote_basket_destination_type = parser.getText();
                        } else if (text == 'quote_basket_customer_id') {
                            quote_basket_customer_id = parser.getText();
                        } else if (text == 'quote_basket_customer_name') {
                            quote_basket_customer_name = parser.getText();
                        } else if (text == 'quote_basket_customer_company') {
                            quote_basket_customer_company = parser.getText();
                        } else if (text == 'quote_basket_customer_email') {
                            quote_basket_customer_email = parser.getText();
                        } else if (text == 'quote_basket_commodity_detail') {
                            quote_basket_commodity_detail = parser.getText();
                        } else if (text == 'quote_basket_origin_code') {
                            quote_basket_origin_code = parser.getText();
                        } else if (text == 'quote_basket_destination_code') {
                            quote_basket_destination_code = parser.getText();
                        } else if (text == 'quote_basket_mode') {
                            quote_basket_mode = parser.getText();
                        } else if (text == 'quote_basket_text') {
                            quote_basket_text = parser.getText();
                        } else if (text == 'quick_quote') {
                            quick_quote = parser.getText();
                        } else if (text == 'quick_quote_url') {
                            quick_quote_url = parser.getText();
                        } else if (text == 'quick_quote_url_connector') { quick_quote_url_connector = parser.getText();
                        } else if (text == 'quick_quote_system') { quick_quote_system = parser.getText();
                        } else if (text == 'quick_quote_database') {  quick_quote_database = parser.getText();
                        } else if (text == 'quick_quote_session_id') { quick_quote_session_id = parser.getText();
                        } else if (text == 'quick_quote_tmp_table') { quick_quote_tmp_table = parser.getText();
                        } else if (text == 'quick_quote_fromtmptable') {  quick_quote_fromtmptable = parser.getText();
                        } else if (text == 'quick_quote_db_id') { quick_quote_db_id = parser.getText();
                        } else if (text == 'quick_quote_user_id') { quick_quote_user_id = parser.getText();
                        } else if (text == 'quick_quote_action') { quick_quote_action = parser.getText();
                        } else if (text == 'quick_quote_source') {  quick_quote_source = parser.getText();
                        } else if (text == 'quick_quote_QQQ') { quick_quote_QQQ = parser.getText();
                        } else if (text == 'quick_quote_getAllRelatedToIQuote') { quick_quote_getAllRelatedToIQuote = parser.getText();
                        } else if (text == 'quick_quote_search_q_origin') { quick_quote_search_q_origin = parser.getText();
                        } else if (text == 'quick_quote_search_q_destination') {  quick_quote_search_q_destination = parser.getText();
                        } else if (text == 'quick_quote_search_q_carrier_id') { quick_quote_search_q_carrier_id = parser.getText();
                        } else if (text == 'quick_quote_search_q_contract_id') {  quick_quote_search_q_contract_id = parser.getText();
                        } else if (text == 'quick_quote_search_q_commodity_id') { quick_quote_search_q_commodity_id = parser.getText();
                        } else if (text == 'quick_quote_origin_type') {  quick_quote_origin_type = parser.getText();
                        } else if (text == 'quick_quote_destination_type') {  quick_quote_destination_type = parser.getText();
                        } else if (text == 'quick_quote_customer_id') { quick_quote_customer_id = parser.getText();
                        } else if (text == 'quick_quote_customer_name') { quick_quote_customer_name = parser.getText();
                        } else if (text == 'quick_quote_customer_company') {  quick_quote_customer_company = parser.getText();
                        } else if (text == 'quick_quote_customer_email') { quick_quote_customer_email = parser.getText();
                        } else if (text == 'quick_quote_commodity_detail') { quick_quote_commodity_detail = parser.getText();
                        } else if (text == 'quick_quote_origin_code') {  quick_quote_origin_code = parser.getText();
                        } else if (text == 'quick_quote_destination_code') {   quick_quote_destination_code = parser.getText();
                        } else if (text == 'quick_quote_mode') { quick_quote_mode = parser.getText();
                        } else if (text == 'quick_quote_text') {  quick_quote_text = parser.getText();
                        } else if (text == 'spot_quote') {
                            spot_quote = parser.getText();
                        } else if (text == 'spot_quote_url') { spot_quote_url = parser.getText();
                        } else if (text == 'spot_quote_url_connector') {  spot_quote_url_connector = parser.getText();
                        } else if (text == 'spot_quote_system') { spot_quote_system = parser.getText();
                        } else if (text == 'spot_quote_database') {  spot_quote_database = parser.getText();
                        } else if (text == 'spot_quote_session_id') { spot_quote_session_id = parser.getText();
                        } else if (text == 'spot_quote_tmp_table') {spot_quote_tmp_table = parser.getText();
                        } else if (text == 'spot_quote_db_id') { spot_quote_db_id = parser.getText();
                        } else if (text == 'spot_quote_display_mode') { spot_quote_display_mode = parser.getText();
                        } else if (text == 'spot_quote_quote_url') {  spot_quote_quote_url = parser.getText();
                        } else if (text == 'spot_quote_getAllRelatedToIQuote') {  spot_quote_getAllRelatedToIQuote = parser.getText();
                        } else if (text == 'spot_quote_input') {   spot_quote_input = parser.getText();
                        } else if (text == 'spot_quote_search_q_origin') {  spot_quote_search_q_origin = parser.getText();
                        } else if (text == 'spot_quote_search_q_destination') { spot_quote_search_q_destination = parser.getText();
                        } else if (text == 'spot_quote_search_q_carrier_id') {  spot_quote_search_q_carrier_id = parser.getText();
                        } else if (text == 'spot_quote_search_q_contract_id') {  spot_quote_search_q_contract_id = parser.getText();
                        } else if (text == 'spot_quote_search_q_commodity_id') {  spot_quote_search_q_commodity_id = parser.getText();
                        } else if (text == 'spot_quote_origin_type') {  spot_quote_origin_type = parser.getText();
                        } else if (text == 'spot_quote_destination_type') { spot_quote_destination_type = parser.getText();
                        } else if (text == 'spot_quote_customer_id') {  spot_quote_customer_id = parser.getText();
                        } else if (text == 'spot_quote_customer_name') { spot_quote_customer_name = parser.getText();
                        } else if (text == 'spot_quote_customer_company') {  spot_quote_customer_company = parser.getText();
                        } else if (text == 'spot_quote_customer_email') {  spot_quote_customer_email = parser.getText();
                        } else if (text == 'spot_quote_commodity_detail') {  spot_quote_commodity_detail = parser.getText();
                        } else if (text == 'spot_quote_origin_code') { spot_quote_origin_code = parser.getText();
                        } else if (text == 'spot_quote_destination_code') {  spot_quote_destination_code = parser.getText();
                        } else if (text == 'spot_quote_mode') {  spot_quote_mode = parser.getText();
                        } else if (text == 'spot_quote_text') {  spot_quote_text = parser.getText();
                        } else if (text == 'origin_port_name') {
                            origin_port_name = parser.getText();
                        } else if (text == 'origin_port_name_database') {
                            origin_port_name_database = parser.getText();
                        } else if (text == 'origin_port_name_port_code') {
                            origin_port_name_port_code = parser.getText();
                        } else if (text == 'origin_port_name_icon_path') {
                            origin_port_name_icon_path = parser.getText();
                        } else if (text == 'origin_via') { origin_via = parser.getText();
                        } else if (text == 'destination_port_name') {destination_port_name = parser.getText();
                        } else if (text == 'destination_port_name_database') {destination_port_name_database = parser.getText();
                        } else if (text == 'destination_port_name_port_code') {destination_port_name_port_code = parser.getText();
                        } else if (text == 'destination_port_name_icon_path') {destination_port_name_icon_path = parser.getText();
                        } else if (text == 'destination_via') {destination_via = parser.getText();
                        } else if (text == 'container') {container = parser.getText();
                        } else if (text == 'carrier_id_link') {carrier_id_link = parser.getText();
                        } else if (text == 'carrier_id_link_url') {carrier_id_link_url = parser.getText();
                        } else if (text == 'carrier_id_link_url_connector') {carrier_id_link_url_connector = parser.getText();
                        } else if (text == 'carrier_id_link_database') {carrier_id_link_database = parser.getText();
                        } else if (text == 'carrier_id_link_session_id') {carrier_id_link_session_id = parser.getText();
                        } else if (text == 'carrier_id_link_tmp_table') {carrier_id_link_tmp_table = parser.getText();
                        } else if (text == 'carrier_id_link_report_id') {carrier_id_link_report_id = parser.getText();
                        } else if (text == 'carrier_id_link_report_title') {carrier_id_link_report_title = parser.getText();
                        }  else if (text == 'carrier_id_link_commodity_detail') {carrier_id_link_commodity_detail = parser.getText();
                        } else if (text == 'carrier_id_link_load_as_sub_report') {carrier_id_link_load_as_sub_report = parser.getText();
                        } else if (text == 'carrier_id_link_key') {carrier_id_link_key = parser.getText();
                        } else if (text == 'carrier_id_link_keyname') {carrier_id_link_keyname = parser.getText();
                        } else if (text == 'carrier_id_link_action') {carrier_id_link_action = parser.getText();
                        } else if (text == 'carrier_id_link_extra') {carrier_id_link_extra = parser.getText();
                        } else if (text == 'sell_rate') {sell_rate = parser.getText();
                        } else if (text == 'sell_rate_currency') {sell_rate_currency = parser.getText();
                        } else if (text == 'sell_rate_format') {sell_rate_format = parser.getText();
                        } else if (text == 'sell_rate_convertedAmount') {sell_rate_convertedAmount = parser.getText();
                        } else if (text == 'buy_rate') {buy_rate = parser.getText();
                        } else if (text == 'buy_rate_currency') {buy_rate_currency = parser.getText();
                        } else if (text == 'buy_rate_format') {buy_rate_format = parser.getText();
                        } else if (text == 'buy_rate_convertedAmount') {buy_rate_convertedAmount = parser.getText();
                        } else if (text == 'ttl_buy_rate') {ttl_buy_rate = parser.getText();
                        } else if (text == 'ttl_buy_rate_url') {ttl_buy_rate_url = parser.getText();
                        } else if (text == 'ttl_buy_rate_url_connector') {ttl_buy_rate_url_connector = parser.getText();
                        } else if (text == 'ttl_buy_rate_system') {ttl_buy_rate_system = parser.getText();
                        } else if (text == 'ttl_buy_rate_action') {ttl_buy_rate_action = parser.getText();
                        } else if (text == 'ttl_buy_rate_session_id') {ttl_buy_rate_session_id = parser.getText();
                        } else if (text == 'ttl_buy_rate_tmp_table') {ttl_buy_rate_tmp_table = parser.getText();
                        } else if (text == 'ttl_buy_rate_db_id') {ttl_buy_rate_db_id = parser.getText();
                        } else if (text == 'ttl_buy_rate_search_q_db_id') {ttl_buy_rate_search_q_db_id = parser.getText();
                        } else if (text == 'ttl_buy_rate_user_id') {ttl_buy_rate_user_id = parser.getText();
                        } else if (text == 'ttl_buy_rate_report_id') {ttl_buy_rate_report_id = parser.getText();
                        } else if (text == 'ttl_buy_rate_act_weight') {ttl_buy_rate_act_weight = parser.getText();
                        } else if (text == 'ttl_buy_rate_dddde') {ttl_buy_rate_dddde = parser.getText();
                        } else if (text == 'ttl_buy_rate_search_customer_company') {ttl_buy_rate_search_customer_company = parser.getText();
                        } else if (text == 'ttl_buy_rate_act_vol') {ttl_buy_rate_act_vol = parser.getText();
                        } else if (text == 'ttl_buy_rate_search_q_origin') {ttl_buy_rate_search_q_origin = parser.getText();
                        } else if (text == 'ttl_buy_rate_search_q_destination') {ttl_buy_rate_search_q_destination = parser.getText();
                        } else if (text == 'ttl_buy_rate_search_q_carrier_name') {ttl_buy_rate_search_q_carrier_name = parser.getText();
                        } else if (text == 'ttl_buy_rate_text') {ttl_buy_rate_text = parser.getText();
                        } else if (text == 'incl_surcharges_buy') {incl_surcharges_buy = parser.getText();
                        } else if (text == 'incl_surcharges_buy_format') {incl_surcharges_buy_format = parser.getText();
                        } else if (text == 'inland_buy') {inland_buy = parser.getText();
                        } else if (text == 'inland_buy_format') {inland_buy_format = parser.getText();
                        } else if (text == 'onforwarding_buy') {onforwarding_buy = parser.getText();
                        } else if (text == 'onforwarding_buy_format') {onforwarding_buy_format = parser.getText();
                        } else if (text == 'contract_expiry') {contract_expiry = parser.getText();
                        } else if (text == 'commodity') {commodity = parser.getText();
                        } else if (text == 'commodity_url') {commodity_url = parser.getText();
                        } else if (text == 'commodity_url_connector') {commodity_url_connector = parser.getText();
                        } else if (text == 'commodity_database') {commodity_database = parser.getText();
                        } else if (text == 'commodity_session_id') {commodity_session_id = parser.getText();
                        } else if (text == 'commodity_tmp_table') {commodity_tmp_table = parser.getText();
                        } else if (text == 'commodity_report_id') {commodity_report_id = parser.getText();
                        } else if (text == 'commodity_report_title') {commodity_report_title = parser.getText();
                        } else if (text == 'commodity_commodity_detail') {commodity_commodity_detail = parser.getText();
                        } else if (text == 'commodity_load_as_sub_report') {commodity_load_as_sub_report = parser.getText();
                        } else if (text == 'commodity_key') {commodity_key = parser.getText();
                        } else if (text == 'commodity_keyname') {commodity_keyname = parser.getText();
                        } else if (text == 'commodity_action') {commodity_action = parser.getText();
                        } else if (text == 'commodity_extra') {commodity_extra = parser.getText();
                        } else if (text == 'detention_demurrage') {detention_demurrage = parser.getText();
                        } else if (text == 'frequency') {frequency = parser.getText();
                        } else if (text == 'transit_time') {transit_time = parser.getText();
                        } else if (text == 'transit_time_url') {transit_time_url = parser.getText();
                        } else if (text == 'transit_time_url_xtype') {transit_time_url_xtype = parser.getText();
                        } else if (text == 'transit_time_url_connector') {transit_time_url_connector = parser.getText();
                        } else if (text == 'transit_time_mode') {transit_time_mode = parser.getText();
                        } else if (text == 'transit_time_origin') {transit_time_origin = parser.getText();
                        } else if (text == 'transit_time_destination') {transit_time_destination = parser.getText();
                        } else if (text == 'transit_time_fromDate') {transit_time_fromDate = parser.getText();
                        } else if (text == 'transit_time_carrierFilter') {transit_time_carrierFilter = parser.getText();
                        } else if (text == 'transit_time_weeksOut') {transit_time_weeksOut = parser.getIntegerValue();
                        } else if (text == 'transit_time_icon') {transit_time_icon = parser.getText();
                        } else if (text == 'transit_time_text') {transit_time_text = parser.getText();
                        } else if (text == 'transit_time_session') {transit_time_session = parser.getText();
                        } else if (text == 'transit_time_database') {transit_time_database = parser.getText();
                        } else if (text == 'bullet_rates_with_via') {bullet_rates_with_via = parser.getText();
                        } else if (text == 'routing_via') {routing_via = parser.getText();
                        } else if (text == 'routing_via_text') {routing_via_text = parser.getText();
                        } else if (text == 'routing_via_url') {routing_via_url = parser.getText();
                        } else if (text == 'routing_via_url_connector') {routing_via_url_connector = parser.getText();
                        } else if (text == 'routing_via_routing_advanced') {routing_via_routing_advanced = parser.getText();
                        } else if (text == 'routing_via_mode') {routing_via_mode = parser.getText();
                        } else if (text == 'routing_via_system') {routing_via_system = parser.getText();
                        } else if (text == 'routing_via_label') {routing_via_label = parser.getText();
                        } else if (text == 'routing_via_ZZ1') {routing_via_ZZ1 = parser.getText();
                        } else if (text == 'service_level') {service_level = parser.getText();
                        } else if (text == 'notes') {notes = parser.getText();
                        } else if (text == 'note_id') {note_id = parser.getText();
                        } else if (text == 'amendment_request') {amendment_request = parser.getText();
                        } else if (text == 'hidden_origin_code') {hidden_origin_code = parser.getText();
                        } else if (text == 'hidden_destination_code') { hidden_destination_code = parser.getText();
                        } else if (text == 'hidden_source') {hidden_source = parser.getText();
                        } else if (text == 'old_id') {old_id = parser.getText();
                        } else if (text == 'named_account') {named_account = parser.getText();
                        } else if (text == 'schedule_id_link') {schedule_id_link = parser.getText();
                        } else if (text == 'equipment') {equipment = parser.getText();
                        } else if (text == 'db_id') { db_id = parser.getText();
                        }  else if (text == 'ExtendedBuyRate') {ExtendedBuyRate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Rows consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static FGAPI parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new FGAPI(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    

    private static List<Rows> arrayOfRows(System.JSONParser p) {
        List<Rows> res = new List<Rows>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Rows(p));
        }
        return res;
    }

    
    
    
}