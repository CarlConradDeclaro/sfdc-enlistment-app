public with sharing class CourseSchedulesTriggerHandler {
  


    // public static void checkDuplicateSchedules(List<Course_Schedule__c> courseSchedules){


    //     Set<String> venue = new Set<String>();
    //     Set<String> timeSlot = new Set<String>();

    //     for(Course_Schedule__c cs : courseSchedules ){
    //         venue.add(cs.Venue__c);
    //         timeSlot.add(cs.Time_Slots__c);
    //     }

        
    //     //get the current course schedule 
    //     List<Course_Schedule__c> courseScheduleList = new List<Course_Schedule__c>();
    //     courseScheduleList = [
    //         SELECT Id,Days_S__c,Venue__c,Time_Slots__c
    //         FROM Course_Schedule__c
    //         WHERE Venue__c IN : venue  AND Time_Slots__c IN :timeSlot
    //     ];



    //     if(!courseScheduleList.isEmpty()){

    //         for(Course_Schedule__c newCS: courseSchedules){
    //         Set<String> days = new Set<String>(newCS.Days_S__c.split(';'));
              

    //             for(Course_Schedule__c existingCS : courseScheduleList){
                   

    //                 Set<String> existingDays = new Set<String>(existingCS.Days_S__c.split(';'));
    //                 existingDays.retainAll(days);
                    
                   
                  

    //                 if(!existingDays.isEmpty()){
    //                     if(newCS.Time_Slots__c == existingCS.Time_Slots__c )
    //                         newCS.Time_Slots__c.addError('There is a conflict with this selected time slots, please select another Time slot');
    //                     if(newCS.Venue__c == newCS.Venue__c)
    //                         newCS.Venue__c.addError('There is a conflict with this selected Venue, please select another Venue');
    //                         break;
    //                     }
    //             }
              
    //         }
    //     }

  //  }
}