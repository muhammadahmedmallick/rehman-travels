<template>
    <section id="toggle-modifyModalPopup">
        <form @submit.prevent="">
            <div class="flex flex-wrap">
                <div class="md:pl-2 flex flex-wrap items-center xxs:mx-1">
                    <SelectCurrency class="border rounded md:rounded-full mr-1 ml-12 md:ml-1 md:px-2 px-4 focus:outline-none py-1 sm:py-0">
                    </SelectCurrency>
                </div>
            </div>
            <div class="flex flex-wrap gap-1 mt-5">
                <div :class="` ${errors.departureAirport != '' ? 'border-red-500 border-2' : 'border-gray-300'}`"
                    class="2xl:w-[26%] xl:w-[26%] w-full relative  h-[3.6rem] rounded-md flex border hover:border-gray-400  leading-tight focus:outline-none focus:bg-white focus:border-blue-500 ">
                    <AutoCompleteArabianOryx @keyup="checkError('fullName')"
                        v-model="inoutboundAirportDateDetails.fullName" @update:arabianOryx="countryDetail"
                        :modelValue="inoutboundAirportDateDetails.fullName" :initialIndex="initialIndex" :initialType="'outbound'"></AutoCompleteArabianOryx>
                    <small class="text-red-500 align-middle justify-center"
                        v-if="errors.departureAirport != '' && inoutboundAirportDateDetails.fullName == ''">(Required)</small>
                </div>
                <div
                    class="w-full md:w-[49%] xl:w-[22.5%] 2xl:w-[22%] h-[3.6rem] rounded-md block leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                    <div class="flex">
                        <div
                            :class="`${(errors.departureDate != '' && inoutboundAirportDateDetails.outboundDate !== undefined) ? 'border-red-500 border-2' : 'border-gray-300'} w-1/2 my-2 md:my-0 md:mt-0 flex items-center h-14 border hover:border-gray-400 px-1 py-[0.32rem] bg-white  rounded-md mr-1 md:mr-0`">
                            <OutinboundDate v-model="inoutboundAirportDateDetails.outboundDate"
                                @change="checkError('checkIn')"
                                @update:outinboundDateDetail="outinboundDateDetail" :flightType="flightType"
                                :initialInput="'checkIn'" :initialLastIndex="initialIndex"
                                :initialIndex="initialIndex"></OutinboundDate>
                            <small class="text-red-500 text-[10px]" v-if="errors.departureDate != '' && inoutboundAirportDateDetails.outboundDate !== undefined">
                                (Required)
                            </small>
                        </div>
                        <div
                            :class="`${(errors.arrivalDate != '' && inoutboundAirportDateDetails.inboundDate !== undefined) ? 'border-red-500 border-2' : 'border-gray-300'} w-1/2 my-2 md:my-0 md:mt-0 lg:ml-2 flex items-center border h-14 hover:border-gray-400 px-1 py-[0.32rem] mx-0 md:ml-2 bg-white  rounded-md`">
                            <OutinboundDate v-model="inoutboundAirportDateDetails.inboundDate"
                                @change="checkError('checkOut')" @update:outinboundDateDetail="outinboundDateDetail"
                                :flightType="flightType" :initialInput="'inboundDate'"
                                :initialLastIndex="initialIndex" :initialIndex="initialIndex">
                            </OutinboundDate>
                            <small class="text-red-500 text-[10px]"
                                v-if="errors.arrivalDate != '' && inoutboundAirportDateDetails.inboundDate !== undefined">
                                (Required)</small>
                        </div>
                    </div>
                </div>
                <div class="w-full  md:w-[49%] xl:w-[10.5%] 2xl:w-[15%] h-[3.6rem] rounded-md block  leading-tight focus:outline-none focus:bg-white focus:border-blue-500 mt-3 sm:mt-0">
                    <div
                        class="flex items-center px-3 h-[3.5rem] mb-2 border border-gray-300 hover:border-gray-400 bg-white rounded-md w-full">
                        <svg xmlns="http://www.w3.org/2000/svg" height="18px" width="24px" fill="#0181dd"
                            viewBox="0 0 576 512" class="block">
                            <path
                                d="M432 96a48 48 0 1 0 0-96 48 48 0 1 0 0 96zM347.7 200.5c1-.4 1.9-.8 2.9-1.2l-16.9 63.5c-5.6 21.1-.1 43.6 14.7 59.7l70.7 77.1 22 88.1c4.3 17.1 21.7 27.6 38.8 23.3s27.6-21.7 23.3-38.8l-23-92.1c-1.9-7.8-5.8-14.9-11.2-20.8l-49.5-54 19.3-65.5 9.6 23c4.4 10.6 12.5 19.3 22.8 24.5l26.7 13.3c15.8 7.9 35 1.5 42.9-14.3s1.5-35-14.3-42.9L505 232.7l-15.3-36.8C472.5 154.8 432.3 128 387.7 128c-22.8 0-45.3 4.8-66.1 14l-8 3.5c-32.9 14.6-58.1 42.4-69.4 76.5l-2.6 7.8c-5.6 16.8 3.5 34.9 20.2 40.5s34.9-3.5 40.5-20.2l2.6-7.8c5.7-17.1 18.3-30.9 34.7-38.2l8-3.5zm-30 135.1l-25 62.4-59.4 59.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L340.3 441c4.6-4.6 8.2-10.1 10.6-16.1l14.5-36.2-40.7-44.4c-2.5-2.7-4.8-5.6-7-8.6zM256 274.1c-7.7-4.4-17.4-1.8-21.9 5.9l-32 55.4L147.7 304c-15.3-8.8-34.9-3.6-43.7 11.7L40 426.6c-8.8 15.3-3.6 34.9 11.7 43.7l55.4 32c15.3 8.8 34.9 3.6 43.7-11.7l64-110.9c1.5-2.6 2.6-5.2 3.3-8L261.9 296c4.4-7.7 1.8-17.4-5.9-21.9z" />
                        </svg>
                        <SelectGuestAndRooms @selectedGuestAndRooms='selectedGuestAndRooms' class="md:ml-2 h-[2.48rem] ml-2">
                        </SelectGuestAndRooms>
                    </div>
                </div>
                <div v-if="isXlScreen && initialIndex === 0" class="w-full md:w-[29%] lg:w-[24%] xl:w-[14%]">
                    <PhoneNumber @keyup="checkError('phoneNumber')" :checkNum="errors.phoneNumber"
                        :phoneNumberValue="phoneNumber" @selectedPhoneNumber="selectedPhoneNumber"></PhoneNumber>
                    <span v-if='errors.phoneErrMsg != ""'><small class="text-red-600 font-semibold">Phone number is
                            invalid</small></span>
                </div>
                <div v-if="isXlScreen && initialIndex === 0" class="w-full md:w-[19.5%] lg:w-[24%] xl:w-[10%]">
                    <button v-on:click="searchFlight()"
                        class="bg-rGTBaseTextColor text-white sm:text-xl font-semibold py-[0.83rem] rounded-md w-full focus:bg-green-500">
                        <i class="fa fa-search"></i> Search
                    </button>
                </div>
            </div>
            <div class="grid grid-cols-12 gap-2">
                <div v-if="!isXlScreen" class="col-span-8 md:col-span-6">
                    <PhoneNumber class="mt-2 xl:mt-0 h-[3.42rem] w-full" @keyup="checkError('phoneNumber')"
                        :checkNum="errors.phoneNumber" :phoneNumberValue="phoneNumber"
                        @selectedPhoneNumber="selectedPhoneNumber"></PhoneNumber>
                    <span v-if='errors.phoneErrMsg != ""'><small class="text-red-600 font-semibold">Phone number is invalid</small></span>
                </div>
                <div v-if="!isXlScreen" class="col-span-4 flex justify-center">
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
import SelectGuestAndRooms from '@/Layout/Website/SelectGuestAndRooms.vue';
import PhoneNumber from '@/Layout/Website/PhoneNumber.vue';
import SelectCurrency from "@/Layout/Website/SelectCurrency.vue";
import AutoCompleteArabianOryx from "@/Pages/Website/Hotels/AutoCompleteArabianOryx.vue";
import OutinboundDate from "@/Pages/Website/Hotels/HotelOutinboundDate.vue";
import moment from 'moment';
import { mapState } from "vuex";

export default {
    props: {
        btnSearch: String,
    },
    components: {
        OutinboundDate,
        SelectCurrency,
        SelectGuestAndRooms,
        PhoneNumber,
        AutoCompleteArabianOryx
    },
    computed: {
        ...mapState(['currency', 'arabianOryxSearch', 'arabianOryxSearchIternary']),
        cheapestFlightSearchInputs() {
            for (const [inoutboundAirportDateDetailKey, inoutboundAirportDateDetail] of Object.entries(this.arabianOryxSearch)) {
                this.setCheapestFlightSearchInputs(inoutboundAirportDateDetailKey, inoutboundAirportDateDetail)
            }
            return this.inoutboundAirportDateDetails;
        },
    },
    data() {
        return {
            initialIndex : 0,
            unValidateNumbers: ["34567", "45678", "54321", "56789", "00000", "11111", "22222", "33333", "44444", "55555", "66666", "77777", "88888"],
            isXlScreen: false,
            toggleCurrency: false,
            stateCurrencyCode: "",
            currencyCode: "",
            currencySymbol: "",
            currencyFlag: "",
            currencyType: "",
            flightType: "round-trip",
            currentCurrencyRate: 0,
            phoneNumber: (this.$store.state.phoneNumber !== "" ? this.$store.state.phoneNumber : ""),
            adultsCount: 1,
            childrenCount: 0,
            params: {
                outboundAirportCode: [],
                outboundAirportType: "",
                inboundAirportCode: [],
                inboundAirportType: "",
                outboundDate: [],
                inboundDate: []
            },
            inoutboundAirportDateDetails: {
                code: (this.$store.state.arabianOryxSearchIternary !== "" ? this.$store.state.arabianOryxSearchIternary.code : ""),
                city: (this.$store.state.arabianOryxSearchIternary !== "" ? this.$store.state.arabianOryxSearchIternary.city : ""),
                destination: (this.$store.state.arabianOryxSearchIternary !== "" ? this.$store.state.arabianOryxSearchIternary.destination : ""),
                fullName: (this.$store.state.arabianOryxSearchIternary !== "" ? this.$store.state.arabianOryxSearchIternary.fullName : ""),
                outboundDate: (this.$store.state.arabianOryxSearchIternary !== "" ? this.$store.state.arabianOryxSearchIternary.outboundDate : ""),
                inboundDate: (this.$store.state.arabianOryxSearchIternary !== "" ? this.$store.state.arabianOryxSearchIternary.inboundDate : ""),
            },
            dd: "ddd",
            errors: {
                fullName: "",
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
        this.setGuest();
    },
    beforeDestroy() {
        window.removeEventListener('resize', this.handleResize);
    },
    methods: {
        setGuest(){
            this.adultsCount = 0;
            this.childrenCount = 0;
            for (const [arabianOryxSearchDetailKey, arabianOryxSearchDetail] of Object.entries(this.arabianOryxSearch)) {
                this.adultsCount += parseInt(arabianOryxSearchDetail.adultsCount);
                this.childrenCount += parseInt(arabianOryxSearchDetail.childrenCount);
            }
        },
        selectedGuestAndRooms(guestRooms){
            this.adultsCount = 0;
            this.childrenCount = 0;
            for(const [guestRoomKey, guestRoom] of Object.entries(guestRooms)){
                this.adultsCount += parseInt(guestRoom.adultsCount);
                this.childrenCount += parseInt(guestRoom.childrenCount);
            }
            this.$store.dispatch("arabianOryxSearch", guestRooms)
        },
        checkError(index) {
            if (index == "fullName") {
                this.errors.fullName = "";
            } else if (index == "checkIn") {
                this.errors.departureAirport = "";
            } else if (index == "checkOut") {
                this.errors.departureAirport = "";
            } else if (index == "phoneNumber") {
                this.errors.phoneNumber = "";
                this.errors.phoneErrMsg = "";
            }
        },
        handleResize() {
            this.isXlScreen = window.innerWidth >= 1280;
        },
        setCheapestFlightSearchInputs(inoutboundAirportDateDetailKey, inoutboundAirportDateDetail) {
            this.inoutboundAirportDateDetails = {
                code: inoutboundAirportDateDetail.code,
                city: inoutboundAirportDateDetail.city,
                destination: inoutboundAirportDateDetail.destination,
                fullName: inoutboundAirportDateDetail.fullName,
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
        updateMinToDate() {
            this.minToDate = this.fromDate;
            if (this.toDate < this.fromDate) this.toDate = this.fromDate;
        },
        addNewEntry(initialIndex) {
            const inoutboundAirportDateDetail = this.inoutboundAirportDateDetails[initialIndex];
            this.inoutboundAirportDateDetails[(Number(initialIndex) + 1)] = {
                code: "",
                city: "",
                destination: "",
                fullName: "",
                outboundDate: moment((inoutboundAirportDateDetail.outboundDate !== null ? inoutboundAirportDateDetail.outboundDate : new Date()), "DD-MM-YYYY").add('7', 'day').format("DD-MM-YYYY"),
                inboundDate: ""
            }
        },
        removeLastEntry(index) {
            this.inoutboundAirportDateDetails.pop();
        },
        setInitialDate(initialDate, initialDay) {
            return moment(initialDate, "DD-MM-YYYY").add(initialDay, "days").format("DD-MM-YYYY");
        },
        setTripTypeDate(initialDate) {
            return moment(initialDate, "DD/MM/YYYY").format("DD-MM-YYYY");
        },
        selectedPhoneNumber(phoneNumber) {
            this.phoneNumber = phoneNumber
        },
        outinboundDateDetail(initial) {
            if (initial.initialDate !== undefined) {
                if (initial.initialDate.start !== null)
                    this.inoutboundAirportDateDetails.outboundDate = initial.initialDate.start
                if (initial.initialDate.end !== null)
                    this.inoutboundAirportDateDetails.inboundDate = initial.initialDate.end
            }
        },
        countryDetail(initial) {
            if (initial.initialItem !== undefined) {
                this.inoutboundAirportDateDetails.code = initial.initialItem.code
                this.inoutboundAirportDateDetails.city = initial.initialItem.city
                this.inoutboundAirportDateDetails.destination = initial.initialItem.destination
                this.inoutboundAirportDateDetails.fullName = initial.initialItem.fullName
            }
        },
        searchFlight() {
            this.params = {
                code: "",
                city: "",
                destination: "",
                outboundDate: [],
                inboundDate: []
            };
            var clientNumber = this.phoneNumber;
            var firstChars = clientNumber.substring(0, 1);
            var secndChars = clientNumber.substring(1, 2);
            var thrdChars = clientNumber.substring(2, 3);
            var checkLastNumber = clientNumber.slice(-5);
            if (this.inoutboundAirportDateDetails.fullName !== "") {
                this.params.code = this.inoutboundAirportDateDetails.code;
                this.params.city = this.inoutboundAirportDateDetails.city;
                this.params.destination = this.inoutboundAirportDateDetails.destination;
            } else {
                this.errors.fullName = "Please Select Country List";
                return false;
            }
            if (this.inoutboundAirportDateDetails.outboundDate !== undefined) {
                this.params.outboundDate.push(this.setTripTypeDate(this.inoutboundAirportDateDetails.outboundDate));
            } else {
                this.errors.departureDate = "Please Enter Departure Date";
                return false;
            }
            if (this.inoutboundAirportDateDetails.inboundDate !== undefined) {
                this.params.inboundDate.push(this.setTripTypeDate(this.inoutboundAirportDateDetails.inboundDate));
            } else {
                this.errors.arrivalDate = "Please Enter Arrival Date";
                return false;
            }
            this.$store.dispatch("arabianOryxSearchIternary", this.inoutboundAirportDateDetails)
            if (this.params.outboundDate.includes('Invalid date')) {
                this.errors.arrivalAirport = "";
                this.errors.departureDate = "Please Enter Check In";
                return false;
            } else if (this.params.inboundDate.includes('Invalid date')) {
                this.errors.departureDate = "";
                this.errors.arrivalDate = "Please Enter Check Out";
                return false;
            } else if (this.unValidateNumbers.includes(checkLastNumber)) {
                this.errors.phoneErrMsg = "Please Enter Valid Phone Number";
                console.log('phone is included');
            } else if (this.phoneNumber === "") {
                this.errors.phoneNumber = "Please Enter Valid Phone Number";
                console.log('phone empty');
                return false;
            } else {
                if (this.phoneNumber != "") {
                    console.log('phone not empty');
                    if (firstChars == 9 && secndChars == 2) {
                        if (thrdChars == 3 && clientNumber.toString().length == 12) {
                            this.errors.phoneNumber = "";
                            console.log('phone thrdChars empty');
                        } else {
                            this.errors.phoneErrMsg = "Please Enter Valid Phone Number";
                            return false;
                        }
                    } else if (firstChars == 0 && secndChars == 3 && clientNumber.toString().length == 11) {
                        this.errors.phoneNumber = "";
                        console.log('phone 03 11');
                    } else if (firstChars == 3 && clientNumber.toString().length == 10) {
                        this.errors.phoneNumber = "";
                        console.log('phone 3 10');
                    } else if (clientNumber.toString().length > 10 && clientNumber.toString().length <= 13) {
                        this.errors.phoneNumber = "";
                        console.log('phone > 10 and phone < 13');
                    } else {
                        console.log('international number');
                        this.errors.phoneErrMsg = "Please Enter Valid Phone Number";
                        this.errors.phoneNumber = "Please Enter Valid Phone Number";
                        return false;
                    }
                }
                this.$store.dispatch("phoneNumber", this.phoneNumber);
                this.errors.code = "";
                this.errors.city = "";
                this.errors.destination = "";
                this.errors.fullName = "";
                const query = "?c=" + this.params.code + "&des=" + this.params.destination + "&rm=" + (localStorage.getItem('rooms') ? localStorage.getItem('rooms') : 1) +
                    "&chi=" + this.params.outboundDate + "&cho=" + this.params.inboundDate + "&ac=" + this.adultsCount + "&cc=" + this.childrenCount +
                    "&cr=" + this.currency.currencyRate + "&ct=" + this.currency.currencyCode + "&pn=" + this.phoneNumber +
                    "&dt=" + (screen.width <= 699 ? "M" : "W");
                window.location = "/hotel" + query;
            }

        },
    },
};
</script>