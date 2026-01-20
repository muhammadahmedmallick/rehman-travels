<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue"
</script>

<template>
    <GuestLayout>
        <section>
            <LoadingBar v-if="loading" />
            <div class="w-[90%] mx-auto" id="printDiv">
                <section class="w-full xs:w-[95%] 2xl:w-[80%] mx-auto my-6">
                    <div class="md:pt-3 gap-y-10 border border-gray-500 bg-white rounded-xl py-0 md:py-0 mb-4">
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
                                            type="text" v-model="form.customers.firstName" placeholder="Your Name">
                                    </div>
                                    <div class="col-span-12 md:col-span-4">
                                        <input
                                            class="appearance-none block w-full h-10 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                            type="number" v-model="form.customers.mobileNo" placeholder="Phone No">
                                    </div>
                                    <div class="col-span-12 md:col-span-4">
                                        <input
                                            class="appearance-none block w-full h-10 border border-gray-400 hover:border-gray-400 rounded-t-lg py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                            type="email" v-model="form.customers.email" placeholder="Email">
                                    </div>
                                </div>
                                <div class="grid grid-cols-12 gap-3">
                                    <div class="col-span-12 md:col-span-8">
                                        <textarea rows="40" cols="40" placeholder="Your Message"
                                            v-model="form.contents.message"
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
                    <section class="w-full mb-4">
                        <div class="mx-auto bg-bgRGTBaseColor rounded-lg items-center">
                            <h3
                                class="text-2xl capitalize text-white w-full font-medium leading-[2.875rem] md:text-start text-center">
                                Visa Consultancy</h3>
                        </div>
                    </section>
                    <div class="space-y-4">
                        <div v-if="$page.props.visaPackages.some(v => v.type === 'consultancy')"
                            class="border border-gray-300 bg-white rounded-xl shadow p-6">
                            <div class="grid grid-cols-12 gap-y-8 gap-x-4">
                                <div v-for="(visitVisa, visaIndex) in $page.props.visaPackages.filter(v => v.type === 'consultancy')"
                                    :key="'consultancy-' + visaIndex"
                                    class="sm:col-span-3 col-span-4 flex flex-col items-center justify-center text-center mx-auto">
                                    <a class="flex flex-col items-center justify-center text-center transition-transform duration-200 hover:scale-105"
                                        :href="baseUrl + '/' + visitVisa.urlLink">
                                        <img :src="`/assets/flags/${visitVisa.countryName}.jpg`"
                                            class="h-auto mb-2 w-20 object-contain shadow-sm"
                                            :alt="visitVisa.countryName + ' flag'"
                                            @error="(e) => e.target.src = '/assets/flags/default.jpg'" />
                                        <p class="text-sm font-semibold uppercase">{{ visitVisa.packageTitle }}</p>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div v-if="$page.props.visaPackages.some(v => v.type !== 'consultancy')"
                            class="border border-gray-300 bg-white rounded-xl shadow p-6">
                            <div class="grid grid-cols-12 gap-y-8 gap-x-4">
                                <div v-for="(visitVisa, visaIndex) in $page.props.visaPackages.filter(v => v.type !== 'consultancy')"
                                    :key="'other-' + visaIndex"
                                    class="sm:col-span-3 col-span-4 flex flex-col items-center justify-center text-center mx-auto">
                                    <a class="flex flex-col items-center justify-center text-center transition-transform duration-200 hover:scale-105"
                                        :href="baseUrl + '/' + visitVisa.urlLink">
                                        <img :src="`/assets/flags/${visitVisa.countryName}.jpg`"
                                            class="h-auto mb-2 w-20 object-contain shadow-sm"
                                            :alt="visitVisa.countryName + ' flag'"
                                            @error="(e) => e.target.src = '/assets/flags/default.jpg'" />
                                        <p class="text-sm font-semibold uppercase">{{ visitVisa.packageTitle }}</p>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </section>
    </GuestLayout>
</template>
<script>
import LoadingBar from "../Ticketing/LoadingBar.vue";
export default {
    name: 'VisaListing',
    data() {
        return {
            baseUrl: '',
            banner: "",
            loading: false,
            form: {
                customers: {
                    firstName: "",
                    mobileNo: "",
                    email: "",
                },
                contents: {
                    message: "",
                    moduleId: 4,
                    leadFrom: "",
                }
            },
        }
    },
    mounted() {
        this.banner = '/assets/banner/dubai-banner.webp';
        this.baseUrl = this.$page.props.ziggy.url;
    },
    methods: {
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
    }
}
</script>