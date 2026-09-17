public with sharing class CourseSelector {

    public static Course__c getSelectedCourseById(Course_Schedule__c course){
        Course__c selectedCourse = [
            SELECT Id, Units__c
            FROM Course__c
            WHERE Id = :course.Course__c
            LIMIT 1
        ];

        return selectedCourse;
    }

    public static List<Course__c> getCourseByEnlistmentSemesterAndYearLevel(Enlistment__c enlistment){
        List<Course__c> course = [
            SELECT Id, Name, Units__c, Faculty__c, Faculty__r.Name, Semester__c, Course_Year_Level__c
            FROM Course__c
            WHERE Semester__c = :enlistment.Semester__c
            AND Course_Year_Level__c = :enlistment.Student_Year_Level__c
            ORDER BY Name
        ];

        return course;
    }
}