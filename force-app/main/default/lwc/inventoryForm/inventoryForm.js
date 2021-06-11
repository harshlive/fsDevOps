import { LightningElement, wire,track,api} from 'lwc';

/** BearController.getAllBears() Apex method */
//import fetchproduct from '@salesforce/apex/OrderFormClass.fetchproduct';
import searchBears from '@salesforce/apex/OrderFormClass.searchBears';
import getproductbypricebookname from '@salesforce/apex/OrderFormClass.Selectpicval';
import createInventory from '@salesforce/apex/OrderFormClass.createInventory';
import INVENTORY_OBJECT from '@salesforce/schema/Inventory__c';
import INVENTORY_LINE_ITEM_OBJECT from '@salesforce/schema/Inventory_Line_Item__c';
import {  ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { getPicklistValues } from 'lightning/uiObjectInfoApi';
//import Name_FIELD from '@salesforce/schema/Pricebook2.Name';
//import { getObjectInfo } from 'lightning/uiObjectInfoApi';
//import selectpicklistval from '@salesforce/apex/OrderFormClass.Selectpicval';


export default class inventoryForm extends LightningElement {
	
@track discount=0;
//@track CP=0;
@track SP=0;
@track inventoryrecordId=INVENTORY_OBJECT;
@track lineitemrecordId=INVENTORY_LINE_ITEM_OBJECT;
	@wire(getproductbypricebookname)
	optionList;
	@api recordId;
	@track val;
@track defaultVal='01s3h000000yiPqAAI';	
	
   get statusOptions(){
	var returnOptions = [];
	if(this.optionList.data){
		this.optionList.data.forEach(ele=>{
	 returnOptions.push({label:ele.Name,value:ele.Id});

		});
		console.log(JSON.stringify(returnOptions));
		
		this.defaultVal = returnOptions[0].value;
		console.log('this.defaultVal')
		console.log(this.defaultVal);
		console.log('this.label',this.label);
		return returnOptions;
	}
	console.log('returnOptions[0]',returnOptions[0].label);
	//if(value == null && label==null){
		this.val=returnOptions[0].value;
	//}
   }
   //@track selectedOption;
   updateQty(event) {
	   //alert('in updateQty');
	   console.log(event);
	   if(event.target.value!==null && event.target.value!='') {
		   console.log(event.target.value);
		   console.log(event.target.name);
		   if(!isNaN(event.target.value)) {
		   for(var j=0;j<this.tableList.length;j++) {
			if(this.tableList[j].Id == event.target.name) {
				this.tableList[j].Qty = parseInt(event.target.value); 
				break;
			}
		}
	}
	else {
		alert('Please enter valid quantity');
	}
		   
	   }
   }
   @track searchTerm = '';
   @track pickval='01s3h000000yiPqAAI';
	@wire(searchBears, {searchTerm: '$searchTerm',pickval:'$pickval'})
	bears;
	
   @track tableList=[];
   //console.log('tableList',this.tableList.id);
  
   @track prodIdSet =[];
  // @track visitId;	
	handleSearchTermChange(event) {
		
		let field = event.target.name;
		if(field === 'SearchBar'){
		this.searchTerm = event.target.value;
		console.log('searchTerm',this.searchTerm);
		}
		if(field === 'Pricebook Name'){
		this.pickval=event.target.value;
		console.log('pickval',this.pickval);
		}
		// searchBears({searchTerm: this.searchTerm,pickval:this.pickval})
        //     .then(result => {
		// 	   consolelog(result);
		// 	   this.bears = result;
        //     })
        //     .catch(error => {
        //         console.log(error);
        //     });
	}
	
	get hasResults() {
		return (this.bears.data.length > 0);
	}
	
	Add(event){
		
		let product_id=event.target.name;
		for(var i=0;i<this.bears.data.length;i++) {
			if(this.bears.data[i].Id == product_id) {
				if(this.prodIdSet.indexOf(product_id) === -1) {
				this.tableList.push(
					{
						Id: this.bears.data[i].Id,
						Product2Id: this.bears.data[i].Product2Id,
						Pricebook2Id: this.bears.data[i].Pricebook2Id,
						UnitPrice: this.bears.data[i].UnitPrice,
						Qty:1,
						//discount:UnitPrice*Qty,
						CP:parseFloat(this.UnitPrice)*parseFloat(this.Qty),
						//Sp:UnitPrice*Qty-discount,
						visitId : this.recordId,
						Productc:
							{
								Name: this.bears.data[i].Product2.Name,
								ProductCode: this.bears.data[i].Product2.ProductCode,
								Id: this.bears.data[i].Product2.Id
							},
						Pricebookc:
							{
								Id: this.bears.data[i].Pricebook2.Id
							}
					}
				);
				this.prodIdSet.push(this.bears.data[i].Id);
				console.log(this.prodIdSet);
				break;
				}
				else {
					for(var j=0;j<this.tableList.length;j++) {
						if(this.tableList[j].Id == product_id) {
							this.tableList[j].Qty = this.tableList[j].Qty + 1; 
							break;
						}
					}
				}
			}

		}

this.template.querySelector("lightning-datatable").data=this.tableList;
		console.log(this.template.querySelector("lightning-datatable").data=this.tableList);
       console.log('this.tableList',this.tableList);
	  
	}
	
	removeRow(event){

//console.log('this.tableList.id',this.tableList.data);
let remove_product=event.target.name;
console.log('remove_product',remove_product);
		for(var i=0;i<this.tableList.length;i++) {
if(this.tableList[i].Id == remove_product) {
	this.tableList.pop(this.tableList[i]);
}	
	}
	console.log(this.tableList);
}

	saveClick(event){
	
		window.console.log('In createRec ===> ');
		console.log(this.tableList);
        createInventory({
			jsonString: JSON.stringify(this.tableList)
			
            })
            .then(result => {
                // Clear the user enter values
				//this.inventoryrecordId = {};
			
                window.console.log('result ===> ' + result);
                // Show success messsage
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Record Created Successfully!!',
                    variant: 'success'
                }), );
            })
            .catch(error => {
				this.error = error.message;
				console.log( error.message)
            });

    
	}

clearClick(event){

	this.tableList=[];
	
}

}