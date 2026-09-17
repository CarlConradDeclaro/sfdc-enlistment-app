public with sharing class EnlistmentTriggerHandler {
    



   // public static void checkExistingEnlistment(List<Enlistment__c> enlistment){

        // //get student id
        // Set<Id> studentId = new Set<Id>();
        // for(Enlistment__c en : enlistment){
        //     studentId.add(en.Student__c);
        // }

        // if(studentId.isEmpty())
        // return;


        // //fetch all enlistment related to student 
        // List<Enlistment__c> studentEnlistment = [
        //     SELECT Id,Academic_Year__c,Semester__c,Student__c
        //     FROM Enlistment__c
        //     WHERE  Student__c IN : studentId 
        // ];

 

        // //check if the current enlistment year and semester already exist

        // Map<Id,Set<String>> siblingsEnlistmentMap = new Map<Id,Set<String>>();
        // // dsgivndsg => 1st semester 2023-2024


        // for(Enlistment__c en : studentEnlistment){
        //     if(siblingsEnlistmentMap.containsKey(en.Student__c))
        //         siblingsEnlistmentMap.get(en.Student__c).addAll(getYearSemesterEnlistment(en));
        //     else
        //         siblingsEnlistmentMap.put(en.Student__c,getYearSemesterEnlistment(en));
        // }


        // if(!siblingsEnlistmentMap.isEmpty()){
            
        //         for(Enlistment__c en: enlistment){
        //             String currentYearAndSem = en.Academic_Year__c + ' ' + en.Semester__c;
        //             Set<String> siblingEnlisment = new Set<String>(siblingsEnlistmentMap.get(en.Student__c));

        //             if(siblingEnlisment.contains(currentYearAndSem)){
        //                 en.Academic_Year__c.addError('Enlistment for this current year already exists');
        //                 en.Semester__c.addError('Enlistment for this current semester already exists');
        //                 break;
        //         }
        //     }
        // }
  //  }


   //  public static Set<String> getYearSemesterEnlistment(Enlistment__c enlistment){

        // Set<String> enlistmentYearAndSemester = new Set<String>();
        
        //  enlistmentYearAndSemester.add(enlistment.Academic_Year__c + ' ' + enlistment.Semester__c);
        

        // return enlistmentYearAndSemester;

//    }
}