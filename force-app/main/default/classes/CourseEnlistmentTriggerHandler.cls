public with sharing class CourseEnlistmentTriggerHandler {
    public CourseEnlistmentTriggerHandler() {}

    public static void validateSchedule(
        List<Course_Enlistment__c> newCourseEnlistments
    ){

        
        List<Id> enlistmentList = new List<Id>();
        List<Id> courseScheduleList = new List<Id>();

        Map<Id,Set<String>> siblingCourseSheduleMap = new Map<Id,Set<String>>();
        // fsdgsggg => Monday 7am-8am
            //         Wednesday 9am - 10am

        //assign the enlistment and courseScheduleList 
        for( Course_Enlistment__c newCE :  newCourseEnlistments){
            enlistmentList.add(newCE.Enlistment__c);
            courseScheduleList.add(newCE.Course_Schedule__c);
        }

        //fetch all the course enlistment related to the student enlisment
        List<Course_Enlistment__c> siblingCourseEnlistmentList = new List<Course_Enlistment__c>();
        siblingCourseEnlistmentList = [SELECT Id,
                                              Name, 
                                              Enlistment__c, 
                                              Course_Schedule__c,
                                              Course_Schedule__r.Days_S__c,
                                              Course_Schedule__r.Time_Slots__c
                                       FROM Course_Enlistment__c
                                       WHERE Enlistment__c IN :enlistmentList
                                       ];

         // get the current course schedule that is being added
         // 
        Map<Id,Course_Schedule__c> currentCourseScheduleMap  = new Map<Id,Course_Schedule__c>(
            [SELECT Id, Days_S__c,Time_Slots__c 
            FROM Course_Schedule__c
            WHERE Id IN :courseScheduleList
            ]
        );

        // populate the siblingCourseSheduleMap with id keys and formatted days and slot time
        if(!siblingCourseEnlistmentList.isEmpty()){
            for(Course_Enlistment__c ce : siblingCourseEnlistmentList){
                if(siblingCourseSheduleMap.containsKey(ce.Enlistment__c))
                    siblingCourseSheduleMap.get(ce.Enlistment__c).addAll(getDailySched(ce));
                else
                    siblingCourseSheduleMap.put(ce.Enlistment__c,getDailySched(ce) );
            }
        }
       


      
      //check if there is a conflict with the selected course schedule   
        for(Course_Enlistment__c newCE: newCourseEnlistments){

            if(newCE.Enlistment__c == null || newCE.Course_Schedule__c == null)
              continue;

            Course_Schedule__c currentCourseSchedule = currentCourseScheduleMap.get(newCE.Course_Schedule__c);
               // fsdgsggg => Monday 7am-8am
            //         Wednesday 9am - 10am
            
            if( currentCourseSchedule == null)
            continue;
           
            Set<String> recScheduleSet = getCurrentDailySched(currentCourseSchedule);
         //   Monday 7am-8am
            //         Wednesday 9am - 10am                        
       
            if(siblingCourseSheduleMap.containsKey(newCE.Enlistment__c)){

                Set<String> siblingSlots = new Set<String>(
                siblingCourseSheduleMap.get(newCE.Enlistment__c)
                );  //   Monday 7am-8am
            //         Wednesday 9am - 10am    


                for(String slot :recScheduleSet ){
                    
                    if(siblingSlots.contains(slot)){
                        newCE.Course_Schedule__c.addError('Course has conflicting schedule');
                    break;
                    }
                }      
            }
        }

    }

    
    public static Set<String> getCurrentDailySched(Course_Schedule__c cs){
            Set<String> returnSet = new Set<String>();

            if(cs == null || String.isBlank(cs.Days_S__c) || String.isBlank(cs.Time_Slots__c))
             return returnSet;

            for(String day : cs.Days_S__c.split(';')){
                String sched = day.trim() + ' '+ cs.Time_Slots__c.trim();
                returnSet.add(sched);
            }
            return returnSet;
    }
 
    public static Set<String> getDailySched(Course_Enlistment__c ce){
            Set<String> returnSet = new Set<String>();

            if(ce == null || String.isBlank(ce.Course_Schedule__r.Days_S__c) || String.isBlank(ce.Course_Schedule__r.Time_Slots__c))
             return returnSet;

            for(String day : ce.Course_Schedule__r.Days_S__c.split(';')){
                String sched = day.trim() + ' '+ ce.Course_Schedule__r.Time_Slots__c.trim();
                returnSet.add(sched);
            }
            return returnSet;
        }




    // check if student trying to insert a course already exist in their current  enlistment
    public static void validateDuplicateCourse(List<Course_Enlistment__c> courseEnlistment){

        Set<Id> enlistmentIds = new Set<Id>();
        Set<Id> courseScheduleIds = new Set<Id>();

        // assign the set enlistment id and course schedule id
        for(Course_Enlistment__c ce: courseEnlistment){
            enlistmentIds.add(ce.Enlistment__c);
            courseScheduleIds.add(ce.Course_Schedule__c);
        }

        //fetch all course enlistment of the student
        List<Course_Enlistment__c> siblingCourseEnlistment = [
            SELECT Id, Name,
                   Enlistment__c,
                   Course_Schedule__c,
                   Course_Schedule__r.Course__c,
                   Course_Schedule__r.Course__r.Name
            FROM Course_Enlistment__c
            WHERE Enlistment__c IN :enlistmentIds
        ];

        //get all the course name of the student in the siblingcourseenlistment
        Set<String> courses  = new Set<String>();
        for(Course_Enlistment__c ce : siblingCourseEnlistment){
            courses.add(ce.Course_schedule__r.Course__r.Name);
        }

        //get the current course schedule 
        Map<Id,Course_Schedule__c> currentCourseMap = new Map<Id,Course_Schedule__c>([
            SELECT Id, Course__c,
                       Course__r.Name
            FROM Course_Schedule__c
            WHERE Id IN : courseScheduleIds
        ]);
 

        //check if the current selected course already exist in the siblingCourseEnlistment
    
        for(Course_Enlistment__c ce : courseEnlistment){

                Course_Schedule__c currentSchedule = currentCourseMap.get(ce.Course_Schedule__c);

                if(currentSchedule == null)
                continue;

                String currentCourse = currentSchedule.Course__r.Name;

                if(courses.contains(currentCourse)){
                    ce.Course_Schedule__c.addError('You can not add this course!');
                    break;
                }
        }
    }
}

