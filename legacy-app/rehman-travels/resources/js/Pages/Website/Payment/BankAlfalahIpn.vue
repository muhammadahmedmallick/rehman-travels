<script setup>
import LoadingBar from "../loader/LoadingBar.vue";
</script>
<template>
    <LoadingBar v-if="loading"/>
    <form class="grid grid-cols-12 px-4" @submit.prevent="cheapestFareFlightOrderPay">
        <div class="col-span-12">
            <fieldset class="grid grid-cols-12 gap-x-1 border p-2 rounded-md shadow-[0px_3px_9px_0px_#f3f3f3]">
                <legend class="text-lg font-medium mb-4">Bank Alfalah</legend>
                <div v-if="responseError !== undefined && responseError !== ''" class="col-span-12 sm:col-span-12 lg:col-span-12 xl:col-span-12 mb-6">
                    <strong class="text-red-600 font-normal">{{responseError}}</strong>
                </div>
                <div class="col-span-12 sm:col-span-12 lg:col-span-12 xl:col-span-12 mb-6">
                    <div class="relative z-0">
                        <input type="text" id="cardNumber"
                               :class="`${(errors['cardNumber'] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} block px-2.5 py-[6px] w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                               v-model="input.cardNumber" placeholder="" autoComplete="off"
                               v-on:input="isEmpty('cardNumber',input.cardNumber)"
                               v-on:change="isEmpty('cardNumber',input.cardNumber)"
                               v-on:keypress="isValidNumber"
                        />
                        <label :for="'cardNumber'"
                               class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                            Card Number</label>
                    </div>
                </div>
                <div class="col-span-6 sm:col-span-4 lg:col-span-4 xl:col-span-4 mb-6">
                    <div class="relative z-0">
                        <input type="text" id="cvv"
                               :class="`${(errors['cvv'] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} block px-2.5 py-[6px] w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                               v-model="input.cvv" placeholder="" autoComplete="off"
                               v-on:input="isEmpty('cvv',input.cvv)"
                               v-on:change="isEmpty('cvv',input.cvv)"
                               v-on:keypress="isValidNumber"
                        />
                        <label :for="'cvv'"
                               class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                            CVV</label>
                    </div>
                </div>
                <div class="col-span-6 sm:col-span-4 lg:col-span-4 xl:col-span-4 mb-6">
                    <div class="relative z-0">
                        <input type="text" id="expiryMonth"
                               :class="`${(errors['expMonth'] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} block px-2.5 py-[6px] w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                               v-model="input.expMonth" placeholder="" autoComplete="off"
                               v-on:input="isEmpty('expMonth',input.expMonth)"
                               v-on:change="isEmpty('expMonth',input.expMonth)"
                               v-on:keypress="isValidNumber"
                        />
                        <label :for="'expiryMonth'"
                               class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                            MM</label>
                    </div>
                </div>
                <div class="col-span-6 sm:col-span-4 lg:col-span-4 xl:col-span-4 mb-6">
                    <div class="relative z-0">
                        <input type="text" id="expiryYear"
                               :class="`${(errors['expYear'] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} block px-2.5 py-[6px] w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                               v-model="input.expYear" placeholder="" autoComplete="off"
                               v-on:input="isEmpty('expYear',input.expYear)"
                               v-on:change="isEmpty('expYear',input.expYear)"
                               v-on:keypress="isValidNumber"
                        />
                        <label :for="'expiryYear'"
                               class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                            YYYY</label>
                    </div>
                </div>
                <div class="col-span-12 sm:col-span-12 lg:col-span-12 xl:col-span-12 mb-6">
                    <div class="relative z-0">
                        <input type="text" id="userName"
                               :class="`${(errors['userName'] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} block px-2.5 py-[6px] w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                               v-model="input.userName" placeholder="" autoComplete="off"
                               v-on:input="isEmpty('userName',input.userName)"
                               v-on:change="isEmpty('userName',input.userName)"
                        />
                        <label :for="'userName'"
                               class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                            Enter Name</label>
                    </div>
                </div>
                <div class="col-span-12 sm:col-span-12 lg:col-span-12 xl:col-span-12 mb-6">
                    <div class="relative z-0">
                        <input type="email" id="email"
                               :class="`${(errors['email'] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} block px-2.5 py-[6px] w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                               v-model="input.email" placeholder="" autoComplete="off"
                               v-on:input="isEmpty('email',input.email)"
                               v-on:change="isEmpty('email',input.email)"
                               v-on:keypress="isValidEmail"
                        />
                        <label :for="'email'"
                               class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                            Enter Email</label>
                    </div>
                </div>
                <div class="col-span-12 sm:col-span-12 lg:col-span-12 xl:col-span-12 mb-6">
                    <div class="relative z-0">
                        <input type="text" id="mobile"
                               :class="`${(errors['mobileNo'] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} block px-2.5 py-[6px] w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                               v-model="input.mobileNo" placeholder="" autoComplete="off"
                               v-on:input="isEmpty('mobileNo',input.mobileNo)"
                               v-on:change="isEmpty('mobileNo',input.mobileNo)"
                               v-on:keypress="isValidPhoneNumber"
                        />
                        <label :for="'mobile'"
                               class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                            Enter Mobile</label>
                    </div>
                </div>
            </fieldset>
        </div>
        <div class="col-span-12 mb-4 lg:mb-0 flex lg:justify-end justify-center mt-2">
            <button type="submit"
                    class=" border border-solid cursor-pointer relative inline-flex items-center justify-start py-3 pl-4 pr-12 overflow-hidden font-semibold text-white transition-all duration-500 ease-in-out rounded hover:pl-10 hover:pr-6 bg-bgRGTBaseColor group">
                                <span
                                    class="absolute bottom-0 left-0 w-full transition-all bg-green-600 duration-500 ease-in-out group-hover:h-full"></span>
                <span class="absolute right-0 pr-4 duration-500 ease-out group-hover:translate-x-12"><i
                    class="fa-solid fa-arrow-right text-white"></i></span>
                <span
                    class="absolute left-0 pl-2.5 -translate-x-12 group-hover:translate-x-0 ease-out duration-500">
                                    <i class="fa-solid fa-arrow-right text-white"></i></span>
                <span class="relative w-full text-left transition-colors duration-500 ease-in-out group-hover:text-white"> Continue Process Payment </span>
            </button>
        </div>
    </form>
</template>

<script>
import Service from "@/Config/Service.js";
import $ from 'jquery';
import {mapState} from "vuex";
export default {
    name: "BankAlfalah",
    components: {},
    emits: ["initiateHC"],
    props:{
        payInput:{},
        payTotalFare:0,
        currencyCode:'',
        processHCData:"",
    },
    computed: {
        ...mapState(['throwError']),
    },
    data() {
        return {
            loading: false,
            input:this.setInputs(),
            errors: this.setErrors(""),
            htmlContent: '',
            responseError:"",
            countries:[{"value":"","title":"Select Country"},{"value":"10","title":"Argentina"},{"value":"100","title":"Iceland"},{"value":"101","title":"India"},{"value":"102","title":"Indonesia"},{"value":"103","title":"Iran"},{"value":"104","title":"Iraq"},{"value":"105","title":"Ireland"},{"value":"106","title":"Israel"},{"value":"107","title":"Italy"},{"value":"108","title":"Jamaica"},{"value":"109","title":"Japan"},{"value":"11","title":"Armenia"},{"value":"110","title":"Jordan"},{"value":"111","title":"Kazakstan or Kazakhstan"},{"value":"112","title":"Kenya"},{"value":"113","title":"Kiribati"},{"value":"114","title":"Korea"},{"value":"115","title":"South Korea"},{"value":"116","title":"Kuwait"},{"value":"117","title":"Kyrgyzstan"},{"value":"118","title":"Lao People's Democratic Republic (Laos)"},{"value":"119","title":"Latvia"},{"value":"12","title":"Aruba"},{"value":"120","title":"Lebanon"},{"value":"121","title":"Lesotho"},{"value":"122","title":"Liberia"},{"value":"123","title":"Libya"},{"value":"124","title":"Liechtenstein"},{"value":"125","title":"Lithuania"},{"value":"126","title":"Luxembourg"},{"value":"127","title":"Macau"},{"value":"128","title":"Macedonia"},{"value":"129","title":"Madagascar"},{"value":"13","title":"Australia"},{"value":"130","title":"Malawi"},{"value":"131","title":"Malaysia"},{"value":"132","title":"Maldives"},{"value":"133","title":"Mali"},{"value":"134","title":"Malta"},{"value":"135","title":"Marshall Islands"},{"value":"136","title":"Martinique (French)"},{"value":"137","title":"Mauritania"},{"value":"138","title":"Mauritius"},{"value":"139","title":"Mayotte"},{"value":"14","title":"Austria"},{"value":"140","title":"Mexico"},{"value":"141","title":"Micronesia"},{"value":"142","title":"Moldova"},{"value":"143","title":"Monaco"},{"value":"144","title":"Mongolia"},{"value":"145","title":"Montserrat"},{"value":"146","title":"Morocco"},{"value":"147","title":"Mozambique"},{"value":"148","title":"Myanmar"},{"value":"149","title":"Namibia"},{"value":"15","title":"Azerbaijan or Azerbaidjan"},{"value":"150","title":"Nauru"},{"value":"151","title":"Nepal"},{"value":"152","title":"Netherlands"},{"value":"153","title":"Netherlands Antilles"},{"value":"154","title":"New Caledonia"},{"value":"155","title":"New Zealand (Aotearoa)"},{"value":"156","title":"Nicaragua"},{"value":"157","title":"Niger"},{"value":"158","title":"Nigeria"},{"value":"159","title":"Niue"},{"value":"16","title":"Bahamas"},{"value":"160","title":"Norfolk Island"},{"value":"161","title":"Northern Mariana Islands"},{"value":"162","title":"Norway"},{"value":"163","title":"Oman"},{"value":"164","title":"Pakistan"},{"value":"165","title":"Palau"},{"value":"166","title":"Palestinian State (Proposed)"},{"value":"167","title":"Panama"},{"value":"168","title":"Papua New Guinea"},{"value":"169","title":"Paraguay"},{"value":"17","title":"Bahrain"},{"value":"170","title":"Peru"},{"value":"171","title":"Philippines"},{"value":"172","title":"Pitcairn Island"},{"value":"173","title":"Poland"},{"value":"174","title":"Portugal"},{"value":"175","title":"Puerto Rico"},{"value":"176","title":"Qatar, State of"},{"value":"177","title":"Reunion (French)"},{"value":"178","title":"Romania"},{"value":"179","title":"Russia"},{"value":"18","title":"Bangladesh"},{"value":"180","title":"Russian Federation"},{"value":"181","title":"Rwanda (Rwandese Republic)"},{"value":"182","title":"Saint Helena"},{"value":"183","title":"Saint Kitts and Nevis"},{"value":"184","title":"Saint Lucia"},{"value":"185","title":"Saint Pierre and Miquelon"},{"value":"186","title":"Saint Vincent and the Grenadines"},{"value":"187","title":"Samoa"},{"value":"188","title":"San Marino"},{"value":"189","title":"Sao Tome and Principe"},{"value":"19","title":"Barbados"},{"value":"190","title":"Saudi Arabia"},{"value":"191","title":"Serbia"},{"value":"192","title":"Senegal"},{"value":"193","title":"Seychelles"},{"value":"194","title":"Sierra Leone"},{"value":"195","title":"Singapore"},{"value":"196","title":"Slovakia"},{"value":"197","title":"Slovenia"},{"value":"198","title":"Solomon Islands"},{"value":"199","title":"Somalia"},{"value":"2","title":"Albania"},{"value":"20","title":"Belarus"},{"value":"200","title":"South Africa"},{"value":"201","title":"South Georgia"},{"value":"202","title":"Spain"},{"value":"203","title":"Sri Lanka"},{"value":"204","title":"Sudan"},{"value":"205","title":"Suriname"},{"value":"206","title":"Svalbard"},{"value":"207","title":"Swaziland"},{"value":"208","title":"Sweden"},{"value":"209","title":"Switzerland"},{"value":"21","title":"Belgium"},{"value":"210","title":"Syria"},{"value":"211","title":"Taiwan"},{"value":"212","title":"Tajikistan"},{"value":"213","title":"Tanzania"},{"value":"214","title":"Thailand"},{"value":"215","title":"Togo"},{"value":"216","title":"Tokelau"},{"value":"217","title":"Tonga"},{"value":"218","title":"Trinidad and Tobago"},{"value":"22","title":"Belize"},{"value":"220","title":"Tunisia"},{"value":"221","title":"Turkey"},{"value":"222","title":"Turkmenistan"},{"value":"223","title":"Turks and Caicos Islands"},{"value":"224","title":"Tuvalu"},{"value":"225","title":"Uganda"},{"value":"226","title":"Ukraine"},{"value":"227","title":"United Arab Emirates"},{"value":"228","title":"United Kingdom (Great Britain / UK)"},{"value":"229","title":"United States"},{"value":"23","title":"Benin"},{"value":"230","title":"United States Minor Outlying Islands"},{"value":"231","title":"Uruguay"},{"value":"232","title":"Uzbekistan"},{"value":"233","title":"Vanuatu"},{"value":"234","title":"Vatican City State"},{"value":"235","title":"Venezuela"},{"value":"236","title":"Vietnam"},{"value":"237","title":"Virgin Islands, British"},{"value":"238","title":"Virgin Islands, United States"},{"value":"239","title":"Wallis and Futuna Islands"},{"value":"24","title":"Bermuda"},{"value":"240","title":"Western Sahara"},{"value":"241","title":"Yemen"},{"value":"242","title":"Yugoslavia"},{"value":"243","title":"Zambia"},{"value":"244","title":"Zimbabwe"},{"value":"25","title":"Bhutan"},{"value":"26","title":"Bolivia"},{"value":"27","title":"Bosnia and Herzegovina"},{"value":"28","title":"Botswana"},{"value":"29","title":"Bouvet Island"},{"value":"3","title":"Algeria"},{"value":"30","title":"Brazil"},{"value":"31","title":"British Indian Ocean Territory (BIOT)"},{"value":"32","title":"Brunei (Negara Brunei Darussalam)"},{"value":"33","title":"Bulgaria"},{"value":"34","title":"Burkina Faso"},{"value":"35","title":"Burundi"},{"value":"36","title":"Cambodia"},{"value":"37","title":"Cameroon"},{"value":"38","title":"Canada"},{"value":"39","title":"Cape Verde"},{"value":"4","title":"American Samoa"},{"value":"40","title":"Cayman Islands"},{"value":"41","title":"Central African Republic"},{"value":"42","title":"Chad"},{"value":"43","title":"Chile"},{"value":"44","title":"China"},{"value":"45","title":"Christmas Island"},{"value":"46","title":"Cocos (Keeling) Islands"},{"value":"47","title":"Colombia"},{"value":"48","title":"Comoros, Union of the"},{"value":"49","title":"Congo"},{"value":"5","title":"Andorra, Principality of"},{"value":"50","title":"Cook Islands"},{"value":"51","title":"Costa Rica"},{"value":"52","title":"Cote D'Ivoire"},{"value":"53","title":"Croatia (Hrvatska)"},{"value":"54","title":"Cuba"},{"value":"55","title":"Cyprus"},{"value":"56","title":"Czech Republic"},{"value":"57","title":"Czechoslavakia"},{"value":"58","title":"Denmark"},{"value":"59","title":"Djibouti"},{"value":"6","title":"Angola"},{"value":"60","title":"Dominica"},{"value":"61","title":"Dominican Republic"},{"value":"62","title":"East Timor"},{"value":"63","title":"Ecuador"},{"value":"64","title":"Egypt"},{"value":"65","title":"El Salvador"},{"value":"66","title":"Equatorial Guinea"},{"value":"67","title":"Eritrea"},{"value":"68","title":"Estonia"},{"value":"69","title":"Ethiopia"},{"value":"7","title":"Anguilla"},{"value":"70","title":"Falkland Islands (Islas Malvinas)"},{"value":"71","title":"Faroe Islands"},{"value":"72","title":"Fiji"},{"value":"73","title":"Finland"},{"value":"74","title":"France"},{"value":"75","title":"French Guiana or French Guyana"},{"value":"76","title":"French Polynesia"},{"value":"77","title":"French Southern Territories"},{"value":"78","title":"Gabon"},{"value":"79","title":"Gambia"},{"value":"8","title":"Antarctica"},{"value":"80","title":"Georgia"},{"value":"81","title":"Germany"},{"value":"82","title":"Ghana"},{"value":"83","title":"Gibraltar"},{"value":"84","title":"Great Britain (United Kingdom)"},{"value":"85","title":"Greece"},{"value":"86","title":"Greenland"},{"value":"87","title":"Grenada"},{"value":"88","title":"Guadeloupe"},{"value":"89","title":"Guam"},{"value":"9","title":"Antigua and Barbuda"},{"value":"90","title":"Guatemala"},{"value":"91","title":"Guinea"},{"value":"92","title":"Guinea-Bissau"},{"value":"93","title":"Guyana"},{"value":"94","title":"Haiti"},{"value":"96","title":"Holy See (Vatican City State)"},{"value":"97","title":"Honduras"},{"value":"98","title":"Hong Kong"},{"value":"99","title":"Hungary"}],
        };
    },
    watch:{
        processHCData(response){
            this.processHC(response)
        }
    },
    methods: {
        setInputs() {
            return {"refNumber":"","transactionType":3,"cardNumber":"","cvv":"","expMonth":"","expYear":"","userName":"","mobileNo": "","email":"",
                "currencyCode":this.currencyCode,"countryCode":164,"airType":this.payInput.airType,"itineraryRef":this.payInput.itineraryRef,"payAmount":this.payTotalFare};
            },
        setErrors(errorType) {
            const  error = (errorType === undefined ? 'error': errorType);
            return {"cardNumber":error,"cvv":error,"expMonth":error,"expYear":error,"userName":error,"mobileNo": error,"email":error}
        },
        isValidEmail(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(selectedCharCode)) return true;
        },
        isValidPhoneNumber(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[0-9+]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isValidNumber(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[0-9]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isValidCheapestFareFlightOrderCreateInputField(e){
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z ]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isEmpty(fieldName, inputFieldName) {
            if (fieldName === 'cardNumber' && inputFieldName === ''){
                this.errors.cardNumber = 'error'
                return false;
            }else if (fieldName === 'cardNumber' && inputFieldName !== ''){
                this.errors.cardNumber = ''
                return true;
            }
            if (fieldName === 'cvv' && inputFieldName === ''){
                this.errors.cvv = 'error'
                return false;
            }else if (fieldName === 'cvv' && inputFieldName !== ''){
                this.errors.cvv = ''
                return true;
            }
            if (fieldName === 'expMonth' && inputFieldName === ''){
                this.errors.expMonth = 'error'
                return false;
            }else if (fieldName === 'expMonth' && inputFieldName !== ''){
                this.errors.expMonth = ''
                return true;
            }
            if (fieldName === 'expYear' && inputFieldName === ''){
                this.errors.expYear = 'error'
                return false;
            }else if (fieldName === 'expYear' && inputFieldName !== ''){
                this.errors.expYear = ''
                return true;
            }
            if (fieldName === 'userName' && inputFieldName === ''){
                this.errors.userName = 'error'
                return false;
            }else if (fieldName === 'userName' && inputFieldName !== ''){
                this.errors.userName = ''
                return true;
            }
            if (fieldName === 'email' && inputFieldName === ''){
                this.errors.email = 'error'
                return false;
            }else if (fieldName === 'email' && inputFieldName !== ''){
                if (!/^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(inputFieldName)) {
                    this.errors.email = 'error'
                    return false
                } else {
                    this.errors.email = ''
                    return true
                }
            }
            if (fieldName === 'mobileNo' && inputFieldName === ''){
                this.errors.mobileNo = 'error'
                return false;
            }else if (fieldName === 'mobileNo' && inputFieldName !== ''){
                this.errors.mobileNo = ''
                return true;
            }
        },
        cheapestFareFlightOrderPay(){
            if(this.input.cardNumber === '') this.errors.cardNumber ='error'
            if(this.input.cvv === '') this.errors.cvv ='error'
            if(this.input.expMonth === '') this.errors.expMonth ='error'
            if(this.input.expYear === '') this.errors.expYear ='error'
            if(this.input.userName === '') this.errors.userName ='error'
            if(this.input.email === '') this.errors.email ='error'
            if(this.input.mobileNo === '') this.errors.mobileNo ='error'
            if (this.errors.cardNumber.includes('error') || this.errors.cvv.includes('error') || this.errors.expMonth.includes('error') ||
                this.errors.expYear.includes('error') || this.errors.userName.includes('error') ||  this.errors.email.includes('error')  ||
                this.errors.mobileNo.includes('error')) {
                return false;
            } else {
                this.start();
                Service.doFetchRequest("/payonline/cheapest-fare-order-alfalah-pay-online-initiatehc-request", "Create", this.input)
                    .then((response) => {
                        if(response.errorType === "false" && response.payUrl !== "" && response.pageUrl === "alfalah"){
                            this.input.refNumber = response.refNumber
                            this.$emit("initiateHC",response.payUrl)
                        }else if(response.errorType === "true" && response.payUrl !== "" && response.pageUrl === "htmlUrl"){
                            window.location.reload();
                            this.$store.dispatch("throwError", response.responseError)
                            this.$toast.error(response.responseError);
                            this.redirectToUrl = false;
                        }
                    });
            }
        },
        processHC(response){
            window.removeEventListener('message', this.processHC);
            this.input.response = response
            Service.doFetchRequest("/payonline/cheapest-fare-order-alfalah-pay-online-processhc-request", "Create", this.input)
                .then((response) => {
                    if(response.pageUrl === "payUrl"){
                        this.responseError = response.responseError;
                    }else{
                        this.responseError = response.responseError;
                        window.location.href = `${response.queryUrl}&ert=${response.errorType}&msg=${response.responseError}`;
                    }
                    this.finish(false);
                });
        },
        start() {this.loading = true },
        finish(option) {this.loading = option},
    }
}
</script>
