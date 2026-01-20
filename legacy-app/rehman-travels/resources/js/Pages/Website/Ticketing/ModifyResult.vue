<template>
    <section>
        <div v-if="modifyModalPopup" class="flex justify-center mb-3">
            <div class="w-full p-4 pb-4 md:p-6 bg-bgRGTBaseColor shadow-xl">
                <!-- Search Flight Form -->
                <form @submit.prevent=""
                      class="flex flex-wrap items-center justify-between pb-4 lg:max-w-[982px] xl:max-w-[1230px] mx-auto">
                    <div class="flex flex-wrap">
                        <div class="md:border-r-2 border-white">
                            <button :class="{
                'bg-white': selectedButton === 'roundTrip',
                'text-rGTBaseTextColor': selectedButton === 'roundTrip',
                'bg-bgRGTBaseColor': selectedButton !== 'roundTrip',
                'text-[white]': selectedButton !== 'roundTrip',
              }" @click="roundBtn('roundTrip')" class="text-[14px] focus:outline-none py-1 px-2 border rounded-full">
                                Round Trip
                            </button>
                            <button :class="{
                'bg-white': selectedButton === 'oneWay',
                'text-rGTBaseTextColor': selectedButton === 'oneWay',
                'bg-bgRGTBaseColor': selectedButton !== 'oneWay',
                'text-[white]': selectedButton !== 'oneWay',
              }" @click="roundBtn('oneWay')" class="text-[14px] focus:outline-none py-1 px-2 border rounded-full mx-2">
                                One Way
                            </button>
                            <button :class="{
                'bg-white': selectedButton === 'multiCity',
                'text-rGTBaseTextColor': selectedButton === 'multiCity',
                'bg-bgRGTBaseColor': selectedButton !== 'multiCity',
                'text-[white]': selectedButton !== 'multiCity',
              }" @click="roundBtn('multiCity')"
                                    class="text-[14px] focus:outline-none py-1 px-2 md:mr-2 border rounded-full">
                                Multi-City
                            </button>
                        </div>

                        <div class="md:pl-2 flex flex-wrap items-center">
                            <!-- Select Class -->
                            <div class="hidden px-1 mr-1 border rounded-full text-white md:flex items-center">
                                <svg fill="white" height="16px" width="16px" version="1.1" id="Capa_1"
                                     xmlns="http://www.w3.org/2000/svg"
                                     xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 240.235 240.235"
                                     xml:space="preserve"
                                     class="mr-1 hidden md:block">
                  <g id="SVGRepo_bgCarrier" stroke-width="0"/>

                                    <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"/>

                                    <g id="SVGRepo_iconCarrier">
                    <path
                        d="M211.744,6.089C208.081,2.163,203.03,0,197.52,0h-15.143c-11.16,0-21.811,8.942-23.74,19.934l-0.955,5.436 c-0.96,5.47,0.332,10.651,3.639,14.589c3.307,3.938,8.186,6.106,13.74,6.106h19.561c2.714,0,5.339-0.542,7.778-1.504l-2.079,17.761 c-2.001-0.841-4.198-1.289-6.507-1.289h-22.318c-9.561,0-18.952,7.609-20.936,16.961l-19.732,93.027l-93.099-6.69 c-5.031-0.36-9.231,1.345-11.835,4.693c-2.439,3.136-3.152,7.343-2.009,11.847l10.824,42.618 c2.345,9.233,12.004,16.746,21.53,16.746h78.049h1.191h39.729c9.653,0,18.336-7.811,19.354-17.411l15.272-143.981 c0.087-0.823,0.097-1.634,0.069-2.437l5.227-44.648c0.738-1.923,1.207-3.967,1.354-6.087l0.346-4.97 C217.214,15.205,215.407,10.016,211.744,6.089z"/>
                  </g>
                </svg>
                                <SelectClass/>
                            </div>

                            <!-- Select Currency -->
                            <div class="hidden py-1 px-2 mr-2 border rounded-full text-white md:flex items-center">
                                <svg width="18px" class="mr-1" height="18px" viewBox="0 0 48.00 48.00"
                                     xmlns="http://www.w3.org/2000/svg" fill="white"
                                     stroke="white" stroke-width="0.8160000000000001">
                                    <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                                    <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
                                    <g id="SVGRepo_iconCarrier">
                                        <title>currency-revenue</title>
                                        <g id="Layer_2" data-name="Layer 2">
                                            <g id="Q3_icons" data-name="Q3 icons">
                                                <path
                                                    d="M44,7.1V14a2,2,0,0,1-2,2H35a2,2,0,0,1-2-2.3A2.1,2.1,0,0,1,35.1,12h2.3A18,18,0,0,0,6.1,22.2a2,2,0,0,1-2,1.8h0a2,2,0,0,1-2-2.2A22,22,0,0,1,40,8.9V7a2,2,0,0,1,2.3-2A2.1,2.1,0,0,1,44,7.1Z">
                                                </path>
                                                <path
                                                    d="M4,40.9V34a2,2,0,0,1,2-2h7a2,2,0,0,1,2,2.3A2.1,2.1,0,0,1,12.9,36H10.6A18,18,0,0,0,41.9,25.8a2,2,0,0,1,2-1.8h0a2,2,0,0,1,2,2.2A22,22,0,0,1,8,39.1V41a2,2,0,0,1-2.3,2A2.1,2.1,0,0,1,4,40.9Z">
                                                </path>
                                                <path
                                                    d="M24.7,22c-3.5-.7-3.5-1.3-3.5-1.8s.2-.6.5-.9a3.4,3.4,0,0,1,1.8-.4,6.3,6.3,0,0,1,3.3.9,1.8,1.8,0,0,0,2.7-.5,1.9,1.9,0,0,0-.4-2.8A9.1,9.1,0,0,0,26,15.3V13a2,2,0,0,0-4,0v2.2c-3,.5-5,2.5-5,5.2s3.3,4.9,6.5,5.5,3.3,1.3,3.3,1.8-1.1,1.4-2.5,1.4h0a6.7,6.7,0,0,1-4.1-1.3,2,2,0,0,0-2.8.6,1.8,1.8,0,0,0,.3,2.6A10.9,10.9,0,0,0,22,32.8V35a2,2,0,0,0,4,0V32.8a6.3,6.3,0,0,0,3-1.3,4.9,4.9,0,0,0,2-4h0C31,23.8,27.6,22.6,24.7,22Z">
                                                </path>
                                            </g>
                                        </g>
                                    </g>
                                </svg>
                                <SelectCurrency/>
                            </div>

                            <!-- Select Travekllers -->
                            <SelectTravellers class="hidden md:block py-1 px-2 border rounded-full text-white"/>
                        </div>
                    </div>
                    <span class="text-3xl lg:hidden" @click="closeModifyModalPopup"><i
                        class="fa-solid fa-xmark font-light text-white ml-2"></i></span>
                </form>

                <!-- For Round-Trip and One-Way -->
                <form @submit.prevent="" class="relative">
                    <div v-if="selectedButton === 'roundTrip' || selectedButton === 'oneWay'"
                         class="grid grid-cols-11 lg:max-w-[982px] xl:max-w-[1230px] mx-auto">
                        <!-- From Where ? -->
                        <div
                            class="col-span-12 md:col-span-3 lg:col-span-3 relative flex items-center px-3 lg:py-1 py-3 bg-white rounded-md">
                            <img :src="this.url+'plane-arrival.svg'"
                                 alt="plane-arrival" class="mr-3"/>
                            <input type="text" id="from-where" maxlength="50" autocomplete="off"
                                   class="w-full font-semibold focus:outline-none border-none focus:ring-0 p-0"
                                   placeholder="From Where ?"
                                   v-model="fromWhereInput"/>

                            <!-- Swap Destinations -->
                            <button @click="swapBtn"
                                    class="absolute border p-1 md:p-[3px] z-1 bg-white border-[#9da1ae] rotate-90 top-6 right-2 md:rotate-0 md:top-[0.4rem] md:-right-6 rounded-full">
                                <svg id="swap-arrow" height="30px" width="30px" fill="#006ee3" viewBox="0 0 24 24">
                                    <path
                                        d="M6.99 11L3 15l3.99 4v-3H14v-2H6.99v-3zM21 9l-3.99-4v3H10v2h7.01v3L21 9z"></path>
                                </svg>
                            </button>
                        </div>
                        <!-- To Where ? -->
                        <div
                            class="col-span-12 md:col-span-3 lg:col-span-3 my-2 md:my-0 md:mt-0 lg:ml-2 flex items-center px-3 lg:py-1 py-3 mx-0 md:ml-2 bg-white rounded-md">
                            <img :src="this.url+'plane-departure.svg'"
                                 alt="plane-departure" class="mr-3 md:ml-2"/>
                            <input type="text" id="to-where" maxlength="50" autocomplete="off"
                                   class="w-full font-semibold focus:outline-none border-none focus:ring-0 p-0"
                                   placeholder="To Where ?"
                                   v-model="toWhereInput"/>
                        </div>

                        <div class="col-span-12 md:col-span-4 md:mx-2">
                            <div class="grid grid-cols-12">
                                <!-- From Date ? -->
                                <div
                                    class="col-span-6 md:col-span-6 lg:col-span-6 flex items-center px-3 py-1 bg-white rounded-md">
                                    <img :src="this.url+'calender.svg'" alt="calender"
                                         class="mr-3"/>
                                    <input type="text" id="fromDate"
                                           class="w-full font-semibold focus:outline-none border-none focus:ring-0"
                                           v-model="fromDate"
                                           @input="updateMinToDate" placeholder="From Date?"/>
                                </div>

                                <!-- To Date -->
                                <div
                                    class="col-span-6 md:col-span-6 lg:col-span-6 flex items-center px-3 py-1 ml-1 bg-white rounded-md">
                                    <img :src="this.url+'calender.svg'" alt="calender"
                                         class="mr-3"/>
                                    <input type="text" id="toDate"
                                           class="w-full font-semibold focus:outline-none border-none focus:ring-0"
                                           :class="{
                      'opacity-25 cursor-not-allowed':
                        selectedButton === 'oneWay',
                    }" v-model="toDate" :min="minToDate" placeholder="To Date ?"/>
                                </div>
                            </div>
                        </div>

                        <!-- Search Button (Show on Medium and above Screens) -->
                        <div class="col-span-12 md:col-span-1 lg:col-span-1 relative hidden md:block">
                            <button
                                class="bg-white flex items-center justify-center text-rGTBaseTextColor sm:text-sm lg:text-base font-semibold py-3 md:py-4 lg:py-3 rounded-md w-full lg:mt-0">
                                <i class="fa fa-search mr-2 md:mr-0 lg:mr-2"></i>
                                <span class="md:hidden lg:block">Search</span>
                            </button>
                        </div>
                    </div>

                    <!-- For Multi-City -->
                    <div v-if="selectedButton === 'multiCity'"
                         class="overflow-auto md:overflow-hidden max-h-[24.5rem] md:h-fit">
                        <div v-for="(_, index) in entries" :key="index"
                             class="grid grid-cols-12 lg:max-w-[982px] xl:max-w-[1230px] mx-auto">
              <span class="flex col-span-12 text-white font-semibold mb-1 md:items-center md:justify-start">Flight {{
                      index + 1
                  }}</span>
                            <!-- From Where ? -->
                            <div
                                class="col-span-12 md:col-span-3 lg:col-span-3 relative flex items-center px-3 lg:py-1 py-3 bg-white rounded-md">
                                <img :src="this.url+'plane-arrival.svg'"
                                     alt="plane-departure" class="mr-3 md:ml-2">
                                <input type="text" id="from-where" maxlength="50" autocomplete="off"
                                       class="w-full font-semibold focus:outline-none border-none focus:ring-0 p-0"
                                       placeholder="From Where ?"
                                       v-model="fromWhereInput"/>

                                <!-- Swap Destinations -->
                                <button @click="swapBtn"
                                        class="absolute border p-1 md:p-[3px] md:top-[0.2rem] z-1 bg-white border-[#9da1ae] rotate-90 top-6 right-2 md:rotate-0 md:-right-6 rounded-full">
                                    <svg id="swap-arrow" height="30px" width="30px" fill="#006ee3" viewBox="0 0 24 24">
                                        <path
                                            d="M6.99 11L3 15l3.99 4v-3H14v-2H6.99v-3zM21 9l-3.99-4v3H10v2h7.01v3L21 9z"></path>
                                    </svg>
                                </button>
                            </div>
                            <!-- To Where ? -->
                            <div
                                class="col-span-12 md:col-span-3 lg:col-span-3 my-2 md:my-0 md:mt-0 lg:ml-2 flex items-center px-3 lg:py-1 py-3 mx-0 md:ml-2 bg-white rounded-md">
                                <img :src="this.url+'plane-departure.svg'"
                                     alt="plane-departure" class="mr-3 md:ml-2">
                                <input type="text" id="to-where" maxlength="50" autocomplete="off"
                                       class="w-full font-semibold focus:outline-none border-none focus:ring-0 p-0"
                                       placeholder="To Where ?"
                                       v-model="toWhereInput"/>
                            </div>

                            <!-- From Date ? -->
                            <div
                                class="col-span-12 md:col-span-2 lg:col-span-2 md:ml-2 flex items-center px-3 py-3 md:mr-0 bg-white rounded-md">
                                <img :src="this.url+'calender.svg'" alt="calender"
                                     class="mr-3"/>
                                <input type="text" id="fromDate"
                                       class="w-full font-semibold focus:outline-none border-none focus:ring-0 p-0"
                                       v-model="fromDate"
                                       @input="updateMinToDate" placeholder="From Date?"/>
                            </div>

                            <!-- Flight & Remove Button For Desktop View -->
                            <div class="col-span-12 md:col-span-2 flex justify-start md:justify-evenly mt-1 md:mt-0">
                                <!-- Add Flight Button -->
                                <button v-if="entries.length > 0 &&
                  index === entries.length - 1 &&
                  selectedButton === 'multiCity'
                  " @click="addNewEntry" class="text-white text-[14px] md:text-[14px] mr-3 md:mr-0">
                                    <i class="fa-solid fa-circle-plus mr-1"></i>
                                    <span>Add</span>
                                </button>
                                <!-- Remove Button -->
                                <button v-if="entries.length > 2 &&
                  index === entries.length - 1 &&
                  selectedButton === 'multiCity'
                  " @click="removeLastEntry" class="text-white text-[14px] md:text-[14px]">
                                    <i class="fa-solid fa-circle-minus mr-1"/>
                                    <span>Remove</span>
                                </button>
                            </div>

                            <!-- Search Button (Show on Medium and above Screens) -->
                            <div class="col-span-12 md:col-span-2 lg:col-span-2">
                                <button v-if="index === entries.length - 1"
                                        class="text-[#0d6efd] bg-white hidden md:block md:static sm:text-sm font-semibold py-3 rounded-md w-full lg:mt-0">
                                    <i class="fa fa-search"></i> Search Flights
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Travellers for Mobile View (Show on Medium and above Screens)) -->
                    <div class="flex items-center px-3 py-2 mt-2 mb-2 md:hidden bg-white rounded-md">
                        <img :src="this.url+'traveller.svg'" alt=""/>
                        <SelectTravellers class="mr-2"/>
                        /
                        <img :src="this.url+'class.svg'" alt="" class="ml-1"/>
                        <SelectClass class="p-0"/>
                    </div>

                    <!-- Search Button for Roundtrip, Oneway and Multi-City (Show on only below Medium Screens) -->
                    <div class="md:hidden">
                        <button
                            class="text-rGTBaseTextColor bg-white sm:text-sm font-semibold py-3 rounded-md w-full lg:mt-0">
                            <i class="fa fa-search"></i> Search Flights
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </section>
</template>
<script>
import SelectTravellers from '@/Layout/Website/SelectTravellers.vue';
import SelectClass from '@/Layout/Website/SelectClass.vue';
export default {
    components: {
        SelectTravellers,
        SelectClass,
    },
    data() {
        return {
            url: "",
            modifyModalPopup: true,
            selectedButton: "roundTrip",
            fromWhereInput: "ISB,Islamabad-Pakistan",
            toWhereInput: "JFK,New York,USA",

            //Date
            fromDate: '2023-11-06',
            toDate: '2023-11-15',
            minToDate: '',

            //Enter Detail Initial Value
            fromWhere: "",
            toWhere: "",
            enteredFromDate: "",
            enteredToDate: "",

            //Array Storing eentered Values
            entries: [
                {fromWhere: "", toWhere: "", enteredFromDate: "", enteredToDate: ""},
            ],
        };
    },
    mounted() {
        this.url = this.$page.props.ziggy.url + "/assets/Flights/flightPageIcons/";
    },
    methods: {
        roundBtn(roundButton) {
            this.selectedButton = roundButton;
        },
        updateMinToDate() {
            this.minToDate = this.fromDate;
            if (this.toDate < this.fromDate) {
                this.toDate = this.fromDate;
            }
        },
        addNewEntry() {
            this.entries.push({
                fromWhere: "",
                toWhere: "",
                enteredFromDate: "",
                enteredToDate: "",
            });
        },
        removeLastEntry() {
            this.entries.pop();
        },

        swapBtn() {
            const temp = this.fromWhereInput;
            this.fromWhereInput = this.toWhereInput;
            this.toWhereInput = temp;
        },

        closeModifyModalPopup() {
            this.$emit('close-popup');
        },

        tryClose() {
            this.$emit('close');
        },
    },
};
</script>
