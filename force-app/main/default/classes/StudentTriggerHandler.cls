public with sharing class StudentTriggerHandler {


     public static void studentType(List<Contact> student){

       

        // RecordType regularRT = [
        //     SELECT Id
        //     FROM RecordType
        //     WHERE SObjectType = 'Contact'
        //     AND Name = 'Regular Student'
        //     LIMIT 1
        // ];

        Id regularRT = Schema.SObjectType.Contact
                       .getRecordTypeInfosByName()
                       .get('Regular Student')
                       .getRecordTypeId();





        for(Contact std : student){

            if(  std.Current_GPA__c > 0 && std.Maintaining_G__c > std.Current_GPA__c  ) {
                std.RecordTypeId = regularRT;
                std.Scholarship_Type__c = null;
                std.Tuition_Discount__c = null;
            }   
        }

 }


 
 public static void checkIsUserTaken(List<Contact> student,Boolean isUpdate){


    if(isUpdate)
    return;

    
    Set<Id> studentId = new Set<Id>();

    for(Contact std: student){
        studentId.add(std.User__c);
    }

    //fetch all student information
    List<Contact> allStudents = [
        SELECT Id,Name, User__c
        FROM Contact
        WHERE User__c IN :studentId
    ];


    if(!allStudents.isEmpty()){
        for(Contact std : student){
            std.User__c.addError('User is already taken');
        }
    }

 }
}