<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue"
</script>

<template>
    <GuestLayout>
        <section>
            <div class="banner md:h-[275px] h-[170px]" :style="'background-image:url(' + banner + ')'">
                <h2
                    class="text-white text-[22px] sm:text-[2rem] md:text-[2.5rem] font-bold drop-shadow-[2px_2px_2px_gray] capitalize text-center md:py-28 py-16 sm:px-24 ">
                    Our Bank Accounts Information</h2>
            </div>
        </section>
        <section class="w-[95%] sm:w-[85%] mx-auto bg-white rounded">
            <div class="grid grid-cols-12 mb-3" v-if="$page.props.getNum['country_code2'] == 'PK'">
                <div v-if="$page.props.bankDetails" v-for="(bankDetail, bankDetailKey) in $page.props.bankDetails"
                    :key="bankDetailKey"
                    class="col-span-12 lg:col-span-6 mb-5 mt-5 mx-4 m-0 rounded-lg border-[0.012rem] border-dashed border-[#cbcccc] cursor-pointer shadow-[0_0_10px_rgb(119_119_119/21%)]">
                    <div class="col-span-12">
                        <div class="grid grid-cols-12">
                            <div
                                class="col-span-12 xs:col-span-4 h-full inline-flex items-center justify-center border-r-[0.012rem] border-dashed border-[#cbcccc]">
                                <img :src="'/assets/bankAccounts/' + bankDetail.bankLogoName" class="pt-4 sm:pt-0" />
                            </div>
                            <div class="col-span-12 xs:col-span-8 mt-2 px-6">
                                <span class="font-semibold text-base">{{ bankDetail.bankName }}</span>
                                <p class=" text-sm text-justify mb-2 mt-2">TITLE : {{ bankDetail.accountTitle }}</p>
                                <p class=" text-sm text-justify mb-2 ">BR-CODE : {{ bankDetail.branchCode }}</p>
                                <p class=" text-sm text-justify mb-2">AC# : {{ bankDetail.accountNo }}</p>
                                <p class=" text-sm text-justify mb-2">IBAN# : {{ bankDetail.ibanNo }}</p>
                                <p class=" text-sm text-justify mb-2">SWIFT CODE : {{ bankDetail.swiftCode }}</p>
                                <p class=" text-sm text-justify mb-2">CONTACT NO : {{ bankDetail.contactNo }}</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-span-12 text-black text-base text-center m-[1rem_0rem] font-semibold">
                    <h3>Rehman Travels PVT Limited NTN # 2691940-7</h3>
                    <h5>For Any Inquiry Regarding Account Details, Call Us on +92 51 111 786 785 (Ext 7108-9)</h5>
                </div>
            </div>
            <div v-else class="mb-5 mt-5 p-4 mx-4 text-center rounded-lg border-[0.012rem] border-dashed border-[#cbcccc] cursor-pointer shadow-[0_0_10px_rgb(119_119_119/21%)]">
                <p>For Bank Details, Please reach us at <a class="underline text-blue-600 font-bold" href="mailto:info@rehmantravel.com">info@rehmantravel.com</a></p>
            </div>
            <!-- Contact Form -->
            <div class="md:pt-3  py-0 md:py-0 hidden md:block">
                <div class="bg-white rounded-lg xs:text-justify">
                    <div class="my-3 w-full">
                        <h3
                            class="text-xl uppercase bg-bgRGTBaseColor text-white p-[0rem_0.7rem] mb-3 font-medium leading-[2.875rem] md:text-start text-center">
                            request a callback</h3>
                    </div>
                    <form class="w-full p-3" @submit.prevent="submit">
                        <div class="grid grid-cols-12 gap-2">
                            <div class="col-span-12 md:col-span-4">
                                <input
                                    class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    type="text" v-model="form.customers.firstName" v-on:keypress="isString" @paste.prevent placeholder="Your Name">
                            </div>
                            <div class="col-span-12 md:col-span-4">
                                <input
                                    class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    type="tel" v-model="form.customers.mobileNo" v-on:keypress="isNumber" @paste.prevent placeholder="Phone No">
                            </div>
                            <div class="col-span-12 md:col-span-4">
                                <input
                                    class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    type="email" v-model="form.customers.email" v-on:keypress="isEmail" @paste.prevent placeholder="Email">
                            </div>
                        </div>
                        <div class="grid grid-cols-12 gap-3">
                            <div class="col-span-12 md:col-span-8">
                                <textarea rows="40" cols="40" v-model="form.contents.message" v-on:keypress="isString" @paste.prevent
                                    class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"> Message</textarea>
                            </div>
                            <div class="col-span-12 md:col-span-2 md:mb-0 mb-4">
                                <input type="submit" @click="submitDetails()"
                                    class=" w-full p-2 text-xl bg-blue-100 text-blue-800 border border-solid border-blue-500 text-center transition-all duration-700 ease-in-out rounded hover:bg-bgRGTBaseColor hover:text-white hover:transition-all hover:ease-in-out hover:duration-700">
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </section>
    </GuestLayout>
</template>
<script>
export default {
    data(){
        return{
            banner : "",
            form: {
                customers: {
                    firstName : "",
                    mobileNo : "",
                    email : "",
                },
                contents: {
                    message : "",
                    moduleId : 9,
                    leadFrom : "Bank Details"
                }
            },
        }
    },
    mounted() {
        this.banner = '/assets/Visa/dubai-banner.webp';
    },
    methods: {
        isString(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z @.]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isNumber(e){
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[0-9+]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isEmail(e){
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z 0-9@.]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        submitDetails() {
            if(this.form.customers.mobileNo == ""){
                this.$toast.error("Please Enter  mobile No.");
                return false;
            }else{
                this.$inertia.post('/addContactDetails', this.form,{
                    onSuccess: (response) => {
                        window.location.href = '/Website/thankYou';
                    }
                });
            }
        }
    }

}
</script>
