<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue"
</script>
<template>
    <GuestLayout>
        <section class=" w-[98%] lg:w-[98%] xl:w-[96%]  mx-auto mt-4">
            <div v-if="throwError !== undefined && throwError !== ''" id="throw-error" class="throw-error col-span-12 sm:col-span-12 lg:col-span-12 xl:col-span-12 text-center">
                <strong class="text-red-600 font-normal">{{throwError}}</strong>
            </div>
            <div :class="`flex flex-wrap gap-2 ${paymentOption}`">
                <!-- Passenger Detail -->
                <div class="w-full sm:w-[48%] xl:w-[24%] mx-1 sm:mx-0 bg-white rounded-md shadow-[0_0_4px_1px_#a69a9a]">
                    <div class="w-full rounded-lg">
                        <p class="text-2xl pl-3 pb-2 pt-2 font-medium rounded-tl-md rounded-tr-md bg-blue-500 text-white capitalize">passenger Details</p>
                    </div>
                    <div class="w-full mt-3 mb-3">
                        <div class="w-full flex flex-wrap gap-y-3" v-for="(nameTitle,nameTitleKey) in passengerDetails.persons.nameTitle">
                            <div class="w-1/5">
                                <p class="text-base font-semibold text-zinc-700 pl-4 capitalize">{{ nameTitle }} </p>
                            </div>
                            <div class="w-3/4">
                                <p class="text-base font-semibold text-zinc-700 pl-4 xxs:pl-0 sm:pl-4 md:pl-1 lg:pl-0 xl:pl-4 2xl:pl-1 capitalize">{{passengerDetails.persons.firstName[nameTitleKey]}} {{passengerDetails.persons.lastName[nameTitleKey]}}</p>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Flight Details -->
                <div class="w-full sm:w-[48%] xl:w-[24%] mx-1 sm:mx-0 bg-white rounded-md shadow-[0_0_4px_1px_#a69a9a]">
                    <div class="w-full">
                        <p class="text-2xl pl-3 pb-2 pt-2 font-medium bg-blue-500 text-white capitalize rounded-tr-md">Flight Details</p>
                    </div>
                    <div class="w-full ">
                        <div v-for="(leg,legKey) in flightAvailabilities.legs" :key="legKey" class="grid grid-cols-12 border border-dashed border-zinc-400 rounded-md mt-3 mb-4 mx-2">
                            <div v-for="(segment,segmentKey) in leg.segments" :key="segmentKey" class="col-span-12 group">
                                <div class="flex justify-between">
                                    <div class="col-span-3 pt-4 pb-2 pl-2 xxs:pl-5 sm:pl-3 lg:pl-3">
                                        <div class="flex flex-col text-center">
                                            <p class="text-xl font-semibold text-zinc-700 leading-[1.2] uppercase">{{ segment.departureAirportCode }}</p>
                                            <p class="text-xs lg:text-[13px] font-medium text-zinc-400">{{setInitialDate(`${segment.departureDate} ${segment.departureTime}`,'h:mm a')}}</p>
                                            <p class="text-xs lg:text-[13px] font-medium text-zinc-400">{{setInitialDate(`${segment.departureDate}`,'D MMM YY')}}</p>
                                        </div>
                                    </div>
                                    <div class="col-span-6 sm:col-span-5  flex flex-col items-center justify-center text-center relative">
                                        <p class="text-xs lg:text[13px] xl:text-sm text-gray-500 lg:leading-4 lg:px-1">{{segment.durationTime }}</p>
                                        <div class="border-b-2 border-dotted border-gray-400 w-full absolute"></div>
                                        <div class="w-full flex justify-center flex-col lg:block">
                                            <img src="/ticketing/plane.svg" alt="Return-icon" class="h-5 lg:mt-1 xl:mt-0 transform -translate-x-1 xl:translate-x-1 lg:group-hover:translate-x-44 xl:group-hover:translate-x-20 2xl:group-hover:translate-x-32  group-hover:transition group-hover:duration-1000 group-hover:ease-in-out transition duration-1000 ease-in-out"/>
                                        </div>
                                        <div class="flex">
                                            <img class="h-5 w-5" :src="`/logos/${segment.marketingAirlineFlag}`" :alt="segment.marketingAirlineFlag"/>
                                            <p class="text-xs">{{segment.marketingAirlineCode}} {{segment.flightNumber}}</p>
                                        </div>
                                    </div>
                                    <div class="col-span-3 pt-4 pb-2 pl-2 xxs:pl-5 sm:pl-3 lg:pl-3 mr-4">
                                        <div class="flex flex-col text-center">
                                            <p class="text-xl font-semibold text-zinc-700 leading-[1.2] uppercase">{{ segment.arrivalAirportCode }}</p>
                                            <p class="text-xs lg:text-[13px] font-medium text-zinc-400">{{setInitialDate(`${segment.arrivalDate} ${segment.arrivalTime}`,'h:mm a')}}</p>
                                            <p class="txt-xs lg:text-[13px] font-medium text-zinc-400">{{setInitialDate(`${segment.arrivalDate}`,'D MMM YY')}}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- Price Details -->
                <div class="w-full sm:w-[48%] xl:w-[24%] mx-1 sm:mx-0 bg-white rounded-md shadow-[0_0_4px_1px_#a69a9a]">
                    <div class="w-full">
                        <p class="text-2xl pl-3 pb-2 pt-2 font-medium bg-blue-500 text-white  capitalize rounded-tr-md">Price Details</p>
                    </div>
                    <div class="w-full">
                        <div class="flex pl-4 justify-center mt-4 mb-1">
                            <img :src="`/logos/${priceInfo.validatingCarrier}.png`" class="h-6" :alt="`${priceInfo.validatingCarrier}-logo`">
                            <span class="text-base  font-semibold text-zinc-900 tracking-wide">{{priceInfo.airlineName}}</span>
                        </div>
                         <div class="grid grid-cols-2 pb-1 mb-1 border-b border-gray-300">
                            <div class="pl-5 lg:pl-3">
                                <p class="text-base font-semibold text-zinc-700">Total Fare</p>
                            </div>
                            <div>
                                <p class="text-base font-semibold text-zinc-700 text-right pr-3">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}} &nbsp;{{setCurrencyConverter(priceInfo.eqTotalFare, currency.currencyRate)}}</p>
                            </div>
                        </div>
                        <div class="grid grid-cols-2 pb-1 mb-1 border-b border-gray-300">
                            <div class="pl-5 lg:pl-3">
                                <p v-if="adultsCount != 0"  class="text-base mt-4 mb-1 font-semibold text-zinc-700">Adult ({{ adultsCount }})</p>
                                <p v-if="childrenCount !=0" class="text-base mt-4 mb-1 font-semibold text-zinc-700">Child({{childrenCount}})</p>
                                <p v-if="infantsCount != 0" class="text-base mt-4 mb-1 font-semibold text-zinc-700">Infant({{infantsCount}})</p>
                            </div>
                            <div>
                                <p v-if="adultsCount != 0"  class="text-base mt-4 mb-1 font-semibold text-zinc-700 text-right pr-3">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}} &nbsp;{{setCurrencyConverter(priceInfo.eqPricePerAdult * adultsCount, currency.currencyRate)}}</p>
                                <p v-if="childrenCount !=0" class="text-base mt-4 mb-1 font-semibold text-zinc-700 text-right pr-3">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}} &nbsp;{{setCurrencyConverter(priceInfo.eqPricePerChild * childrenCount, currency.currencyRate)}}</p>
                                <p v-if="infantsCount != 0" class="text-base mt-4 mb-1 font-semibold text-zinc-700 text-right pr-3">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}} &nbsp;{{setCurrencyConverter(priceInfo.eqPricePerInfant * infantsCount, currency.currencyRate)}}</p>
                            </div>
                        </div>
                        <div class="grid grid-cols-2 pb-1 mb-1">
                            <div class="pl-5 lg:pl-3">
                                <p class="text-base font-semibold text-zinc-700">Price you pay</p>
                            </div>
                            <div>
                                <p class="text-base font-semibold text-zinc-700 text-right pr-3">{{(currency.currencyRate !== 0 ? currency.currencyCode : priceInfo.currencyCode)}} &nbsp;{{setCurrencyConverter(priceInfo.eqPublicFare, currency.currencyRate)}}</p>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Payment Option -->
                <div class="w-full sm:w-[48%] xl:w-[24%] mx-1 sm:mx-0 bg-white rounded-md shadow-[0_0_4px_1px_#a69a9a]">
                    <div class="w-full">
                        <p class="text-2xl pl-3 pb-2 pt-2 font-medium bg-blue-500 text-white  capitalize rounded-tr-md">Payment Option</p>
                    </div>
                    <div class="full">
                        <div class="md:flex justify-center mt-3 mx-1">
                            <ul class="flex-column w-full space-y space-y-4 text-sm font-medium text-gray-500 md:me-4 mb-4 md:mb-0">
                                <li>
                                    <div class="flex items-center">
                                        <label for="debit"  @click="activeTab('alfalah')"
                                               :class="`${tabStatus === 'alfalah' ? 'bg-blue-500 text-white' : ' bg-gray-200'} h-10 items-center flex justify-between py-1 px-4 w-full text-base text-gray-900 rounded-md `"
                                               aria-current="page">
                                            <BankAlfalah :payInput="$page.props.payInput" :payTotalFare="payTotalFare" :currencyCode="currencyCode"/>
                                            <img src="/pay/alflah.webp"  class="h-15 w-20"/>
                                        </label>
                                    </div>
                                </li>
                                <!--<li>-->
                                <!--    <div class="flex items-center">-->
                                <!--        <label for="debit-hbl"  @click="activeTab('hbl')"-->
                                <!--               :class="`${tabStatus === 'hbl' ? 'bg-blue-500 text-white' : ' bg-gray-200'} h-10 items-center flex justify-between py-1 px-4 w-full text-base text-gray-900 rounded-md `"-->
                                <!--               aria-current="page">-->
                                <!--            <BankHbl :payInput="$page.props.payInput" :payTotalFare="payTotalFare" :currencyCode="currencyCode"/>-->
                                <!--            <img src="/pay/hbl.png"  class="h-15 w-20"/>-->
                                <!--        </label>-->
                                <!--    </div>-->
                                <!--</li>-->
                                <li>
                                    <div class="flex items-center">
                                        <label for="alfalahipn"  @click="activeTab('alfalahipn')"
                                               :class="`${tabStatus === 'alfalahipn' ? 'bg-blue-500 text-white' : ' bg-gray-200'} h-10 items-center flex justify-between py-1 px-4 w-full text-base text-gray-900 rounded-md `"
                                               aria-current="page">
                                            <input @click="alfalahIpnDCCard(ipnDCCardOption)" id="alfalahipn" type="radio" value="" name="list-credit" class="w-5 h-5 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 focus:ring-2"/>
                                               Debit / Credit Card
                                            <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 496 496" xml:space="preserve" width="40px" height="40px" fill="#000000"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path id="SVGCleanerId_0" style="fill:#12DB55;" d="M496,379.6c0,9.6-7.2,16.8-16.8,16.8H16.8c-9.6,0-16.8-7.2-16.8-16.8v-264 c0-9.6,7.2-16.8,16.8-16.8h462.4c9.6,0,16.8,7.2,16.8,16.8L496,379.6L496,379.6z"></path> <g> <path id="SVGCleanerId_0_1_" style="fill:#12DB55;" d="M496,379.6c0,9.6-7.2,16.8-16.8,16.8H16.8c-9.6,0-16.8-7.2-16.8-16.8v-264 c0-9.6,7.2-16.8,16.8-16.8h462.4c9.6,0,16.8,7.2,16.8,16.8L496,379.6L496,379.6z"></path> </g> <path style="fill:#0AC945;" d="M0,115.6c0-9.6,7.2-16.8,16.8-16.8h462.4c9.6,0,16.8,7.2,16.8,16.8v264.8c0,9.6-7.2,16.8-16.8,16.8"></path> <rect y="118.8" style="fill:#334449;" width="496" height="96.8"></rect> <polygon points="170.4,215.6 496,215.6 496,118.8 5.6,118.8 "></polygon> <path style="fill:#0CC69A;" d="M496,379.6c0,9.6-7.2,16.8-16.8,16.8H16.8c-9.6,0-16.8-7.2-16.8-16.8"></path> <path style="fill:#0BAF84;" d="M479.2,396.4c9.6,0,16.8-7.2,16.8-16.8h-44.8L479.2,396.4z"></path> <g> <path style="fill:#D4F9ED;" d="M177.6,264.4c0,3.2-2.4,5.6-5.6,5.6H52.8c-3.2,0-5.6-2.4-5.6-5.6l0,0c0-3.2,2.4-5.6,5.6-5.6H172 C175.2,258.8,177.6,261.2,177.6,264.4L177.6,264.4z"></path> <path style="fill:#D4F9ED;" d="M177.6,293.2c0,3.2-2.4,5.6-5.6,5.6H52.8c-3.2,0-5.6-2.4-5.6-5.6l0,0c0.8-3.2,3.2-5.6,5.6-5.6H172 C175.2,287.6,177.6,290,177.6,293.2L177.6,293.2z"></path> <path style="fill:#D4F9ED;" d="M154.4,322c0,3.2-2.4,5.6-5.6,5.6h-96c-2.4,0-4.8-2.4-4.8-5.6l0,0c0-3.2,2.4-5.6,5.6-5.6h96 C152,317.2,154.4,319.6,154.4,322L154.4,322z"></path> </g> <circle style="fill:#FFBC00;" cx="360" cy="300.4" r="60"></circle> <path style="fill:#FFAA00;" d="M360,240.4c-30.4,0-55.2,22.4-60,51.2l96.8,56.8c14.4-11.2,23.2-28,23.2-48 C420.8,266.8,393.6,240.4,360,240.4z"></path> <path style="fill:#F7B208;" d="M360,240.4c33.6,0,60,27.2,60,60s-27.2,60-60,60"></path> <g> <circle style="fill:#F20A41;" cx="408" cy="300.4" r="60"></circle> <circle style="fill:#F20A41;" cx="408" cy="300.4" r="60"></circle> </g> <path style="fill:#E00040;" d="M408,361.2c-33.6,0-60-27.2-60-60s27.2-60,60-60"></path> <path style="fill:#F97803;" d="M384,245.2c-21.6,9.6-36,30.4-36,55.2s15.2,46.4,36,55.2c21.6-9.6,36-30.4,36-55.2 S405.6,254,384,245.2z"></path> <path style="fill:#F76806;" d="M384,355.6c21.6-9.6,36-30.4,36-55.2s-15.2-46.4-36-55.2"></path> </g></svg>
                                        </label>
                                    </div>
                                    <div :class="ipnDCCardOption">
                                        <BankAlfalahIpn :payInput="$page.props.payInput" :payTotalFare="payTotalFare" :currencyCode="currencyCode" @initiateHC="initiateHC" :processHCData="processHCData"/>
                                    </div>
                                </li>
                                <li>
                                    <div class="flex items-center">
                                        <label for="bank"  @click="activeTab('payviaonline')"
                                               :class="`${tabStatus === 'payviaonline' ? 'bg-blue-600 text-white' : ' bg-gray-200'} flex h-10 items-center justify-between px-4 w-full text-base text-gray-900 rounded-md`">
                                            <PayViaOnlineBank :payInput="$page.props.payInput" :payTotalFare="setCurrencyConverter(priceInfo.totalFare, currency.currencyRate)" :currencyCode="currencyCode"/>
                                            <svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 512 512" xml:space="preserve" width="40px" height="40px" fill="#000000"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path style="fill:#0aa1a4;" d="M512,402.282c0,16.716-13.55,30.267-30.265,30.267H30.265C13.55,432.549,0,418.996,0,402.282V109.717 c0-16.716,13.55-30.266,30.265-30.266h451.469c16.716,0,30.265,13.551,30.265,30.266L512,402.282L512,402.282z"></path> <path style="opacity:0.15;fill:#202121;enable-background:new ;" d="M21.517,402.282V109.717 c0-16.716,13.552-30.266,30.267-30.266h-21.52C13.55,79.451,0,93.003,0,109.717v292.565c0,16.716,13.55,30.267,30.265,30.267h21.52 C35.07,432.549,21.517,418.996,21.517,402.282z"></path> <g> <path style="fill:#ffffff;" d="M146.165,179.389h38.042c14.009-0.227,29.384,3.418,29.384,20.389c0,7.289-4.329,13.211-10.706,16.4 c8.654,2.505,14.011,10.024,14.011,19.249c0,19.363-14.239,25.284-31.665,25.284h-39.066L146.165,179.389L146.165,179.389z M167.348,211.395h16.404c3.643,0,8.654-1.937,8.654-7.745c0-5.923-4.215-7.858-8.654-7.858h-16.404L167.348,211.395 L167.348,211.395z M167.348,243.741h16.972c6.719,0,11.389-2.391,11.389-9.111c0-7.176-5.011-9.568-11.389-9.568h-16.972V243.741z"></path> <path style="fill:#ffffff;" d="M250.487,179.389h21.524l30.411,81.322h-22.096l-5.011-14.578h-28.36l-5.126,14.578h-21.754 L250.487,179.389z M251.852,230.417h18.45l-8.998-28.474h-0.226L251.852,230.417z"></path> <path style="fill:#ffffff;" d="M308.336,179.389h21.757l28.246,50.115h0.226v-50.115H378.5v81.322h-21.757l-28.246-50.682h-0.226 v50.682h-19.935V179.389z"></path> <path style="fill:#ffffff;" d="M392.957,179.389h21.185v31.209l26.765-31.209h26.311l-30.07,32.006l33.829,49.317h-26.309 l-21.869-34.167l-8.656,9.112v25.056h-21.185V179.39L392.957,179.389L392.957,179.389z"></path> </g> <g> <path style="fill:#ffffff;" d="M92.893,290.217H76.184v43.452H61.598v-43.452H44.891v-12.55h48.002V290.217z"></path> <path style="fill:#ffffff;" d="M99.324,277.668h28.55c9.883,0,19.608,4.472,19.608,15.764c0,6.04-2.899,11.766-8.783,14.042v0.155 c5.96,1.414,7.684,8.078,8.156,13.413c0.157,2.352,0.394,10.587,2.354,12.629h-14.435c-1.254-1.882-1.489-7.373-1.646-8.941 c-0.394-5.648-1.332-11.451-8.156-11.451h-11.059v20.392H99.324V277.668z M113.916,301.981h12.232c4.393,0,6.746-2.352,6.746-6.586 c0-4.156-3.294-6.042-7.372-6.042h-11.607C113.916,289.353,113.916,301.981,113.916,301.981z"></path> <path style="fill:#ffffff;" d="M171.169,277.668h14.824l20.941,56.002h-15.218l-3.448-10.041h-19.531l-3.528,10.041h-14.983 L171.169,277.668z M172.111,312.806h12.707l-6.197-19.611h-0.157L172.111,312.806z"></path> <path style="fill:#ffffff;" d="M211.015,277.668h14.98l19.453,34.511h0.159v-34.511h13.726v56.002h-14.98l-19.455-34.902h-0.157 v34.902h-13.726L211.015,277.668L211.015,277.668z"></path> <path style="fill:#ffffff;" d="M280.665,314.845c0.315,6.588,4.393,8.704,10.59,8.704c4.391,0,8.941-1.567,8.941-5.724 c0-4.941-8.001-5.882-16.078-8.159c-8.001-2.274-16.394-5.88-16.394-16.157c0-12.235,12.315-17.02,22.826-17.02 c11.137,0,22.352,5.41,22.432,18.039h-14.589c0.235-5.098-4.55-6.745-9.021-6.745c-3.137,0-7.059,1.097-7.059,4.785 c0,4.313,8.078,5.097,16.235,7.373c8.081,2.274,16.237,6.038,16.237,16.156c0,14.198-12.08,18.748-24.393,18.748 c-12.863,0-24.234-5.649-24.316-20.001h14.589V314.845z"></path> <path style="fill:#ffffff;" d="M321.608,277.668h41.258v11.686h-26.667v11.452h23.059v11.292h-23.059v21.572h-14.591V277.668z"></path> <path style="fill:#ffffff;" d="M369.535,277.668h44.629v11.686h-30.041v9.805h27.452v11.294h-27.452v10.668h30.826v12.548h-45.413 L369.535,277.668L369.535,277.668z"></path> <path style="fill:#ffffff;" d="M423.263,277.668h28.55c9.883,0,19.606,4.472,19.606,15.764c0,6.04-2.9,11.766-8.783,14.042v0.155 c5.96,1.414,7.687,8.078,8.156,13.413c0.159,2.352,0.392,10.587,2.354,12.629h-14.433c-1.257-1.882-1.489-7.373-1.647-8.941 c-0.392-5.648-1.332-11.451-8.156-11.451h-11.058v20.392h-14.589L423.263,277.668L423.263,277.668z M437.852,301.981h12.237 c4.391,0,6.742-2.352,6.742-6.586c0-4.156-3.291-6.042-7.372-6.042h-11.607V301.981z"></path> </g> <g> <rect x="44.889" y="179.38" style="fill:#D92B2B;" width="88.3" height="17.682"></rect> <rect x="44.889" y="243.03" style="fill:#D92B2B;" width="88.3" height="17.681"></rect> <rect x="44.889" y="211.2" style="fill:#D92B2B;" width="88.3" height="17.682"></rect> </g> </g></svg>
                                        </label>
                                    </div>

                                </li>
                                <li>
                                    <div class="flex items-center">
                                        <label for="cash"  @click="activeTab('cashinoffice')"
                                               :class="`${tabStatus === 'cashinoffice' ? 'bg-blue-600 text-white' : ' bg-gray-200'} h-10 flex justify-between items-center px-4 w-full text-base text-gray-900 rounded-md `"
                                        >
                                            <CashInOffice :payInput="$page.props.payInput" :payTotalFare="setCurrencyConverter(priceInfo.totalFare, currency.currencyRate)" :currencyCode="currencyCode"/>
                                            <span>Our Branches</span>
                                            <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" width="40" height="40" viewBox="0 0 256 256" xml:space="preserve">
                                                    <defs>
                                                    </defs>
                                                <g style="stroke: none; stroke-width: 0; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: none; fill-rule: nonzero; opacity: 1;" transform="translate(1.4065934065934016 1.4065934065934016) scale(2.81 2.81)" >
                                                        <path d="M 39.171 33.76 l 4.964 -22.019 c 0.441 -1.99 -0.619 -4.007 -2.507 -4.774 l 0 0 c -1.999 -0.812 -4.306 0.022 -5.28 1.947 c -7.493 14.812 -20.942 32.629 -20.942 39.459 c -0.027 0.354 -0.039 0.708 -0.039 1.061 c 0 3.091 0.954 6.144 1.879 9.106 c 1.016 3.251 2.066 6.611 1.817 9.941 l -0.615 8.247 l 20.317 0 C 35.759 62.717 35.703 48.413 39.171 33.76 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(238,198,179); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    <path d="M 39.409 8.993 c -7.493 15.33 -20.942 33.771 -20.942 40.839 c -0.027 0.366 -0.039 0.733 -0.039 1.098 c 0 3.199 0.954 6.359 1.879 9.425 c 1.016 3.365 2.066 6.842 1.817 10.288 l -0.438 6.084 h -3.237 l 0.615 -8.247 c 0.248 -3.33 -0.802 -6.69 -1.817 -9.941 c -0.925 -2.963 -1.879 -6.015 -1.879 -9.106 c 0 -0.353 0.012 -0.707 0.039 -1.061 c 0 -6.829 13.449 -24.647 20.942 -39.459 c 0.968 -1.914 3.256 -2.746 5.247 -1.957 C 40.677 7.325 39.883 8.022 39.409 8.993 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(205,149,123); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    <path d="M 75.268 11.483 c -7.013 14.382 -9.524 28.226 -9.856 46.061 L 37.67 56.562 c 0.137 -16.69 2.579 -32.098 10.13 -46.674 c 0.365 -0.705 1.112 -1.132 1.905 -1.104 L 74.16 9.65 C 75.082 9.683 75.673 10.654 75.268 11.483 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(34,105,38); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    <path d="M 65.786 4.576 c -2.468 17.262 -2.723 34.796 -0.558 52.628 l -27.609 2.883 c -2.175 -16.481 -1.514 -34.247 0.615 -52.678 c 0.114 -0.984 0.899 -1.758 1.884 -1.861 l 24.181 -2.525 C 65.183 2.932 65.912 3.696 65.786 4.576 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(39,119,44); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    <path d="M 55.82 1.551 l 10.459 55.97 c 0.193 1.032 -0.487 2.024 -1.519 2.217 l -26.966 5.039 c -1.032 0.193 -2.024 -0.487 -2.217 -1.519 L 25.118 7.288 c -0.193 -1.032 0.487 -2.024 1.519 -2.217 l 26.966 -5.039 C 54.635 -0.16 55.627 0.52 55.82 1.551 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(49,139,54); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    <path d="M 28.792 12.82 l 8.212 43.945 c 3.072 -0.574 6.028 1.451 6.602 4.523 l 14.505 -2.71 c -0.574 -3.072 1.451 -6.028 4.523 -6.602 L 54.422 8.03 c -0.055 0.012 -0.108 0.029 -0.165 0.039 c -3.072 0.574 -6.028 -1.451 -6.602 -4.523 l -14.505 2.71 C 33.714 9.273 31.77 12.171 28.792 12.82 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(59,158,65); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    <circle cx="39.117000000000004" cy="60.687000000000005" r="1.417" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(59,158,65); fill-rule: nonzero; opacity: 1;" transform="  matrix(1 0 0 1 0 0) "/>
                                                    <circle cx="62.017" cy="56.407000000000004" r="1.417" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(59,158,65); fill-rule: nonzero; opacity: 1;" transform="  matrix(1 0 0 1 0 0) "/>
                                                    <circle cx="29.377000000000002" cy="8.407" r="1.417" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(59,158,65); fill-rule: nonzero; opacity: 1;" transform="  matrix(1 0 0 1 0 0) "/>
                                                    <circle cx="52.277" cy="4.127" r="1.417" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(59,158,65); fill-rule: nonzero; opacity: 1;" transform="  matrix(1 0 0 1 0 0) "/>
                                                    <circle cx="45.695" cy="32.405" r="11.135" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(49,139,54); fill-rule: nonzero; opacity: 1;" transform="  matrix(1 0 0 1 0 0) "/>
                                                    <path d="M 46.093 28.513 c -1.156 0.844 -1.463 2.455 -1.601 3.764 c -0.166 1.572 -0.489 1.964 -0.62 2.06 c -0.085 0.062 -0.242 0.07 -0.428 0.032 c -0.537 -0.129 -1.005 -0.714 -1.137 -1.421 c -0.095 -0.508 -0.005 -1.021 0.222 -1.385 c 0.167 -0.269 0.144 -0.614 -0.036 -0.875 l -0.473 -0.682 c -0.313 -0.451 -0.983 -0.486 -1.32 -0.053 c -0.514 0.66 -0.809 1.502 -0.844 2.4 l -0.88 0.164 c -0.447 0.084 -0.742 0.514 -0.658 0.961 l 0.143 0.764 c 0.084 0.447 0.514 0.742 0.961 0.658 l 0.974 -0.182 c 0.54 1.01 1.435 1.756 2.52 2.017 c 1.15 0.238 1.934 -0.108 2.388 -0.44 c 1.156 -0.844 1.463 -2.455 1.601 -3.764 c 0.165 -1.573 0.488 -1.965 0.62 -2.061 c 0.085 -0.062 0.242 -0.07 0.429 -0.032 c 0.537 0.129 1.005 0.714 1.137 1.422 c 0.095 0.509 0.006 1.02 -0.221 1.385 c -0.167 0.269 -0.144 0.614 0.036 0.874 l 0.473 0.682 c 0.316 0.456 0.989 0.481 1.33 0.044 c 0.477 -0.613 0.766 -1.383 0.831 -2.209 l 0.915 -0.171 c 0.447 -0.084 0.742 -0.514 0.658 -0.961 l -0.143 -0.764 c -0.084 -0.447 -0.514 -0.742 -0.961 -0.658 l -0.916 0.171 c -0.528 -1.095 -1.467 -1.905 -2.611 -2.18 C 47.332 27.835 46.548 28.181 46.093 28.513 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(59,158,65); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    <path d="M 49.573 46.709 l 1.019 5.453 c 0.12 0.641 -0.303 1.258 -0.944 1.378 l 0 0 c -0.641 0.12 -1.258 -0.303 -1.378 -0.944 l -1.019 -5.453 c -0.12 -0.641 0.303 -1.258 0.944 -1.378 h 0 C 48.836 45.646 49.453 46.068 49.573 46.709 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(49,139,54); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    <path d="M 43.127 12.213 l 1.019 5.453 c 0.12 0.641 -0.303 1.258 -0.944 1.378 h 0 c -0.641 0.12 -1.258 -0.303 -1.378 -0.944 l -1.019 -5.453 c -0.12 -0.641 0.303 -1.258 0.944 -1.378 v 0 C 42.39 11.149 43.007 11.572 43.127 12.213 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(49,139,54); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    <path d="M 49.663 35.15 c 1.758 2.354 3.405 5.857 1.204 10.722 l -6.253 13.521 c -0.785 2.157 -0.592 4.288 -0.385 6.546 c 0.222 2.413 0.449 4.918 -0.528 7.535 l -1.573 4.226 l -10.604 -3.07 C 29.441 59.548 43.72 37.118 49.663 35.15 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(238,198,179); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    <path d="M 34.355 56.9 c 1.173 -8.285 7.047 -16.95 12.261 -21.777 c 0.862 -0.798 2.199 -0.785 3.048 0.027 l 0 0 C 46.414 35.312 38.23 48.864 34.355 56.9 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(205,149,123); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    <path d="M 14.602 75.091 v 12.324 c 0 1.427 1.157 2.585 2.585 2.585 h 30.557 c 1.427 0 2.585 -1.157 2.585 -2.585 V 75.091 c 0 -1.427 -1.157 -2.585 -2.585 -2.585 H 17.187 C 15.76 72.507 14.602 73.664 14.602 75.091 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(52,57,54); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    <path d="M 50.329 75.091 v 1.27 c -0.096 -0.011 -0.19 -0.029 -0.289 -0.029 H 19.482 c -1.427 0 -2.585 1.157 -2.585 2.585 v 11.054 c -1.289 -0.145 -2.295 -1.227 -2.295 -2.555 V 75.091 c 0 -1.427 1.157 -2.585 2.585 -2.585 h 30.557 C 49.172 72.507 50.329 73.664 50.329 75.091 z" style="stroke: none; stroke-width: 1; stroke-dasharray: none; stroke-linecap: butt; stroke-linejoin: miter; stroke-miterlimit: 10; fill: rgb(46,50,47); fill-rule: nonzero; opacity: 1;" transform=" matrix(1 0 0 1 0 0) " stroke-linecap="round" />
                                                    </g>
                                                    </svg>
                                        </label>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="mt-2">
                            <img src="/sslweb.webp" class="h-12"/>
                        </div>
                        <div class="px-3 pb-3">
                            <p class="text-justify text-zinc-600 text-sm"><span class="text-blue-600 text-base font-semibold"> Note : </span> Rehman Travel ensures your privacy and security. We do not store your personal or payment details</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="flex flex-wrap gap-2">
                <div id="dv3DS" style="width: 100%"></div>
            </div>
        </section>
    </GuestLayout>
</template>
<script>
import BankAlfalahIpn from '../Payment/BankAlfalahIpn.vue'
import BankAlfalah from '../Payment/BankAlfalah.vue'
import BankHbl from '../Payment/BankHbl.vue'
import CashInOffice from '../Payment/CashInOffice.vue'
import PayViaOnlineBank from '../Payment/PayViaOnlineBank.vue'
import CurrencyConverter from "@/Config/CurrencyConverter.js";
import {mapState} from "vuex";
import moment from "moment";
import $ from 'jquery';
export default {
    name: "CheapestFareOrderPayNow",
    components:{BankAlfalahIpn,BankHbl,BankAlfalah,CashInOffice,PayViaOnlineBank},
    computed: {
        ...mapState(['currency','throwError'])
    },
    data() {
        return {
            passengerDetails: {type: Object},
            cheapestFareFlight: {type: Object},
            flightAvailabilities: {type: Object},
            priceInfo: {type: Object},
            adultsCount: 1,
            childrenCount: 0,
            infantsCount: 0,
            payTotalFare:0,
            currencyCode:'',
            tabStatus: '',
            ipnDCCardOption:"hidden",
            paymentOption:'show',
            countries:[{"name":"Pakistan","dialCode":"+92","code":"PK"},{"name":"Afghanistan","dialCode":"+93","code":"AF"},{"name":"Aland Islands","dialCode":"+358","code":"AX"},{"name":"Albania","dialCode":"+355","code":"AL"},{"name":"Algeria","dialCode":"+213","code":"DZ"},{"name":"AmericanSamoa","dialCode":"+1684","code":"AS"},{"name":"Andorra","dialCode":"+376","code":"AD"},{"name":"Angola","dialCode":"+244","code":"AO"},{"name":"Anguilla","dialCode":"+1264","code":"AI"},{"name":"Antarctica","dialCode":"+672","code":"AQ"},{"name":"Antigua and Barbuda","dialCode":"+1268","code":"AG"},{"name":"Argentina","dialCode":"+54","code":"AR"},{"name":"Armenia","dialCode":"+374","code":"AM"},{"name":"Aruba","dialCode":"+297","code":"AW"},{"name":"Australia","dialCode":"+61","code":"AU"},{"name":"Austria","dialCode":"+43","code":"AT"},{"name":"Azerbaijan","dialCode":"+994","code":"AZ"},{"name":"Bahamas","dialCode":"+1242","code":"BS"},{"name":"Bahrain","dialCode":"+973","code":"BH"},{"name":"Bangladesh","dialCode":"+880","code":"BD"},{"name":"Barbados","dialCode":"+1246","code":"BB"},{"name":"Belarus","dialCode":"+375","code":"BY"},{"name":"Belgium","dialCode":"+32","code":"BE"},{"name":"Belize","dialCode":"+501","code":"BZ"},{"name":"Benin","dialCode":"+229","code":"BJ"},{"name":"Bermuda","dialCode":"+1441","code":"BM"},{"name":"Bhutan","dialCode":"+975","code":"BT"},{"name":"Bolivia, Plurinational State of","dialCode":"+591","code":"BO"},{"name":"Bosnia and Herzegovina","dialCode":"+387","code":"BA"},{"name":"Botswana","dialCode":"+267","code":"BW"},{"name":"Brazil","dialCode":"+55","code":"BR"},{"name":"British Indian Ocean Territory","dialCode":"+246","code":"IO"},{"name":"Brunei Darussalam","dialCode":"+673","code":"BN"},{"name":"Bulgaria","dialCode":"+359","code":"BG"},{"name":"Burkina Faso","dialCode":"+226","code":"BF"},{"name":"Burundi","dialCode":"+257","code":"BI"},{"name":"Cambodia","dialCode":"+855","code":"KH"},{"name":"Cameroon","dialCode":"+237","code":"CM"},{"name":"Canada","dialCode":"+1","code":"CA"},{"name":"Cape Verde","dialCode":"+238","code":"CV"},{"name":"Cayman Islands","dialCode":"+ 345","code":"KY"},{"name":"Central African Republic","dialCode":"+236","code":"CF"},{"name":"Chad","dialCode":"+235","code":"TD"},{"name":"Chile","dialCode":"+56","code":"CL"},{"name":"China","dialCode":"+86","code":"CN"},{"name":"Christmas Island","dialCode":"+61","code":"CX"},{"name":"Cocos (Keeling) Islands","dialCode":"+61","code":"CC"},{"name":"Colombia","dialCode":"+57","code":"CO"},{"name":"Comoros","dialCode":"+269","code":"KM"},{"name":"Congo","dialCode":"+242","code":"CG"},{"name":"Congo, The Democratic Republic of the Congo","dialCode":"+243","code":"CD"},{"name":"Cook Islands","dialCode":"+682","code":"CK"},{"name":"Costa Rica","dialCode":"+506","code":"CR"},{"name":"Cote d'Ivoire","dialCode":"+225","code":"CI"},{"name":"Croatia","dialCode":"+385","code":"HR"},{"name":"Cuba","dialCode":"+53","code":"CU"},{"name":"Cyprus","dialCode":"+357","code":"CY"},{"name":"Czech Republic","dialCode":"+420","code":"CZ"},{"name":"Denmark","dialCode":"+45","code":"DK"},{"name":"Djibouti","dialCode":"+253","code":"DJ"},{"name":"Dominica","dialCode":"+1767","code":"DM"},{"name":"Dominican Republic","dialCode":"+1849","code":"DO"},{"name":"Ecuador","dialCode":"+593","code":"EC"},{"name":"Egypt","dialCode":"+20","code":"EG"},{"name":"El Salvador","dialCode":"+503","code":"SV"},{"name":"Equatorial Guinea","dialCode":"+240","code":"GQ"},{"name":"Eritrea","dialCode":"+291","code":"ER"},{"name":"Estonia","dialCode":"+372","code":"EE"},{"name":"Ethiopia","dialCode":"+251","code":"ET"},{"name":"Falkland Islands (Malvinas)","dialCode":"+500","code":"FK"},{"name":"Faroe Islands","dialCode":"+298","code":"FO"},{"name":"Fiji","dialCode":"+679","code":"FJ"},{"name":"Finland","dialCode":"+358","code":"FI"},{"name":"France","dialCode":"+33","code":"FR"},{"name":"French Guiana","dialCode":"+594","code":"GF"},{"name":"French Polynesia","dialCode":"+689","code":"PF"},{"name":"Gabon","dialCode":"+241","code":"GA"},{"name":"Gambia","dialCode":"+220","code":"GM"},{"name":"Georgia","dialCode":"+995","code":"GE"},{"name":"Germany","dialCode":"+49","code":"DE"},{"name":"Ghana","dialCode":"+233","code":"GH"},{"name":"Gibraltar","dialCode":"+350","code":"GI"},{"name":"Greece","dialCode":"+30","code":"GR"},{"name":"Greenland","dialCode":"+299","code":"GL"},{"name":"Grenada","dialCode":"+1473","code":"GD"},{"name":"Guadeloupe","dialCode":"+590","code":"GP"},{"name":"Guam","dialCode":"+1671","code":"GU"},{"name":"Guatemala","dialCode":"+502","code":"GT"},{"name":"Guernsey","dialCode":"+44","code":"GG"},{"name":"Guinea","dialCode":"+224","code":"GN"},{"name":"Guinea-Bissau","dialCode":"+245","code":"GW"},{"name":"Guyana","dialCode":"+595","code":"GY"},{"name":"Haiti","dialCode":"+509","code":"HT"},{"name":"Holy See (Vatican City State)","dialCode":"+379","code":"VA"},{"name":"Honduras","dialCode":"+504","code":"HN"},{"name":"Hong Kong","dialCode":"+852","code":"HK"},{"name":"Hungary","dialCode":"+36","code":"HU"},{"name":"Iceland","dialCode":"+354","code":"IS"},{"name":"India","dialCode":"+91","code":"IN"},{"name":"Indonesia","dialCode":"+62","code":"ID"},{"name":"Iran, Islamic Republic of Persian Gulf","dialCode":"+98","code":"IR"},{"name":"Iraq","dialCode":"+964","code":"IQ"},{"name":"Ireland","dialCode":"+353","code":"IE"},{"name":"Isle of Man","dialCode":"+44","code":"IM"},{"name":"Israel","dialCode":"+972","code":"IL"},{"name":"Italy","dialCode":"+39","code":"IT"},{"name":"Jamaica","dialCode":"+1876","code":"JM"},{"name":"Japan","dialCode":"+81","code":"JP"},{"name":"Jersey","dialCode":"+44","code":"JE"},{"name":"Jordan","dialCode":"+962","code":"JO"},{"name":"Kazakhstan","dialCode":"+77","code":"KZ"},{"name":"Kenya","dialCode":"+254","code":"KE"},{"name":"Kiribati","dialCode":"+686","code":"KI"},{"name":"Korea, Democratic People's Republic of Korea","dialCode":"+850","code":"KP"},{"name":"Korea, Republic of South Korea","dialCode":"+82","code":"KR"},{"name":"Kuwait","dialCode":"+965","code":"KW"},{"name":"Kyrgyzstan","dialCode":"+996","code":"KG"},{"name":"Laos","dialCode":"+856","code":"LA"},{"name":"Latvia","dialCode":"+371","code":"LV"},{"name":"Lebanon","dialCode":"+961","code":"LB"},{"name":"Lesotho","dialCode":"+266","code":"LS"},{"name":"Liberia","dialCode":"+231","code":"LR"},{"name":"Libyan Arab Jamahiriya","dialCode":"+218","code":"LY"},{"name":"Liechtenstein","dialCode":"+423","code":"LI"},{"name":"Lithuania","dialCode":"+370","code":"LT"},{"name":"Luxembourg","dialCode":"+352","code":"LU"},{"name":"Macao","dialCode":"+853","code":"MO"},{"name":"Macedonia","dialCode":"+389","code":"MK"},{"name":"Madagascar","dialCode":"+261","code":"MG"},{"name":"Malawi","dialCode":"+265","code":"MW"},{"name":"Malaysia","dialCode":"+60","code":"MY"},{"name":"Maldives","dialCode":"+960","code":"MV"},{"name":"Mali","dialCode":"+223","code":"ML"},{"name":"Malta","dialCode":"+356","code":"MT"},{"name":"Marshall Islands","dialCode":"+692","code":"MH"},{"name":"Martinique","dialCode":"+596","code":"MQ"},{"name":"Mauritania","dialCode":"+222","code":"MR"},{"name":"Mauritius","dialCode":"+230","code":"MU"},{"name":"Mayotte","dialCode":"+262","code":"YT"},{"name":"Mexico","dialCode":"+52","code":"MX"},{"name":"Micronesia, Federated States of Micronesia","dialCode":"+691","code":"FM"},{"name":"Moldova","dialCode":"+373","code":"MD"},{"name":"Monaco","dialCode":"+377","code":"MC"},{"name":"Mongolia","dialCode":"+976","code":"MN"},{"name":"Montenegro","dialCode":"+382","code":"ME"},{"name":"Montserrat","dialCode":"+1664","code":"MS"},{"name":"Morocco","dialCode":"+212","code":"MA"},{"name":"Mozambique","dialCode":"+258","code":"MZ"},{"name":"Myanmar","dialCode":"+95","code":"MM"},{"name":"Namibia","dialCode":"+264","code":"NA"},{"name":"Nauru","dialCode":"+674","code":"NR"},{"name":"Nepal","dialCode":"+977","code":"NP"},{"name":"Netherlands","dialCode":"+31","code":"NL"},{"name":"Netherlands Antilles","dialCode":"+599","code":"AN"},{"name":"New Caledonia","dialCode":"+687","code":"NC"},{"name":"New Zealand","dialCode":"+64","code":"NZ"},{"name":"Nicaragua","dialCode":"+505","code":"NI"},{"name":"Niger","dialCode":"+227","code":"NE"},{"name":"Nigeria","dialCode":"+234","code":"NG"},{"name":"Niue","dialCode":"+683","code":"NU"},{"name":"Norfolk Island","dialCode":"+672","code":"NF"},{"name":"Northern Mariana Islands","dialCode":"+1670","code":"MP"},{"name":"Norway","dialCode":"+47","code":"NO"},{"name":"Oman","dialCode":"+968","code":"OM"},{"name":"Palau","dialCode":"+680","code":"PW"},{"name":"Palestinian Territory, Occupied","dialCode":"+970","code":"PS"},{"name":"Panama","dialCode":"+507","code":"PA"},{"name":"Papua New Guinea","dialCode":"+675","code":"PG"},{"name":"Paraguay","dialCode":"+595","code":"PY"},{"name":"Peru","dialCode":"+51","code":"PE"},{"name":"Philippines","dialCode":"+63","code":"PH"},{"name":"Pitcairn","dialCode":"+872","code":"PN"},{"name":"Poland","dialCode":"+48","code":"PL"},{"name":"Portugal","dialCode":"+351","code":"PT"},{"name":"Puerto Rico","dialCode":"+1939","code":"PR"},{"name":"Qatar","dialCode":"+974","code":"QA"},{"name":"Romania","dialCode":"+40","code":"RO"},{"name":"Russia","dialCode":"+7","code":"RU"},{"name":"Rwanda","dialCode":"+250","code":"RW"},{"name":"Reunion","dialCode":"+262","code":"RE"},{"name":"Saint Barthelemy","dialCode":"+590","code":"BL"},{"name":"Saint Helena, Ascension and Tristan Da Cunha","dialCode":"+290","code":"SH"},{"name":"Saint Kitts and Nevis","dialCode":"+1869","code":"KN"},{"name":"Saint Lucia","dialCode":"+1758","code":"LC"},{"name":"Saint Martin","dialCode":"+590","code":"MF"},{"name":"Saint Pierre and Miquelon","dialCode":"+508","code":"PM"},{"name":"Saint Vincent and the Grenadines","dialCode":"+1784","code":"VC"},{"name":"Samoa","dialCode":"+685","code":"WS"},{"name":"San Marino","dialCode":"+378","code":"SM"},{"name":"Sao Tome and Principe","dialCode":"+239","code":"ST"},{"name":"Saudi Arabia","dialCode":"+966","code":"SA"},{"name":"Senegal","dialCode":"+221","code":"SN"},{"name":"Serbia","dialCode":"+381","code":"RS"},{"name":"Seychelles","dialCode":"+248","code":"SC"},{"name":"Sierra Leone","dialCode":"+232","code":"SL"},{"name":"Singapore","dialCode":"+65","code":"SG"},{"name":"Slovakia","dialCode":"+421","code":"SK"},{"name":"Slovenia","dialCode":"+386","code":"SI"},{"name":"Solomon Islands","dialCode":"+677","code":"SB"},{"name":"Somalia","dialCode":"+252","code":"SO"},{"name":"South Africa","dialCode":"+27","code":"ZA"},{"name":"South Sudan","dialCode":"+211","code":"SS"},{"name":"South Georgia and the South Sandwich Islands","dialCode":"+500","code":"GS"},{"name":"Spain","dialCode":"+34","code":"ES"},{"name":"Sri Lanka","dialCode":"+94","code":"LK"},{"name":"Sudan","dialCode":"+249","code":"SD"},{"name":"Suriname","dialCode":"+597","code":"SR"},{"name":"Svalbard and Jan Mayen","dialCode":"+47","code":"SJ"},{"name":"Swaziland","dialCode":"+268","code":"SZ"},{"name":"Sweden","dialCode":"+46","code":"SE"},{"name":"Switzerland","dialCode":"+41","code":"CH"},{"name":"Syrian Arab Republic","dialCode":"+963","code":"SY"},{"name":"Taiwan","dialCode":"+886","code":"TW"},{"name":"Tajikistan","dialCode":"+992","code":"TJ"},{"name":"Tanzania, United Republic of Tanzania","dialCode":"+255","code":"TZ"},{"name":"Thailand","dialCode":"+66","code":"TH"},{"name":"Timor-Leste","dialCode":"+670","code":"TL"},{"name":"Togo","dialCode":"+228","code":"TG"},{"name":"Tokelau","dialCode":"+690","code":"TK"},{"name":"Tonga","dialCode":"+676","code":"TO"},{"name":"Trinidad and Tobago","dialCode":"+1868","code":"TT"},{"name":"Tunisia","dialCode":"+216","code":"TN"},{"name":"Turkey","dialCode":"+90","code":"TR"},{"name":"Turkmenistan","dialCode":"+993","code":"TM"},{"name":"Turks and Caicos Islands","dialCode":"+1649","code":"TC"},{"name":"Tuvalu","dialCode":"+688","code":"TV"},{"name":"Uganda","dialCode":"+256","code":"UG"},{"name":"Ukraine","dialCode":"+380","code":"UA"},{"name":"United Arab Emirates","dialCode":"+971","code":"AE"},{"name":"United Kingdom","dialCode":"+44","code":"GB"},{"name":"United States","dialCode":"+1","code":"US"},{"name":"Uruguay","dialCode":"+598","code":"UY"},{"name":"Uzbekistan","dialCode":"+998","code":"UZ"},{"name":"Vanuatu","dialCode":"+678","code":"VU"},{"name":"Venezuela, Bolivarian Republic of Venezuela","dialCode":"+58","code":"VE"},{"name":"Vietnam","dialCode":"+84","code":"VN"},{"name":"Virgin Islands, British","dialCode":"+1284","code":"VG"},{"name":"Virgin Islands, U.S.","dialCode":"+1340","code":"VI"},{"name":"Wallis and Futuna","dialCode":"+681","code":"WF"},{"name":"Yemen","dialCode":"+967","code":"YE"},{"name":"Zambia","dialCode":"+260","code":"ZM"},{"name":"Zimbabwe","dialCode":"+263","code":"ZW"}]
        };
    },
    created() {
        this.cheapestFareFlight = JSON.parse(localStorage.getItem("cheapestFareFlight"))
        this.passengerDetails = JSON.parse(localStorage.getItem("passengerDetails"))
        this.flightAvailabilities = this.cheapestFareFlight.flightAvailabilities
        this.priceInfo = this.flightAvailabilities.price
        this.adultsCount = this.flightAvailabilities.passengers.adultsCount
        this.childrenCount = this.flightAvailabilities.passengers.childrenCount
        this.infantsCount = this.flightAvailabilities.passengers.infantsCount
        this.payTotalFare = this.priceInfo.totalFare
        this.currencyCode = (this.currency.currencyRate !== 0 ? this.currency.currencyCode : this.priceInfo.currencyCode)
    },

    methods: {
        alfalahIpnDCCard(option){
             this.ipnDCCardOption = (option === 'hidden' ? 'show' : 'hidden')
        },
        initiateHC(payUrl){
            $('#dv3DS').load(payUrl);
            this.paymentOption ='hidden'
            window.addEventListener('message', this.processHC, false);
        },
        processHC(event){
            window.removeEventListener('message', this.processHC);
            this.processHCData = event.data
            this.paymentOption ='show'
        },
        setInitialDate(initialDate, formatType) {
            return moment(initialDate).format(formatType)
        },
        setCurrencyConverter(amount, currencyRate) {
            return CurrencyConverter.doRequest(amount, currencyRate)
        },
        activeTab(tabStatus) {
            this.tabStatus = tabStatus;
            if(tabStatus !== 'alfalahipn') this.ipnDCCardOption = 'hidden'
            // document.body.style.overflow = "hidden";
        },
        closeTabone(){
            this.tabStatus = '';
            document.body.style.overflow = "auto";
        },
        handleResize() {
            if (window.innerWidth < 640) {
                this.tabStatus = '';
            } else {
                this.activeTab('');
            }
        }
    },
    mounted() {
        this.handleResize();
        window.addEventListener('resize', this.handleResize);
                setTimeout(() => {
            this.$store.dispatch("throwError", "")
            $(".throw-error").css("display","none")
        }, 10000);
    },
    beforeMount() {
        window.removeEventListener('resize', this.handleResize);
    }
};


</script>
<style>
@media screen and (max-width: 639px) {
    .payment-open {
        animation: opens 0.7s;
    }
    @keyframes opens {
        from {
            transform: translateX(100%);
            animation-timing-function: cubic-bezier(0.1, 0, 3, 1);
        }
        to {
            transform: translateX(0);
            animation-timing-function: cubic-bezier(0, 0, 0.2, 1);
        }
    }
}
</style>
