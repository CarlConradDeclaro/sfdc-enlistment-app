import { LightningElement, api } from 'lwc';
import createCourseEnlistment from '@salesforce/apex/CourseEnlistmentController.createCourseEnlistment'
const LAST_STEP = 3 ;

export default class CourseEnlistmentWizard extends LightningElement {
    @api recordId;

    currentStep = 1;
    courseId;
    courseName;
    loading =false;
    scheduleId;
    scheduleName;
    errorMessage;
    successMessage;
    isSuccess = false;

    Units;


    get isStep1() { return this.currentStep === 1; }
    get isStep2() { return this.currentStep === 2; }
    get isStep3() { return this.currentStep === 3; }



    async handleCourseEnlistment(){
        this.errorMessage = null;
        this.loading = true;

        let res;
        try {


          res = await createCourseEnlistment({
             courseScheduleId : this.scheduleId,
             enlistmentId : this.recordId
           })
           this.loading = false;
 

        } catch (error) {
            this.errorMessage = error?.body?.message ?? 'Something went wrong' ;
            this.isSuccess = false;
        }
         this.loading = false;

        if(res){
            this.successMessage= 'Course Successfully inserted'
            this.isSuccess = true;
        }

    }


    get currentStepString() {
        return String(this.currentStep);
    }

    handleCourseSelected(event) {
        this.courseId = event.detail.courseId;
        this.courseName = event.detail.courseName;
        this.Units = event.detail.units
    }

    handleScheduleSelected(event) {
    this.scheduleId = event.detail.scheduleId;
    this.scheduleName = event.detail.scheduleName;
    }

    handleNext() {
        this.currentStep += 1;
    }

    handleSave(){
        this.handleCourseEnlistment();
    }

    handleBack() {
        this.currentStep -= 1;
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
        return this.currentStep == LAST_STEP && this.isSuccess == false;
    }

    get isNextDisabled() {
        if (this.isStep1) return false;      // welcome screen - always allowed
        if (this.isStep2) return !this.courseId;
        return false;
    }

    get isSuccess(){
        return this.isSuccess;
    }
}