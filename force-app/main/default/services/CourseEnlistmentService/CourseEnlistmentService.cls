public with sharing class CourseEnlistmentService {
   
    private static final String MAX_UNITS_ERROR = 'Maximum units exceeded';

    //fetch all the courses
    public static List<Course__c> getCourses(Id enlistmentId){
        if(enlistmentId == null)
            return new List<Course__c>();
        Enlistment__c enlistment = EnlistmentSelector.getEnlistmentById(enlistmentId);

        return CourseSelector.getCourseByEnlistmentSemesterAndYearLevel(enlistment);
    }
    
    //fetch course schedule based on the selected course 
    public static List<Course_Schedule__c> getCourseScheduleByEnlistment(Id enlistmentId, Id selectedCourseId) {
        if (enlistmentId == null || selectedCourseId == null)
            return new List<Course_Schedule__c>();
        return CourseScheduleSelector.getCourseScheduleBySelectedCourse(selectedCourseId);
    }

    //create a course enlistment
    public static Id createCourseEnlistment(Id courseScheduleId,Id enlistmentId){

        Enlistment__c enlistment = EnlistmentSelector.getEnlistmentById(enlistmentId);
        Course_Schedule__c cs = CourseScheduleSelector.getSelectedCourseScheduleById(courseScheduleId);
        Course__c course = CourseSelector.getSelectedCourseById(cs);
        
        Decimal totalUnits = enlistment.Total_Units__c + course.Units__c;
        if(checkUnitsExceed(enlistment.Maximum_Units__c, totalUnits))
            throw new AuraHandledException(MAX_UNITS_ERROR);

        try {
            Course_Enlistment__c newCE =  new Course_Enlistment__c(
                Course_Schedule__c = courseScheduleId,
                Enlistment__c = enlistmentId,
                Student__c = enlistment.Student__c
            );

            insert newCE;
            updateTotalUnits(enlistment, course.Units__c);

            return newCe.Id;
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        }
    }
    // update the total units in the enlistment when a new course is inserted
     private static void updateTotalUnits(Enlistment__c enlistment,Decimal numberOfUnits){

        Decimal currentTotalUnits = enlistment.Total_Units__c == null?   0.0: enlistment.Total_Units__c;   
        currentTotalUnits+=numberOfUnits;

        Enlistment__c newEnlistment  = new Enlistment__c();
        newEnlistment.Id = enlistment.Id;
        newEnlistment.Total_Units__c = currentTotalUnits;

        update newEnlistment;
    }

    //check if the the units exceed the maximum value
    private static Boolean checkUnitsExceed(Decimal maxUnits, Decimal numberOfUnits){
        return numberOfUnits > maxUnits;
    }
}