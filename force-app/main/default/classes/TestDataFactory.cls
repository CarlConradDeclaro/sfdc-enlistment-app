@isTest
public with sharing class TestDataFactory {


    
    

    public static Contact createStudent(String lastName,String year, String degree,String status){
          Contact student = new Contact(
             LastName = lastName,
             Year_label__c = year,
             Degree_Program__c =degree,
             Status__c = status
        );

        
        insert student;

        return student;
    }


    public static Enlistment__c createEnlistment(String name,Contact student, String semester,String academicYear){
         Enlistment__c enlistment = new Enlistment__c(
            Name = name,
            Student__c = student.Id,
            Semester__c = semester,
            Academic_Year__c = academicYear
        );

        insert enlistment;

        return enlistment;
    }

    public static Course__c createCourse(String name, String semester,String courseYearLevel,Integer units){

        Course__c course = new Course__c(
            Name = name,
             Semester__c = semester,
            Course_Year_Level__c = courseYearLevel,
            Units__c = units
        );
        insert course;

        return course;
    }

    public static Course_Schedule__c createCourseSchedule(Course__c course,String days,String timeslots, String venue){
          Course_Schedule__c schedule = new Course_Schedule__c(
            Course__c = course.Id,
            Days_S__c = days,
            Time_Slots__c = timeSlots,
            Venue__c = venue
        );
        insert schedule;

        return schedule;
    }


    public static Course_Enlistment__c createCourseEnlistment(Enlistment__c enlistment,Course_Schedule__c schedule){
         Course_Enlistment__c courseEnlistment = new Course_Enlistment__c(
            Enlistment__c = enlistment.Id,
            Course_Schedule__c = schedule.Id
        );
        insert courseEnlistment;

        return courseEnlistment;
    }


}