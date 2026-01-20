<template>
    <div v-on:click="toggleCurrency(displayType)" class="flex items-center relative text-[14px] focus:outline-none cursor-pointer">
      <span v-if="currency.currencyCode" class="flex items-center">
        <img :src="`/currency/${currency.currencyFlag}`" class="mr-2 hidden md:block" height="22" width="22"
             :alt="currency.currencyFlag"/>
        <span class="text-sm sm:text-lg font-semibold">{{ currency.currencyCode }}</span>
      </span>
            <span v-else class="flex"><img src="#" alt=""> <span class="mx-1">Currency</span></span>
            <ul :class="`${displayType} absolute top-7 -right-10 w-36 p-2 bg-white text-black border rounded-lg shadow-md z-20`">
                <li v-for="(currency,currencyKey) in $page.props.currencies" :key="currencyKey">
                    <a href="javascript:void('')" class="flex items-center p-2 hover:bg-[#e7e7e7] rounded-md duration-300"
                       v-on:click="selectCurrency(currency)">
                        <img :src="`/currency/${currency.currencyFlag}`" class="mr-2" height="30" width="30"
                             :alt="currency.currencyFlag"/>
                        {{ currency.currencySymbol }}
                    </a>
                </li>
            </ul>
    </div>
</template>
<script>
import {mapState} from 'vuex'

export default {
    props: {currencies: {type: Object},},
    computed: {...mapState(['currency'])},
    data() {
        return {
            displayType:'hidden',
            currencyRate: 0,
            currencyCode: "",
            currencySymbol: "",
            currencyFlag: "",
        };
    },
    created() {
        if(this.$store.state.currency === ""){
            let currencyType =  this.airURLSearchParam().get('ct');
            let currency = this.$page.props.currencies.filter(e => e.currencyCode === (currencyType != null ? currencyType : 'USD'))[0];
            this.$store.dispatch("update", currency)
        }
    },
    mounted () {
        document.addEventListener('click', this.close);
    },
    beforeDestroy () {
        document.removeEventListener('click',this.close)
    },
    methods: {
        toggleCurrency(displayType) {
            console.log(displayType);
            this.displayType =(displayType == "hidden" ? "block" :  "hidden")
        },
        selectCurrency(currency) {
            this.$store.dispatch("update", currency)
            this.currencyRate = currency.currencyRate;
            this.currencyCode = currency.currencyCode;
            this.currencySymbol = currency.currencySymbol;
            this.currencyFlag = currency.currencyFlag;
            this.queryString(currency);
        },
        queryString(currency) {
            var airURLHref = new URL(window.location.href);
            if(airURLHref.searchParams.size !== 0){
                airURLHref.searchParams.set('cr', currency.currencyRate);
                airURLHref.searchParams.set('ct', currency.currencyCode);
                airURLHref.searchParams.set('cs', currency.currencySymbol);
                airURLHref.searchParams.set('cf', currency.currencyFlag);
                history.pushState({}, '', airURLHref.toString());
            }
        },
        airURLSearchParam: function () {
            return new URLSearchParams(window.location.search);
        },
        close (e) {
            if (!this.$el.contains(e.target)) {
                this.displayType = 'hidden';
            }
        },
    },
};
</script>
