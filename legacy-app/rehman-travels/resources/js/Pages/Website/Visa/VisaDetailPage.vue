<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
import VisaSideBar from "./VisaSideBar.vue";
import ExtraPhoneEmailDetails from "@/Layout/Website/ExtraPhoneEmailDetails.vue";
</script>

<template>
    <GuestLayout>
        <section class="bg-gray-200" v-for="(visaDetail, visaDetailIndex) in $page.props.visaPackages" :key="visaDetailIndex">
            <div class="banner md:h-[275px] h-[170px]" :style="'background-image:url('+banner+')'">
                <h1 class="text-white text-[22px] sm:text-[2rem] md:text-[2.5rem] font-bold drop-shadow-[2px_2px_2px_gray] capitalize text-center md:py-28 py-16 sm:px-24 ">
                    {{ visaDetail['visaDetails'].packageTitle }}
                </h1>
            </div>
            <div class="w-[90%] mx-auto mt-4">
                <div class="grid grid-cols-12">
                    <div class="col-span-12 lg:col-span-9 mb-4 relative flex flex-col">
                        <div  v-if="showFormBelow" class="md:pt-3 gap-y-10 border border-gray-500 bg-white rounded-xl py-0 md:py-0 mb-4 block lg:hidden">
                            <div class="rounded-lg shadow-lg p-3 xs:text-justify">
                                <div class="flex justify-between gap-x-5">
                                    <h3
                                        class="text-2xl capitalize lg:px-4 rounded-t-lg bg-bgRGTBaseColor text-white w-full mb-3 font-medium leading-[2.875rem] md:text-start text-center">
                                        Contact Us
                                    </h3>
                                    <a href="tel:+9251111786785"
                                        class="text-2xl capitalize lg:px-4 rounded-t-lg bg-red-600 text-white w-full mb-3 font-medium leading-[2.875rem] md:text-start text-center">
                                        <i class="fas fa-phone mr-1"></i>Call Us
                                    </a>
                                </div>
                                <form class="w-full" @submit.prevent="submit">
                                    <div class="grid grid-cols-12 gap-2">
                                        <div class="col-span-12 md:col-span-4">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="text" v-model="form.customers.firstName" v-on:keypress="isString" @paste.prevent placeholder="Your Name">
                                        </div>
                                        <div class="col-span-12 md:col-span-4">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="number" v-model="form.customers.mobileNo" v-on:keypress="isNumber" @paste.prevent placeholder="Phone No">
                                        </div>
                                        <div class="col-span-12 md:col-span-4">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="email" v-model="form.customers.email" v-on:keypress="isEmail" @paste.prevent placeholder="Email">
                                        </div>
                                    </div>
                                    <div class="grid grid-cols-12 gap-3">
                                        <div class="col-span-12 md:col-span-8">
                                            <textarea rows="40" cols="40" placeholder="Your Message"
                                                v-model="form.contents.message" v-on:keypress="isString" @paste.prevent
                                                class="appearance-none block w-full h-20 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"> Message</textarea>
                                        </div>
                                        <div class="col-span-12 md:col-span-2 md:mb-0 mb-4">
                                            <input type="submit" @click="submitDetails()"
                                                class=" w-full p-2 text-xl bg-bgRGTBaseColor font-medium text-white border border-solid border-blue-500 text-center transition-all duration-700 ease-in-out rounded hover:transition-all hover:ease-in-out hover:duration-700">
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="break-words bg-white bg-clip-border border-[1px] border-solid border-[rgba(0,0,0,.125)] rounded-[0.25rem]">
                            <div class="px-4">
                                <div class="col-span-12 my-4 text-justify mb-5"
                                    v-html="visaDetail['visaDetails'].shortDescription">
                                </div>
                                <div class="grid grid-cols-12 mt-4" v-if="visaDetail['visaDuration'] != ''">
                                    <div v-for="(visaDuration, visaDurationIndex) in visaDetail['visaDuration']"
                                        :key="visaDurationIndex"
                                        class="col-span-12 sm:col-span-6 md:col-span-4 lg:col-span-6 xl:col-span-4 mx-2 mb-4">
                                        <div
                                            class="bg-white text-center pb-4 rounded-lg overflow-hidden shadow-[0_1px_3px_0px_rgba(0,0,0,0.3)]">
                                            <div class="">
                                                <span
                                                    class="text-white bg-blue-500 text-xl font-medium capitalize w-full p-[6px_6px_6px] rounded-none inline-block">
                                                    {{ visaDuration.duration }}</span>
                                            </div>
                                            <div class="capitalize">
                                                <h3 class="text-amber-950 text-2xl font-medium m-0 text-center pt-3 pb-3">
                                                    {{ visaDuration.visaTitle }}</h3>
                                            </div>
                                            <div class="visaIncludes" v-html="visaDuration.visaIncludes"></div>
                                            <div class="text-black p-[0px_15px]">
                                                <span class="font-semibold leading-10 text-3xl">{{ currency.currencyCode }}
                                                    {{ setConverter(visaDuration.visaPrice, visaDuration.currency, currency) }}
                                                </span>
                                                <span class="font-light capitalize pl-1">/Per Person</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- End Price Table -->
                                <div ref="visaDescriptionRef" class="col-span-12 mt-4 text-justify mb-5 visaDescription ck-Detail"
                                    v-html="visaDetail['visaDetails'].description">
                                </div>
                                <ExtraPhoneEmailDetails v-if="$page.props.getNum.whatsapp !== '' || $page.props.getNum.landline !== ''" />
                            </div>
                        </div>
                        <div class="md:pt-3 gap-y-10 border border-gray-500 bg-white rounded-xl py-0 md:py-0 mt-4">
                            <div class="rounded-lg shadow-lg p-3 xs:text-justify">
                                <div class="flex justify-between gap-x-5">
                                    <h3
                                        class="text-2xl capitalize lg:px-4 rounded-t-lg bg-bgRGTBaseColor text-white w-full mb-3 font-medium leading-[2.875rem] md:text-start text-center">
                                        Contact Us
                                    </h3>
                                    <a href="tel:+9251111786785"
                                        class="text-2xl capitalize lg:px-4 rounded-t-lg bg-red-600 text-white w-full mb-3 font-medium leading-[2.875rem] md:text-start text-center">
                                        <i class="fas fa-phone mr-1"></i>Call Us
                                    </a>
                                </div>
                                <form class="w-full" @submit.prevent="submit">
                                    <div class="grid grid-cols-12 gap-2">
                                        <div class="col-span-12 md:col-span-4">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="text" v-model="form.customers.firstName" v-on:keypress="isString" @paste.prevent placeholder="Your Name">
                                        </div>
                                        <div class="col-span-12 md:col-span-4">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="number" v-model="form.customers.mobileNo" v-on:keypress="isNumber" @paste.prevent placeholder="Phone No">
                                        </div>
                                        <div class="col-span-12 md:col-span-4">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="email" v-model="form.customers.email" v-on:keypress="isEmail" @paste.prevent placeholder="Email">
                                        </div>
                                    </div>
                                    <div class="grid grid-cols-12 gap-3">
                                        <div class="col-span-12 md:col-span-8">
                                            <textarea rows="40" cols="40" placeholder="Your Message"
                                                v-model="form.contents.message" v-on:keypress="isString" @paste.prevent
                                                class="appearance-none block w-full h-20 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"> Message</textarea>
                                        </div>
                                        <div class="col-span-12 md:col-span-2 md:mb-0 mb-4">
                                            <input type="submit" @click="submitDetails()"
                                                class=" w-full p-2 text-xl bg-bgRGTBaseColor font-medium text-white border border-solid border-blue-500 text-center transition-all duration-700 ease-in-out rounded hover:transition-all hover:ease-in-out hover:duration-700">
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Right Side -->
                    <div :class="`sm:col-span-12 lg:col-span-3 sm:mx-3 col-span-12 lg:w-[85%]`">
                        <div v-if="showFormBelow" class="rounded-lg hidden lg:block bg-white shadow-lg p-3 xs:text-justify">
                                <h3
                                    class="text-lg capitalize lg:px-4 rounded-t-lg bg-bgRGTBaseColor text-white w-full mb-3 font-medium leading-[2.875rem] md:text-start text-center">
                                    Request a CallBack
                                </h3>
                                <form class="w-full" @submit.prevent="submit">
                                    <div class="grid grid-cols-12 gap-2">
                                        <div class="col-span-12">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="text" v-model="form.customers.firstName" v-on:keypress="isString" @paste.prevent placeholder="Your Name">
                                        </div>
                                        <div class="col-span-12">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="number" v-model="form.customers.mobileNo" v-on:keypress="isNumber" @paste.prevent placeholder="Phone No">
                                        </div>
                                        <div class="col-span-12">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="email" v-model="form.customers.email" v-on:keypress="isEmail" @paste.prevent placeholder="Email">
                                        </div>
                                    </div>
                                    <div class="grid grid-cols-12 gap-3">
                                        <div class="col-span-12">
                                            <textarea rows="40" cols="40" placeholder="Your Message"
                                                v-model="form.contents.message"  v-on:keypress="isString" @paste.prevent
                                                class="appearance-none block w-full h-20 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"> Message</textarea>
                                        </div>
                                        <div class="col-span-12 md:mb-0 mb-4">
                                            <input type="submit" @click="submitDetails()"
                                                class=" w-full p-2 text-xl bg-bgRGTBaseColor font-medium text-white border border-solid border-blue-500 text-center transition-all duration-700 ease-in-out rounded hover:transition-all hover:ease-in-out hover:duration-700">
                                        </div>
                                    </div>
                                </form>
                            </div>
                        <div class="col-span-12 sm:mx-4">
                            <div class="my-3 border-2 border-dashed border-gray-400 p-3 bg-gray-200 rounded text-center justify-center">
                                <h3 class=" text-blue-800 mb-2">For additional information, kindly get in touch via:</h3>
                                <i class=" fa fa-phone text-blue-600"></i> <a href="tel:923345164637"
                                    class="text-blue-800">(+92)3345164637</a>
                            </div>
                        </div>
                        <div class="col-span-12 sm:mx-4">
                            <VisaSideBar />
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </GuestLayout>
</template>
<script>
import CurrencyConverter from "@/Config/CurrencyConverter.js";
import {mapState} from "vuex";
export default {
    name: 'visaPackages',
    computed: {...mapState(['currency'])},
    components: {
        VisaSideBar,
    },
    data(){
        return{
            banner:"",
            toggleValue : 'first',
            showFormBelow: false,
            form: {
                customers: {
                    firstName : "",
                    mobileNo : "",
                    email : "",
                },
                contents: {
                    message : "",
                    moduleId : 4,
                    leadFrom : ""
                }
            },
        }
    },
    mounted(){
        this.banner = '/assets/banner/dubai-banner.webp';
        this.$nextTick(() => {
            this.checkContentHeight()
            window.addEventListener('resize', this.checkContentHeight)
        })
    },
    beforeUnmount() {
        window.removeEventListener('resize', this.checkContentHeight)
    },
    methods: {
        isString(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z ]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isEmail(e){
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z 0-9@.]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isNumber(e){
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[0-9+]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        checkContentHeight() {
            let el = this.$refs.visaDescriptionRef
            if (Array.isArray(el)) {
                el = el[0]
            }
            if (!el || typeof el.scrollHeight === 'undefined') {
                this.showFormBelow = false
                return
            }
            const contentHeight = el.scrollHeight || 0
            const screenHeight = window.innerHeight || 0
            this.showFormBelow = contentHeight > screenHeight
        },
        submitDetails(){
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
        },
        changeTabs(value){
            this.toggleValue = value;
        },
        setConverter(amount, currencyCode, currency) {
            const packageCurrencyInfo = this.$page.props.currencies.filter(e => e.currencyCode === currencyCode)[0];
            if (currencyCode === currency.currencyCode) {
                return amount;
            } else if (currencyCode === "PKR" && currency.currencyCode === "PKR") {
                return amount;
            }else if (currencyCode !== "PKR" && currency.currencyCode === "PKR") {
                return Math.floor(eval(amount) * packageCurrencyInfo.currencyRate);
            }else{
                return Math.floor(CurrencyConverter.doRequest((eval(amount) * packageCurrencyInfo.currencyRate), currency.currencyRate));
            }
        },
    }
}
</script>