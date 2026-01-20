<script setup xmlns="http://www.w3.org/1999/html">
import SuccessButton from '@/Components/SuccessButton.vue';
import SecondaryButton from '@/Components/SecondaryButton.vue';
import Modal from '@/Components/Modal.vue';
import LoadingBar from "../loader/LoadingBar.vue";
</script>
<template>
    <Modal :show="modalPopup" @close="closedModal">
        <div class="flex flex-1 h-12 text-black items-center justify-end">
            <h2 class="w-full text-base font-semibold pl-4">Create New User</h2>
            <i class="fa fa-close bg-red-500 rounded-lg p-2 text-white cursor-pointer mr-4" @click="closedModal()"></i>
        </div>
        <div class="relative w-[95%] mx-auto bg-white">
            <!-- <div class="w-full bg-gradient-to-r from-sky-800 via-sky-600 to-sky-700 mt-2">
                <div>
                </div>
            </div> -->
            <LoadingBar v-if="loading"/>
            <div class="px-4 py-2 mx-auto mt-8">
                <div class="grid grid-cols-12 gap-1">
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">User Type </label>
                        <select
                            :class="(errors['userType'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.userType" required="true"
                            v-on:change="isEmpty('userType',input.userType)">
                            <option value="">User Type</option>
                            <option value="agent">Agent</option>
                            <option value="sub_agent">Sub-Agent</option>
                            <option value="corporate">Corporate</option>
                            <option value="third_party">Third Party</option>
                        </select>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Portal Type </label>
                        <select
                            :class="(errors['portalType'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.portalType" required="true"
                            v-on:change="isEmpty('portalType',input.portalType)">
                            <option value="">Portal Type</option>
                            <option value="Non-Ticketing">Non-Ticketing</option>
                            <option value="Ticketing">Ticketing</option>
                        </select>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Payment Type </label>
                        <select
                            :class="(errors['paymentType'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.paymentType" required="true"
                            v-on:change="isEmpty('paymentType',input.paymentType)">
                            <option value="">Payment Type</option>
                            <option value="credit">Credit</option>
                            <option value="cash">Cash</option>
                            <option value="both">Both</option>
                            <option value="none">None</option>
                        </select>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Account Status </label>
                        <select
                            :class="(errors['accountStatus'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.accountStatus" required="true"
                            v-on:change="isEmpty('accountStatus',input.accountStatus)">
                            <option value="">Account Status</option>
                            <option value="pending">Pending</option>
                            <option value="active">Active</option>
                            <option value="de-active">De-Active</option>
                        </select>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Account ID </label>
                        <input
                            class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                            v-model="input.accountId" type="text" placeholder="Account ID"
                            v-on:keypress="isValidCredit"/>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">User Name </label>
                        <input
                            :class="(errors['userName'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.userName" type="text" placeholder="User Name" required="true"
                            v-on:input="isEmpty('userName',input.userName)"
                            v-on:keypress="isValidInputField"/>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Email</label>
                        <input
                            :class="(errors['email'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.email" type="text" placeholder="Email" required="true"
                            v-on:input="isEmpty('email',input.email)"
                            v-on:change="isEmpty('email',input.email)"
                            v-on:keypress="isValidEmail"/>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Password </label>
                        <input
                            :class="(errors['password'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.password" type="password" placeholder="Password" required="true"
                            v-on:input="isEmpty('password',input.password)"
                            v-on:change="isEmpty('password',input.password)"/>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Branch </label>
                        <select
                            :class="(errors['branchId'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.branchId" required="true"
                            v-on:change="isEmpty('branchId',input.branchId)">
                            <option value="">Branch</option>
                            <option value="1">Islamabad</option>
                            <option value="2">Karachi</option>
                            <option value="3">Peshawar</option>
                            <option value="4">Lahore</option>
                            <option value="5">Mardan</option>
                            <option value="6">Rawalpindi</option>
                            <option value="7">Attock</option>
                            <option value="8">Swabi</option>
                        </select>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Mobile No </label>
                        <input
                            :class="(errors['mobileNo'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.mobileNo" type="text" placeholder="Mobile No" required="true"
                            v-on:input="isEmpty('mobileNo',input.mobileNo)"
                            v-on:change="isEmpty('mobileNo',input.mobileNo)"
                            v-on:keypress="isValidPhoneNumber"/>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Phone No </label>
                        <input
                            :class="(errors['phoneNo'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.phoneNo" type="text" placeholder="Phone No" required="true"
                            v-on:input="isEmpty('phoneNo',input.phoneNo)"
                            v-on:change="isEmpty('phoneNo',input.phoneNo)"
                            v-on:keypress="isValidPhoneNumber"/>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Credit Limit </label>
                        <input
                            :class="(errors['creditLimit'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.creditLimit" type="text" placeholder="Credit Limit" required="true"
                            v-on:input="isEmpty('creditLimit',input.creditLimit)"
                            v-on:keypress="isValidCredit"/>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Tmp Credit Limit </label>
                        <input
                            :class="(errors['tmpCreditLimit'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.tmpCreditLimit" type="text" placeholder="Tmp Credit Limit"
                            required="true"
                            v-on:input="isEmpty('tmpCreditLimit',input.tmpCreditLimit)"
                            v-on:keypress="isValidCredit"/>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-3">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Current Credit Limit</label>
                        <input
                            :class="(errors['currentCreditLimit'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.currentCreditLimit" type="text" placeholder="Current Credit Limit"
                            required="true"
                            v-on:input="isEmpty('currentCreditLimit',input.currentCreditLimit)"
                            v-on:keypress="isValidCredit"/>
                    </div>
                    <div class="col-span-12 xxs:col-span-6 md:col-span-4 2xl:col-span-6">
                        <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Address </label>
                        <textarea
                            :class="(errors['address'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900':'')+ 'appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500'"
                            v-model="input.address" placeholder="Address" required="true"
                            v-on:input="isEmpty('address',input.address)">
                        </textarea>
                    </div>
                </div>
            </div>
            <div  class="mt-6 flex justify-end mb-3">
                <SuccessButton v-if="(actionType === 'add' && permissions['Add'] === 1) || (actionType === 'edit' && permissions['Update'] === 1)" class="mr-3" v-on:click="save()">
                    <span v-if="actionType === 'add' &&  permissions['Add'] === 1">Create</span>
                    <span v-if="actionType === 'edit' && permissions['Update'] === 1">Update</span>
                </SuccessButton>
                <button class="bg-red-600 text-white px-5 py-1 rounded-md hover:bg-red-700" v-on:click="closedModal()"> Cancel</button>
            </div>
        </div>
    </Modal>
</template>
<script>
import Service from "@/Config/Service.js";
export default {
    emits: ["closedModal","refresh"],
    props: {
        modalPopup: false,
        permissions:"",
        actionType:"",
        user: "",
    },
    data() {
        return {
            loading: false,
            input: this.setInputs(),
            errors: this.setErrors(),
        };
    },
    beforeUpdate() {
        if (this.user.id !== undefined) {
            this.input = this.user
            this.errors = this.setErrors("")
        } else {
            this.input = this.setInputs();
            this.errors = this.setErrors("error")
        }
    },
    methods: {
        setInputs() {
            return {
                "id": "",
                "agentId": "",
                "parentId": "",
                "userType": "",
                "portalType": "",
                "paymentType": "",
                "accountStatus": "",
                "accountId": 0,
                "userName": "",
                "email": "",
                "password": "",
                "branchId": "",
                "mobileNo": "",
                "phoneNo": "",
                "creditLimit": "",
                "tmpCreditLimit": "",
                "currentCreditLimit": "",
                "address": ""
            };
        },
        setErrors(errorType) {
            return {
                userType: errorType,
                markupType: errorType,
                portalType: errorType,
                paymentType: errorType,
                accountStatus: errorType,
                userName: errorType,
                email: errorType,
                password: errorType,
                branchId: errorType,
                mobileNo: errorType,
                phoneNo: errorType,
                creditLimit: errorType,
                tmpCreditLimit: errorType,
                currentCreditLimit: errorType,
                address: errorType

            }
        },
        isValidInputField(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if (/^[A-Za-z ]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isValidEmail(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(selectedCharCode)) return true;
        },
        isValidPhoneNumber(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if (/^[0-9+]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isValidCredit(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if (/^[0-9.]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isEmpty(fieldName, inputFieldName) {
            if (fieldName === 'userType' && inputFieldName !== '')
                this.errors.userType = ''
            else if (fieldName === 'userType' && inputFieldName === '')
                this.errors.userType = 'error'
            if (fieldName === 'portalType' && inputFieldName !== '')
                this.errors.portalType = ''
            else if (fieldName === 'portalType' && inputFieldName === '')
                this.errors.portalType = 'error'
            if (fieldName === 'paymentType' && inputFieldName !== '')
                this.errors.paymentType = ''
            else if (fieldName === 'paymentType' && inputFieldName === '')
                this.errors.paymentType = 'error'
            if (fieldName === 'accountStatus' && inputFieldName !== '')
                this.errors.accountStatus = ''
            else if (fieldName === 'accountStatus' && inputFieldName === '')
                this.errors.accountStatus = 'error'
            if (fieldName === 'userName' && inputFieldName !== '')
                this.errors.userName = ''
            else if (fieldName === 'userName' && inputFieldName === '')
                this.errors.userName = 'error'
            if (fieldName === 'email' && inputFieldName !== '')
                this.errors.email = ''
            else if (fieldName === 'email' && inputFieldName === '')
                this.errors.email = 'error'
            if (fieldName === 'password' && inputFieldName !== '')
                this.errors.password = ''
            else if (fieldName === 'password' && inputFieldName === '')
                this.errors.password = 'error'
            if (fieldName === 'branchId' && inputFieldName !== '')
                this.errors.branchId = ''
            else if (fieldName === 'branchId' && inputFieldName === '')
                this.errors.branchId = 'error'
            if (fieldName === 'mobileNo' && inputFieldName !== '')
                this.errors.mobileNo = ''
            else if (fieldName === 'mobileNo' && inputFieldName === '')
                this.errors.mobileNo = 'error'
            if (fieldName === 'phoneNo' && inputFieldName !== '')
                this.errors.phoneNo = ''
            else if (fieldName === 'phoneNo' && inputFieldName === '')
                this.errors.phoneNo = 'error'
            if (fieldName === 'creditLimit' && inputFieldName !== '')
                this.errors.creditLimit = ''
            else if (fieldName === 'creditLimit' && inputFieldName === '')
                this.errors.creditLimit = 'error'
            if (fieldName === 'tmpCreditLimit' && inputFieldName !== '')
                this.errors.tmpCreditLimit = ''
            else if (fieldName === 'tmpCreditLimit' && inputFieldName === '')
                this.errors.tmpCreditLimit = 'error'
            if (fieldName === 'currentCreditLimit' && inputFieldName !== '')
                this.errors.currentCreditLimit = ''
            else if (fieldName === 'currentCreditLimit' && inputFieldName === '')
                this.errors.currentCreditLimit = 'error'
            if (fieldName === 'address' && inputFieldName !== '')
                this.errors.address = ''
            else if (fieldName === 'address' && inputFieldName === '')
                this.errors.address = 'error'
        },
        save() {
            if (this.errors.userType === 'error') {
                this.$toast.error("Please select User Type.");
                return false;
            } else if (this.errors.portalType === 'error') {
                this.$toast.error("Please select Portal Type.");
                return false;
            } else if (this.errors.paymentType === 'error') {
                this.$toast.error("Please select Payment Type.");
                return false;
            } else if (this.errors.accountStatus === 'error') {
                this.$toast.error("Please select Account Status.");
                return false;
            }  else if (this.errors.userName === 'error') {
                this.$toast.error("Please make sure User Name field is filled in correctly.");
                return false;
            } else if (this.errors.email === 'error') {
                this.$toast.error("Please make sure Email field is filled in correctly.");
                return false;
            } else if (this.errors.password === 'error') {
                this.$toast.error("Please make sure Password field is filled in correctly.");
                return false;
            } else if (this.errors.branchId === 'error') {
                this.$toast.error("Please select Branch.");
                return false;
            }else if (this.errors.mobileNo === 'error') {
                this.$toast.error("Please make sure Mobile No field is filled in correctly.");
                return false;
            } else if (this.errors.phoneNo === 'error') {
                this.$toast.error("Please make sure Phone No field is filled in correctly.");
                return false;
            } else if (this.errors.creditLimit === 'error') {
                this.$toast.error("Please select Credit Limit.");
                return false;
            } else if (this.errors.tmpCreditLimit === 'error') {
                this.$toast.error("Please select Temp Credit Limit.");
                return false;
            } else if (this.errors.currentCreditLimit === 'error') {
                this.$toast.error("Please select Current Credit Limit.");
                return false;
            } else if (this.errors.address === 'error') {
                this.$toast.error("Please make sure Address field is filled in correctly.");
                return false;
            } else {
                this.start();
                const airURLSearchParam = this.airURLSearchParams();
                this.input.agentId = airURLSearchParam.get("aid")
                this.input.parentId = airURLSearchParam.get("paid")
             Service.doRequest("/b2b/user/"+(this.input.id !== undefined ? 'update-user-request': 'create-new-user-request')  , (this.input.id !== undefined ? "PUT": "POST"), this.input)
                    .then((response) => {
                        console.log('response', response);
                        if (response.errorType === "true") {
                            this.$toast.error(response.error);
                        } else if (response.errorType === "false") {
                            this.$emit("refresh","true")
                            this.$toast.success(response.error);
                        }
                        this.finish(false);
                    });
            }
        },
        start() {
            this.loading = true;
        },
        finish(option) {
            this.loading = option;
        },
        closedModal: function () {
            this.$emit("closedModal", false)
        },
        airURLSearchParams: function () {
            return new URLSearchParams(window.location.search);
        },
    },
};
</script>

