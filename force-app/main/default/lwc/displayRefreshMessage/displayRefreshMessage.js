import { LightningElement, api } from 'lwc';
import {
    subscribe,
    unsubscribe,
    onError,
} from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';

export default class DisplayRefreshMessage extends LightningElement {
    showWarning = false;
    @api recordId;
    @api channelName = '/data/AccountChangeEvent';
    subscription = {};
    connectedCallback() {
        this.handleSubscribe()
        this.registerErrorListener();
    }
    handleSubscribe() {
        const messageCallback = (response) => {
            this.performBusinessLogic(response);
        };
        subscribe(this.channelName, -1, messageCallback).then((response) => {
            console.log(
                'Subscription request sent to: ',
                JSON.stringify(response.channel)
            );
            this.subscription = response;
        });

    }
    showToast() {
        const event = new ShowToastEvent({
            title: 'Updated',
            message: 'Data updated successfully.',
            variant: 'success'
        });
        this.dispatchEvent(event);
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
    async refreshPage() {
        await notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
        this.showWarning = false;
        this.showToast()
    }
    performBusinessLogic(response) {
        if (response.data) {
            let data = response.data;
            if (data.payload) {
                let payload = data.payload;
                let isRecord = payload.ChangeEventHeader.recordIds.find(rec => rec === this.recordId);
                if (isRecord) {
                    this.showWarning = true;
                }
            }
        }
    }
}