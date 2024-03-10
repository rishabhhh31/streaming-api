import { LightningElement, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import getAccessToken from '@salesforce/apex/SalesforceOAuth.getAccessToken';
import newAccount from '@salesforce/apex/SalesforceOAuth.newAccount';

export default class SalesforceOauth extends NavigationMixin(LightningElement) {
    code;
    accName;
    domain;
    authDisabled = false;
    getAccessToken = false;
    tokenDisbled = false
    accessToken;
    accId;
    @wire(CurrentPageReference)
    getStateParameter(CurrentPageRef) {
        if (CurrentPageRef) {
            if (CurrentPageRef.state) {
                console.log(CurrentPageRef.state.state)
                this.domain = CurrentPageRef.state.state;
                this.code = CurrentPageRef.state.code;
                if (this.code) {
                    console.log(this.code);
                    this.authDisabled = true
                    this.getAccessToken = true;
                }
            }
        }
    }
    authorizeHandler() {
        let authUrl = `${this.domain}/services/oauth2/authorize?client_id={clientId}&redirect_uri=https://helioswebservice2-dev-ed.develop.my.site.com/salesforceoauth/s/&response_type=code&state=${this.domain}`;
        window.open(authUrl, '_blank')
        // this[NavigationMixin.Navigate](
        //     {
        //         type: "standard__webPage",
        //         attributes: {
        //             url: this.authUrl,
        //         },
        //     },
        //     true,
        // );
    }
    async Token() {
        let response = await getAccessToken({ code: this.code, domain: this.domain });
        let obj = JSON.parse(response);
        console.log(JSON.stringify(obj));
        this.accessToken = obj.access_token;
        this.tokenDisbled = true;
    }
    accountHandler(evt) {
        this.accName = evt.target.value
    }
    async createAccount() {
        let response = await newAccount({ access: this.accessToken, name: this.accName, domain: this.domain })
        let obj = JSON.parse(response);
        this.accId = obj.id;
    }
    domainHandler(evt) {
        this.domain = evt.target.value;
        console.log(this.domain);
    }
}