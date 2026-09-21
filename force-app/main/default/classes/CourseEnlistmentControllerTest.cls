@IsTest
private class CourseEnlistmentControllerTest {

    
    @TestSetup
    static void makeData(){
         Contact student = TestDataFactory.createStudent(
            'test',
            '1st Year',
            'BS IT',
            'Eligible for Enlistment'
        );

        Enlistment__c enlistment = TestDataFactory.createEnlistment(
            'test enlistment',
            student,
            '1st Semester',
            'AY 2023-2024'
        );

        Course__c course = TestDataFactory.createCourse(
            'test course',
            '1st Semester',
            '1st Year',
            3
        );

        TestDataFactory.createCourseSchedule(
            course,
            'Monday;Wednesday',
            '7:00 AM - 8:00 AM',
            'A01'
        );
    }
   

    @IsTest
    static void testGetCourses() {

        Enlistment__c enlistment = [
            SELECT Id,Academic_Year__c,Semester__c,Student__c
            FROM Enlistment__c
            LIMIT 1
        ];

        Test.startTest();

        List<Course__c> courses =
            CourseEnlistmentController.getCourses(
                enlistment.Id
            );

        Test.stopTest();

        System.assertEquals(
            1,
            courses.size(),
            'Should return one course'
        );
    }

    @IsTest
    static void testGetCourseScheduleByEnlistment() {

          Enlistment__c enlistment = [
            SELECT Id,Academic_Year__c,Semester__c,Student__c
            FROM Enlistment__c
            LIMIT 1
        ];

        Course__c course = [
            SELECT Id
            FROM Course__c
            LIMIT 1
        ];

        Test.startTest();

        List<Course_Schedule__c> schedules =
            CourseEnlistmentController.getCourseScheduleByEnlistment(
                enlistment.Id,
                course.Id
            );

        Test.stopTest();

        System.assertEquals(
            1,
            schedules.size(),
            'Should return one schedule'
        );

        System.assertEquals(
            course.Id,
            schedules[0].Course__c
        );
    }

    @IsTest
    static void testCreateCourseEnlistment() {

           Enlistment__c enlistment = [
            SELECT Id,Academic_Year__c,Semester__c,Student__c
            FROM Enlistment__c
            LIMIT 1
        ];

        Course__c course2 = TestDataFactory.createCourse(
            'controller course',
            '1st Semester',
            '1st Year',
            3
        );

        Course_Schedule__c schedule2 =
            TestDataFactory.createCourseSchedule(
                course2,
                'Thursday;Friday',
                '9:00 AM - 10:00 AM',
                'A02'
            );

        Test.startTest();

        Id resultId =
            CourseEnlistmentController.createCourseEnlistment(
                schedule2.Id,
                enlistment.Id
            );

        Test.stopTest();

        System.assertNotEquals(
            null,
            resultId
        );

        Course_Enlistment__c ce = [
            SELECT Id,
                   Course_Schedule__c,
                   Enlistment__c
            FROM Course_Enlistment__c
            WHERE Id = :resultId
        ];

        System.assertEquals(
            enlistment.Id,
            ce.Enlistment__c
        );

        System.assertEquals(
            schedule2.Id,
            ce.Course_Schedule__c
        );
    }

    @IsTest
    static void testCreateCourseEnlistment_MaxUnitsExceeded() {

        Contact student = TestDataFactory.createStudent(
            'student2',
            '1st Year',
            'BS IT',
            'Eligible for Enlistment'
        );

        Enlistment__c enlistment = TestDataFactory.createEnlistment(
            'max units enlistment',
            student,
            '1st Semester',
            'AY 2023-2024'
        );

        enlistment.Maximum_Units__c = 3;
        enlistment.Total_Units__c = 2;
        update enlistment;

        Course__c course = TestDataFactory.createCourse(
            'Physics',
            '1st Semester',
            '1st Year',
            3
        );

        Course_Schedule__c schedule =
            TestDataFactory.createCourseSchedule(
                course,
                'Saturday',
                '1:00 PM - 2:00 PM',
                'A03'
            );

        Test.startTest();

        try {

            CourseEnlistmentController.createCourseEnlistment(
                schedule.Id,
                enlistment.Id
            );

            System.assert(
                false,
                'Expected AuraHandledException'
            );

        } catch (AuraHandledException e) {

            System.assert(
                e.getMessage().contains(
                    'Maximum units exceeded'
                )
            );
        }

        Test.stopTest();
    }
}