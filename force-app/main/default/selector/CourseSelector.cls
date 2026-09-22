public with sharing class CourseSelector {

    private static final Decimal PASSING_GRADE = 75;

    // return the selected course by id
    public static Course__c getSelectedCourseById(Course_Schedule__c courseSchedule) {
        if (courseSchedule == null || courseSchedule.Course__c == null) {
            return null;
        }

        return [
            SELECT Id, Units__c
            FROM Course__c
            WHERE Id = :courseSchedule.Course__c
            LIMIT 1
        ];
    }

    // return lis of courses based on the semester and year level 
    public static List<Course__c>getCourseByEnlistmentSemesterAndYearLevel(Enlistment__c enlistment) {

        List<Course__c> matchingCourses = [
            SELECT Id,Name,Units__c,Faculty__c,Faculty__r.Name,
                   Semester__c,Course_Year_Level__c,Prerequisite__c,Prerequisite__r.Name
            FROM Course__c
            WHERE Semester__c = :enlistment.Semester__c
            AND Course_Year_Level__c =:enlistment.Student_Year_Level__c
            ORDER BY Name
        ];

        if (matchingCourses.isEmpty()) {
            return new List<Course__c>();
        }

        // initialize a set to store all course with prerequisites
        Set<Id> prerequisiteCourseIds = new Set<Id>();

        for (Course__c course : matchingCourses) {
            if (course.Prerequisite__c != null)
                prerequisiteCourseIds.add(course.Prerequisite__c); // add the id to the prerequisiteCourseIds if there is prerequisite course
        }
        
        if(prerequisiteCourseIds.isEmpty()) {
            return matchingCourses; // return all the matching courses because all there were no prerequisites
        }

        Set<Id> passedCourseIds = new Set<Id>();

        //fetch all the courses that has prerequisite and check if passed
        List<Course_Enlistment__c> passedCourseEnlistments = [
            SELECT Id,Course_Grade__c,Course_Schedule__r.Course__c
            FROM Course_Enlistment__c
            WHERE Student__c = :enlistment.Student__c
            AND Course_Schedule__r.Course__c IN :prerequisiteCourseIds
            AND Course_Grade__c > :PASSING_GRADE
        ];

        for (Course_Enlistment__c previousCourse :passedCourseEnlistments) {
            passedCourseIds.add(previousCourse.Course_Schedule__r.Course__c); // add all the passedCourseEnlistment to passedCourseIds
        }

        List<Course__c> eligibleCourses = new List<Course__c>();

        for (Course__c course : matchingCourses) {
            Boolean hasNoPrerequisite = course.Prerequisite__c == null;// the course doesnt have a prerequisite

            Boolean passedPrerequisite = passedCourseIds.contains(course.Prerequisite__c); // the course has prerequisite and check if it passed
            
            //either hasNoPreRequisite or passedPrequisite is true it will be added in the eligibleCourses list
            if (hasNoPrerequisite || passedPrerequisite) {
                eligibleCourses.add(course);
            }
        }

        return eligibleCourses;
    }
}