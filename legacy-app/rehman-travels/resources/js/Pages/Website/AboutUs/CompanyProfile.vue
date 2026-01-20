<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue"
</script>

<template>
    <GuestLayout>
        <div class="banner md:h-[275px] h-[170px]" :style="'background-image:url('+banner+')'">
            <h2
                class="text-white text-[22px] sm:text-[2rem] md:text-[2.5rem] font-bold drop-shadow-[2px_2px_2px_gray] capitalize text-center md:py-28 py-16 sm:px-24 ">
                Rehman Travel Profile</h2>
        </div>
        <section class="w-[85%] mx-auto bg-white mb-4 mt-4">
            <div class="grid grid-cols-12">
                <div class="col-span-12 mx-4">
                    <h3
                        class=" text-gray-900 pb-2 text-center mt-4 mr-0 mb-8 ml-0 capitalize border-b-2 border-[#323639] border-dashed text-3xl font-medium">
                        About Rehman Group of Travels</h3>
                </div>
                <div class="col-span-12">
                    <p class="text-justify px-6 leading-relaxed text-base mb-2 text-gray-600">
                        Rehman Travels has been in the tour and tourism filed for more than 20 years. Rehman Travels is an
                        established name for Umra and Hajj travel where we endeavour to provide the best value for money and
                        comfort during your stay in Saudi Arabia.

                        Rehman Travels also offers tour and tourism packages through its subsidiary Rehman Holidays for
                        families, couples and solo travellers to all major destinations including Dubai, Malaysia, Thailand,
                        China, Singapore, Indonesia, Sri Lanka, UK, USA, Europe, Australia and Canada.

                        With independent departments for worldwide ticketing, inbound and outbound tours, our optimum aim is
                        to provide top quality professional services to the satisfaction and individual requirements of the
                        passenger.

                        Rehman Travels offers the best competitive fares on all flights both domestic and international. The
                        Rehman Travels web portal provides ease of access and use when booking your flights. We ensure you
                        get the best deals and fare when booking and purchasing your ticket through us. We offer multiple
                        ways to pay including online using credit/debit card through our secure channel.
                    </p>
                </div>
                <div class="col-span-12 md:mt-4 p-5">
                    <!-- PDF View Attached here -->
                    <iframe src="https://www.rehmantravel.com/doc/profile-book-version-02April.pdf"
                        class="w-full h-[1000px]"></iframe>
                </div>
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
                                    class="appearance-none block w-full border h-10 border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"> Message</textarea>
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
    name: 'CompanyProfile',
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
                    moduleId : 9,
                    leadFrom : "Company Profile"
                }
            },
        }
    },
    mounted(){
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
            if(/^[0-9]+$/.test(selectedCharCode)) return true;
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
