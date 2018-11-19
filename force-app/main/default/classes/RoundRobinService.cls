public class RoundRobinService {

    public static List<Round_Robin_Member__c> getMembers(String objectName) {
        List<Round_Robin_Member__c> members = [select Id, Contact__c, Last_Assigned__c,Last_Assigned_Epoch__c, Round_Robin__r.Assign_Field__c from Round_Robin_Member__c where Active__c = true and Round_Robin__r.Object__c = :objectName order by Last_Assigned_Epoch__c asc];
        return members;
    }

}