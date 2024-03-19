import { LightningElement, track } from 'lwc';
import executeCode from "@salesforce/apex/ExecuteCodeCtrl.executeCode";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ExecuteCodeLWC extends LightningElement {
    @track scriptCode;
    @track data;
    showSpinner = false;
    handleFieldChange(event) {
        this.scriptCode = event.detail.value;
    }
    handleValidation(message, isError) {
        let scriptCode = this.template.querySelector(".scriptCode");

        if (isError) {
            scriptCode.setCustomValidity(message);
        } else {
            scriptCode.setCustomValidity("");
        }
        scriptCode.reportValidity();
    }
    handleExecute() {
        this.showSpinner = true;
        if (this.scriptCode.length > 0) {
            executeCode({ script: this.scriptCode })
                .then(res => {
                    console.log(res);
                    this.showToast('Success', res, 'success', 'dismissable');
                    this.handleValidation('', false);
                }).catch(err => {
                    console.log(err);
                    this.showToast('Error', err.body.message, 'error', 'dismissable');
                    this.handleValidation(err.body.message, true);
                }).finally(() => {
                    this.showSpinner = false;
                })
        } else {
            this.showToast('Error', 'Please write something in the code editor', 'error', 'dismissable')
        }
    }
    get isDisableExecuteButton() {
        return !this.scriptCode || this.scriptCode === undefined;
    }
    showToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
}