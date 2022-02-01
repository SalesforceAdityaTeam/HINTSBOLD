public class CopyBPFNameCtrl {
	
    @AuraEnabled
    public static String getName(String recid){
        return [select name from BPF__C where Id =:recid LIMIT 1 ][0].Name;
    }
}