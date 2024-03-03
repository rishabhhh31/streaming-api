import { LightningElement, api, wire } from 'lwc';
import { getObjectInfo, getPicklistValues } from "lightning/uiObjectInfoApi";
import STATUS_FIELD from "@salesforce/schema/Case.Status";
import CASE_OBJECT from "@salesforce/schema/Case";
import { getRecord, getFieldValue, updateRecord } from "lightning/uiRecordApi";
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import {
    subscribe,
    unsubscribe,
    onError,
} from 'lightning/empApi';
import ID_FIELD from "@salesforce/schema/Case.Id";

export default class PlatfromEventSubscribe extends LightningElement {
    @api recordId;
    channelName = '/event/Case_Detail__e';
    subscription = {};
    steps = [];
    currentStatus;
    @wire(getRecord, {
        recordId: "$recordId",
        fields: [STATUS_FIELD],
    })
    caseStatusCurrent({ data, error }) {
        if (data) {
            this.currentStatus = getFieldValue(data, STATUS_FIELD);
        } else {
            console.log(error);
        }
    }

    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    caseObject;

    @wire(getPicklistValues, { recordTypeId: '$caseObject.data.defaultRecordTypeId', fieldApiName: STATUS_FIELD })
    caseStatusPicklist({ data, error }) {
        if (data) {
            this.steps = data.values;
        } else {
            console.log(error);
        }
    }
    connectedCallback() {
        this.handleSubscribe()
        this.registerErrorListener();
    }
    handleSubscribe() {
        const messageCallback = (response) => {
            this.refreshCaseDetails(response)
        };

        subscribe(this.channelName, -1, messageCallback).then((response) => {
            this.subscription = response;
        });
    }
    disconnectedCallback() {
        unsubscribe(this.subscription, (response) => {
            console.log('unsubscribe() response: ', JSON.stringify(response));
        });
    }
    registerErrorListener() {
        onError((error) => {
            console.log('Received error from server: ', JSON.stringify(error));
        });
    }
    async refreshCaseDetails(response) {
        if (response.data) {
            if (response.data.payload) {
                let payload = response.data.payload;
                if (this.recordId === payload.Case_id__c) {
                    let fields = {};
                    fields[STATUS_FIELD.fieldApiName] = payload.Case_Status__c;
                    fields[ID_FIELD.fieldApiName] = this.recordId;
                    let recordInput = { fields };
                    await updateRecord(recordInput)
                    await notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Success",
                            message: "Case updated",
                            variant: "success",
                        }),
                    );
                }
            }
        }
    }
}