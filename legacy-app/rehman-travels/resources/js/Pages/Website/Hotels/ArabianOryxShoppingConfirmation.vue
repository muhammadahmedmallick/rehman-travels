<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
import LoadingBar from "@/Pages/Website/Ticketing/LoadingBar.vue";
import HotelFormInput from "../../../Layout/Website/HotelFormInput.vue";
</script>
<template>
    <GuestLayout>
        <section class="container mx-auto mt-3 md:mt-8">
            <div class="min-h-screen bg-gray-50" id="printDiv">
                <header class="bg-blue-900 text-white flex items-center justify-between px-6 py-4">
                    <div class="flex items-center space-x-4">
                        <img src="/rgt-logo.webp" alt="Rehman Travel Logo" class="w-20 h-10" />
                        <h1 class="text-xl font-semibold italic text-white/80">Rehman Travel</h1>
                    </div>
                </header>

                <main class="p-4 space-y-6 text-gray-800"   v-for="(confirmation, confirmationIndex) in $page.props.confirmationDetails" :key="confirmationIndex">
                    <div class="text-left space-y-4 sm:space-y-3">
                        <h2 class="text-xl sm:text-2xl">Booking confirmed, <b>{{ confirmation.isLead }}</b>! You're good to go!
                        </h2>
                        <p class="text-xs mt-2 text-black sm:text-base">
                            <i class="fas fa-suitcase-rolling mr-2 text-green-500"></i>
                            All set at <span class="font-bold">{{confirmation['hotelDetails'].name}}</span>. See you soon!
                        </p>
                        <div class="space-y-2 text-left">
                            <p class="text-xs text-gray-700 sm:text-base">
                                <i class="fas fa-calendar-check mr-2 text-green-500"></i>
                                {{confirmation['hotelDetails'].name}} is all set for your arrival on <span class="font-semibold">{{
                                    confirmation.shoppingDetails['check_in'] }}</span>.
                            </p>
                            <p class="text-sm text-gray-700 sm:text-base">
                                <i class="fas fa-phone-alt mr-2 text-green-500"></i>
                                Feel free to call or email us with any questions.
                            </p>
                        </div>
                    </div>
                    <div class="relative">
                        <div class="bg-white rounded-lg shadow-md p-2 space-y-2 relative">
                            <div class="text-center sm:text-left">
                                <h3 class="text-lg font-semibold italic">{{confirmation['hotelDetails'].name}}</h3>
                                <p class="text-sm text-blue-950">{{confirmation['hotelDetails'].address}}</p>
                            </div>
                            <div class="flex flex-col sm:flex-row sm:space-x-4">
                                <div class="w-full sm:w-1/2">
                                    <iframe class="w-full h-40 sm:h-64 rounded-md" scrolling="no" :src="'https://maps.google.com/?q=' + hotelExinfo.lat + ',' + hotelExinfo.lon + '&hl=en&z=14&amp;output=embed'" frameborder="0"
                                        allowfullscreen></iframe>
                                </div>
                                <div class="w-full sm:w-1/2 flex items-center justify-center">
                                    <img :src="hotelExinfo.img" alt="Hotel"
                                        class="rounded-md object-cover w-full h-40 sm:h-64" />
                                </div>
                            </div>
                        </div>
                        <img src="/assets/Hotels/shopping-cancelled.png" alt="Cancel Hotel"
                         v-if="htlCcl == 4"
                                    class="rounded-md object-cover absolute top-0 left-1/2 transform -translate-x-1/2 -rotate-[14deg] w-80 h-80 md:w-96 md:h-96" />
                    </div>
    
                    <div class="bg-white rounded-lg shadow-md p-4 grid grid-cols-1 sm:grid-cols-4 gap-4">
                        <!-- Booking Details -->
                        <div class="border-b sm:border-none">
                            <h3 class="text-lg font-semibold border-b pb-2 mb-2">Booking Details</h3>
                            <div class="grid gap-2 text-sm text-gray-700">
                                <p><strong>Booking Number:</strong> {{ payload.crfm }}</p>
                                <p><strong>Check-in:</strong> {{ confirmation.shoppingDetails['check_in'] }}</p>
                                <p><strong>Check-out:</strong> {{ confirmation.shoppingDetails['check_out'] }}</p>
                            </div>
                        </div>
                        <div class="border-b sm:border-none">
                            <h3 class="text-lg font-semibold border-b pb-2 mb-2">Guest Details</h3>
                            <div class="grid gap-2 text-sm text-gray-700" v-for="(guest, guestIndex) in confirmation.roomGuests" :key="guestIndex">
                                <p><strong>Guest {{ guestIndex+1 }} :</strong> {{ guest.guestName }}</p>
                            </div>
                        </div>
                        <div class="border-b sm:border-none">
                            <h3 class="text-lg font-semibold border-b pb-2 mb-2">Room Details</h3>
                            <div class="grid gap-2 text-sm text-gray-700">
                                <p><strong>Room Name :</strong>  {{ confirmation.roomDetails['room_name'] }}</p>
                                <p><strong>Meal :</strong>  {{ confirmation.roomDetails['meal'] }}</p>
                                <p><strong>Rate Type :</strong>  <span :class="`font-bold ${confirmation.roomDetails['rate_type'] === 'Refundable' ? 'text-green-600' : 'text-red-600'}`">{{ confirmation.roomDetails['rate_type'] }}</span></p>
                                <p><strong>Status :</strong>  {{ confirmation.roomDetails['status'] }}</p>
                            </div>
                        </div>
                        <div>
                            <h3 class="text-lg font-semibold border-b pb-2 mb-2">Payment Summary</h3>
                            <div class="text-sm text-gray-700 space-y-2">
                                <p><strong>Total Amount:</strong> {{ currency.currencySymbol }} {{ setConverter(confirmation.gross, currency.currencyRate) }} </p>
                                <p><strong>Tax:</strong> {{ currency.currencySymbol }}  {{ setConverter(confirmation.tax, currency.currencyRate) }}</p>
                                <p><strong>Amount Paid:</strong> {{ currency.currencySymbol }}  {{ setConverter(confirmation.net, currency.currencyRate) }}</p>
                            </div>
                        </div>
                    </div>
    
                    <div class="flex flex-col sm:flex-row gap-5 justify-center sm:justify-start print:hidden">
                        <!-- <button
                            class="px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600 shadow-md flex items-center justify-center w-full sm:w-auto mb-4 sm:mb-0"
                            @click="downloadPDF">
                            <i class="fas fa-file-pdf mr-2"></i> Download PDF
                        </button> -->
    
                        <!-- <button
                            class="px-4 py-2 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600 shadow-md flex items-center justify-center w-full sm:w-auto mb-4 sm:mb-0"
                            @click="emailBooking">
                            <i class="fas fa-envelope mr-2"></i> Email
                        </button> -->
    
                        <button
                            class="px-4 py-2 bg-purple-500 text-white rounded-lg hover:bg-purple-600 shadow-md flex items-center justify-center w-full sm:w-auto mb-4 sm:mb-0"
                            v-print="'#printDiv'">
                            <i class="fas fa-print mr-2"></i> Print
                        </button>
    
                        <!-- <button @click="cancelShopping" v-if="htlCcl != 4"
                            class="px-6 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 shadow-md w-full sm:w-auto">
                            Cancel Your Booking
                        </button> -->
    
                        <!-- <p class="text-sm italic text-red-950 mt-2 sm:mt-0 sm:text-center print:block" v-if="confirmation['hotelDetails']['roomInfo']['room']">
                            This booking is {{ confirmation['hotelDetails']['roomInfo']['room'][0].rateType }} in given time period.
                        </p> -->
                        
                    </div>
                </main>
            </div>
        </section>
    </GuestLayout>
</template>

<script>
import { mapState } from "vuex";
import HotelCurrencyConverter from "@/Config/HotelCurrencyConverter.js";
export default {
    name: "CheapestBookingPage",
    data() {
        return {
            hotelExinfo: '',
            loading: false,
            payload: { type: Object },
            guests: 0,
            totalNights: 0,
            htlCcl : 0,
        }
    },
    mounted() {
        this.hotelExinfo = JSON.parse(localStorage.getItem('hotelGeoLocation'));
        const hotelURLSearchParam = this.hotelURLSearchParams();
        this.htlCcl = (localStorage.getItem('htlCcl') ? localStorage.getItem('htlCcl') : '')
        this.payload = {
            'countryCode': hotelURLSearchParam.get('c'),
            'bck': hotelURLSearchParam.get('bck'),
            'rooms': hotelURLSearchParam.get('rm'),
            'totalNights': hotelURLSearchParam.get('tn'),
            'destinationCode': hotelURLSearchParam.get('des'),
            'groupCode': hotelURLSearchParam.get('gc'),
            'hotelCode': hotelURLSearchParam.get('hc'),
            'checkInDate': hotelURLSearchParam.get('chi'),
            'checkOutDate': hotelURLSearchParam.get('cho'),
            'nationality': hotelURLSearchParam.get('c'),
            'adultCount': hotelURLSearchParam.get('ac'),
            'childCount': (hotelURLSearchParam.get('cc') ? hotelURLSearchParam.get('cc') : 0),
            'personsDetails': JSON.parse(localStorage.getItem('arabianOryxSearch')),
            'gross': hotelURLSearchParam.get('gam'),
            'net': hotelURLSearchParam.get('nam'),
            'tax': hotelURLSearchParam.get('tam'),
            'crfm': hotelURLSearchParam.get('crfm')
        };
        this.guests = Number(this.payload.adultCount) + Number(this.payload.childCount);
        this.totalNights = hotelURLSearchParam.get('tn');
    },
    computed: {
        ...mapState(['currency']),
    },
    methods: {
        hotelURLSearchParams: function () {
            return new URLSearchParams(window.location.search)
        },
        setConverter(amount, currencyRate) {
            let getUAECurrency = this.$page.props.currencies[0]
            if (this.currency.currencyCode !== "USD") {
                return HotelCurrencyConverter.doRequest(amount, currencyRate, getUAECurrency.currencyRate)
            } else if(amount !== undefined){
                return eval(amount).toFixed()
            }
        },
    }
}
</script>