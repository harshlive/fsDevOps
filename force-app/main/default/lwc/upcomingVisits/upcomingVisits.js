import { LightningElement,track } from 'lwc';
import getVisitRecords from '@salesforce/apex/upcomingVisitController.getVisits'; 

export default class UpcomingVisits extends LightningElement {
    @track todayVisits;
    @track tomorrowVisits;
    connectedCallback()
    {
        getVisitRecords()
        .then(result => {
            console.log(result);
            this.todayVisits = result.TODAY;
            this.tomorrowVisits = result.TOMORROW;
        })
        .catch(error => {
            console.log(error);
        });
    }
    onTileClick(event) {
        console.log(event.target.id.split('-')[0]);
        let id = event.target.id.split('-')[0];
        if(id!=null && id!=undefined && id!='') {
        window.location.href = '/'+id;
        }
    }
}