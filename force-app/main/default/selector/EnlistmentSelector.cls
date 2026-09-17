public with sharing class EnlistmentSelector {
     
    public static Enlistment__c getEnlistmentById(Id enlistmentId){
           Enlistment__c enlistment = [
            SELECT Id, Semester__c, Student_Year_Level__c,
            Student__c,Total_Units__c, Maximum_Units__c
            FROM Enlistment__c
            WHERE Id = :enlistmentId
            LIMIT 1
        ];

        return enlistment;
    }
}