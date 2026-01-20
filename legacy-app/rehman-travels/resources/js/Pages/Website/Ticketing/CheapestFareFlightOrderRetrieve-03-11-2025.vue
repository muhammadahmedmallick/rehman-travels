<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue"
</script>
<template>
    <GuestLayout>
        <section class="my-10 w-full md:max-w-[700px] lg:max-w-[960px] mx-auto rounded-md">
            <p class="text-red-600">{{paymentError}}</p>
            <v-pdf ref="orderRetrieveToPdf" :options="pdfOptions" :filename="flightItineraryInfo.itineraryRef !== undefined ? flightItineraryInfo.itineraryRef: 'prntopdf'">
                <div ref="orderRetrieve" id="orderRetrieve" class="bg-white p-4">
                <img src="/ticketing/header-img.webp" alt="header-img.webp"/>
                <div class="text-sm py-5">
                    <div class="flex flex-col mb-4 sm:mb-0 lg:mr-16">
                        <table>
                            <tbody>
                                <tr class="align-baseline">
                                    <td v-if="flightItinerary.persons !== undefined">
                                        <table class="lg:w-[28rem]">
                                            <tbody>
                                            <tr>
                                                <td><b>Traveller Name's</b></td>
                                                <td v-if="flightItinerary.persons[0].ticketNumber !== undefined">
                                                    <b>Ticket Number</b>
                                                </td>
                                            </tr>
                                            <tr v-for="(person, personKey) in flightItinerary.persons" :key="personKey">
                                                <td>{{flightItineraryInfo.airType == 'Airsial' ? '' : person.lastName +'/'}}{{ person.firstName }}</td>
                                                <td v-if="person.ticketNumber !== undefined">
                                                    {{ (person.ticketNumber !== undefined ? person.ticketNumber : '') }} -
                                                    {{ (person.ticketStatus !== undefined ? person.ticketStatus : '') }}
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                    <td v-if="(flightItineraryInfo.responseError !== undefined && flightItineraryInfo.responseError !== '')">
                                        <table class="lg:w-[28rem] text-red-600">
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <b>{{flightItineraryInfo.responseError}}</b>
                                                        &nbsp;
                                                        <b>PNR Status is:{{flightItineraryInfo.status}}</b>
                                                    </td></tr>
                                            </tbody>
                                        </table>
                                    </td>
                                    <td>
                                        <table>
                                            <tbody>
                                            <tr class="align-baseline">
                                                <td>
                                                    <span class="font-bold">Contact Details</span>
                                                    <span v-if="flightItinerary.persons !== undefined">
                                                        <br/>
                                                        <span class="font-bold mr-1">Name:</span>
                                                         <span v-if="flightItinerary.persons !== undefined">
                                                            {{flightItineraryInfo.airType == 'Airsial' ? '' : flightItinerary.persons[0].lastName +'/'}}
                                                            {{ flightItinerary.persons[0].firstName }}
                                                        </span>
                                                    </span>
                                                    <span v-if="flightItineraryInfo.airType !== undefined">
                                                        <br/>
                                                        <span class="font-bold mr-1">Supplier:</span>
                                                        <span>{{ (flightItineraryInfo.supplier !== undefined ? flightItineraryInfo.supplier : flightItineraryInfo.airType) }}</span>
                                                    </span>
                                                    <span v-if="flightItineraryInfo.itineraryRef !== undefined">
                                                        <br/>
                                                        <span class="font-bold mr-1">itineraryRef:</span>
                                                        <span>{{ flightItineraryInfo.itineraryRef }}</span>
                                                    </span>
                                                    <span v-if="flightItineraryInfo.reference !== undefined">
                                                        <br/>
                                                        <span class="font-bold mr-1">Reference:</span>
                                                        <span>{{ flightItineraryInfo.airType == 'Airarabia' || flightItineraryInfo.airType == 'Flyjinnah' ? flightItineraryInfo.itineraryRef : flightItineraryInfo.reference }}</span>
                                                    </span>
                                                    <span v-if="flightItineraryInfo.status !== undefined">
                                                        <br/>
                                                        <span class="font-bold mr-1">PNR Status:</span>
                                                        <span>{{ flightItineraryInfo.status }}</span>
                                                    </span>
                                                    <span v-if="flightItinerary.contacts !== undefined && flightItinerary.contacts[0].phone !== undefined">
                                                         <br/>
                                                        <span class="font-bold mr-1">Mobile No:</span>
                                                        <span>{{ flightItinerary.contacts[0].phone }}</span>
                                                    </span>
                                                    <span v-if="flightItinerary.contacts !== undefined && flightItinerary.contacts[0].email !== undefined">
                                                        <br/>
                                                        <span class="font-bold mr-1">Email:</span>
                                                        <span>{{ flightItinerary.contacts[0].email }}</span>
                                                    </span>
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div v-if="flightItinerary.legs !== undefined" :class="overflowClass">
                    <table class="table-fixed text-left text-sm printing">
                        <thead>
                        <tr class="border-b border-black/20">
                            <th class="pl-2 py-2 w-[6.9rem]">Day</th>
                            <th class="py-2 w-[4.8rem]">Date</th>
                            <th class="py-2 w-[25rem]">City / Terminal / Stopover City</th>
                            <th class="py-2 w-20">Time</th>
                            <th class="py-2 w-24">Duration</th>
                            <th class="py-2 w-20">Flight</th>
                            <th class="py-2 w-20">Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="(leg, legKey) in flightItinerary.legs" :key="legKey"
                            class="border-b border-black/20">
                            <td class="pl-2 pb-5">{{ setInitialDate(leg.departureDate, "dddd") }}</td>
                            <td class="pt-2 pb-5">{{ setInitialDate(leg.departureDate, "DD MMM") }}</td>
                            <td class="pt-2 pb-5">
                                <span>DEP {{ leg.departureCode }} - {{ leg.departureAirportCode }}</span><br/>
                                <span>ARR {{ leg.arrivalCode }} - {{ leg.arrivalAirportCode }}</span>
                            </td>
                            <td class="pt-2 pb-5">
                                <span>
                                    {{(leg.departureTime.toLowerCase().includes("m") ? leg.departureTime.toLowerCase() : setInitialDate(leg.departureDate + ' ' + leg.departureTime, "h:mm a")) }}
                                </span><br/>
                                <span>
                                    {{(leg.arrivalTime.toLowerCase().includes("m") ? leg.arrivalTime.toLowerCase() : setInitialDate(leg.arrivalDate + ' ' + leg.arrivalTime, "h:mm a")) }}
                                </span>
                            </td>
                            <td class="pt-2 pb-5">{{(leg.duration !== undefined && leg.duration !== "" ? leg.duration : leg.elapsedTime) }}</td>
                            <td>{{ leg.operatingAirlineCode }} {{ leg.operatingFlightNumber }}</td>
                            <td>{{ (leg.status === "HK" ? "Confirmed" : leg.status) }}</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div v-if="flightItinerary.legs !== undefined" class="grid grid-cols-12 my-4">
                    <div v-if="flightItinerary.policy !== undefined" class="col-span-12 mb-4 px-2">
                        <div class="grid grid-cols-12">
                            <span
                                class="col-span-12 xxs:col-span-5 sm:col-span-4 md:col-span-4 lg:col-span-3 font-bold">Endorsment/Restrictions</span>
                            <span class="col-span-12 xxs:col-span-12 sm:col-span-8 lg:col-span-9 text-sm text-justify">
                                    <span v-for="(policy,policyKey) in flightItinerary.policy" :key="policyKey">
                                     {{ policy.text }}
                                     </span>
                            </span>
                        </div>
                    </div>
                    <div v-if="flightItinerary.baggage !== undefined" class="col-span-12 mb-4 px-2">
                        <div class="grid grid-cols-12">
                            <span
                                class="col-span-12 xxs:col-span-5 sm:col-span-4 md:col-span-4 lg:col-span-3 font-bold">Baggage</span>
                            <span class="col-span-12 xxs:col-span-12 sm:col-span-8 lg:col-span-9 text-sm">
                              <span v-for="(baggage,baggageKey) in flightItinerary.baggage" :key="baggageKey">
                                  {{ baggage.passengerType }}  {{ baggage.segment }}  {{ baggage.baggageAllowance }}  /
                              </span>
                            </span>
                        </div>
                    </div>
                    <div class="col-span-12 sm:flex sm:justify-between mb-4 border-t border-b border-black/30">
                        <div class="grid grid-cols-12 p-2">
                          <div class="col-span-4">
                            <span class="mr-4 md:mr-6 font-bold">FOP</span>
                            <span v-if="flightItinerary.flightItineraryInfo.receivedFrom !== undefined" class="text-sm">{{flightItinerary.flightItineraryInfo.receivedFrom}}</span>
                          </div>
                            <div class="col-span-4 sm:mr-20 lg:mr-28">
                                <span class="mr-4 md:mr-6 font-bold">Fare</span>
                                <span v-if="flightItinerary.price !== undefined" class="text-sm">{{currency.currencySymbol}}{{setConverter(flightItinerary.price.baseFare, currency.currencyRate)}}
                                 </span>
                            </div>
                            <div class="col-span-4">
                                <span class="mr-4 md:mr-6 ml-4 md:ml-0 lg:ml-3 font-bold">Taxes</span>
                                <span v-if="flightItinerary.price !== undefined" class="text-sm">{{currency.currencySymbol}}{{setConverter(flightItinerary.price.taxes, currency.currencyRate)}}
                                </span>
                            </div>
                        </div>
                        <div class="grid grid-cols-12">
                            <div class="col-span-12 bg-black/20 p-2">
                                <span class="mr-4 md:mr-8 font-bold">Total Fare</span>
                                <span v-if="flightItinerary.price !== undefined" class="text-sm">{{currency.currencySymbol}}{{ setConverter(flightItinerary.price.totalFare, currency.currencyRate) }}
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-span-12 mb-4">
                        <p class="col-span-3 text-justify">
                            Data protection notice: your personal data will be processed in
                            accordance with the applicable carriers privacy policy And, if your
                            booking is made via a reservation system provider (gds), with its
                            privacy policy. These are available at
                            <a href="https://rehmantravel.com/privacy" class="text-blue-600">https://rehmantravel.com/privacy</a>
                            or from the carrier or gds directly. You should read this
                            documentation, which Applies to your booking and specifies, for
                            example, how your personal data is collected, stored, used, disclosed
                            and Transferred.
                        </p>
                    </div>
                </div>
                <img src="/ticketing/footer-img.webp" alt="footer-img.webp"/>
            </div>
            </v-pdf>
            <div class="flex items-center justify-center mt-10">
                <button v-on:click="sendMail"
                        class="btn flex items-center justify-center h-12 w-12 sm:w-14 sm:h-14 md:w-16 md:h-16 lg:w-20 lg:h-20 bg-white border-[#262626] border-2 text-xl sm:text-2xl md:text-3xl lg:text-4xl mx-4 md:mx-7 lg:mx-10 rounded-full relative overflow-hidden z-10  before:bg-[#0181dd] hover:before:top-0 before:duration-500 before:absolute before:top-20 before:left-0 before:w-full before:h-full before:z-20 cursor-pointer">
                    <i class="fa fa-envelope relative text-gray-700 duration-500 z-30"/>
                </button>
                <button v-print="'#orderRetrieve'"
                        class="btn flex items-center justify-center h-12 w-12 sm:w-14 sm:h-14 md:w-16 md:h-16 lg:w-20 lg:h-20 bg-white border-[#262626] border-2 text-xl sm:text-2xl md:text-3xl lg:text-4xl mx-4 md:mx-7 lg:mx-10 rounded-full relative overflow-hidden z-10  before:bg-[#0181dd] hover:before:top-0 before:duration-500 before:absolute before:top-20 before:left-0 before:w-full before:h-full before:z-20 cursor-pointer">
                    <i class="fa fa-print icon relative text-gray-700 duration-500 z-30"/>
                </button>
                <button v-on:click="exportToPDF"
                        class="btn flex items-center justify-center h-12 w-12 sm:w-14 sm:h-14 md:w-16 md:h-16 lg:w-20 lg:h-20 bg-white border-[#262626] border-2 text-xl sm:text-2xl md:text-3xl lg:text-4xl mx-4 md:mx-7 lg:mx-10 rounded-full relative overflow-hidden z-10  before:bg-[#0181dd] hover:before:top-0 before:duration-500 before:absolute before:top-20 before:left-0 before:w-full before:h-full before:z-20 cursor-pointer">
                    <i class="fa fa-file-pdf relative text-gray-700 duration-500 z-30"/>
                </button>
            </div>
        </section>
    </GuestLayout>
</template>

<script>
import Service from "@/Config/Service.js";
import CurrencyConverter from "@/Config/CurrencyConverter";
import moment from "moment";
import {mapState} from "vuex";
export default {
    name: "CheapestFareFlightOrderRetrieve",
    computed: {
        ...mapState(['currency'])
    },
    data() {
        return {
            overflowClass: 'overflow-auto',
            orderRetrieveProvider: {type: Object},
            flightItinerary: {type: Object},
            flightItineraryInfo: {type: Object},
            input: {type: Object},
            paymentError:"",
            pdfOptions:{
                image: {type: 'jpeg',quality: 1},
                html2canvas: { scale: 3 },
                jsPDF: {unit: 'mm',format: 'a4',orientation: 'p'},
            },
        }
    },
    created() {
        this.orderRetrieveProvider = this.$page.props.orderRetrieveProvider
        this.flightItinerary = this.orderRetrieveProvider
        this.flightItineraryInfo = this.orderRetrieveProvider.flightItineraryInfo
        this.paymentError = ((this.airURLSearchParam().get('message') !== undefined) ? this.airURLSearchParam().get('message') : '')
    },
    methods: {
        setInitialDate(initialDate, formatType) {
            return moment(initialDate).format(formatType)
        },
        setConverter(amount, currency) {
            return CurrencyConverter.doRequest(amount, currency)
        },
        sendMail() {
            Service.doFetchRequest("/ticketing/cheapest-fare-flight-order-retrieve-send-pdf-email", 'Create', {'orderRetrieveProvider':this.orderRetrieveProvider}).then(response => {
                if (response.errorType === false) {
                    this.$toast.success(response.message);
                } else {
                    this.$toast.error(response.message);
                }
            });
        },
        async exportToPDF() {
            this.$refs.orderRetrieveToPdf.download()
        },
        params: function (type) {
            let params = {};
            let query = "";
            let paramKey = 0;
            this.airURLSearchParam().forEach((value, key) => {
                params[key] = value;
                query += (paramKey === 0 ? '?' : '&') + key + "=" + value;
                paramKey++;
            });
            return (type === 'p' ? params : query);
        },
        airURLSearchParam: function () {
            return new URLSearchParams(window.location.search)
        },
        start() {
            this.loading = true
        },
        finish() {
            this.loading = false
        },
    }
}
</script>
