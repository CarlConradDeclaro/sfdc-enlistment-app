import { LightningElement, api, wire } from 'lwc';
import getCourses from '@salesforce/apex/CourseEnlistmentController.getCourses';

export default class CoursePicker extends LightningElement {
    @api recordId;

    courses = [];
    selectedId;
    errorMessage;

    @wire(getCourses, { enlistmentId: '$recordId' })
    wireCourses({ data, error }) {
        if (data) {
            this.rawCourses = data;
            this.buildRows();
            this.errorMessage = undefined;
        } else if (error) {
            this.courses = [];
            this.errorMessage = error?.body?.message || 'Could not load courses';
        }
    }

    rawCourses = [];

    buildRows() {
        this.courses = this.rawCourses.map(c => ({
            Id: c.Id,
            name: c.Name,
            units: c.Units__c,
            facultyName: c.Faculty__r ? c.Faculty__r.Name : '',
            facultyUrl: c.Faculty__c ? `/${c.Faculty__c}` : '#',
            selected: c.Id === this.selectedId,
            rowClass: c.Id === this.selectedId
                ? 'slds-hint-parent row-selected'
                : 'slds-hint-parent'
        }));
    }

    handleSelect(event) {
    this.selectedId = event.target.dataset.id;
    this.buildRows();
    this.notifyParent();
    }

    handleRowClick(event) {
        this.selectedId = event.currentTarget.dataset.id;
        this.buildRows();
        this.notifyParent();
    }

    notifyParent() {
        const c = this.selectedCourse;
        this.dispatchEvent(new CustomEvent('courseselected', {
            detail: { courseId: c.Id, courseName: c.name, units: c.units }
        }));
    }

    get selectedCourse() {
        return this.courses.find(c => c.Id === this.selectedId);
    }

    get selectionLabel() {
        const c = this.selectedCourse;
        return c ? `${c.name} — ${c.units} units` : 'No course selected';
    }

    get hasCourses() {
        return this.courses.length > 0;
    }

 

    handleNext() {
        console.log(this.selectedId);
    }
}