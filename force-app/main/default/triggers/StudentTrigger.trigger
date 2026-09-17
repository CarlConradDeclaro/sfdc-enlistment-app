trigger StudentTrigger on Contact (before insert, before  update,after update, after insert) {
    
      if(Trigger.isBefore && Trigger.isUpdate){
        StudentTriggerHandler.studentType(
            Trigger.New
        );
      }

      if(Trigger.isBefore ){
        StudentTriggerHandler.checkIsUserTaken(Trigger.New,Trigger.isUpdate);
      }
    


}