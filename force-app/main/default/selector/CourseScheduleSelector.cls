public with sharing class CourseScheduleSelector {
   
    public static Course_Schedule__c getSelectedCourseScheduleById(Id courseScheduleId){
        Course_Schedule__c selectCourseSchedule = [
           SELECT Id, Course__c
            FROM Course_Schedule__c
            WHERE Id =:courseScheduleId
            LIMIT 1
        ];

        return selectCourseSchedule;
    }
    public static List<Course_Schedule__c> getCourseScheduleBySelectedCourse(Id selectedCourseId){
        List<Course_Schedule__c> courseSchedule = [
             SELECT Id, Course__c, Course__r.Name, Days_S__c, Time_Slots__c, Venue__c
            FROM Course_Schedule__c
            WHERE Course__c = :selectedCourseId  
        ];

        return courseSchedule;
    }
}