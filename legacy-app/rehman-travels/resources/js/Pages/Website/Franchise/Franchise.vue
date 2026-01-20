<script setup>
import GuestLayout from '@/Layouts/GuestLayout.vue';
</script>

<template>
    <GuestLayout>
        <section class="bg-white">
            <div class="banner md:h-[275px] h-[170px]" :style="'background-image:url(' + banner + ')'">
                <p class="text-white text-lg  sm:text-[2rem] md:text-[2.5rem] font-bold drop-shadow-[2px_2px_2px_gray] capitalize text-center py-28 sm:px-24 ">
                    Franchises</p>
            </div>
            <div id="printDiv" class="w-[90%] mx-auto border border-1 border-gray-300 rounded-md">
                <div class="grid grid-cols-12 bg-[#0181dd] rounded-t-md">
                    <div class="col-span-12 lg:col-span-6">
                        <h1 class="text-center lg:text-left  text-white py-2 lg:pl-4 text-xl font-bold capitalize"> {{ $page.props.franchisePackages.packageTitle }}</h1>
                    </div>
                    <div class="col-span-12 lg:col-span-6 md:pb-1">
                        <div class="flex flex-col xs:flex-row xs:justify-center lg:justify-end mt-2 mx-2 ">
                            <button v-print="'#printDiv'" class="mb-1 px-5 bg-white text-[#0181dd] print:hidden mr-2 py-1 rounded-md">
                                <i class="fa-solid fa-print"></i> Print</button>
                            <button v-on:click="exportToPDF" class="mb-1 px-5 bg-white text-[#0181dd] print:hidden mr-2 py-1 rounded-md">
                                <i class="fa-solid fa-download"></i> Download</button>
                        </div>
                    </div>
                </div>
                <v-pdf ref="orderRetrieveToPdf" :options="pdfOptions" :filename="'Rehman Travel Franchise Registration Form'">
                    <div class="mt-3 pb-6 px-6 border-b border-1 border-dashed border-gray-500 ck-Detail" v-html="$page.props.franchisePackages.description">
                    </div>
                </v-pdf>
                <!-- Form -->
                <div class="w-[95%]  mx-auto mt-10  mb-10 print:hidden">
                    <form @submit.prevent="submit">
                        <div class="grid grid-cols-12 lg:grid-cols-9 gap-2">
                            <div class="col-span-12 sm:col-span-6 md:col-span-4 lg:col-span-2">
                                <div class="relative z-0">
                                    <input type="text" @paste.prevent v-on:keypress="isString" autocomplete="off" id="fullname" v-model="input.customers.firstName"
                                        class="block px-2.5 pb-2.5 pt-4 w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-lg  appearance-none  focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="fullname"
                                        class="absolute text-base text-gray-500  duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                        Full Name</label>
                                </div>
                            </div>
                            <div class="col-span-12 sm:col-span-6 md:col-span-4 lg:col-span-2">
                                <div class="relative z-0">
                                    <input type="email" @paste.prevent v-on:keypress="isEmail" autocomplete="off" id="Email" v-model="input.customers.email"
                                        class="block px-2.5 pb-2.5 pt-4 w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-lg  appearance-none  focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="Email"
                                        class="absolute text-base focus:text-lg text-gray-500  duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                        Email</label>
                                </div>
                            </div>
                            <div class="col-span-12 sm:col-span-6 md:col-span-4 lg:col-span-2">
                                <div class="relative z-0">
                                    <input type="tel" @paste.prevent v-on:keypress="isNumber" autocomplete="off" maxlength="20" id="mobileno" v-model="input.customers.mobileNo"
                                        class="block px-2.5 pb-2.5 pt-4 w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-lg  appearance-none  focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="mobileno" class="absolute text-base focus:text-lg text-gray-500  duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">Mobile No</label>
                                </div>
                            </div>
                            <div class="col-span-12 sm:col-span-6 md:col-span-4 lg:col-span-3">
                                <div class="relative z-0">
                                    <input type="text" @paste.prevent v-on:keypress="isString" autocomplete="off" maxlength="20" id="city" v-model="input.contents.city"
                                        class="block px-2.5 pb-2.5 pt-4 w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-lg  appearance-none  focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="city"
                                        class="absolute text-base focus:text-lg text-gray-500  duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                        City</label>
                                </div>
                            </div>
                            <div class="col-span-12 sm:col-span-6 md:col-span-4 lg:col-span-2">
                                <div class="relative z-0">
                                    <input type="text" @paste.prevent v-on:keypress="isString" autocomplete="off" id="address" v-model="input.contents.address"
                                        class="block px-2.5 pb-2.5 pt-4 w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-lg  appearance-none  focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="address"
                                        class="absolute text-base focus:text-lg text-gray-500  duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                        Address</label>
                                </div>
                            </div>
                            <div class="col-span-12 sm:col-span-6 md:col-span-4 lg:col-span-2">
                                <div class="relative z-0">
                                    <input type="text" @paste.prevent v-on:keypress="isString" autocomplete="off" id="education" v-model="input.contents.education"
                                        class="block px-2.5 pb-2.5 pt-4 w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-lg  appearance-none  focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="education"
                                        class="absolute text-base focus:text-lg text-gray-500  duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                        Education</label>
                                </div>
                            </div>
                            <div class="col-span-12 sm:col-span-6 md:col-span-4 lg:col-span-2">
                                <div class="relative z-0">
                                    <input type="text" @paste.prevent v-on:keypress="isNumber" autocomplete="off" maxlength="17" id="cnic" v-model="input.contents.cnic" class="block px-2.5 pb-2.5 pt-4 w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-lg  appearance-none  focus:ring-0 focus:border-blue-600 peer" placeholder=" " />
                                    <label for="cnic" class="absolute text-base focus:text-lg text-gray-500  duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                        CNIC </label>
                                </div>
                            </div>
                            <div class="col-span-12 sm:col-span-6 md:col-span-4 lg:col-span-3">
                                <div class="relative z-0">
                                    <input type="text" @paste.prevent v-on:keypress="isNumber" autocomplete="off" id="investment" v-model="input.contents.Investment" class="block px-2.5 pb-2.5 pt-4 w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-lg  appearance-none  focus:ring-0 focus:border-blue-600 peer" placeholder=" " />
                                    <label for="investment "
                                        class="absolute text-base focus:text-lg text-gray-500  duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                        Investment </label>
                                </div>
                            </div>
                            <div class=" col-span-12 sm:col-span-12 lg:col-span-9">
                                <div class="relative z-0">
                                    <textarea rows="3" @paste.prevent v-on:keypress="isString" autocomplete="off" id="details" v-model="input.contents.message" class="block px-2.5 pb-2.5 pt-4 w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-lg  appearance-none  focus:ring-0 focus:border-blue-600 peer" placeholder=" "></textarea>
                                    <label for="details" class="absolute text-base focus:text-lg text-gray-500  duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white  px-2 peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-5 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1"> Details </label>
                                </div>
                            </div>
                            <div class="col-span-12 lg:col-span-9">
                                <div class="flex justify-center lg:justify-end items-center mt-3">
                                    <button @click="saveFranchise()" class="bg-[#0181dd] text-white text-lg px-24 py-2 rounded-md capitalize font-semibold transition-all duration-500 ease-in-out focus:outline-none focus:bg-green-700 hover:bg-green-700 hover:transition-all hover:ease-in-out hover:duration-500 ">Register</button>
                                </div>
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
    data() {
        return {
            requirementbtn: false,
            banner: "",
            input: {
                customers: {
                    firstName : "",
                    mobileNo : "",
                    email : "",
                },
                contents: {
                    city: "",
                    address: "",
                    education: "",
                    cnic: "",
                    Investment: "",
                    message : "",
                    moduleId : 7,
                    leadFrom : this.$page.props.franchisePackages.packageTitle
                }
            },
            pdfOptions:{
                image: {type: 'jpeg',quality: 1},
                html2canvas: { scale: 3 },
                jsPDF: {unit: 'mm',format: 'a4',orientation: 'p'},
            },
        };
    },
    mounted() {
        this.banner = '/assets/Visa/dubai-banner.webp';
    },
    methods: {
        async exportToPDF() {
            this.$refs.orderRetrieveToPdf.download()
        },
        saveFranchise(){
            if(this.input.customers.mobileNo == ""){
                this.$toast.error('Mobile Number is Required.');
            }else if(this.input.customers.firstName == ""){
                this.$toast.error('First Name is Required.');
            }else if(this.input.customers.email == ""){
                this.$toast.error('Email is Required.');
            }else if(this.input.contents.city == ""){
                this.$toast.error('City is Required.');
            }else{
                this.$inertia.post('/addContactDetails', this.input, {
                    onSuccess: (response) => {
                        window.location.href = '/Website/thankYou';
                    }
                });
            }
        },
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
            if(/^[0-9 -+]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
    },
};
</script>