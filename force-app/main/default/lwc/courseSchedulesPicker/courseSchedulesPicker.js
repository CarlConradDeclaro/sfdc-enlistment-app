import { LightningElement, api, wire } from 'lwc';

import getCourseScheduleByEnlistment from '@salesforce/apex/CourseEnlistmentController.getCourseScheduleByEnlistment';

export default class CourseSchedulesPicker extends LightningElement {
    @api recordId;      // the Enlistment Id, passed down
    @api courseId;      // the course chosen in step 2, passed down
    @api courseName;

    schedules = [];
    selectedId;
    errorMessage;

    @wire(getCourseScheduleByEnlistment, {
        enlistmentId: '$recordId',
        selectedCourseId: '$courseId'
    })
    wireSchedules({ data, error }) {
        if (data) {
            this.schedules = data.map(s => ({
            Id: s.Id,
            daysList: s.Days_S__c ? s.Days_S__c.split(';') : [],
            daysText: s.Days_S__c ? s.Days_S__c.split(';').join(', ') : '',
            timeSlot: s.Time_Slots__c,
            venue: s.Venue__c,
            selected: false,
            rowClass: 'slds-hint-parent'
        }));
            this.errorMessage = undefined;
        } else if (error) {
            this.schedules = [];
            this.errorMessage = error?.body?.message || 'Could not load schedules';
        }
    }

    handleRowClick(event) {
        this.selectedId = event.currentTarget.dataset.id;
        this.schedules = this.schedules.map(s => ({
            ...s,
            selected: s.Id === this.selectedId,
            rowClass: s.Id === this.selectedId
                ? 'slds-hint-parent row-selected'
                : 'slds-hint-parent'
        }));
        this.notifyParent();
    }

    notifyParent() {
        const s = this.schedules.find(x => x.Id === this.selectedId);
        this.dispatchEvent(new CustomEvent('scheduleselected', {
            detail: {
                scheduleId: s.Id,
                scheduleName: `${s.days} ${s.timeSlot}`
            }
        }));
    }

    get hasSchedules() {
        return this.schedules.length > 0;
    }
}