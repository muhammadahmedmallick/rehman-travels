<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue"
import LoadingBar from "../../Ticketing/LoadingBar.vue";
</script>

<template>
    <GuestLayout>
        <section>
            <div class="banner md:h-[275px] h-[170px]" :style="'background-image:url(' + banner + ')'">
                <p class="text-white text-[22px] sm:text-[2rem] md:text-[2.5rem] font-bold drop-shadow-[2px_2px_2px_gray] capitalize text-center md:py-28 py-16 sm:px-24">Pakistan Tour Listing</p>
            </div>
            <LoadingBar v-if="loading"> </LoadingBar>
            <div class="w-[90%] mx-auto" id="printDiv">
                <section class="w-full xs:w-[95%] 2xl:w-[80%] mx-auto my-6">
                    <div class="grid grid-cols-12 gap-y-6 sm:gap-y-4 px-2 py-4 rounded-sm">
                        <div v-for="(pakistanTour, pakistanTourIndex) in $page.props.pakistanTour" :key="pakistanTourIndex" class="col-span-12 sm:col-span-6 lg:col-span-4 relative">
                            <div class="group cursor-pointer sm:mx-2 rounded-xl shadow-[0px_2px_6px_0px_#383838]">
                                <img :alt="pakistanTour.packageTitle" :src="'/assets/Domestic Tour/'+ pakistanTour.cardImage"
                                    class="w-full brightness-75 rounded-xl group-hover:brightness-50 group-hover:transition-all group-hover:duration-500 group-hover:ease-in-out transition-all duration-500 ease-in-out" />
                                <div
                                    class="md:group-hover:bottom-5 bottom-2 md:-bottom-10 md:group-hover:transition-all md:group-hover:duration-500 md:group-hover:ease-in-out absolute left-0 w-full px-4 pb-12 md:pb-8 md:px-8 text-white overflow-hidden z-10 transition-all duration-500 ease-in-out">
                                    <p class="capitalize text-xs md:text-sm">{{ pakistanTour.tour_days + ' Days' }},&nbsp; {{ pakistanTour.tour_nights + ' Nights' }}</p>
                                    <p class="text-xl md:text-2xl mt-0 mb-4 block">
                                        <span class="capitalize font-semibold truncate">{{ pakistanTour.packageTitle }} </span>
                                    </p>
                                    <a class="mr-3 md:group-hover:opacity-100 md:group-hover:-bottom-3 md:group-hover:duration-500 md:group-hover:transition-all md:group-hover:ease-in-out bg-blue-700 text-white text-xs md:text-sm font-[400] p-[8px_15px] rounded-md relative -bottom-10 md:bottom-4 opacity-100 md:opacity-0 transition-all duration-500"
                                        :href="pakistanTour.urlLink">Details</a>
                                    <a @click="sendLead(pakistanTour.packageTitle)" class="md:group-hover:opacity-100 md:group-hover:-bottom-3 md:group-hover:duration-500 md:group-hover:transition-all md:group-hover:ease-in-out bg-green-700 text-white text-xs md:text-sm font-[400] p-[8px_15px] rounded-md relative -bottom-10 md:bottom-4 opacity-100 md:opacity-0 transition-all duration-500"
                                        ><i class="fa fa-book-atlas mr-1"></i>Book Now</a>
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
import CurrencyConverter from "@/Config/CurrencyConverter.js";
import { mapState } from "vuex";
export default {
    name: 'PakistanTourListing',
    computed: { ...mapState(['currency']) },
    data() {
        return {
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
                    moduleId: 20,
                    leadFrom: "",
                }
            },
        }
    },
    mounted() {
        this.banner = '/assets/banner/pakistan-tour.webp';
    },
    methods: {
        sendLead(title){
            this.loading = true;
            this.form.contents.leadFrom = title + ' Booking Via Whatsapp';
            this.$inertia.post('whatsapp', this.form, {
                onSuccess: (res) => {
                    this.loading = false;
                    console.log(res);
                }
            } )
        }
    }
}
</script>