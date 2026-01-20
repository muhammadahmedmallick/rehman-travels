<script setup>
import SearchFlight from '@/Layout/Website/SearchFlight.vue';
import GuestLayout from "@/Layouts/GuestLayout.vue";
</script>
<template>
    <GuestLayout v-slot="{ selectedCurrencyFromParent }" :selectedCurrencyFromChild="selectedCurrencyFromChild">
        <SearchFlight @selectedCurrencyFromChildToParent="selectedCurrencyFromChildToParent"
            :selectedCurrencyFromParent="selectedCurrencyFromParent" />
        <div class="-mt-56 md:-mt-36">
            <section class="px-2 md:px-4 mb-4 mx-auto w-[90%] sm:w-[78%] xl:w-[88%] 2xl:w-[70%]">
                <div class="rounded-lg xs:text-justify">
                    <p class=" p-3 w-fit font-bold text-xs text-gray-400 mb-4">
                        rehmantravel.com &nbsp;/ &nbsp;Cheap Tickets &nbsp;/ &nbsp;{{ $page.props.dynamicFlightPages.packageTitle }}
                    </p>
                </div>
            </section>
            <!-- Cheapest Flight Section -->
            <div class="border border-slate-300 bg-white shadow rounded-lg p-4 h-[180px] px-2 md:px-4 mb-3 mx-auto w-[90%] sm:w-[78%] xl:w-[88%] 2xl:w-[70%] mt-8"
            v-if= "cheapestFare.isRecordFounds.length === 0">
                <div class="animate-pulse flex space-x-4">
                    <div class="rounded-full bg-slate-200 h-24 w-24"></div>
                    <div class="flex-1 space-y-6 py-1">
                        <div class="h-9 bg-slate-200 rounded items-center justify-center font-bold"> Searching for Cheap Flights, Please wait!</div>
                        <div class="space-y-3">
                            <div class="grid grid-cols-3 gap-4">
                                <div class="h-2 bg-slate-200 rounded col-span-2"></div>
                                <div class="h-2 bg-slate-200 rounded col-span-1"></div>
                                <div class="h-2 bg-slate-200 rounded col-span-1"></div>
                                <div class="h-2 bg-slate-200 rounded col-span-1"></div>
                                <div class="h-2 bg-slate-200 rounded col-span-1"></div>
                            </div>
                            <div class="h-2 bg-slate-200 rounded"></div>
                            <div class="h-2 bg-slate-200 rounded"></div>
                        </div>
                    </div>
                </div>
            </div>
            <section class="px-2 md:px-4 mb-3 mx-auto w-[90%] sm:w-[78%] xl:w-[88%] 2xl:w-[70%] mt-8" v-else>
                <div class="grid grid-cols-12 gap-y-5">
                    <div class="col-span-12 md:col-span-5 lg:col-span-6">
                        <div class="flex items-center">
                            <h1 class="text-lg capitalize font-semibold text-gray-600">
                                Cheap Flights from {{ $page.props.dynamicFlightPages.packageTitle }}
                            </h1>
                        </div>
                    </div>
                    <div class="col-span-12 md:col-span-7 lg:col-span-6">
                        <div class="flex justify-start md:justify-end rounded-md">
                            <button @click="byOrderType('asc')" class="p-2 bg-bgRGTBaseColor text-[white] font-semibold text-xs sm:text-sm rounded-md">
                                Lowest Price
                            </button>
                            <button @click="byOrderType('desc')" class="p-2 font-semibold text-xs sm:text-sm rounded-md">
                                Most Popular
                            </button>
                            <button class="p-2 font-semibold text-xs sm:text-sm rounded-md" @click="byOrderType('OurTrending')">
                                Our Trending
                            </button>
                        </div>
                    </div>
                </div>
                <!-- {{ cheapestFare.byAirlines }} -->
                <div class="grid grid-cols-12">
                    <div class="col-span-12 bg-white rounded-md my-2 md:my-2 group duration-700" v-for="(cheapestFareFlight ,cheapestFareFlightIndex) in cheapestFareFlights" :key="cheapestFareFlightIndex">
                        <div class="grid grid-cols-12 border border-[#D9D9D9] hover:shadow-md rounded-md" v-for="(cheapestFareFlightDetails, cheapestFareFlightDetailsIndex) in cheapestFareFlight" :key="cheapestFareFlightDetailsIndex">
                            <div class="col-span-12 lg:col-span-9 flex flex-col justify-center">
                                <div class="grid grid-cols-12 relative my-3 mx-4 xs:ml-6 sm:ml-8">
                                    <div
                                        class="col-span-3 xs:col-span-3 sm:col-span-4 flex items-center sm:items-start">
                                        <img class="xs:mr-1 w-7 h-6" :src="`/logos/${cheapestFareFlightDetails.flightAvailabilities.legs.leg1.marketingAirlines.split(',')[0].substring(0, 2)}.png`" />
                                        <div class="flex flex-col">
                                            <span
                                                class="hidden xs:block text-sm xl:text-base font-bold text-gray-700">{{cheapestFareFlightDetails.flightAvailabilities.legs.leg1.marketingAirlines.split(',')[0]}}</span>
                                            <span
                                                class="hidden sm:block text-xs xl:text-[13px] text-gray-500 capitalize">Marketed By {{cheapestFareFlightDetails.flightAvailabilities.price.airlineName}}</span>
                                            <span
                                                class="hidden sm:block text-xs xl:text-[13px] text-gray-500 capitalize">{{cheapestFareFlightDetails.flightAvailabilities.legs.leg1.segments[0].cabin}}</span>
                                        </div>
                                    </div>
                                    <div class="col-span-3 sm:col-span-2 flex justify-center items-center text-center">
                                        <div class="flex flex-col text-center">
                                            <span
                                                class="text-[1.1rem] md:text-xl lg:text-xl xl:text-2xl font-medium m-0 leading-[1.2] uppercase">{{ cheapestFareFlightDetails.flightAvailabilities.legs.leg1.departureAirport }}</span>
                                            <span class="text-xs lg:text[13px] font-medium text-gray-400">{{ setInitialDate(`${cheapestFareFlightDetails.flightAvailabilities.legs.leg1.departureDate} ${cheapestFareFlightDetails.flightAvailabilities.legs.leg1.departureTime}`,'h:mm a') }}</span>
                                            <span class="text-xs lg:text[13px] font-medium text-gray-400">{{ setInitialDate(cheapestFareFlightDetails.flightAvailabilities.legs.leg1.departureDate,'Do MMM YY') }}</span>
                                        </div>
                                    </div>
                                    <div
                                        class="col-span-3 flex flex-col items-center justify-center text-center relative">
                                        <p class="text-xs lg:text[13px] xl:text-sm text-gray-500 lg:leading-4 lg:px-1">
                                            {{ cheapestFareFlightDetails.flightAvailabilities.legs.leg1.elapsedTime }}
                                        </p>
                                        <div class="border-b-2 border-dotted border-gray-300 w-full absolute">
                                        </div>
                                        <div class="w-full flex justify-center flex-col lg:block">
                                            <img src="/ticketing/plane.svg" alt="Return-icon"
                                                class="h-5 lg:mt-1 xl:mt-0 transform -translate-x-1 xl:-translate-x-3 lg:group-hover:translate-x-28 xl:group-hover:translate-x-[13rem] group-hover:transition group-hover:duration-1000 group-hover:ease-in-out transition duration-1000 ease-in-out" />
                                            <p class="text-xs lg:text-xs leading-4 text text-rGTBaseTextColor">
                                                {{ cheapestFareFlightDetails.flightAvailabilities.legs.leg1.pointAirports }}</p>
                                        </div>
                                    </div>
                                    <div class="col-span-3 sm:col-span-2 flex justify-center items-center text-center">
                                        <div class="flex flex-col text-center">
                                            <span
                                                class="text-[1.1rem] md:text-xl lg:text-xl xl:text-2xl font-medium m-0 leading-[1.2] uppercase">
                                                {{ cheapestFareFlightDetails.flightAvailabilities.legs.leg1.arrivalAirport }}
                                            </span>
                                            <span class="text-xs lg:text[13px] font-medium text-gray-400"> {{ setInitialDate(`${cheapestFareFlightDetails.flightAvailabilities.legs.leg1.arrivalDate} ${cheapestFareFlightDetails.flightAvailabilities.legs.leg1.arrivalTime}`,'h:mm a') }} </span>
                                            <span class="text-xs lg:text[13px] font-medium text-gray-400"> {{ setInitialDate(cheapestFareFlightDetails.flightAvailabilities.legs.leg1.arrivalDate,'Do MMM YY') }}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div
                                class="relative col-span-12 lg:my-2 lg:col-span-3 flex flex-col justify-center border-t-[1px] lg:border-t-0 border-dashed border-[#808080] lg:border-l-[1px] lg:border-dashed lg:border-[#808080] px-3 py-2 lg:py-0 bg-white">
                                <div class="grid grid-cols-12 justify-center items-center">
                                    <div class="col-span-7 xs:col-span-8 sm:col-span-9 lg:col-span-12">
                                        <div class="col-span-9 lg:col-span-12 flex lg:flex-col lg:mb-1">
                                            
                                            
                                            <div class="lg:text-end">
                                                <span class="text-black text-[30px] lg:text-4xl font-bold">
                                                    {{currency.currencySymbol}}{{setConverter(cheapestFareFlightDetails.flightAvailabilities.price.totalFare, currency.currencyRate)}}
                                                </span>
                                            </div>
                                            <div class="hidden lg:block mt-1 ml-2 lg:mt-0 lg:ml-0 lg:text-end">
                                                <span
                                                    class="text-[11px] sm:text-[12px] md:text-[13px] text-[#ADB5BD] rounded-md"
                                                    v-if="cheapestFareFlightDetails.flightAvailabilities.price.isRefundable=='false'">Non-Refundable</span>
                                                <span
                                                    class="text-[11px] sm:text-[12px] md:text-[13px] text-[#ADB5BD] rounded-md"
                                                    v-else="cheapestFareFlightDetails.flightAvailabilities.price.isRefundable =='true'">Refundable</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-span-5 xs:col-span-4 sm:col-span-3 lg:col-span-12 lg:ml-7 xl:ml-10">
                                        <button v-on:click="cheapestFareFlightOrderCreate(cheapestFareFlightDetails)"
                                            class="bg-bgRGTBaseColor flex justify-center p-[5px_0px_4px_0px] w-full text-center order-first text-sm xl:text-base items-center capitalize rounded text-white py-2 md:py-3 cursor-pointer duration-500 ease-in-out transition-all hover:duration-500 hover:ease-in-out hover:transition-all hover:bg-green-500">
                                            <span class="mr-1">Book Now</span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- current Airlines -->
                <h2 class="md:text-lg text-sm font-bold text-[#2E312F] my-4">
                    Popular Airlines Operate from {{ $page.props.dynamicFlightPages.packageTitle }}
                </h2>
                <div class="grid grid-cols-12 bg-white rounded-md py-4 border border-[#D9D9D9] gap-y-1 mt-2" v-if="cheapestFare.byAirlines != ''">
                    <div class="col-span-12 lg:col-span-3 flex flex-col justify-center" v-for="(airlineDetails, airlineIndex) in cheapestFare.byAirlines" :key="airlineIndex">
                        <div class="col-span-12 sm:col-span-6 md:col-span-3 px-2 flex items-center" v-for="(airline, airlineIndex) in airlineDetails" :key="airlineIndex">
                            <img class="xs:mr-1 w-7 h-6" :src="`/logos/`+ airline.flightAvailabilities.price.validatingCarrier + '.png'" />
                            <h3 class="font-semibold text-base hover:underline cursor-pointer text-rGTBaseTextColor pl-2">{{airline.airlineName}}</h3>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Popular Airlines And Routes -->
            <section class="px-2 md:px-4 mb-3 mx-auto w-[90%] sm:w-[78%] xl:w-[88%] 2xl:w-[70%] p-4 mt-2">
                <h2 class="md:text-lg text-sm font-bold text-[#2E312F]" v-if="$page.props.popularRoutes.length != 0">
                    Popular Routes From {{ $page.props.departCity }}
                </h2>
                <div class="grid grid-cols-12 xs:text-justify gap-x-3" v-if="$page.props.popularRoutes.length != 0">
                    <div class="col-span-12 sm:col-span-6 md:col-span-4 lg:col-span-3 " v-for="(Flight, FlightsKey) in $page.props.popularRoutes">
                        <a class="bg-white flex justify-center font-medium shadow-md capitalize text-sm sm:text-base border border-[#D9D9D9] text-[#0a549c] tracking-wide text-center py-3 rounded-[8px] items-center mt-4 hover:transition-all hover:ease-in-out hover:duration-500 hover:underline courser-pointer transition-all duration-500 ease-in-out hover:bg-bgRGTBaseColor hover:text-white"
                            :href="'/' + Flight.urlLink">
                            <span class="px-3 truncate">
                                {{ Flight.packageTitle }}
                            </span>
                        </a>
                    </div>
                </div>
                <h2 class="md:text-lg text-sm font-bold text-[#2E312F] mt-9" v-if="$page.props.popularArrRoutes.length != 0">
                    Popular Routes From {{ $page.props.arrCity }}
                </h2>
                <div class="grid grid-cols-12 xs:text-justify gap-x-3" v-if="$page.props.popularArrRoutes.length != 0">
                    <div class="col-span-12 sm:col-span-6 md:col-span-4 lg:col-span-3 " v-for="(Flights, FlightsKey) in $page.props.popularArrRoutes">
                        <a class="bg-white flex justify-center font-medium shadow-md capitalize text-sm sm:text-base border border-[#D9D9D9] text-[#0a549c] tracking-wide text-center py-3 rounded-[8px] items-center mt-4 hover:transition-all hover:ease-in-out hover:duration-500 hover:underline courser-pointer transition-all duration-500 ease-in-out hover:bg-bgRGTBaseColor hover:text-white"
                            :href="'/' + Flights.urlLink">
                            <span class="px-3 truncate">
                                {{ Flights.packageTitle }}
                            </span>
                        </a>
                    </div>
                </div>
            </section>
            <!-- Description -->
            <section class="px-2 md:px-4 mx-auto w-[90%] sm:w-[78%] xl:w-[88%] 2xl:w-[70%]">
                <div class="bg-white border border-[#D9D9D9] rounded-lg xs:text-justify p-4">
                    <p class="text-justify text-gray-500 rounded-md ck-Detail"
                        v-html="$page.props.dynamicFlightPages.description">
                    </p>
                </div>
            </section>

            <!-- Popular Airlines And Routes -->
            <section class="px-2 md:px-4 mb-3 mx-auto w-[90%] sm:w-[78%] xl:w-[88%] 2xl:w-[70%] p-4 mt-2">
                <p class="md:text-lg text-sm font-bold text-[#2E312F]">
                    Popular Airlines on Rehmantravel.com
                </p>
                <div class="grid grid-cols-12 xs:text-justify gap-x-3">
                    <div class="col-span-12 sm:col-span-6 md:col-span-4 lg:col-span-3"
                    v-for="(Airlines, AirlinesKey) in $page.props.airline.Airlines">
                        <a :href="'/' + Airlines.urlLink" class="bg-white hover:underline courser-pointer flex justify-center font-medium shadow-[0_2px_4px_0_rgb(0_0_0_/_10%)] hover:text-white capitalize text-sm sm:text-base border border-[#D9D9D9] text-[#0a549c] tracking-wide text-center py-3 rounded-[8px] items-center mt-4 hover:transition-all hover:ease-in-out hover:duration-500 transition-all duration-500 ease-in-out hover:bg-bgRGTBaseColor hover:text-whie">
                            <span class="px-3 truncate" v-if="Airlines.parentId === 13">
                                {{ Airlines.packageTitle }}
                            </span>
                        </a>
                    </div>
                </div>
            </section>
            <!-- Contact Form -->
            <div class="md:px-4 mx-auto w-[90%] sm:w-[78%] xl:w-[88%] 2xl:w-[70%] mb-5">
                <div class="bg-white rounded-lg xs:text-justify">
                    <div class="my-3 w-full">
                        <h3
                            class="text-xl uppercase rounded-t-lg bg-bgRGTBaseColor text-white p-[0rem_0.7rem] mb-3 font-medium leading-[2.875rem] md:text-start text-center">
                            request a callback</h3>
                    </div>
                    <form class="w-full px-4 py-2" @submit.prevent="submit">
                        <div class="grid grid-cols-12 gap-2">
                            <div class="col-span-12 md:col-span-4">
                                <input
                                    class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    type="text" v-model="form.customers.firstName" placeholder="Your Name">
                            </div>
                            <div class="col-span-12 md:col-span-4">
                                <input
                                    class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    type="number" v-model="form.customers.mobileNo" placeholder="Phone No">
                            </div>
                            <div class="col-span-12 md:col-span-4">
                                <input
                                    class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    type="email" v-model="form.customers.email" placeholder="Email">
                            </div>
                        </div>
                        <div class="grid grid-cols-12 gap-3">
                            <div class="col-span-12 md:col-span-8">
                                <textarea cols="40" v-model="form.contents.message"
                                    class="appearance-none block w-full border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 focus:outline-none focus:bg-white focus:border-blue-500"> Message</textarea>
                            </div>
                            <div class="col-span-12 md:col-span-2 md:mb-0 mb-4">
                                <input type="submit" @click="submitDetails()"
                                    class=" w-full p-2 text-xl bg-blue-100 text-blue-800 border border-solid border-blue-500 text-center rounded hover:bg-bgRGTBaseColor hover:text-white hover:transition-all hover:ease-in-out hover:duration-700 transition-all duration-700 ease-in-out">
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </GuestLayout>
</template>

<script>
import _ from 'lodash'
import { mapState } from "vuex";
import CurrencyConverter from "@/Config/CurrencyConverter.js";
import Service from "@/Config/Service.js";
import moment from "moment";
export default {
    name: 'DynamicFareFlight',
    components: {
        SearchFlight
    },
    data() {
        return {
            selectedCurrencyFromParent: { type: Object },
            selectedCurrencyFromChild: { type: Object },
            departCode: '',
            arrCode: '',
            providers: [],
            payload: { type: Object },
            flightType: 'one-way',
            form: {
                customers: {
                    firstName: "",
                    mobileNo: "",
                    email: "",
                },
                contents: {
                    message: "",
                    moduleId: 3,
                    leadFrom: "flights"
                }
            },
            cheapestFare: {
                cheapflight: '',
                isCsrfToken: {type: String},
                loading: false,
                isOrderType: "asc",
                isErrorFounds: [],
                isRecordFounds: [],
                isNoRecordFounds: [],
                responseError: "",
                isActive: false,
                isFilterSearch: "none",
                flightAvailabilities: [],
                byStops: {type: Object},
                byVendors: {type: Object},
                byAirlines: {type: Object},
                byArrivalAirports: {type: Object},
                isStopPoint: [],
                isVendor: [],
                isAirline: [],
                isArrivalAirport: [],
            },
            cheapestFlightFareRule: {
                loading: false,
                modalPopup:false,
                isRecordFounds: [],
                isNoRecordFounds: [],
                isWaitingResponse: '',
                isErrorFounds: [],
                responseError: ""
            },
        }
    },
    created() {
        this.providers = this.$page.props.providers.split(",");
    },
    mounted(){
        this.payload = {
            "departureCode": this.$page.props.dynamicFlightPages.departCode,
            "arrivalCode": this.$page.props.dynamicFlightPages.arrCode,
            "outboundDate": moment(new Date(), "DD-MM-YYYY").add(10, 'day').format("DD-MM-YYYY"),
            "inboundDate": "",
            "cabin": "Y",
            "currencyCode": "USD",
            "adultsCount": 1,
            "childrenCount": 0,
            "infantsCount": 0,
            "tripType": "one-way",
            "locale": "ar"
        }
        this.airShopping();
    },
    computed: {
        ...mapState(['currency']),
        cheapestFareFlights: function () {
            if (this.cheapestFare.isRecordFounds.length !== 0) {
                let availabilities = [];
                let cheapestFareFlightInfos = [];
                for (const [flightAvailabilityKey, flightAvailabilities] of Object.entries(this.cheapestFare.flightAvailabilities)) {
                    for (const [availabilityKey, flightAvailability] of Object.entries(flightAvailabilities)) {
                        if(flightAvailability.price !== undefined){
                            if (
                                (this.cheapestFare.isStopPoint.length === 0 || this.cheapestFare.isStopPoint.includes(flightAvailability.stopPoints)) &&
                                (this.cheapestFare.isVendor.length === 0 || this.cheapestFare.isVendor.includes(flightAvailability.price.airType)) &&
                                (this.cheapestFare.isAirline.length === 0 || this.cheapestFare.isAirline.includes(flightAvailability.price.airType + ' ' + flightAvailability.price.airlineName + ' ' + flightAvailability.price.validatingCarrier)) &&
                                (this.cheapestFare.isArrivalAirport.length === 0 || this.cheapestFare.isArrivalAirport.includes(flightAvailability.price.airType + ' ' + flightAvailability.price.validatingCarrier + ' ' + flightAvailability.legs.leg1.pointAirports))
                            ) {
                                availabilities.push({
                                    'totalFare': eval(flightAvailability.price.totalFare),
                                    'flightAvailabilities': JSON.parse(JSON.stringify(flightAvailability)),
                                    'byAirlines': this.cheapestFare.byAirlines
                                });
                            }
                            cheapestFareFlightInfos.push({
                                airType: flightAvailability.price.airType,
                                airlineName: flightAvailability.price.airlineName,
                                validatingCarrier: flightAvailability.price.validatingCarrier,
                                pointAirport: flightAvailability.legs.leg1.pointAirports,
                                airlineImage: flightAvailability.legs.leg1.marketingAirlines.split(',')[0].substring(0, 2)+".png",
                                stopPoint: flightAvailability.stopPoints,
                                flightAvailability: flightAvailability,
                                totalFare: eval(flightAvailability.price.totalFare)
                            })
                            this.cheapestFare.byAirlines = _.orderBy(cheapestFareFlightInfos, "totalFare", this.cheapestFare.isOrderType).filter((value, index, self) => {
                                return self.findIndex((v) => v.airType === value.airType && v.airlineName === value.airlineName) === index
                            }).reduce(function (obj, cheapestFareFlightInfo) {
                                obj[cheapestFareFlightInfo.airlineName + ' ' + cheapestFareFlightInfo.airType] = obj[cheapestFareFlightInfo.airlineName] || [];
                                obj[cheapestFareFlightInfo.airlineName + ' ' + cheapestFareFlightInfo.airType].push({
                                    "airType": cheapestFareFlightInfo.airType,
                                    "airlineName": cheapestFareFlightInfo.airlineName,
                                    "flightAvailabilities": cheapestFareFlightInfo.flightAvailability,
                                    "validatingCarrier": cheapestFareFlightInfo.validatingCarrier,
                                    "airlineImage": cheapestFareFlightInfo.airlineImage,
                                    "totalFare": cheapestFareFlightInfo.totalFare
                                });
                                return obj;
                            }, {});
                        }    
                    }
                }
                return this.cheapestFare.byAirlines;
            } else {
                if(this.cheapestFare.isNoRecordFounds.length === this.providers && this.cheapestFare.isNoRecordFounds.includes("notfound") === false){
                    this.cheapestFare.responseError = "No Flight Found In Your Selected Date, Please Modify Search";
                }
                return [];
            }
        }
    },
    methods: {
        cheapestFareFlightOrderCreate(cheapestFareFlight){
            // console.log(this.cheapestFareFlightOrderCreateParams());
            localStorage.setItem("cheapestFareFlight", JSON.stringify(cheapestFareFlight));
            localStorage.setItem("currencyCode", this.currencyCode);
            localStorage.setItem("currencyRate", this.currencyRate);
            localStorage.setItem("currencySymbol", this.currencySymbol);
            window.location.href = "/ticketing/cheapest-fare-flight-order-create" + this.cheapestFareFlightOrderCreateParams();
        },
        cheapestFareFlightOrderCreateParams(){
            return "?ft="+this.payload.tripType+"&ol="+this.payload.departureCode+"&dl="+this.payload.arrivalCode+"&obd="+this.payload.outboundDate+"&ibd=&ac=1&cc=0&ic=0&cbn=Y&cr="+this.currency.currencyRate+"&ct="+this.currency.currencyCode+"&pn=&st=b2c&dt="+ (screen.width <= 699 ? "M" : "W");
        },
        start() {
            this.cheapestFare.loading = true;
        },
        submitDetails() {
            if (this.form.customers.mobileNo == "") {
                this.$toast.error("Please Enter  mobile No.");
                return false;
            } else {
                this.$inertia.post('/addContactDetails', this.form, {
                    onSuccess: (response) => {
                        window.location.href = '/Website/thankYou';
                    }
                });
            }
        },
        byOrderType(orderType) {
            this.cheapestFare.isOrderType = orderType;
        },
        setInitialDate(initialDate, formatType) {
            return moment(initialDate).format(formatType)
        },
        byOrderType(orderType) {
            this.cheapestFare.isOrderType = orderType;
        },
        setConverter(amount, currencyRate) {
            return CurrencyConverter.doRequest(amount, currencyRate)
        },
        selectedCurrencyFromChildToParent(currency) {
            this.selectedCurrencyFromChild = currency;
        },

        airShopping: function () {
            this.$store.dispatch("cheapestFlightSearch", this.payload)
            this.$store.dispatch("flightType", this.flightType)
            this.providers.forEach((actionType) => {
                Service.doFetchRequest("/ticketing/cheapest-fare-airshopping-request", actionType, this.payload)
                    .then((response) => {
                        if (response.length !== 0 && response.input !== undefined && response.error !== undefined) {
                            this.cheapestFare.responseError = response.error;
                        }else if (response.length !== 0 && response.error === undefined) {
                            this.cheapestFare.responseError = '';
                            this.cheapestFare.flightAvailabilities.push(response);
                            this.cheapestFare.isRecordFounds.push({'found': true});
                        } else {
                            this.cheapestFare.isErrorFounds.push({'error': true});
                            this.cheapestFare.isNoRecordFounds.push({'found': false});
                            if (this.cheapestFare.isErrorFounds.length === this.providers.length) {
                                if (response.error !== undefined && response.error.code === 401 && this.cheapestFare.isErrorFounds.length === this.providers.length) {
                                    this.cheapestFare.responseError = response.error.message;
                                    this.openModal();
                                } else {
                                    this.cheapestFare.responseError = "No Flight Found In Your Selected Date, Please Modify Search";
                                }
                            }
                        }
                    });
            });
        },
    }
}
</script>