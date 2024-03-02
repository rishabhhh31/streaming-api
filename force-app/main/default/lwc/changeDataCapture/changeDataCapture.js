import { LightningElement } from 'lwc';
import callRestQuery from '@salesforce/apex/LambdaApex.callRestQuery';
export default class ChangeDataCapture extends LightningElement {
    async callQuery() {
        let data = await callRestQuery();
        console.log(JSON.parse(data))
    }
}