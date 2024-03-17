import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createAccountRecords from '@salesforce/apex/AccountDataCreateByCSV.createAccountRecords';
const COLUMN = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Phone', fieldName: 'Phone' },
    { label: 'Account Number', fieldName: 'AccountNumber' }
];
export default class CsvFileUploader extends LightningElement {
    columns = COLUMN;
    files = [];
    fileItems = [];
    fileName;
    showDatatable = false;
    data = [];
    showSpinner = false;
    MAX_FILE_SIZE = 1500000;
    isTrue = true;
    showPills = false;
    fileContents;
    handleChange(evt) {
        this.files = evt.detail.files;
        this.fileName = this.files['0'].name;
        for (let key of Object.keys(this.files)) {
            this.fileItems.push({ label: this.files[key].name, name: this.files[key].name })
        }
        this.showPills = this.fileItems.length > 0 ? true : false;
        this.isTrue = !this.showPills;
    }
    handleItemRemove(event) {
        const index = event.detail.index;
        console.log('index', index);
        this.fileItems.splice(index, 1);
        let updatedFiles = [];
        for (let key of Object.keys(this.files)) {
            let num = Number(key);
            if (num !== index) {
                console.log('inside', this.files[index]);
                updatedFiles.push(this.files[index]);
            }
        }
        console.log(JSON.stringify(updatedFiles));
        // this.files.splice(index, 1);
        this.isTrue = !(this.fileItems.length > 0);
        console.log('this.files', this.files);
    }
    get acceptedFormats() {
        return ['.csv'];
    }
    uploadFiles() {
        if (this.files.length > 0) {
            this.uploadHelper();
        } else {
            this.showToast('Upload !!', 'Please select a CSV file to upload!!', 'error', 'pester')
        }
    }
    uploadHelper() {
        this.file = this.files[0];
        if (this.file.size > this.MAX_FILE_SIZE) {
            this.showToast('Large File !!', 'File Size is to long', 'error', 'pester')
            return;
        }
        this.isTrue = true;
        this.showSpinner = true;
        let fileReader = new FileReader();
        fileReader.onloadend = (() => {
            this.fileContents = fileReader.result;
            this.saveToFile();
        });
        fileReader.readAsText(this.file);
    }
    saveToFile() {
        createAccountRecords({ base64Data: JSON.stringify(this.fileContents) })
            .then(result => {
                this.data = result;
                this.fileName = this.fileName + ' - Uploaded Successfully';
                this.isTrue = false;
                this.showDatatable = true;
                this.showSpinner = false;
                this.showToast('Success', this.fileName, 'success', 'dismissable');
            })
            .catch(error => {
                console.log(error);
                this.showToast('Error while uploading File', error.body.message, 'error', 'dismissable');
            });
    }
    get showTable() {
        return this.showDatatable;
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