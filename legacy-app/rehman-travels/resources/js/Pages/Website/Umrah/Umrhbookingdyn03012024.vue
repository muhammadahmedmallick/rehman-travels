<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
import Modal from '@/Components/Modal.vue';
import { Head } from "@inertiajs/vue3";
import AutocompleteUmrah from "@/Pages/Website/Umrah/AutocompleteUmrah.vue"
import ChecInCheckOutDate from "@/Pages/Website/Umrah/ChecInCheckOutDate.vue"
</script>
<template>
    <Head>
        <title>{{ $page.props.umrahPackages.packageTitle }} </title>
        <meta head-key="title" :content="$page.props.umrahPackages.metaTitle" />
        <meta head-key="description" :content="$page.props.umrahPackages.metaDescription" />
        <meta head-key="language" content="English">
        <meta property="og:url" :content="'https://www.rehmantravel.com/' + $page.props.umrahPackages.urlLink">
        <meta property="og:title" :content="$page.props.umrahPackages.metaTitle" />
        <meta property="og:description" :content="$page.props.umrahPackages.metaDescription" />
        <meta property="og:site_name" content="Rehman Travels" />
        <meta property="fb:admins" content="100064855023859"/>
        <meta property="og:image" content="https://www.rehmantravel.com/rgt-logo.webp" />
        <meta property="og:image:secure_url" content="https://www.rehmantravel.com/rgt-logo.webp" />
        <meta property="og:image:type" content="image/png" />
        <meta property="og:image:width" content="400" />
        <meta property="og:image:height" content="300" />
        <meta property="og:image:alt" :content="$page.props.umrahPackages.metaTitle" />
        <meta property="og:locale" content="en-us" />
        <meta name="twitter:card" content="summary" />
        <meta name="twitter:title" :content="$page.props.umrahPackages.metaTitle"  />
        <meta name="twitter:description" :content="$page.props.umrahPackages.metaDescription"/>
        <meta name="twitter:image" content="https://www.rehmantravel.com/rgt-logo.webp" />
        <meta itemprop="image" content="https://www.rehmantravel.com/rgt-logo.webp"/>
        <meta name="twitter:site" content="@RehmanTravels"/>
        <meta name="twitter:creator" content="@RehmanTravels"/> 
    </Head>
    <GuestLayout>
        <section>
            <div class="grid grid-cols-12">
                <div class="col-span-12">
                    <div class="banner w-full" :style="'background-image:url('+banner+')'">
                        <div class="container mx-auto pb-12 xl:pb-24 pt-8 px-2 xl:px-24">
                            <h2
                                class="text-white capitalize text-center text-xl md:text-3xl font-medium drop-shadow[0.125rem_0.125rem_0.125rem_gray] pb-4">
                                Book Your Umrah Package</h2>
                            <div class="grid grid-cols-12 pb-2 sm:py-6 bg-white rounded-md border border-dashed border-[#05153f]">
                                <div class="col-span-12 lg:col-span-9">
                                    <div class="grid grid-cols-12 gap-2 mx-4 pb-6">
                                        <div class="col-span-12 hidden md:block">
                                            <div class="flex gap-5">
                                                <div>
                                                    <input class="h-4 w-4" type="checkbox" id="UmrahVisa" checked="checked"
                                                        v-model="umrahDyn.umrahVisa">
                                                    <label for="UmrahVisa" class="text-base font-semibold">&nbsp; Umrah Visa
                                                    </label>
                                                </div>
                                                <div>
                                                    <input class="h-4 w-4" type="checkbox" id="transport" checked="checked"
                                                        v-model="umrahDyn.transport" :onChange="umrahTransport(umrahDyn.transport)">
                                                    <label for="transport" class="text-base font-semibold">&nbsp; Transport
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="flex flex-wrap gap-1 mx-4 pb-6"
                                        v-for="(hotel, hotelIndex) in umrahDyn.hotel" :key="hotelIndex">
                                        <div class=" w-full xs:w-[23%] sm:w-[22%] md:w-[21%] lg:w-[15%] xl:w-[12%] 2xl:w-[10%]">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                :for="'localtion_' + hotelIndex">
                                                Location
                                            </label>
                                            <select required
                                                class="text-sm block w-full h-11  border border-gray-300 hover:border-gray-400 text-gray-700 pr-4 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                :id="'localtion_' + hotelIndex" v-model="hotel.location">
                                                <option value="Makkah" selected>Makkah</option>
                                                <option value="Madinah">Madinah</option>
                                            </select>
                                        </div>
                                        <div class="w-full xs:w-[76%] sm:w-[77%] md:w-[78%] lg:w-[48%] xl:w-[31%] 2xl:w-[37%]" v-if="hotel.location == 'Makkah'">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                for="Hotel-in-Makkah">
                                                Hotel in {{ hotel.location }}
                                            </label>
                                            
                                            <AutocompleteUmrah v-model="hotel.umrahHotelName" v-on:click="validHotel(hotelIndex)"
                                                @umrahSelectedHotels="umrahSelectedHotels" :umrahHotels="$page.props.umrahHotelMakkah"
                                                :initialIndex="hotelIndex"
                                            />
                                        </div>
                                        <div class="w-full xs:w-[76%] sm:w-[77%] md:w-[78%] lg:w-[48%] xl:w-[31%] 2xl:w-[37%]" v-if="hotel.location == 'Madinah'">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                for="Hotel-in-Makkah">
                                                Hotel in {{ hotel.location }}
                                            </label>
                                            
                                            <AutocompleteUmrah v-model="hotel.umrahHotelName" v-on:click="validHotel(hotelIndex)"
                                                @umrahSelectedHotels="umrahSelectedHotels" :umrahHotels="$page.props.umrahHotelMadinah"
                                                :initialIndex="hotelIndex" 
                                            />
                                        </div>
                                        <div class="w-[49%] xs:w-[49.4%] sm:w-[22%] md:w-[21%] lg:w-[17%] xl:w-[15%] 2xl:w-[13%]">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                for="Check-in">
                                                Check In
                                            </label>
                                            <div
                                                class="text-sm block w-full h-11  text-gray-700 border border-gray-300 hover:border-gray-400 rounded px-2 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                            >
                                                <ChecInCheckOutDate v-model="hotel.checkIn"
                                                @update:outinboundDateDetail="outinboundDateDetail" flightType="round-trip"
                                                :initialIndex="hotelIndex" />
                                            </div>
                                        </div>
                                        <div class="w-[49%] xs:w-[49.4%] sm:w-[22%] md:w-[21%] lg:w-[17%] xl:w-[15%] 2xl:w-[13%]">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                for="Check-out">
                                                Check Out
                                            </label>
                                            <div class="text-sm block w-full h-11 text-gray-700 border border-gray-300 hover:border-gray-400 rounded px-2 leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                                <ChecInCheckOutDate v-model="hotel.checkOut"
                                                @update:outinboundDateDetail="outinboundDateDetail" flightType="round-trip"
                                                :initialIndex="hotelIndex" />
                                            </div>
                                        </div>
                                        <div class="w-[48.4%] xs:w-[49.4%] sm:w-[26.6%] md:w-[25%] lg:w-[17%] xl:w-[12%] 2xl:w-[12%]">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                for="Select-Room">
                                                Select Room
                                            </label>
                                            <div
                                                class=" flex justify-start px-1 text-sm  w-full h-11 text-gray-700 border border-gray-300 hover:border-gray-400 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                                <SelectRooms @hotelRooms="hotelRooms" :hotelIndex="hotelIndex" />
                                            </div>

                                        </div>
                                        <div class="w-[48.4%] xs:w-[49.4%] sm:w-[27%] md:w-[31%] lg:w-[25%] xl:w-[11%] 2xl:w-[12%]">
                                            <div class="flex gap-1">
                                                <div class="w-1/2">
                                                    <label
                                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                        for="Rooms">
                                                        Rooms
                                                    </label>
                                                    <input type="text" aria-label="disabled input"
                                                        class="text-sm block w-full h-11  text-gray-700 border border-gray-300 hover:border-gray-400 rounded text-center leading-tight focus:outline-none focus:bg-white focus:border-blue-500 cursor-not-allowed"
                                                        v-model="umrahDyn.hotel[hotelIndex].totalRooms.rooms"
                                                        v-value="umrahDyn.hotel[hotelIndex].totalRooms.rooms" disabled>
                                                </div>
                                                <div class="w-1/2">
                                                    <label
                                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                        for="Nights">
                                                        Nights
                                                    </label>
                                                    <input type="text" id="nights" aria-label="disabled input"
                                                        class="text-sm block w-full h-11  text-gray-700 border border-gray-300 hover:border-gray-400 rounded text-center leading-tight focus:outline-none focus:bg-white focus:border-blue-500 cursor-not-allowed"
                                                        :value="umrahDyn.hotel[hotelIndex].totalNights" disabled>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="w-full">
                                            <div class="grid grid-cols-2" v-if="hotelIndex == umrahDyn.hotel.length - 1">
                                                <div v-if="hotelIndex > 1">
                                                    <button class="bg-red-600 text-white p-1 rounded-md px-5 py-2 mr-2"
                                                        @click="removeDiv(hotelIndex)">Remove</button>
                                                </div>
                                                <div v-if="hotelIndex < 2">
                                                    <button class="bg-green-600 text-white p-1 rounded-md px-5 py-2 mr-2"
                                                        @click="cloneDiv(hotelIndex)">Add More</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div
                                        class="flex flex-wrap gap-1 mx-4 mt-1 pb-1 border-t-[0.063rem] border-dashed border-[#ced4da]">
                                        <div class="col-span-12 mt-3 md:hidden">
                                            <div class="flex gap-5">
                                                <div>
                                                    <input class="h-4 w-4" type="checkbox" id="UmrahVisa" checked="checked"
                                                        v-model="umrahDyn.umrahVisa">
                                                    <label for="UmrahVisa" class="text-base font-semibold">&nbsp; Umrah Visa
                                                    </label>
                                                </div>
                                                <div>
                                                    <input class="h-4 w-4" type="checkbox" id="transport" checked="checked"
                                                        v-model="umrahDyn.transport" :onChange="umrahTransport(umrahDyn.transport)">
                                                    <label for="transport" class="text-base font-semibold">&nbsp; Transport
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div
                                        class="flex flex-wrap gap-1 mx-4 mt-4 pb-6 border-b-[0.063rem] border-dashed border-[#ced4da]">
                                        <div class="w-full xs:w-[29%] sm:w-[27%] md:w-[20%] xl:w-[12.5%] 2xl:w-[10%]">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                for="Select-Nationality">
                                                Nationality
                                            </label>
                                            <select
                                                class=" text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                id="Select-Nationality" v-model="umrahDyn.nationality">
                                                <option value="0" selected>Pakistani</option>
                                                <option value="1">Other</option>
                                            </select>
                                        </div>
                                        <div class="w-full block xs:hidden">
                                            <div :class="`${!umrahDyn.transport ? 'w-full' : 'flex gap-1'}`">
                                                <div :class="`${!umrahDyn.transport ? 'w-full' : 'w-[49%]'}`">
                                                    <label class="capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">
                                                        Select Traveler
                                                    </label>
                                                    <div
                                                        class="flex  items-center px-3 text-sm  w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded  leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                                        <svg xmlns="http://www.w3.org/2000/svg" height="18px" width="24px" fill="#0181dd"
                                                            viewBox="0 0 576 512" class="block md:hidden">
                                                            <path
                                                                d="M432 96a48 48 0 1 0 0-96 48 48 0 1 0 0 96zM347.7 200.5c1-.4 1.9-.8 2.9-1.2l-16.9 63.5c-5.6 21.1-.1 43.6 14.7 59.7l70.7 77.1 22 88.1c4.3 17.1 21.7 27.6 38.8 23.3s27.6-21.7 23.3-38.8l-23-92.1c-1.9-7.8-5.8-14.9-11.2-20.8l-49.5-54 19.3-65.5 9.6 23c4.4 10.6 12.5 19.3 22.8 24.5l26.7 13.3c15.8 7.9 35 1.5 42.9-14.3s1.5-35-14.3-42.9L505 232.7l-15.3-36.8C472.5 154.8 432.3 128 387.7 128c-22.8 0-45.3 4.8-66.1 14l-8 3.5c-32.9 14.6-58.1 42.4-69.4 76.5l-2.6 7.8c-5.6 16.8 3.5 34.9 20.2 40.5s34.9-3.5 40.5-20.2l2.6-7.8c5.7-17.1 18.3-30.9 34.7-38.2l8-3.5zm-30 135.1l-25 62.4-59.4 59.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L340.3 441c4.6-4.6 8.2-10.1 10.6-16.1l14.5-36.2-40.7-44.4c-2.5-2.7-4.8-5.6-7-8.6zM256 274.1c-7.7-4.4-17.4-1.8-21.9 5.9l-32 55.4L147.7 304c-15.3-8.8-34.9-3.6-43.7 11.7L40 426.6c-8.8 15.3-3.6 34.9 11.7 43.7l55.4 32c15.3 8.8 34.9 3.6 43.7-11.7l64-110.9c1.5-2.6 2.6-5.2 3.3-8L261.9 296c4.4-7.7 1.8-17.4-5.9-21.9z" />
                                                        </svg>
                                                        <SelectTravellers @selectedTravelers="selectedTravelers" />
                                                    </div>
                                                </div>
                                                <div v-if="umrahDyn.transport" class="w-[49%]">
                                                    <label
                                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                        for="Vehicle-Type">
                                                        Vehicle Type
                                                    </label>
                                                    <select
                                                        class="text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                        id="Vehicle-Type" v-model="umrahDyn.vehicle">
                                                        <option
                                                            v-for="(umrahVehicleService, umrahVehicleServiceIndex) in $page.props.umrahVehicleServices"
                                                            :value="umrahVehicleService.id">{{ umrahVehicleService.vehicleName }}
                                                        </option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div v-if="umrahDyn.transport" class="w-full">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                    for="Select-Sector">
                                                    Sector
                                                </label>
                                                <select
                                                    class="text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="Select-Sector" v-model="umrahDyn.sector">
                                                    <option
                                                        v-for="(umrahTransportSector, umrahTransportSectorIndex) in $page.props.umrahTransportSectors"
                                                        :value="umrahTransportSector.id"> {{ umrahTransportSector.sectorName }}
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div v-if="umrahDyn.transport" class="hidden xs:block w-full xs:w-[70%] sm:w-[72%] md:w-[50%] xl:w-[29.5%] 2xl:w-[34%]">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                for="Select-Sector-Desk">
                                                Sector
                                            </label>
                                            <select
                                                class="text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                id="Select-Sector-Desk" v-model="umrahDyn.sector">
                                                <option
                                                    v-for="(umrahTransportSector, umrahTransportSectorIndex) in $page.props.umrahTransportSectors"
                                                    :value="umrahTransportSector.id"> {{ umrahTransportSector.sectorName }}
                                                </option>
                                            </select>
                                        </div>
                                        <div v-if="umrahDyn.transport" class="hidden xs:block w-[49%] xs:w-[29%] sm:w-[27%] md:w-[27%] xl:w-[17%] 2xl:w-[18%]">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                for="Vehicle-Type-Desk">
                                                Vehicle Type
                                            </label>
                                            <select
                                                class="text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                id="Vehicle-Type-Desk" v-model="umrahDyn.vehicle">
                                                <option
                                                    v-for="(umrahVehicleService, umrahVehicleServiceIndex) in $page.props.umrahVehicleServices"
                                                    :value="umrahVehicleService.id">{{ umrahVehicleService.vehicleName }}
                                                </option>
                                            </select>
                                        </div>
                                        <div class="hidden xs:block w-[49%] xs:w-[27%] sm:w-[31%] md:w-[20%] xl:w-[16%] 2xl:w-[15%]">
                                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">
                                                Select Traveler
                                            </label>
                                            <div
                                            class="flex items-center px-3 text-sm  w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded  leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                                <svg xmlns="http://www.w3.org/2000/svg" height="18px" width="24px" fill="#0181dd"
                                                    viewBox="0 0 576 512" class="hidden xs:block">
                                                    <path
                                                        d="M432 96a48 48 0 1 0 0-96 48 48 0 1 0 0 96zM347.7 200.5c1-.4 1.9-.8 2.9-1.2l-16.9 63.5c-5.6 21.1-.1 43.6 14.7 59.7l70.7 77.1 22 88.1c4.3 17.1 21.7 27.6 38.8 23.3s27.6-21.7 23.3-38.8l-23-92.1c-1.9-7.8-5.8-14.9-11.2-20.8l-49.5-54 19.3-65.5 9.6 23c4.4 10.6 12.5 19.3 22.8 24.5l26.7 13.3c15.8 7.9 35 1.5 42.9-14.3s1.5-35-14.3-42.9L505 232.7l-15.3-36.8C472.5 154.8 432.3 128 387.7 128c-22.8 0-45.3 4.8-66.1 14l-8 3.5c-32.9 14.6-58.1 42.4-69.4 76.5l-2.6 7.8c-5.6 16.8 3.5 34.9 20.2 40.5s34.9-3.5 40.5-20.2l2.6-7.8c5.7-17.1 18.3-30.9 34.7-38.2l8-3.5zm-30 135.1l-25 62.4-59.4 59.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L340.3 441c4.6-4.6 8.2-10.1 10.6-16.1l14.5-36.2-40.7-44.4c-2.5-2.7-4.8-5.6-7-8.6zM256 274.1c-7.7-4.4-17.4-1.8-21.9 5.9l-32 55.4L147.7 304c-15.3-8.8-34.9-3.6-43.7 11.7L40 426.6c-8.8 15.3-3.6 34.9 11.7 43.7l55.4 32c15.3 8.8 34.9 3.6 43.7-11.7l64-110.9c1.5-2.6 2.6-5.2 3.3-8L261.9 296c4.4-7.7 1.8-17.4-5.9-21.9z" />
                                                </svg>
                                                <SelectTravellers @selectedTravelers="selectedTravelers" />
                                            </div>
                                        </div>
                                        <div class=" w-full xs:w-[42%] sm:w-[40%] md:w-[50%] xl:w-[22%] 2xl:w-[20%]">
                                            <div class="flex gap-1">
                                                <div class="w-1/2">
                                                    <label
                                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                        for="t-rooms">
                                                        Total Rooms
                                                    </label>
                                                    <input type="text" id="t-rooms" aria-label="disabled input"
                                                        class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500 cursor-not-allowed"
                                                        :value="umrahDyn.grandRooms" disabled>
                                                </div>
                                                <div class="w-1/2">
                                                    <label
                                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                        for="t-Nights">
                                                        Total Nights
                                                    </label>
                                                    <input type="text" id="t-Nights" aria-label="disabled input"
                                                        class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500 cursor-not-allowed"
                                                        :value="umrahDyn.grandNights" disabled>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div
                                    class="col-span-12 mt-1 lg:mt-0 lg:col-span-3 mx-4 lg:border-l-[0.063rem] lg:border-dashed lg:border-gray-600 lg:px-4">
                                    <div class="grid grid-cols-12 gap-2 lg:gap-0  lg:grid-cols-1">
                                        <div class="col-span-12 xs:col-span-6 sm:col-span-6 lg:col-span-4 xl:col-span-2">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2 mt-2"
                                                for="f-name">
                                                Name
                                            </label>
                                            <input v-model="umrahDyn.customers.firstName"  v-on:keypress="isString" @paste.prevent
                                                class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                id="f-name" type="text" placeholder="Full Name">
                                        </div>
                                        <div class="col-span-12 hidden xs:block xs:col-span-6 sm:col-span-6 lg:col-span-4 xl:col-span-2">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2 mt-2"
                                                for="email">
                                                Email
                                            </label>
                                            <input v-model="umrahDyn.customers.email" v-on:keypress="isString" @paste.prevent
                                                class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                id="email" type="email" placeholder="Email">
                                        </div>
                                        <div class="col-span-7  xs:col-span-6 sm:col-span-6 lg:col-span-4 xl:col-span-2">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2 mt-2"
                                                for="contactNo">
                                                Contact <span class="text-red-500">*</span>
                                            </label>
                                            <input v-model="umrahDyn.customers.mobileNo" v-on:keypress="isNumber" @paste.prevent
                                                class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                id="contactNo" type="tel" placeholder="Phone Number">
                                        </div>
                                        <div class="col-span-5 xs:col-span-6 sm:col-span-6 lg:col-span-4 xl:col-span-2">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2 mt-2"
                                                for="city">
                                                City
                                            </label>
                                            <select v-model="umrahDyn.city"
                                                class="text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                id="city">
                                                <option value="1" class="leading-7 bg-[#f9f9fa] hover:bg-blue-500 h-3">Islamabad</option>
                                                <option value="2" class="leading-7 bg-[#f9f9fa] hover:bg-blue-500 ">Karach</option>
                                                <option value="3" class="leading-7 bg-[#f9f9fa] hover:bg-blue-500">Lahore</option>
                                                <option value="4" class="leading-7 bg-[#f9f9fa] hover:bg-blue-500">Peshawar</option>
                                                <option value="5" class="leading-7 bg-[#f9f9fa] hover:bg-blue-500">Mirpur</option>
                                                <option value="6" class="leading-7 bg-[#f9f9fa] hover:bg-blue-500">Others</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-span-12 lg:col-span-9 text-center lg:ml-10 mt-4">
                                    <button type="button"
                                        class="focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2"><i
                                            class="fa fa-refresh" aria-hidden="true"></i> Reset Form </button>
                                    <button type="button" @click="umrahBookingQuery()"
                                        class="focus:outline-none text-white bg-green-700 hover:bg-green-800 focus:ring-4 focus:ring-green-300 font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2">
                                        <i class="fa fa-calculator"></i> Calculate Fare </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="overflow-auto px-2 md:pt-2">
                <div class="w-[100%] mx-auto" v-html="$page.props.packageHtml">
                </div>
            </div>
            <div class="px-4 py-3 flex flex-1 justify-end sm:px-6" id="UmrahUbcClosebtn">
                <button @click="printModal()" type="button"
                    class="mt-3 inline-flex w-full justify-center rounded-md bg-green-600 px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset  sm:mt-0 sm:w-auto mr-3">Print</button>
                <button @click="closeModal()" type="button"
                    class="mt-3 inline-flex w-full justify-center rounded-md bg-red-600 px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset  sm:mt-0 sm:w-auto">Close</button>
            </div>
        </Modal>
        <section>
            <div class="w-[90%] mx-auto">
                <div class="grid grid-cols-12 mt-4">
                    <div
                        class=" col-span-12 lg:col-span-8 mb-4 relative flex flex-col break-words bg-white bg-clip-border border-[1px] border-solid border-[rgba(0,0,0,.125)] rounded-[0.25rem]">
                        <div class="p-4">
                            <div class="col-span-12 mb-3 mt-4">
                                <h2
                                    class="text-[#f89923] text-lg rounded py-2 px-4 w-fit bg-[#f899231c] border border-dashed border-[#f89923]">
                                    {{ $page.props.umrahPackages.packageTitle }}</h2>
                            </div>
                            <div class="col-span-12 mb-4">
                                <p class="text-justify mt-2 text-lg mb-0 frondEnd" v-html="$page.props.umrahPackages.shortDescription">
                                </p>
                            </div>
                            <div class="col-span-12 text-justify mb-5 frondEnd" v-html="$page.props.umrahPackages.description">
                            </div>
                        </div>
                        <div class="md:pt-3  py-0 md:py-0 hidden md:block">
                            <div class="bg-white rounded-lg xs:text-justify">
                                <div class="my-3 w-full">
                                    <h3
                                        class="text-xl uppercase bg-bgRGTBaseColor text-white p-[0rem_0.7rem] mb-3 font-medium leading-[2.875rem] md:text-start text-center">
                                        request a callback</h3>
                                </div>
                                <form class="w-full p-3" @submit.prevent="submit">
                                    <div class="grid grid-cols-12 gap-2">
                                        <div class="col-span-12 md:col-span-4">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="text" v-model="form.customers.firstName" v-on:keypress="isString" @paste.prevent placeholder="Your Name">
                                        </div>
                                        <div class="col-span-12 md:col-span-4">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="tel" v-model="form.customers.mobileNo" v-on:keypress="isNumber" @paste.prevent placeholder="Phone No">
                                        </div>
                                        <div class="col-span-12 md:col-span-4">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="email" v-model="form.customers.email" v-on:keypress="isString" @paste.prevent placeholder="Email">
                                        </div>
                                    </div>
                                    <div class="grid grid-cols-12 gap-3">
                                        <div class="col-span-12 md:col-span-8">
                                            <textarea rows="5" cols="40" v-model="form.contents.message" v-on:keypress="isString" @paste.prevent
                                                class="appearance-none block h-10 w-full border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"> Message</textarea>
                                        </div>
                                        <div class="col-span-12 md:col-span-2 md:mb-0 mb-4">
                                            <input type="submit" @click="submitDetails()"
                                                class=" w-full p-2 text-xl bg-blue-100 text-blue-800 border border-solid border-blue-500 text-center transition-all duration-700 ease-in-out rounded hover:bg-bgRGTBaseColor hover:text-white hover:transition-all hover:ease-in-out hover:duration-700">
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="sm:col-span-12 lg:col-span-4 sm:mx-3 sm:mt-0 mt-4 col-span-12 w-full">
                        <div class="col-span-12 sm:mx-4">
                            <div>
                                <h3
                                    class="text-xl rounded bg-bgRGTBaseColor text-white p-[0rem_0.7rem] mb-3 font-medium text-center leading-[2.875rem]">
                                    Request a Callback</h3>
                            </div>
                        </div>
                        <div class="col-span-12 sm:mx-4">
                            <form @submit.prevent="submit">
                                <div class="relative">
                                    <input type="text" id="name" v-model="form.customers.firstName" v-on:keypress="isString" @paste.prevent
                                        class="block rounded-t-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="name"
                                        class="absolute text-sm text-black duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">Name
                                        <span class="text-red-600">*</span></label>
                                </div>
                                <div class="relative mt-3">
                                    <input type="tel" id="phone-number" v-model="form.customers.mobileNo" v-on:keypress="isNumber" @paste.prevent
                                        class="block rounded-t-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="phone-number"
                                        class="absolute text-sm text-black duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                                        Phone Number <span class="text-red-600">*</span></label>
                                </div>
                                <div class="relative mt-3">
                                    <input type="email" id="Email" v-model="form.customers.email" v-on:keypress="isString" @paste.prevent
                                        class="block rounded-t-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="Email"
                                        class="absolute text-sm text-black duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                                        Email <span class="text-red-600">*</span></label>
                                </div>
                                <div class="relative mt-3">
                                    <textarea id="textArea" v-model="form.contents.message" v-on:keypress="isString" @paste.prevent
                                        class="block rounded-t-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer h-24"
                                        placeholder=""></textarea>
                                    <label for="textArea"
                                        class="absolute text-sm text-black duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                                        Type a Message <span class="text-red-600">*</span></label>
                                </div>
                                <div class="relative mt-3">
                                    <input type="submit" @click="submitDetails()"
                                    class=" w-full p-2 text-xl bg-blue-100 text-blue-800 border border-solid border-blue-500 text-center transition-all duration-700 ease-in-out rounded hover:bg-bgRGTBaseColor hover:text-white hover:transition-all hover:ease-in-out hover:duration-700">
                                </div>

                            </form>
                        </div>
                        <div class="col-span-12 sm:mx-4 ">
                            <div
                                class="my-3 border-2 border-dashed border-gray-400 p-3 bg-gray-200 rounded text-center justify-center">
                                <h3 class=" text-blue-800 mb-2">For additional information, kindly get in touch via:</h3>
                                <i class=" fa fa-phone text-blue-600"></i> 
                                <a href="tel:923345555121" class="text-blue-800">(+92)3345555121</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </GuestLayout>
</template>
<script>
import moment from 'moment';
import SelectTravellers from '@/Layout/Website/SelectTravellers.vue';
import SelectRooms from '@/Layout/Website/SelectRooms.vue';
export default {
    components: {
        SelectTravellers,
        SelectRooms
    },
    data() {
        return {
            modalWidth: "sm:w-[100%] md:w-[85%] xl:w-[65%] umrahBanner",
            banner:"",
            umrahHotels: [],
            isModalVisible: false,
            form: {
                customers: {
                    firstName : "",
                    mobileNo : "",
                    email : "",
                },
                contents: {
                    message : "",
                    moduleId : 3,
                    leadFrom : ""
                }
            },
            umrahDyn: {
                hotel: [{
                    location: "Makkah",
                    umrahHotelId: "",
                    umrahHotelName: "",
                    checkIn: "",
                    checkOut: "",
                    totalNights: 0,
                    totalRooms: {
                        Double: 0,
                        Triple: 0,
                        Quad: 0,
                        Quint: 0,
                        rooms: 0,
                    }
                }],
                travellers: {
                    adultCount: 1,
                    childCount: 0,
                    infantCount: 0,
                    totalTraveller: 1
                },
                customers: {
                    firstName: "",
                    email: "",
                    mobileNo: "",
                },
                grandRooms: 0,
                grandNights: 0,
                transport: true,
                umrahVisa: true,
                sector: "",
                vehicle: "",
                nationality: "0",
                city: 1
            }
        }
    },
    mounted(){
        this.banner = '/assets/Umrah/economy-banner.webp';
    },
    methods: {
        isString(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z @.]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isNumber(e){
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[0-9+]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        selectedTravelers(traveller) {
            this.umrahDyn.travellers.adultCount = traveller.adultsCount;
            this.umrahDyn.travellers.childCount = traveller.childrenCount;
            this.umrahDyn.travellers.infantCount = traveller.infantsCount;
            this.umrahDyn.travellers.totalTraveller = traveller.totalTraveller;
        },
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
        umrahTransport(transport){
            if(!transport){
                this.umrahDyn.sector = "";
                this.umrahDyn.vehicle = "";
            };
        },
        umrahSelectedHotel() {
            let umrahHotel = this.umrahDyn.hotel;
            for(let hotel in umrahHotel){
                if (JSON.parse(JSON.stringify(umrahHotel[hotel].location)) == "Makkah") {
                    this.umrahHotels = this.$page.props.umrahHotelMakkah;
                }else if (JSON.parse(JSON.stringify(umrahHotel[hotel].location)) == "Madinah") {
                    this.umrahHotels = this.$page.props.umrahHotelMadinah;
                }
            }
        },
        hotelRooms(hotelRooms) {
            this.umrahDyn.grandRooms = 0;
            for (let hotelIndex in this.umrahDyn.hotel) {
                if(hotelRooms.hotelId == hotelIndex){
                    this.umrahDyn.hotel[hotelIndex].totalRooms = hotelRooms;
                }
                this.umrahDyn.grandRooms += this.umrahDyn.hotel[hotelIndex].totalRooms.rooms;
            }
        },
        cloneDiv(index) {
            this.umrahDyn.hotel.push({
                location: (this.umrahDyn.hotel[index].location == "Makkah" ? "Madinah" : "Makkah"),
                umrahHotelId: "",
                umrahHotelName: "",
                checkIn: "",
                checkOut: "",
                totalNights: 0,
                totalRooms: {
                    Double: 0,
                    Triple: 0,
                    Quad: 0,
                    Quint: 0,
                    rooms: 0,
                }
            })
        },
        removeDiv(index) {
            let totalNights = this.umrahDyn.hotel[index].totalNights;
            let grandNights = this.umrahDyn.grandNights;
            let gdNights = grandNights - totalNights;
            this.umrahDyn.grandNights = gdNights;

            let totalRoom = this.umrahDyn.hotel[index].totalRooms.rooms;
            let grandRooms = this.umrahDyn.grandRooms;
            let gdRoom = grandRooms - totalRoom;
            this.umrahDyn.grandRooms = gdRoom;
            
            this.umrahDyn.hotel.splice(index, 1);
        },
        closeModal() {
            this.isModalVisible = false;
            document.body.style.overflow = "auto";
        },
        umrahSelectedHotels(umrahSelectedHotels){
            this.umrahDyn.hotel[umrahSelectedHotels.initialIndex].umrahHotelId = umrahSelectedHotels.initialItem.id;
            this.umrahDyn.hotel[umrahSelectedHotels.initialIndex].umrahHotelName = umrahSelectedHotels.initialItem.hotelName;
        },
        outinboundDateDetail(dateDetail){
            if(this.umrahDyn.hotel[dateDetail.initialIndex].umrahHotelId != "" && dateDetail.initialDate !== undefined){
                let validHotels = this.validHotel(dateDetail.initialIndex);
                if(validHotels == "undefined" || validHotels == "HotelNotFound"){
                    this.$toast.error('Hotel is not avaiable between '+ this.umrahDyn.hotel[dateDetail.initialIndex].checkIn +' And '+this.umrahDyn.hotel[dateDetail.initialIndex].checkOut+' !');
                    let totalNights = this.umrahDyn.hotel[dateDetail.initialIndex].totalNights;
                    this.umrahDyn.hotel[dateDetail.initialIndex].umrahHotelId = "";
                    this.umrahDyn.hotel[dateDetail.initialIndex].umrahHotelName = "";
                    this.umrahDyn.hotel[dateDetail.initialIndex].checkIn = "";
                    this.umrahDyn.hotel[dateDetail.initialIndex].checkOut = "";
                    this.umrahDyn.grandNights = (this.umrahDyn.grandNights > 0 ? (this.umrahDyn.grandNights - totalNights) : 0);
                    this.umrahDyn.hotel[dateDetail.initialIndex].totalNights = 0;
                }else{
                    if (dateDetail.initialDate.start !== null){
                        this.umrahDyn.hotel[dateDetail.initialIndex].checkIn = dateDetail.initialDate.start;
                    }
                    if (dateDetail.initialDate.end !== null){
                        this.umrahDyn.hotel[dateDetail.initialIndex].checkOut = dateDetail.initialDate.end;
                    }
                    this.checkNumDays(dateDetail.initialIndex);
                }
            }else{
                this.$toast.error('Please select hotel first!');
                this.umrahDyn.hotel[dateDetail.initialIndex].checkIn = "";
                this.umrahDyn.hotel[dateDetail.initialIndex].checkOut = "";
            }
        },
        validHotel(index){
            let umrahHotel = this.umrahDyn.hotel[index];
            let checkIn = moment(umrahHotel.checkIn, "DD-MM-YYYY").format("YYYY-MM-DD");
            let checkOut = moment(umrahHotel.checkOut, "DD-MM-YYYY").format("YYYY-MM-DD");
            if(umrahHotel.umrahHotelId != "" && (umrahHotel.checkIn != "" || umrahHotel.checkOut != "")){
                if(umrahHotel.location == "Makkah"){
                    let MakkahHotel = this.$page.props.umrahHotelMakkah;
                    for(let hotelIndex in MakkahHotel){
                        if(umrahHotel.umrahHotelId == MakkahHotel[hotelIndex].id){
                            let roomPeriods = MakkahHotel[hotelIndex].hotel_room_periods;
                            let result = "";
                            for(let roomPeriodIndex in roomPeriods){
                                if((roomPeriods[roomPeriodIndex].periodFrom >= checkIn && roomPeriods[roomPeriodIndex].periodTo <= checkOut) || (roomPeriods[roomPeriodIndex].periodTo >= checkIn && roomPeriods[roomPeriodIndex].periodFrom <= checkOut)){
                                    result = "HotelFound";
                                }
                            }
                            return result;
                        }
                    }
                }else if(umrahHotel.location == "Madinah"){
                    let MadinahHotel = this.$page.props.umrahHotelMadinah;
                    for(let hotelIndex in MadinahHotel){
                        if(umrahHotel.umrahHotelId == MadinahHotel[hotelIndex].id){
                            let roomPeriods = MadinahHotel[hotelIndex].hotel_room_periods;
                            let result = "";
                            for(let roomPeriodIndex in roomPeriods){
                                if((roomPeriods[roomPeriodIndex].periodFrom >= checkIn && roomPeriods[roomPeriodIndex].periodTo <= checkOut) || (roomPeriods[roomPeriodIndex].periodTo >= checkIn && roomPeriods[roomPeriodIndex].periodFrom <= checkOut)){
                                    result = "HotelFound";
                                }
                            }
                            return result;
                        }
                    }
                }
            }
        },
        setInitialDate(initialDate, initialDay) {
            return moment(initialDate, "DD-MM-YYYY").add(initialDay, "days").format("DD-MM-YYYY")
        },
        checkNumDays(hotelIndex){
            let checkIn = this.umrahDyn.hotel[hotelIndex].checkIn;
            let checkOut = this.umrahDyn.hotel[hotelIndex].checkOut;
            checkIn = moment(checkIn, "DD-MM-YYYY").format("YYYY-MM-DD");
            checkOut = moment(checkOut, "DD-MM-YYYY").format("YYYY-MM-DD");
            if(checkIn != "" && checkOut != ""){
                if(hotelIndex > 0){
                    let previousIndex = hotelIndex - 1;
                    let previousCheckOut = moment(this.umrahDyn.hotel[previousIndex].checkOut, "DD-MM-YYYY").format("YYYY-MM-DD");
                    if(checkIn < previousCheckOut || checkIn > checkOut){
                        this.umrahDyn.hotel[hotelIndex].checkIn  = "";
                        this.umrahDyn.hotel[hotelIndex].checkOut  = "";
                        this.$toast.error('Please select Date From Today, Onwards!');
                        console.log(this.umrahDyn.hotel[hotelIndex].checkIn, this.umrahDyn.hotel[hotelIndex].checkOut, hotelIndex);
                        return false;
                    }
                }else{
                    if(checkIn > checkOut){
                        this.umrahDyn.hotel[hotelIndex].checkIn = "";
                        this.umrahDyn.hotel[hotelIndex].checkOut = "";
                        this.$toast.error('Please select Date From Today, Onwards!');
                        return false;
                    }
                }
                if(this.umrahDyn.hotel[hotelIndex].totalNights != "" || this.umrahDyn.hotel[hotelIndex].totalNights != 0){
                    this.umrahDyn.grandNights = ((this.umrahDyn.grandNights) - (this.umrahDyn.hotel[hotelIndex].totalNights));
                }
                const  currentDate = new Date(checkIn);
                const  previousDate = new Date(checkOut);
                const  timeDifference =  previousDate.getTime() - currentDate.getTime();
                const  daysDifference = Math.floor(timeDifference / (1000 * 60 * 60 * 24));
                this.umrahDyn.hotel[hotelIndex].totalNights = daysDifference;
                this.umrahDyn.grandNights += daysDifference;
            }
        },
        printModal() {
            const prtHtml = document.getElementById('print').innerHTML;
            let stylesHtml = '';
            for (const node of [...document.querySelectorAll('link[rel="stylesheet"], style')]) {
                stylesHtml += node.outerHTML;
            }
            window.document.write(`<!DOCTYPE html><html><head>${stylesHtml}</head>
            <body style="width:100%; height:auto; table tr th{padding:2px;}; table tr td{padding:2px;}">
                ${prtHtml}
            </body>
            </html>`);

            window.document.close();
            window.focus();
            window.print();
            window.close();
            window.location.href = '/Umrhbookingdyn';
        },
        umrahBookingQuery() {
            if(this.umrahDyn.customers.mobileNo != ""){
                if(this.umrahDyn.transport && (this.umrahDyn.sector === "" && this.umrahDyn.vehicle === "")){
                    this.$toast.error('Sector And Vehicle Type field is required.');
                    return false;
                }else{
                    for (let hotelIndex in this.umrahDyn.hotel){
                        if(this.umrahDyn.hotel[hotelIndex].umrahHotelId == ""){
                            this.$toast.error('Hotel Name field is required.');
                            return false;
                        }else if(this.umrahDyn.hotel[hotelIndex].checkIn == ""){
                            this.$toast.error('Hotel check In field is required.');
                            return false;
                        }else if(this.umrahDyn.hotel[hotelIndex].checkOut == ""){
                            this.$toast.error('Hotel check Out field is required.');
                            return false;
                        }else if(this.umrahDyn.hotel[hotelIndex].totalRooms.rooms == 0){
                            this.$toast.error('Hotel Rooms are required.');
                            return false;
                        }
                    }
                    this.loading = true;
                    this.$inertia.post('/Umrhbookingdyn', this.umrahDyn, {
                        onSuccess: (response) => {
                            if(response){
                                this.isModalVisible = true;
                                document.body.style.overflow = "hidden";
                            }else{
                                this.$toast.error('Please Select Rooms.');
                            }
                            this.loading = false;
                        }
                    });
                }
            }else{
                this.$toast.error('Phone Number field is required!');
                return false;
            }
        }
    }
}
</script>
