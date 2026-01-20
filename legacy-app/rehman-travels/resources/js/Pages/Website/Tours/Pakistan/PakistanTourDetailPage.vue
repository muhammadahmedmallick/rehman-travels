<script setup>
    import GuestLayout from "@/Layouts/GuestLayout.vue";
    import ExtraPhoneEmailDetails from "@/Layout/Website/ExtraPhoneEmailDetails.vue";
</script>

<template>
    <GuestLayout>
        <section class="bg-gray-200">
            <div class="banner md:h-[275px] h-[170px]" :style="'background-image:url('+banner+')'">
                <h1 class="text-white text-[22px] sm:text-[2rem] md:text-[2.5rem] font-bold drop-shadow-[2px_2px_2px_gray] capitalize text-center md:py-28 py-16 sm:px-24 ">
                    {{ $page.props.pakistanTour.packageTitle }}</h1>
            </div>
            <div class="w-[90%] mx-auto" id="printDiv">
                <div class="grid grid-cols-12 mt-4">
                    <v-pdf ref="domesticToPdf" :options="pdfOptions" :filename="$page.props.pakistanTour.packageTitle" class="col-span-12 lg:col-span-8">
                        <div class=" col-span-12 lg:col-span-8 print:col-span-12 mb-4 relative flex flex-col break-words bg-white bg-clip-border border-[1px] border-solid border-[rgba(0,0,0,.125)] rounded-[0.25rem]">
                            <div class="px-4">
                                <div class="col-span-12 my-3 flex justify-between">
                                    <div class="hidden print:block w-full">
                                        <p class="text-center text-white sm:text-xl sm:pl-3 font-semibold sm:text-left mt-1 mx-1 mb-2 capitalize bg-[#036dc3] p-[5px_0px] rounded sm:rounded-none">
                                            {{ $page.props.pakistanTour.packageTitle }}
                                            </p>
                                    </div> 
                                    <div class="w-full gap-2 sm:flex justify-end mr-3 hidden">
                                        <button type="button" class="text-white p-[4px_10px_4px_10px] bg-green-600 text-base rounded-md mt-2 print:hidden" v-print="'#printDiv'"><i class="fa fa-print mt-1"></i> Print</button>
                                        <button v-on:click="exportToPDF" class="text-white p-[4px_10px_4px_10px] bg-green-600 mt-2 text-base rounded-md print:hidden"><i class="fa fa-download mt-1"></i> Download</button>
                                    </div>
                                </div>
                                <div class="flex gap-2 float-right sm:hidden">
                                    <button class="px-3 py-2 text-white bg-green-600 text-base rounded-md print:hidden" v-print="'#printDiv'"><i class="fa fa-print mt-1"></i></button>
                                    <button class="px-3 py-2 text-white bg-green-600 text-base rounded-md print:hidden"><i class="fa fa-download mt-1"></i></button>
                                </div>
                                <div class="col-span-12 text-justify my-4" v-if="$page.props.pakistanTour.shortDescription">
                                    <h3 class="font-bold uppercase mb-2 p-1 bg-rGTBorderColor w-40 rounded-md text-white">Tour Highlights</h3>
                                    <div class="ck-Detail" v-html="$page.props.pakistanTour.shortDescription"></div>
                                </div>
                                <div class="col-span-12 text-justify mb-5" v-if="$page.props.pakistanTour.description">
                                    <h3 class="font-bold uppercase mb-2 p-1 bg-rGTBorderColor w-32 rounded-md text-white">Tour Details</h3>
                                    <div class="leading-[1.50rem] ck-Detail" v-html="$page.props.pakistanTour.description"></div>
                                </div>
                                <div class="col-span-12 text-justify mb-5" v-if="$page.props.pakistanTour.days_details">
                                    <h3 class="font-bold uppercase mb-2 p-1 bg-rGTBorderColor w-24 rounded-md text-white">Iternary</h3>
                                    <div class="leading-[1.50rem] ck-Detail" v-html="$page.props.pakistanTour.days_details"></div>
                                </div>
                                <div class="col-span-12 mb-5 text-center align-middle print:hidden">
                                    <a href="/bank-details" target="_blank" class="text-lg underline font-semibold">For Bank Details <span class="text-red-500">Click Here</span></a>
                                </div>
                                <div class="col-span-12  text-center align-middle bg-bgRGTBaseColor py-1" v-if="$page.props.pakistanTour.price > 0">
                                    <p class="text-lg font-semibold text-white">Tour Price {{ $page.props.pakistanTour.price_label }} : {{ currency.currencyCode }}
                                                        {{ setConverter($page.props.pakistanTour.price, $page.props.pakistanTour.currencyType, currency) }} /- </p>
                                </div>
                                <div class="col-span-12 text-justify mb-5 mt-3" v-if="$page.props.pakistanTour.includes">
                                    <h3 class="font-bold uppercase mb-2 p-1 bg-rGTBorderColor w-24 rounded-md text-white">Includes</h3>
                                    <div class="leading-[1.50rem] ck-Detail" v-html="$page.props.pakistanTour.includes"></div>
                                </div>
                                <div class="col-span-12 text-justify mb-5" v-if="$page.props.pakistanTour.excludes">
                                    <h3 class="font-bold uppercase mb-2 p-1 bg-rGTBorderColor w-24 rounded-md text-white">Excludes</h3>
                                    <div class="leading-[1.50rem] ck-Detail" v-html="$page.props.pakistanTour.excludes"></div>
                                </div>
                                <div class="flex gap-x-2 justify-center mb-3">
                                    <button class="px-3 py-2 text-white bg-green-600 text-base rounded-md print:hidden" v-print="'#printDiv'"><i class="fa fa-print mt-1"></i> &nbsp; Print</button>
                                    <button class="px-3 py-2 text-white bg-green-600 text-base rounded-md print:hidden"><i class="fa fa-download mt-1"></i> &nbsp; Download</button>
                                </div>
                                <ExtraPhoneEmailDetails v-if="$page.props.getNum.whatsapp !== '' || $page.props.getNum.landline !== ''"></ExtraPhoneEmailDetails>
                            </div>
                            <!-- Contact Form -->
                            <div class="md:pt-3  py-0 md:py-0 hidden md:block print:hidden">
                                <div class="bg-white rounded-lg xs:text-justify">
                                    <div class="my-3 w-full">
                                        <p
                                            class="text-xl uppercase bg-bgRGTBaseColor text-white p-[0rem_0.7rem] mb-3 font-medium leading-[2.875rem] md:text-start text-center">
                                            request a callback</p>
                                    </div>
                                    <form class="w-full p-3" @submit.prevent="submit">
                                        <div class="grid grid-cols-12 gap-2">
                                            <div class="col-span-12 md:col-span-4">
                                                <input v-on:keypress="isString" @paste.prevent
                                                    class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    type="text" v-model="form.customers.firstName" placeholder="Your Name">
                                            </div>
                                            <div class="col-span-12 md:col-span-4">
                                                <input v-on:keypress="isNumber" @paste.prevent
                                                    class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    type="tel" v-model="form.customers.mobileNo" placeholder="Phone No">
                                            </div>
                                            <div class="col-span-12 md:col-span-4">
                                                <input v-on:keypress="isEmail" @paste.prevent
                                                    class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    type="email" v-model="form.customers.email" placeholder="Email">
                                            </div>
                                        </div>
                                        <div class="grid grid-cols-12 gap-3">
                                            <div class="col-span-12 md:col-span-8">
                                                <textarea cols="40" v-model="form.contents.message" v-on:keypress="isString" @paste.prevent
                                                    class="appearance-none block h-10 w-full border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"> Message</textarea>
                                            </div>
                                            <div class="col-span-12 md:col-span-2 md:mb-0 mb-4">
                                                <input type="submit" @click="submitDetails()"
                                                    class=" w-full p-2 text-xl bg-blue-100 text-blue-800 border border-solid border-blue-500 text-center transition-all duration-700 ease-in-out rounded hover:bg-bgRGTBaseColor hover:text-white hover:transition-all hover:ease-in-out hover:duration-700">
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </v-pdf>

                    <!-- Right Side -->
                    <div class="sm:col-span-12 lg:col-span-4 sm:mx-3 sm:mt-0 mt-4 col-span-12 w-full print:hidden">
                        <div class="col-span-12 sm:mx-4 ">
                            <div class="relative flex justify-center items-center">
                                <div class=" rounded-[10px] w-full hover:bg-white">
                                    <img :alt="$page.props.pakistanTour.packageTitle" class="rounded-md w-full"
                                        :src="'/assets/Domestic Tour/' + $page.props.pakistanTour.cardImage">
                                </div>
                                <div class="absolute">
                                    <p class="text-white font-bold text-2xl md:text-3xl text-center capitalize drop-shadow-[2px_2px_1px_black] pl-14 sm:pl-0">
                                        {{ $page.props.pakistanTour.packageTitle }}</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-span-12 sm:mx-4">
                            <div class="my-3">
                                <p class="text-xl rounded bg-bgRGTBaseColor text-white p-[0rem_0.7rem] mb-3 font-medium text-center leading-[2.875rem]">
                                    Request a Callback</p>
                            </div>
                        </div>
                        <div class="col-span-12 sm:mx-4">
                            <form  @submit.prevent="submit">
                                <div class="relative">
                                    <input type="text" id="name" v-model="form.customers.firstName" v-on:keypress="isString" @paste.prevent
                                        class="block rounded-t-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="name"
                                        class="absolute text-sm text-black duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">Name
                                        <span class="text-red-600">*</span></label>
                                </div>
                                <div class="relative mt-3">
                                    <input type="tel" id="phone-number" v-model="form.customers.mobileNo" v-on:keypress="isNumber" @paste.prevent
                                        class="block rounded-t-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="phone-number"
                                        class="absolute text-sm text-black duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                                        Phone Number <span class="text-red-600">*</span></label>
                                </div>
                                <div class="relative mt-3">
                                    <input type="email" id="Email" v-model="form.customers.email" v-on:keypress="isEmail" @paste.prevent
                                        class="block rounded-t-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="Email"
                                        class="absolute text-sm text-black duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                                        Email <span class="text-red-600">*</span></label>
                                </div>
                                <div class="relative mt-3">
                                    <textarea id="textArea" v-model="form.contents.message" v-on:keypress="isString" @paste.prevent
                                        class="block rounded-t-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer h-24"
                                        placeholder=""></textarea>
                                    <label for="textArea"
                                        class="absolute text-sm text-black duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                                        Type a Message <span class="text-red-600">*</span></label>
                                </div>
                                <div class="relative mt-3">
                                    <input type="submit" @click="submitDetails()"
                                        class=" w-full p-2 text-xl bg-blue-100 text-blue-800 border border-solid border-blue-500 text-center transition-all duration-700 ease-in-out rounded hover:bg-bgRGTBaseColor hover:text-white hover:transition-all hover:ease-in-out hover:duration-700">
                                </div>

                            </form>
                        </div>
                        <div class="col-span-12 sm:mx-4" v-if="$page.props.getNum.whatsapp !== '' || $page.props.getNum.landline !== ''">
                            <div
                                class="my-3 border-2 border-dashed border-gray-400 p-3 bg-gray-200 rounded text-center justify-center">
                                <p class=" text-blue-800 mb-2">For additional information, kindly get in touch via:</p>
                                <i class=" fa fa-phone text-blue-600"></i> <a href="tel:923355644469"
                                    class="text-blue-800">(+92)3355644469</a>
                            </div>
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
    name: 'pakistanTour',
    data(){
        return{
            banner:"",
            form: {
                customers: {
                    firstName : "",
                    mobileNo : "",
                    email : "",
                },
                contents: {
                    message : "",
                    moduleId : 12,
                    leadFrom : ""
                }
            },
        }
    },
    computed: {
        ...mapState(['currency']),
    },
    mounted(){
        this.banner = '/assets/banner/pakistan-tour.webp';
    },
    methods: {
        async exportToPDF() {
            this.$refs.domesticToPdf.download();
        },
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