
public with sharing class CourseEnlistmentController {

   @AuraEnabled(cacheable=true)
    public static List<Course__c> getCourses(Id enlistmentId){
       return CourseEnlistmentService.getCourses(enlistmentId);
    }

    @AuraEnabled(cacheable=true)
    public static List<Course_Schedule__c> getCourseScheduleByEnlistment(Id enlistmentId, Id selectedCourseId) {
        return CourseEnlistmentService.getCourseScheduleByEnlistment(enlistmentId,selectedCourseId);
    }

    @AuraEnabled
    public static Id createCourseEnlistment(Id courseScheduleId,Id enlistmentId){
        return CourseEnlistmentService.createCourseEnlistment(courseScheduleId, enlistmentId);
    }
}