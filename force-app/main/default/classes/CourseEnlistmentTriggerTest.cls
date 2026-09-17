@IsTest()
public  class CourseEnlistmentTriggerTest {

     @TestSetup
    static void setupData() {

        Contact student = TestDataFactory.createStudent('test','1st Year','BS IT','Eligible for Enlistment');
        Enlistment__c enlistment = TestDataFactory.createEnlistment('test enlistment',student,'1st Semester','AY 2023-2024');
        Course__c course = TestDataFactory.createCourse('test course','1st Semester','1st Year',3);
        Course_Schedule__c schedule = TestDataFactory.createCourseSchedule(course,'Monday;Wednesday','7:00 AM - 8:00 AM','A01');

        Course_Enlistment__c existing = TestDataFactory.createCourseEnlistment(enlistment,schedule);



        Course__c course2 = TestDataFactory.createCourse('test course2','1st Semester','1st Year',3);
        Course_Schedule__c schedule2 = TestDataFactory.createCourseSchedule(course2,'Thursday;Friday','9:00 AM - 10:00 AM','A02');
     }

 

    @IsTest()// test a conflict schedule
    static void insertInvalideCourseEnlistmentTest(){

          Enlistment__c enlistment = [
            SELECT Id,Academic_Year__c,Semester__c,Student__c
            FROM Enlistment__c
            LIMIT 1
        ];
       
        Course_Schedule__c existingSchedule = [
        SELECT Id
        FROM Course_Schedule__c
        LIMIT 1
        ];
        Course_Enlistment__c courseEnlistmentTest = new Course_Enlistment__c(Course_Schedule__c = existingSchedule.Id ,Enlistment__c =enlistment.Id );
      

        Test.startTest();

        Database.SaveResult  result = Database.insert(
            courseEnlistmentTest,
            false
        );

        Test.stopTest();

        System.assertEquals(false,result.isSuccess(),'course enlistment shound be inserted');

        System.assertEquals('Course has conflicting schedule', result.getErrors()[0].getMessage());

        System.debug('ERROR: ' + result.getErrors()[0].getMessage());

        System.assertEquals(
            false,
            result.isSuccess()
        );

    }


     @IsTest()// test a course enlistment that has no conflict
    static void insertValidCourseEnlistmentTest(){

          Enlistment__c enlistment = [
            SELECT Id,Academic_Year__c,Semester__c,Student__c
            FROM Enlistment__c
            LIMIT 1
        ];

        Course__c course = [
            SELECT Id, Name
            FROM Course__c
            WHERE Name = 'test course2'
        ];
       
        Course_Schedule__c newSchedule = [
        SELECT Id, Course__c
        FROM Course_Schedule__c
        WHERE Course__c = :course.Id
        ];

        Course_Enlistment__c courseEnlistmentTest = new Course_Enlistment__c(Course_Schedule__c = newSchedule.Id ,Enlistment__c =enlistment.Id );
      

        Test.startTest();

        Database.SaveResult  result = Database.insert(
            courseEnlistmentTest,
            false
        );

        Test.stopTest();

        System.assertEquals(true,result.isSuccess(), 'course enlistment should insert successfully');


    }

   
    
}
 





    
