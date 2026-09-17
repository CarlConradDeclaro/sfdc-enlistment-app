trigger CourseEnlistmentTrigger on Course_Enlistment__c (before insert) {
 
    if (Trigger.isBefore && Trigger.isInsert) {
         CourseEnlistmentTriggerHandler.validateSchedule(
                Trigger.new
            );

               
            CourseEnlistmentTriggerHandler.validateDuplicateCourse(
        Trigger.new
        );
    }

 
 

    // if(Trigger.isAfter && Trigger.isUpdate){
    //     CourseEnlistmentTriggerHandler.validateStudentScholarchipEligebility(
    //         Trigger.new
    //     );
    // }

}