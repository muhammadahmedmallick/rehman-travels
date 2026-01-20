<template>
    <div class="sticky top-0 z-50">
        <nav class="bg-white py-2 px-3 md:px-16 shadow-md flex sm:items-center sm:justify-between">
            <div class="logo-size w-full flex"><a :href="baseUrl"><img src="/rgt-logo.webp" alt="Rehman Travel"/></a></div>
            <div class="flex justify-end items-center w-[5.5rem] md:mr-3 md:w-[40rem] lg:w-[120rem]">
                <a href="tel:+51111786785" target="_blank" v-if="$page.props.getNum.landline">
                <p class="mr-3 items-center text-center hidden lg:flex cursor-pointer"><i class="fa fa-phone text-rGTBaseTextColor"></i>&nbsp; {{ $page.props.getNum.landline }}   <span class="ml-2 text-rGTBaseTextColor">|</span> </p></a>
                <a target="_blank" @click="whatsappContact()" v-if="$page.props.getNum.whatsapp">
                <p class="mr-3 items-center text-center hidden lg:flex cursor-pointer"><i class="fa-brands fa-whatsapp text-[#25D366]" > </i>&nbsp; {{ $page.props.getNum.whatsapp }}  <span class="ml-2 text-rGTBaseTextColor">|</span> </p></a>
                <div class="lg:flex items-center text-center sm:justify-center sm:mt-0 ml-2 hidden">
                    <a  target="_blank" href="https://www.facebook.com/rehmantravelofficial" title="Facebook" class="text-black hover:text-gray-900">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 32 32"
                                class="w-5 h-5 text-blue-600">
                            <path
                                d="M32 16c0-8.839-7.167-16-16-16-8.839 0-16 7.161-16 16 0 7.984 5.849 14.604 13.5 15.803v-11.177h-4.063v-4.625h4.063v-3.527c0-4.009 2.385-6.223 6.041-6.223 1.751 0 3.584 0.312 3.584 0.312v3.937h-2.021c-1.984 0-2.604 1.235-2.604 2.5v3h4.437l-0.713 4.625h-3.724v11.177c7.645-1.199 13.5-7.819 13.5-15.803z">
                            </path>
                        </svg>
                    </a>
                    <a target="_blank" href="https://twitter.com/rehmantravelcom" title="Twitter" class="text-black hover:text-gray-900 ms-5">
                        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                                class="w-5 h-5 text-rGTBaseTextColor">
                            <path
                                d="M23.954 4.569a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.691 8.094 4.066 6.13 1.64 3.161a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.061a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.937 4.937 0 004.604 3.417 9.868 9.868 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.054 0 13.999-7.496 13.999-13.986 0-.209 0-.42-.015-.63a9.936 9.936 0 002.46-2.548l-.047-.02z">
                            </path>
                        </svg>
                    </a>
                    <a target="_blank" href="https://www.instagram.com/rehmantravel/" title="Instagram" class="text-black hover:text-gray-900 ms-5">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" fill="currentColor"
                                class="w-5 h-5 text-red-400">
                            <path
                                d="M16 0c-4.349 0-4.891 0.021-6.593 0.093-1.709 0.084-2.865 0.349-3.885 0.745-1.052 0.412-1.948 0.959-2.833 1.849-0.891 0.885-1.443 1.781-1.849 2.833-0.396 1.020-0.661 2.176-0.745 3.885-0.077 1.703-0.093 2.244-0.093 6.593s0.021 4.891 0.093 6.593c0.084 1.704 0.349 2.865 0.745 3.885 0.412 1.052 0.959 1.948 1.849 2.833 0.885 0.891 1.781 1.443 2.833 1.849 1.020 0.391 2.181 0.661 3.885 0.745 1.703 0.077 2.244 0.093 6.593 0.093s4.891-0.021 6.593-0.093c1.704-0.084 2.865-0.355 3.885-0.745 1.052-0.412 1.948-0.959 2.833-1.849 0.891-0.885 1.443-1.776 1.849-2.833 0.391-1.020 0.661-2.181 0.745-3.885 0.077-1.703 0.093-2.244 0.093-6.593s-0.021-4.891-0.093-6.593c-0.084-1.704-0.355-2.871-0.745-3.885-0.412-1.052-0.959-1.948-1.849-2.833-0.885-0.891-1.776-1.443-2.833-1.849-1.020-0.396-2.181-0.661-3.885-0.745-1.703-0.077-2.244-0.093-6.593-0.093zM16 2.88c4.271 0 4.781 0.021 6.469 0.093 1.557 0.073 2.405 0.333 2.968 0.553 0.751 0.291 1.276 0.635 1.844 1.197 0.557 0.557 0.901 1.088 1.192 1.839 0.22 0.563 0.48 1.411 0.553 2.968 0.072 1.688 0.093 2.199 0.093 6.469s-0.021 4.781-0.099 6.469c-0.084 1.557-0.344 2.405-0.563 2.968-0.303 0.751-0.641 1.276-1.199 1.844-0.563 0.557-1.099 0.901-1.844 1.192-0.556 0.22-1.416 0.48-2.979 0.553-1.697 0.072-2.197 0.093-6.479 0.093s-4.781-0.021-6.48-0.099c-1.557-0.084-2.416-0.344-2.979-0.563-0.76-0.303-1.281-0.641-1.839-1.199-0.563-0.563-0.921-1.099-1.197-1.844-0.224-0.556-0.48-1.416-0.563-2.979-0.057-1.677-0.084-2.197-0.084-6.459 0-4.26 0.027-4.781 0.084-6.479 0.083-1.563 0.339-2.421 0.563-2.979 0.276-0.761 0.635-1.281 1.197-1.844 0.557-0.557 1.079-0.917 1.839-1.199 0.563-0.219 1.401-0.479 2.964-0.557 1.697-0.061 2.197-0.083 6.473-0.083zM16 7.787c-4.541 0-8.213 3.677-8.213 8.213 0 4.541 3.677 8.213 8.213 8.213 4.541 0 8.213-3.677 8.213-8.213 0-4.541-3.677-8.213-8.213-8.213zM16 21.333c-2.948 0-5.333-2.385-5.333-5.333s2.385-5.333 5.333-5.333c2.948 0 5.333 2.385 5.333 5.333s-2.385 5.333-5.333 5.333zM26.464 7.459c0 1.063-0.865 1.921-1.923 1.921-1.063 0-1.921-0.859-1.921-1.921 0-1.057 0.864-1.917 1.921-1.917s1.923 0.86 1.923 1.917z">
                            </path>
                        </svg>
                    </a>
                    <a  target="_blank" href="https://www.pinterest.com/rehmantravel" title="Pinterest" class="text-black hover:text-gray-900 ms-5">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="w-5 h-5 text-red-400"
                                viewBox="0 0 16 16">
                            <path
                                d="M8 0a8 8 0 0 0-2.915 15.452c-.07-.633-.134-1.606.027-2.297.146-.625.938-3.977.938-3.977s-.239-.479-.239-1.187c0-1.113.645-1.943 1.448-1.943.682 0 1.012.512 1.012 1.127 0 .686-.437 1.712-.663 2.663-.188.796.4 1.446 1.185 1.446 1.422 0 2.515-1.5 2.515-3.664 0-1.915-1.377-3.254-3.342-3.254-2.276 0-3.612 1.707-3.612 3.471 0 .688.265 1.425.595 1.826a.24.24 0 0 1 .056.23c-.061.252-.196.796-.222.907-.035.146-.116.177-.268.107-1-.465-1.624-1.926-1.624-3.1 0-2.523 1.834-4.84 5.286-4.84 2.775 0 4.932 1.977 4.932 4.62 0 2.757-1.739 4.976-4.151 4.976-.811 0-1.573-.421-1.834-.919l-.498 1.902c-.181.695-.669 1.566-.995 2.097A8 8 0 1 0 8 0z"
                                fill="red">
                            </path>
                        </svg>
                    </a>
                    <a  target="_blank" href="https://www.youtube.com/RehmanTravelsOfficial" title="Youtube" class="text-black hover:text-gray-900 ms-5">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="w-5 h-5 text-red-400"
                                viewBox="0 0 16 16">
                            <path
                                d="M8.051 1.999h.089c.822.003 4.987.033 6.11.335a2.01 2.01 0 0 1 1.415 1.42c.101.38.172.883.22 1.402l.01.104.022.26.008.104c.065.914.073 1.77.074 1.957v.075c-.001.194-.01 1.108-.082 2.06l-.008.105-.009.104c-.05.572-.124 1.14-.235 1.558a2.007 2.007 0 0 1-1.415 1.42c-1.16.312-5.569.334-6.18.335h-.142c-.309 0-1.587-.006-2.927-.052l-.17-.006-.087-.004-.171-.007-.171-.007c-1.11-.049-2.167-.128-2.654-.26a2.007 2.007 0 0 1-1.415-1.419c-.111-.417-.185-.986-.235-1.558L.09 9.82l-.008-.104A31.4 31.4 0 0 1 0 7.68v-.123c.002-.215.01-.958.064-1.778l.007-.103.003-.052.008-.104.022-.26.01-.104c.048-.519.119-1.023.22-1.402a2.007 2.007 0 0 1 1.415-1.42c.487-.13 1.544-.21 2.654-.26l.17-.007.172-.006.086-.003.171-.007A99.788 99.788 0 0 1 7.858 2h.193zM6.4 5.209v4.818l4.157-2.408L6.4 5.209z"
                                fill="red">
                            </path>
                        </svg>
                    </a>
                    <span class="ml-2">|</span>
                </div>
                <div class="items-center">
                    <SelectCurrency class="border md:border-none rounded-full p-1 mt-2 lg:mt-0"></SelectCurrency>
                </div>
                <!-- Toggle Navbar Button show below Medium Screen -->
                <button @click="toggleNav" data-collapse-toggle="toggle-nav" type="button"
                class="inline-flex items-center justify-center lg:hidden p-2 w-10 h-10 rounded-md text-txtColor focus:outline-none focus:ring-2 focus:ring-txtColor ml-4"
                aria-controls="toggle-nav" aria-expanded="false">
                <!-- Cross Inside Button -->
                <img v-if="colapse" src="/assets/Cross.svg" alt="Logo" />
                <!-- Bars Inside Button -->
                <svg v-if="!colapse" class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none"
                    viewBox="0 0 17 14">
                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M1 1h15M1 7h15M1 13h15" />
                </svg>
                </button>
            </div>
        </nav>
        <nav class="justify-center shadow-md lg:block" :class="NavClass">
            <div id="toggle-nav" :class="NavClass"
                 class="absolute bg-bgRGTBaseColor lg:block md:static right-2 md:right-0 -top-[0.5rem] md:top-0 w-60 md:w-auto rounded-lg md:rounded-none">
                <ul class="md:flex flex-wrap mx-5 justify-center md:gap-[1.0rem] items-center md:text-[15px] font-bold">
                    <li class="hover:text-NavListItemtxtHover md:border-b-2 md:border-transparent md:hover:border-ListItemHoverUnderline duration-300">
                        <a :href="baseUrl" class="block cursor-pointer py-4 pl-3 pr-4 text-textWhite focus:text-black rounded md:bg-transparent ">Home</a>
                    </li>
                    <li class="hover:text-NavListItemtxtHover md:border-b-2 md:border-transparent md:hover:border-ListItemHoverUnderline duration-300"
                        v-for="(menu, menuIndex) in $page.props.menus" :key="menuIndex">
                        <a :href="baseUrl+menu[0].parentUrl" :ref="menu[0].parentId" v-if="menu[0].contentId == ''"
                           class="block cursor-pointer py-4 pl-3 pr-4 text-textWhite focus:text-black rounded md:bg-transparent ">{{
                                menu[0].packageTitle
                            }}</a>
                        <button :ref="'dropdownSubMenu' + menu[0].parentId"
                        @click="MenuDropdownBtn(menu[0].parentId)"
                        v-if="menu[0].contentId != ''" :id="'dropdownSubMenu' + menu[0].parentId"
                                :data-dropdown-toggle="'dropdownSubMenu' + menu[0].parentId"
                                class="flex cursor-pointer items-center text-textWhite focus:text-black md:text-white justify-between w-full py-4 pl-3 pr-4 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-white md:w-auto">
                            {{ menuIndex }}
                            <svg v-if="menu[0].contentId != ''" class="w-2.5 h-2.5 ml-2.5" aria-hidden="true"
                                 xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
                                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                      stroke-width="2" d="m1 1 4 4 4-4"/>
                            </svg>
                        </button>
                        <ul :id="'dropdownSubMenu' + menu[0].parentId" v-if="subNavbar == menu[0].parentId && menu[0].contentId != ''"
                            :class="{'md:grid md:grid-cols-3' : menu.length > 8}"
                            class=" bg-white p-1 mt-1 md:mt-0 w-[83%] md:w-auto absolute text-black text-xs font-normal h-[250px] md:h-auto overflow-y-scroll md:overflow-hidden rounded-md shadow-[-4px_1px_8px_3px_#95959561] animate">
                            <li v-for="(allMenu, allMenuIndex) in menu" :key="allMenuIndex">
                                <a class="block p-2 hover:rounded-md hover:bg-NavdropHoverBg w-full hover:text-NavdropHoverText"
                                   :class="{'border-b-[1px]' : menu.length < 9, 'leading-tight truncate' : menu.length > 8}"
                                   :href="baseUrl+ '/' + allMenu.parentUrl">{{ allMenu.packageTitle }}</a>
                            </li>
                        </ul>
                    </li>
                    <li class="hover:text-NavListItemtxtHover md:border-b-2 md:border-transparent md:hover:border-ListItemHoverUnderline duration-300">
                        <a :href="route('contactUs')" class="block cursor-pointer py-4 pl-3 pr-4 text-textWhite focus:text-black rounded md:bg-transparent md:text-white ">Contact Us</a>
                    </li>
                </ul>
            </div>
        </nav>
    </div>
</template>
<script>
import SelectClass from "@/Layout/Website/SelectClass.vue";
import SelectCurrency from "@/Layout/Website/SelectCurrency.vue";
import SelectTravellers from "@/Layout/Website/SelectTravellers.vue";
import Service from "@/Config/Service.js";

export default {
    name: 'HeaderLayout',
    components: {
        SelectClass,
        SelectCurrency,
        SelectTravellers,
    },
    emits: ["selectedCurrencyFromParentToChild"],
    props: {
        selectedCurrencyFromChild: {type: Object}
    },
    data() {
        return {
            baseUrl:"",
            colapse: false,
            subNavbar: '',
            applyGrid: '',
            id : '',
            toggleCurrency: false,
            form: {
                contents: {
                    message : "Header Whatsapp Button",
                    moduleId : 19,
                    leadFrom : ""
                },
                whatsapp:{
                  code: (this.$page.props.getNum !== '' ? this.$page.props.getNum.country_code2 : 'PK')
                }
            },
        };
    },
    computed: {
        NavClass() {
            return {
                hidden: !this.colapse,
                animated: this.colapse,
            };
        },
    },
    created() {
        this.baseUrl = this.$page.props.ziggy.url;
        const currencyCode = (this.airURLSearchParam().get('ct') !== null ? this.airURLSearchParam().get('ct') : "USD");
        this.$page.props.currencies.filter(e => e.currencyCode === currencyCode)[0];
    },
    mounted () {
        document.addEventListener('click', this.close);
    },
    beforeDestroy () {
        document.removeEventListener('click',this.close)
    },
    methods: {
        toggleNav(){
            this.colapse = !this.colapse;
        },
        toggleCurrencyBtn() {
            this.toggleCurrency = !this.toggleCurrency;
            if (this.toggleCurrency) window.addEventListener("click", this.outsideClickHandler())
        },
        outsideClickHandler(event) {
            if (this.$refs.currencyMenu && !this.$refs.currencyMenu.contains(event.target)) this.toggleCurrency = false
        },
        close (e) {
            if (!this.$el.contains(e.target)) {
                this.subNavbar = "";
            }
        },
        selectCurrency(currency) {
            this.$store.dispatch("update", currency)
            this.queryString(currency)
        },
        queryString(currency) {
            var airURLHref = new URL(window.location.href);
            if (airURLHref.searchParams.get('cr') !== null) {
                airURLHref.searchParams.set('cr', currency.currencyRate);
                airURLHref.searchParams.set('ct', currency.currencyCode);
                airURLHref.searchParams.set('cs', currency.currencySymbol);
                airURLHref.searchParams.set('cf', currency.currencyFlag);
                history.pushState({}, '', airURLHref.toString());
            }
        },
        airURLSearchParam: function () {
            return new URLSearchParams(window.location.search)
        },
        MenuDropdownBtn(id) {
            if(this.subNavbar != ''){
                if(this.subNavbar == id){
                    this.subNavbar = "";
                }else{
                    this.subNavbar = id;
                }
            }else{
                this.subNavbar = id;
            }
        },
        whatsappContact(){
            Service.doFetchRequest("/whatsapp", '', this.form).then((data) => {
                window.location.href = 'https://api.whatsapp.com/send?phone='+ data.phone +'&&text=Need%20some%20Help%20Regarding%20%20%20'+ data.getreferalUrl;
            });
        }
    },
};
</script>
