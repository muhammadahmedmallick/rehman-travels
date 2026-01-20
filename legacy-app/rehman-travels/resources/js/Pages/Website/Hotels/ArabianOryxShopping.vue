<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
import LoadingLayout from "@/Layout/Website/LoadingLayout.vue";
import HotelFormInput from "../../../Layout/Website/HotelFormInput.vue";
</script>
<template>
    <GuestLayout>
        <section class="lg:block sidebar-open sidebar-open-off fixed right-0 md:right-2 top-[4.5rem] lg:w-full lg:static z-20 lg:z-0 h-4/5 overflow-y-auto lg:overflow-y-visible lg:h-fit w-[96%] xxs:w-[90%] xs:w-[80%] sm:w-full md:w-[96%] xl:w-[85%] 2xl:w-[78%] mx-auto bg-white rounded-md py-2 px-4 lg:mt-3 shadow-[0_3px_10px_rgb(0,0,0,0.2)] border-dashed border-[#808080] lg:border-dashed lg:border-[#808080] border border-1"
                :class="modifyClass">
                <div class="lg:mt-3 sm:mb-20 lg:mb-2 mb-16">
                    <span class="text-3xl lg:hidden block cursor-pointer" @click="modifyModal">
                        <span class="text-base font-bold float-right text-white bg-red-600 px-[0.7rem] py-1 rounded">X</span>
                    </span>
                    <HotelFormInput />
                </div>
            </section>
        <section class="sticky top-16 z-10 bg-bgRGTBaseColor shadow-xl">
            <div class="flex justify-end lg:mb-4 py-2 gap-2 lg:hidden w-11/12 sm:max-w-[600px] md:max-w-[660px] lg:max-w-[982px] xl:max-w-[1230px] mx-auto">
                <button type="button" @click="filterModal" data-dropdown-toggle="toggle-filterModalPopup"
                    class="flex justify-center items-center text-rGTBaseTextColor bg-white text-sm px-3 py-2 rounded-md">
                    <img src="/ticketing/filter.svg" class="mr-1" alt="">Filter
                </button>
                <button type="button" @click="modifyModal" data-dropdown-toggle="toggle-modifyModalPopup"
                    class="flex justify-center items-center text-rGTBaseTextColor bg-white text-sm px-3 py-2 rounded-md">
                    <img src="/ticketing/modify.svg" class="mr-1" alt=""> Modify Search
                </button>
            </div>
        </section>
        <section class="md:mt-9 mx-2 md:mx-auto">
            <div class="w-[96%] xxs:w-[90%] xs:w-[80%] sm:w-full md:w-[96%] xl:w-[85%] 2xl:w-[78%] mx-auto">
                <div class="grid grid-cols-12 gap-4 sm:gap-0">
                    <div class="col-span-12 md:col-span-3 sticky top-0 sidebar-open lg:block mb-3" id="toggle-filterModalPopup" :class="filterClass">
                        <div class="border border-1 border-solid border-[#e7e7e7] bg-white rounded-md w-full lg:w-[95%]">
                            <div class="w-full flex justify-between">
                                <h2 class="border-b border-solid border-[#e7e7e7]  justify-start text-blue-600 font-medium text-lg capitalize pl-4 pt-2 pb-2">
                                    Filter by :</h2>
                                <span class="text-3xl lg:hidden cursor-pointer" @click="closeFilterModalPopup()">
                                    <span class="text-base font-bold justify-end text-white bg-red-600 px-[0.7rem] mr-3 py-1 rounded">X</span>
                                </span>
                            </div>
                            <div class="w-full border-b border-solid border-[#e7e7e7] pb-3 pt-3">
                                <h2 class="font-semibold text-black capitalize pl-4 text-sm pb-1 flex"> By Rating <div class="text-gray-500 capitalize font-medium">&nbsp; ({{ cheapestHotels.length }} - Results found) 
                                </div> </h2>
                                <div class="flex items-center pl-4 pb-2 pt-2" v-if="hotelShopping.length !== 0" v-for="(byStar, byStarIndex) in byStars" :key="byStarIndex">
                                    <input v-model="isStars" :id="byStarIndex+'-stars'"
                                        :value="byStarIndex" type="checkbox" name="bordered-checkbox"
                                        class="w-4 h-4 cursor-pointer text-orange-400 bg-gray-100 border-gray-300 rounded focus:ring-orange-400"/>
                                    <label :for="byStarIndex+'-stars'" class="ms-2 font-medium flex items-center">
                                        <span class="fa fa-star text-sm checked text-orange-400">{{byStarIndex}}</span>
                                    </label>
                                </div>
                            </div>
                            <div class="w-full border-b border-solid border-[#e7e7e7] pb-3 pt-3">
                                <h2 class="font-semibold text-black capitalize pl-4 text-sm pb-2"> By Price</h2>
                                <div class="gap-2 px-2">
                                    <input type="range" v-model="changeMinPrice" class="w-full accent-[#0181dd] [&::-webkit-slider-runnable-track]:bg-black/5 [&::-webkit-slider-runnable-track]:rounded-full appearance-none bg-transparent"
                                    :min="minPrice" :max="maxPrice" :value="changeMinPrice" step="10">
                                    <div class="flex justify-between text-gray-500 text-xs font-bold">
                                        <span id="minPrice">{{ currency.currencySymbol }}{{ setConverter(minPrice, currency.currencyRate) }}</span>
                                        <span id="maxPrice">{{ currency.currencySymbol }}{{ setConverter(maxPrice, currency.currencyRate) }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <LoadingLayout v-if="loading" />
                    
                    <div class="col-span-12 lg:col-span-9 md:mt-0 mt-4">
                        <div v-if="responseError !== ''" class="col-span-12 mb-4 mt-10 text-red-600 font-semibold text-center lg:text-center lg:text-xl capitalize">
                            {{ responseError }}
                        </div>
                        <div class="col-span-12 mb-4"
                            v-if="!loading && hotelShopping != ''"
                            v-for="(hotelDetail, hotelIndex) in cheapestHotels" :indexKey="hotelIndex">
                            <div class="grid grid-cols-12 gap-2">
                                <div class="col-span-12 sm:col-span-6 lg:col-span-12 rounded-md shadow-xl bg-white border border-zinc-200">
                                    <div v-if="hotelIndex === 0" class="py-2 bg-green-600 rounded-t-md">
                                        <p class="text-white font-bold text-xs 2xl:text-base ml-2">
                                            Recommended Hotel
                                        </p>
                                    </div>
                                    <div  :class="`grid grid-cols-12 ${hotelIndex === 0 ? 'rounded-b-md' : 'rounded-md'} p-3`">
                                        <div class="col-span-12 lg:col-span-3">
                                            <img :src="(hotelDetail.hotelAvailabilities.hotelInfos.image != '' ? hotelDetail.hotelAvailabilities.hotelInfos.image : 'assets/Hotels/hotelImage.jpg')"
                                                :alt="hotelDetail.hotelAvailabilities.name" width="375px" height="250px"
                                                class="rounded-lg w-[375px] h-[250px]" />
                                        </div>
                                        <div class="col-span-12 lg:col-span-6">
                                            <div class="px-2 md:pl-4">
                                                <div>
                                                    <div class="flex-col items-center">
                                                        <h2 class="font-bold text-lg md:text-2xl captilize mr-3">
                                                            {{ hotelDetail.hotelAvailabilities.name }}</h2>
                                                        <i class="fa fa-star text-sm leading-[1rem] rounded p-[1.5px] checked text-orange-400 ml-[1px]"
                                                            v-if="hotelDetail.hotelAvailabilities.hotelInfos.starRating > 0"
                                                            v-for="(starRating, starRatingIndex) in parseInt(hotelDetail.hotelAvailabilities.hotelInfos.starRating)"
                                                            :indexKey="starRatingIndex"></i>
                                                        <i class="fa-solid fa-thumbs-up ml-2 text-white bg-rGTBaseTextColor p-1 rounded" title="Recommended"></i>
                                                    </div>
                                                    <p class="capitalize text-blue-500 cursor-pointer text-xs mt-3 items-center"> 
                                                        <i class="fas fa-map-marker-alt text-base"></i> {{ hotelDetail.hotelAvailabilities.hotelInfos.city }} |
                                                        <a :href="'http://www.google.com/maps/place/'+hotelDetail.hotelAvailabilities.hotelInfos.lat+','+hotelDetail.hotelAvailabilities.hotelInfos.lon" class="capitalize text-blue-500 underline cursor-pointer text-xs">Show On Map</a>
                                                    </p>
                                                </div>
                                                <div class="md:mt-4">
                                                    <ul>
                                                        <li class="items-center" v-if="hotelDetail.hotelAvailabilities.hotelInfos.add1 != '' && hotelDetail.hotelAvailabilities.hotelInfos.add2 != ''">
                                                            <i class="fa-solid fa-circle text-[5px] text-rGTBaseTextColor"></i>
                                                            <span class="pl-1 text-[13px] text-zinc-500 capitalize">
                                                                {{ hotelDetail.hotelAvailabilities.hotelInfos.add1 }} , {{ hotelDetail.hotelAvailabilities.hotelInfos.add2 }}
                                                            </span>
                                                        </li>
                                                        <li class="items-center">
                                                            <i class="fa-solid fa-circle text-[5px] text-rGTBaseTextColor"></i>
                                                            <span class="pl-1 text-[13px] text-zinc-500 capitalize">Manual Cancellation</span>
                                                        </li>
                                                        <li class="items-center">
                                                            <i class="fa-solid fa-circle text-[5px] text-rGTBaseTextColor"></i>
                                                            <span class="pl-1 text-[13px] text-zinc-500 capitalize">Free Wi-Fi</span>
                                                        </li>
                                                        <li>
                                                        </li>
                                                    </ul>
                                                </div>
                                                <!-- <div class="mt-4">
                                                    <span class="inline-flex items-center flex-col mt-1 mr-5">
                                                        <i class="fas fa-wifi text-xl text-rGTBaseTextColor"></i>
                                                        <span class="capitalize mt-1 text-xs text-[#5f5f5f]">Wifi</span>
                                                    </span>
                                                    <span class="inline-flex items-center flex-col mt-1 mr-5">
                                                        <i class="fas fa-tv text-xl text-red-800"></i>
                                                        <span class="capitalize mt-1 text-xs text-[#5f5f5f]">TV</span>
                                                    </span>
                                                    <span class="inline-flex items-center flex-col mt-1 mr-5">
                                                        <i class="fas fa-snowflake text-xl text-slate-600"></i>
                                                        <span class="capitalize mt-1 text-xs text-[#5f5f5f]">AC</span>
                                                    </span>
                                                    <span class="inline-flex items-center flex-col mt-1 mr-5">
                                                        <i class="fas fa-bath text-xl text-sky-600"></i>
                                                        <span class="capitalize mt-1 text-xs text-[#5f5f5f]">Bath</span>
                                                    </span>
                                                </div> -->
                                                <!-- <div class="mt-4">
                                                    <span class="items-center flex-col mt-1 mr-5">
                                                        <label class="font-bold">Find on Google map</label>
                                                        <iframe width="100%" height="270" frameborder="0"
                                                            scrolling="no" marginheight="0" marginwidth="0"
                                                            :src="'https://maps.google.com/?q=' + hotelDetail.hotelInfos.lat + ',' + hotelDetail.hotelInfos.lon+'&hl=es&z=14&amp;output=embed'"
                                                            ></iframe>
                                                    </span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div
                                            class="col-span-12 lg:col-span-3 mt-3 lg:mt-0 border-t lg:border-t-0 lg:border-l  border-dashed border-gray-400">
                                            <div
                                                class="mt-3 md:ml-3 lg:text-right flex md:flex-col justify-between sm:justify-none">
                                                <div>
                                                    <div class="flex float-right">
                                                        <p class="pr-2 text-xs text-zinc-500 font-medium"><span v-if="payload.adultCount > 0"> {{payload.adultCount}} Adults,</span> <span v-if="payload.childCount > 0">&nbsp;{{ payload.childCount }} Children,</span></p>
                                                        <span class="text-xs text-zinc-500 font-medium">{{ totalNights }} Nights</span>
                                                    </div>
                                                    <div class="md:mt-6">
                                                        <span class="font-bold text-xl text-zinc-900">{{ currency.currencyCode }} &nbsp;</span>
                                                        <span class="font-semibold text-xl text-zinc-900">{{ setConverter(hotelDetail.hotelAvailabilities.minPrice, currency.currencyRate) }}</span>
                                                        <p class="text-[10px] md:text-xs text-zinc-500 capitalize pb-1">
                                                            Includes taxes and fees
                                                        </p>
                                                    </div>
                                                </div>
                                                <div class="float-end ">
                                                    <button type="button" @click="availibilityRooms(hotelDetail.hotelAvailabilities)"
                                                        class="group min-h-[40px] w-36 2xl:w-48 md:flex float-end items-center justify-center gap-2 font-bold bg-blue-500 transition-all rounded-md ease-in-out duration-500 hover:bg-blue-800 hover:transition-all hover:ease-in-out hover:duration-500 text-base md:text-sm text-white capitalize">
                                                        See Availibility
                                                        <i class="fa-solid hidden md:block fa-arrow-right group-hover:translate-x-1 group-hover:duration-300 group-hover:transition-all group-hover:ease-in-out duration-300 transition-all ease-in-out"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div v-if="!loading && hotelShopping == ''" class="w-[96%] xxs:w-[90%] xs:w-[85%] sm:[75%] md:w-[96%] 2xl:w-[78%] mx-auto">
                            <div
                                class="grid grid-cols-12 gap-4 p-3 rounded-md shadow-xl bg-white border border-zinc-200">
                                <div class="col-span-12 md:col-span-12 lg:col-span-9 mx-auto">
                                    <div class="col-span-12 mx-auto mt-5">
                                        <p class="font-bold"> No hotel found, Please update your search Or Reach Us at <a class="text-rGTBaseTextColor underline cursor-pointer" href="tel:+92 51 111 786 785">+92 51 111 786 785</a></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </GuestLayout>
</template>

<script>
import _ from 'lodash'
import Service from "@/Config/Service.js";
import { mapState } from "vuex";
import moment from 'moment';
import HotelCurrencyConverter from "@/Config/HotelCurrencyConverter.js";
export default {
    name: "CheapestBookingPage",
    data() {
        return {
            filterModalPopup: false,
            modifyModalPopup: false,
            hotelShopping: [],
            isStars: [],
            byStars: {type: Object},
            loading: false,
            payload: { type: Object },
            minPrice: 0,
            maxPrice: 0,
            changeMinPrice: null,
            responseError : '',
            isOrderType: "asc",
            totalNights: 0,
            avalibility: {
                code: 0,
                groupCode: 0,
                adultCount: 0,
                childCount: 0,
            }
        }
    },
    mounted() {
        const hotelURLSearchParam = this.hotelURLSearchParams();
        this.payload = {
            'destinationCode': hotelURLSearchParam.get('des'),
            'countryCode': hotelURLSearchParam.get('c'),
            'checkInDate': hotelURLSearchParam.get('chi'),
            'checkOutDate': hotelURLSearchParam.get('cho'),
            'currency': hotelURLSearchParam.get('ct'),
            'nationality': hotelURLSearchParam.get('c'),
            'adultCount': Number(hotelURLSearchParam.get('ac')),
            'childCount': (hotelURLSearchParam.get('cc') ? Number(hotelURLSearchParam.get('cc')) : 0),
            'personsDetails' : JSON.parse(localStorage.getItem('arabianOryxSearch')),
            'rooms': hotelURLSearchParam.get('rm'),
            'mobileNo': hotelURLSearchParam.get('pn'),
        };
        this.fetchHotels();
        this.totalNights = this.totalNumDays(hotelURLSearchParam.get('chi'), hotelURLSearchParam.get('cho'));
        this.changeMinPrice = this.minPrice;
    },
    computed: {
        ...mapState(['currency']),
        filterClass() {
            return {
                hidden: !this.filterModalPopup,
            }
        },
        modifyClass() {
            return {
                hidden: !this.modifyModalPopup,
            }
        },
        cheapestHotels: function () {
            if (this.hotelShopping.length !== 0) {
                let availabilities = [];
                let hotelInfos = [];
                for (const [hotelAvailabilityKey, hotelAvailabilities] of Object.entries(this.hotelShopping)) {
                    if(hotelAvailabilities.hotelInfos.starRating !== ''){
                        if (
                            (this.isStars.length === 0 || this.isStars.includes(hotelAvailabilities.hotelInfos.starRating)) &&
                            (this.changeMinPrice <= hotelAvailabilities.minPrice)
                        ) {
                            if(hotelAvailabilityKey == 0){
                                this.minPrice = hotelAvailabilities.minPrice;
                            }
                            if(hotelAvailabilityKey == (this.hotelShopping.length - 1)){
                                this.maxPrice = hotelAvailabilities.minPrice;
                            }
                            availabilities.push({
                                'stars': eval(hotelAvailabilities.hotelInfos.starRating),
                                'hotelAvailabilities': JSON.parse(JSON.stringify(hotelAvailabilities))
                            });
                        }
                        this.responseError = '';
                        hotelInfos.push(hotelAvailabilities);
                        this.byStars = _.orderBy(hotelInfos, "stars", this.isOrderType).filter((value, index, self) => {
                            return self.findIndex((v) => v.hotelInfos.starRating === value.hotelInfos.starRating) === index
                        }).reduce(function (obj, hotelInfos) {
                            obj[hotelInfos.hotelInfos.starRating] = obj[hotelInfos.hotelInfos.starRating] || [];
                            obj[hotelInfos.hotelInfos.starRating].push({
                                "stars": hotelInfos.hotelInfos.starRating
                            });
                            return obj;
                        }, {});
                    }
                }
                return _.orderBy(availabilities, "stars", this.isOrderType);
            } else {
                if(this.hotelShopping.length === 0){
                    this.responseError = "";
                    // this.finish(false);
                }
                return [];
            }
        }
    },
    methods: {
        updateStar(stars){
            this.stars = stars;
        },
        filterModal() {

            this.filterModalPopup = !this.filterModalPopup;
        },
        modifyModal() {
            this.modifyModalPopup = !this.modifyModalPopup;
        },
        closeFilterModalPopup() {
            this.filterModalPopup = false;
        },
        totalNumDays(checkIn, checkOut) {
            checkIn = moment(checkIn, "DD-MM-YYYY").format("YYYY-MM-DD");
            checkOut = moment(checkOut, "DD-MM-YYYY").format("YYYY-MM-DD");
            const currentDate = new Date(checkIn);
            const previousDate = new Date(checkOut);
            const timeDifference = previousDate.getTime() - currentDate.getTime();
            const daysDifference = Math.floor(timeDifference / (1000 * 60 * 60 * 24));
            return daysDifference;
        },
        fetchHotels() {
            this.loading = true;
            try {
                Service.doFetchRequest("/hotel/shopping", '', this.payload).then((data) => {
                    console.log(data);
                    if (!data.error) {
                        this.hotelShopping = data.hotels.filter(item => {
                            return item.hotelInfos.starRating.indexOf(this.isStars) > -1
                        });
                        sessionStorage.setItem('hotelSessionId', data.sessionId);
                        this.loading = false;
                    }else{
                        this.hotelShopping = data.hotels;
                        this.loading = false;
                    }
                });
            } catch (error) {
                console.log(error);
            }
        },
        availibilityRooms(hotelDetails) {
            console.log(hotelDetails)
            this.avalibility.code = hotelDetails.code;
            this.avalibility.groupCode = hotelDetails.groupCode;
            let googledirection = {
                'lat' : hotelDetails.hotelInfos.lat,
                'lon' : hotelDetails.hotelInfos.lon,
                'img' : hotelDetails.hotelInfos.image,
                'htl' : hotelDetails.name,
                'cdi' : hotelDetails.code,
                'ad1' : hotelDetails.hotelInfos.add1,
                'ad2' : hotelDetails.hotelInfos.add2,
                'cty' : hotelDetails.hotelInfos.city,
                'sr' : hotelDetails.hotelInfos.starRating
            }
            localStorage.setItem('hotelGeoLocation', JSON.stringify(googledirection));
            const query = "?c=" + this.payload.countryCode + "&rm=" + this.payload.rooms + "&tn=" + this.totalNights + "&des=" + this.payload.destinationCode + "&gc=" + this.avalibility.groupCode + "&hc=" + this.avalibility.code + "&chi=" + this.payload.checkInDate + "&cho=" + this.payload.checkOutDate + "&ac=" + this.payload.adultCount + "&cc=" + this.payload.childCount + "&pn=" + this.payload.mobileNo + "&ct=USD";
            window.location.href = "/hotel/shopping-details" + query;
        },
        hotelURLSearchParams: function () {
            return new URLSearchParams(window.location.search);
        },
        setConverter(amount, currencyRate) {
            let getUAECurrency = this.$page.props.currencies[0];
            if(this.currency.currencyCode !== "USD"){
                return HotelCurrencyConverter.doRequest(amount, currencyRate, getUAECurrency.currencyRate);
            }else{
                return eval(amount).toFixed();
            }
        },
    }
}
</script>