<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import SuccessButton from '@/Components/SuccessButton.vue';
import DangerButton from '@/Components/DangerButton.vue';
import CKEditor from '@ckeditor/ckeditor5-vue';
import Autocomplete from "@/Pages/Website/Ticketing/Autocomplete.vue"
</script>

<template>
    <AuthenticatedLayout>
        <div class="w-[95%] mx-auto bg-white">
            <div class="w-full bg-gradient-to-r from-sky-800 via-sky-600 to-sky-700 mt-2">
                <div>
                    <h2 class="text-white p-1 ml-6 font-semibold text-lg">
                        Manage Pages
                    </h2>
                </div>
            </div>
            <div class="p-4 mx-auto mt-8">
                <form class="w-full" @submit.prevent="submit">
                    <input v-model="input._method" type="hidden" />
                    <div class="flex flex-wrap -mx-3 mb-5">
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/6 px-1 mb-1">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="category-name">
                                Page Title
                            </label>
                            <input
                                :class="`appearance-none block w-full h-10 text-[14px] border ${errors.packageTitle == 'error' ? 'border-red-400' : 'border-gray-300'}  hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.packageTitle" @input="concateUrlLink()" type="text"
                                v-on:keyup="isEmpty('packageTitle')" placeholder="Package Name" />
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/12 px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="page-parent">
                                Page Parent
                            </label>
                            <select
                                :class="`block appearance-none w-full h-10 text-[14px] border ${errors.parentId == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.parentId" @change="concateUrlLink()" v-on:change="isEmpty('parentId')">
                                <option value="0">-- Select Parent Page --</option>
                                <option v-for="(parentPage, parentPageKey) in $page.props.parentPages"
                                    :key="parentPageKey" :value="parentPage['id']">
                                    {{ parentPage['title'] }}
                                </option>
                            </select>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[11%] px-1 mb-5" v-if="input.parentId == 12">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="order-sequence">
                                Tour Category
                            </label>
                            <select
                                class="block appearance-none w-full h-10 text-[14px] border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.tourCategory">
                                <option>--Select Type--</option>
                                <option value="wopackage">With Out Package</option>
                                <option value="wpackage">With Package</option>
                            </select>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[13%] px-1" v-if="input.parentId == 20">
                            <div :class="`appearance-none block text-[14px] mt-5 text-gray-700 border ${errors.flight.departCode == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`">
                                <Autocomplete v-model="input.flight.departCode" @click="concateUrlLink()" v-on:change="isEmpty('departCode')"
                                    @update:autocomplete="outinboundAirportDetail" :initialIndex="0"
                                    :initialType="'outbound'"></Autocomplete>
                            </div>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[13%] px-1" v-if="input.parentId == 20">
                            <div :class="`appearance-none block text-[14px] mt-5 text-gray-700 border ${errors.flight.arrCode == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`">
                                <Autocomplete v-model="input.flight.arrCode" @click="concateUrlLink()" v-on:change="isEmpty('arrCode')"
                                    @update:autocomplete="outinboundAirportDetail" :initialIndex="0"
                                    :initialType="'inbound'"></Autocomplete>
                            </div>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[8%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="order-sequence">
                                Order/Sequence
                            </label>
                            <input v-on:input="isEmpty('sequence')"
                                :class="`appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.sequence == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.sequence" type="text" placeholder="Order/Sequence" />
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-1/12 px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2 lg:ml-2"
                                for="status">
                                Status
                            </label>
                            <select v-on:change="isEmpty('status')"
                                :class="`block appearance-none w-full h-10 text-[14px] border ${errors.status == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                id="status" v-model="input.status">
                                <option>--Select Status--</option>
                                <option value="1">Active</option>
                                <option value="0">De-Active</option>
                            </select>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/6 px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="url-link">
                                URL Link
                            </label>
                            <input v-on:input="isEmpty('urlLink')"
                                :class="`appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.urlLink == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                type="text" v-model="input.urlLink" placeholder="URL Link" />
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-[6%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="type">
                                Type
                            </label>
                            <select v-on:change="isEmpty('type')"
                                :class="`block appearance-none w-full h-10 text-[14px] border ${errors.type == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.type">
                                <option>--Select Type--</option>
                                <option value="1">New</option>
                                <option value="0">Old</option>
                            </select>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[5%] px-1 mb-5">
                            <label for="currency"
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2">Currency</label>
                            <select v-model="input.currencyType" name="currency" v-on:change="isEmpty('currencyType')"
                                :class="`block appearance-none w-full h-10 text-[14px] border ${errors.currencyType == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`">
                                <option value="PKR">PKR</option>
                                <option value="USD" selected="selected">USD</option>
                                <option value="SR">SAR</option>
                                <option value="AED">AED</option>
                                <option value="EUR">EURO</option>
                                <option value="GBP">GBP</option>
                            </select>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[6%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="price">
                                Price
                            </label>
                            <input v-on:input="isEmpty('price')"
                                :class="`appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.price == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                type="text" v-model="input.price" placeholder="Price" />
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-1/12 px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="type">
                                Show On Home
                            </label>
                            <select v-on:change="isEmpty('showOnHome')"
                                :class="`block appearance-none w-full h-10 text-[14px] border ${errors.showOnHome == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.showOnHome">
                                <option>--Select Type--</option>
                                <option value="1">Yes</option>
                                <option value="0">No</option>
                            </select>
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-[12%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="canonical">
                                card Image
                            </label>
                            <input
                                class="appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.cardImage == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                :onChange="(e) => { input.cardImage = e.target.files[0];}"
                                type="file" placeholder="Canonical URL" />
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-[12%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="canonical">
                                Banner Image
                            </label>
                            <input
                                class="appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.bannerImage == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                :onChange="(e) => { input.bannerImage = e.target.files[0];}"
                                type="file" placeholder="Canonical URL" />
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-1/6 px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="canonical">
                                Canonical URL
                            </label>
                            <input v-on:input="isEmpty('canonicalUrl')"
                                :class="`appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.canonicalUrl == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.canonicalUrl" type="text" placeholder="Canonical URL" />
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[13%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="meta-title">
                                Meta Title
                            </label>
                            <input v-on:input="isEmpty('metaTitle')"
                                :class="`appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.metaTitle == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.metaTitle" type="text" placeholder="Meta Title" />
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[30.5%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="grid-last-name">
                                Meta Description
                            </label>
                            <input v-on:input="isEmpty('metaDescription')"
                                :class="`appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.metaDescription == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.metaDescription" type="text" placeholder="Meta Description" />
                        </div>
                    </div>
                    <div class="flex flex-wrap -mx-3" v-if="input.parentId == 12 && input.tourCategory == 'wpackage'">
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-[13%] px-1 mb-5">
                            <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="type"> Show Departure
                            </label>
                            <select
                                class="block appearance-none w-full h-10 text-[14px] border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.tourPackage.show_departure">
                                <option>--Select Type--</option>
                                <option value="1">Yes</option>
                                <option value="0">No</option>
                            </select>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[13%] px-1 mb-5">
                            <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="price"> Fixed Date
                            </label>
                            <input
                                class="appearance-none block w-full h-10 text-[14px] text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                type="text" v-model="input.tourPackage.fixed_date" placeholder="Fixed Date" />
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-[10%] px-1 mb-5">
                            <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="type"> Tour Status
                            </label>
                            <select
                                class="block appearance-none w-full h-10 text-[14px] border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.tourPackage.tour_status">
                                <option>--Select Type--</option>
                                <option value="1">Yes</option>
                                <option value="0">No</option>
                            </select>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/12 px-1 mb-1">
                            <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="category-name"> Tour Days
                            </label>
                            <input
                                class="appearance-none block w-full h-10 text-[14px] border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.tourPackage.tour_days" type="text" placeholder="Tour Days" />
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[12%] px-1 mb-1">
                            <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="category-name"> Tour Availability
                            </label>
                            <input
                                class="appearance-none block w-full h-10 text-[14px] border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.tourPackage.tour_availability" type="text"
                                placeholder="Tour Availability" />
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[10%] px-1 mb-5">
                            <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="page-parent"> Price Label
                            </label>
                            <select
                                class="block appearance-none w-full h-10 text-[14px] border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.tourPackage.price_label">
                                <option>-- Select Parent Page --</option>
                                <option value="0">Couple</option>
                                <option value="1">Per person</option>
                            </select>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[10%] px-1 mb-5">
                            <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="order-sequence"> Discount Price
                            </label>
                            <input
                                class="appearance-none block w-full h-10 text-[14px] text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.tourPackage.discount_price" type="text" placeholder="Discount Price" />
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[23%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2 lg:ml-2"
                                for="status"> Departure Location
                            </label>
                            <input
                                class="appearance-none block w-full h-10 text-[14px] text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                type="text" v-model="input.tourPackage.departure_location"
                                placeholder="Departure Location" />
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[14%] px-1 mb-5">
                            <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="url-link"> Destination Location
                            </label>
                            <input
                                class="appearance-none block w-full h-10 text-[14px] text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                type="text" v-model="input.tourPackage.destination_location"
                                placeholder="Destination Location" />
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-[10%] px-1 mb-5">
                            <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="type"> Tour States
                            </label>
                            <select
                                class="block appearance-none w-full h-10 text-[14px] border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.tourPackage.domestic_states_id">
                                <option>--Select Type--</option>
                                <option value="10">KPK</option>
                                <option value="11">Punjab</option>
                                <option value="12">Sindh</option>
                                <option value="13">Balochistan</option>
                            </select>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[20%] px-1 mb-5">
                            <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="url-link"> Tour Services
                            </label>
                            <input
                                class="appearance-none block w-full h-10 text-[14px] text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                type="text" v-model="input.tourPackage.tour_services" placeholder="Tour Services" />
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/4 px-1 mb-5">
                            <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="map"> Map
                            </label>
                            <input name="map"
                                class="appearance-none block w-full h-10 text-[14px] text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                type="text" v-model="input.tourPackage.map" placeholder="Map" />
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[30%] px-1 mb-1">
                            <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="category-name">
                                Meta Keyword
                            </label>
                            <input class="appearance-none block w-full h-10 text-[14px] border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.tourPackage.meta_keyword" type="text" placeholder="Meta Keyword" />
                        </div>
                    </div>
                </form>
            </div>
            <div class="mx-auto px-4 py-2" v-if="input.parentId == 12 && input.tourCategory == 'wpackage'">
                <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="category-name"> 
                    Days Details
                </label>
                <ckeditor :editor="editor" v-model="input.tourPackage.days_details" :config="editorConfig"></ckeditor>
            </div>
            <div class="mx-auto px-4 py-2">
                <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="schema"> 
                    Schema
                </label>
                <textarea rows="12" cols="12" id="schema"
                 class="appearance-none block w-full text-[14px] border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                v-model="input.schemaVal"></textarea>
            </div>
            <div class="mx-auto p-4">
                <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="category-name"> 
                    Includes
                </label>
                <ckeditor :editor="editor" v-model="input.includes" :config="editorConfig"></ckeditor>
            </div>
            <div class="mx-auto p-4">
                <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="category-name"> 
                    Excludes
                </label>
                <ckeditor :editor="editor" v-model="input.excludes" :config="editorConfig"></ckeditor>
            </div>
            <div class="mx-auto p-4">
                <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="category-name"> 
                    Short Details
                </label>
                <ckeditor :editor="editor" v-model="input.shortDescription" :config="editorConfig"></ckeditor>
            </div>
            <div class="mx-auto p-4">
                <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="category-name"> 
                    Details<span v-if="errors.description"> <i><small class="text-red-600 text-[9px]">(Please fill the field)</small></i></span>
                </label>
                <ckeditor :editor="editor" v-model="input.description" :config="editorConfig"></ckeditor>
            </div>
            <div class="md:flex justify-end m-3 p-3">
                <SuccessButton class="mr-3" @click="save()">Add New Page</SuccessButton>
                <DangerButton>Rest Form</DangerButton>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script>
import ClassicEditor from '@ckeditor/ckeditor5-build-classic';
import moment from 'moment';
export default {
    name: "addNewPage",
    components: {
        // Use the <ckeditor> component in this view.
        ckeditor: CKEditor.component,
        Autocomplete
    },
    data() {
        return {
            editor: ClassicEditor,
            editorConfig: {
                toolbar: {
                    items: [
                        'undo', 'redo',
                        '|',
                        'heading',
                        '|',
                        'fontfamily', 'fontsize', 'fontColor', 'fontBackgroundColor',
                        '|',
                        'bold', 'italic', 'strikethrough', 'subscript', 'superscript', 'code',
                        '|',
                        'link', 'uploadImage', 'blockQuote', 'codeBlock',
                        '|',
                        'bulletedList', 'numberedList', 'todoList', 'outdent', 'indent'
                    ]
                },
                menuBar: {
                    isVisible: true
                },
                language: 'en',
                heading: {
                    options: [
                        { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
                        { model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1' },
                        { model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2' },
                        { model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3' },
                        { model: 'heading4', view: 'h4', title: 'Heading 4', class: 'ck-heading_heading4' },
                        { model: 'heading5', view: 'h5', title: 'Heading 5', class: 'ck-heading_heading5' }
                    ]
                },
            },
            errors: {
                packageTitle: '',
                parentId: '',
                sequence: '',
                status: '',
                urlLink: '',
                currencyType: '',
                cardImage: '',
                bannerImage: '',
                price: '',
                type: '',
                showOnHome: '',
                includes: '',
                excludes: '',
                canonicalUrl: '',
                metaTitle: '',
                metaDescription: '',
                shortDescription: '',
                description: '',
                flight: {
                    departCode: '',
                    arrCode: '',
                },
            },
            input: {
                tourCategory : 'wopackage',
                id: '',
                packageTitle: '',
                parentId: '',
                sequence: '',
                categories : '',
                status: '1',
                urlLink: '',
                schemaVal: '',
                currencyType: 'PKR',
                cardImage: '',
                bannerImage: '',
                price: '',
                type: '1',
                flight: {
                    departCode: '',
                    departFullname:'',
                    arrCode: '',
                    arrFullname:'',
                },
                showOnHome: '1',
                includes: '',
                excludes: '',
                canonicalUrl: '',
                metaTitle: '',
                metaDescription: '',
                shortDescription: '',
                description: '',
                _method: '',
                tourPackage: {
                    id:'',
                    cms_cp_id:'',
                    tour_status:'1',
                    domestic_states_id: '',
                    meta_keyword:'',
                    tour_days:'',
                    tour_availability:moment(new Date()).format('DD-MM-YYYY'),
                    price_label:'1',
                    discount_price:'0.00',
                    departure_location:'',
                    destination_location:'',
                    tour_services:'',
                    map:'',
                    days_details:'',
                    show_departure:'1',
                    fixed_date: moment(new Date()).format('Y'),
                    created_by: ''
                }
            },
        }
    },
    methods: {
        outinboundAirportDetail(initial) {
            if (initial !== undefined) {
                if (initial.initialType === 'outbound') {
                    this.input.flight.departFullname = initial.fullName;
                    this.input.flight.departCode = initial.code;
                } else if (initial.initialType === 'inbound') {
                    this.input.flight.arrFullname = initial.fullName;
                    this.input.flight.arrCode = initial.code;
                }
            }
        },
        customImageUploadAdapter(editor) {
            editor.plugins.get('FileRepository').createUploadAdapter = loader => {
                return {
                    upload: async file => {
                        const formData = new FormData();
                        formData.append('image', file);
                        try {
                            const response = await fetch('/upload', {
                                method: 'POST',
                                body: formData,
                            });
                            const data = await response.json();
                            return {
                                default: data.imagePath,
                            };
                        } catch (error) {
                            console.error('Upload failed', error);
                            return {
                                error: 'Upload failed',
                            };
                        }
                    },
                };
            };
        },
        concateUrlLink() {
            let parentPages = this.$page.props.parentPages;
            let packageTitle = this.input.packageTitle;
            if (this.input.packageTitle != "" && this.input.parentId != "") {
                for (let parentPageKey in parentPages) {
                    if (this.input.parentId == parentPages[parentPageKey].id) {
                        console.log(parentPages[parentPageKey].id);
                        if(parentPages[parentPageKey].id == 20){
                            let parentTitle = (parentPages[parentPageKey].title).replace(/\s+/g, "").toLowerCase();
                            console.log(this.input.flight.departCode, this.input.flight.arrCode);
                            this.input.urlLink = (parentTitle + "/" + this.input.flight.departCode + "/" + this.input.flight.arrCode + "/" + packageTitle).replace(/\s+/g, "-").toLowerCase();
                        }else if (parentPages[parentPageKey].id == 12) {
                            let parentTitle = (parentPages[parentPageKey].title).replace(/\s+/g, "").toLowerCase()
                            this.input.urlLink = (parentTitle + "/" + packageTitle).replace(/\s+/g, "-").toLowerCase();
                        } else {
                            this.input.urlLink = (parentPages[parentPageKey].title + "/" + packageTitle).replace(/\s+/g, "-").toLowerCase();
                        }
                        if (parentPages[parentPageKey].title == "World Tours") {
                            this.input.categories = "International Tour";
                        } else if (parentPages[parentPageKey].title == "Pakistan Tours") {
                            this.input.categories = "Domestic Tour";
                        } else if(this.input.parentId == 20){
                            this.input.categories = "Flights";
                        }else{
                            this.input.categories = parentPages[parentPageKey].title;
                        }
                        console.log(this.input.categories);
                    }
                }
            } else {
                this.input.urlLink = packageTitle.replace(/\s+/g, "-").toLowerCase();
            }
        },
        isEmpty(title) {
            if (title === 'packageTitle')
                this.errors.packageTitle = "";
            else if (title === "parentId")
                this.errors.parentId = "";
            else if (title === "arrCode")
                this.errors.flight.arrCode = "";
            else if (title === "departCode")
                this.errors.flight.arrCode = "";
            else if (title === "sequence")
                this.errors.sequence = "";
            else if (title === "status")
                this.errors.status = "";
            else if (title === "urlLink")
                this.errors.urlLink = "";
            else if (title === "currencyType")
                this.errors.currencyType = "";
            else if (title === "price")
                this.errors.price = "";
            else if (title === "cardImage")
                this.errors.cardImage = "";
            else if (title === "bannerImage")
                this.errors.bannerImage = "";
            else if (title === "type")
                this.errors.type = "";
            else if (title === "showOnHome")
                this.errors.showOnHome = "";
            else if (title === "canonicalUrl")
                this.errors.canonicalUrl = "";
            else if (title === "metaTitle")
                this.errors.metaTitle = "";
            else if (title === "metaDescription")
                this.errors.metaDescription = "";
            else if (title === "description")
                this.errors.description = "";
        },
        save: function () {
            if (this.input.packageTitle === "") {
                this.errors.packageTitle = 'error';
                return false;
            } else if (this.input.parentId === "") {
                this.errors.parentId = 'error';
                return false;
            } else if (this.input.parentId == 20 && this.input.flight.departCode == "") {
                this.errors.flight.departCode = 'error';
                return false;
            } else if (this.input.parentId == 20 && this.input.flight.arrCode == "") {
                this.errors.flight.arrCode = 'error';
                return false;
            } else if (this.input.sequence === "") {
                this.errors.sequence = 'error';
                return false;
            } else if (this.input.status === "") {
                this.errors.status = 'error';
                return false;
            } else if (this.input.urlLink === "") {
                this.errors.urlLink = 'error';
                return false;
            } else if (this.input.type === "") {
                this.errors.type = 'error';
                return false;
            } else if (this.input.currencyType === "") {
                this.errors.currencyType = 'error';
                return false;
            } else if (this.input.price === "") {
                this.errors.price = 'error';
                return false;
            } else if (this.input.showOnHome === "") {
                this.errors.showOnHome = 'error';
                return false;
            } else if (this.input.canonicalUrl === "") {
                this.errors.canonicalUrl = 'error';
                return false;
            } else if (this.input.metaTitle === "") {
                this.errors.metaTitle = 'error';
                return false;
            } else if (this.input.metaDescription === "") {
                this.errors.metaDescription = 'error';
                return false;
            } else if (this.input.description === "") {
                this.errors.description = 'error';
                return false;
            } else {
                this.$inertia.post('add-new-page', { 'formData': this.input }, {
                    onSuccess: (response) => {
                        console.log(response, "data inserted successfully.");
                        this.$toast.success(this.input.packageTitle + ' is added successfully!');
                        this.reset();
                    }
                });
            }
        },
        reset: function () {
            Object.assign(this.$data, this.$options.data());
        }
    }
}
</script>