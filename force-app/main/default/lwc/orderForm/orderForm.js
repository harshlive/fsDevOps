import { LightningElement,track } from 'lwc';
// import standard toast event 
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
export default class OrderForm extends LightningElement {
  
   @track searchKey;
   sVal = '';
 
   updateSeachKey(event) {
    this.sVal = event.target.value;
}
handleSearch() {
if (this.sVal !== '') {
  
} else {
    // fire toast event if input field is blank
    const event = new ShowToastEvent({
        variant: 'error',
        message: 'Search text missing..',
    });
    this.dispatchEvent(event);
}
}
}