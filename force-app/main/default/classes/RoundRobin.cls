public class RoundRobin{

    public static void initialize(List<sObject> newRecords, List<sObject> oldRecords) {
        String objectName = newRecords[0].getSObjectType().getDescribe().getName();
        List<Round_Robin_Member__c> members = RoundRobinService.getMembers(objectName);
        List<MemberWrapper> memberWrappers = new List<MemberWrapper>();
        for(Round_Robin_Member__c rrm : members){
            MemberWrapper mw = new MemberWrapper(rrm);
            memberWrappers.add(mw);
        }
        String assignField = memberWrappers[0].rrm.Round_Robin__r.Assign_Field__c;
        Integer membersSize = memberWrappers.size();

        Integer index = 0;
        Integer count = 0;
        for(sObject record : newRecords){
            if(index == membersSize) index = 0;
            record.put(assignField, memberWrappers[index].rrm.Contact__c);
            memberWrappers[index].count = count;
            system.debug('count ' + count);
            index++;
            count++;
        }
        memberWrappers.sort();
        DateTime dt = DateTime.Now();
        List<Round_Robin_Member__c> membersToUpdate = new List<Round_Robin_Member__c>();
        for(MemberWrapper mw : memberWrappers){
            mw.rrm.Last_Assigned__c = dt;
            system.debug('dt ' + dt);
            dt = dt.addSeconds(1);
            membersToUpdate.add(mw.rrm);
        }
        update membersToUpdate;

        //String assignField = members[0].Round_Robin__r.Assign_Field__c;
        //Integer membersSize = members.size();
        //Integer index = 0;
        //DateTime dt = DateTime.Now();
        //Long longtime = dt.getTime();
        // for(sObject record : newRecords){
        //     if(index == membersSize) index = 0;
        //     record.put(assignField, members[index].Contact__c);
        //     members[index].Last_Assigned__c = DateTime.newInstance(longtime);
        //     System.debug(members[index].Last_Assigned__c.millisecond());
        //     System.debug(longtime);
        //     index++;
        //     longtime++;
        // }
        //update members;
    }

    //the purpose of this wrapperclass is for bulk inserts. When inserting records in bulk, if we were to mark the last assigned date as 
    //NOW(), then all the RR members would potentially have the same last assigned date. In order to deal with this, we add a
    //wrapper class w a count attribute. After the reord assignemnt is complete, the Comparable is called which sorts the list by count
    public class MemberWrapper implements Comparable {
        public Round_Robin_Member__c rrm;
        public Integer count {get;set;}

        public MemberWrapper(Round_Robin_Member__c member) {
            rrm = member;
        }

        public Integer compareTo(Object compareTo) {
            MemberWrapper compareToRrm = (MemberWrapper)compareTo;
            Integer returnValue = 0;
            if (count > compareToRrm.count) returnValue = 1;
            if (count < compareToRrm.count) returnValue = -1;
            return returnValue;        
        }
    }
    
}
