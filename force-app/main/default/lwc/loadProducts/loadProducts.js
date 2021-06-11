import { LightningElement, wire,track,api } from 'lwc';

import searchBears from '@salesforce/apex/OrderFormClass.searchBears';
import getproductbypricebookname from '@salesforce/apex/OrderFormClass.Selectpicval';
import Creatorder from '@salesforce/apex/OrderFormClass.Creatorder';
import ORDER_OBJECT from '@salesforce/schema/Order';
import ORDER_LINE_ITEM_OBJECT from '@salesforce/schema/OrderItem';
import {  ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class BearList extends LightningElement {
	//abc="01s3h000000yiPqAAI";

	@track orderid;
	@track multiplication=0;
	@track promocode=0;
	@track orderrecordId=ORDER_OBJECT;
	@track orderitemrecordId=ORDER_LINE_ITEM_OBJECT;
		@wire(getproductbypricebookname)
		optionList;
		@api recordId;
		@track val;
		//value = this.returnOptions[0];
		@track defVal ='01s3h000000yiPqAAI';
	   get statusOptions(){
		var returnOptions = [];
		if(this.optionList.data){
			this.optionList.data.forEach(ele=>{
		 returnOptions.push({label:ele.Name,value:ele.Id});
	
			});
			console.log(JSON.stringify(returnOptions));
			this.val=returnOptions[0].value;
			return returnOptions;
		}
	   }
	   //@track selectedOption;
	   @track searchTerm = '';
	   @track pickval='01s3h000000yiPqAAI';
		@wire(searchBears, {searchTerm: '$searchTerm',pickval:'$pickval'})
		bears;
	//	@track TotalList=bears.data;
	   @track tableList=[];
	   @track prodIdSet =[];	
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
					 this.tableList[j].SP = this.tableList[j].Qty * this.tableList[j].UnitPrice*(1-this.tableList[j].Discount/100); 
					 break;
				 }
			 }
			 this.multiplication=0;
	  for(var i=0;i<this.tableList.length;i++){
		  console.log('i',i);
		  var fetchrec=parseFloat(this.tableList[i].Qty)*parseFloat(this.tableList[i].UnitPrice)*(1-parseFloat(this.tableList[i].Discount)/100);
		 this.multiplication=fetchrec+this.multiplication;
		  console.log(' this.multiplication', this.multiplication);
	
		}
		 }
		 else {
			 alert('Please enter valid quantity');
		 }
				
			}
		}
		updateDisc(event) {
			console.log(event);
			if(event.target.value!==null && event.target.value!='') {
				console.log(event.target.value);
				console.log(event.target.name);
				if(!isNaN(event.target.value)) {
				for(var j=0;j<this.tableList.length;j++) {
				 if(this.tableList[j].Id == event.target.name) {
					 this.tableList[j].Discount = parseFloat(event.target.value); 
					 this.tableList[j].SP = this.tableList[j].Qty * this.tableList[j].UnitPrice*(1-this.tableList[j].Discount/100); 
					 break;
				 }
			 }
			 this.multiplication=0;
	  for(var i=0;i<this.tableList.length;i++){
		  console.log('i',i);
		  var fetchrec=parseFloat(this.tableList[i].Qty)*parseFloat(this.tableList[i].UnitPrice)*(1-parseFloat(this.tableList[i].Discount)/100);
		 this.multiplication=fetchrec+this.multiplication;
		  console.log(' this.multiplication', this.multiplication);
	
		}
			 console.log(this.tableList);
		 }
		 else {
			 alert('Please enter valid discount');
		 }
				
			}	
		}
		updateSP(event) {
			console.log(event);
			if(event.target.value!==null && event.target.value!='') {
				console.log(event.target.value);
				console.log(event.target.name);
				if(!isNaN(event.target.value)) {
				for(var j=0;j<this.tableList.length;j++) {
				 if(this.tableList[j].Id == event.target.name) {
					 this.tableList[j].SP = parseFloat(event.target.value); 
					 break;
				 }
			 }
			 this.multiplication=0;
	  for(var i=0;i<this.tableList.length;i++){
		  console.log('i',i);
		  var fetchrec=parseFloat(this.tableList[i].Qty)*parseFloat(this.tableList[i].UnitPrice)*(1-parseFloat(this.tableList[i].Discount)/100);
		 this.multiplication=fetchrec+this.multiplication;
		  console.log(' this.multiplication', this.multiplication);
	
		}
			 console.log(this.tableList);
		 }
		 else {
			 alert('Please enter valid discount');
		 }
				
			}	
		}
		get hasResults() {
			return (this.bears.data.length > 0);
		}
		 datatableList=[];
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
						CurrencyIsoCode: this.bears.data[i].CurrencyIsoCode,
						Qty:1,
						visitId : this.recordId,
						Discount : 0.00,
						SP : this.bears.data[i].UnitPrice,
						Productc:
							{
								Name: this.bears.data[i].Product2.Name,
								ProductCode: this.bears.data[i].Product2.ProductCode,
								CurrencyIsoCode:this.bears.data[i].Product2.CurrencyIsoCode,
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
							this.tableList[j].SP = this.tableList[j].Qty * this.tableList[j].UnitPrice*(1-this.tableList[j].Discount/100); 
							break;
						}
					}
				}
			}
		}
		this.multiplication=0;
	  for(var i=0;i<this.tableList.length;i++){
		  console.log('i',i);
		  var fetchrec=parseFloat(this.tableList[i].Qty)*parseFloat(this.tableList[i].UnitPrice);
		 this.multiplication=fetchrec+this.multiplication;
		  console.log(' this.multiplication', this.multiplication);
	
		}
		
		}
		
		removeRow(event){
			let remove_product=event.target.name;
			console.log('remove_product',remove_product);
					for(var i=0;i<this.tableList.length;i++) {
			if(this.tableList[i].Id == remove_product) {
				this.tableList.pop(this.tableList[i]);
			}	
				}
				console.log(this.tableList);
				this.multiplication=0;
				for(var i=0;i<this.tableList.length;i++){
					console.log('i',i);
					var fetchrec=parseFloat(this.tableList[i].Qty)*parseFloat(this.tableList[i].UnitPrice)*(1-parseFloat(this.tableList[i].Discount)/100);
				   this.multiplication=fetchrec+this.multiplication;
					console.log(' this.multiplication', this.multiplication);
			  
				  }
			
	}
	//////////////////////////////////
	/*creat order
	AccountId: '{!Visits__c.Account__c}',
                        Status: 'Draft',
                        Order_Status__c : 'New',
                        EffectiveDate: new Date(),
                        Pricebook2Id: $('select[id*="pricebook"]').val(),
                        Distributor__c : distributor
                    };
					saveSignature();

save signature by passing orderid parameter


 creat OrderItem
                            UnitPrice: unitPriceWithDiscount,
                            PricebookEntryId: orders[i].Id,
                            Quantity: orders[i].Quantity,
                            Promo_Applied__c : appliedPromoCodeName

					*/
	///////////////////////////////////////
		saveClick(event){
		
			window.console.log('In createRec ===> ');
			console.log(this.tableList);
			Creatorder({
				JsonStrings: JSON.stringify(this.tableList)
								})
							
		
				.then(result => {
					// Clear the user enter values
					//this.inventoryrecordId = {};
					window.console.log('result ===> ' + result.data);
					this.orderid=result;
					console.log('this.orderid',this.orderid);
					this.template.querySelector("c-signature-component").orderid=this.orderid;
					this.template.querySelector("c-signature-component").handleSaveClick();
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
		console.log('cleartable');
		this.tableList=[];
		this.multiplication=0;
		this.promocode=0
		console.log('clearsignature');
		this.template.querySelector("c-signature-component").handleClearClick();
			
	}
	
	@track value = 'GET 10% off on all products';

   
	@track  
	options = [
		{ label:'None',value:'None'},
            { label: 'GET 10% off on all products', value: 'GET 10% off on all products' },
            { label: 'Buy 4 Get 1 Free', value: 'Buy 4 Get 1 Free' }
        ];
		@track  value='None';
	 appliedPromoCodeName;
	 totalOrderPriceWithDiscount=0;
	handlePromocode(event){
		//appliedPromoCodeName=value;
		let val=event.target.value;
		
		if(val === 'GET 10% off on all products' ){
			console.log('val',val);
		this.promocode=this.multiplication*90 / 100;
		console.log('this.promocode',this.promocode);
		}
		else if(val ==='Buy 4 Get 1 Free'){
			
			this.promocode=this.multiplication;
			//this.promocode=this.multiplication*90 / 100;
		}
		
	/*	const selectedOption = event.detail.value;
	//	this.value = event.detail.value;
    if(selectedOption==='GET 10% off on all products'){
		totalOrderPriceWithDiscount = totalOrderPriceWithoutDiscount * 90 / 100;
		$('#totalPriceAfterDiscount').html('Total after discount : Rs.'+totalOrderPriceWithDiscount);
	}else if(selectedOption === 'Buy 4 GET 1 FREE'){
		totalOrderPriceWithDiscount = totalOrderPriceWithoutDiscount;
		$('#totalPriceAfterDiscount').html('Total after discount : Rs.'+totalOrderPriceWithDiscount);   
	}else{
		$('#totalPriceAfterDiscount').html('');

	}*/

		}


}