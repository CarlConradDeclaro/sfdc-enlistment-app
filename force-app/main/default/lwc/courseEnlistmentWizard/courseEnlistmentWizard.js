import { LightningElement, api } from 'lwc';
import createCourseEnlistment from '@salesforce/apex/CourseEnlistmentController.createCourseEnlistment'
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';


const LAST_STEP = 3 ;
const SUCCESS_MESSAGE = 'Course Successfully inserted';

export default class CourseEnlistmentWizard extends LightningElement {
    //this makes the recordId publicly available
    @api recordId; // this variable is auto-fill when you are in the record page 

    // these variables are accessible only in this component
    currentStep = 1; 
    courseId;
    courseName;
    loading =false;
    scheduleId;
    scheduleName;
    errorMessage;
    successMessage;
    isSuccess = false;

    units;


    get isStep1() { return this.currentStep === 1; }
    get isStep2() { return this.currentStep === 2; }
    get isStep3() { return this.currentStep === 3; }




    
    async handleCourseEnlistment(){
        this.errorMessage = null;
        this.loading = true;

        if(!this.recordId || !this.scheduleId){
            this.errorMessage  = 'Missing required information';
            return;
        }

        let res;
        try {
          res = await createCourseEnlistment({//create a course enlistment 
             courseScheduleId : this.scheduleId,
             enlistmentId : this.recordId
           })
           this.loading = false;
        } catch (error) {
            this.errorMessage = error?.body?.message ?? 'Something went wrong' ;
            this.isSuccess = false;
        }finally{
            this.loading = false;
        }

        if(!res){
          return;
        }else{
          notifyRecordUpdateAvailable([
            { recordId: this.recordId }]);
        }
        
        this.successMessage= SUCCESS_MESSAGE;
        this.isSuccess = true;

        

    }


    get currentStepString() {
        return String(this.currentStep);
    }

    //from custom event 
    handleCourseSelected(event) {
        this.courseId = event.detail.courseId;
        this.courseName = event.detail.courseName;
        this.units = event.detail.units
    }

    //custom event created from the child component
    handleScheduleSelected(event) {
    this.scheduleId = event.detail.scheduleId;
    this.scheduleName = event.detail.scheduleName;
    }

    handleNext() {
        if(this.currentStep < LAST_STEP)
            this.currentStep++;
    }

    
    async handleSave(){
        await this.handleCourseEnlistment();

    }

    handleBack() {
        this.currentStep--;

        this.isSuccess = false;
        this.errorMessage = null
    }

    get showPrevious() {
        return this.currentStep > 1;
    }

    get showNext() {
        return this.currentStep < LAST_STEP;
    }

    get isToSave(){
        return this.currentStep == LAST_STEP && !this.isSuccess;
    }

    get isNextDisabled() {
        if (this.isStep1) return false;    
        if (this.isStep2) return !this.courseId;
        return false;
    }

    get isSuccess(){
        return this.isSuccess;
    }
}