<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
import LoadingBar from "@/Pages/Website/Ticketing/LoadingBar.vue";
import HotelFormInput from "../../../Layout/Website/HotelFormInput.vue";
</script>
<template>
    <GuestLayout>
        <LoadingBar v-if="loading" />
        <section class="container mx-auto mt-3 md:mt-8" v-else>
            <p class="my-12 flex mx-auto w-full bg-white border rounded-md shadow-md lg:bg-transparent lg:border-0 lg:rounded-none lg:shadow-none"
                v-if="hotelShoppingDetails == ''"> No Data Found</p>
            <div v-if="hotelShoppingDetails != ''" class="grid grid-cols-12 mx-2 gap-4">
                <div class="col-span-12 lg:col-span-8">
                    <div class="col-span-12">
                        <div
                            class="grid grid-cols-12 bg-white px-2 lg:px-8 py-6 border border-gray-300 rounded-md mb-2">
                            <div class="col-span-12">
                                <h1 class=" font-bold text-zinc-700 text-xl capitalize">Enter your details</h1>
                                <p class="mt-3 border border-[#ff2d2d42] bg-zinc-100 p-[8px_8px] lg:p-[17px_48px] rounded-md text-xs md:text-sm text-zinc-600">
                                    <i class="fa-solid fa-circle-exclamation text-gray-400 text-base"></i>
                                    Almost done! Just fill in the
                                    <span class="text-red-500">*</span> required info
                                </p>
                            </div>
                            <div class="col-span-12 mt-4">
                                <form class="grid grid-cols-12" @submit.prevent="hotelOrderCreate">
                                    <div :class="`${responseErrorType} col-span-12 border border-1 border-solid border-gray-400 mt-3 rounded-md  py-1`">
                                        <span class="text-red-700 text-base font-semibold pl-8">{{ responseError }}</span>
                                    </div>
                                    <div class="col-span-12 mt-2">
                                        <fieldset class="grid grid-cols-12 bg-gray-100 gap-x-1 gap-y-4 border border-1 border-solid border-gray-400 p-2 rounded-md shadow-[0px_3px_9px_0px_#f3f3f3] mb-3 lg:px-4 pt-3 pb-4 lg:pb-4">
                                            <legend class="font-semibold text-lg pl-3  pb-3 pt-3 capitalize">Contact information</legend>
                                            <div class="col-span-12 sm:col-span-6 lg:col-span-6 xl:col-span-5">
                                                <div class="relative mb-5 lg:mb-0 z-0">
                                                    <input type="text" id="email_address"
                                                        v-model="guestForm.contactDetails.email"
                                                        v-on:input="isEmpty(0, 'email', guestForm.contactDetails.email, 'email')"
                                                        v-on:change="isEmpty(0, 'email', guestForm.contactDetails.email, 'email')"
                                                        :class="`${(errors['email'] === 'error' ? 'bg-red-50 border border-red-500 text-red-900' : 'border-gray-400')}
                                                        block lowercase px-2.5 py-[6px] w-full border-solid  bg-white hover:border hover:border-solid hover:border-gray-500 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                                                        v-on:keypress="isValidEmail" placeholder=""
                                                        autoComplete="off" />
                                                    <label for="email_address"
                                                        class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                                        Email Address <span class="text-red-600 font-bold text-base"
                                                            v-if="errors['email'] === 'error'">*</span></label>
                                                </div>
                                            </div>
                                            <div
                                                class="col-span-12 sm:col-span-6 sm:mb-2 lg:mt-0 lg:mb-4 lg:col-span-6 xl:col-span-6">
                                                <div class="grid grid-cols-12 relative mb-5">
                                                    <div
                                                        class="col-span-4 xs:col-span-3 sm:col-span-5 md:col-span-4 xl:col-span-3">
                                                        <div class="relative">
                                                            <input type="text"
                                                                v-model="guestForm.contactDetails.areaCode"
                                                                v-on:input="isEmpty(0, 'areaCode', guestForm.contactDetails.areaCode, 'areaCode')"
                                                                v-on:change="isEmpty(0, 'areaCode', guestForm.contactDetails.areaCode, 'areaCode')"
                                                                @input="handleInputEvent"
                                                                @keydown.arrow-down="handleKeyDown"
                                                                @keydown.arrow-up="handleKeyDown"
                                                                @keydown.enter="handleKeyDown" @focus="handleFocus"
                                                                @blur="handleBlur" @click="handleClick" ref="areaCode"
                                                                autocomplete="off" placeholder="Area Code"
                                                                :class="`${(errors['areaCode'] === 'error' ? 'bg-red-50 border-red-500 text-red-900' : '')}  placeholder:text-gray-400 placeholder:text-sm block bg-white px-2.5 py-[6px] w-full rounded-tl-md rounded-bl-md lowercase border border-r-0 border-solid hover:border hover:border-solid hover:border-gray-500 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent appearance-none focus:ring-0 focus:border-blue-600 peer`" />
                                                            <span class="absolute top-[7px] right-[8px]"
                                                                @click="toggleDropdown">
                                                                <i v-if="!isInputFocused"
                                                                    class="fa fa-caret-down text-sm text-gray-400"></i>
                                                                <i v-if="isInputFocused"
                                                                    class="fa fa-search text-sm text-gray-400"></i>
                                                            </span>
                                                        </div>
                                                        <div v-if="filteredCountries.length > 0"
                                                            class="absolute top-42 rounded max-w-52 max-h-52 border bg-white border-gray-400 border-solid overflow-y-auto z-20"
                                                            ref="listContainer">
                                                            <div v-for="(country, index) in filteredCountries"
                                                                :key="index" @click="selectCountry(index)"
                                                                class="p-2 cursor-pointer text-sm w-44"
                                                                :class="{ 'bg-gray-200': index === currentFocus }"
                                                                ref="item" @mouseenter="currentFocus = index">
                                                                <span v-html="highlightMatch(country)"></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div
                                                        class="col-span-8 xs:col-span-9 sm:col-span-7 md:col-span-8 xl:col-span-9 ">
                                                        <input type="tel" id="mobileNo"
                                                            v-model="guestForm.contactDetails.mobileNo"
                                                            v-on:input="isEmpty(0, 'mobileNo', guestForm.contactDetails.mobileNo, 'mobileNo')"
                                                            v-on:change="isEmpty(0, 'mobileNo', guestForm.contactDetails.mobileNo, 'mobileNo')"
                                                            :class="`${(errors['email'] === 'error' ? 'bg-red-50 border-red-500 text-red-900' : 'border-gray-400')} placeholder:text-sm placeholder:text-gray-300 bg-white block px-2.5 py-[6px] w-full rounded-tr-md rounded-br-md border border-solid hover:border hover:border-solid hover:border-gray-500 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                                                            v-on:keypress="isValidPhoneNumber" placeholder="3XXXXXXXXX"
                                                            autoComplete="off" />
                                                    </div>
                                                    <label for="date"
                                                        class="absolute text-base text-blue-600 duration-300 transform -translate-y-4 scale-75 -top-2 z-10 origin-[0] peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                                        Mobile No 
                                                        <span v-if="errors['mobileNo'] === 'error'" class="text-red-600 font-bold text-base">*</span>
                                                    </label>
                                                </div>
                                            </div>
                                        </fieldset>
                                        <div class="col-span-12">
                                            <div v-for="(booking, bookingKey) in bookings" :key="bookingKey">
                                                <p class="p-3 bg-bgRGTBaseColor text-white font-bold rounded-t-md">Room
                                                    - {{ bookingKey + 1 }}</p>
                                                <fieldset
                                                    class="grid grid-cols-12 gap-x-1 border border-1 border-solid border-gray-400 bg-gray-100 p-2 rounded-md shadow-[0px_3px_9px_0px_#f3f3f3] mb-3"
                                                    v-for="(bookingDetails, bookingDetailsKey) in booking"
                                                    :key="bookingDetailsKey">
                                                    <legend class="text-lg font-medium mb-4">
                                                        {{ bookingDetails.type }} - {{ bookingDetailsKey + 1 }}
                                                    </legend>
                                                    <div class="col-span-12 mt-1 mb-3 sm:col-span-6 sm:mb-5 lg:mt-0 lg:mb-4 lg:col-span-4 xl:col-span-3 relative">
                                                        <ul
                                                            :class="`${(errors['email'] === 'error' ? 'bg-red-50 border-red-500 text-red-900' : 'border-gray-400')} w-full flex items-center bg-white text-sm font-medium text-gray-900 border border-gray-400 border-solid hover:border hover:border-solid hover:border-gray-500 rounded-lg`">
                                                            <li v-for="(option, optionKey) in options[bookingDetails.type]"
                                                                class="w-full focus:ring-0 focus:border-blue-600">
                                                                <div class="flex items-center ps-3">
                                                                    <input
                                                                        v-on:change="isEmpty(bookingKey, 'title', guestForm.persons[bookingKey][bookingDetailsKey].title, bookingDetailsKey)"
                                                                        :checked="(guestForm.persons[bookingKey][bookingDetailsKey].title === option.value)"
                                                                        v-model="guestForm.persons[bookingKey][bookingDetailsKey].title"
                                                                        :id="`${bookingKey}_${bookingDetailsKey}_${optionKey}`"
                                                                        type="radio" :value="option.value"
                                                                        :name="`${bookingKey}_${bookingDetailsKey}_${optionKey}`"
                                                                        :class="`w-4 h-4 text-blue-600 border-gray-400 focus:ring-blue-500 dark:focus:ring-blue-600 focus:ring-2`">
                                                                    <label
                                                                        :for="`${bookingKey}_${bookingDetailsKey}_${optionKey}`"
                                                                        class="w-full py-2 ms-2 text-sm font-medium text-gray-900 ">{{ option.title }}</label>
                                                                </div>
                                                            </li>
                                                        </ul>
                                                        <label
                                                            class="absolute text-base text-blue-600 duration-300 transform -translate-y-4 scale-75 -top-2 z-10 origin-[0] peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                                            Select Title
                                                            <span class="text-red-600 text-sm">{{ (errors.rooms[bookingKey]['title'][bookingDetailsKey] === 'error' ? 'Atleast One' : '')}} </span>
                                                        </label>
                                                    </div>
                                                    <div class="col-span-12 sm:col-span-6 lg:col-span-4 xl:col-span-4">
                                                        <div class="relative mb-5 z-0">
                                                            <input type="text"
                                                                :id="'firstName-' + bookingKey + '-' + bookingDetailsKey"
                                                                v-model="guestForm.persons[bookingKey][bookingDetailsKey].firstName"
                                                                v-on:input="isEmpty(bookingKey, 'firstName', guestForm.persons[bookingKey][bookingDetailsKey].firstName, bookingDetailsKey)"
                                                                :class="`${(errors.rooms[bookingKey]['firstName'][bookingDetailsKey] === 'error' ? 'bg-red-50 border-red-500 text-red-900' : 'border-gray-400')} block px-2.5 py-[6px] w-full border border-solid border-gray-400 hover:border hover:border-solid hover:border-gray-500 bg-white text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                                                                v-on:keypress="isString" placeholder=""
                                                                autoComplete="off" />
                                                            <label :for="'firstName-' + bookingKey + '-' + bookingDetailsKey"
                                                                class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                                                First Name
                                                                <span class="text-red-600 font-bold text-base"
                                                                    v-if="errors.rooms[bookingKey]['firstName'][bookingDetailsKey] === 'error'">
                                                                    *
                                                                </span>
                                                            </label>
                                                        </div>
                                                    </div>
                                                    <div class="col-span-12 sm:col-span-6 lg:col-span-4 xl:col-span-4">
                                                        <div class="relative mb-8 z-0">
                                                            <input type="text"
                                                                :id="'lastName-' + bookingKey + '-' + bookingDetailsKey"
                                                                v-model="guestForm.persons[bookingKey][bookingDetailsKey].lastName"
                                                                v-on:input="isEmpty(bookingKey, 'lastName', guestForm.persons[bookingKey][bookingDetailsKey].lastName, bookingDetailsKey)"
                                                                :class="`${(errors.rooms[bookingKey]['lastName'][bookingDetailsKey] === 'error' ? 'bg-red-50 border-red-500 text-red-900' : 'border-gray-400')} block px-2.5 py-[6px] w-full border border-solid border-gray-400 hover:border hover:border-solid hover:border-gray-500 bg-white text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                                                                v-on:keypress="isString" placeholder=""
                                                                autoComplete="off" />
                                                            <label 
                                                                :for="'lastName-' + bookingKey + '-' + bookingDetailsKey"
                                                                class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                                                Last Name
                                                                <span class="text-red-600 font-bold text-base"
                                                                    v-if="errors.rooms[bookingKey]['lastName'][bookingDetailsKey] === 'error'">
                                                                    *
                                                                </span>
                                                            </label>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-span-12 mb-4 lg:mb-0 flex lg:justify-end justify-center mt-2">
                                        <button type="submit"
                                            class=" border border-solid cursor-pointer relative inline-flex items-center justify-start py-3 pl-4 pr-12 overflow-hidden font-semibold text-white transition-all duration-500 ease-in-out rounded hover:pl-10 hover:pr-6 bg-bgRGTBaseColor group">
                                            <span
                                                class="absolute bottom-0 left-0 w-full transition-all bg-green-600 duration-500 ease-in-out group-hover:h-full"></span>
                                            <span
                                                class="absolute right-0 pr-4 duration-500 ease-out group-hover:translate-x-12"><i
                                                    class="fa-solid fa-arrow-right text-white"></i></span>
                                            <span
                                                class="absolute left-0 pl-2.5 -translate-x-12 group-hover:translate-x-0 ease-out duration-500">
                                                <i class="fa-solid fa-arrow-right text-white"></i></span>
                                            <span
                                                class="relative w-full text-left transition-colors duration-500 ease-in-out group-hover:text-white">Continue
                                                to Next Step </span>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-span-12" v-if="hotelShoppingDetails.rooms">
                        <div
                            class="grid grid-cols-12 bg-white shadow-md px-2 lg:px-8 py-6 border border-gray-300 rounded-md mb-2">
                            <div class="col-span-12">
                                <div class="col-span-full relative">
                                    <h4 class="text-base text-zinc-700 font-semibold capitalize mb-2">Remarks</h4>
                                    <div v-for=" (roomDetails, roomIndex) in hotelShoppingDetails.rooms.room"
                                        :key="roomIndex">
                                        <div v-if="roomIndex === 0" class="pt-3 relative">
                                            <div v-if="roomDetails.remarks">
                                                <div
                                                    class="absolute -left-[8px] md:-left-[14px] h-[15px] w-[15px] mt-[4px] ml-1 rounded-full border-[3px] border-blue-500 bg-white">
                                                </div>
                                                <div class="pl-4">
                                                    <p class="text-sm text-zinc-600 leading-6">{{
                                                        roomDetails.remarks.remark[0].type }} : {{
                                                            roomDetails.remarks.remark[0].text }}</p>
                                                </div>
                                            </div>
                                            <div v-if="roomDetails.policies.policy"
                                                v-for="(policy, policyIndex) in roomDetails.policies.policy"
                                                :key="policyIndex">
                                                <div v-if="policyIndex == 0">
                                                    <div class="pl-4">
                                                        <span
                                                            class="absolute -left-[8px] md:-left-[14px] h-[15px] w-[15px] mt-[4px] ml-1 rounded-full border-[3px] border-blue-500 bg-white"></span>
                                                        <p class="text-sm text-zinc-600 leading-6">{{
                                                            policy.textCondition }} </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div v-if="hotelShoppingDetails.rooms"
                        v-for="(roomDetails, roomIndex) in hotelShoppingDetails.rooms.room" :indexKey="roomIndex">
                        <div class="grid grid-cols-2 px-4 lg:px-6 xl:px-8 py-6 bg-white border border-gray-300 rounded-md mb-5 hover:shadow"
                            v-if="roomIndex === 0">
                            <div class="col-span-full">
                                <p class="text-base text-zinc-700 font-semibold capitalize mb-4">How much will it cost
                                    to cancel?</p>
                                <p class="text-sm text-blue-600 leading-6" v-if="roomDetails.policies.policy">Free
                                    cancellation before {{
                                        cancellationDateFormat(roomDetails.policies.policy[0].condition[0].fromDate) }}</p>
                            </div>
                            <div class="mt-2" v-if="roomDetails.policies.policy"
                                v-for="(condition, conditionIndex) in roomDetails.policies.policy[0].condition"
                                :key="conditionIndex">
                                <p class="text-sm text-zinc-600">From {{ condition.fromTime }} on {{
                                    cancellationDateFormat(condition.fromDate) }} To {{ condition.toTime }} on {{
                                        cancellationDateFormat(condition.toDate) }}</p>
                            </div>
                            <div class="mt-2" v-if="roomDetails.policies.policy">
                                <p class="text-sm text-zinc-600 text-right font-bold"> {{ currency.currencyCode }} {{
                                    (hotelShoppingDetails.prices.length > 0 ?
                                        setConverter(hotelShoppingDetails.prices[0].eqnet, currency.currencyRate) :
                                        setConverter(guestForm.payload.net, currency.currencyRate)) }}<sup>*</sup></p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-span-12 lg:col-span-4 xl:col-span-3 mb-5 md:mb-0">
                    <div
                        class="col-span-12 bg-white border rounded-md shadow-md lg:bg-transparent lg:border-0 lg:rounded-none lg:shadow-none">
                        <div
                            class="px-4 lg:px-4 2xl:px-8 py-6 lg:bg-white lg:border lg:border-gray-300 lg:rounded-md lg:mb-2 hover:shadow">
                            <p class="text-base font-semibold text-zinc-600 mb-3">Hotel Details
                                <span class="bg-amber-500 text-white text-xs rounded-[4px] ml-2 px-3 py-1 font-bold">New
                                    on Rehman Travel </span>
                            </p>
                            <p class="text-sm text-zinc-700 mb-1">{{ hotelShoppingDetails.hotelInfo.name }}</p>
                            <p class="text-xs text-zinc-600"><i class="fas fa-map-marker-alt text-xs"></i> {{
                                hotelShoppingDetails.hotelInfo.add1 }}, {{
                                    hotelShoppingDetails.hotelInfo.add2 }}</p>
                        </div>
                        <div
                            class="grid grid-cols-2 lg:bg-white lg:border lg:border-gray-300 lg:rounded-md mb-5 hover:shadow">
                            <div class="col-span-full px-4 lg:px-6 2xl:px-8 pt-6">
                                <p class="text-base text-zinc-700 font-semibold capitalize mb-4">Your price summary</p>
                            </div>
                            <div class="bg-bgRGTBaseColor pl-4 lg:pl-4 xl:pl-8">
                                <h2 class="text-lg md:text-2xl lg:text-xl text-white font-extrabold pt-4">Total</h2>
                            </div>
                            <div class="bg-bgRGTBaseColor">
                                <h2
                                    class="text-lg md:text-2xl lg:text-xl text-white font-extrabold pt-4 text-right pr-3">
                                    {{ currency.currencyCode }} {{ (hotelShoppingDetails.prices.length > 0 ?
                                        setConverter(hotelShoppingDetails.prices[0].eqnet, currency.currencyRate) :
                                        setConverter(guestForm.payload.net, currency.currencyRate)) }}</h2>
                            </div>
                            <div
                                class="col-span-full bg-bgRGTBaseColor text-right text-xs sm:text-sm text-slate-200 pt-1 pb-3 pr-3">
                                <p>Includes taxes and charges</p>
                                <p>In property currency: USD {{ (hotelShoppingDetails.prices.length > 0 ?
                                    roundAmount(hotelShoppingDetails.prices[0].eqnet) :
                                    roundAmount(guestForm.payload.net)) }}</p>
                            </div>
                            <div class="col-span-full relative px-4 lg:px-6 xl:px-8 pt-6">
                                <h4 class="text-base text-zinc-700 font-semibold capitalize mb-4">Price information</h4>
                                <div class="relative border-l border-blue-500 border-dashed">
                                    <div
                                        class="absolute -top-1 -left-[14px] h-5 w-5 mt-1 ml-1 rounded-full border-[3px] border-blue-500 bg-white">
                                    </div>
                                    <div class="pl-4">
                                        <p class="text-sm text-zinc-600 leading-6">Includes <strong>{{
                                            currency.currencyCode }} {{ (hotelShoppingDetails.prices.length > 0 ?
                                                    setConverter(hotelShoppingDetails.prices[0].eqtax,
                                                        currency.currencyRate) : setConverter(guestForm.payload.tax,
                                                            currency.currencyRate)) }}</strong> in taxes and charges</p>
                                    </div>
                                </div>
                                <div class="pt-5 relative border-l border-blue-500 border-dashed">
                                    <div
                                        class="absolute top-11 sm:top-6 lg:top-11 -left-[14px] h-5 w-5 mt-1 ml-1 rounded-full border-[3px] border-blue-500 bg-white">
                                    </div>
                                    <div class="pl-4">
                                        <p class="text-sm text-zinc-600 leading-6 ">This price is converted to show you
                                            the approximate cost in <strong>{{ currency.currencyCode }}</strong>. You'll
                                            pay in <strong>$</strong>.The exchange rate may change
                                            before you pay.</p>
                                    </div>
                                </div>
                                <div class="pt-5 mb-3 relative border-l border-blue-500 border-dashed">
                                    <div
                                        class="absolute bottom-0 -left-[14px] h-5 w-5 mt-1 ml-1 rounded-full border-[3px] border-blue-500 bg-white">
                                    </div>
                                    <div class="pl-4">
                                        <p class="text-sm text-zinc-600 leading-6 ">Bear in mind that your card issuer
                                            may charge you a foreign transaction fee.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="lg:hidden block relative pb-4 mb-3 mt-5">
                            <div
                                class="fixed lg:static bottom-0 py-1 container -ml-[8px] lg:mx-0 lg:w-full bg-white border-2 border-blue-400 shadow-md z-10">
                                <div class="lg:relative flex justify-between items-center px-4 lg:px-0">
                                    <div class="flex flex-inline items-start text-white">
                                        <span class="font-bold text-2xl ml-2 text-blue-600 italic">
                                            <span class="text-sm font-medium text-black">{{ currency.currencyCode
                                                }}:</span> {{ (hotelShoppingDetails.prices.length > 0 ? setConverter(hotelShoppingDetails.prices[0].eqnet, currency.currencyRate) : setConverter(guestForm.payload.net, currency.currencyRate)) }}</span>
                                    </div>
                                    <button @click="hotelOrderCreate"
                                        class="px-3 py-2 bg-blue-600 hover:bg-green-600 text-white font-semibold text-lg rounded-xl shadow-lg transition-all duration-300 ease-in-out  animate-pulse">
                                        Continue
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div
                            class="grid grid-cols-2 px-4 lg:px-6 xl:px-8 lg:py-6 lg:bg-white lg:border lg:border-gray-300 lg:rounded-md lg:mb-2 hover:shadow">
                            <div class="col-span-full">
                                <p class="text-base text-zinc-700 font-semibold mb-4 capitalize">Your booking details
                                </p>
                            </div>
                            <div class="pr-3 xxs:pr-4 border-b sm:border-0 border-gray-200 ">
                                <p class="text-sm font-medium text-zinc-700 mb-1">Check-in</p>
                                <p class="text-sm font-semibold text-zinc-700">{{
                                    dateFormate(guestForm.payload.checkInDate) }}
                                </p>
                                <p class="text-sm text-zinc-500"><i class="fa-regular fa-clock"></i> 12:00 – 08:00</p>
                            </div>
                            <div class="pl-3 xxs:pl-4 border-b  sm:border-0 border-gray-200 ">
                                <p class="text-sm font-medium text-zinc-700 mb-1">Check-out</p>
                                <p class="text-sm font-semibold text-zinc-700">{{
                                    dateFormate(guestForm.payload.checkOutDate) }}
                                </p>
                                <p class="text-sm text-zinc-500"><i class="fa-regular fa-clock"></i> 08:00 – 11:00</p>
                            </div>
                            <div class="col-span-full border-b border-gray-200 pb-4 mt-5">
                                <p class="text-sm font-semibold text-zinc-700">Total length of stay:</p>
                                <p class="text-sm text-zinc-500 capitalize"><i class="fa-regular fa-moon"></i>
                                    {{ totalNights }} nights</p>
                            </div>
                            <div class="col-span-full mt-4">
                                <p class="text-sm font-semibold text-zinc-700">You Selected :</p>
                                <p class="text-sm text-zinc-500"><i class="fa-solid fa-users"></i> {{
                                    guestForm.payload.rooms }}
                                    Room For {{ guestForm.payload.adultCount }} Adult, {{ guestForm.payload.childCount
                                    }} Child </p>
                            </div>
                        </div>
                        <div v-if="hotelShoppingDetails.rooms"
                            v-for="(roomDetails, roomIndex) in hotelShoppingDetails.rooms.room"
                            :indexKey="roomIndex"
                            class="px-4 lg:px-6 xl:px-8 py-6 lg:bg-white lg:border lg:border-gray-300 lg:rounded-md lg:mb-2 hover:shadow">
                            <p class="text-xs text-zinc-600 mb-3">Room Details</p>
                            <p class="text-base text-zinc-700 font-semibold mb-1">{{ roomDetails.roomName }}</p>
                            <p class="text-sm text-zinc-500"><i class="fa-regular fa-circle-check text-xs"></i> {{
                                roomDetails.rateType }}</p>
                            <p class="text-sm text-zinc-500 capitalize"><i
                                    class="fa-regular fa-circle-check text-xs"></i> {{ roomDetails.meal }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

    </GuestLayout>
</template>

<script>
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
            responseError: "",
            responseErrorType: 'hidden',
            options: {
                'Adult': [{ 'title': 'Mr', value: 'Mr' }, { 'title': 'Mrs', value: 'Mrs' }, { 'title': 'Ms', value: 'Ms' }],
                'Child': [{ 'title': 'Master', value: 'Master' }, { 'title': 'Miss', value: 'Miss' }],
            },
            hotelShoppingDetails: [],
            loading: false,
            isInputFocused: false,
            guests: 0,
            totalNights: 0,
            errors: {
                email: "",
                areaCode: "",
                countryCode: "",
                mobileNo: "",
                rooms: [{
                    title: [],
                    firstName: [],
                    lastName: [],
                }]
            },
            guestForm: {
                payload: { type: Object },
                contactDetails: {
                    countryCode: 92,
                    areaCode: '',
                    mobileNo: '',
                    email: '',
                },
                bookingIds: [],
                persons: [],
                availablePrices: JSON.parse(localStorage.getItem('avP'))
            },
            currentFocus: 92,
            filteredCountries: [],
            countries: [{ "name": "Pakistan", "dialCode": "+92", "code": "PK" }, { "name": "Afghanistan", "dialCode": "+93", "code": "AF" }, { "name": "Aland Islands", "dialCode": "+358", "code": "AX" }, { "name": "Albania", "dialCode": "+355", "code": "AL" }, { "name": "Algeria", "dialCode": "+213", "code": "DZ" }, { "name": "AmericanSamoa", "dialCode": "+1684", "code": "AS" }, { "name": "Andorra", "dialCode": "+376", "code": "AD" }, { "name": "Angola", "dialCode": "+244", "code": "AO" }, { "name": "Anguilla", "dialCode": "+1264", "code": "AI" }, { "name": "Antarctica", "dialCode": "+672", "code": "AQ" }, { "name": "Antigua and Barbuda", "dialCode": "+1268", "code": "AG" }, { "name": "Argentina", "dialCode": "+54", "code": "AR" }, { "name": "Armenia", "dialCode": "+374", "code": "AM" }, { "name": "Aruba", "dialCode": "+297", "code": "AW" }, { "name": "Australia", "dialCode": "+61", "code": "AU" }, { "name": "Austria", "dialCode": "+43", "code": "AT" }, { "name": "Azerbaijan", "dialCode": "+994", "code": "AZ" }, { "name": "Bahamas", "dialCode": "+1242", "code": "BS" }, { "name": "Bahrain", "dialCode": "+973", "code": "BH" }, { "name": "Bangladesh", "dialCode": "+880", "code": "BD" }, { "name": "Barbados", "dialCode": "+1246", "code": "BB" }, { "name": "Belarus", "dialCode": "+375", "code": "BY" }, { "name": "Belgium", "dialCode": "+32", "code": "BE" }, { "name": "Belize", "dialCode": "+501", "code": "BZ" }, { "name": "Benin", "dialCode": "+229", "code": "BJ" }, { "name": "Bermuda", "dialCode": "+1441", "code": "BM" }, { "name": "Bhutan", "dialCode": "+975", "code": "BT" }, { "name": "Bolivia, Plurinational State of", "dialCode": "+591", "code": "BO" }, { "name": "Bosnia and Herzegovina", "dialCode": "+387", "code": "BA" }, { "name": "Botswana", "dialCode": "+267", "code": "BW" }, { "name": "Brazil", "dialCode": "+55", "code": "BR" }, { "name": "British Indian Ocean Territory", "dialCode": "+246", "code": "IO" }, { "name": "Brunei Darussalam", "dialCode": "+673", "code": "BN" }, { "name": "Bulgaria", "dialCode": "+359", "code": "BG" }, { "name": "Burkina Faso", "dialCode": "+226", "code": "BF" }, { "name": "Burundi", "dialCode": "+257", "code": "BI" }, { "name": "Cambodia", "dialCode": "+855", "code": "KH" }, { "name": "Cameroon", "dialCode": "+237", "code": "CM" }, { "name": "Canada", "dialCode": "+1", "code": "CA" }, { "name": "Cape Verde", "dialCode": "+238", "code": "CV" }, { "name": "Cayman Islands", "dialCode": "+ 345", "code": "KY" }, { "name": "Central African Republic", "dialCode": "+236", "code": "CF" }, { "name": "Chad", "dialCode": "+235", "code": "TD" }, { "name": "Chile", "dialCode": "+56", "code": "CL" }, { "name": "China", "dialCode": "+86", "code": "CN" }, { "name": "Christmas Island", "dialCode": "+61", "code": "CX" }, { "name": "Cocos (Keeling) Islands", "dialCode": "+61", "code": "CC" }, { "name": "Colombia", "dialCode": "+57", "code": "CO" }, { "name": "Comoros", "dialCode": "+269", "code": "KM" }, { "name": "Congo", "dialCode": "+242", "code": "CG" }, { "name": "Congo, The Democratic Republic of the Congo", "dialCode": "+243", "code": "CD" }, { "name": "Cook Islands", "dialCode": "+682", "code": "CK" }, { "name": "Costa Rica", "dialCode": "+506", "code": "CR" }, { "name": "Cote d'Ivoire", "dialCode": "+225", "code": "CI" }, { "name": "Croatia", "dialCode": "+385", "code": "HR" }, { "name": "Cuba", "dialCode": "+53", "code": "CU" }, { "name": "Cyprus", "dialCode": "+357", "code": "CY" }, { "name": "Czech Republic", "dialCode": "+420", "code": "CZ" }, { "name": "Denmark", "dialCode": "+45", "code": "DK" }, { "name": "Djibouti", "dialCode": "+253", "code": "DJ" }, { "name": "Dominica", "dialCode": "+1767", "code": "DM" }, { "name": "Dominican Republic", "dialCode": "+1849", "code": "DO" }, { "name": "Ecuador", "dialCode": "+593", "code": "EC" }, { "name": "Egypt", "dialCode": "+20", "code": "EG" }, { "name": "El Salvador", "dialCode": "+503", "code": "SV" }, { "name": "Equatorial Guinea", "dialCode": "+240", "code": "GQ" }, { "name": "Eritrea", "dialCode": "+291", "code": "ER" }, { "name": "Estonia", "dialCode": "+372", "code": "EE" }, { "name": "Ethiopia", "dialCode": "+251", "code": "ET" }, { "name": "Falkland Islands (Malvinas)", "dialCode": "+500", "code": "FK" }, { "name": "Faroe Islands", "dialCode": "+298", "code": "FO" }, { "name": "Fiji", "dialCode": "+679", "code": "FJ" }, { "name": "Finland", "dialCode": "+358", "code": "FI" }, { "name": "France", "dialCode": "+33", "code": "FR" }, { "name": "French Guiana", "dialCode": "+594", "code": "GF" }, { "name": "French Polynesia", "dialCode": "+689", "code": "PF" }, { "name": "Gabon", "dialCode": "+241", "code": "GA" }, { "name": "Gambia", "dialCode": "+220", "code": "GM" }, { "name": "Georgia", "dialCode": "+995", "code": "GE" }, { "name": "Germany", "dialCode": "+49", "code": "DE" }, { "name": "Ghana", "dialCode": "+233", "code": "GH" }, { "name": "Gibraltar", "dialCode": "+350", "code": "GI" }, { "name": "Greece", "dialCode": "+30", "code": "GR" }, { "name": "Greenland", "dialCode": "+299", "code": "GL" }, { "name": "Grenada", "dialCode": "+1473", "code": "GD" }, { "name": "Guadeloupe", "dialCode": "+590", "code": "GP" }, { "name": "Guam", "dialCode": "+1671", "code": "GU" }, { "name": "Guatemala", "dialCode": "+502", "code": "GT" }, { "name": "Guernsey", "dialCode": "+44", "code": "GG" }, { "name": "Guinea", "dialCode": "+224", "code": "GN" }, { "name": "Guinea-Bissau", "dialCode": "+245", "code": "GW" }, { "name": "Guyana", "dialCode": "+595", "code": "GY" }, { "name": "Haiti", "dialCode": "+509", "code": "HT" }, { "name": "Holy See (Vatican City State)", "dialCode": "+379", "code": "VA" }, { "name": "Honduras", "dialCode": "+504", "code": "HN" }, { "name": "Hong Kong", "dialCode": "+852", "code": "HK" }, { "name": "Hungary", "dialCode": "+36", "code": "HU" }, { "name": "Iceland", "dialCode": "+354", "code": "IS" }, { "name": "India", "dialCode": "+91", "code": "IN" }, { "name": "Indonesia", "dialCode": "+62", "code": "ID" }, { "name": "Iran, Islamic Republic of Persian Gulf", "dialCode": "+98", "code": "IR" }, { "name": "Iraq", "dialCode": "+964", "code": "IQ" }, { "name": "Ireland", "dialCode": "+353", "code": "IE" }, { "name": "Isle of Man", "dialCode": "+44", "code": "IM" }, { "name": "Israel", "dialCode": "+972", "code": "IL" }, { "name": "Italy", "dialCode": "+39", "code": "IT" }, { "name": "Jamaica", "dialCode": "+1876", "code": "JM" }, { "name": "Japan", "dialCode": "+81", "code": "JP" }, { "name": "Jersey", "dialCode": "+44", "code": "JE" }, { "name": "Jordan", "dialCode": "+962", "code": "JO" }, { "name": "Kazakhstan", "dialCode": "+77", "code": "KZ" }, { "name": "Kenya", "dialCode": "+254", "code": "KE" }, { "name": "Kiribati", "dialCode": "+686", "code": "KI" }, { "name": "Korea, Democratic People's Republic of Korea", "dialCode": "+850", "code": "KP" }, { "name": "Korea, Republic of South Korea", "dialCode": "+82", "code": "KR" }, { "name": "Kuwait", "dialCode": "+965", "code": "KW" }, { "name": "Kyrgyzstan", "dialCode": "+996", "code": "KG" }, { "name": "Laos", "dialCode": "+856", "code": "LA" }, { "name": "Latvia", "dialCode": "+371", "code": "LV" }, { "name": "Lebanon", "dialCode": "+961", "code": "LB" }, { "name": "Lesotho", "dialCode": "+266", "code": "LS" }, { "name": "Liberia", "dialCode": "+231", "code": "LR" }, { "name": "Libyan Arab Jamahiriya", "dialCode": "+218", "code": "LY" }, { "name": "Liechtenstein", "dialCode": "+423", "code": "LI" }, { "name": "Lithuania", "dialCode": "+370", "code": "LT" }, { "name": "Luxembourg", "dialCode": "+352", "code": "LU" }, { "name": "Macao", "dialCode": "+853", "code": "MO" }, { "name": "Macedonia", "dialCode": "+389", "code": "MK" }, { "name": "Madagascar", "dialCode": "+261", "code": "MG" }, { "name": "Malawi", "dialCode": "+265", "code": "MW" }, { "name": "Malaysia", "dialCode": "+60", "code": "MY" }, { "name": "Maldives", "dialCode": "+960", "code": "MV" }, { "name": "Mali", "dialCode": "+223", "code": "ML" }, { "name": "Malta", "dialCode": "+356", "code": "MT" }, { "name": "Marshall Islands", "dialCode": "+692", "code": "MH" }, { "name": "Martinique", "dialCode": "+596", "code": "MQ" }, { "name": "Mauritania", "dialCode": "+222", "code": "MR" }, { "name": "Mauritius", "dialCode": "+230", "code": "MU" }, { "name": "Mayotte", "dialCode": "+262", "code": "YT" }, { "name": "Mexico", "dialCode": "+52", "code": "MX" }, { "name": "Micronesia, Federated States of Micronesia", "dialCode": "+691", "code": "FM" }, { "name": "Moldova", "dialCode": "+373", "code": "MD" }, { "name": "Monaco", "dialCode": "+377", "code": "MC" }, { "name": "Mongolia", "dialCode": "+976", "code": "MN" }, { "name": "Montenegro", "dialCode": "+382", "code": "ME" }, { "name": "Montserrat", "dialCode": "+1664", "code": "MS" }, { "name": "Morocco", "dialCode": "+212", "code": "MA" }, { "name": "Mozambique", "dialCode": "+258", "code": "MZ" }, { "name": "Myanmar", "dialCode": "+95", "code": "MM" }, { "name": "Namibia", "dialCode": "+264", "code": "NA" }, { "name": "Nauru", "dialCode": "+674", "code": "NR" }, { "name": "Nepal", "dialCode": "+977", "code": "NP" }, { "name": "Netherlands", "dialCode": "+31", "code": "NL" }, { "name": "Netherlands Antilles", "dialCode": "+599", "code": "AN" }, { "name": "New Caledonia", "dialCode": "+687", "code": "NC" }, { "name": "New Zealand", "dialCode": "+64", "code": "NZ" }, { "name": "Nicaragua", "dialCode": "+505", "code": "NI" }, { "name": "Niger", "dialCode": "+227", "code": "NE" }, { "name": "Nigeria", "dialCode": "+234", "code": "NG" }, { "name": "Niue", "dialCode": "+683", "code": "NU" }, { "name": "Norfolk Island", "dialCode": "+672", "code": "NF" }, { "name": "Northern Mariana Islands", "dialCode": "+1670", "code": "MP" }, { "name": "Norway", "dialCode": "+47", "code": "NO" }, { "name": "Oman", "dialCode": "+968", "code": "OM" }, { "name": "Palau", "dialCode": "+680", "code": "PW" }, { "name": "Palestinian Territory, Occupied", "dialCode": "+970", "code": "PS" }, { "name": "Panama", "dialCode": "+507", "code": "PA" }, { "name": "Papua New Guinea", "dialCode": "+675", "code": "PG" }, { "name": "Paraguay", "dialCode": "+595", "code": "PY" }, { "name": "Peru", "dialCode": "+51", "code": "PE" }, { "name": "Philippines", "dialCode": "+63", "code": "PH" }, { "name": "Pitcairn", "dialCode": "+872", "code": "PN" }, { "name": "Poland", "dialCode": "+48", "code": "PL" }, { "name": "Portugal", "dialCode": "+351", "code": "PT" }, { "name": "Puerto Rico", "dialCode": "+1939", "code": "PR" }, { "name": "Qatar", "dialCode": "+974", "code": "QA" }, { "name": "Romania", "dialCode": "+40", "code": "RO" }, { "name": "Russia", "dialCode": "+7", "code": "RU" }, { "name": "Rwanda", "dialCode": "+250", "code": "RW" }, { "name": "Reunion", "dialCode": "+262", "code": "RE" }, { "name": "Saint Barthelemy", "dialCode": "+590", "code": "BL" }, { "name": "Saint Helena, Ascension and Tristan Da Cunha", "dialCode": "+290", "code": "SH" }, { "name": "Saint Kitts and Nevis", "dialCode": "+1869", "code": "KN" }, { "name": "Saint Lucia", "dialCode": "+1758", "code": "LC" }, { "name": "Saint Martin", "dialCode": "+590", "code": "MF" }, { "name": "Saint Pierre and Miquelon", "dialCode": "+508", "code": "PM" }, { "name": "Saint Vincent and the Grenadines", "dialCode": "+1784", "code": "VC" }, { "name": "Samoa", "dialCode": "+685", "code": "WS" }, { "name": "San Marino", "dialCode": "+378", "code": "SM" }, { "name": "Sao Tome and Principe", "dialCode": "+239", "code": "ST" }, { "name": "Saudi Arabia", "dialCode": "+966", "code": "SA" }, { "name": "Senegal", "dialCode": "+221", "code": "SN" }, { "name": "Serbia", "dialCode": "+381", "code": "RS" }, { "name": "Seychelles", "dialCode": "+248", "code": "SC" }, { "name": "Sierra Leone", "dialCode": "+232", "code": "SL" }, { "name": "Singapore", "dialCode": "+65", "code": "SG" }, { "name": "Slovakia", "dialCode": "+421", "code": "SK" }, { "name": "Slovenia", "dialCode": "+386", "code": "SI" }, { "name": "Solomon Islands", "dialCode": "+677", "code": "SB" }, { "name": "Somalia", "dialCode": "+252", "code": "SO" }, { "name": "South Africa", "dialCode": "+27", "code": "ZA" }, { "name": "South Sudan", "dialCode": "+211", "code": "SS" }, { "name": "South Georgia and the South Sandwich Islands", "dialCode": "+500", "code": "GS" }, { "name": "Spain", "dialCode": "+34", "code": "ES" }, { "name": "Sri Lanka", "dialCode": "+94", "code": "LK" }, { "name": "Sudan", "dialCode": "+249", "code": "SD" }, { "name": "Suriname", "dialCode": "+597", "code": "SR" }, { "name": "Svalbard and Jan Mayen", "dialCode": "+47", "code": "SJ" }, { "name": "Swaziland", "dialCode": "+268", "code": "SZ" }, { "name": "Sweden", "dialCode": "+46", "code": "SE" }, { "name": "Switzerland", "dialCode": "+41", "code": "CH" }, { "name": "Syrian Arab Republic", "dialCode": "+963", "code": "SY" }, { "name": "Taiwan", "dialCode": "+886", "code": "TW" }, { "name": "Tajikistan", "dialCode": "+992", "code": "TJ" }, { "name": "Tanzania, United Republic of Tanzania", "dialCode": "+255", "code": "TZ" }, { "name": "Thailand", "dialCode": "+66", "code": "TH" }, { "name": "Timor-Leste", "dialCode": "+670", "code": "TL" }, { "name": "Togo", "dialCode": "+228", "code": "TG" }, { "name": "Tokelau", "dialCode": "+690", "code": "TK" }, { "name": "Tonga", "dialCode": "+676", "code": "TO" }, { "name": "Trinidad and Tobago", "dialCode": "+1868", "code": "TT" }, { "name": "Tunisia", "dialCode": "+216", "code": "TN" }, { "name": "Turkey", "dialCode": "+90", "code": "TR" }, { "name": "Turkmenistan", "dialCode": "+993", "code": "TM" }, { "name": "Turks and Caicos Islands", "dialCode": "+1649", "code": "TC" }, { "name": "Tuvalu", "dialCode": "+688", "code": "TV" }, { "name": "Uganda", "dialCode": "+256", "code": "UG" }, { "name": "Ukraine", "dialCode": "+380", "code": "UA" }, { "name": "United Arab Emirates", "dialCode": "+971", "code": "AE" }, { "name": "United Kingdom", "dialCode": "+44", "code": "GB" }, { "name": "United States", "dialCode": "+1", "code": "US" }, { "name": "Uruguay", "dialCode": "+598", "code": "UY" }, { "name": "Uzbekistan", "dialCode": "+998", "code": "UZ" }, { "name": "Vanuatu", "dialCode": "+678", "code": "VU" }, { "name": "Venezuela, Bolivarian Republic of Venezuela", "dialCode": "+58", "code": "VE" }, { "name": "Vietnam", "dialCode": "+84", "code": "VN" }, { "name": "Virgin Islands, British", "dialCode": "+1284", "code": "VG" }, { "name": "Virgin Islands, U.S.", "dialCode": "+1340", "code": "VI" }, { "name": "Wallis and Futuna", "dialCode": "+681", "code": "WF" }, { "name": "Yemen", "dialCode": "+967", "code": "YE" }, { "name": "Zambia", "dialCode": "+260", "code": "ZM" }, { "name": "Zimbabwe", "dialCode": "+263", "code": "ZW" }]
        }
    },
    mounted() {
        const hotelURLSearchParam = this.hotelURLSearchParams();
        this.guestForm.payload = {
            'bckId': hotelURLSearchParam.get('bck'),
            'hotelSessionId': sessionStorage.getItem('hotelSessionId'),
            'customerCode': '',
            'hotelCode': hotelURLSearchParam.get('hc'),
            'groupCode': hotelURLSearchParam.get('gc'),
            'destinationCode': hotelURLSearchParam.get('des'),
            'nationality': hotelURLSearchParam.get('c'),
            'countryCode': hotelURLSearchParam.get('c'),
            'rooms': hotelURLSearchParam.get('rm'),
            'checkInDate': hotelURLSearchParam.get('chi'),
            'checkOutDate': hotelURLSearchParam.get('cho'),
            'adultCount': hotelURLSearchParam.get('ac'),
            'childCount': (hotelURLSearchParam.get('cc') ? hotelURLSearchParam.get('cc') : 0),
            'personsDetails': JSON.parse(localStorage.getItem('arabianOryxSearch')),
            'rateKey': JSON.parse(localStorage.getItem('rRK')),
            'dCurrency': 'USD',
            'dcurrencyRate': this.$page.props.currencies[0].currencyRate,
            'sCurrency': this.currency.currencyCode,
            'sCurrencyRate': this.currency.currencyRate,
            'mka': hotelURLSearchParam.get('mka'),
            'mkt': hotelURLSearchParam.get('mkt'),
            'gross': (JSON.parse(localStorage.getItem('avP')) ? JSON.parse(localStorage.getItem('avP'))[0].gross : hotelURLSearchParam.get('gam')),
            'net': (JSON.parse(localStorage.getItem('avP')) ? JSON.parse(localStorage.getItem('avP'))[0].net : hotelURLSearchParam.get('nam')),
            'tax': (JSON.parse(localStorage.getItem('avP')) ? JSON.parse(localStorage.getItem('avP'))[0].tax : hotelURLSearchParam.get('tam')),
            'eqgross': (JSON.parse(localStorage.getItem('avP')) ? JSON.parse(localStorage.getItem('avP'))[0].eqgross : hotelURLSearchParam.get('gam')),
            'eqnet': (JSON.parse(localStorage.getItem('avP')) ? JSON.parse(localStorage.getItem('avP'))[0].eqnet : hotelURLSearchParam.get('nam')),
            'eqtax': (JSON.parse(localStorage.getItem('avP')) ? JSON.parse(localStorage.getItem('avP'))[0].eqtax : hotelURLSearchParam.get('tam'))
        };
        this.fetchHotels();
        this.guests = Number(this.guestForm.payload.adultCount) + Number(this.guestForm.payload.childCount);
        this.totalNights = hotelURLSearchParam.get('tn');
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
        bookings() {
            this.guestForm.contactDetails.countryCode = '+92'
            for (const [hotelAvailabilityKey, hotelAvailabilities] of Object.entries(this.guestForm.payload.personsDetails)) {
                if (hotelAvailabilityKey > 0) {
                    this.errors.rooms.push({
                        title: [],
                        firstName: [],
                        lastName: [],
                    });
                }
                let personDetails = []
                for (let adult = 1; adult <= parseInt(hotelAvailabilities.adultsCount); adult++) {
                    console.log(hotelAvailabilities.adultsCount)
                    let adultDetails = {
                        'type': 'Adult',
                        'isLeadPax': (adult > 1 ? 0 : 1),
                        'title': '',
                        'firstName': '',
                        'lastName': '',
                        'age': 0,
                    };
                    personDetails.push(adultDetails)
                }
                if (hotelAvailabilities.childrenCount > 0) {
                    for (let child = 1; child <= parseInt(hotelAvailabilities.childrenCount); child++) {
                        console.log(hotelAvailabilities.childrenCount)
                        let childDetails = {
                            'type': 'Child',
                            'isLeadPax': 0,
                            'title': '',
                            'firstName': '',
                            'lastName': '',
                            'age': hotelAvailabilities.age[child - 1],
                        };
                        personDetails.push(childDetails)
                    }
                }
                this.guestForm.persons.push(personDetails);
            }
            return this.guestForm.persons
        },
    },
    methods: {
        roundAmount(amount) {
            return eval(amount).toFixed();
        },
        hotelOrderCreate() {
            if (this.guestForm.contactDetails.areaCode === '') this.errors.areaCode = 'error'
            if (this.guestForm.contactDetails.email === '') this.errors.email = 'error'
            if (this.guestForm.contactDetails.countryCode === '') this.errors.countryCode = 'error'
            if (this.guestForm.contactDetails.mobileNo === '') this.errors.mobileNo = 'error'

            for (const [passengersKey, passengers] of Object.entries(this.guestForm.persons)) {
                for (const [passengerKey, passenger] of Object.entries(passengers)) {
                    if (passenger.title === '') this.errors.rooms[passengersKey].title[passengerKey] = 'error'
                    if (passenger.firstName === '') this.errors.rooms[passengersKey].firstName[passengerKey] = 'error'
                    if (passenger.lastName === '') this.errors.rooms[passengersKey].lastName[passengerKey] = 'error'
                }
            }
            for (const [roomsKey, rooms] of Object.entries(this.errors.rooms)) {
                if (rooms.title.includes('error') || rooms.firstName.includes('error') || rooms.lastName.includes('error')) {
                    return false;
                }
            }
            if (this.errors.areaCode === 'error' || this.errors.email === 'error' || this.errors.countryCode === 'error' || this.errors.mobileNo === 'error'
            ) {
                return false;
            } else {
                console.log(this.guestForm);
                this.loading = true;
                Service.doFetchRequest("/hotel/shopping-order-create", '', this.guestForm).then((resp) => {
                    console.log(resp);
                    if (!resp.error) {
                        const query = "?c=" + this.guestForm.payload.countryCode + "&rm=" + this.guestForm.payload.rooms + "&tn=" + this.totalNights + "&des=" + this.guestForm.payload.destinationCode + "&gc=" + this.guestForm.payload.groupCode
                            + "&hc=" + this.guestForm.payload.hotelCode + "&chi=" + this.guestForm.payload.checkInDate + "&cho=" + this.guestForm.payload.checkOutDate + "&ac=" + this.guestForm.payload.adultCount + "&cc=" + this.guestForm.payload.childCount
                            + "&gam=" + this.guestForm.payload.gross + "&nam=" + this.guestForm.payload.net + "&tam=" + this.guestForm.payload.tax + "&ct=USD&bck=" + this.guestForm.payload.bckId + "&crfm=" + resp.data;
                        window.location.href = "/hotel/shopping-confirmation" + query;
                        this.loading = true;
                    } else {
                        this.$toast.error(resp.data)
                        this.loading = false;
                    }
                });
            }
        },
        isEmpty(bookingKey, fieldName, inputFieldName, bookingDetailsKey) {
            if (fieldName === 'email' && inputFieldName !== '') {
                if (!/^[^\s@]+(\.[^\s@]+)*@[^\s@]+\.[^\s@]{2,3}$/.test(inputFieldName)) {
                    this.errors.email = 'error'
                    return false
                } else {
                    this.errors.email = ''
                    return true
                }
            } else if (fieldName === 'email' && inputFieldName === '') {
                this.errors.email = 'error'
                return false
            }
            if (fieldName === 'areaCode' && inputFieldName !== '') {
                this.errors.areaCode = ''
                return true
            } else if (fieldName === 'areaCode' && inputFieldName === '') {
                this.errors.areaCode = 'error'
                return false
            }

            if (fieldName === 'mobileNo' && inputFieldName !== '') {
                this.errors.mobileNo = ''
                return true
            } else if (fieldName === 'mobileNo' && inputFieldName === '') {
                this.errors.mobileNo = 'error'
                return false
            }

            console.log(bookingKey, fieldName, inputFieldName, bookingDetailsKey);

            if (fieldName === 'title' && inputFieldName !== '') {
                this.errors.rooms[bookingKey].title[bookingDetailsKey] = ''
                return true
            } else if (fieldName === 'title' && inputFieldName === '') {
                this.errors.rooms[bookingKey].title[bookingDetailsKey] = 'error'
                return false
            }
            if (fieldName === 'firstName' && inputFieldName !== '') {
                this.errors.rooms[bookingKey].firstName[bookingDetailsKey] = ''
                return true
            } else if (fieldName === 'firstName' && inputFieldName === '') {
                this.errors.rooms[bookingKey].firstName[bookingDetailsKey] = 'error'
                return false
            }
            if (fieldName === 'lastName' && inputFieldName !== '') {
                this.errors.rooms[bookingKey].lastName[bookingDetailsKey] = ''
                return true
            } else if (fieldName === 'lastName' && inputFieldName === '') {
                this.errors.rooms[bookingKey].lastName[bookingDetailsKey] = 'error'
                return false
            }
        },
        handleClick() {
            this.$refs.areaCode.select();
            this.guestForm.contactDetails.areaCode = ''
            this.filterCountries()
        },
        handleFocus() {
            this.isInputFocused = true;
            this.filterCountries();
        },
        handleKeyDown(event) {
            if (event.key === 'ArrowDown') {
                this.currentFocus++;
                this.scrollList();
            } else if (event.key === 'ArrowUp') {
                this.currentFocus--;
                this.scrollList();
            } else if (event.key === 'Enter') {
                if (this.currentFocus > -1 && this.currentFocus < this.filteredCountries.length) {
                    this.selectCountry(this.currentFocus);
                    this.closeAllLists();
                }
            }
        },
        selectCountry(index) {
            const selectedCountry = this.filteredCountries[index];
            this.guestForm.contactDetails.areaCode = `${selectedCountry.code} (${selectedCountry.dialCode})`;
            this.guestForm.contactDetails.countryCode = selectedCountry.dialCode;
            if (this.guestForm.contactDetails.areaCode !== '') this.errors.areaCode = ''
            if (this.guestForm.contactDetails.countryCode !== '') this.errors.countryCode = ''
            this.closeAllLists();
        },
        closeAllLists() {
            this.filteredCountries = [];
        },
        handleInputEvent(event) {
            this.guestForm.contactDetails.areaCode = event.target.value;
            this.currentFocus = null;
            this.filterCountries();
        },
        filterCountries() {
            const val = this.guestForm.contactDetails.areaCode.toLowerCase();
            this.filteredCountries = this.countries.filter(country =>
                country.name.toLowerCase().includes(val) || country.dialCode.includes(val)
            );
            this.currentFocus = -1;
        },
        highlightMatch(country) {
            const val = this.guestForm.contactDetails.areaCode.toLowerCase();
            const name = country.name;
            const dialCode = country.dialCode;
            const nameMatchIndex = name.toLowerCase().indexOf(val);
            const dialCodeMatchIndex = dialCode.indexOf(val);
            if (nameMatchIndex !== -1) {
                const matchingPart = name.substr(nameMatchIndex, val.length);
                const beforeMatch = name.substr(0, nameMatchIndex);
                const afterMatch = name.substr(nameMatchIndex + val.length);
                return `${beforeMatch}<span class="text-black bg-yellow-200 font-bold text-base">${matchingPart}</span>${afterMatch} (${dialCode})`;
            } else if (dialCodeMatchIndex !== -1) {
                const matchingPart = dialCode.substr(dialCodeMatchIndex, val.length);
                const beforeMatch = dialCode.substr(0, dialCodeMatchIndex);
                const afterMatch = dialCode.substr(dialCodeMatchIndex + val.length);
                return `${name} (${beforeMatch}<span class="bg-yellow-200 font-bold">${matchingPart}</span>${afterMatch})`;
            } else {
                return `${name} (${dialCode})`;
            }
        },
        handleBlur() {
            this.isInputFocused = false;
        },
        isValidEmail(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if (/^[^\s@]+(\.[^\s@]+)*@[^\s@]+\.[^\s@]{2,3}$/.test(selectedCharCode)) return true;
        },
        isString(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if (/^[A-Za-z ]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isValidPhoneNumber(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if (/^[0-9]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        dateFormate(date) {
            const newDateFormate = moment(date, 'DD-MM-YYYY').format("ddd MMMM Do YYYY");
            return newDateFormate;
        },
        cancellationDateFormat(date) {
            const cancellationDateFormate = moment(date).format("MMMM Do");
            return cancellationDateFormate;
        },
        fetchHotels() {
            this.loading = true;
            Service.doFetchRequest("/hotel/shopping-details-retrieve", '', this.guestForm.payload).then((data) => {
                console.log(data);
                if(!data.error){
                    let hotelPriceAndAvailibility = data['hotelPriceAndAvailibility'];
                    this.hotelShoppingDetails = hotelPriceAndAvailibility;
                    this.guestForm.payload.customerCode = hotelPriceAndAvailibility['customerCode'];
                    this.guestForm.bookingIds.push(data['bookingId']);
                }else{
                    let hotelPriceAndAvailibility = data['hotelPriceAndAvailibility'];
                    this.hotelShoppingDetails = hotelPriceAndAvailibility;
                    this.guestForm.payload.customerCode = hotelPriceAndAvailibility['customerCode'];
                    this.guestForm.bookingIds.push(data['bookingId']);
                }
                this.loading = false;
            });
        },
        hotelURLSearchParams: function () {
            return new URLSearchParams(window.location.search);
        },
        setConverter(amount, currencyRate) {
            let getUAECurrency = this.$page.props.currencies[0];
            if (this.currency.currencyCode !== "USD") {
                return HotelCurrencyConverter.doRequest(amount, currencyRate, getUAECurrency.currencyRate);
            } else {
                return eval(amount).toFixed();
            }
        },
    }
}
</script>