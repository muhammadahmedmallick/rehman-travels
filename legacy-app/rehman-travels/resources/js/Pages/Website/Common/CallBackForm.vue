<script setup>
import Modal from '@/Components/Modal.vue';
import Service from '@/Config/Service';
import LoadingBar from '../Ticketing/LoadingBar.vue';
</script>

<template>

    <div class="flypop-button callback-btn">
        <button @click="checkCallBack" style="background-color:red">
        <span style="color:#ffffff" class="font-semibold"><i class="fa-solid fa-phone rotate-90"></i> &nbsp;Request Call Back</span>
        </button>
    </div>

    <Modal :show="isCallBack" @close="closeModal" :modalWidth="modalWidth">
        <div class="bg-white shadow-lg sm:p-8 p-4 w-full max-w-2xl border-t-rose-600 border-t-8 border-2">
            <h1 class="text-3xl font-normal text-gray-700 mb-2 flex justify-between"><span>Request a Call Back</span> <button @click="closeModal" class="bg-red-600 rounded text-white items-center text-center ml-1 py-[1px] px-2 flex">&times;</button></h1>
            <p class="text-gray-600 mb-6 md:text-base text-sm">
                Kindly complete the form below, and one of our representatives will reach out to you promptly upon receiving your submissions.
            </p>
            <form @submit.prevent>
                <div class="mb-3 md:mb-6">
                    <div class="grid grid-cols-4 gap-4">
                        <div class="col-span-4 md:col-span-2">
                            <label for="firstName" class="block text-gray-700 mb-2 font-bold">
                                Name
                            </label>
                            <input type="text" v-on:keypress="isString" id="firstName" v-model="input.customers.firstName" class="w-full border rounded p-2"
                                />
                        </div>
                        <div class="col-span-4 md:col-span-2">
                            <label for="mobileNo" class="block text-gray-700 mb-2 font-bold">
                                Phone <span class="text-red-500 font-bold" v-if="errors.mobileNo == 'errors'">*</span>
                            </label>
                            <div class="flex">
                                <input type="text" v-on:keypress="isValidPhoneNumber" id="mobileNo" v-on:input="EmptyError('mobileNo', input.customers.mobileNo)" v-model="input.customers.mobileNo" placeholder="(201) 555-0123"
                                    class="flex-1 p-2 outline-none ring-0 border rounded focus:ring-0"
                                    :class="{'border-red-600' : errors.mobileNo == 'errors'}" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="grid grid-cols-4 gap-4 mb-3 md:mb-6">
                    <div class="col-span-4 md:col-span-2">
                        <label for="email" class="block text-gray-700 mb-2 font-bold">
                            Email
                        </label>
                        <div class="flex">
                            <input type="email" v-on:keypress="isValidEmail" id="email" v-model="input.customers.email" placeholder=""
                                class="flex-1 p-2 outline-none ring-0 border rounded focus:ring-0 focus:border-green-600 focus:border-2"
                                />
                        </div>
                    </div>
                    <div class="col-span-4 md:col-span-2">
                        <label for="address" class="block text-gray-700 mb-2 font-bold">
                            City/Country
                        </label>
                        <div class="flex">
                            <input type="text" v-on:keypress="isString" id="address" v-model="input.customers.address" placeholder=""
                                class="flex-1 p-2 outline-none ring-0 border rounded focus:ring-0 focus:border-green-600 focus:border-2"
                            />
                        </div>
                    </div>
                </div>
                <div class="mb-3 md:mb-6">
                    <label for="message" class="block text-gray-700 mb-2 font-bold">
                        Remarks <span class="text-red-500 font-bold" v-if="errors.message == 'errors'">*</span>
                    </label>
                    <textarea v-model="input.contents.message" id="message"
                    :class="{'border-red-600' : errors.message == 'errors'}"
                    v-on:input="EmptyError('message', input.customers.message)"
                    v-on:keypress="isString"
                    class="w-full border rounded p-2 sm:h-32 resize-y"
                    ></textarea>
                </div>
                <div class="flex justify-end space-x-4">
                    <button @click="closeModal"
                        class="bg-rose-500 print:hidden text-white py-2 px-6 rounded-md hover:bg-blue-600">
                        Close
                    </button>
                    <button @click="submitForm"
                        class="bg-green-500 text-white px-6 py-2 rounded hover:bg-green-600 transition-colors">
                        Submit
                    </button>
                </div>
            </form>
            <LoadingBar v-if="process" />
        </div>
    </Modal>
</template>

<script>
export default {
    data() {
        return {
            showScrollerBtn: false,
            isCallBack: false,
            process : false,
            modalWidth: "sm:w-[45%] md:w-[35%]",
            input: {
                customers: {
                    firstName: '',
                    mobileNo: '',
                    email: '',
                    address: '',
                },
                contents: {
                    message: '',
                    leadFrom: 'Call Back Form',
                    moduleId: 21,
                    created_by: 9
                }
            },
            errors:{
                mobileNo: '',
                message: ''
            }
        }
    },
    methods: {
        EmptyError(inputName, inputValue){
            if (inputName === 'message' && inputValue !== '') {
                this.errors.message = ''
                return true
            } else if (inputName === 'message' && inputValue === '') {
                this.errors.message = 'error'
                return false
            }
            if (inputName === 'mobileNo' && inputValue !== '') {
                this.errors.mobileNo = ''
                return true
            } else if (inputName === 'mobileNo' && inputValue === '') {
                this.errors.mobileNo = 'error'
                return false
            }

        },
        checkCallBack() {
            this.isCallBack = !this.isCallBack
        },
        handleScroll() {
            this.showScrollerBtn = window.scrollY > 800;
        },
        submitForm() {
            this.process = true
            if(this.input.customers.mobileNo === '') this.errors.mobileNo= 'errors'
            if(this.input.contents.message === '') this.errors.message= 'errors'

            if(this.errors.mobileNo == 'errors' || this.errors.message == 'errors'){
                this.process = false
                return false;
            }else{
                this.$inertia.post("/addContactDetails", this.input, {
                    onSuccess: (data) => {
                        window.location.href= '/Website/thankYou';
                        this.process = false
                    }
                })
            }
        },
        closeModal() {
            this.isCallBack = false;
        },
        isValidEmail(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if (/^[^\s@]+(\.[^\s@]+)*@[^\s@]+\.[^\s@]{2,3}$/.test(selectedCharCode)) return true;
        },
        isString(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if (/^[A-Za-z ]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isValidPhoneNumber(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if (/^[0-9]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
    }
}
</script>

<style scoped>
input:focus,
textarea:focus,
select:focus {
    outline: none;
    border-color: #9CA3AF;
}

select {
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    padding-right: 1.5rem;
    background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='none' stroke='%236B7280' viewBox='0 0 12 12'%3E%3Cpath d='M3 5l3 3 3-3'/%3E%3C/svg%3E") no-repeat right 0.5rem center;
}
.callback-btn {
    animation: blinking 2s ease-in-out infinite
}
@keyframes blinking {
    0% {
        box-shadow: 0 0 0 0 rgba(255, 0, 0, 0.589);
        border-radius: 14px;
    }
    70% {
        box-shadow: 0 0 0 15px rgba(37, 211, 102, 0);
        border-radius: 14px;
    }
    100% {
        box-shadow: 0 0 0 0 rgba(0, 0, 0, 0);
        border-radius: 14px;
    }
}
.flypop-button{
    z-index: 10;
    position: fixed;
    right: 0px;
    top: 50%;
    transform: translateY(-50%);
    display: block;
    direction: ltr !important;
    margin-top: -20px;
}

.flypop-button button {
    text-decoration: none;
    text-transform: capitalize;
    font-size: 16px;
    position: relative;
    border: none;
    outline: 0;
    padding: 12px 12px 12px 13px;
    cursor: pointer;
    background-color: rgb(0, 0, 0);
    transition: .1s ease-in-out;
    width: 46px;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    border-radius: 14px 0px 0px 14px;
    letter-spacing: .2px;
    font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif !important;
    transform: translateX(2px);
    -webkit-transform: translateX(2px);
    min-height: 65px;
    height: auto !important;
    text-align: center;
    justify-content: center;
    line-height: initial;
}

.flypop-button button span {
    font-weight: 600;
    color: #fff;
    writing-mode: vertical-lr;
    -webkit-writing-mode: vertical-lr;
    transform: rotate(180deg);
}

@media (max-width: 720px) {
    .flypop-button button{
        padding: 10px 10px 10px 9px !important;
        min-height: 50px !important;
        width: 36px !important;
        font-size: 13px !important;
        letter-spacing: .3px !important;

    }
    .flypop-button button span {
        font-weight: 400;
    }
}
</style>