public class RoundRobin {

    public static void initialize(List<sObject> newRecords, List<sObject> oldRecords) {
        String objectName = newRecords[0].getSObjectType().getDescribe().getName();
        List<Round_Robin_Member__c> members = RoundRobinService.getMembers(objectName);
        String assignField = members[0].Round_Robin__r.Assign_Field__c;
        Integer membersSize = members.size();
        Integer index = 0;
        DateTime dt = DateTime.Now();
        Long longtime = dt.getTime();
        for(sObject record : newRecords){
            if(index == membersSize) index = 0;
            record.put(assignField, members[index].Contact__c);
            members[index].Last_Assigned__c = DateTime.newInstance(longtime);
            index++;
            longtime++;
        }

        update members;
    }

}
