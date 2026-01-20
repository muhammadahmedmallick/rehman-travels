<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue"
import LoadingBar from "./LoadingBar.vue";
import FixedLoadingBar from "./FixedLoadingBar.vue"
</script>
<template>
    <GuestLayout>
        <section>
            <div v-if="modifyModalPopup || filterModalPopup" @click="tryClose" class="lg:static fixed top-0 left-0 h-full lg:h-0 z-20 lg:z-0  w-full lg:w-0 bg-black bg-opacity-1"></div>
            <section class="sticky top-16 z-10 bg-bgRGTBaseColor shadow-xl">
                <div
                    class="flex justify-end lg:mb-4 py-2 gap-2 lg:hidden w-11/12 sm:max-w-[600px] md:max-w-[660px] lg:max-w-[982px] xl:max-w-[1230px] mx-auto">
                    <button type="button" @click="filterModal" data-dropdown-toggle="toggle-filterModalPopup"
                            class="flex justify-center items-center text-rGTBaseTextColor bg-white text-sm px-3 py-2 rounded-md">
                        <img src="/ticketing/filter.svg" class="mr-1" alt="">Filter Results
                    </button>
                    <button type="button" @click="modifyModal" data-dropdown-toggle="toggle-modifyModalPopup"
                            class="flex justify-center items-center text-rGTBaseTextColor bg-white text-sm px-3 py-2 rounded-md">
                        <img src="/ticketing/modify.svg" class="mr-1" alt=""> Modify Search
                    </button>
                </div>
            </section>
            <section class="lg:block sidebar-open sidebar-open-off fixed right-0 md:right-2 top-[4.5rem] lg:w-full lg:static z-20 lg:z-0 h-screen overflow-y-auto lg:overflow-y-visible lg:h-fit w-full sm:max-w-[600px] md:max-w-[660px] lg:max-w-[982px] xl:max-w-[1230px] mx-auto bg-white rounded-md py-2 px-4 lg:mt-3 shadow-[0_3px_10px_rgb(0,0,0,0.2)] border-dashed border-[#808080] lg:border-dashed lg:border-[#808080] border border-1"
                     :class="modifyClass">
                <div  class="mb-40 sm:mb-20 lg:mb-2 lg:mt-3">
                    <span class="text-3xl lg:hidden block cursor-pointer"  @click="closeModifyModalPopup()">
                        <span class="text-base font-bold float-right text-white bg-red-600 px-[0.7rem] py-1 rounded">X</span>
                    </span>
                    <FormInput> </FormInput>
                </div>
            </section>
            <LoadingBar v-if="cheapestFare.loading"></LoadingBar>
            <section  class="w-11/12 sm:max-w-[600px] md:max-w-[660px] lg:max-w-[982px] xl:max-w-[1230px] mx-auto lg:mt-2">
                <RollingCalendar v-if="$store.state.flightType !== 'multi-trip'" :mode="($store.state.flightType === 'round-trip' ? 'range' : 'single')" :obd="obd" :ibd="ibd" :payload="cheapestFare.payload" @update:selectedDate="handleDateChange" @navigate="onNavigate"> </RollingCalendar>
                <div class="col-span-12 sm:col-span-12 lg:col-span-12 text-center">
                        <span v-if="cheapestFare.responseError === ''" class="text-base font-bold text-[#05264e]">{{ loadingMsg }}
                            <!--<search-loader :is-record-found="cheapestFare.isRecordFounds.length > 0"></search-loader>-->
                            <loading-popup :is-record-found="cheapestFare.isRecordFounds.length > 0"></loading-popup>
                        </span>
                    <span v-else-if="cheapestFare.responseError !== ''" class="text-red-600 font-semibold">{{ cheapestFare.responseError }}</span>
                </div>
                <div class="grid grid-cols-12 lg:gap-8">
                    <div  v-if="cheapestFare.isRecordFounds.length !== 0" id="toggle-filterModalPopup" :class="filterClass" class="lg:block h-[32rem] sidebar-open sidebar-open-off fixed sm:right-5 top-[3.2rem] w-11/12 lg:static z-20 lg:z-0 lg:h-fit bg-white col-span-12 sm:col-span-12 md:col-span-5 lg:col-span-3 shadow-lg lg:px-3 pt-4 mt-6 border border-solid rounded-md border-1 border-gray-300">
                        <div class="overflow-auto lg:overflow-hidden pl-4 lg:pl-0 pr-4 lg:pr-0 h-[27.5rem] lg:h-fit">
                            <div class="border-b-[1px] border-dashed border-gray-500 pb-4 mb-4">
                                <div
                                    class="pb-0 flex justify-between items-center font-bold text-rGTBaseTextColor text-xl mb-2">
                                    Filter Your Results
                                    <span class="text-3xl lg:hidden cursor-pointer" @click="closeFilterModalPopup()">
                                        <span class="text-base font-bold float-right text-white bg-red-600 px-[0.7rem] py-1 rounded">X</span>
                                    </span>
                                </div>
                                <div class="text-gray-500 capitalize font-medium">{{ cheapestFareFlights.length }} Results found
                                </div>
                            </div>
                            <div v-if="cheapestFare.byStops.length !== 0"
                                 class="border-b-[1px] border-dashed border-gray-500 pb-4 mb-4">
                                <div class="font-bold text-rGTBaseTextColor text-xl">Stops</div>
                                <div class="pt-3">
                                    <div v-for="(byStops,byStopsKey) in cheapestFare.byStops" :key="byStopsKey"
                                         class="flex items-center">
                                        <div v-for="(byStop,byStopKey) in byStops" :key="byStopKey"
                                             class="flex items-center pl-1">
                                            <input v-model="cheapestFare.isStopPoint" :id="byStop.stopPoint+'-stop'"
                                                   :value="byStop.stopPoint" type="checkbox" name="bordered-checkbox"
                                                   class="w-4 h-4 cursor-pointer text-rGTBaseTextColor bg-gray-100 border-gray-300 rounded focus:ring-[#0181dd]"/>
                                            <label :for="byStop.stopPoint+'-stop'"
                                                   class="w-full py-1 ml-2">
                                                <div class="flex text-sm font-normal capitalize text-gray-700">
                                                    <span class="truncate w-28 font-medium">{{ byStop.stopPoint == 0 ? 'Direct' : byStop.stopPoint + ' Stop' }}  </span>
                                                    <span class="pl-2">{{currency.currencySymbol}} {{setConverter(byStop.totalFare, currency.currencyRate)}}
                                                    </span>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div v-if="cheapestFare.byVendors.length !== 0"
                                 class="border-b-[1px] border-dashed border-gray-500 pb-4 mb-4">
                                <div class="font-bold text-rGTBaseTextColor text-xl">Vendors</div>
                                <div class="pt-3">
                                    <div v-for="(byVendors,byVendorsKey) in cheapestFare.byVendors" :key="byVendorsKey"
                                         class="flex items-center">
                                        <div v-for="(byVendor,byVendorKey) in byVendors" :key="byVendorKey"
                                             class="flex items-center pl-1">
                                            <input v-model="cheapestFare.isVendor" :id="byVendor.supplier"
                                                   type="checkbox" :value="byVendor.supplier" name="bordered-checkbox"
                                                   class="w-4 h-4 cursor-pointer text-rGTBaseTextColor bg-gray-100 border-gray-300 rounded focus:ring-[#0181dd]"/>
                                            <label :for="byVendor.supplier"
                                                   class="w-full py-1 ml-1">
                                                <div class="flex text-sm capitalize text-gray-700">
                                                    <span class="truncate w-28 font-medium">{{ byVendor.supplier }} </span>
                                                    <span class="pl-2">{{currency.currencySymbol}} {{setConverter(byVendor.totalFare, currency.currencyRate)}}
                                                        </span>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div v-if="cheapestFare.byAirlines.length !== 0"
                                 class="border-b-[1px] border-dashed border-gray-500 pb-4 mb-4">
                                <div class="font-bold text-rGTBaseTextColor text-xl">Airlines</div>
                                <div class="pt-3">
                                    <div v-for="(byAirlines,byAirlinesKey) in cheapestFare.byAirlines"
                                         :key="byAirlinesKey" class="flex items-center">
                                        <div v-for="(byAirline,byAirlineKey) in byAirlines" :key="byAirlineKey"
                                             class="flex items-center pl-1">
                                            <input v-model="cheapestFare.isAirline" :id="byAirline.airType + ' ' + byAirline.airlineName + ' ' + byAirline.validatingCarrier" type="checkbox"
                                                   :value="byAirline.airType + ' ' + byAirline.airlineName + ' ' + byAirline.validatingCarrier"
                                                   name="bordered-checkbox"
                                                   class="w-4 h-4 cursor-pointer text-rGTBaseTextColor bg-gray-100 border-gray-300 rounded focus:ring-[#0181dd]"/>
                                            <label
                                                :for="byAirline.airType + ' ' + byAirline.airlineName + ' ' + byAirline.validatingCarrier"
                                                class="w-full py-1 ml-1">
                                                <div class="flex text-sm capitalize text-gray-700">
                                                    <span class="truncate w-28 font-medium">{{ byAirline.airlineName }} </span>
                                                    <span class="pl-2">{{currency.currencySymbol}} {{setConverter(byAirline.totalFare, currency.currencyRate)}}
                                                    </span>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div v-if="cheapestFare.byArrivalAirports.length !== 0"
                                 class="pb-4 mb-1">
                                <div class="font-bold text-rGTBaseTextColor text-xl"> Arrival Airports</div>
                                <div class="pt-3">
                                    <div
                                        v-for="(byArrivalAirports,byArrivalAirportsKey) in cheapestFare.byArrivalAirports"
                                        :key="byArrivalAirportsKey" class="mb-3">
                                        <p v-if="byArrivalAirports[0] != null" class="text-gray-700 font-semibold">
                                            {{ byArrivalAirports[0].airlineName }}</p>
                                        <div v-for="(byArrivalAirport,byArrivalAirportKey) in byArrivalAirports"
                                             :key="byArrivalAirportKey" class="flex items-center pl-1">
                                            <input v-model="cheapestFare.isArrivalAirport" :id="byArrivalAirports[0].airlineName + '_' +  byArrivalAirportKey"
                                                   type="checkbox"
                                                   :value="byArrivalAirport.airType + ' ' + byArrivalAirport.validatingCarrier + ' ' + byArrivalAirport.pointAirport"
                                                   name="bordered-checkbox"
                                                   class="w-4 h-4 cursor-pointer text-rGTBaseTextColor bg-gray-100 border-gray-300 rounded focus:ring-[#0181dd]"/>
                                            <label :for="byArrivalAirports[0].airlineName + '_' + byArrivalAirportKey"
                                                   class="w-full py-1 ml-1">
                                                <div class="flex text-sm capitalize text-gray-700">
                                                    <span class="truncate w-28 font-medium">{{ byArrivalAirport.pointAirport }} </span>
                                                    <span class="pl-2">{{currency.currencySymbol}} {{setConverter(byArrivalAirport.totalFare, currency.currencyRate)}}
                                                    </span>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="absolute w-full lg:static -bottom-3 flex justify-center mb-4 gap-5">
                            <button v-on:click="clearFilter()"
                                    class="bg-bgRGTBaseColor w-[60%] lg:w-full text-white left-3 px-4 py-2 rounded text-center duration-500 ease-in-out transition-colors  hover:bg-red-700 hover:duration-500 hover:ease-in-out hover:transition-colors">
                                Clear All Results
                            </button>
                            <button @click="closeFilterModalPopup()"
                                    class="lg:hidden bg-red-600 w-30 text-white px-4 py-2 rounded text-center duration-500 ease-in-out transition-colors  hover:bg-red-700 hover:duration-500 hover:ease-in-out hover:transition-colors">
                                Close
                            </button>
                        </div>
                    </div>
                    <div class="col-span-12 sm:col-span-12 lg:col-span-9 mt-4">
                        <div class="flex justify-between items-center">
                            <div class="py-2" v-if="cheapestFareFlights.length !=0"><span
                                class="text-base font-bold text-[#05264e]">Showing {{ cheapestFareFlights.length }} Search Results</span>
                            </div>
                            <div class="hidden sm:block">
                                <div class="bg-bgRGTBaseColor flex items-center justify-center rounded-md"
                                     v-if="cheapestFareFlights.length !=0">
                                    <div class="my-1 mx-2">
                                        <button
                                            :class="{'bg-white': cheapestFare.isOrderType === 'asc','text-rGTBaseTextColor': cheapestFare.isOrderType === 'asc','bg-bgRGTBaseColor': cheapestFare.isOrderType !== 'asc','text-[white]': cheapestFare.isOrderType !== 'asc'}"
                                            class="p-2 font-semibold text-sm rounded-md" @click="byOrderType('asc')">
                                            Lowest Price
                                        </button>
                                        <button
                                            :class="{'bg-white':cheapestFare.isOrderType === 'desc','text-rGTBaseTextColor':cheapestFare.isOrderType === 'desc','bg-bgRGTBaseColor': cheapestFare.isOrderType !== 'desc','text-[white]':cheapestFare.isOrderType !== 'desc'}"
                                            @click="byOrderType('desc')" class="p-2 font-semibold text-sm rounded-md">
                                            Most Popular
                                        </button>
                                        <button
                                            :class="{'bg-white': cheapestFare.isOrderType === 'OurTrending','text-rGTBaseTextColor': cheapestFare.isOrderType === 'OurTrending','bg-bgRGTBaseColor': cheapestFare.isOrderType !== 'OurTrending','text-[white]': cheapestFare.isOrderType !== 'OurTrending',}"
                                            @click="byOrderType('OurTrending')"
                                            class="p-2 font-semibold text-sm rounded-md">Our Trending
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--<div v-if="cheapestFare.responseError !== ''"-->
                        <!--     class="mt-10 text-red-600 font-semibold text-center lg:text-center lg:text-xl col-span-12 capitalize">-->
                        <!--    {{ cheapestFare.responseError }}-->
                        <!--</div>-->
                        <div class="grid grid-cols-12">
                            <div v-for="(cheapestFareFlight, cheapestFareFlightKey) in cheapestFareFlights" :key="cheapestFareFlightKey" class="col-span-12 bg-white rounded-md my-2 md:my-2 group duration-700">
                                <div v-if="cheapestFareFlightKey === 0" class="py-2 bg-green-600 rounded-t-md">
                                    <p class="text-white font-medium text-xs 2xl:text-sm ml-2">Cheapest Fare</p>
                                </div>
                                <div :class="`grid grid-cols-12 border border-1 border-dashed border-gray-500 ${cheapestFareFlightKey === 0 ? 'rounded-b-md' : 'rounded-md'}`">
                                    <div class="col-span-12 lg:col-span-9 flex flex-col justify-center">
                                        <div v-for="(availability, availabilityKey) in cheapestFareFlight.flightAvailabilities.legs" :key="availabilityKey"
                                             class="grid grid-cols-12 relative my-3 mx-4 xs:ml-6 sm:ml-8">
                                            <div
                                                class="col-span-3 xs:col-span-3 sm:col-span-4 flex items-center sm:items-start">
                                                <img class="xs:mr-1" :src="`/logos/${availability.marketingAirlines.split(',')[0].substring(0, 2)}.png`"/>
                                                <div class="flex flex-col">
                                                        <span
                                                            class="hidden xs:block text-sm xl:text-base font-bold text-gray-700">{{availability.marketingAirlines.split(',')[0]}}</span>
                                                    <span
                                                        class="hidden sm:block text-xs xl:text-[13px] text-gray-500 capitalize">Marketed By {{cheapestFareFlight.flightAvailabilities.price.airlineName}}</span>
                                                    <span
                                                        class="hidden sm:block text-xs xl:text-[13px] text-gray-500 capitalize">{{cheapestFareFlight.flightAvailabilities.legs[availabilityKey].segments[0].cabin}}</span>
                                                </div>
                                            </div>
                                            <div
                                                class="col-span-3 sm:col-span-2 flex justify-center items-center text-center">
                                                <div class="flex flex-col text-center">
                                                    <span class="text-[1.1rem] md:text-xl lg:text-xl xl:text-2xl font-medium m-0 leading-[1.2] uppercase">{{availability.departureAirport}}</span>
                                                    <span class="text-xs lg:text[13px] font-medium text-gray-400">{{setInitialDate(`${availability.departureDate} ${availability.departureTime}`,'h:mm a')}}</span>
                                                    <span class="text-xs lg:text[13px] font-medium text-gray-400">{{setInitialDate(availability.departureDate,'Do MMM YY')}}</span>
                                                </div>
                                            </div>
                                            <div
                                                class="col-span-3 flex flex-col items-center justify-center text-center relative">
                                                <p class="text-xs lg:text[13px] xl:text-sm text-gray-500 lg:leading-4 lg:px-1">
                                                    {{ availability.elapsedTime }}</p>
                                                <div class="border-b-2 border-dotted border-gray-300 w-full absolute">
                                                </div>
                                                <div class="w-full flex justify-center flex-col lg:block">
                                                    <img src="/ticketing/plane.svg" alt="Return-icon"
                                                         class="h-5 lg:mt-1 xl:mt-0 transform -translate-x-1 xl:-translate-x-3 lg:group-hover:translate-x-28 xl:group-hover:translate-x-[9rem] group-hover:transition group-hover:duration-1000 group-hover:ease-in-out transition duration-1000 ease-in-out"/>
                                                    <p class="text-xs lg:text-xs leading-4 text text-rGTBaseTextColor">
                                                        {{ availability.pointAirports }}</p>
                                                </div>
                                            </div>
                                            <div
                                                class="col-span-3 sm:col-span-2 flex justify-center items-center text-center">
                                                <div class="flex flex-col text-center">
                                                        <span class="text-[1.1rem] md:text-xl lg:text-xl xl:text-2xl font-medium m-0 leading-[1.2] uppercase">
                                                            {{ availability.arrivalAirport }}
                                                        </span>
                                                    <span class="text-xs lg:text[13px] font-medium text-gray-400"> {{ setInitialDate(`${availability.arrivalDate} ${availability.arrivalTime}`,'h:mm a') }}</span>
                                                    <span class="text-xs lg:text[13px] font-medium text-gray-400"> {{ setInitialDate(availability.arrivalDate,'Do MMM YY') }}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div
                                        class="relative col-span-12 lg:my-2 lg:col-span-3 flex flex-col justify-center border-t-[1px] lg:border-t-0 border-dashed border-[#808080] lg:border-l-[1px] lg:border-dashed lg:border-[#808080] px-3 py-2 lg:py-0 bg-white">
                                        <div class="grid grid-cols-12 justify-center items-center">
                                            <div class="col-span-7 xs:col-span-8 sm:col-span-9 lg:col-span-12">
                                                <div class="col-span-9 lg:col-span-12 flex lg:flex-col lg:mb-1">
                                                    <div v-if="cheapestFareFlight.flightAvailabilities.price.discount !== 0" class="justify-center relative lg:text-end hidden lg:block -top-[9px] mb-[2.2rem] 2xl:mb-[2.5rem]">
                                                        <span  class="text-[11px] sm:text-[12px] absolute -right-[12px] md:text-[15px] items-center justify-center rounded-bl-md px-1 py-[0.15rem] 2xl:py-1 flex bg-green-600 border border-b-[1px] border-white text-white font-medium">
                                                            <svg fill="#FFFFFF" width="20px" height="20px" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg" class="icon">
                                                            <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                                                            <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
                                                            <g id="SVGRepo_iconCarrier"><path d="M512 64C264.6 64 64 264.6 64 512s200.6 448 448 448 448-200.6 448-448S759.4 64 512 64zm0 820c-205.4 0-372-166.6-372-372s166.6-372 372-372 372 166.6 372 372-166.6 372-372 372zm47.7-395.2l-25.4-5.9V348.6c38 5.2 61.5 29 65.5 58.2.5 4 3.9 6.9 7.9 6.9h44.9c4.7 0 8.4-4.1 8-8.8-6.1-62.3-57.4-102.3-125.9-109.2V263c0-4.4-3.6-8-8-8h-28.1c-4.4 0-8 3.6-8 8v33c-70.8 6.9-126.2 46-126.2 119 0 67.6 49.8 100.2 102.1 112.7l24.7 6.3v142.7c-44.2-5.9-69-29.5-74.1-61.3-.6-3.8-4-6.6-7.9-6.6H363c-4.7 0-8.4 4-8 8.7 4.5 55 46.2 105.6 135.2 112.1V761c0 4.4 3.6 8 8 8h28.4c4.4 0 8-3.6 8-8.1l-.2-31.7c78.3-6.9 134.3-48.8 134.3-124-.1-69.4-44.2-100.4-109-116.4zm-68.6-16.2c-5.6-1.6-10.3-3.1-15-5-33.8-12.2-49.5-31.9-49.5-57.3 0-36.3 27.5-57 64.5-61.7v124zM534.3 677V543.3c3.1.9 5.9 1.6 8.8 2.2 47.3 14.4 63.2 34.4 63.2 65.1 0 39.1-29.4 62.6-72 66.4z"></path></g>
                                                        </svg>&nbsp;Save {{ setConverter(cheapestFareFlight.flightAvailabilities.price.discount, currency.currencyRate) }} /-  {{ currency.currencyCode }}</span>
                                                    </div>
                                                    <div class="lg:text-end">
                                                        <span class="text-black text-xl xs:text-[22px] sm:text-[26px] lg:text-3xl font-bold">
                                                            {{currency.currencySymbol}} {{setConverter(cheapestFareFlight.flightAvailabilities.price.publicFare, currency.currencyRate) }}
                                                        </span>
                                                    </div>
                                                    <div class="hidden lg:block mt-1 ml-2 lg:mt-0 lg:ml-0 lg:text-end">
                                                            <span
                                                                class="text-[11px] sm:text-[12px] md:text-[13px] text-[#ADB5BD] rounded-md"
                                                                v-if="cheapestFareFlight.flightAvailabilities.price.isRefundable=='false'">Non-Refundable</span>
                                                        <span
                                                            class="text-[11px] sm:text-[12px] md:text-[13px] text-[#ADB5BD] rounded-md"
                                                            v-else="cheapestFareFlight.flightAvailabilities.price.isRefundable =='true'">Refundable</span>
                                                    </div>
                                                </div>
                                                <div
                                                    class="col-span-9 lg:col-span-12 flex items-center lg:justify-end lg:-mt-1 lg:mb-1">
                                                    <a v-if="cheapestFareFlight.flightAvailabilities.price.airType !== 'Airpia'" @click="openFareRuleModal(cheapestFareFlight)"
                                                       class="flex justify-start cursor-pointer items-center capitalize text-[12px] md:text-[13px] xl:text-[14px]">
                                                        <span>Fare Rule</span>
                                                        <svg width="17px" height="17px" viewBox="0 0 24 24" fill="none"
                                                             xmlns="http://www.w3.org/2000/svg">
                                                            <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                                                            <g id="SVGRepo_tracerCarrier" stroke-linecap="round"
                                                               stroke-linejoin="round"></g>
                                                            <g id="SVGRepo_iconCarrier">
                                                                <path fill-rule="evenodd" clip-rule="evenodd"
                                                                      d="M4.29289 8.29289C4.68342 7.90237 5.31658 7.90237 5.70711 8.29289L12 14.5858L18.2929 8.29289C18.6834 7.90237 19.3166 7.90237 19.7071 8.29289C20.0976 8.68342 20.0976 9.31658 19.7071 9.70711L12.7071 16.7071C12.3166 17.0976 11.6834 17.0976 11.2929 16.7071L4.29289 9.70711C3.90237 9.31658 3.90237 8.68342 4.29289 8.29289Z"
                                                                      fill="#000000"></path>
                                                            </g>
                                                        </svg>
                                                    </a>  |
                                                    <a @click="openModal(cheapestFareFlight)"
                                                       class="flex justify-start cursor-pointer items-center capitalize text-[12px] md:text-[13px] xl:text-[14px]">
                                                        <span>Flights Details</span>
                                                        <svg width="17px" height="17px" viewBox="0 0 24 24" fill="none"
                                                             xmlns="http://www.w3.org/2000/svg">
                                                            <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                                                            <g id="SVGRepo_tracerCarrier" stroke-linecap="round"
                                                               stroke-linejoin="round"></g>
                                                            <g id="SVGRepo_iconCarrier">
                                                                <path fill-rule="evenodd" clip-rule="evenodd"
                                                                      d="M4.29289 8.29289C4.68342 7.90237 5.31658 7.90237 5.70711 8.29289L12 14.5858L18.2929 8.29289C18.6834 7.90237 19.3166 7.90237 19.7071 8.29289C20.0976 8.68342 20.0976 9.31658 19.7071 9.70711L12.7071 16.7071C12.3166 17.0976 11.6834 17.0976 11.2929 16.7071L4.29289 9.70711C3.90237 9.31658 3.90237 8.68342 4.29289 8.29289Z"
                                                                      fill="#000000"></path>
                                                            </g>
                                                        </svg>
                                                    </a>
                                                </div>
                                            </div>
                                            <div
                                                class="col-span-5 xs:col-span-4 sm:col-span-3 lg:col-span-12 lg:ml-7 xl:ml-10">
                                                <button v-on:click="cheapestFareFlightOrderCreate(cheapestFareFlight)"
                                                        class="bg-bgRGTBaseColor flex justify-center p-[5px_0px_4px_0px] w-full text-center order-first text-sm xl:text-base items-center capitalize rounded text-white py-2 md:py-3 cursor-pointer duration-500 ease-in-out transition-all hover:duration-500 hover:ease-in-out hover:transition-all hover:bg-green-500">
                                                    <span class="mr-1">Book Now</span>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <section class="relative z-20">
                <div v-if="ModalPopup" class="relative z-10" aria-labelledby="modal-title" role="dialog" aria-modal="true">
                    <div class="fixed right-0 inset-0 bg-gray-500 filter  bg-opacity-75 transition-opacity"></div>
                    <div class="fixed bg-white sidebar-open rounded right-0 top-20 lg:top-52 xl:top-32 w-full sm:w-4/5 lg:max-w-prose">
                        <div class="flex justify-between items-center py-3 px-4 border-b ">
                            <h3 class="text-xl font-semibold text-gray-900 capitalize">
                                Flights Details
                            </h3>
                            <button @click="closedModal" type="button" class="flex justify-center items-center size-7 text-base font-semibold rounded-full border border-transparent text-gray-800" data-hs-overlay="#hs-vertically-centered-modal">
                                <span class="sr-only">Close</span>
                                <svg class="flex-shrink-0 h-7 w-7 bg-red-600 rounded-lg text-white hover:bg-blue-600" xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M18 6 6 18"></path>
                                    <path d="m6 6 12 12"></path>
                                </svg>
                            </button>
                        </div>
                        <div class="h-[68vh] sm:h-[75vh] lg:h-[63vh] xl:h-[72vh] 2xl:h-[75vh] bg-gray-100 overflow-y-auto pb-12">
                            <section v-for="(leg, legKey) in legs" :key="legKey">
                                <div
                                    class="flex justify-between items-center p-5 px-6 bg-[#f3f3f3] shadow-[-2px_1px_5px_0px_#e9e9e9]">
                                    <div>
                                        <p class="text-xl font-semibold capitalize">{{ (legKey == 'leg1' ? 'Departure ' : 'Return') }}</p>
                                    </div>
                                    <div class="pr-6 font-semibold">
                                        <p class="text-sm text-gray-800">Total Duration:
                                            <span class="text-sm text-gray-600">{{ legs[legKey].elapsedTime}}</span>
                                        </p>
                                    </div>
                                </div>
                                <div v-for="(segment, segmentKey) in leg.segments" :key="segmentKey" class="mb-5">
                                    <div class="grid grid-cols-12 bg-white mx-4 shadow-[-2px_1px_5px_0px_#e9e9e9]">
                                        <div class="col-span-4 pt-5 pb-5 pl-1 lg:col-span-3 border-r-[1px] border-dashed border-gray-700">
                                            <p class="text-xl font-semibold pl-1 sm:pl-4"> {{setInitialDate(segment.departureDate,'D MMM YY') }} </p>
                                            <p class="text-xl font-semibold pl-1 sm:pl-4">
                                                {{ setInitialDate(`${segment.departureDate} ${segment.departureTime.substring(0, 5)}`,'h:mm a') }}</p>
                                        </div>
                                        <div class="col-span-7 lg:col-span-9 pt-3 pb-3 pl-6 lg:pl-10"
                                             style="position: relative;">
                                            <p class="capitalize text-base font-semibold ">
                                                {{ segment.departureAirportCode }}</p>
                                            <p class="capitalize text-xs sm:text-sm text-gray-600">
                                                {{ segment.departureCity }}<span class="uppercase font-semibold"> ({{ (segment.departureAirportCode) }})</span>
                                            </p>
                                            <div
                                                class="bg-white border border-1 border-solid border-[#6d7682] rounded-full h-4 w-4 m-[0_-8px] absolute top-0 left-0"></div>
                                        </div>
                                    </div>
                                    <div
                                        class="grid grid-cols-12 mx-4 bg-[#f3f3f3] shadow-[-2px_1px_5px_0px_#e9e9e9]">
                                        <div
                                            class="col-span-4 lg:col-span-3 pl-4 lg:pl-8  flex items-center text-gray-700 text-sm border-r-[1px] border-dashed border-gray-700">
                                            {{ segment.durationTime }}
                                        </div>
                                        <div class="col-span-8 lg:col-span-9">
                                            <div
                                                class="pl-6 pt-3 border-b-[1px] border-solid border-gray-300 lg:mx-4">
                                                <p class="pb-2 text-sm font-semibold">{{ segment.cabin }}</p>
                                                <div v-for="(baggage, baggageKey) in baggageAllowances[legKey].segments"
                                                     :key="baggageKey">
                                                    <p class="pt-1 text-xs sm:text-sm text-gray-600">
                                                        <i class="fa-solid fa-briefcase pe-3"></i>
                                                        {{ baggage.fareType }}
                                                    </p>
                                                    <p class="pt-1 pb-3 text-xs sm:text-sm text-gray-600">
                                                        <i class="fas fa-luggage-cart pe-2"></i>
                                                        {{ baggage.baggageAllowance }}
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="relative">
                                                <i class="fa fa-plane rotate-90 text-gray-700 absolute -top-[1.4rem] -left-[0.6rem]"></i>
                                            </div>
                                            <div class="pl-2 lg:pl-6 pt-3 mx-4">
                                                <i class="fa fa-plane rotate-270 text-gray-600"></i>
                                                <span
                                                    class="pl-2 pt-1 text-xs sm:text-sm text-gray-900"> {{segment.marketingAirlineCode}}  -  {{ segment.marketingFlightNumber }}  </span>
                                                <p class="pl-7 pt-1 pb-3 text-xs sm:text-sm text-gray-600">Aircraft
                                                    - {{ segment.aircraftCode }} </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div
                                        class="grid grid-cols-12 bg-white rounded-bl-xl rounded-br-xl mx-4 shadow-[-2px_1px_5px_0px_#e9e9e9]">
                                        <div
                                            class="col-span-4 pt-5 pb-5 pl-1 lg:col-span-3 border-r-[1px] border-dashed border-gray-700">
                                            <p class="text-xl font-semibold pl-1 sm:pl-4">
                                                {{ setInitialDate(`${segment.arrivalDate} ${segment.arrivalTime.substring(0, 5)}`,'h:mm a') }}</p>
                                        </div>
                                        <div class="col-span-7 lg:col-span-9 pt-3 pb-3 pl-6 lg:pl-10"
                                             style="position: relative;">
                                            <p class="capitalize text-base font-semibold">
                                                {{ segment.arrivalAirportCode }}</p>
                                            <p class=" capitalize text-xs sm:text-sm text-gray-600">
                                                {{ segment.arrivalCity }} <span
                                                class="uppercase font-semibold">( {{segment.arrivalAirportCode}})</span>
                                            </p>
                                            <div
                                                class="bg-white border border-1 border-solid border-[#6d7682] h-4 w-4 m-[0_-8px] absolute bottom-0 left-0 rounded-full"></div>
                                        </div>
                                    </div>
                                </div>
                            </section>
                        </div>
                        <div class="sticky bottom-0 flex justify-center sm:justify-end  py-2 px-4 border-t border-gray-300 bg-white">
                            <button @click="closedModal" type="button" class="py-2 w-11/12 sm:w-[200px] text-sm font-semibold rounded-lg border border-transparent bg-blue-600 text-white hover:bg-blue-700 disabled:opacity-50 disabled:pointer-events-none">
                                Back
                            </button>
                        </div>
                    </div>
                </div>
            </section>
            <section>
                <div v-if="cheapestFlightFareRule.modalPopup" class="relative z-10" aria-labelledby="modal-title" role="dialog" aria-modal="true">
                    <div class="fixed right-0 inset-0 bg-gray-500 filter  bg-opacity-75 transition-opacity"></div>
                    <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
                        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
                            <div class="absolute sidebar-open right-0 top-[4.5rem] sm:top-10 md:top-8 lg:top-24 overflow-hidden bg-[#fafafa] rounded-tl-xl rounded-tr-xl text-left shadow-xl transition-all sm:my-8 md:w-3/4 lg:w-full 2xl:w-2/6">
                                <div class="z-10 bg-white flex items-center justify-end p-4 md:p-5 border-b rounded-t">
                                    <h3 class="text-xl font-semibold text-gray-900  capitalize">Flight Fare Rule Details</h3>
                                    <button v-on:click="closedFareRuleModal()" type="button"
                                            class="text-white hover:bg-bgRGTBaseColor bg-red-600 hover:text-white rounded-lg text-xl w-8 h-8 ms-auto inline-flex justify-center items-center"
                                            data-modal-hide="default-modal">X
                                    </button>
                                </div>
                                <section class="mt-4">
                                    <div class="mb-5">
                                        <p class="text-center">{{cheapestFlightFareRule.isWaitingResponse}}</p>
                                        <div class="grid grid-cols-12 bg-white mx-4 shadow-[-2px_1px_5px_0px_#e9e9e9]">
                                            <div class="col-span-12 bg-[#f3f3f3] shadow-[-2px_1px_5px_0px_#e9e9e9]">
                                                <FixedLoadingBar v-if="cheapestFlightFareRule.loading"> </FixedLoadingBar>
                                                <v-pdf ref="fareRuleToPdf" :options="pdfOptions" :filename="exportFilename">
                                                    <div ref="fareRuleToPrint" id="fareRuleToPrint" v-if="cheapestFlightFareRule.isRecordFounds.length !== 0 && cheapestFlightFareRule.isRecordFounds.length !== undefined" class="grid grid-cols-12 gap-2">
                                                        <div v-for="(cheapestFareFlightFareRuleLegs, cheapestFareFlightFareRuleKey) in cheapestFlightFareRule.isRecordFounds[0].legs" :key="cheapestFareFlightFareRuleKey" :class="`px-4 col-span-12 shadow-[-2px_1px_5px_0px_#e9e9e9] border border-1 border-[#d1d9e3] border-solid`" >
                                                            <div>
                                                                <p  class="font-bold text-black text-center bg-white mx-4 shadow-[-2px_1px_5px_0px_#e9e9e9]" v-if="cheapestFareFlightFareRuleKey === 'leg2'">Inbound Fare Rule Details</p>
                                                                <p  class="font-bold text-black text-center bg-white mx-4 shadow-[-2px_1px_5px_0px_#e9e9e9]" v-if="cheapestFareFlightFareRuleKey !== 'leg2'">Outbound Fare Rule Details</p>
                                                            </div>
                                                            <div  v-for="(cheapestFareFlightFareRuleLeg, cheapestFareFlightFareRuleLegKey) in cheapestFareFlightFareRuleLegs.penalties" :key="cheapestFareFlightFareRuleLegKey">
                                                                <p class="font-bold text-black">{{cheapestFareFlightFareRuleLeg.title}}</p>
                                                                <p class="text-sm">{{cheapestFareFlightFareRuleLeg.text}}</p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </v-pdf>
                                                <div v-if="cheapestFlightFareRule.responseError !== 0 && cheapestFlightFareRule.isRecordFounds.length === 0 && cheapestFlightFareRule.isRecordFounds.length !== undefined">{{cheapestFlightFareRule.responseError}}</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div v-if="cheapestFlightFareRule.isRecordFounds.length !== 0 && cheapestFlightFareRule.isRecordFounds.length !== undefined" class="flex items-center justify-center mt-10">
                                        <button  v-on:click="openMailModal" class="btn flex items-center justify-center h-12 w-12 sm:w-14 sm:h-14 md:w-16 md:h-16 lg:w-20 lg:h-20 bg-white border-[#262626] border-2 text-xl sm:text-2xl md:text-3xl lg:text-4xl mx-4 md:mx-7 lg:mx-10 rounded-full relative overflow-hidden z-10  before:bg-[#0181dd] hover:before:top-0 before:duration-500 before:absolute before:top-20 before:left-0 before:w-full before:h-full before:z-20 cursor-pointer">
                                            <i class="fa fa-envelope relative text-gray-700 duration-500 z-30"></i>
                                        </button>
                                        <button v-print="'#fareRuleToPrint'" class="btn flex items-center justify-center h-12 w-12 sm:w-14 sm:h-14 md:w-16 md:h-16 lg:w-20 lg:h-20 bg-white border-[#262626] border-2 text-xl sm:text-2xl md:text-3xl lg:text-4xl mx-4 md:mx-7 lg:mx-10 rounded-full relative overflow-hidden z-10  before:bg-[#0181dd] hover:before:top-0 before:duration-500 before:absolute before:top-20 before:left-0 before:w-full before:h-full before:z-20 cursor-pointer">
                                            <i class="fa fa-print icon relative text-gray-700 duration-500 z-30"></i>
                                        </button>
                                        <button v-on:click="exportToPDF" class="btn flex items-center justify-center h-12 w-12 sm:w-14 sm:h-14 md:w-16 md:h-16 lg:w-20 lg:h-20 bg-white border-[#262626] border-2 text-xl sm:text-2xl md:text-3xl lg:text-4xl mx-4 md:mx-7 lg:mx-10 rounded-full relative overflow-hidden z-10  before:bg-[#0181dd] hover:before:top-0 before:duration-500 before:absolute before:top-20 before:left-0 before:w-full before:h-full before:z-20 cursor-pointer">
                                            <i class="fa fa-file-pdf relative text-gray-700 duration-500 z-30"></i>
                                        </button>
                                    </div>
                                </section>
                                <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row sm:px-6">
                                    <button v-on:click="closedFareRuleModal()" type="button" class="mt-3 inline-flex w-full justify-center rounded-md bg-bgRGTBaseColor px-3 py-2 text-sm font-semibold text-white shadow-sm sm:mt-0">
                                        Close
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </section>
        <section>
            <div v-if="cheapestMail.modalPopup" class="relative z-10" aria-labelledby="modal-title" role="dialog"
                 aria-modal="true">
                <div class="fixed right-0 inset-0 bg-gray-500 filter  bg-opacity-75 transition-opacity"></div>
                <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
                    <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
                        <div
                            class="absolute sidebar-open right-0 top-[4.5rem] sm:top-10 md:top-8 lg:top-24 overflow-hidden bg-[#fafafa] rounded-tl-xl rounded-tr-xl text-left shadow-xl transition-all sm:my-8 md:w-3/4 lg:w-2/4 2xl:w-2/6">
                            <div style="width: -webkit-fill-available;" class="z-10 bg-white flex items-center justify-between p-4 md:p-5 border-b rounded-t">
                                <h3 class="text-xl font-semibold text-gray-900  capitalize">Send Fare Rule</h3>
                                <button v-on:click="closedMailModal()" type="button"
                                        class="text-white hover:bg-bgRGTBaseColor bg-red-600 hover:text-white rounded-lg text-xl w-8 h-8 ms-auto inline-flex justify-center items-center"
                                        data-modal-hide="default-modal">X
                                </button>
                            </div>
                            <section class="mt-4">
                                <FixedLoadingBar v-if="cheapestMail.loading"> </FixedLoadingBar>
                                <div class="col-span-12 sm:col-span-6 lg:col-span-5 mb-2">
                                    <div class="relative mx-2 z-0">
                                        <input type="email" id="email-address" v-model="cheapestMail.email"
                                               v-on:input="isEmpty()"
                                               v-on:change="isEmpty()"
                                               :class="`${(cheapestMail.error === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} block px-2.5 pb-2.5 pt-4 w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-lg  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                                               v-on:keypress="isValidEmail"
                                               placeholder=""
                                               autoComplete="off"
                                        />
                                        <label for="email-address" class="absolute text-base text-gray-500 duration-300 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white px-2 peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                            Email Address</label>
                                    </div>
                                </div>
                                <div class="col-span-12 mb-4 lg:mb-0 flex justify-center">
                                    <button v-on:click="sendMail" type="button" class=" border border-solid cursor-pointer relative inline-flex items-center justify-start py-3 pl-4 pr-12 overflow-hidden font-semibold text-white transition-all duration-500 ease-in-out rounded hover:pl-10 hover:pr-6 bg-bgRGTBaseColor group">
                                        <span class="absolute bottom-0 left-0 w-full transition-all bg-green-600 duration-500 ease-in-out group-hover:h-full"></span>
                                        <span class="absolute right-0 pr-4 duration-500 ease-out group-hover:translate-x-12">
                                    <i class="fa-solid fa-arrow-right text-white"></i></span>
                                        <span class="absolute left-0 pl-2.5 -translate-x-12 group-hover:translate-x-0 ease-out duration-500">
                                    <i class="fa-solid fa-arrow-right text-white"></i>
                                </span>
                                        <span  class="relative w-full text-left transition-colors duration-500 ease-in-out group-hover:text-white">Send</span>
                                    </button>
                                </div>
                            </section>
                            <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row sm:px-6">
                                <button v-on:click="closedMailModal()" type="button"
                                        class="mt-3 inline-flex w-full justify-center rounded-md hover:bg-bgRGTBaseColor bg-red-600 px-3 py-2 text-sm font-semibold text-white shadow-sm sm:mt-0">
                                    Back
                                </button>
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
import CurrencyConverter from "@/Config/CurrencyConverter.js";
import FormInput from "@/Layout/Website/FormInput.vue"
import RollingCalendar from "@/Layout/Website/RollingCalendar.vue"
import {mapState} from "vuex";
import moment from "moment";
export default {
    components: {
        FormInput,RollingCalendar
    },
    data() {
        const params = new URLSearchParams(window.location.search);
        return {
            loadingMsg:"",
            obd: params.get("obd") || "",
            ibd: params.get("ibd") || "",
            tripType: params.get("ft") || "round-trip",
            isTripType:'one-way',
            providers:[],
            filterModalPopup: false,
            modifyModalPopup: false,
            ModalPopup: false,
            legs: "",
            flightType: "lowestPrice",
            cheapestFareModelType: "flight",
            travelers: 0,
            searchInput: {
                "cheapestFareFlight": {type: Object},
                "cheapestFareFlightCurrency": {type: Object},
                "airURLSearchParams": "",
                "flightType": "",
                "departureAirportCode": "",
                "arrivalAirportCode": "",
                "outboundDate": "",
                "inboundDate": "",
                "cabinType": "",
                "currencyType": "",
                "currencyRate": "",
                "currencyCode": "",
                "adultsCount": "",
                "childrenCount": "",
                "infantsCount": "",
                "passengers": "",
                "sectorType": "",
                "markupType": "b2c"
            },
            cheapestFare: {
                isCsrfToken: {type: String},
                loading: false,
                isOrderType: "asc",
                isErrorFounds: [],
                isRecordFounds: [],
                isNoRecordFounds: [],
                responseError: "",
                isActive: false,
                isFilterSearch: "none",
                payload: {type: Object},
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
            pdfOptions:{
                image: {type: 'jpeg',quality: 1},
                html2canvas: { scale: 3 },
                jsPDF: {unit: 'mm',format: 'a4',orientation: 'p'},
            },
            exportFilename: 'flight-fare-rule-details.pdf',
            cheapestMail: {
                modalPopup:false,
                loading:false,
                email:'',
                error:'',
                fareRules:''
            },
        };
    },
    mounted() {
        this.isTripType = this.airURLSearchParams().get("ft");
        const params = new Map(new URL(location.href).search.slice(1).split('&').map(pair => pair.split('=')));
        const queryString = Array.from(params.entries())
            .map(([key, value]) => {
                if (value !== undefined) {
                    const cleanKey = key.replace(/[^a-z]/gi, '');
                    const cleanValue = value.replace(/[^a-zA-Z0-9-,.]/g, '');
                    return `${cleanKey}=${cleanValue}`;
                }
                return null;
            }).filter(Boolean).join('&');
        window.history.replaceState(null, '', `${window.location.pathname}?${queryString}`);
        this.providers = this.$page?.props?.providers?.split(",") || [];
        this.isCsrfToken = window.Laravel.csrfToken;
        const airURLSearchParam = this.airURLSearchParams();
        this.cheapestFare.payload = {
            'departureCode': airURLSearchParam.get("ol"),
            'arrivalCode': airURLSearchParam.get("dl"),
            'outboundDate': airURLSearchParam.get("obd"),
            'inboundDate': airURLSearchParam.get("ibd"),
            'cabin': airURLSearchParam.get("cbn"),
            'stop': airURLSearchParam.get("stp"),
            'currencyCode':airURLSearchParam.get("ct"),
            'adultsCount': Number(airURLSearchParam.get("ac")),
            'childrenCount': Number(airURLSearchParam.get("cc")),
            'infantsCount': Number(airURLSearchParam.get("ic")),
            'tripType': airURLSearchParam.get("ft"),
            'locale': "ar"
        };
        // Use new chunked API (single backend call with polling)
        // To revert to old implementation, change to: this.airShopping()
        this.airShoppingChunked();
        this.travelers = Number(this.searchInput.adultsCount) + Number(this.searchInput.childrenCount) + Number(this.searchInput.infantsCount) + " Traveler" + (this.searchInput.passengers != 1 ? 's' : '');
    },
    computed: {
        ...mapState(['currency', 'searchQuery']),
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
        cheapestFareFlights: function () {
            if (this.cheapestFare.isRecordFounds.length !== 0) {
                let availabilities = [];
                let cheapestFareFlightInfos = [];
                for (const [flightAvailabilityKey, flightAvailabilities] of Object.entries(this.cheapestFare.flightAvailabilities)) {
                    for (const [availabilityKey, flightAvailability] of Object.entries(flightAvailabilities)) {
                        if (flightAvailability.price !== undefined) {
                            if (
                                (this.cheapestFare.isStopPoint.length === 0 || this.cheapestFare.isStopPoint.includes(flightAvailability.stopPoints)) &&
                                (this.cheapestFare.isVendor.length === 0 || this.cheapestFare.isVendor.includes(flightAvailability.price.supplier)) &&
                                (this.cheapestFare.isAirline.length === 0 || this.cheapestFare.isAirline.includes(flightAvailability.price.airType + ' ' + flightAvailability.price.airlineName + ' ' + flightAvailability.price.validatingCarrier)) &&
                                (this.cheapestFare.isArrivalAirport.length === 0 || this.cheapestFare.isArrivalAirport.includes(flightAvailability.price.airType + ' ' + flightAvailability.price.validatingCarrier + ' ' + flightAvailability.legs.leg1.pointAirports))
                            ) {
                                availabilities.push({
                                    'totalFare': eval(flightAvailability.price.publicFare),
                                    'flightAvailabilities': JSON.parse(JSON.stringify(flightAvailability)),
                                });
                            }
                            cheapestFareFlightInfos.push({
                                airType: flightAvailability.price.airType,
                                supplier: flightAvailability.price.supplier,
                                airlineName: flightAvailability.price.airlineName,
                                validatingCarrier: flightAvailability.price.validatingCarrier,
                                pointAirport: flightAvailability.legs.leg1.pointAirports,
                                stopPoint: flightAvailability.stopPoints,
                                totalFare: eval(flightAvailability.price.publicFare)
                            })
                            this.cheapestFare.byStops = _.orderBy(cheapestFareFlightInfos, "totalFare", this.cheapestFare.isOrderType).filter((value, index, self) => {
                                return self.findIndex((v) => v.stopPoint === value.stopPoint) === index
                            }).reduce(function (obj, cheapestFareFlightInfo) {
                                obj[cheapestFareFlightInfo.stopPoint] = obj[cheapestFareFlightInfo.stopPoint] || [];
                                obj[cheapestFareFlightInfo.stopPoint].push({
                                    "stopPoint": cheapestFareFlightInfo.stopPoint,
                                    "totalFare": cheapestFareFlightInfo.totalFare
                                });
                                return obj;
                            }, {});
                            this.cheapestFare.byVendors = _.orderBy(cheapestFareFlightInfos, "totalFare", this.cheapestFare.isOrderType).filter((value, index, self) => {
                                return self.findIndex((v) => v.supplier === value.supplier) === index
                            }).reduce(function (obj, cheapestFareFlightInfo) {
                                obj[cheapestFareFlightInfo.supplier] = obj[cheapestFareFlightInfo.supplier] || [];
                                obj[cheapestFareFlightInfo.supplier].push({
                                    "supplier": cheapestFareFlightInfo.supplier,
                                    "totalFare": cheapestFareFlightInfo.totalFare
                                });
                                return obj;
                            }, {});
                            this.cheapestFare.byAirlines = _.orderBy(cheapestFareFlightInfos, "totalFare", this.cheapestFare.isOrderType).filter((value, index, self) => {
                                return self.findIndex((v) => v.airType === value.airType && v.airlineName === value.airlineName) === index
                            }).reduce(function (obj, cheapestFareFlightInfo) {
                                obj[cheapestFareFlightInfo.airlineName + ' ' + cheapestFareFlightInfo.airType] = obj[cheapestFareFlightInfo.airlineName] || [];
                                obj[cheapestFareFlightInfo.airlineName + ' ' + cheapestFareFlightInfo.airType].push({
                                    "airType": cheapestFareFlightInfo.airType,
                                    "airlineName": cheapestFareFlightInfo.airlineName,
                                    "validatingCarrier": cheapestFareFlightInfo.validatingCarrier,
                                    "totalFare": cheapestFareFlightInfo.totalFare
                                });
                                return obj;
                            }, {});

                            this.cheapestFare.byArrivalAirports = _.orderBy(cheapestFareFlightInfos, "totalFare", this.cheapestFare.isOrderType).filter((value, index, self) => {
                                return self.findIndex((v) => v.pointAirport === value.pointAirport && v.airlineName === value.airlineName) === index
                            }).reduce(function (obj, cheapestFareFlightInfo) {
                                obj[cheapestFareFlightInfo.airlineName] = obj[cheapestFareFlightInfo.airlineName] || [];
                                obj[cheapestFareFlightInfo.airlineName].push({
                                    "airType": cheapestFareFlightInfo.airType,
                                    "airlineName": cheapestFareFlightInfo.airlineName,
                                    "validatingCarrier": cheapestFareFlightInfo.validatingCarrier,
                                    "pointAirport": cheapestFareFlightInfo.pointAirport,
                                    "totalFare": cheapestFareFlightInfo.totalFare
                                });
                                return obj;
                            }, {});
                        }
                    }
                }
                // const uniqueFares = Array.from(new Map(availabilities.map(item => [item.totalFare, item])).values());
                // uniqueFares.sort((a, b) => a.totalFare - b.totalFare);
                // return _.orderBy(uniqueFares, "totalFare", this.cheapestFare.isOrderType);
                return _.orderBy(availabilities, "totalFare", this.cheapestFare.isOrderType);
            } else {
                if (this.cheapestFare.isNoRecordFounds.length === this.providers && this.cheapestFare.isNoRecordFounds.includes("notfound") === false) {
                    this.cheapestFare.responseError = "No Flight Found In Your Selected Date, Please Modify Search";
                    this.finish(false);
                }
                return [];
            }
        }
    },
    methods: {
        handleDateChange(selectedDate) {
            if (selectedDate) {
                const params = new URLSearchParams(window.location.search);
                if (selectedDate.includes("-")) {
                    const [newObd, newIbd] = selectedDate.split(" - ").map(s => s.trim());
                    params.set("obd", newObd);
                    this.searchQuery[0].obdDate = newObd
                    if(newIbd){
                        params.set("ibd", newIbd);
                        this.searchQuery[0].ibdDate = newIbd
                    }
                    this.$store.dispatch("searchQuery", this.searchQuery)
                } else {
                    params.set("obd", selectedDate);
                    this.searchQuery[0].obdDate = selectedDate
                    this.$store.dispatch("searchQuery", this.searchQuery)
                }
                const newUrl = `${window.location.pathname}?${params.toString()}`;
                window.history.replaceState(null, "", newUrl);
                window.location.reload();
            }
        },
        onNavigate(newObd) {
            if (newObd) {
                const params = new URLSearchParams(window.location.search);
                params.set("obd", newObd);
                const newUrl = `${window.location.pathname}?${params.toString()}`;
                window.history.replaceState(null, "", newUrl);
                window.location.reload();
            }
        },
        cheapestFareFlightOrderCreate(cheapestFareFlight) {
            localStorage.setItem("cheapestFareFlight", JSON.stringify(cheapestFareFlight));
            localStorage.setItem("currencyCode", this.currencyCode);
            localStorage.setItem("currencyRate", this.currencyRate);
            localStorage.setItem("currencySymbol", this.currencySymbol);
            window.location.href = "/ticketing/cheapest-fare-flight-order-create" + this.cheapestFareFlightOrderCreateParams();
        },
        async airShoppingChunked() {
            this.finish(true);
            Object.assign(this, {responseError: '', progress: 0, loadingMsg: "Searching for the best available fares..."});
            Object.assign(this.cheapestFare, {responseError: '', flightAvailabilities: [], isNoRecordFounds: [], isRecordFounds: []});

            if (!this.providers || this.providers.length === 0) {
                this.responseError = "No providers available for flight search.";
                this.finish(false);
                return;
            }

            let searchId = null;
            let lastResultCount = 0;
            const maxPollingAttempts = 50;
            let pollingAttempts = 0;

            const pollForResults = async () => {
                try {
                    const payload = {
                        ...this.cheapestFare.payload,
                        providers: this.providers.join(','),
                        searchId: searchId,
                        lastCount: lastResultCount
                    };

                    const response = await fetch("/ticketing/chunked-flight-search", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                            "X-CSRF-TOKEN": this.isCsrfToken,
                            "Accept": "application/json"
                        },
                        body: JSON.stringify(payload)
                    });

                    const result = await response.json();

                    if (response.status !== 200) {
                        this.responseError = result.error || "Failed to fetch flight data";
                        this.finish(false);
                        return;
                    }

                    // Store search ID for subsequent polls
                    if (!searchId) {
                        searchId = result.searchId;
                    }

                    // Process new results
                    if (result.latestResult && result.latestResult.data) {
                        this.cheapestFare.flightAvailabilities.push(result.latestResult.data);
                        this.cheapestFare.isRecordFounds.push({found: true});
                    }

                    // Update progress
                    if (result.totalProviders > 0) {
                        this.progress = Math.round((result.processedCount / result.totalProviders) * 100);
                        this.loadingMsg = `Searching ${result.processedCount}/${result.totalProviders} providers...`;
                    }

                    lastResultCount = result.data.length;

                    // Continue polling if fetchMore is true
                    if (result.fetchMore && pollingAttempts < maxPollingAttempts) {
                        pollingAttempts++;
                        // Poll again after short delay
                        await new Promise(resolve => setTimeout(resolve, 500));
                        await pollForResults();
                    } else {
                        // Search complete
                        if (this.cheapestFare.flightAvailabilities.length === 0) {
                            this.cheapestFare.responseError = "No flights are available on the selected dates. Please consider choosing alternative dates.";
                        } else {
                            this.loadingMsg = "The lowest priced fares are displayed at the top.";
                        }
                        this.finish(false);
                    }

                } catch (error) {
                    console.error("Flight search error:", error);
                    this.responseError = "A network error occurred. Please try again.";
                    this.finish(false);
                }
            };

            // Start the polling process
            await pollForResults();
        },
        async airShopping() {
            this.finish(true);
            Object.assign(this, {responseError: '',progress: 0,loadingMsg: "Searching for the best available fares...",});
            Object.assign(this.cheapestFare, {responseError: '',flightAvailabilities: [],isNoRecordFounds: [],isRecordFounds: [],});
            const concurrencyLimit = 3;
            const totalProviders = this.providers?.length ?? 0;
            const processedProviders = [];
            if (totalProviders === 0) {
                this.responseError = "No providers available for flight search.";
                this.finish(false);
                return;
            }
            const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
            const fetchProviderData = async (supplier) => {
                try {
                    const response = await Service.doFetch("/ticketing/cheapest-fare-airshopping-request",supplier,this.cheapestFare.payload);
                    if (!response) throw new Error("No response received from provider.");
                    const { status, data, error } = response;
                    switch (status) {
                        case 200:
                            if (data?.error || typeof data?.message === "string") {
                                this.cheapestFare.isNoRecordFounds.push({ found: false });
                            } else if (data && Object.keys(data).length > 0) {
                                this.cheapestFare.flightAvailabilities.push(data);
                                this.cheapestFare.isRecordFounds.push({ found: true });
                            } else {
                                this.cheapestFare.isNoRecordFounds.push({ found: false });
                            }
                            break;
                        case 429:
                            this.responseError = error || "Too many requests. Please try again later.";
                            window.location.href = "/";
                            return;
                        default:
                            this.responseError = error || `Unexpected response status (${status}).`;
                            break;
                    }
                    processedProviders.push(supplier);
                } catch (err) {
                    this.cheapestFare.isNoRecordFounds.push({ found: false });
                    if (/Network|timeout|ECONNRESET/i.test(err.message)) {
                        await sleep(1000);
                        return fetchProviderData(supplier);
                    }
                }
            };
            let currentIndex = 0;
            const processBatch = async () => {
                const batch = [];
                while (currentIndex < totalProviders && batch.length < concurrencyLimit) {
                    const supplier = this.providers[currentIndex++];
                    batch.push(fetchProviderData(supplier));
                }
                await Promise.allSettled(batch);
                if (currentIndex < totalProviders) {
                    this.finish(false);
                    await processBatch();
                }
            };
            try {
                await processBatch();
                if (this.cheapestFare.flightAvailabilities.length === 0) {
                    this.cheapestFare.responseError ="No flights are available on the selected dates. Please consider choosing alternative dates.";
                }
                this.loadingMsg = "The lowest priced fares are displayed at the top.";
            } catch (criticalErr) {
                this.responseError = "A critical system error occurred. Please try again later.";
            } finally {
                this.finish(false);
            }
        },
        airShopping__: function () {
            this.finish(true);
            const providers = [];
            this.providers.forEach((supplier) => {
                Service.doFetch("/ticketing/cheapest-fare-airshopping-request", supplier, this.cheapestFare.payload)
                    .then((response) => {
                        const data = response?.data ?? [];
                        if (response && response.status === 429) {
                            this.responseError = response.error || "Too many requests. Please try again later.";
                            window.location.href = "/";
                        }else if (response && response.status === 200) {
                            if (data && data?.error) {
                                this.cheapestFare.isNoRecordFounds.push({'found': false});
                            } else if (data && typeof data?.message === 'string') {
                                this.cheapestFare.isNoRecordFounds.push({'found': false});
                            } else if (data && Object.keys(data).length > 0) {
                                this.cheapestFare.responseError = '';
                                this.cheapestFare.flightAvailabilities.push(data);
                                this.cheapestFare.isRecordFounds.push({'found': true});
                            }
                        }else{
                            this.responseError = response.error || "Too many requests. Please try again later.";
                        }
                        if (data) {
                            // this.loadingMsg = "Please wait while we search for the best available flights.";
                            providers.push(supplier)
                            if (this.progress < 100) {
                                const increment = 100 / this.providers.length;
                                this.progress = Math.ceil(Math.min(this.progress + increment, 100));
                            }
                        }
                    }).finally(() => {
                    if(providers.length >= 1){
                        this.finish(false);
                    }
                    if (providers.length === this.providers.length) {
                        if(this.cheapestFare.flightAvailabilities.length === 0){
                            this.cheapestFare.responseError = "No flights are available on the selected dates. Please consider choosing alternative dates.";
                        }
                        this.loadingMsg = 'The lowest-priced fares are displayed at the top.'
                    }
                })
            });
        },
        filterModal() {
            this.filterModalPopup = !this.filterModalPopup;
            document.body.style.overflow = "hidden";
        },
        closeFilterModalPopup() {
            this.filterModalPopup = false;
            document.body.style.overflow = "auto";
        },
        modifyModal() {
            this.modifyModalPopup = !this.modifyModalPopup;
            document.body.style.overflow = "hidden";
        },
        closeModifyModalPopup() {
            this.modifyModalPopup = false;
            document.body.style.overflow = "auto";
        },
        tryClose() {
            this.modifyModalPopup = false;
            this.filterModalPopup = false;
        },
        openModal(cheapestFareFlight) {
            this.legs = cheapestFareFlight.flightAvailabilities.legs;
            this.baggageAllowances = cheapestFareFlight.flightAvailabilities.baggageAllowance;
            this.airlineType = cheapestFareFlight.flightAvailabilities.price.airType;
            this.ModalPopup = !this.ModalPopup;
            document.body.style.overflow = "hidden";
        },
        closedModal() {
            this.ModalPopup = false;
            document.body.style.overflow = "auto";
        },
        openFareRuleModal(cheapestFareFlight){
            this.cheapestFlightFareRule.isWaitingResponse = 'kindly wait for a while.............'
            this.cheapestFlightFareRule.modalPopup = !this.cheapestFlightFareRule.modalPopup;
            document.body.style.overflow = "hidden";
            this.cheapestFlightFareRule.loading = true;
            if(cheapestFareFlight.flightAvailabilities.bundledServices !== undefined){
                this.cheapestFlightFareRule.isRecordFounds = cheapestFareFlight.flightAvailabilities.bundledServices
                this.cheapestFlightFareRule.isWaitingResponse = ''
                this.cheapestFlightFareRule.loading = false;
            }else{
                let fareRuleRefKeys = []
                for(let leg in cheapestFareFlight.flightAvailabilities.legs)
                    fareRuleRefKeys.push({"fareRuleRefKey": cheapestFareFlight.flightAvailabilities.legs[leg]['fareRuleKey']});
                let priceInfo = cheapestFareFlight.flightAvailabilities.price;
                const payload = {
                    fareRuleKeys: JSON.parse(JSON.stringify(fareRuleRefKeys)),
                    jSessionId:cheapestFareFlight.flightAvailabilities.jSessionId,
                    airType: priceInfo.airType,
                    vCarrier: priceInfo.validatingCarrier
                };
                Service.doFetch("/ticketing/cheapest-fare-flight-fare-rule-request",'', payload)
                    .then((response) => {
                        if (response && response.status === 429) {
                            this.responseError = response.error || "Too many requests. Please try again later.";
                            window.location.href = "/";
                        }else if (response && response.status === 200) {
                            const data = response?.data ?? [];
                            if (data.length !== 0 && data.error !== undefined) {
                                this.cheapestFlightFareRule.loading = false;
                                this.cheapestFlightFareRule.responseError = `Internal Server Error ${data.error.code}`
                            } else if (data.length !== 0 && data.error === undefined) {
                                this.cheapestFlightFareRule.isRecordFounds = data
                                this.cheapestFlightFareRule.isWaitingResponse = ''
                                this.cheapestFlightFareRule.loading = false;
                            }
                        }else{
                            this.responseError = response.error || "An unknown error occurred.";
                        }
                    });
            }
        },
        closedFareRuleModal(){
            this.cheapestFlightFareRule.responseError = ''
            this.cheapestFlightFareRule.isRecordFounds = []
            this.cheapestFlightFareRule.modalPopup = false
            this.cheapestMail = {modalPopup:false,loading:false,email:'',error:'',fareRules:''}
            document.body.style.overflow = "auto"
        },
        exportToPDF() {
            this.$refs.fareRuleToPdf.download()
        },
        openMailModal() {
            this.cheapestMail.modalPopup = !this.cheapestMail.modalPopup;
            document.body.style.overflow = "hidden";
        },
        closedMailModal(){
            this.cheapestMail = {
                modalPopup:false,
                loading:false,
                email:'',
                error:''
            }
            document.body.style.overflow = "auto";
        },
        isEmpty() {
            if (this.cheapestMail.email !== '')
                this.cheapestMail.error = ''
            else if (this.cheapestMail.email === '')
                this.cheapestMail.error = 'error'
        },isValidEmail(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(selectedCharCode)) return true;
        },
        sendMail() {
            if(this.cheapestMail.email === '') this.cheapestMail.error ='error'
            if (this.cheapestMail.error.includes('error')) {
                return false;
            } else {
                this.cheapestMail.loading = true;
                const airURLSearchParams = this.airURLSearchParams();
                this.cheapestMail.fareRules = this.cheapestFlightFareRule.isRecordFounds
                this.cheapestMail.tripTpye = airURLSearchParams.get('ft')
                this.cheapestMail.obd = airURLSearchParams.get('obd')
                this.cheapestMail.ibd = airURLSearchParams.get('ibd')
                this.cheapestMail.ol = airURLSearchParams.get('ol')
                this.cheapestMail.dl = airURLSearchParams.get('dl')
                Service.doFetch("/ticketing/cheapest-fare-flight-fare-rule-send-pdf-email", 'Create', {'cheapestFlightFareRule': this.cheapestMail})
                    .then(response => {
                        if (response && response.status === 429) {
                            this.responseError = response.error || "Too many requests. Please try again later.";
                            window.location.href = "/";
                        }else if (response && response.status === 404) {
                            this.responseError = response.error || "An unknown error occurred.";
                        }else if (response && response.status === 200) {
                            const data = response?.data ?? [];
                            if (data.errorType === false) {
                                this.$toast.success(data.message || 'An unknown error occurred.');
                                this.cheapestMail.loading = false;
                            } else {
                                this.$toast.error(data.error || 'An unknown error occurred.');
                                this.cheapestMail.loading = false;
                            }
                        }else{
                            this.responseError = response.error || "An unknown error occurred.";
                        }
                    });
            }
        },
        byOrderType(orderType) {
            this.cheapestFare.isOrderType = orderType;
        },
        setConverter(amount, currencyRate) {
            return CurrencyConverter.doRequest(amount, currencyRate)
        },
        start() {
            this.cheapestFare.loading = true;
        },
        finish(option) {
            this.cheapestFare.loading = option;
        },
        setInitialDate(initialDate, formatType) {
            return moment(initialDate).format(formatType)
        },
        cheapestFareFlightOrderCreateParams: function () {
            let params = "";
            let paramKey = 0;
            this.airURLSearchParams().forEach((value, key) => {
                params += (paramKey === 0 ? '?' : '&') + key + "=" + value;
                paramKey++;
            })
            return params;
        },
        operatingAirlineFlags: function (operatingAllAirlineFlags) {
            let operatingAirlineIndex = 0;
            for (let operatingAllAirlineFlag in operatingAllAirlineFlags) {
                if (operatingAirlineIndex == 0) return operatingAllAirlineFlags[operatingAllAirlineFlag];
                operatingAirlineIndex++;
            }
        },
        airURLSearchParams: function () {
            return new URLSearchParams(window.location.search);
        },
        clearFilter: function () {
            this.cheapestFare.isStopPoint = []
            this.cheapestFare.isVendor = []
            this.cheapestFare.isAirline = []
            this.cheapestFare.isArrivalAirport = []
            this.cheapestFare.isOrderType = "asc"
        }
    },
};
</script>
