import { LightningElement, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import getAccessToken from '@salesforce/apex/SalesforceOAuth.getAccessToken';
import newAccount from '@salesforce/apex/SalesforceOAuth.newAccount';

export default class SalesforceOauth extends NavigationMixin(LightningElement) {
    code;
    accName;
    authDisabled = false;
    getAccessToken = false;
    tokenDisbled = false
    accessToken;
    accId;
    authUrl = 'https://resilient-shark-8carn7-dev-ed.trailblaze.my.salesforce.com/services/oauth2/authorize?client_id={clientId}&redirect_uri=https://helioswebservice2-dev-ed.develop.my.site.com/salesforceoauth/s/&response_type=code';
    @wire(CurrentPageReference)
    getStateParameter(CurrentPageRef) {
        if (CurrentPageRef) {
            if (CurrentPageRef.state) {
                this.code = CurrentPageRef.state.code;
                if (this.code) {
                    this.authDisabled = true
                    this.getAccessToken = true;
                }
            }
        }
    }
    navigateToWebPage() {
        this[NavigationMixin.Navigate](
            {
                type: "standard__webPage",
                attributes: {
                    url: this.authUrl,
                },
            },
            true,
        );
    }
    async Token() {
        let response = await getAccessToken({ code: this.code });
        let obj = JSON.parse(response);
        this.accessToken = obj.access_token;
        this.tokenDisbled = true;
    }
    accountHandler(evt) {
        this.accName = evt.target.value
    }
    async createAccount() {
        let response = await newAccount({ access: this.accessToken, name: this.accName })
        let obj = JSON.parse(response);
        this.accId = obj.id;
    }
}