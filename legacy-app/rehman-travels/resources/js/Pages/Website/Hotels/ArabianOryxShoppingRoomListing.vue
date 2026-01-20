<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
import LoadingBar from "@/Pages/Website/Ticketing/LoadingBar.vue";
import HotelFormInput from "../../../Layout/Website/HotelFormInput.vue";
</script>
<template>
    <GuestLayout>
        <section class="sticky top-16 z-10 bg-bgRGTBaseColor shadow-xl">
            <div
                class="flex justify-end lg:mb-4 py-2 gap-2 lg:hidden w-11/12 sm:max-w-[600px] md:max-w-[660px] lg:max-w-[982px] xl:max-w-[1230px] mx-auto">
                <button type="button" @click="modifyModal" data-dropdown-toggle="toggle-modifyModalPopup"
                    class="flex justify-center items-center text-rGTBaseTextColor bg-white text-sm px-3 py-2 rounded-md">
                    <img src="/ticketing/modify.svg" class="mr-1" alt=""> Modify Search
                </button>
            </div>
        </section>
        <section
            class="lg:block sidebar-open sidebar-open-off fixed right-0 md:right-2 top-[4.5rem] lg:w-full lg:static z-20 lg:z-0 h-4/5 overflow-y-auto lg:overflow-y-visible lg:h-fit w-full sm:max-w-[600px] md:max-w-[660px] lg:max-w-[982px] xl:max-w-[1230px] mx-auto bg-white rounded-md py-2 px-4 lg:mt-3 shadow-[0_3px_10px_rgb(0,0,0,0.2)] border-dashed border-[#808080] lg:border-dashed lg:border-[#808080] border border-1"
            :class="modifyClass">
            <div class="lg:mt-3 sm:mb-20 lg:mb-2 mb-40">
                <span class="text-3xl lg:hidden block cursor-pointer" @click="modifyModal()">
                    <span
                        class="text-base font-bold float-right text-white bg-red-600 px-[0.7rem] py-1 rounded">X</span>
                </span>
                <HotelFormInput />
            </div>
        </section>
        <div v-if="loading" class="my-9 w-[96%] xxs:w-[90%] xs:w-[85%] sm:[75%] md:w-[96%] 2xl:w-[68%] mx-auto">
            <div class="w-full mx-auto">
                <b>Loading Availabile Rooms, please wait...</b>
            </div>
            <div class="border border-slate-300 bg-white shadow rounded-lg p-4 h-[180px] w-full">
                <div class="animate-pulse flex space-x-4">
                    <div class="rounded-full bg-slate-200 h-24 w-24"></div>
                    <div class="flex-1 space-y-6 py-1">
                        <div class="h-9 bg-slate-200 rounded"></div>
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
            <div class="border border-slate-300 bg-white shadow rounded-lg p-4 h-[180px] my-4 w-full">
                <div class="animate-pulse flex space-x-4">
                    <div class="rounded-md bg-slate-200 h-24 w-24"></div>
                    <div class="flex-1 space-y-6 py-1">
                        <div class="h-9 bg-slate-200 rounded"></div>
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
            <div class="border border-slate-300 bg-white shadow rounded-lg p-4 h-[180px] w-full">
                <div class="animate-pulse flex space-x-4">
                    <div class="rounded-full bg-slate-200 h-24 w-24"></div>
                    <div class="flex-1 space-y-6 py-1">
                        <div class="h-9 bg-slate-200 rounded"></div>
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
        </div>
        <section class="mt-3 md:my-8 px-4 md:px-0">
            <div v-if="!loading && hotelShoppingDetails == ''" class="my-9 w-[96%] xxs:w-[90%] xs:w-[85%] sm:[75%] md:w-[96%] 2xl:w-[55%] mx-auto">
                <div class="border border-slate-300 bg-white shadow rounded-lg p-4 h-[180px] w-full">
                    <div class="animate-pulse items-center">
                        <p class="text-center font-bold text-rose-600"> All Rooms are Pre-Booked, Please Modify Your search.</p>
                    </div>
                </div>
            </div>
            <div class="w-full sm:max-w-[600px] md:max-w-[660px] lg:max-w-[982px] xl:max-w-[1230px] mx-auto" v-if="hotelShoppingDetails != ''">
                <div class="grid grid-cols-12 gap-4">
                    <div class="col-span-12 md:col-span-12 lg:col-span-9">
                        <!-- about hotel -->
                        <div class="border border-1 bg-blue-100 border-solid border-[#e7e7e7] rounded-sm w-full mb-3 shadow block md:hidden" v-if="!loading && hotelShoppingDetails != ''">
                            <div class="w-full px-3 py-1">
                                <div class="mt-6 w-full space-y-6 sm:mt-8 lg:mt-0 lg:max-w-xs xl:max-w-md">
                                    <div class="flow-root">
                                        <h3 class="text-lg font-bold text-gray-800 mt-1 uppercase">About {{ hotelShoppingDetails.hotelInfo.name }}</h3>
                                        <i class="fa fa-star text-[0.75rem] leading-[1rem] rounded p-[1.5px] checked bg-orange-400 text-white ml-[1.5px]"
                                            v-if="hotelShoppingDetails.hotelInfo.starRating > 0"
                                            v-for="(starRating, starRatingIndex) in parseInt(hotelShoppingDetails.hotelInfo.starRating)"
                                            :indexKey="starRatingIndex"></i>
                                        <p class="text-sm text-slate-600 font-medium my-2">Premium Choice for {{ totalNights }} Nights stay</p>
                                        <p class="text-sm text-slate-500 my-2">
                                            <i class="fa-solid fa-location-dot mr-1"></i>{{ hotelShoppingDetails.hotelInfo.add1 }} - {{ hotelShoppingDetails.hotelInfo.add2 }}
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <table class="w-full bg-white">
                            <thead class="bg-bgRGTBaseColor text-white">
                                <tr class="*:p-1 *:border *:border-white *:text-center md:*:text-base *:text-xs">
                                    <th>Room Type</th>
                                    <th>Price for {{ totalNights }} Nights</th>
                                    <th>Related</th>
                                    <th>Select Room(s)</th>
                                </tr>
                            </thead>
                            <tbody class="border border-solid text-center">
                                <tr v-for="(hotelDetail, hotelIndex) in hotelShoppingDetails.rooms.room" :indexKey="hotelIndex">
                                    <th class="whitespace-break-spaces flex-col border-b text-start border-blue-200 px-3  text-[12px] md:text-sm"
                                        v-if="hotelDetail.roomIdentifier == 1">
                                        {{ hotelDetail.roomName }}
                                        <span class="font-normal flex mx-auto w-full items-center text-blue-500 text-xs underline mt-1">
                                            <button class="items-center" @click="showPolicy(hotelDetail.rateKey)">Cancellation Policy</button>
                                        </span>
                                    </th>
                                    <td class="border border-blue-500 font-bold text-[12px] md:text-[13px]" v-if="hotelDetail.roomIdentifier == 1">
                                        {{ currency.currencyCode }}  {{ setConverter(hotelDetail.price.eqnet, currency.currencyRate) }}
                                    </td>
                                    <td class="text-start border border-blue-500 p-3"
                                        v-if="hotelDetail.roomIdentifier == 1">
                                        <ul>
                                            <li class="mt-2 items-center flex" v-if="hotelDetail.rateType">
                                                <i
                                                    :class="`fa-solid fa-check ${hotelDetail.rateType === 'Refundable' ? 'text-green-500' : 'text-red-600'} text-[12px] md:text-[13px]`"></i>
                                                <span
                                                    :class="`pl-1 text-[12px] md:text-[13px] capitalize ${hotelDetail.rateType === 'Refundable' ? 'text-green-500 font-bold' : 'text-red-600 font-bold'}`">{{
                                                    hotelDetail.rateType }}</span>
                                            </li>
                                            <li class="mt-2 items-center flex" v-if="hotelDetail.meal">
                                                <i class="fa-solid fa-circle text-[5px] text-green-500"></i>
                                                <span class="pl-1 text-[12px] md:text-[13px] capitalize whitespace-break-spaces">
                                                    <b>Facilities:</b> {{ hotelDetail.meal }}
                                                </span>
                                            </li>
                                            <li class="mt-2 items-center flex" v-if="hotelDetail.bedTypes">
                                                <i class="fa-solid fa-circle text-[5px] text-green-500"></i>
                                                <span class="pl-1 text-[12px] md:text-[13px] capitalize whitespace-break-spaces">
                                                    <b>Bed Type:</b> {{ hotelDetail.bedTypes.bedType }}
                                                </span>
                                            </li>
                                            <li class="mt-2 items-center flex" v-if="hotelDetail.status">
                                                <i class="fa-solid fa-circle text-[5px] text-green-500"></i>
                                                <span class="pl-1 text-[12px] md:text-[13px] capitalize whitespace-break-spaces">
                                                    <b>Status:</b> {{ hotelDetail.status }}
                                                </span>
                                            </li>
                                        </ul>
                                    </td>
                                    <td class="border border-blue-500 align-top items-center"
                                        v-if="hotelDetail.roomIdentifier == 1">
                                        <button :id="'room-' + hotelIndex"
                                        class="group mt-3 sidebar-open sidebar-open-off min-h-[40px] min-w-20 font-bold bg-blue-500 transition-all rounded-md ease-in-out duration-500 hover:bg-blue-800 hover:transition-all hover:ease-in-out hover:duration-500 text-base text-white capitalize"
                                        @click="checkAvailibility(hotelDetail, hotelIndex)">Select</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="col-span-12 lg:col-span-3 sidebar-open" id="toggle-filterModalPopup">
                        <!-- about hotel -->
                        <div class="border border-1 bg-blue-100 border-solid border-[#e7e7e7] rounded-sm w-full mb-3 shadow hidden md:block"
                            v-if="!loading && hotelShoppingDetails != ''">
                            <div class="w-full px-3 py-1">
                                <div class="mt-6 w-full space-y-6 sm:mt-8 lg:mt-0 lg:max-w-xs xl:max-w-md">
                                    <div class="flow-root">
                                        <h3 class="text-lg font-bold text-gray-800 mt-1 uppercase">About {{
                                            hotelShoppingDetails.hotelInfo.name }}</h3>
                                        <i class="fa fa-star text-[0.75rem] leading-[1rem] rounded p-[1.5px] checked bg-orange-400 text-white ml-[1.5px]"
                                            v-if="hotelShoppingDetails.hotelInfo.starRating > 0"
                                            v-for="(starRating, starRatingIndex) in parseInt(hotelShoppingDetails.hotelInfo.starRating)"
                                            :indexKey="starRatingIndex"></i>
                                        <p class="text-sm text-slate-600 font-medium my-2">Premium Choice for {{
                                            totalNights }} Nights stay</p>
                                        <p class="text-sm text-slate-500 my-2"><i
                                                class="fa-solid fa-location-dot mr-1"></i>{{
                                            hotelShoppingDetails.hotelInfo.add1 }} - {{
                                            hotelShoppingDetails.hotelInfo.add2 }}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- price -->
                        <div class="md:shadow md:w-full md:mb-3 md:border-t-[1px]">
                            <img class="w-full h-full rounded-t-sm hidden md:block" :src="hotelImg.img" alt="Card image">
                            <div v-if="avalibility.net" class="lg:hidden block relative pb-4 mb-3 mt-5">
                                <div
                                    class="fixed lg:static bottom-0 container -ml-[15px] lg:mx-0 lg:w-full bg-white border-t-[1px] border border-gray-400 lg:bg-none z-10 lg:z-0">
                                    <!-- <div
                                        class="lg:relative flex justify-between items-center lg:justify-center pl-2 lg:pl-0">
                                        <div class="lg:hidden text-gray-800">
                                            <span class="text-lg font-semibold capitalize ml-2"> <b></b>&nbsp; </span>
                                            <span class="font-bold text-lg tracking-wide text-blue-600 italic"> </span>
                                        </div>
                                        <div class="lg:flex lg:justify-center">
                                            <button type="button"
                                                class="font-bold text-sm sm:text-lg border border-blue-600 bg-blue-600 text-white hover:from-blue-700 hover:to-blue-900 focus:outline-none focus:ring-2 focus:ring-blue-300 rounded-2xl px-5 py-3 transition-transform transform hover:scale-105 shadow-md italic animate-pulse opacity-90">
                                                Reserve Now
                                            </button>
                                        </div>
                                    </div> -->
                                    <div
                                        class="fixed lg:static w-full bottom-0 py-0 lg:mx-0 lg:w-full bg-gray-50 border-t border-gray-300 lg:bg-transparent z-10 lg:z-0 shadow-md lg:shadow-none rounded-t-lg lg:rounded-none">
                                        <div
                                            class="lg:relative flex justify-between items-center lg:justify-center p-2">
                                            <div class="lg:hidden text-gray-800">
                                                <span class="text-xl font-semibold capitalize ml-2">{{ currency.currencyCode }}&nbsp;</span>
                                                <span
                                                    class="font-bold text-xl tracking-wide text-blue-600 italic">
                                                    {{ setConverter(avalibility.net, currency.currencyRate) }} /-</span>
                                            </div>
                                            <div class="lg:flex lg:justify-center mr-4">
                                                <button type="button" @click="reserveAvailibility()"
                                                    class="font-bold text-sm sm:text-lg border border-blue-600 bg-blue-600 text-white hover:from-blue-700 hover:to-blue-900 focus:outline-none focus:ring-2 focus:ring-blue-300 rounded-2xl p-3 transition-transform transform hover:scale-105 shadow-md animate-pulse opacity-90">
                                                    Reserve Now
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="w-full p-3 hidden lg:block bg-white">
                                <div class="mt-6 w-full space-y-6 sm:mt-8 lg:mt-0 lg:max-w-xs xl:max-w-md">
                                    <div class="flow-root">
                                        <div class="-my-3 divide-y divide-gray-200">
                                            <h3 class="text-lg font-bold text-gray-800 mt-3">Summary</h3>
                                            <dl class="flex items-center justify-between gap-4 py-3">
                                                <dt class="text-sm font-normal text-gray-500">
                                                    Subtotal</dt>
                                                <dd class="text-sm font-medium text-gray-900">
                                                    {{ currency.currencySymbol }} {{ setConverter(avalibility.eqgross,
                                                    currency.currencyRate) }} </dd>
                                            </dl>

                                            <dl class="flex items-center justify-between gap-4 py-3">
                                                <dt class="text-sm font-normal text-gray-500">Tax
                                                </dt>
                                                <dd class="text-sm font-medium text-gray-900">{{
                                                    currency.currencySymbol }} {{ setConverter(avalibility.eqtax,
                                                    currency.currencyRate) }}</dd>
                                            </dl>

                                            <dl class="flex items-center justify-between gap-4 py-3">
                                                <dt class="text-sm font-bold text-gray-900">Total</dt>
                                                <dd class="text-sm font-bold text-gray-900">{{
                                                    currency.currencySymbol }} {{ setConverter(avalibility.eqnet,
                                                    currency.currencyRate) }}</dd>
                                            </dl>
                                        </div>
                                    </div>
                                </div>
                                <button type="button" ref="reserveButton"  @click="reserveAvailibility()" v-if="avalibility.net"
                                    class="group mt-3 sidebar-open sidebar-open-off min-h-[40px] font-bold w-full bg-blue-500 transition-all rounded-md ease-in-out duration-500 hover:bg-blue-800 hover:transition-all hover:ease-in-out hover:duration-500 text-base text-white capitalize flex justify-center items-center">
                                    Reserve
                                    <i
                                        class="ml-2 fa-solid hidden md:block fa-arrow-right group-hover:translate-x-1 group-hover:duration-300 group-hover:transition-all group-hover:ease-in-out duration-300 transition-all ease-in-out"></i>
                                </button>
                                <div v-if="isScrolled && !isReserveVisible && avalibility.net"
                                :class="{ 'fixed-bottom': isScrolled }"
                                    class="relative pb-4 mb-3 mt-5 desktop-scroll">
                                    <div  class="block bottom-0 container -ml-[15px] md:mx-auto md:w-[30%] bg-white border border-gray-300 shadow-md rounded z-50" >
                                        <div
                                            class="lg:relative flex justify-between items-center p-2">
                                            <div class="text-gray-800 md:justify-right">
                                                <span class="text-xl font-semibold capitalize ml-2">{{
                                                    currency.currencyCode }}&nbsp;</span>
                                                <span class="font-bold text-xl tracking-wide text-blue-600 italic">
                                                    {{ setConverter(avalibility.eqnet, currency.currencyRate) }} /-</span>
                                            </div>
                                            <div class="lg:flex md:justify-left mr-4">
                                                <button type="button" @click="reserveAvailibility()"
                                                    class="font-bold text-sm sm:text-lg border border-blue-600 bg-blue-600 text-white hover:from-blue-700 hover:to-blue-900 focus:outline-none focus:ring-2 focus:ring-blue-300 rounded-2xl p-2 transition-transform transform hover:scale-105 shadow-md  opacity-90">
                                                    Reserve Now
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- location -->
                        <div class="items-center flex-col my-3 shadow bg-white rounded-sm hidden md:block">
                            <iframe width="100%" height="270" frameborder="0" scrolling="no" marginheight="0"
                                marginwidth="0"
                                :src="'https://maps.google.com/?q=' + hotelImg.lat + ',' + hotelImg.lon + '&hl=en&z=14&amp;output=embed'"></iframe>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <LoadingBar v-if="cancellationPolicyloader" />
        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="w-full bg-gradient-to-r from-sky-800 via-sky-600 to-sky-700 mb-2">
                <div class="flex">
                    <h2 class="text-white p-1 my-auto ml-6 font-semibold text-lg uppercase">
                        Cancellation Policy
                    </h2>
                    <div class="flex flex-1 mb-2 mr-4 justify-end">
                        <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer"
                            @click="closeModal()"></i>
                    </div>
                </div>
            </div>
            <div class="justify-center px-5" v-if="cancellationPolicyRetArr != ''"
                v-for="(cancellationPolicy, cancellationPolicyIndex) in cancellationPolicyRetArr"
                :key="cancellationPolicyIndex">
                <div class="grid grid-cols-9 gap-4 border-b border-gray-300 mb-4 md:mb-9 pb-2">
                    <div class="col-span-9 md:col-span-6">
                        <h1 class="font-bold text-base">Room Name: <span class="font-normal text-base">{{
                                cancellationPolicy.roomName }}</span></h1>
                    </div>
                    <div class="col-span-9 md:col-span-3">
                        <h1 class="font-bold text-base">Status: <span
                                :class="`font-normal text-base px-2 py-1 items-center rounded ${cancellationPolicy.status === 'Available' ? 'bg-green-500 text-white' : 'bg-red-600 text-white'}`">{{
                                cancellationPolicy.status }}</span></h1>
                    </div>
                    <div class="col-span-9 md:col-span-5 2xl:col-span-2">
                        <h1 class="font-bold text-base">Meal: <span class="font-normal text-base">{{
                                cancellationPolicy.meal }}</span></h1>
                    </div>
                    <div class="col-span-9 md:col-span-4 2xl:col-span-2 items-center">
                        <h1 class="font-bold text-base">Rate Type: <span
                                :class="`font-normal text-base px-2 py-1 items-center rounded ${cancellationPolicy.rateType === 'Refundable' ? 'bg-green-500 text-white' : 'bg-red-600 text-white'}`">{{
                                cancellationPolicy.rateType }}</span></h1>
                    </div>
                </div>
                <h2 class="">Conditions:</h2>
                <table class="w-full mb-3">
                    <thead class="border border-white bg-bgRGTBaseColor">
                        <tr class="*:text-center *:md:text-base *:font-bold *:text-white *:text-xs">
                            <th>From Date</th>
                            <th class="border border-white">To Date</th>
                            <th class="border border-white">From Time</th>
                            <th class="border border-white">To Time</th>
                            <th>Percentage</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(condition, conditionIndex) in cancellationPolicy.condition" :key="condition"
                            class="*:text-center *:md:text-base *:border *:border-gray-500 *:text-xs">
                            <td>{{ convertDate(condition.fromDate) }}</td>
                            <td>{{ convertDate(condition.toDate) }}</td>
                            <td>{{ condition.fromTime }}</td>
                            <td>{{ condition.toTime }}</td>
                            <td>{{ condition.percentage }} %</td>
                        </tr>
                    </tbody>
                </table>
                <div class="mb-9" v-if="cancellationPolicy.textCondition">
                    <h3 class="md:text-base text-xs">{{ cancellationPolicy.textCondition[0].textCondition }}</h3>
                </div>
                <div class="mb-2" v-if="cancellationPolicy.remarks">
                    <h3 class="text-gray-400 md:text-base text-xs">{{ cancellationPolicy.remarks[0].type }}: {{
                        cancellationPolicy.remarks[0].text }}</h3>
                </div>
            </div>
            <div class="justify-center px-5" v-else>
                <p class="py-3 text-rose-600 font-bold">No Policy Found for the selected Room!</p>
            </div>
        </Modal>
    </GuestLayout>
</template>

<script>
import Service from "@/Config/Service.js";
import { mapState } from "vuex";
import HotelCurrencyConverter from "@/Config/HotelCurrencyConverter.js";
import Modal from "@/Components/Modal.vue";
import moment from "moment";
import { parseInt } from "lodash";
export default {
    name: "CheapestBookingPage",
    data() {
        return {
            isScrolled: false,
            isReserveVisible: false,
            modifyModalPopup: false,
            isModalVisible: false,
            hotelShoppingDetails: [],
            modalWidth: "sm:w-[100%] md:w-[45%]",
            hotelImg: '',
            loading: false,
            payload: { type: Object },
            cancellationPolicyloader: false,
            cancellationPolicy: { type: Object },
            cancellationPolicyRetArr: [],
            guests: 0,
            totalNights: 0,
            selectedRooms: 0,
            avalibleroomKeys: [],
            selectedRoomPrice: [],
            selectedRoomDetails: {
                hotel_id: '',
                room_name: '',
                meal: '',
                rate_type: '',
                rate_key: '',
                status: '',
                marriage_identifier: '',
                reprice: '',
                is_price_breakup_available: '',
                is_cancelation_policy_availble: '',
            },
            mrkupDetails:{
                mkup: 0,
                mkType: ''
            },
            diff: [],
            avalibility: {
                code: 0,
                adultCount: '',
                childCount: '',
                infantCount: '',
                gross: 0,
                net: 0,
                tax: 0,
                eqgross: 0,
                eqnet: 0,
                eqtax: 0,
            }
        }
    },
    mounted() {
        window.addEventListener("scroll", this.handleScroll);
        this.hotelImg = JSON.parse(localStorage.getItem('hotelGeoLocation'));
        const hotelURLSearchParam = this.hotelURLSearchParams();
        this.payload = {
            'bckId': 0,
            'countryCode': hotelURLSearchParam.get('c'),
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
            'hotelDetails': JSON.parse(localStorage.getItem('hotelGeoLocation')),
            'hotelSessionId': sessionStorage.getItem('hotelSessionId'),
            'mobileNo': hotelURLSearchParam.get('pn'),
        };
        this.fetchHotels();
        this.guests = Number(this.payload.adultCount) + Number(this.payload.childCount);
        this.totalNights = hotelURLSearchParam.get('tn');

    },
    beforeDestroy() {
        window.removeEventListener("scroll", this.handleScroll);
    },
    computed: {
        ...mapState(['currency']),
        modifyClass() {
            return {
                hidden: !this.modifyModalPopup,
            }
        },

    },
    methods: {
        handleScroll() {
            const reserveButton = this.$refs.reserveButton;
            const reserveRect = reserveButton.getBoundingClientRect();
            this.isReserveVisible = reserveRect.top >= 0 && reserveRect.bottom <= (window.innerHeight || document.documentElement.clientHeight);
            this.isScrolled = window.scrollY > -1;
        },
        convertDate(date) {
            return moment(date).format('DD-MM-YYYY');
        },
        modifyModal() {
            this.modifyModalPopup = !this.modifyModalPopup;
        },
        showPolicy(key) {
            this.cancellationPolicy = {
                'hotelSessionId': sessionStorage.getItem('hotelSessionId'),
                'hotelCode': this.payload.hotelCode,
                'groupCode': this.payload.groupCode,
                'destinationCode': this.payload.destinationCode,
                'rateKey': key,
            };
            this.cancellationPolicyloader = true
            this.isModalVisible = true
            Service.doFetchRequest("/hotel/hotel-cancellation-policy", 'POST', this.cancellationPolicy).then((data) => {
                this.cancellationPolicyRetArr = data
                this.cancellationPolicyloader = false
            });
        },
        closeModal() {
            this.isModalVisible = false
        },
        fetchHotels() {
            this.loading = true
            Service.doFetchRequest("/hotel/shopping-details", '', this.payload).then((data) => {
                this.hotelShoppingDetails = data['hotelDetails']
                this.payload.bckId = data['bkingId']
                this.loading = false
            });
        },
        reserveAvailibility() {
            const query = "?c=" + this.payload.countryCode + "&rm=" + this.payload.rooms + "&tn=" + this.totalNights + "&des=" + this.payload.destinationCode + "&gc=" + this.payload.groupCode
                + "&hc=" + this.payload.hotelCode + "&chi=" + this.payload.checkInDate + "&cho=" + this.payload.checkOutDate + "&mka=" + this.mrkupDetails.mkup + "&mkt=" + this.mrkupDetails.mkType + "&ac=" + this.payload.adultCount + "&cc=" + this.payload.childCount
                + "&gam=" + this.avalibility.eqgross + "&nam=" + this.avalibility.eqnet + "&tam=" + this.avalibility.eqtax + "&ct=USD&bck=" + this.payload.bckId;
            window.location.href = "/hotel/shopping-details-retrieve" + query;
        },

        checkAvailibility(hotelDetail, hotelIndex) {
            this.diff.length = 0
            this.avalibleroomKeys.length = 0
            this.avalibility.gross = 0
            this.avalibility.net = 0
            this.avalibility.tax = 0
            this.avalibility.eqgross = 0
            this.avalibility.eqnet = 0
            this.avalibility.eqtax = 0
            let newHotelIndex = hotelIndex;
            let roomParse = parseInt(this.payload.rooms);
            const hotelRooms = (roomParse > 1 ?  roomParse +=hotelIndex : roomParse);
            for (const [hotelShoppingDetail, hotelShoppingDetailKey] of Object.entries(this.hotelShoppingDetails)) {
                if(hotelShoppingDetail === 'hotelInfo'){
                    this.mrkupDetails.mkup = hotelShoppingDetailKey.customeMarkup;
                    this.mrkupDetails.mkType = hotelShoppingDetailKey.customeMarkupType;
                }
                if (hotelShoppingDetail === 'rooms') {
                    for (const [hotelShoppingKey, hotelShopping] of Object.entries(hotelShoppingDetailKey.room)) {
                        if (hotelShoppingKey == newHotelIndex && hotelRooms > 1 && newHotelIndex < hotelRooms) {
                            this.diffRoomSelection(hotelShopping);
                            newHotelIndex +=1;
                        } else if (hotelShoppingKey == newHotelIndex && hotelRooms === 1) {
                            this.diffRoomSelection(hotelShopping);
                        }
                    }
                }
            }
        },
        diffRoomSelection: function (hotelShopping) {
            this.avalibleroomKeys.push(hotelShopping.rateKey)
            localStorage.setItem('rRK', JSON.stringify(this.avalibleroomKeys))
            this.diff.push(
                {
                    'gross': hotelShopping.price.gross,
                    'net': hotelShopping.price.net,
                    'tax': hotelShopping.price.tax,
                    'eqgross': hotelShopping.price.eqgross,
                    'eqnet': hotelShopping.price.eqnet,
                    'eqtax': hotelShopping.price.eqtax
                }
            );
            localStorage.setItem('avP', JSON.stringify(this.diff));
            this.avalibility.gross = hotelShopping.price.gross
            this.avalibility.net = hotelShopping.price.net
            this.avalibility.tax = hotelShopping.price.tax
            this.avalibility.eqgross = hotelShopping.price.eqgross
            this.avalibility.eqnet = hotelShopping.price.eqnet
            this.avalibility.eqtax = hotelShopping.price.eqtax
        },

        sumRooms(payloadRooms, selectedRooms, hotelIndex) {
            if (this.avalibleroomKeys[hotelIndex]) {
                return parseInt(payloadRooms)
            } else {
                return parseInt(payloadRooms) - parseInt(selectedRooms)
            }
        },
        hotelURLSearchParams: function () {
            return new URLSearchParams(window.location.search)
        },
        setConverter(amount, currencyRate) {
            let getUAECurrency = this.$page.props.currencies[0]
            if (this.currency.currencyCode !== "USD") {
                return HotelCurrencyConverter.doRequest(amount, currencyRate, getUAECurrency.currencyRate)
            } else {
                return eval(amount).toFixed()
            }
        },
    }
}
</script>
<style scoped>
.desktop-scroll {
  position: relative;
}

.fixed-bottom {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 50;
  padding-bottom: 20px;
}

@media (max-width: 768px) {
  .fixed-bottom {
    position: relative;
  }
}
</style>