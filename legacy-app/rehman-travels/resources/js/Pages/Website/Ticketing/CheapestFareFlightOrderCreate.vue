<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue"
import LoadingBar from "./LoadingBar.vue";
</script>
<template>
    <GuestLayout>
        <section class="container mx-auto mt-8">
            <div class="grid grid-cols-12 gap-4 lg:gap-1">
                <div class=" col-span-12 lg:col-span-9  rounded-md border border-solid border-gray-200 bg-white mb-4">
                    <div class="col-span-12 bg-bgRGTBaseColor rounded-tl-sm rounded-tr-sm">
                        <p class="text-2xl pl-5 pb-1 pt-1 text-white font-semibold me-2 px-2.5 py-0.5 rounded ms-2">Traveler Information</p>
                    </div>
                    <LoadingBar v-if="cheapestFareOrderCreate.loading" />
                    <form class="grid grid-cols-12 px-4" @submit.prevent="cheapestFareFlightOrderCreate">
                        <div :class="`${responseErrorType} col-span-12 border border-1 border-solid border-gray-300 mt-3 rounded-md  py-1`">
                            <span class="text-red-700 text-base font-semibold pl-8">{{responseError}}</span>
                        </div>
                        <div class="col-span-12 mt-2">
                            <fieldset  class="grid grid-cols-12 gap-x-1 gap-y-4 border p-2 rounded-md shadow-[0px_3px_9px_0px_#f3f3f3] mb-3 lg:px-4 pt-3 pb-4 lg:pb-4">
                                <legend class="font-semibold text-lg pl-3  pb-3 pt-3 capitalize">Contact Information</legend>
                                <div class="col-span-12 sm:col-span-6 lg:col-span-6 xl:col-span-5">
                                    <div class="relative mb-5 lg:mb-0 z-0">
                                        <input type="text" id="email_address" v-model="input.email"
                                               v-on:input="isEmpty(0,'email',input.email,'email')"
                                               v-on:change="isEmpty(0,'email',input.email,'email')"
                                               :class="`${(errors['email'] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} block lowercase px-2.5 py-[6px] w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                                               v-on:keypress="isValidEmail"
                                               placeholder=""
                                               autoComplete="off"
                                        />
                                        <label for="email_address"
                                               class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                            Email Address <span class="text-red-600 font-bold text-base" v-if="errors['email'] === 'error'">(Required)</span></label>
                                    </div>
                                </div>
                                <div class="col-span-12 sm:col-span-6 sm:mb-2 lg:mt-0 lg:mb-4 lg:col-span-6 xl:col-span-6">
                                    <div class="grid grid-cols-12 relative mb-5">
                                        <div class="col-span-4 xs:col-span-3 sm:col-span-5 md:col-span-4 xl:col-span-3">
                                            <div class="relative">
                                                <input type="text"
                                                       v-model="input.areaCode"
                                                       v-on:input="isEmpty(0,'areaCode',input.areaCode,'areaCode')"
                                                       v-on:change="isEmpty(0,'areaCode',input.areaCode,'areaCode')"
                                                       @input="handleInputEvent"
                                                       @keydown.arrow-down="handleKeyDown"
                                                       @keydown.arrow-up="handleKeyDown"
                                                       @keydown.enter="handleKeyDown"
                                                       @focus="handleFocus"
                                                       @blur="handleBlur"
                                                       @click="handleClick"
                                                       ref="areaCode"
                                                       autocomplete="off"
                                                       placeholder="Area Code"
                                                       :class="`${(errors['areaCode'] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} placeholder:text-gray-400 placeholder:text-sm block px-2.5 py-[6px] w-full rounded-tl-md rounded-bl-md border-r-0 border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent appearance-none focus:ring-0 focus:border-blue-600 peer`"
                                                />
                                                <span class="absolute top-[7px] right-[8px]" @click="toggleDropdown">
                                                         <i v-if="!isInputFocused" class="fa fa-caret-down text-sm text-gray-400"></i>
                                                         <i v-if="isInputFocused" class="fa fa-search text-sm text-gray-400"></i>
                                                   </span>
                                            </div>
                                            <div v-if="filteredCountries.length > 0" class="absolute top-42 rounded max-w-52 max-h-52 bg-white border border-gray-200 border-solid overflow-y-auto z-20" ref="listContainer">
                                                <div v-for="(country, index) in filteredCountries"
                                                     :key="index"
                                                     @click="selectCountry(index)"
                                                     class="p-2 cursor-pointer text-sm w-44"
                                                     :class="{ 'bg-gray-200': index === currentFocus }"
                                                     ref="item"
                                                     @mouseenter="currentFocus = index">
                                                    <span v-html="highlightMatch(country)"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-span-8 xs:col-span-9 sm:col-span-7 md:col-span-8 xl:col-span-9 ">
                                            <input type="tel" id="mobileNo" v-model="input.mobileNo"
                                                   v-on:input="isEmpty(0,'mobileNo',input.mobileNo,'mobileNo')"
                                                   v-on:change="isEmpty(0,'mobileNo',input.mobileNo,'mobileNo')"
                                                   :class="`${(errors['mobileNo'] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} placeholder:text-sm placeholder:text-gray-300 block px-2.5 py-[6px] w-full rounded-tr-md rounded-br-md  border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                                                   v-on:keypress="isValidPhoneNumber"
                                                   placeholder="3XXXXXXXXX"
                                                   autoComplete="off"
                                            />
                                        </div>
                                        <label for="date" class="absolute text-base text-blue-600 duration-300 transform -translate-y-4 scale-75 -top-2 z-10 origin-[0] bg-white peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                            Mobile No <span class="text-red-600 font-bold text-base" v-if="errors['mobileNo'] === 'error'">(Required)</span></label>
                                    </div>
                                </div>
                            </fieldset>
                        </div>
                        <div class="col-span-12">
                            <fieldset class="grid grid-cols-12 gap-x-1 border p-2 rounded-md shadow-[0px_3px_9px_0px_#f3f3f3] mb-3"  v-for="(booking, bookingKey) in bookings" :key="bookingKey">
                                <legend class="text-lg font-medium mb-4">{{ booking.passengerType }}</legend>
                                <div class="col-span-12 mt-1 mb-6 sm:col-span-6 sm:mb-8 lg:mt-0 lg:mb-7 lg:col-span-4 xl:col-span-3 relative">
                                    <ul :class="`${(errors['nameTitle'][bookingKey] === 'error' ? 'bg-red-50 border border-red-300 text-red-900' :'')} w-full  flex items-center text-sm font-medium text-gray-900 bg-white border border-gray-300 border-solid hover:border hover:border-solid hover:border-gray-400 rounded-lg`">
                                        <li v-for="(option,optionKey) in options[booking.passengerType]" class="w-full focus:ring-0 focus:border-blue-600">
                                            <div  class="flex items-center ps-3" >
                                                <input v-on:change="isEmpty(bookingKey,'nameTitle',input.persons.nameTitle,booking.passengerType)"
                                                       :checked="(input.persons.nameTitle[bookingKey] === option.value)"
                                                       v-model="input.persons.nameTitle[bookingKey]"
                                                       :id="`${bookingKey}_${optionKey}`" type="radio"
                                                       :value="option.value"
                                                       :name="`${bookingKey}_${optionKey}`" :class="`${(errors['nameTitle'][bookingKey] === 'error' ? 'bg-red-50 border border-red-300 text-red-900' :'')} w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 focus:ring-2`">
                                                <label :for="`${bookingKey}_${optionKey}`"  class="w-full py-2 ms-2 text-sm font-medium text-gray-900 ">{{option.title}}</label>
                                            </div>
                                        </li>

                                    </ul>
                                    <label class="absolute text-base text-blue-600 duration-300 transform -translate-y-4 scale-75 -top-2 z-10 origin-[0] bg-white peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">Select Title <span class="text-red-600 text-sm">{{(errors['nameTitle'][bookingKey] === 'error' ? 'Atleast One' : '')}}</span></label>
                                </div>
                                <div class="col-span-12 sm:col-span-6 lg:col-span-4 xl:col-span-3">
                                    <div class="relative mb-5 z-0">
                                        <input type="text" :id="'firstName-'+ bookingKey"
                                               v-model="input.persons.firstName[bookingKey]"
                                               v-on:input="isEmpty(bookingKey,'firstName',input.persons.firstName,booking.passengerType)"
                                               :class="`${(errors['firstName'][bookingKey] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} block px-2.5 py-[6px] w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                                               v-on:keypress="isValidCheapestFareFlightOrderCreateInputField"
                                               placeholder=""
                                               autoComplete="off"
                                        />
                                        <label :for="'firstName-'+ bookingKey"
                                               class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                            First Name <span class="text-red-600 font-bold text-base" v-if="errors['firstName'][bookingKey] === 'error'">(Required)</span></label>
                                    </div>
                                </div>
                                <div class="col-span-12 sm:col-span-6 lg:col-span-4 xl:col-span-3">
                                    <div class="relative mb-8 z-0">
                                        <input type="text"
                                               :id="'lastName-'+ bookingKey"
                                               v-model="input.persons.lastName[bookingKey]"
                                               v-on:input="isEmpty(bookingKey,'lastName',input.persons.lastName,booking.passengerType)"
                                               :class="`${(errors['lastName'][bookingKey] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} block px-2.5 py-[6px] w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-md  appearance-none focus:ring-0 focus:border-blue-600 peer`"
                                               v-on:keypress="isValidCheapestFareFlightOrderCreateInputField"
                                               placeholder=""
                                               autoComplete="off"
                                        />
                                        <label :for="'lastName-'+ bookingKey"
                                               class="absolute text-base text-blue-500  duration-300 transform -translate-y-4 scale-75 -top-[0.5rem] z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-90 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:-top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                            Last Name <span class="text-red-600 font-bold text-base" v-if="errors['lastName'][bookingKey] === 'error'">(Required)</span></label>
                                    </div>
                                </div>
                                <div class="col-span-12 mt-1 sm:col-span-6 sm:mb-2 lg:mt-0 lg:mb-4 lg:col-span-4 xl:col-span-3">
                                    <div class="grid grid-cols-12 relative mb-5">
                                        <div class="col-span-4">
                                            <select v-on:change="isEmpty(bookingKey,'dobDate',input.persons.dobDate,booking.passengerType)" v-model="input.persons.dobDate[bookingKey]"
                                                    :class="`${(errors['dobDate'][bookingKey] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} block px-2.5 py-[6px] w-full rounded-tl-md rounded-bl-md  border-r-0 border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent   appearance-none focus:ring-0 focus:border-blue-600 peer`">
                                                <option v-for="(day, dayKey) in days" ref="selectedDate" :key="dayKey" :value="day.value" >{{day.title}}</option>
                                            </select>
                                        </div>
                                        <div class="col-span-4">
                                            <select v-on:change="isEmpty(bookingKey,'dobMonth',input.persons.dobMonth,booking.passengerType)" v-model="input.persons.dobMonth[bookingKey]"
                                                    :class="`${(errors['dobMonth'][bookingKey] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')}  border border-r-0 hover:border hover:border-solid hover:border-gray-400 border-gray-300 block px-2.5 py-[6px] w-full  border-solid    text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent  focus:ring-0 focus:border-blue-600`">
                                                <option v-for="(month, monthKey) in months" ref="selectedMonth" :key="monthKey" :value="month.value" >{{month.name}}</option>
                                            </select>
                                        </div>
                                        <div class="col-span-4">
                                            <input type="text"
                                                   :id="`dob-year-${bookingKey}`"
                                                   v-model="input.persons.dobYear[bookingKey]"
                                                   v-on:input="isEmpty(bookingKey,'dobYear',input.persons.dobYear,booking.passengerType)"
                                                   v-on:change="isEmpty(bookingKey,'dobYear',input.persons.dobYear,booking.passengerType)"
                                                   :class="`${(errors['dobYear'][bookingKey] === 'error' ? 'bg-red-50 border border-red-300 text-red-900':'')} rounded-tr-lg rounded-br-lg hover:border-gray-400 border-gray-300  block px-2.5 py-[6px] w-full border border-solid hover:border hover:border-solid  text-base font-medium  focus:border focus:border-solid outline-none text-gray-900 bg-transparent appearance-none focus:ring-0 focus:border-blue-600 peer`" maxlength="4" placeholder="YYYY" autocomplete="off"/>
                                        </div>
                                        <label for="date" class="absolute text-base text-blue-600  duration-300 transform -translate-y-4 scale-75 -top-2 z-10 origin-[0] bg-white px-2 peer-focus:px-2  peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
                                            Date Of Birth <span class="text-red-600 font-bold text-base" v-if="errors['dobYear'][bookingKey] === 'error'">(Required)</span></label>
                                    </div>
                                </div>
                            </fieldset>
                        </div>
                        <div class="col-span-12 mb-4 lg:mb-0 flex lg:justify-end justify-center mt-2">
                            <button type="submit"
                                    class=" border border-solid cursor-pointer relative inline-flex items-center justify-start py-3 pl-4 pr-12 overflow-hidden font-semibold text-white transition-all duration-500 ease-in-out rounded hover:pl-10 hover:pr-6 bg-bgRGTBaseColor group">
                                <span
                                    class="absolute bottom-0 left-0 w-full transition-all bg-green-600 duration-500 ease-in-out group-hover:h-full"></span>
                                <span class="absolute right-0 pr-4 duration-500 ease-out group-hover:translate-x-12"><i
                                    class="fa-solid fa-arrow-right text-white"></i></span>
                                <span
                                    class="absolute left-0 pl-2.5 -translate-x-12 group-hover:translate-x-0 ease-out duration-500">
                                    <i class="fa-solid fa-arrow-right text-white"></i></span>
                                <span
                                    class="relative w-full text-left transition-colors duration-500 ease-in-out group-hover:text-white">Continue to Next Step </span>
                            </button>
                        </div>
                    </form>
                </div>
                <div class="col-span-12 lg:col-span-3 bg-white rounded-md mb-4 mx-2">
                    <div class="grid grid-cols-12">
                        <div class="col-span-12  border-b-[1px] border-solid border-gray-300">
                            <p class="text-2xl pl-3 pb-2 pt-2 font-medium bg-bgRGTBaseColor rounded-[0px 0px 10px 0px] text-white capitalize"><i
                                class="fas fa-handshake text-white"></i> Flight Details</p>
                        </div>
                        <div class="col-span-12 xl:mb-2">
                            <div class="grid grid-cols-2 border-b-[1px] border-dashed border-gray-400" v-if="adultsCount != 0">
                                <div class="pl-5 lg:pl-3">
                                    <p class=" text-sm xs:text-base mt-4 mb-1 font-semibold text-black">Pax {{ adultsCount }}, Adult</p>
                                    <p class="text-sm text-gray-500 text-justify">Price Per Adult</p>
                                </div>
                                <div>
                                    <p class="text-base mt-4 font-semibold text-black text-right pr-3 ">
                                        <span class="uppercase float-left">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}}</span>
                                        {{setCurrencyConverter(priceInfo.pricePerAdult * adultsCount, currency.currencyRate)}}
                                    </p>
                                    <p class="text-sm text-gray-500  text-right pr-3">
                                        <span class="uppercase">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}}</span>
                                        {{ setCurrencyConverter(priceInfo.pricePerAdult, currency.currencyRate) }}
                                    </p>
                                </div>
                            </div>
                            <div class="grid grid-cols-2 border-b-[1px] border-dashed border-gray-400" v-if="childrenCount !=0">
                                <div class="pl-5 lg:pl-3">
                                    <p class="text-sm xs:text-base mt-4 mb-1 font-semibold text-black">Pax {{ childrenCount }}, Child</p>
                                    <p class="text-sm text-gray-500 text-justify">Price Per Child</p>
                                </div>
                                <div>
                                    <p class="text-sm xs:text-base mt-4 font-semibold text-black text-right pr-3"><span
                                        class="uppercase float-left">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}}</span>{{setCurrencyConverter(priceInfo.pricePerChild * childrenCount, currency.currencyRate)}}
                                    </p>
                                    <p class="text-sm text-gray-500  text-right pr-3"><span class="uppercase">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}}</span> {{ setCurrencyConverter(priceInfo.pricePerChild, currency.currencyRate) }}
                                    </p>
                                </div>
                            </div>
                            <div class="grid grid-cols-2 border-b-[1px] border-dashed border-gray-400" v-if="infantsCount != 0">
                                <div class="pl-5 lg:pl-3">
                                    <p class="text-sm xs:text-base mt-4 mb-1 font-semibold text-black">Pax {{ infantsCount }}, Infant</p>
                                    <p class="text-sm text-gray-500 text-justify">Price Per Infant</p>
                                </div>
                                <div>
                                    <p class="text-base mt-4 font-semibold text-black text-right pr-3"><span class="uppercase  float-left">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}}</span> {{setCurrencyConverter(priceInfo.pricePerInfant * infantsCount, currency.currencyRate)}}
                                    </p>
                                    <p class="text-sm text-gray-500  text-right pr-3"><span class="uppercase">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}}</span> {{setCurrencyConverter(priceInfo.pricePerInfant, currency.currencyRate)}}
                                    </p>
                                </div>
                            </div>
                            <div class="grid grid-cols-2 border-b-[1px] border-dashed border-gray-400 pb-2 mb-4">
                                <div class="pl-5 lg:pl-3"><p class="text-base font-semibold text-black float-left">Total Amount</p></div>
                                <div><p class="text-base font-semibold text-black text-right pr-3"><span class="uppercase float-left">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}}</span> <span class="uppercase float-right">{{ setCurrencyConverter(priceInfo.totalFare, currency.currencyRate) }}</span></p></div>
                                <div class="pl-5 lg:pl-3" v-if="priceInfo.discount !== 0"><p class="text-base font-semibold float-left text-[#0181dd]" >Total Discount</p></div>
                                <div v-if="priceInfo.discount !== 0"><p class="text-base font-semibold text-right pr-3 text-[#0181dd]"><span class="uppercase float-left">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}}</span> <span class="uppercase float-right">{{ setCurrencyConverter(priceInfo.discount, currency.currencyRate) }}</span></p></div>
                                <div class="pl-5 lg:pl-3" v-if="priceInfo.discount !== 0"><p class="text-base font-semibold text-black float-left">Discount Fare</p></div>
                                <div v-if="priceInfo.discount !== 0"><p class="text-base font-semibold text-black text-right pr-3"><span class="uppercase float-left">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}}</span> <span class="uppercase float-right">{{ setCurrencyConverter(priceInfo.publicFare, currency.currencyRate) }}</span></p></div>
                            </div>
                            <div class="grid grid-cols-2 border-b-[1px] border-dashed border-gray-400 pb-2 mb-4">
                                <div class="pl-5 lg:pl-3"><p class="text-base font-semibold text-[#0181dd] float-left">Amount to Pay</p></div>
                                <div><p class="text-base font-semibold text-[#0181dd] text-right pr-3"><span class="uppercase float-left">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}}</span> <span class="uppercase float-right">{{ setCurrencyConverter(priceInfo.publicFare, currency.currencyRate) }}</span></p></div>
                            </div>
                        </div>
                        <div class="col-span-12" v-for="(leg,legKey) in flightAvailabilities.legs" :key="legKey">
                            <p class="text-[1.125rem] mt-4 mb-1 w-28 rounded-md text-center border border-dashed border-white text-white bg-bgRGTBaseColor font-semibold capitalize">
                                {{ (legKey == 'leg1' ? 'Departure ' : 'Return') }}</p>
                            <section v-for="(segment,segmentKey) in leg.segments" :key="segmentKey">
                                <div class="col-span-12 relative">
                                    <div :class="`pl-5 mb-5 lg:pl-3 ${segmentKey == 0 ? 'mt-4' : 'mt-2'}`">
                                        <span class="flex items-center">
                                            <img src="/calendar/calendar.svg" alt="calendar.svg" class="h-4 justify-center align-middle pr-1">
                                            <p class="text-base rounded-md font-medium space-x-1">
                                                <span>{{ setInitialDate(segment.departureDate,'Do MMM YY') }}</span>
                                            </p>
                                        </span>
                                        <p class="text-[1rem] font-semibold text-black">
                                            {{setInitialDate(`${segment.departureDate} ${segment.departureTime.substr(0, 8)}`,'h:mm a')}} -
                                            {{setInitialDate(`${segment.arrivalDate} ${segment.arrivalTime.substr(0, 8)}`,'h:mm a')}}
                                            <span class="text-gray-500 text-sm font-normal">({{segment.durationTime }})</span>
                                        </p>
                                        <div class="border-l border-dashed border-gray-700 mt-[8px] relative">
                                            <p class="text-sm text-gray-500 capitalize pl-[14px] pb-2">
                                                {{ segment.departureCity }}</p>
                                            <div
                                                class="bg-white border border-1 border-solid border-[#6d7682] rounded-full h-4 w-4 m-[0_-8px] absolute top-0 left-0"></div>
                                            <p class="text-sm text-gray-500 capitalize pl-[14px]">
                                                {{ segment.arrivalCity }} </p>
                                            <div
                                                class="bg-white border border-1 border-solid border-[#6d7682] rounded-full h-4 w-4 m-[0_-8px] absolute bottom-0 left-0"></div>
                                        </div>
                                    </div>
                                    <div class="absolute top-1 right-2"><img
                                        :src="'/logos/' + segment.marketingAirlineFlag"
                                        :alt="segment.marketingAirlineFlag"></div>
                                </div>
                            </section>
                        </div>
                        <div class="col-span-12 relative border-b-[1px] border-dashed border-gray-400 pb-4 mb-3 mt-5">
                            <div
                                class="fixed lg:static bottom-0  container -ml-[8px] lg:mx-0 lg:w-full bg-bgRGTBaseColor lg:bg-none z-10 lg:z-0">
                                <div
                                    class="lg:relative flex justify-between items-center lg:justify-center pl-2 lg:pl-0">
                                    <div class="lg:hidden">
                                        <span class="text-base text-white capitalize ml-2"><b> {{(currency.currencyRate !== "" ? currency.currencySymbol : priceInfo.currencySymbol)}}</b>&nbsp;</span>
                                        <span
                                            class="text-white font-semibold text-base">{{setCurrencyConverter(priceInfo.totalFare, currency.currencyRate)}}</span>
                                    </div>
                                    <div class="lg:flex lg:justify-center">
                                        <button @click="openModal()"
                                                class="font-semibold lg:absolute text-base border-l-[1px] border-dashed lg:border-none sm:text-sm bg-bgRGTBaseColor text-white lg:rounded-full px-3 py-2">
                                            More Details
                                            <!-- <i class="fa-solid fa-up-right-from-square pl-1"></i> -->
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-span-12 relative border-b-[1px] border-dashed border-gray-400 pb-4 mb-3" v-for="(leg,legKey) in flightAvailabilities.legs" :key="legKey">
                            <p class="text-[1rem] mt-2 mb-1 font-semibold text-black capitalize pl-3">
                                {{ (legKey == 'leg1' ? 'Departure Baggage' : 'Return Baggage') }}</p>
                            <div class="pl-3 lg:pl-2 xl:pl-3" v-for="(baggage, baggageKey) in flightAvailabilities.baggageAllowance[legKey].segments" :key="baggageKey">
                                <p class="pt-1 text-xs sm:text-sm text-gray-600 flex flex-1"><i class="fa-solid fa-briefcase pe-3"></i>{{baggage.fareType }}</p>
                                <p class="pt-1 pb-3 text-xs sm:text-sm text-gray-600"><i class="fas fa-luggage-cart pe-2 mt-1"></i>{{baggage.baggageAllowance }}</p>
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
                        <section v-for="(leg,legKey) in flightAvailabilities.legs" :key="legKey">
                            <div
                                class="flex justify-between items-center p-5 px-6 bg-[#f3f3f3] shadow-[-2px_1px_5px_0px_#e9e9e9]">
                                <div>
                                    <p class="text-xl font-semibold capitalize">{{ (legKey == 'leg1' ? 'Departure' : 'Return') }}</p>
                                </div>
                                <div class="pr-6 font-semibold">
                                    <p class="text-sm text-gray-800">Total Duration:<span
                                        class="text-sm text-gray-600"></span>{{ leg.elapsedTime }}</p>
                                </div>
                            </div>
                            <div v-for="(segment, segmentKey) in leg.segments" :key="segmentKey" class="mb-2">
                                <div class="grid grid-cols-12 bg-white mx-4 shadow-[-2px_1px_5px_0px_#e9e9e9]">
                                    <div class="col-span-4 pt-5 pb-5 pl-1 lg:col-span-3 border-r-[1px] border-dashed border-gray-700">
                                        <div class="col-span-12 flex items-center">
                                            <span class="text-xl font-semibold pl-1 sm:pl-4">
                                                    {{setInitialDate((legKey == 'leg1' ? segment.departureDate: segment.arrivalDate) ,'D MMM YY')}}
                                                </span>
                                        </div>
                                        <p class="text-xl font-semibold pl-1 sm:pl-4">
                                            {{setInitialDate(`${segment.departureDate} ${segment.departureTime.substr(0, 8)}`,'h:mm a')}}
                                        </p>
                                    </div>
                                    <div class="col-span-7 lg:col-span-9 pt-3 pb-3 pl-6 lg:pl-10"
                                         style="position: relative;">
                                        <p class="capitalize text-base font-semibold ">
                                            {{ segment.departureAirportCode }}</p>
                                        <p class="capitalize text-xs sm:text-sm text-gray-600">
                                            {{ segment.departureCity }}<span
                                            class="uppercase font-semibold"> ({{segment.departureAirportCode}})</span>
                                        </p>
                                        <div class="bg-white border border-1 border-solid border-[#6d7682] rounded-full h-4 w-4 m-[0_-8px] absolute top-0 left-0"></div>
                                    </div>
                                </div>
                                <div class="grid grid-cols-12 mx-4 bg-[#f3f3f3] shadow-[-2px_1px_5px_0px_#e9e9e9]">
                                    <div
                                        class=" col-span-4 lg:col-span-3 pl-4 lg:pl-8  flex items-center text-gray-700 text-sm border-r-[1px] border-dashed border-gray-700">
                                        {{ segment.durationTime }}
                                    </div>
                                    <div class=" col-span-8 lg:col-span-9">
                                        <div class="pl-6 pt-3 border-b-[1px] border-solid border-gray-300 lg:mx-4">
                                            <p class="pb-2 text-sm font-semibold">{{ segment.cabin }}</p>
                                            <div v-for="(baggage, baggageKey) in flightAvailabilities.baggageAllowance[legKey].segments" :key="baggageKey">
                                                <p class="pt-1 text-xs sm:text-sm text-gray-600"><i class="fa-solid fa-briefcase pe-3"></i>{{ baggage.fareType }}</p>
                                                <p class="pt-1 pb-3 text-xs sm:text-sm text-gray-600"><i class="fas fa-luggage-cart pe-2"></i>{{ baggage.baggageAllowance }}</p>
                                            </div>
                                        </div>
                                        <div class="relative">
                                            <i class="fa fa-plane rotate-90 text-gray-700 absolute -top-[1.4rem] -left-[0.6rem]"></i>
                                        </div>
                                        <div class="pl-2 lg:pl-6 pt-3 mx-4">
                                            <i class="fa fa-plane rotate-270 text-gray-600"></i>
                                            <span
                                                class="pl-2 pt-1 text-xs sm:text-sm text-gray-900">{{segment.operatingAirlineCode}} - {{segment.operatingFlightNumber }} ({{ segment.aircraftCode }})</span>
                                        </div>
                                    </div>
                                </div>
                                <div
                                    class="grid grid-cols-12 bg-white rounded-bl-xl rounded-br-xl mx-4 shadow-[-2px_1px_5px_0px_#e9e9e9]">
                                    <div
                                        class="col-span-4 pt-5 pb-5 pl-1 lg:col-span-3 border-r-[1px] border-dashed border-gray-700">
                                        <p class="text-xl font-semibold pl-1 sm:pl-4">
                                            {{setInitialDate(`${segment.arrivalDate} ${segment.arrivalTime.substr(0, 8)}`,'h:mm a')}}
                                        </p>
                                    </div>
                                    <div class="col-span-7 lg:col-span-9 pt-3 pb-3 pl-6 lg:pl-10"
                                         style="position: relative;">
                                        <p class="capitalize text-base font-semibold ">
                                            {{ segment.arrivalAirportCode }}</p>
                                        <p class=" capitalize text-xs sm:text-sm text-gray-600">
                                            {{ segment.arrivalCity }} <span class="uppercase font-semibold">({{segment.arrivalAirportCode}})</span></p>
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
    </GuestLayout>
</template>
<script>
import Service from "@/Config/Service.js";
import {mapState} from "vuex";
import CurrencyConverter from "@/Config/CurrencyConverter.js";
import moment from "moment";
export default {
    data() {
        return {
            responseError: "",
            responseErrorType: 'hidden',
            options:{
                'Adult':[{'title':'MR',value:'Mr'},{'title':'MRS',value:'Mrs'},{'title':'MS',value:'MS'}],
                'Child':[{'title':'Master',value:'MSTR'},{'title':'Miss',value:'Miss'}],
                'Infant':[{'title':'Master',value:'MSTR'},{'title':'Miss',value:'Miss'}]
            },
            cheapestFareFlight: {type: Object},
            flightAvailabilities: {type: Object},
            priceInfo: {type: Object},
            passengerType: "",
            ModalPopup: false,
            jSessionId: String,
            responseMessageDetailModal: 'hide',
            redirectToUrl: false,
            outboundDate: "",
            loading: false,
            passengers: [],
            errorMessage: [],
            airCountryLists: [],
            currencies: [],
            currencyType: "",
            currencyCode: "",
            currencyRate: 0,
            currencySymbol: "",
            cheapestFareOrderCreate: {
                isCsrfToken: {type: String},
                loading: false,
                responseError: "",
            },
            errors: {
                email: "",
                countryCode: "",
                areaCode: "",
                mobileNo:"",
                type: [],
                nameTitle: [],
                firstName: [],
                lastName: [],
                dobDate: [],
                dobMonth: [],
                dobYear: [],
                idnNmber: [],
                expDate: [],
                expMonth: [],
                expYear: [],
                nationality: [],
                issDate: [],
                issMonth: [],
                issYear: [],
                issueCountry: []
            },
            input: {
                departureDate: "",
                adultsCount: 1,
                childrenCount: 0,
                infantsCount: 0,
                countryCode: 92,
                areaCode: "",
                mobileNo:"",
                email: "",
                airType: "",
                jSessionId: "",
                vCarrier: "",
                contact: [{
                    "type": "O",
                    "phone": "009251111785786"
                }],
                persons: {
                    type: [],
                    nameTitle: [],
                    firstName: [],
                    lastName: [],
                    dobDate: [],
                    dobMonth: [],
                    dobYear: [],
                    idnNmber: [],
                    expDate: [],
                    expMonth: [],
                    expYear: [],
                    nationality: [],
                    issDate: [],
                    issMonth: [],
                    issYear: [],
                    issueCountry: []
                },
                bookingKeys: [],
                params: {type: Object},
            },
            isInputFocused: false,
            inputValue: '',
            currentFocus: 92,
            filteredCountries: [],
            months:[{"value":"-1","name":"MM","title":"MM"},{"value":"01","name":"Jan","title":"January"},{"value":"02","name":"Feb","title":"February"},{"value":"03","name":"Mar","title":"March"},{"value":"04","name":"Apr","title":"April"},{"value":"05","name":"May","title":"May"},{"value":"06","name":"Jun","title":"June"},{"value":"07","name":"Jul","title":"July"},{"value":"08","name":"Aug","title":"August"},{"value":"09","name":"Sep","title":"September"},{"value":"10","name":"Oct","title":"October"},{"value":"11","name":"Nov","title":"November"},{"value":"12","name":"Dec","title":"December"}],
            countries:[{"name":"Pakistan","dialCode":"+92","code":"PK"},{"name":"Afghanistan","dialCode":"+93","code":"AF"},{"name":"Aland Islands","dialCode":"+358","code":"AX"},{"name":"Albania","dialCode":"+355","code":"AL"},{"name":"Algeria","dialCode":"+213","code":"DZ"},{"name":"AmericanSamoa","dialCode":"+1684","code":"AS"},{"name":"Andorra","dialCode":"+376","code":"AD"},{"name":"Angola","dialCode":"+244","code":"AO"},{"name":"Anguilla","dialCode":"+1264","code":"AI"},{"name":"Antarctica","dialCode":"+672","code":"AQ"},{"name":"Antigua and Barbuda","dialCode":"+1268","code":"AG"},{"name":"Argentina","dialCode":"+54","code":"AR"},{"name":"Armenia","dialCode":"+374","code":"AM"},{"name":"Aruba","dialCode":"+297","code":"AW"},{"name":"Australia","dialCode":"+61","code":"AU"},{"name":"Austria","dialCode":"+43","code":"AT"},{"name":"Azerbaijan","dialCode":"+994","code":"AZ"},{"name":"Bahamas","dialCode":"+1242","code":"BS"},{"name":"Bahrain","dialCode":"+973","code":"BH"},{"name":"Bangladesh","dialCode":"+880","code":"BD"},{"name":"Barbados","dialCode":"+1246","code":"BB"},{"name":"Belarus","dialCode":"+375","code":"BY"},{"name":"Belgium","dialCode":"+32","code":"BE"},{"name":"Belize","dialCode":"+501","code":"BZ"},{"name":"Benin","dialCode":"+229","code":"BJ"},{"name":"Bermuda","dialCode":"+1441","code":"BM"},{"name":"Bhutan","dialCode":"+975","code":"BT"},{"name":"Bolivia, Plurinational State of","dialCode":"+591","code":"BO"},{"name":"Bosnia and Herzegovina","dialCode":"+387","code":"BA"},{"name":"Botswana","dialCode":"+267","code":"BW"},{"name":"Brazil","dialCode":"+55","code":"BR"},{"name":"British Indian Ocean Territory","dialCode":"+246","code":"IO"},{"name":"Brunei Darussalam","dialCode":"+673","code":"BN"},{"name":"Bulgaria","dialCode":"+359","code":"BG"},{"name":"Burkina Faso","dialCode":"+226","code":"BF"},{"name":"Burundi","dialCode":"+257","code":"BI"},{"name":"Cambodia","dialCode":"+855","code":"KH"},{"name":"Cameroon","dialCode":"+237","code":"CM"},{"name":"Canada","dialCode":"+1","code":"CA"},{"name":"Cape Verde","dialCode":"+238","code":"CV"},{"name":"Cayman Islands","dialCode":"+ 345","code":"KY"},{"name":"Central African Republic","dialCode":"+236","code":"CF"},{"name":"Chad","dialCode":"+235","code":"TD"},{"name":"Chile","dialCode":"+56","code":"CL"},{"name":"China","dialCode":"+86","code":"CN"},{"name":"Christmas Island","dialCode":"+61","code":"CX"},{"name":"Cocos (Keeling) Islands","dialCode":"+61","code":"CC"},{"name":"Colombia","dialCode":"+57","code":"CO"},{"name":"Comoros","dialCode":"+269","code":"KM"},{"name":"Congo","dialCode":"+242","code":"CG"},{"name":"Congo, The Democratic Republic of the Congo","dialCode":"+243","code":"CD"},{"name":"Cook Islands","dialCode":"+682","code":"CK"},{"name":"Costa Rica","dialCode":"+506","code":"CR"},{"name":"Cote d'Ivoire","dialCode":"+225","code":"CI"},{"name":"Croatia","dialCode":"+385","code":"HR"},{"name":"Cuba","dialCode":"+53","code":"CU"},{"name":"Cyprus","dialCode":"+357","code":"CY"},{"name":"Czech Republic","dialCode":"+420","code":"CZ"},{"name":"Denmark","dialCode":"+45","code":"DK"},{"name":"Djibouti","dialCode":"+253","code":"DJ"},{"name":"Dominica","dialCode":"+1767","code":"DM"},{"name":"Dominican Republic","dialCode":"+1849","code":"DO"},{"name":"Ecuador","dialCode":"+593","code":"EC"},{"name":"Egypt","dialCode":"+20","code":"EG"},{"name":"El Salvador","dialCode":"+503","code":"SV"},{"name":"Equatorial Guinea","dialCode":"+240","code":"GQ"},{"name":"Eritrea","dialCode":"+291","code":"ER"},{"name":"Estonia","dialCode":"+372","code":"EE"},{"name":"Ethiopia","dialCode":"+251","code":"ET"},{"name":"Falkland Islands (Malvinas)","dialCode":"+500","code":"FK"},{"name":"Faroe Islands","dialCode":"+298","code":"FO"},{"name":"Fiji","dialCode":"+679","code":"FJ"},{"name":"Finland","dialCode":"+358","code":"FI"},{"name":"France","dialCode":"+33","code":"FR"},{"name":"French Guiana","dialCode":"+594","code":"GF"},{"name":"French Polynesia","dialCode":"+689","code":"PF"},{"name":"Gabon","dialCode":"+241","code":"GA"},{"name":"Gambia","dialCode":"+220","code":"GM"},{"name":"Georgia","dialCode":"+995","code":"GE"},{"name":"Germany","dialCode":"+49","code":"DE"},{"name":"Ghana","dialCode":"+233","code":"GH"},{"name":"Gibraltar","dialCode":"+350","code":"GI"},{"name":"Greece","dialCode":"+30","code":"GR"},{"name":"Greenland","dialCode":"+299","code":"GL"},{"name":"Grenada","dialCode":"+1473","code":"GD"},{"name":"Guadeloupe","dialCode":"+590","code":"GP"},{"name":"Guam","dialCode":"+1671","code":"GU"},{"name":"Guatemala","dialCode":"+502","code":"GT"},{"name":"Guernsey","dialCode":"+44","code":"GG"},{"name":"Guinea","dialCode":"+224","code":"GN"},{"name":"Guinea-Bissau","dialCode":"+245","code":"GW"},{"name":"Guyana","dialCode":"+595","code":"GY"},{"name":"Haiti","dialCode":"+509","code":"HT"},{"name":"Holy See (Vatican City State)","dialCode":"+379","code":"VA"},{"name":"Honduras","dialCode":"+504","code":"HN"},{"name":"Hong Kong","dialCode":"+852","code":"HK"},{"name":"Hungary","dialCode":"+36","code":"HU"},{"name":"Iceland","dialCode":"+354","code":"IS"},{"name":"India","dialCode":"+91","code":"IN"},{"name":"Indonesia","dialCode":"+62","code":"ID"},{"name":"Iran, Islamic Republic of Persian Gulf","dialCode":"+98","code":"IR"},{"name":"Iraq","dialCode":"+964","code":"IQ"},{"name":"Ireland","dialCode":"+353","code":"IE"},{"name":"Isle of Man","dialCode":"+44","code":"IM"},{"name":"Israel","dialCode":"+972","code":"IL"},{"name":"Italy","dialCode":"+39","code":"IT"},{"name":"Jamaica","dialCode":"+1876","code":"JM"},{"name":"Japan","dialCode":"+81","code":"JP"},{"name":"Jersey","dialCode":"+44","code":"JE"},{"name":"Jordan","dialCode":"+962","code":"JO"},{"name":"Kazakhstan","dialCode":"+77","code":"KZ"},{"name":"Kenya","dialCode":"+254","code":"KE"},{"name":"Kiribati","dialCode":"+686","code":"KI"},{"name":"Korea, Democratic People's Republic of Korea","dialCode":"+850","code":"KP"},{"name":"Korea, Republic of South Korea","dialCode":"+82","code":"KR"},{"name":"Kuwait","dialCode":"+965","code":"KW"},{"name":"Kyrgyzstan","dialCode":"+996","code":"KG"},{"name":"Laos","dialCode":"+856","code":"LA"},{"name":"Latvia","dialCode":"+371","code":"LV"},{"name":"Lebanon","dialCode":"+961","code":"LB"},{"name":"Lesotho","dialCode":"+266","code":"LS"},{"name":"Liberia","dialCode":"+231","code":"LR"},{"name":"Libyan Arab Jamahiriya","dialCode":"+218","code":"LY"},{"name":"Liechtenstein","dialCode":"+423","code":"LI"},{"name":"Lithuania","dialCode":"+370","code":"LT"},{"name":"Luxembourg","dialCode":"+352","code":"LU"},{"name":"Macao","dialCode":"+853","code":"MO"},{"name":"Macedonia","dialCode":"+389","code":"MK"},{"name":"Madagascar","dialCode":"+261","code":"MG"},{"name":"Malawi","dialCode":"+265","code":"MW"},{"name":"Malaysia","dialCode":"+60","code":"MY"},{"name":"Maldives","dialCode":"+960","code":"MV"},{"name":"Mali","dialCode":"+223","code":"ML"},{"name":"Malta","dialCode":"+356","code":"MT"},{"name":"Marshall Islands","dialCode":"+692","code":"MH"},{"name":"Martinique","dialCode":"+596","code":"MQ"},{"name":"Mauritania","dialCode":"+222","code":"MR"},{"name":"Mauritius","dialCode":"+230","code":"MU"},{"name":"Mayotte","dialCode":"+262","code":"YT"},{"name":"Mexico","dialCode":"+52","code":"MX"},{"name":"Micronesia, Federated States of Micronesia","dialCode":"+691","code":"FM"},{"name":"Moldova","dialCode":"+373","code":"MD"},{"name":"Monaco","dialCode":"+377","code":"MC"},{"name":"Mongolia","dialCode":"+976","code":"MN"},{"name":"Montenegro","dialCode":"+382","code":"ME"},{"name":"Montserrat","dialCode":"+1664","code":"MS"},{"name":"Morocco","dialCode":"+212","code":"MA"},{"name":"Mozambique","dialCode":"+258","code":"MZ"},{"name":"Myanmar","dialCode":"+95","code":"MM"},{"name":"Namibia","dialCode":"+264","code":"NA"},{"name":"Nauru","dialCode":"+674","code":"NR"},{"name":"Nepal","dialCode":"+977","code":"NP"},{"name":"Netherlands","dialCode":"+31","code":"NL"},{"name":"Netherlands Antilles","dialCode":"+599","code":"AN"},{"name":"New Caledonia","dialCode":"+687","code":"NC"},{"name":"New Zealand","dialCode":"+64","code":"NZ"},{"name":"Nicaragua","dialCode":"+505","code":"NI"},{"name":"Niger","dialCode":"+227","code":"NE"},{"name":"Nigeria","dialCode":"+234","code":"NG"},{"name":"Niue","dialCode":"+683","code":"NU"},{"name":"Norfolk Island","dialCode":"+672","code":"NF"},{"name":"Northern Mariana Islands","dialCode":"+1670","code":"MP"},{"name":"Norway","dialCode":"+47","code":"NO"},{"name":"Oman","dialCode":"+968","code":"OM"},{"name":"Palau","dialCode":"+680","code":"PW"},{"name":"Palestinian Territory, Occupied","dialCode":"+970","code":"PS"},{"name":"Panama","dialCode":"+507","code":"PA"},{"name":"Papua New Guinea","dialCode":"+675","code":"PG"},{"name":"Paraguay","dialCode":"+595","code":"PY"},{"name":"Peru","dialCode":"+51","code":"PE"},{"name":"Philippines","dialCode":"+63","code":"PH"},{"name":"Pitcairn","dialCode":"+872","code":"PN"},{"name":"Poland","dialCode":"+48","code":"PL"},{"name":"Portugal","dialCode":"+351","code":"PT"},{"name":"Puerto Rico","dialCode":"+1939","code":"PR"},{"name":"Qatar","dialCode":"+974","code":"QA"},{"name":"Romania","dialCode":"+40","code":"RO"},{"name":"Russia","dialCode":"+7","code":"RU"},{"name":"Rwanda","dialCode":"+250","code":"RW"},{"name":"Reunion","dialCode":"+262","code":"RE"},{"name":"Saint Barthelemy","dialCode":"+590","code":"BL"},{"name":"Saint Helena, Ascension and Tristan Da Cunha","dialCode":"+290","code":"SH"},{"name":"Saint Kitts and Nevis","dialCode":"+1869","code":"KN"},{"name":"Saint Lucia","dialCode":"+1758","code":"LC"},{"name":"Saint Martin","dialCode":"+590","code":"MF"},{"name":"Saint Pierre and Miquelon","dialCode":"+508","code":"PM"},{"name":"Saint Vincent and the Grenadines","dialCode":"+1784","code":"VC"},{"name":"Samoa","dialCode":"+685","code":"WS"},{"name":"San Marino","dialCode":"+378","code":"SM"},{"name":"Sao Tome and Principe","dialCode":"+239","code":"ST"},{"name":"Saudi Arabia","dialCode":"+966","code":"SA"},{"name":"Senegal","dialCode":"+221","code":"SN"},{"name":"Serbia","dialCode":"+381","code":"RS"},{"name":"Seychelles","dialCode":"+248","code":"SC"},{"name":"Sierra Leone","dialCode":"+232","code":"SL"},{"name":"Singapore","dialCode":"+65","code":"SG"},{"name":"Slovakia","dialCode":"+421","code":"SK"},{"name":"Slovenia","dialCode":"+386","code":"SI"},{"name":"Solomon Islands","dialCode":"+677","code":"SB"},{"name":"Somalia","dialCode":"+252","code":"SO"},{"name":"South Africa","dialCode":"+27","code":"ZA"},{"name":"South Sudan","dialCode":"+211","code":"SS"},{"name":"South Georgia and the South Sandwich Islands","dialCode":"+500","code":"GS"},{"name":"Spain","dialCode":"+34","code":"ES"},{"name":"Sri Lanka","dialCode":"+94","code":"LK"},{"name":"Sudan","dialCode":"+249","code":"SD"},{"name":"Suriname","dialCode":"+597","code":"SR"},{"name":"Svalbard and Jan Mayen","dialCode":"+47","code":"SJ"},{"name":"Swaziland","dialCode":"+268","code":"SZ"},{"name":"Sweden","dialCode":"+46","code":"SE"},{"name":"Switzerland","dialCode":"+41","code":"CH"},{"name":"Syrian Arab Republic","dialCode":"+963","code":"SY"},{"name":"Taiwan","dialCode":"+886","code":"TW"},{"name":"Tajikistan","dialCode":"+992","code":"TJ"},{"name":"Tanzania, United Republic of Tanzania","dialCode":"+255","code":"TZ"},{"name":"Thailand","dialCode":"+66","code":"TH"},{"name":"Timor-Leste","dialCode":"+670","code":"TL"},{"name":"Togo","dialCode":"+228","code":"TG"},{"name":"Tokelau","dialCode":"+690","code":"TK"},{"name":"Tonga","dialCode":"+676","code":"TO"},{"name":"Trinidad and Tobago","dialCode":"+1868","code":"TT"},{"name":"Tunisia","dialCode":"+216","code":"TN"},{"name":"Turkey","dialCode":"+90","code":"TR"},{"name":"Turkmenistan","dialCode":"+993","code":"TM"},{"name":"Turks and Caicos Islands","dialCode":"+1649","code":"TC"},{"name":"Tuvalu","dialCode":"+688","code":"TV"},{"name":"Uganda","dialCode":"+256","code":"UG"},{"name":"Ukraine","dialCode":"+380","code":"UA"},{"name":"United Arab Emirates","dialCode":"+971","code":"AE"},{"name":"United Kingdom","dialCode":"+44","code":"GB"},{"name":"United States","dialCode":"+1","code":"US"},{"name":"Uruguay","dialCode":"+598","code":"UY"},{"name":"Uzbekistan","dialCode":"+998","code":"UZ"},{"name":"Vanuatu","dialCode":"+678","code":"VU"},{"name":"Venezuela, Bolivarian Republic of Venezuela","dialCode":"+58","code":"VE"},{"name":"Vietnam","dialCode":"+84","code":"VN"},{"name":"Virgin Islands, British","dialCode":"+1284","code":"VG"},{"name":"Virgin Islands, U.S.","dialCode":"+1340","code":"VI"},{"name":"Wallis and Futuna","dialCode":"+681","code":"WF"},{"name":"Yemen","dialCode":"+967","code":"YE"},{"name":"Zambia","dialCode":"+260","code":"ZM"},{"name":"Zimbabwe","dialCode":"+263","code":"ZW"}]
        };
    },
    mounted () {
        document.addEventListener('click', this.close);
        document.addEventListener('click', this.handleOutsideClick);
    },
    beforeDestroy () {
        document.removeEventListener('click',this.close)
        document.removeEventListener('click', this.handleOutsideClick);
    },
    created() {
        var params = new Map(new URL(location.href).search.slice(1).split('&').map(function(query) {return query.split("=")}))
        var queryString = Array.from(params.entries()).map(function(v){
            if(v[1] !== undefined) return v[0].replace(/[^a-z]/g,'')+'='+v[1].replace(/[^a-zA-Z0-9-,.]/g,'') }).join('&')
        window.history.replaceState(null, '', window.location.pathname+"?"+queryString)
        this.cheapestFareFlight = JSON.parse(localStorage.getItem("cheapestFareFlight"));
        this.flightAvailabilities = this.cheapestFareFlight.flightAvailabilities;
        this.priceInfo = this.flightAvailabilities.price;
        Object.values(this.flightAvailabilities.legs).forEach(leg => {
            if (leg && leg?.bookingKey) {
                this.input.bookingKeys.push({ bookingRefKey: leg?.bookingKey });
            }
        });
        this.adultsCount = this.flightAvailabilities.passengers.adultsCount;
        this.childrenCount = this.flightAvailabilities.passengers.childrenCount;
        this.infantsCount = this.flightAvailabilities.passengers.infantsCount;
        this.input.adultsCount = this.adultsCount;
        this.input.childrenCount = this.childrenCount;
        this.input.infantsCount = this.infantsCount;
        this.input.airType = this.priceInfo.airType;
        this.input.vCarrier = this.priceInfo.validatingCarrier;
        this.input.totalFare = this.priceInfo.totalFare;
        this.input.jSessionId = (this.flightAvailabilities.jSessionId !== undefined ? this.flightAvailabilities.jSessionId : "");
        this.input.bookingInfo = (this.flightAvailabilities.bookingInfo !== undefined ? this.flightAvailabilities.bookingInfo : "");
        this.passengers.push({passengerType: "Adult", passengerCount: eval(this.adultsCount)});
        if (eval(this.childrenCount) !== 0) this.passengers.push({passengerType: "Child",passengerCount: eval(this.childrenCount)});
        if (eval(this.infantsCount) !== 0) this.passengers.push({ passengerType: "Infant",passengerCount: eval(this.infantsCount) });
        this.input.departureDate = this.airURLSearchParams().get('obd').substring(0, 10);
        this.outboundDate = this.airURLSearchParams().get('obd');
        this.input.params = this.params('p');
        this.input.params['airType'] = this.priceInfo.airType;
        this.input.params['vCarrier'] = this.priceInfo.validatingCarrier;
        this.input.url = this.params('q');
    },
    computed: {
        ...mapState(['currency']),
        days(){
            let days = [];
            days.push({"value": "-1","title": "DD"});
            for (let day = 1; day <= eval(31); day++) {
                const dayTitle = day.toString().length === 1 ? '0'+day : day
                days.push({"value": dayTitle,"title": dayTitle});
            }
            return days;
        },
        bookings() {
            let persons = [];
            for (const [passengersKey, passengers] of Object.entries(this.passengers)) {
                for (let passenger = 1; passenger <= eval(passengers.passengerCount); passenger++) {
                    persons.push({passengerType: passengers.passengerType, passengerCount: passengers.passengerCount});
                    this.input.persons.type.push(passengers.passengerType);
                    this.errors.nameTitle.push('');
                    this.errors.firstName.push('');
                    this.errors.lastName.push('');
                    this.errors.dobDate.push('');
                    this.errors.dobMonth.push('');
                    this.errors.dobYear.push('');
                    this.errorMessage.push(false)
                    this.input.persons.dobDate.push('-1')
                    this.input.persons.dobMonth.push('-1')
                    this.input.persons.expDate.push('-1')
                    this.input.persons.expMonth.push('-1')
                    this.input.persons.issDate.push('-1')
                    this.input.persons.issMonth.push('-1')
                    this.input.persons.nationality.push('-1')
                    this.input.persons.issueCountry.push('-1')
                    this.input.countryCode = '+92'
                }
            }
            return persons
        },
    },
    methods: {
        isValidEmail(e) {
            if(e.keyCode == 32){
                e.preventDefault();
            }else{
                let selectedCharCode = String.fromCharCode(e.keyCode);
                if(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(selectedCharCode)) return true;
            }
        },
        isValidPhoneNumber(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[0-9+]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isValidCheapestFareFlightOrderCreateInputField(e){
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z ]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isEmpty(bookingKey, fieldName, inputFieldName,passengerType) {
            if (fieldName === 'email' && inputFieldName !== '') {
                if (!/^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|.(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(inputFieldName)) {
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

            if (fieldName === 'countryCode' && inputFieldName !== '') {
                this.errors.countryCode = ''
                return true
            } else if (fieldName === 'countryCode' && inputFieldName === '') {
                this.errors.countryCode = 'error'
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
                // if (this.input.countryCode === "+92") {
                //  const extentions = ["300", "301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311", "312", "313", "314", "315", "316", "317", "318", "319", "320", "321", "322", "323", "324", "325", "326", "327", "328", "329", "330", "331", "332", "333", "334", "335", "336", "337", "338", "339", "340", "341", "342", "343", "344", "345", "346", "347", "348", "349"]
                //  if (extentions.includes(inputFieldName.substring(0, 3))) {
                //    this.errors.mobileNo = ''
                //    return true
                //  } else {
                //    this.errors.mobileNo = 'error'
                //   return false
                //  }
                // } else {
                this.errors.mobileNo = ''
                return true
                // }
            } else if (fieldName === 'mobileNo' && inputFieldName === '') {
                this.errors.mobileNo = 'error'
                return false
            }


            if (fieldName === 'nameTitle' && inputFieldName[bookingKey] !== '') {
                this.errors.nameTitle[bookingKey] = ''
                return true
            } else if (fieldName === 'nameTitle' && inputFieldName[bookingKey] === '') {
                this.errors.nameTitle[bookingKey] = 'error'
                return false
            }
            if (fieldName === 'firstName' && inputFieldName[bookingKey] !== '') {
                this.errors.firstName[bookingKey] = ''
                return true
            } else if (fieldName === 'firstName' && inputFieldName[bookingKey] === '') {
                this.errors.firstName[bookingKey] = 'error'
                return false
            }
            if (fieldName === 'lastName' && inputFieldName[bookingKey] !== '') {
                this.errors.lastName[bookingKey] = ''
                return true
            } else if (fieldName === 'lastName' && inputFieldName[bookingKey] === '') {
                this.errors.lastName[bookingKey] = 'error'
                return false
            }
            if (fieldName === 'dobDate' && inputFieldName[bookingKey] !== '' && inputFieldName[bookingKey] !== '-1') {
                this.errors.dobDate[bookingKey] = ''
                return true
            } else if (fieldName === 'dobDate' && (inputFieldName[bookingKey] === '' || inputFieldName[bookingKey] === '-1')) {
                this.errors.dobDate[bookingKey] = 'error'
                return false
            }
            if (fieldName === 'dobMonth' && inputFieldName[bookingKey] !== '' && inputFieldName[bookingKey] !== '-1') {
                this.errors.dobMonth[bookingKey] = ''
                return true
            } else if (fieldName === 'dobMonth' && (inputFieldName[bookingKey] === '' || inputFieldName[bookingKey] === '-1')) {
                this.errors.dobMonth[bookingKey] = 'error'
                return false
            }
            if (fieldName === 'dobYear' && inputFieldName[bookingKey].length === 4) {
                const doBirthYear = this.doBirthYear(passengerType);
                if (doBirthYear.doBirthStartYear <= inputFieldName[bookingKey] && doBirthYear.doBirthEndYear >= inputFieldName[bookingKey]) {
                    this.errors.dobYear[bookingKey] = ''
                    this.input.persons.dobYear[bookingKey] = inputFieldName[bookingKey]
                } else if (doBirthYear.doBirthStartYear >= inputFieldName[bookingKey] || doBirthYear.doBirthEndYear <= inputFieldName[bookingKey]) {
                    this.input.persons.dobYear[bookingKey] = ''
                    this.errors.dobYear[bookingKey] = 'error'
                }
            } else if (fieldName === 'dobYear') {
                this.errors.dobYear[bookingKey] = 'error'
                return false
            }
        },
        doBirthYear(passengerType){
            const doBirthStartYear =  moment(this.outboundDate, "DD-MM-YYYY").subtract(passengerType == "Adult" ? 11 : passengerType == "Child" ? 2 : 0, "years").format("DD-MM-YYYY");
            return {
                'doBirthStartYear': moment(doBirthStartYear, "DD-MM-YYYY").subtract(passengerType == "Child" ? 11 : passengerType == "Infant" ? 2 : 121, "years").format("YYYY"),
                'doBirthEndYear':moment(doBirthStartYear, "DD-MM-YYYY").format("YYYY")
            }
        },
        openModal() {
            this.ModalPopup = !this.ModalPopup;
            document.body.style.overflow = "hidden";
        },
        closedModal() {
            this.ModalPopup = false;
            document.body.style.overflow = "auto";
        },
        setCurrencyConverter(amount, currencyRate) {
            return CurrencyConverter.doRequest(amount, currencyRate)
        },
        airURLSearchParams: function () {
            return new URLSearchParams(window.location.search)
        },
        setInitialDate(initialDate, formatType) {
            return moment(initialDate).format(formatType)
        },
        cheapestFareFlightOrderCreate() {
            if(this.input.email === '') this.errors.email ='error'
            if(this.input.areaCode === '') this.errors.areaCode ='error'
            if(this.input.countryCode === '') this.errors.countryCode ='error'
            if(this.input.mobileNo === '') this.errors.mobileNo ='error'
            for (const [typeKey, type] of Object.entries(this.input.persons.type)) {
                if(this.input.persons.nameTitle[typeKey] === undefined) this.errors.nameTitle[typeKey] = 'error'
                if(this.input.persons.firstName[typeKey] === undefined) this.errors.firstName[typeKey] = 'error'
                if(this.input.persons.lastName[typeKey] === undefined)  this.errors.lastName[typeKey] = 'error'
                if(this.input.persons.dobDate[typeKey] === undefined || this.input.persons.dobDate[typeKey] === '-1')  this.errors.dobDate[typeKey] = 'error'
                if(this.input.persons.dobMonth[typeKey] === undefined || this.input.persons.dobMonth[typeKey] === '-1')  this.errors.dobMonth[typeKey] = 'error'
                if(this.input.persons.dobYear[typeKey] === undefined)  this.errors.dobYear[typeKey] = 'error'
            }
            if (this.errors.email.includes('error') || this.errors.countryCode.includes('error') || this.errors.areaCode.includes('error') ||  this.errors.mobileNo.includes('error') ||
                this.errors.nameTitle.includes('error') || this.errors.firstName.includes('error') ||
                this.errors.lastName.includes('error')  || this.errors.dobDate.includes('error') ||
                this.errors.dobMonth.includes('error')  || this.errors.dobYear.includes('error')) {
                return false;
            } else {
                this.start();
                this.input.phoneNumber = `${this.input.countryCode}-${this.input.mobileNo}`
                this.input.currencyRate = this.currency.currencyRate
                this.input.currencyCode = this.currency.currencyCode
                localStorage.setItem("passengerDetails", JSON.stringify(this.input));
                Service.doFetch("/ticketing/cheapest-fare-flight-order-create-request", "Create", this.input)
                    .then((response) => {
                        if (response && response?.status === 429) {
                            window.location.href = "/";
                            this.responseError = response.error || "Too many requests. Please try again later.";
                            return;
                        }else if (response && response?.status === 422) {
                            this.responseError = response.error || "Validation failed.";
                            this.redirectToUrl = true;
                            this.responseErrorType = 'block';
                            return;
                        }else if (response && response?.status === 200) {
                            const data = response.data ?? []
                            if(data?.statusCode && data?.statusCode !== 200){
                                if(data?.statusCode && data?.statusCode === 429) {
                                    window.location.href = "/";
                                }else{
                                    this.responseError = data.error ?? 'An unknown error occurred.'
                                    this.redirectToUrl = true;
                                    this.responseErrorType = 'block'
                                }
                            }else{
                                if(data?.input !== undefined && data?.input === "true"){
                                    this.responseError = data?.error ?? 'An unknown error occurred.'
                                    this.redirectToUrl = true;
                                    this.responseErrorType = 'block'
                                }else if (data?.errorType === "true") {
                                    this.responseError = data?.responseError  ?? 'An unknown error occurred.'
                                    this.redirectToUrl = true;
                                    this.responseErrorType = 'block'
                                } else if (data?.errorType === "false") {
                                    if (data?.payUrl !== "") {
                                        this.responseErrorType = 'hidden'
                                        window.location.href = data?.payUrl;
                                    } else {
                                        this.responseError = data?.responseError ?? 'An unknown error occurred.';
                                        this.responseErrorType = 'block'
                                        this.redirectToUrl = false;
                                    }
                                }
                            }
                        }else{
                            this.responseError = response?.responseError;
                            this.responseErrorType = 'block'
                            this.redirectToUrl = false;
                        }
                        this.finish(false);
                    });
            }
        },
        params: function (type) {
            let params = {};
            let query = "";
            let paramKey = 0;
            this.airURLSearchParams().forEach((value, key) => {
                params[key] = value;
                query += (paramKey === 0 ? '?' : '&') + key + "=" + value;
                paramKey++;
            });
            return (type === 'p' ? params : query);
        },
        start() {this.cheapestFareOrderCreate.loading = true },
        finish(option) {this.cheapestFareOrderCreate.loading = option},
        handleOutsideClick(event) {
            if (this.$refs.areaCode && !this.$refs.areaCode.contains(event.target)) {
                this.closeAllLists();
            }
        },
        handleFocus() {
            this.isInputFocused = true;
            this.filterCountries();
        },
        handleBlur() {
            this.isInputFocused = false;
        },
        toggleDropdown() {
            if (this.isInputFocused) {
                this.filterCountries();
            } else {
                this.closeAllLists();
            }
        },
        filterCountries() {
            const val = this.input.areaCode.toLowerCase();
            this.filteredCountries = this.countries.filter(country =>
                country.name.toLowerCase().includes(val) || country.dialCode.includes(val)
            );
            this.currentFocus = -1;
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
        scrollList() {
            if (this.currentFocus >= this.filteredCountries.length) this.currentFocus = 0;
            if (this.currentFocus < 0) this.currentFocus = this.filteredCountries.length - 1;
            const listContainer = this.$refs.listContainer;
            const selectedItem = this.$refs.item[this.currentFocus];
            if (listContainer && selectedItem) {
                const itemOffsetTop = selectedItem.offsetTop;
                const itemOffsetHeight = selectedItem.offsetHeight;
                const containerScrollTop = listContainer.scrollTop;
                const containerOffsetHeight = listContainer.offsetHeight;
                if (itemOffsetTop < containerScrollTop) {
                    listContainer.scrollTop = itemOffsetTop;
                } else if (itemOffsetTop + itemOffsetHeight > containerScrollTop + containerOffsetHeight) {
                    listContainer.scrollTop = itemOffsetTop + itemOffsetHeight - containerOffsetHeight;
                }
            }
        },
        selectCountry(index) {
            const selectedCountry = this.filteredCountries[index];
            this.input.areaCode = `${selectedCountry.code} (${selectedCountry.dialCode})`;
            this.input.countryCode = selectedCountry.dialCode;
            if(this.input.areaCode !== '') this.errors.areaCode = ''
            if(this.input.countryCode !== '') this.errors.countryCode = ''
            this.closeAllLists();
        },
        closeAllLists() {
            this.filteredCountries = [];
        },
        handleClick() {
            this.$refs.areaCode.select();
            this.input.areaCode = ''
            this.filterCountries()
        },
        highlightMatch(country) {
            const val = this.input.areaCode.toLowerCase();
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
        handleInputEvent(event) {
            this.input.areaCode = event.target.value;
            this.currentFocus = null;
            this.filterCountries();
        },
    }
};
</script>
