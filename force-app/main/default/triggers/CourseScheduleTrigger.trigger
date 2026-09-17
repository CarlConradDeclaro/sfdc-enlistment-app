trigger CourseScheduleTrigger on Course_Schedule__c (before insert, before update) {



    if(Trigger.isBefore && Trigger.isInsert || Trigger.isUpdate){
        CourseSchedulesTriggerHandler.checkDuplicateSchedules(Trigger.New);
    }

}