@IsTest
public class ApprovalStatusBarclTest{
  public static testMethod void testBar(){
    Approval__c oApproval = new Approval__c(Origin__c = 'Argentina', Product_Factcode__c = 'ALL', Physical_audit_or_on_remote__c = 'Physical', Reason_for_audit__c = 'Other',
                        Pre_audit_by_Hoogwegt_required__c = 'Yes', Documents_to_prepare_send_prior_to_audit__c = 'test', Customer_specification_available__c = 'No', Customer_Qmanual_available_and_known_by__c = 'No',
                        Name_of_the_auditor__c = 'test', Starting_date_of_the_audit__c = Date.today(), After_held_Feedback_on_report_arranged__c = 'No', After_held_Audit_result_approved__c = 'No', 
                        After_held_Approved_from__c = Date.today(), Close_this_audit_process__c = 'No');
    insert oApproval;
    Approval_Combination__c oCom = new Approval_Combination__c(Approval__c = oApproval.Id, Status__c = 'Final Closing');
    insert oCom;
    ApprovalStatusBarcl.loadStatus(oApproval.Id);
  }
}