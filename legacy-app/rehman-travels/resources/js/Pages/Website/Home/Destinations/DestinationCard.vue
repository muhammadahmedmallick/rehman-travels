<template>
    <div :class="`relative w-full justify-center ${ $page.props.getNum.whatsapp === '' || $page.props.getNum.landline  === '' ? ' md:-mt-[8rem] -mt-48' : ''}`">
        <section :class="`${ packagesKey === 'Hajj' && isXlScreen ? 'block' : (!isXlScreen ? 'block' : 'hidden')} px-2 md:px-4 py-4 xs:p-6 mx-auto w-[90%] sm:w-[78%] xl:w-[88%] 2xl:w-[78%]`"
                 v-for="(subPackages, packagesKey) in sortedDestinations" :key="packagesKey">
            <div class="grid grid-cols-12 cursor-pointer p-1">
                <h2 v-if="packagesKey === 'Hajj'" :class="{'sm:col-span-8' : packagesKey === 'Hajj'}"
                    class="col-span-12 justify-center sm:justify-normal flex flex-wrap items-center text-lg sm:text-xl md:text-[23px] lg:text-2xl xl:text-3xl text-[#313541] font-bold mb-5">
                    Explore
                    <svg width="24" height="24" fill="#008A04" class="bi bi-send-fill send-icon mx-2"
                         viewBox="0 0 16 16">
                        <path
                            d="M15.964.686a.5.5 0 0 0-.65-.65L.767 5.855H.766l-.452.18a.5.5 0 0 0-.082.887l.41.26.001.002 4.995 3.178 3.178 4.995.002.002.26.41a.5.5 0 0 0 .886-.083l6-15Zm-1.833 1.89L6.637 10.07l-.215-.338a.5.5 0 0 0-.154-.154l-.338-.215 7.494-7.494 1.178-.471-.47 1.178Z"></path>
                    </svg>
                    <span class="text-[#008A04] mr-2">{{ packagesKey }}</span>
                    <span v-if="packagesKey == 'Umrah' || packagesKey == 'Hajj'"> Best Packages</span> <span v-if="packagesKey != 'Umrah' && packagesKey !== 'Hajj'">Destinations</span>
                </h2>
                <h2 v-if="packagesKey != 'Hajj' && packagesKey === 'Visa'"
                    class="col-span-12 justify-center sm:justify-normal sm:col-span-8 flex flex-wrap items-center text-lg sm:text-xl md:text-[23px] lg:text-2xl xl:text-3xl text-[#313541] font-bold mb-5">
                    Explore
                    <svg width="24" height="24" fill="#008A04" class="bi bi-send-fill send-icon mx-2"
                        viewBox="0 0 16 16">
                        <path
                            d="M15.964.686a.5.5 0 0 0-.65-.65L.767 5.855H.766l-.452.18a.5.5 0 0 0-.082.887l.41.26.001.002 4.995 3.178 3.178 4.995.002.002.26.41a.5.5 0 0 0 .886-.083l6-15Zm-1.833 1.89L6.637 10.07l-.215-.338a.5.5 0 0 0-.154-.154l-.338-.215 7.494-7.494 1.178-.471-.47 1.178Z"></path>
                    </svg>
                    <span class="mr-2">These Welcoming </span> <span class="text-[#008A04] mr-2">Visit {{ packagesKey }}</span>
                    <span v-if="packagesKey === 'Umrah' || packagesKey === 'Hajj'"> Best Packages</span> <span v-if="packagesKey !== 'Umrah' && packagesKey !== 'Hajj'">Destinations</span>
                </h2>
                <h2 v-if="packagesKey != 'Hajj' && packagesKey != 'Visa'" :class="{'sm:col-span-8' : packagesKey === 'Hajj'}"
                    class="col-span-12 justify-center sm:justify-normal flex flex-wrap items-center text-lg sm:text-xl md:text-[23px] lg:text-2xl xl:text-3xl text-[#313541] font-bold mb-5">
                    Explore
                    <svg width="24" height="24" fill="#008A04" class="bi bi-send-fill send-icon mx-2"
                         viewBox="0 0 16 16">
                        <path
                            d="M15.964.686a.5.5 0 0 0-.65-.65L.767 5.855H.766l-.452.18a.5.5 0 0 0-.082.887l.41.26.001.002 4.995 3.178 3.178 4.995.002.002.26.41a.5.5 0 0 0 .886-.083l6-15Zm-1.833 1.89L6.637 10.07l-.215-.338a.5.5 0 0 0-.154-.154l-.338-.215 7.494-7.494 1.178-.471-.47 1.178Z"></path>
                    </svg>
                    <span class="text-[#008A04] mr-2">{{ packagesKey }}</span>
                    <span v-if="packagesKey == 'Umrah' || packagesKey == 'Hajj'"> Best Packages</span> <span v-if="packagesKey != 'Umrah' && packagesKey !== 'Hajj'">Destinations</span>
                </h2>
                <a class="col-span-12 sm:col-span-4 flex justify-end mb-5" v-if="packagesKey === 'Hajj'"
                   target="_blank"
                   href="https://maps.app.goo.gl/CZGkiXx2DJzXieuQ7">
                    <button class="block w-full sm:w-36 md:w-44 lg:w-52 text-rGTBaseTextColor text-sm  md:text-[17px] lg:text-[19px] xl:text-xl  border-[1px] border-rGTBorderColor hover:bg-[#dde9fb] py-1 rounded-md">
                        <i class="fas fa-map-marker-alt mr-2"></i>Map View
                    </button>
                </a>
            </div>
            <!-- Card 1 -->
            <div class="grid grid-cols-12 bg-[#f1f5f8] rounded-lg">
                <a :href="baseUrl+ '/' + subPackage.urlLink" v-for="(subPackage, subPackageKey) in subPackages"
                   :key="subPackageKey"
                   class="block col-span-12 lg:col-span-3 md:col-span-6 xs:col-span-6  m-2 rounded-lg overflow-hidden shadow-lg">
                    <img :src="'assets/'+ packagesKey + '/' + subPackage.cardImage"
                         :alt="subPackage.packageTitle"
                         class="w-full object-cover object-center rounded-tl-md rounded-tr-md"/>
                    <div class="relative px-4 bg-white">
                        <div class="px-2 py-4 rounded-lg">
                            <div class="flex items-center">
                                <span class="text-xl font-semibold leading-tight truncate">{{ subPackage.packageTitle }}</span>

                                <span v-if="subPackage.type" class="block xs:hidden sm:block bg-bgRGTBaseColor text-white ml-2 opacity-100 text-xs px-1 py-[02px] rounded-md uppercase font-semibold tracking-wide">
                                    {{ subPackage.type }}
                                </span>
                            </div>
                            <div class="mt-4 mb-2">
                                <span class="text-gray-600 text-xs md:text-sm font-semibold">Starting from</span>
                            </div>
                            <div class="flex flex-wrap justify-between items-center mb-3">
                                <span class="text-base lg:text-xl xs:pr-4 sm:pr-0 font-semibold text-[#008A04]">
                                    {{currency.currencySymbol}}
                                    {{setConverter((subPackage.price != "" ? subPackage.price : subPackage.price), (subPackage.price != "" ? subPackage.currencyType : subPackage.currencyType), currency)}}*
                                </span>
                                <a :href="baseUrl+ '/' + subPackage.urlLink"> 
                                    View Details <i class="fa-solid fa-arrow-right ml-1"></i>
                                </a>
                            </div>
                            <div class="relative pt-1 pb-2">
                                <div
                                    class="w-full h-[0.3rem] rounded-md min-h-[0.3rem] mt-[0.4rem] bg-gradient-to-r from-green-600 via-blue-500 to-purple-600">
                                    <div
                                        class="absolute border border-b-transparent border-t-[0.5rem] border-green-600 left-[2.3rem] top-0 border-r-[0.4rem] border-r-transparent border-l-[0.4rem] border-l-transparent">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </a>
            </div>
        </section>
    </div>
</template>
<script>
import CurrencyConverter from "@/Config/CurrencyConverter.js";
import {mapState} from "vuex";

export default {
    computed: {
        ...mapState(['currency']),
        sortedDestinations() {
            const destinations = this.$page.props.destinations;
            const sortedKeys = Object.keys(destinations).sort((a, b) => {
                if (a === 'Hajj') return -1; // Hajj comes first
                if (b === 'Hajj') return 1;
                if (a === 'Visa') return -1; // Umrah comes second
                if (b === 'Visa') return 1;
                return 0;
            });

            const sortedDestinations = {};
            sortedKeys.forEach(key => {
                sortedDestinations[key] = destinations[key];
            });

            return sortedDestinations;
        }
    },
    data() {
        return {
            baseUrl: '',
            isXlScreen: false,
        }
    },
    mounted() {
        this.baseUrl = this.$page.props.ziggy.url;
        this.isXlScreen = window.innerWidth <= 600;
        window.addEventListener('resize', this.handleResize);
    },
    beforeDestroy() {
        window.removeEventListener('resize', this.handleResize);
    },
    methods: {
        handleResize() {
            this.isXlScreen = window.innerWidth <= 600;
        },
        setConverter(amount, currencyCode, currency) {
            const packageCurrencyInfo = this.$page.props.currencies.filter(o => o.currencyCode === currencyCode)[0];
            return currencyCode === currency.currencyCode || currencyCode === "PKR" && currency.currencyCode === "PKR" ? amount : currencyCode !== "PKR" && currency.currencyCode === "PKR" ? Math.floor(eval(amount) * packageCurrencyInfo.currencyRate) : Math.floor(CurrencyConverter.doRequest(eval(amount) * packageCurrencyInfo.currencyRate, currency.currencyRate))
        },
    },
}
</script>
