<template>
    <section id="toggle-modifyModalPopup">
        <form @submit.prevent="">
            <div class="flex flex-wrap">
                <div class="flex md:border-r-2 border-[#0181DD]">
                    <div v-on:click="flightTabNav('round-trip')"
                        :class="'text-[12px] xxs:text-[14px] focus:outline-none py-1 px-2 border rounded-full ' + (flightType === 'round-trip' ? 'bg-[#006ee31c] text-rGTBaseTextColor border-rGTBorderColor' : '')">
                        <input v-model="flightType" class="hidden" value='round-trip' type="radio" name="flexRadioDefault"
                            id="round-trip">
                        <label for="round-trip">Round Trip</label>
                    </div>
                    <div v-on:click="flightTabNav('one-way')"
                        :class="'text-[12px] xxs:text-[14px] focus:outline-none py-1 px-2 border rounded-full mx-2 ' + (flightType === 'one-way' ? 'bg-[#006ee31c] text-rGTBaseTextColor border-rGTBorderColor' : '')">
                        <input v-model="flightType" class="hidden" value='one-way' type="radio" name="flexRadioDefault"
                            id="one-way">
                        <label for="one-way">One Way</label>
                    </div>
                    <div v-on:click="flightTabNav('multi-trip')"
                        :class="'text-[12px] xxs:text-[14px] focus:outline-none py-1 px-2 md:mr-2 border rounded-full ' + (flightType === 'multi-trip' ? 'bg-[#006ee31c] text-rGTBaseTextColor border-rGTBorderColor' : '')">
                        <input v-model="flightType" class="hidden" value='multi-trip' type="radio" name="flexRadioDefault"
                            id="multi-city">
                        <label for="multi-city">Multi-City</label>
                    </div>
                </div>
                <div class="md:pl-2 flex flex-wrap items-center xxs:mx-1">
                    <div class="hidden px-1 mr-1 border rounded-full md:flex items-center">
                        <svg fill="#0181dd" height="16px" width="16px" version="1.1" id="Capa_1"
                            xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                            viewBox="0 0 240.235 240.235" xml:space="preserve" class="mr-1 hidden md:block">
                            <g id="SVGRepo_bgCarrier" stroke-width="0" />
                            <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round" />
                            <g id="SVGRepo_iconCarrier">
                                <path
                                    d="M211.744,6.089C208.081,2.163,203.03,0,197.52,0h-15.143c-11.16,0-21.811,8.942-23.74,19.934l-0.955,5.436 c-0.96,5.47,0.332,10.651,3.639,14.589c3.307,3.938,8.186,6.106,13.74,6.106h19.561c2.714,0,5.339-0.542,7.778-1.504l-2.079,17.761 c-2.001-0.841-4.198-1.289-6.507-1.289h-22.318c-9.561,0-18.952,7.609-20.936,16.961l-19.732,93.027l-93.099-6.69 c-5.031-0.36-9.231,1.345-11.835,4.693c-2.439,3.136-3.152,7.343-2.009,11.847l10.824,42.618 c2.345,9.233,12.004,16.746,21.53,16.746h78.049h1.191h39.729c9.653,0,18.336-7.811,19.354-17.411l15.272-143.981 c0.087-0.823,0.097-1.634,0.069-2.437l5.227-44.648c0.738-1.923,1.207-3.967,1.354-6.087l0.346-4.97 C217.214,15.205,215.407,10.016,211.744,6.089z" />
                            </g>
                        </svg>
                        <SelectClass @selectedCabin="selectedCabin" class="rounded-full"></SelectClass>
                    </div>
                    <SelectCurrency class="border rounded-full mr-1 ml-1 px-2 focus:outline-none py-1 sm:py-0"></SelectCurrency>
                    <div class="hidden px-1 mr-1 border rounded-full md:flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" height="18px" width="24px" fill="#0181dd"
                            viewBox="0 0 576 512" class="hidden md:block">
                            <path
                                d="M432 96a48 48 0 1 0 0-96 48 48 0 1 0 0 96zM347.7 200.5c1-.4 1.9-.8 2.9-1.2l-16.9 63.5c-5.6 21.1-.1 43.6 14.7 59.7l70.7 77.1 22 88.1c4.3 17.1 21.7 27.6 38.8 23.3s27.6-21.7 23.3-38.8l-23-92.1c-1.9-7.8-5.8-14.9-11.2-20.8l-49.5-54 19.3-65.5 9.6 23c4.4 10.6 12.5 19.3 22.8 24.5l26.7 13.3c15.8 7.9 35 1.5 42.9-14.3s1.5-35-14.3-42.9L505 232.7l-15.3-36.8C472.5 154.8 432.3 128 387.7 128c-22.8 0-45.3 4.8-66.1 14l-8 3.5c-32.9 14.6-58.1 42.4-69.4 76.5l-2.6 7.8c-5.6 16.8 3.5 34.9 20.2 40.5s34.9-3.5 40.5-20.2l2.6-7.8c5.7-17.1 18.3-30.9 34.7-38.2l8-3.5zm-30 135.1l-25 62.4-59.4 59.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L340.3 441c4.6-4.6 8.2-10.1 10.6-16.1l14.5-36.2-40.7-44.4c-2.5-2.7-4.8-5.6-7-8.6zM256 274.1c-7.7-4.4-17.4-1.8-21.9 5.9l-32 55.4L147.7 304c-15.3-8.8-34.9-3.6-43.7 11.7L40 426.6c-8.8 15.3-3.6 34.9 11.7 43.7l55.4 32c15.3 8.8 34.9 3.6 43.7-11.7l64-110.9c1.5-2.6 2.6-5.2 3.3-8L261.9 296c4.4-7.7 1.8-17.4-5.9-21.9z" />
                        </svg>
                        <SelectTravellers @selectedTravelers="selectedTravelers"
                            class=" py-1 px-1 md:block hidden rounded-full"></SelectTravellers>
                    </div>
                </div>
            </div> 

            <div v-for="(inoutboundAirportDateDetail, initialIndex) in cheapestFlightSearchInputs" :key="initialIndex"
                class="flex flex-wrap gap-1 mt-5">
                <span v-if="flightType === 'multi-trip'"
                    class="flex w-full lg:w-auto font-semibold mb-1 md:items-center md:justify-start">Flight
                    {{ initialIndex + 1 }}</span>

                <div :class="`${flightType === 'round-trip' ? '2xl:w-[26%] xl:w-[26%]' : flightType !== 'multi-trip' ? '2xl:w-[31%] xl:w-[31%]' : '2xl:w-[29%] xl:w-[29%]'}  ${flightType !== 'multi-trip' ? 'lg:w-[49%] md:w-[49%]' : 'lg:w-[38%] md:w-[38%]'} ${errors.departureAirport != '' ? 'border-red-500 border-2' : 'border-gray-300'}`" class=" w-full relative  h-[3.6rem] rounded-md flex border hover:border-gray-400  leading-tight focus:outline-none focus:bg-white focus:border-blue-500 ">
                    <Autocomplete v-model="inoutboundAirportDateDetail.outboundAirport" @keyup="checkError('departureAirport')"
                        @update:autocompleteValue="outinboundAirportDetail" :initialIndex="initialIndex"
                        :initialType="'outbound'"></Autocomplete>
                        <small class="text-red-500 align-middle justify-center" v-if="errors.departureAirport != '' && inoutboundAirportDateDetail.outboundAirport == ''">(Required)</small>
                    <button @click="swap(initialIndex, inoutboundAirportDateDetail)" aria-label="swap button" class="absolute z-10 p-1 md:p-[3px] z-1 bg-white border border-gray-400 rotate-90 top-[2.6rem] right-2 md:rotate-0 md:top-[10px] md:-right-5 rounded-full">
                        <svg id="swap-arrow" height="30px" width="30px" fill="#0181dd" viewBox="0 0 24 24">
                            <path d="M6.99 11L3 15l3.99 4v-3H14v-2H6.99v-3zM21 9l-3.99-4v3H10v2h7.01v3L21 9z"></path>
                        </svg>
                    </button>
                </div>
                <div :class="`${flightType === 'round-trip' ? '2xl:w-[26%] xl:w-[26%]' : flightType !== 'multi-trip' ? '2xl:w-[31%] xl:w-[31%]' : '2xl:w-[29%] xl:w-[29%]'} ${flightType !== 'multi-trip' ? 'lg:w-[49%] md:w-[49%]' : 'lg:w-[38%] md:w-[38%]'} ${errors.arrivalAirport != '' ? 'border-red-500 border-2' : 'border-gray-300'}`" class="w-full  h-[3.6rem] rounded-md border flex hover:border-gray-400 leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                    <Autocomplete v-model="inoutboundAirportDateDetail.inboundAirport" @keyup="checkError('arrivalAirport')"
                        @update:autocompleteValue="outinboundAirportDetail" :initialIndex="initialIndex"
                        :initialType="'inbound'"></Autocomplete>
                        <small class="text-red-500 align-middle justify-center" v-if="errors.arrivalAirport != '' && inoutboundAirportDateDetail.inboundAirport == ''">(Required)</small>
                </div>
                    <!-- Multiple and One Way Calender -->

                <div v-if="flightType === 'one-way' || flightType === 'multi-trip'" :class="`${flightType !== 'multi-trip' ? 'lg:w-[24.4%] md:w-[22%]' : 'lg:w-[15%] md:w-[22%]'} ${(errors.departureDate != '' && inoutboundAirportDateDetail.outboundDate == '') ? 'border-red-500 border-2' : 'border-gray-300'}`" class="w-full  xl:w-[11%] 2xl:w-[11%] h-[3.6rem] rounded-md flex border hover:border-gray-400  leading-tight focus:outline-none focus:bg-white focus:border-blue-500 my-2 md:my-0 md:mt-0 items-center pt-2 px-1 py-[0.32rem] bg-white   mr-1 md:mr-0">
                    <OutinboundDate v-model="inoutboundAirportDateDetail.outboundDate" @change="checkError('departureDate')"
                        @update:outinboundDateDetail="outinboundDateDetail" :flightType="flightType"
                        :initialInput="'outboundDate-' + initialIndex" :initialLastIndex="inoutboundAirportDateDetails.length"
                        :initialIndex="initialIndex"></OutinboundDate>
                        <small class="text-red-500 text-[10px]" v-if="errors.departureDate != '' && inoutboundAirportDateDetail.outboundDate == ''"> (Required)</small>
                </div>

                <div v-if="flightType === 'round-trip'" class="w-full  md:w-[49%] xl:w-[22.5%] 2xl:w-[22%] h-[3.6rem] rounded-md block  leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                    <div class="flex">
                        <div :class="`${(errors.departureDate != '' && inoutboundAirportDateDetail.outboundDate == '') ? 'border-red-500 border-2' : 'border-gray-300'} w-1/2 my-2 md:my-0 md:mt-0 flex items-center h-14 border hover:border-gray-400 px-1 py-[0.32rem] bg-white  rounded-md mr-1 md:mr-0`">
                            <OutinboundDate v-model="inoutboundAirportDateDetail.outboundDate" @change="checkError('departureDate')"
                                @update:outinboundDateDetail="outinboundDateDetail" :flightType="flightType"
                                :initialInput="'outboundDate'" :initialLastIndex="inoutboundAirportDateDetails.length"
                                :initialIndex="initialIndex"></OutinboundDate>
                                <small class="text-red-500 text-[10px]" v-if="errors.departureDate != '' && inoutboundAirportDateDetail.outboundDate == ''"> (Required)</small>
                        </div>
                        <div
                            :class="`${(errors.arrivalDate  != '' && inoutboundAirportDateDetail.inboundDate  == '') ? 'border-red-500 border-2' : 'border-gray-300'} w-1/2 my-2 md:my-0 md:mt-0 lg:ml-2 flex items-center border h-14 hover:border-gray-400 px-1 py-[0.32rem] mx-0 md:ml-2 bg-white  rounded-md`">
                            <OutinboundDate v-model="inoutboundAirportDateDetail.inboundDate" @change="checkError('arrivalDate')"
                                @update:outinboundDateDetail="outinboundDateDetail" :flightType="flightType"
                                :initialInput="'inboundDate'" :initialLastIndex="inoutboundAirportDateDetails.length"
                                :initialIndex="initialIndex"></OutinboundDate>
                                <small class="text-red-500 text-[10px]" v-if="errors.arrivalDate != '' && inoutboundAirportDateDetail.inboundDate == ''"> (Required)</small>
                        </div>
                    </div>
                </div>
                <div v-if="flightType === 'multi-trip' && initialIndex === inoutboundAirportDateDetails.length - 1" class="w-full xl:w-[20%] flex justify-end xl:justify-start xl:mr-0 mr-3">
                    <button
                        v-if="inoutboundAirportDateDetails.length > 2 && initialIndex === inoutboundAirportDateDetails.length - 1 && flightType === 'multi-trip'"
                        v-on:click="removeLastEntry(initialIndex)"
                        class="text-red-600 md:col-span-2 xl:col-span-1 text-[14px] md:text-[15px] mx-2 md:mt-2">
                        <i class="fa-solid fa-circle-minus mr-1"></i> <span>Remove</span>
                    </button>
                    <button
                        v-if="inoutboundAirportDateDetails.length > 0 && inoutboundAirportDateDetails.length <= 4 && initialIndex === inoutboundAirportDateDetails.length - 1 && flightType === 'multi-trip'"
                        v-on:click="addNewEntry(initialIndex)"
                        class="text-rGTBaseTextColor md:col-span-1 justify-start text-[14px] md:text-[15px] ml-2 md:mt-2">
                        <i class="fa-solid fa-circle-plus mr-1"></i>
                        <span>Add</span>
                    </button>
                </div>
                <div v-if="(flightType === 'round-trip' || flightType === 'one-way') || (flightType === 'multi-trip' && !isXlScreen) && initialIndex === inoutboundAirportDateDetails.length - 1"
                    :class="`flex items-center px-3 h-[3.5rem] py-1 mb-2 md:hidden border border-gray-300 hover:border-gray-400 bg-white rounded-md w-full ${flightType === 'one-way' ? 'mt-0' : 'mt-[1rem]'}`">
                    <svg xmlns="http://www.w3.org/2000/svg" height="18px" width="24px" fill="#0181dd"
                        viewBox="0 0 576 512" class="block">
                        <path
                            d="M432 96a48 48 0 1 0 0-96 48 48 0 1 0 0 96zM347.7 200.5c1-.4 1.9-.8 2.9-1.2l-16.9 63.5c-5.6 21.1-.1 43.6 14.7 59.7l70.7 77.1 22 88.1c4.3 17.1 21.7 27.6 38.8 23.3s27.6-21.7 23.3-38.8l-23-92.1c-1.9-7.8-5.8-14.9-11.2-20.8l-49.5-54 19.3-65.5 9.6 23c4.4 10.6 12.5 19.3 22.8 24.5l26.7 13.3c15.8 7.9 35 1.5 42.9-14.3s1.5-35-14.3-42.9L505 232.7l-15.3-36.8C472.5 154.8 432.3 128 387.7 128c-22.8 0-45.3 4.8-66.1 14l-8 3.5c-32.9 14.6-58.1 42.4-69.4 76.5l-2.6 7.8c-5.6 16.8 3.5 34.9 20.2 40.5s34.9-3.5 40.5-20.2l2.6-7.8c5.7-17.1 18.3-30.9 34.7-38.2l8-3.5zm-30 135.1l-25 62.4-59.4 59.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L340.3 441c4.6-4.6 8.2-10.1 10.6-16.1l14.5-36.2-40.7-44.4c-2.5-2.7-4.8-5.6-7-8.6zM256 274.1c-7.7-4.4-17.4-1.8-21.9 5.9l-32 55.4L147.7 304c-15.3-8.8-34.9-3.6-43.7 11.7L40 426.6c-8.8 15.3-3.6 34.9 11.7 43.7l55.4 32c15.3 8.8 34.9 3.6 43.7-11.7l64-110.9c1.5-2.6 2.6-5.2 3.3-8L261.9 296c4.4-7.7 1.8-17.4-5.9-21.9z" />
                    </svg>
                    <SelectTravellers class="md:ml-2 h-[2.48rem] ml-2" @selectedTravelers="selectedTravelers"></SelectTravellers> / 
                    <svg fill="#0181dd" height="16px" width="16px" version="1.1" id="Capa_1"
                        xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                        viewBox="0 0 240.235 240.235" xml:space="preserve" class="ml-4 block">
                        <g id="SVGRepo_bgCarrier" stroke-width="0" />
                        <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round" />
                        <g id="SVGRepo_iconCarrier">
                            <path
                                d="M211.744,6.089C208.081,2.163,203.03,0,197.52,0h-15.143c-11.16,0-21.811,8.942-23.74,19.934l-0.955,5.436 c-0.96,5.47,0.332,10.651,3.639,14.589c3.307,3.938,8.186,6.106,13.74,6.106h19.561c2.714,0,5.339-0.542,7.778-1.504l-2.079,17.761 c-2.001-0.841-4.198-1.289-6.507-1.289h-22.318c-9.561,0-18.952,7.609-20.936,16.961l-19.732,93.027l-93.099-6.69 c-5.031-0.36-9.231,1.345-11.835,4.693c-2.439,3.136-3.152,7.343-2.009,11.847l10.824,42.618 c2.345,9.233,12.004,16.746,21.53,16.746h78.049h1.191h39.729c9.653,0,18.336-7.811,19.354-17.411l15.272-143.981 c0.087-0.823,0.097-1.634,0.069-2.437l5.227-44.648c0.738-1.923,1.207-3.967,1.354-6.087l0.346-4.97 C217.214,15.205,215.407,10.016,211.744,6.089z" />
                        </g>
                    </svg>
                    <SelectClass class="md:ml-2 h-[2.48rem] ml-2"></SelectClass>
                </div>
                <div v-if="(flightType === 'round-trip' || flightType === 'one-way') || (flightType === 'multi-trip' && isXlScreen) && initialIndex === 0" class="w-full md:w-[29%] lg:w-[24%] xl:w-[14%]">
                    <PhoneNumber @keyup="checkError('phoneNumber')" :checkNum="errors.phoneNumber" :phoneNumberValue="phoneNumber" @selectedPhoneNumber="selectedPhoneNumber"></PhoneNumber>
                    <span v-if='errors.phoneErrMsg != ""'><small class="text-red-600 font-semibold">Phone Number is invalid</small></span>
                </div>
                <div v-if="(flightType === 'round-trip' || flightType === 'one-way') || (flightType === 'multi-trip' && isXlScreen) && initialIndex === 0" class="w-full md:w-[19.5%] lg:w-[24%] xl:w-[10%]">
                    <button v-on:click="searchFlight()"
                        class="bg-rGTBaseTextColor text-white sm:text-xl font-semibold py-[0.83rem] rounded-md w-full focus:bg-green-500">
                        <i class="fa fa-search"></i>  Search
                    </button>
                </div>
            </div>
            <div class="grid grid-cols-12 gap-2">
                <div v-if="flightType === 'multi-trip' && !isXlScreen" class="col-span-8 md:col-span-6">
                    <PhoneNumber class="mt-2 xl:mt-0 h-[3.42rem] w-full" @keyup="checkError('phoneNumber')" :phoneNumberValue="phoneNumber" :checkNum="errors.phoneNumber" @selectedPhoneNumber="selectedPhoneNumber"></PhoneNumber>
                    <span v-if='errors.phoneErrMsg != ""'><small class="text-red-600 font-semibold">Phone Number is invalid</small></span>
                </div>
                <div v-if="flightType === 'multi-trip' && !isXlScreen" class="col-span-4 flex justify-center">
                    <button v-on:click="searchFlight()"
                        class="bg-rGTBaseTextColor text-white sm:text-xl mt-2 w-full font-semibold rounded-md focus:bg-green-500">
                        <i class="fa fa-search mr-2"></i>Search
                    </button>
                </div>
            </div>
        </form>
    </section>
</template>
<script>
import SelectClass from '@/Layout/Website/SelectClass.vue';
import SelectTravellers from '@/Layout/Website/SelectTravellers.vue';
import PhoneNumber from '@/Layout/Website/PhoneNumber.vue';
import SelectCurrency from "@/Layout/Website/SelectCurrency.vue";
import Autocomplete from "@/Pages/Website/Ticketing/Autocomplete.vue"
import OutinboundDate from "@/Pages/Website/Ticketing/OutinboundDate.vue"
import moment from 'moment';
import { mapState } from "vuex";

export default {
    props: {
        btnSearch: String,
    },
    components: {
        Autocomplete,
        OutinboundDate,
        SelectClass,
        SelectCurrency,
        SelectTravellers,
        PhoneNumber
    },
    computed: {
        ...mapState(['currency', 'cheapestFlightSearch', 'tripType']),
        cheapestFlightSearchInputs() {
            for (const [inoutboundAirportDateDetailKey, inoutboundAirportDateDetail] of Object.entries(this.cheapestFlightSearch)) {
                if (this.flightType === "multi-trip") {
                    this.inoutboundAirportDateDetails[inoutboundAirportDateDetailKey] = {
                        outboundAirportType: "",
                        outboundAirport: "",
                        outboundAirportCode: "",
                        inboundAirportType: "",
                        inboundAirport: "",
                        inboundAirportCode: "",
                        outboundDate: "",
                        inboundDate: ""
                    }
                    this.setCheapestFlightSearchInputs(inoutboundAirportDateDetailKey, inoutboundAirportDateDetail)
                } else if (this.flightType !== "multi-trip" && inoutboundAirportDateDetailKey == 0) {
                    this.setCheapestFlightSearchInputs(inoutboundAirportDateDetailKey, inoutboundAirportDateDetail)
                }
            }
            return this.inoutboundAirportDateDetails;
        },
    },
    data() {
        return {
            unValidateNumbers : ["34567", "45678", "54321", "56789", "00000", "11111", "22222", "33333", "44444", "55555", "66666", "77777", "88888"],
            isXlScreen: false,
            toggleCurrency: false,
            stateCurrencyCode: "",
            currencyCode: "",
            currencySymbol: "",
            currencyFlag: "",
            currencyType: "",
            currentCurrencyRate: 0,
            phoneNumber: (this.$store.state.phoneNumber !== "" ? this.$store.state.phoneNumber : ""),
            flightType: (this.$store.state.flightType !== "" ? this.$store.state.flightType : "round-trip"),
            cabin: (this.$store.state.flightCabin !== "" ? this.$store.state.flightCabin.cabin : "Y"),
            cabinName: (this.$store.state.flightCabin !== "" ? this.$store.state.flightCabin.name : "Economy"),
            adultsCount: (this.$store.state.flightTravelers !== "" ? this.$store.state.flightTravelers.adultsCount : 1),
            childrenCount: (this.$store.state.flightTravelers !== "" ? this.$store.state.flightTravelers.childrenCount : 0),
            infantsCount: (this.$store.state.flightTravelers !== "" ? this.$store.state.flightTravelers.infantsCount : 0),
            params: {
                outboundAirportCode: [],
                outboundAirportType: "",
                inboundAirportCode: [],
                inboundAirportType: "",
                outboundDate: [],
                inboundDate: []
            },
            inoutboundAirportDateDetails: [{
                outboundAirportType: "",
                outboundAirport: "",
                outboundAirportCode: "",
                inboundAirportType: "",
                inboundAirport: "",
                inboundAirportCode: "",
                outboundDate: '',
                inboundDate: ''
            }],
            errors:{
                departureAirport: "",
                arrivalAirport: "",
                departureDate: "",
                arrivalDate: "",
                phoneNumber: "",
                phoneErrMsg: ""
            }
        };
    },
    mounted() {
        this.isXlScreen = window.innerWidth >= 1280;
        window.addEventListener('resize', this.handleResize);
    },
    beforeDestroy() {
        window.removeEventListener('resize', this.handleResize);
    },
    methods: {
        checkError(index){
            if(index == "departureAirport"){
                this.errors.departureAirport = "";
            }else if(index == "arrivalAirport"){
                this.errors.departureAirport = "";
            }else if(index == "departureDate"){
                this.errors.departureAirport = "";
            }else if(index == "arrivalDate"){
                this.errors.departureAirport = "";
            }else if(index == "phoneNumber"){
                this.errors.phoneNumber = "";
                this.errors.phoneErrMsg = "";
            }
        },
        handleResize() {
            this.isXlScreen = window.innerWidth >= 1280;
        },
        setCheapestFlightSearchInputs(inoutboundAirportDateDetailKey, inoutboundAirportDateDetail) {
            this.inoutboundAirportDateDetails[inoutboundAirportDateDetailKey] = {
                outboundAirportType: inoutboundAirportDateDetail.outboundAirportType,
                outboundAirport: inoutboundAirportDateDetail.outboundAirport,
                outboundAirportCode: inoutboundAirportDateDetail.outboundAirportCode,
                inboundAirportType: inoutboundAirportDateDetail.inboundAirportType,
                inboundAirport: inoutboundAirportDateDetail.inboundAirport,
                inboundAirportCode: inoutboundAirportDateDetail.inboundAirportCode,
                outboundDate: inoutboundAirportDateDetail.outboundDate,
                inboundDate: inoutboundAirportDateDetail.inboundDate
            }
        },
        toggleCurrencyBtn() {
            this.toggleCurrency = !this.toggleCurrency;
            if (this.toggleCurrency) window.addEventListener("click", this.outsideClickHandler);
        },
        outsideClickHandler(event) {
            if (this.$refs.currencyMenu && !this.$refs.currencyMenu.contains(event.target)) this.toggleCurrency = false;
        },
        flightTabNav: function (flightType) {
            if (flightType === "multi-trip") {
                this.inoutboundAirportDateDetails[1] = {
                    outboundAirportType: (this.inoutboundAirportDateDetails[0] !== undefined ? this.inoutboundAirportDateDetails[0].inboundAirportType : ''),
                    outboundAirport: (this.inoutboundAirportDateDetails[0] !== undefined ? this.inoutboundAirportDateDetails[0].inboundAirport : ''),
                    outboundAirportCode: (this.inoutboundAirportDateDetails[0] !== undefined ? this.inoutboundAirportDateDetails[0].inboundAirportCode : ''),
                    inboundAirportType: "",
                    inboundAirport: "",
                    inboundAirportCode: "",
                    outboundDate: (this.inoutboundAirportDateDetails[0] !== undefined ? this.setInitialDate(this.inoutboundAirportDateDetails[0].outboundDate, 3) : ''),
                    inboundDate: (this.inoutboundAirportDateDetails[0] !== undefined ? this.setInitialDate(this.inoutboundAirportDateDetails[0].outboundDate, 3) : ''),
                };
            } else {
                this.inoutboundAirportDateDetails.splice(1, this.inoutboundAirportDateDetails.length);
            }
            this.flightType = flightType
        },
        updateMinToDate() {
            this.minToDate = this.fromDate;
            if (this.toDate < this.fromDate) this.toDate = this.fromDate;
        },
        addNewEntry(initialIndex) {
            const inoutboundAirportDateDetail = this.inoutboundAirportDateDetails[initialIndex];
            this.inoutboundAirportDateDetails[(Number(initialIndex) + 1)] = {
                outboundAirportType: inoutboundAirportDateDetail.inboundAirportType,
                outboundAirport: inoutboundAirportDateDetail.inboundAirport,
                outboundAirportCode: inoutboundAirportDateDetail.inboundAirportCode,
                inboundAirportType: "",
                inboundAirport: "",
                inboundAirportCode: "",
                outboundDate: moment((inoutboundAirportDateDetail.outboundDate !== null ? inoutboundAirportDateDetail.outboundDate : new Date()), "DD-MM-YYYY").add('7', 'day').format("DD-MM-YYYY"),
                inboundDate: ""
            }
        },
        removeLastEntry(index) {
            // if(this.cheapestFlightSearch !== "") this.cheapestFlightSearch.pop()
            this.inoutboundAirportDateDetails.pop();
        },
        swap(initialIndex, inoutboundAirportDateDetail) {
            const swapInoutboundAirportDateDetail = {
                outboundAirportType: inoutboundAirportDateDetail.inboundAirportType,
                outboundAirport: inoutboundAirportDateDetail.inboundAirport,
                outboundAirportCode: inoutboundAirportDateDetail.inboundAirportCode,
                inboundAirportType: inoutboundAirportDateDetail.outboundAirportType,
                inboundAirport: inoutboundAirportDateDetail.outboundAirport,
                inboundAirportCode: inoutboundAirportDateDetail.outboundAirportCode,
                outboundDate: inoutboundAirportDateDetail.outboundDate,
                inboundDate: inoutboundAirportDateDetail.inboundDate
            };
            this.inoutboundAirportDateDetails[initialIndex] = swapInoutboundAirportDateDetail
            this.cheapestFlightSearch[initialIndex] = swapInoutboundAirportDateDetail
        },
        setInitialDate(initialDate, initialDay) {
            return moment(initialDate, "DD-MM-YYYY").add(initialDay, "days").format("DD-MM-YYYY")
        },
        setTripTypeDate(initialDate) {
            return moment(initialDate, "DD/MM/YYYY").format("DD-MM-YYYY")
        },
        selectedCabin(selectedCabin) {
            this.cabin = selectedCabin.cabin
            this.cabinName = selectedCabin.name
            this.$store.dispatch("flightCabin", selectedCabin)
        },
        selectedTravelers(travelers) {
            this.adultsCount = travelers.adultsCount
            this.childrenCount = travelers.childrenCount
            this.infantsCount = travelers.infantsCount
            this.$store.dispatch("flightTravelers", travelers)
        },
        selectedPhoneNumber(phoneNumber) {
            this.phoneNumber = phoneNumber
        },
        outinboundDateDetail(initial) {
            if (initial.initialDate !== undefined) {
                if (initial.initialDate.start !== null)
                    this.inoutboundAirportDateDetails[initial.initialIndex].outboundDate = initial.initialDate.start
                if (initial.initialDate.end !== null)
                    this.inoutboundAirportDateDetails[initial.initialIndex].inboundDate = initial.initialDate.end
            }
        },
        outinboundAirportDetail(initial) {
            if (initial.initialItem !== undefined) {
                if (initial.initialType === 'outbound') {
                    this.inoutboundAirportDateDetails[initial.initialIndex].outboundAirportType = initial.initialItem.sectorType
                    this.inoutboundAirportDateDetails[initial.initialIndex].outboundAirport = initial.initialItem.fullName
                    this.inoutboundAirportDateDetails[initial.initialIndex].outboundAirportCode = initial.initialItem.code
                } else if (initial.initialType === 'inbound') {
                    this.inoutboundAirportDateDetails[initial.initialIndex].inboundAirportType = initial.initialItem.sectorType
                    this.inoutboundAirportDateDetails[initial.initialIndex].inboundAirport = initial.initialItem.fullName
                    this.inoutboundAirportDateDetails[initial.initialIndex].inboundAirportCode = initial.initialItem.code
                    
                    // if need auto increment on entring a search
                    
                    if (this.flightType == "multi-trip" && this.inoutboundAirportDateDetails.length <= 5) {
                        let inoutboundAirportDateDetailKey = (Number(initial.initialIndex) + 1);
                        this.inoutboundAirportDateDetails[inoutboundAirportDateDetailKey].outboundAirportType = initial.initialItem.sectorType
                        this.inoutboundAirportDateDetails[inoutboundAirportDateDetailKey].outboundAirport = initial.initialItem.fullName
                        this.inoutboundAirportDateDetails[inoutboundAirportDateDetailKey].outboundAirportCode = initial.initialItem.code
                        //     this.inoutboundAirportDateDetails[inoutboundAirportDateDetailKey] = {
                        //         outboundAirportType: "",
                        //         outboundAirport: "",
                        //         outboundAirportCode: "",
                        //         inboundAirportType: "",
                        //         inboundAirport: "",
                        //         inboundAirportCode: "",
                        //         outboundDate: "",
                        //         inboundDate: ""
                        //     }
                    }
                }
            }
        },
        searchFlight() {
            this.params = {
                outboundAirportCode: [],
                outboundAirportType: "",
                inboundAirportCode: [],
                inboundAirportType: "",
                outboundDate: [],
                inboundDate: []
            };
            var clientNumber = this.phoneNumber;
            var firstChars = clientNumber.substring(0, 1);
            var secndChars = clientNumber.substring(1, 2);
            var thrdChars = clientNumber.substring(2, 3);
            var checkLastNumber = clientNumber.slice(-5);
            
            for (const [inoutboundAirportDateDetailKey, inoutboundAirportDateDetail] of Object.entries(this.inoutboundAirportDateDetails)) {
                if (inoutboundAirportDateDetail.outboundAirportCode !== "") {
                    this.params.outboundAirportCode.push(inoutboundAirportDateDetail.outboundAirportCode);
                    this.params.outboundAirportType = inoutboundAirportDateDetail.outboundAirportType
                } else {
                    this.errors.departureAirport = "Please Enter Departure Airport";
                    return false;
                }
                if (this.flightType === "multi-trip") {
                    if (inoutboundAirportDateDetail.inboundAirportCode === "" || inoutboundAirportDateDetail.inboundAirportCode === "To Where ?") {
                        this.errors.arrivalAirport = "Please Enter Arrival Airport";
                        return false;
                    } else if (inoutboundAirportDateDetail.outboundDate === "") {
                        this.errors.arrivalAirport = "";
                        this.errors.departureDate = "Please Enter Departure Date";
                        return false;
                    } else {
                        this.errors.arrivalAirport = "";
                        this.errors.departureDate = "";
                        if (inoutboundAirportDateDetail.inboundAirportCode !== "")
                            this.params.inboundAirportCode.push(inoutboundAirportDateDetail.inboundAirportCode);
                        this.params.inboundAirportType = inoutboundAirportDateDetail.inboundAirportType
                        if (inoutboundAirportDateDetail.outboundDate !== "")
                            this.params.outboundDate.push(this.setTripTypeDate(inoutboundAirportDateDetail.outboundDate))
                    }
                } else if (this.flightType !== "multi-trip") {
                    if (inoutboundAirportDateDetail.inboundAirportCode !== "") {
                        this.params.inboundAirportCode.push(inoutboundAirportDateDetail.inboundAirportCode);
                        this.params.inboundAirportType = inoutboundAirportDateDetail.inboundAirportType
                    } else {
                        this.errors.arrivalAirport = "Please Enter Arrival Airport";
                        return false;
                    }
                    if (this.flightType === "round-trip") {
                        if (inoutboundAirportDateDetail.outboundDate !== undefined) {
                            this.params.outboundDate.push(this.setTripTypeDate(inoutboundAirportDateDetail.outboundDate));
                        } else {
                            this.errors.departureDate = "Please Enter Departure Date";
                            return false;
                        }
                        if (inoutboundAirportDateDetail.inboundDate !== undefined) {
                            this.params.inboundDate.push(this.setTripTypeDate(inoutboundAirportDateDetail.inboundDate));
                        } else {
                            this.errors.arrivalDate = "Please Enter Arrival Date";
                            return false;
                        }
                    } else if (this.flightType === "one-way") {
                        if (inoutboundAirportDateDetail.outboundDate !== "") {
                            this.params.outboundDate.push(this.setTripTypeDate(inoutboundAirportDateDetail.outboundDate));
                        } else {
                            this.errors.departureDate = "Please Enter Departure Date";
                            return false;
                        }
                    }
                }
            }
            this.$store.dispatch("cheapestFlightSearch", this.inoutboundAirportDateDetails)
            this.$store.dispatch("flightType", this.flightType)
            if (this.params.outboundAirportCode.includes(' ')) {
                this.errors.departureAirport = "Please Enter  Departure Airport";
                return false;
            } else if(this.params.inboundAirportCode.includes(' ')) {
                this.errors.departureAirport = "";
                this.errors.arrivalAirport = "Please Enter  Arrival Airport";
                return false;
            } else if(this.params.outboundDate.includes('Invalid date')) {
                this.errors.arrivalAirport = "";
                this.errors.departureDate = "Please Enter  Departure Date";
                return false;
            } else if(this.params.inboundDate.includes('Invalid date')) {
                this.errors.departureDate = "";
                this.errors.arrivalDate = "Please Enter  Arrival Date";
                return false;
            } else if(this.unValidateNumbers.includes(checkLastNumber)){
                this.errors.phoneErrMsg = "Please Enter Valid Phone Number";
                console.log('phone is included');
            } else if(this.phoneNumber === "" ){
                this.errors.phoneNumber = "Please Enter Valid Phone Number";
                return false;   
            } else {
                if(this.phoneNumber != "" ){
                    console.log('phone not empty');
                    if(firstChars == 9 && secndChars == 2){
                        if(thrdChars == 3 && clientNumber.toString().length == 12){
                            this.errors.phoneNumber = "";
                        }else{
                            this.errors.phoneErrMsg = "Please Enter Valid Phone Number";
                            return false;
                        }
                    }else if(firstChars == 0 && secndChars == 3 && clientNumber.toString().length == 11){
                            this.errors.phoneNumber = "";
                    }else if(firstChars == 3 && clientNumber.toString().length == 10){
                            this.errors.phoneNumber = "";
                    }else if(clientNumber.toString().length > 10 && clientNumber.toString().length <= 13) {
                            this.errors.phoneNumber = "";
                    }else{
                        this.errors.phoneErrMsg = "Please Enter Valid Phone Number";
                        this.errors.phoneNumber = "Please Enter Valid Phone Number";
                        return false;
                    }
                }
                this.$store.dispatch("phoneNumber", this.phoneNumber);
                this.errors.departureAirport = "";
                this.errors.arrivalAirport = "";
                this.errors.departureDate = "";
                this.errors.arrivalDate = "";
                const query = "?ft=" + this.flightType + "&ol=" + this.params.outboundAirportCode + "&dl=" + this.params.inboundAirportCode +
                    "&obd=" + this.params.outboundDate + "&ibd=" + this.params.inboundDate + "&ac=" + this.adultsCount + "&cc=" + this.childrenCount +
                    "&ic=" + this.infantsCount + "&cbn=" + this.cabin + "&cr=" + this.currency.currencyRate + "&ct=" + this.currency.currencyCode+"&pn=" + this.phoneNumber+
                    "&st=b2c"+ "&dt=" + (screen.width <= 699 ? "M" : "W");
                window.location = "/ticketing/cheapest-fare-flight" + query;
            }

        },
    },
};
</script>