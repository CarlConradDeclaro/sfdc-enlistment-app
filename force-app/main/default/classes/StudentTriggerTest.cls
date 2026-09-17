@isTest()
public with sharing class StudentTriggerTest {


    @TestSetup
    static void setupData() {

        Contact student = TestDataFactory.createStudent('test','1st Year','BS IT','Eligible for Enlistment');
        Enlistment__c enlistment = TestDataFactory.createEnlistment('test enlistment',student,'1st Semester','AY 2023-2024');
        Course__c course = TestDataFactory.createCourse('test course','1st Semester','1st Year',3);
        Course_Schedule__c schedule = TestDataFactory.createCourseSchedule(course,'Monday;Wednesday','7:00 AM - 8:00 AM','A01');

        Course_Enlistment__c existing = TestDataFactory.createCourseEnlistment(enlistment,schedule);

     }
   
    @IsTest // test user if the student record type is converted to regular when maintaining grades is no longer met
    static void studentConvertToRegularTest() {

            Id scholarRT = Schema.SObjectType.Contact
                        .getRecordTypeInfosByName()
                        .get('Scholar')
                        .getRecordTypeId();

            Contact student = [
                        SELECT Id,
                            RecordTypeId,
                            Maintaining_G__c
                        FROM Contact
                        LIMIT 1
            ];

            student.RecordTypeId = scholarRT;
            student.Maintaining_G__c = 90;

            Enlistment__c enlistment = [
                    SELECT Id,
                        Student__c
                    FROM Enlistment__c
                    WHERE Student__c = :student.Id
                    LIMIT 1
            ];

            Course_Enlistment__c existingCourseEnlistment = [
                    SELECT Id,student__c
                    FROM Course_Enlistment__c
                    WHERE Enlistment__c = :enlistment.Id
                    LIMIT 1
            ];

            existingCourseEnlistment.Course_Grade__c = 80;
            Test.startTest();
                update student;
                update existingCourseEnlistment;
            Test.stopTest();


            Contact updatedStudent = [
                    SELECT RecordTypeId,
                        Current_GPA__c,
                        Maintaining_G__c,
                        Scholarship_Type__c,
                        Tuition_Discount__c
                    FROM Contact
                    WHERE Id = :student.Id
            ];

            System.assertEquals(
                    80,
                    updatedStudent.Current_GPA__c,
                    'Current GPA should become 80.'
            );

                System.assertNotEquals(
                    scholarRT,
                    updatedStudent.RecordTypeId,
                    'The student should no longer have the Scholar record type.'
            );
}

         @IsTest // test user if the student record type is unchanged when the current grade still above the maintaining grade when course grade is updated
         static void studentMaintainScholarTypeTest() {

            Id scholarRT = Schema.SObjectType.Contact
                        .getRecordTypeInfosByName()
                        .get('Scholar')
                        .getRecordTypeId();

            Contact student = [
                        SELECT Id,
                            RecordTypeId,
                            Maintaining_G__c
                        FROM Contact
                        LIMIT 1
            ];

            student.RecordTypeId = scholarRT;
            student.Maintaining_G__c = 90;

            Enlistment__c enlistment = [
                    SELECT Id,
                        Student__c
                    FROM Enlistment__c
                    WHERE Student__c = :student.Id
                    LIMIT 1
            ];

            Course_Enlistment__c existingCourseEnlistment = [
                    SELECT Id
                    FROM Course_Enlistment__c
                    WHERE Enlistment__c = :enlistment.Id
                    LIMIT 1
            ];
            
            existingCourseEnlistment.Course_Grade__c = 95;

            Test.startTest();
                update student;
                update existingCourseEnlistment;
            Test.stopTest();

            Contact updatedStudent = [
                    SELECT RecordTypeId,
                        Current_GPA__c,
                        Maintaining_G__c,
                        Scholarship_Type__c,
                        Tuition_Discount__c
                    FROM Contact
                    WHERE Id = :student.Id
            ];

            System.assertEquals(
                    95,
                    updatedStudent.Current_GPA__c,
                    'Current GPA should become 95.'
            );

                System.assertEquals(
                    scholarRT,
                    updatedStudent.RecordTypeId,
                    'The student should still have the Scholar record type.'
            );
}
 

}