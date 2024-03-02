import { LightningElement } from 'lwc';
import createCustomChannel from '@salesforce/apex/CustomChangeDataChannel.createCustomChannel';
import createChannelMembers from '@salesforce/apex/CustomChangeDataChannel.createChannelMembers';
import createEnrichField from '@salesforce/apex/CustomChangeDataChannel.createEnrichField';
import callRestQuery from '@salesforce/apex/LambdaApex.callRestQuery';
import createFilterChannel from '@salesforce/apex/CustomChangeDataChannel.createFilterChannel';
export default class ChangeDataCapture extends LightningElement {
    async callQuery() {
        let data = await callRestQuery();
        console.log(data)
    }
    async createFilter() {
        let data = await createFilterChannel();
        console.log(data)
    }
    async createChannel() {
        let data = await createCustomChannel();
        console.log(data)
    }
    async createChannelMember() {
        let data = await createChannelMembers();
        console.log(data)
    }
    async createEnrichFields() {
        let data = await createEnrichField();
        console.log(data)
    }
}