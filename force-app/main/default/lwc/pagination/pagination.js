import { LightningElement, wire } from 'lwc';
import getRecordCount from '@salesforce/apex/EfficientPaginationController.getRecordCount';
import fetchRecords from '@salesforce/apex/EfficientPaginationController.fetchRecords';
const COLUMN = [
    { label: 'Account Name', fieldName: 'Name' },
    { label: 'Rating', fieldName: 'Rating' },
    { label: 'Industry', fieldName: 'Industry' },
    { label: 'Annual Revenue', fieldName: 'AnnualRevenue' },
]
export default class Pagination extends LightningElement {
    totalRecordCount = 0;
    recordPerPage = 5;
    totalPage = 0;
    pageNumber = 1;
    columns = COLUMN;
    isLoading = false;
    firstName;
    lastName;
    buttonTypePrevious;
    buttonTypeNext;
    searchKey;
    copiedData = [];
    accountList = [];
    connectedCallback() {
        this.getRecords();
    }
    @wire(getRecordCount)
    totalRecords({ data, error }) {
        if (data) {
            this.totalRecordCount = data;
            this.totalPage = Math.ceil(this.totalRecordCount / this.recordPerPage);
        } else {
            console.log(error);
        }
    }
    previousHandler() {
        if (this.pageNumber > 1) {
            this.pageNumber--;
            this.buttonTypePrevious = true;
            this.buttonTypeNext = false;
            this.getRecords();
        }
    }
    nextHandler() {
        if (this.pageNumber < this.totalPage) {
            this.pageNumber++;
            this.buttonTypeNext = true;
            this.buttonTypePrevious = false;
            this.getRecords();
        }
    }
    get disablePrevious() {
        return this.pageNumber === 1;
    }
    get disableNext() {
        return this.totalPage === this.pageNumber;
    }
    getRecords() {
        this.isLoading = true;
        fetchRecords({
            previousType: this.buttonTypePrevious,
            nextType: this.buttonTypeNext,
            firstName: this.firstName,
            lastName: this.lastName,
            recordCount: this.recordPerPage
        }).then(res => {
            this.accountList = res;
            if (this.buttonTypePrevious === true) {
                this.accountList.sort(function (a, b) {
                    let aName = a.Name.toLowerCase();
                    let bName = b.Name.toLowerCase();
                    if (aName < bName) {
                        return -1;
                    }
                    else if (aName > bName) {
                        return 1;
                    }
                    return 0;
                });
            }
            this.copiedData = [...this.accountList];
            this.firstName = this.accountList[0].Name;
            this.lastName = this.accountList[this.accountList.length - 1].Name;
            this.isLoading = false;
        })
    }
    handelSearchKey(event) {
        this.accountList = [...this.copiedData];
        this.isLoading = true;
        this.searchKey = event.target.value;
        let filtered = this.accountList.filter(acc => {
            return acc.Name.includes(this.searchKey);
        })
        this.accountList = [...filtered];
        this.isLoading = false;
    }
    showAllRecords() {
        this.getRecords();
    }
}