<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import DangerButton from '@/Components/DangerButton.vue';
import SuccessButton from '@/Components/SuccessButton.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import Dropdown from '@/Components/Dropdown.vue';
import TextInput from '@/Components/TextInput.vue';
import Modal from '@/Components/Modal.vue';
import SecondaryButton from '@/Components/SecondaryButton.vue';
import {Head, Link, useForm} from '@inertiajs/vue3';
</script>
<template>
    <AuthenticatedLayout>

        <div class="mx-auto justify-center items-center w-[90%] lg:w-[80%]">
            <div class="flex justify-between m-3 items-center">
                <div class="justify-start">
                    <form @submit.prevent class="flex gap-6 items-center" v-if="inputHotelMarkup.hotel.selectedHotelIds != ''">
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Markup Type</label>
                            <select v-model="inputHotelMarkup.markupInput.markup_type" class="border border-gray-300 text-gray-900 rounded-lg focus:shadow-[0_0_0_.25rem_rgba(10,173,10,.25)] focus:ring-green-600 focus:ring-0 focus:border-green-600 block p-2 px-3 disabled:opacity-50 disabled:pointer-events-none w-full text-base mt-2">
                                <option value="percentage">Percentage</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Markup Value</label>
                            <input type="number" v-model="inputHotelMarkup.markupInput.markup_value" class="w-full border border-gray-300 text-gray-900 rounded-lg focus:shadow-[0_0_0_.25rem_rgba(10,173,10,.25)] focus:ring-green-600 focus:ring-0 focus:border-green-600 block p-2 px-3 disabled:opacity-50 disabled:pointer-events-none text-base mt-2" />
                        </div>
                        <div class="mt-7 items-center">
                            <button type="submit" @click="updateSelectedHotelMarkup"
                                class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition">Submit</button>
                        </div>
                        <div v-if="proceed"
                            class="absolute -translate-x-1/2 -translate-y-1/2 top-2/4 left-1/2 z-50">
                            <svg aria-hidden="true" class="w-16 h-16 text-gray-200 animate-spin fill-blue-600"
                                viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path
                                    d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
                                    fill="currentColor" />
                                <path
                                    d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
                                    fill="currentFill" />
                            </svg>
                            <span class="sr-only">Loading...</span>
                        </div>
                    </form>
                </div>
                <div class="justify-end items-center">
                    <input type="text" v-model="search" placeholder="Search" class="border border-gray-300 text-gray-900 rounded-lg focus:shadow-[0_0_0_.25rem_rgba(10,173,10,.25)] focus:ring-green-600 focus:ring-0 focus:border-green-600 placeholder:text-base placeholder:text-gray-400 mr-3">
                    <a v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'" v-on:click="openModel()" class="bg-bgRGTBaseColor text-white p-2 rounded-md cursor-pointer"><i
                    class="fa fa-plus"></i> &nbsp; Add New Hotel </a>
                </div>
            </div>
            <div class="w-full overflow-x-auto shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] border-2 mt-4 md:overflow-hidden rounded-lg mb-2">
                <table class="w-full text-sm text-left rtl:text-right text-gray-500">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                    <tr>
                        <th scope="col" class="px-6 py-3 whitespace-nowrap">
                            <input 
                                type="checkbox" 
                                class="border border-gray-400 rounded-md focus:border-white" 
                                :checked="selectAll"
                                @change="toggleAll"
                            />
                        </th>
                        <th scope="col" class="px-6 py-3 whitespace-nowrap">Hotel Name</th>
                        <th scope="col" class="px-6 py-3 whitespace-nowrap">Hotel Location</th>
                        <th scope="col" class="px-6 py-3 whitespace-nowrap">Basis Type</th>
                        <th scope="col" class="px-6 py-3 whitespace-nowrap">Hotel Type</th>
                        <th scope="col" class="px-6 py-3 whitespace-nowrap">Hotel Status</th>
                        <th scope="col" class="px-6 py-3 whitespace-nowrap">Created/Updated</th>
                        <th scope="col" class="px-6 py-3 whitespace-nowrap">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-if="filterHotels == ''" class="odd:bg-white even:bg-slate-50 border-b col-span-12">
                        <td scope="row"
                            class="px-6 py-4 whitespace-nowrap"
                            colSpan={6}> No Data Found</td>
                    </tr>
                    <tr v-else class="odd:bg-white even:bg-slate-100 border-b-2" v-for="(hotel, hotelKey) in filterHotels" :key="hotelKey">
                        <td scope="row" class="px-6 py-4 text-gray-600 text-xs w-10">
                            <input 
                                type="checkbox" :id="hotelKey"
                                :checked="inputHotelMarkup.hotel.selectedHotelIds.includes(hotel.hotelDetail.hotel['id'])"
                                @change="toggleHotelSelection(hotel.hotelDetail.hotel['id'])"
                                class="border border-gray-400 rounded-md" 
                            />
                        </td>
                        <td scope="row" class="px-6 py-4 text-gray-600 text-xs w-72">
                            {{ hotel.hotelDetail.hotel['hotelName'] }}
                        </td>
                        <td scope="row" class="px-6 py-4 text-xs text-gray-600 w-20">
                            {{ hotel.hotelDetail.hotel['hotelLocation'] }}
                        </td>
                        <td scope="row" class="px-6 py-4 text-xs text-gray-600 w-20">
                            {{ hotel.hotelDetail.hotel['basisType'] }}
                        </td>
                        <td scope="row" class="px-6 py-4 text-xs text-gray-600">
                            {{ (hotel.hotelDetail.hotel['hotelType'] == 'economy' || hotel.hotelDetail.hotel['hotelType'] == 'economy-plus' ? hotel.hotelDetail.hotel['hotelType'] : hotel.hotelDetail.hotel['hotelType'] + " Stars") }}
                        </td>
                        <td scope="row" class="px-6 py-4 text-xs text-gray-600">
                            {{ (hotel.hotelDetail.hotel['hotelStatus'] == 1 ? 'Active' : 'De-active') }}
                        </td>
                        <td scope="row" class="px-6 py-4 text-xs text-gray-600 font-medium">
                            Created At: {{ hotel.hotelDetail.hotel['created_at'] }} <br />
                            Updated At: {{ hotel.hotelDetail.hotel['updated_at'] }} <br />
                            Created By: {{ hotel.hotelDetail.hotel['created_user'] }}
                        </td>
                        <td scope="row" class="px-6 py-4 text-xs text-gray-900">
                            <a  v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'"
                            v-on:click="edit(hotel, 'edit')">
                            <i class="fa fa-pen-to-square text-green-400 cursor-pointer mr-3"></i></a>
                            <a v-on:click="edit(hotel, 'view')"><i class="fa fa-eye text-orange-400 cursor-pointer mr-3"></i></a>
                            <a v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'owner'"
                            v-on:click='removeRow(filterHotels[hotelKey].hotelDetail.hotel.id)'>
                            <i class="fa fa-trash text-red-600 cursor-pointer"></i></a>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <form ref="hotelMarkupForm" method="POST">
                <input type="hidden" name="selectedHotelIds" :value="inputHotelMarkup.hotel.selectedHotelIds.join(',')" />
            </form>
            <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
                <div class="flex flex-1 mb-2 mr-4 justify-end">
                    <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer" v-on:click="closeModal()"></i>
                </div>
                <form v-on:submit.prevent="submit">
                    <div class="justify-center px-5">
                        <TextInput type="hidden" v-model="input.hotel.id"></TextInput>
                        <TextInput type="hidden" v-model="viewType"></TextInput>
                        <fieldset class="border p-1">
                            <legend class="text-md float-none px-3 w-[13%]">Hotel Details</legend>
                            <div class="flex flex-wrap md:mb-4 gap-1">
                                <div class="w-full sm:w-1/2 md:w-[23%] lg:w-[20%]">
                                    <InputLabel for="hotelName" value="Hotel Name"></InputLabel>
                                    <TextInput id="hotelName" ref="hotelNameInput" type="text" class="mt-1 w-full capitalize" placeholder="Hotel Name" v-model="input.hotel.hotelName"></TextInput>
                                    <InputError class="mt-2"></InputError>
                                </div>
                                <div class="w-full sm:w-1/2 md:w-[23%] lg:w-[11%]">
                                    <InputLabel for="hotelLocation" value="Location"></InputLabel>
                                    <Dropdown
                                        class="mt-1 w-full">
                                        <template #trigger>
                                            <select
                                                id="hotelLocation"
                                                v-model="input.hotel.hotelLocation"
                                                class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                <option value="Makkah">Makkah</option>
                                                <option value="Madinah">Madinah</option>
                                                <option value="Jeddah">Jeddah</option>
                                            </select>
                                        </template>
                                    </Dropdown>
                                    <InputError class="mt-2"></InputError>
                                </div>
                                <div class="w-full sm:w-1/2 md:w-[23%] lg:w-[11%]">
                                    <InputLabel for="hotelType" value="Hotel Type"></InputLabel>
                                    <Dropdown
                                        class="mt-1 w-full">
                                        <template #trigger>
                                            <select
                                                id="hotelType"
                                                v-model="input.hotel.hotelType"
                                                class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                <option value="5">5 Stars</option>
                                                <option value="4">4 Stars</option>
                                                <option value="3">3 Stars</option>
                                                <option value="2">2 Stars</option>
                                                <option value="1">1 Stars</option>
                                                <option value="economy">Economy</option>
                                                <option value="economy-plus">Economy Plus</option>
                                            </select>
                                        </template>
                                    </Dropdown>
                                    <InputError class="mt-2"></InputError>
                                </div>
                                <div class="w-full sm:w-1/2 md:w-[23%] lg:w-[10%]">
                                    <InputLabel for="basis" value="Basis"></InputLabel>
                                    <Dropdown
                                        class="mt-1 w-full">
                                        <template #trigger>
                                            <select
                                                id="basisType"
                                                v-model="input.hotel.basisType"
                                                class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                <option value="RO">RO</option>
                                                <option value="BB">BB</option>
                                                <option value="HB">HB</option>
                                                <option value="FB">FB</option>
                                            </select>
                                        </template>
                                    </Dropdown>
                                    <InputError class="mt-2"></InputError>
                                </div>
                                <div class="w-full sm:w-1/2 md:w-[23%] lg:w-[12%]">
                                    <InputLabel for="hotelDistance" value="Hotel Distance"></InputLabel>
                                    <TextInput type="text" class="mt-1 w-full" placeholder="Hotel Distance" v-model="input.hotel.hotelDistance"></TextInput>
                                    <InputError class="mt-2"></InputError>
                                </div>
                                <div class="w-full sm:w-1/2 md:w-[23%] lg:w-[7%]">
                                    <InputLabel for="markup" value="Mark Up"></InputLabel>
                                    <TextInput type="text" class="mt-1 md:w-full" placeholder="Mark Up" v-model="input.hotel.markup"></TextInput>
                                    <InputError class="mt-2"></InputError>
                                </div>
                                <div class="w-full sm:w-1/2 md:w-[23%] lg:w-[15%]">
                                    <InputLabel for="vendor" value="Vendor"></InputLabel>
                                    <TextInput type="text" class="mt-1 w-full" placeholder="Vendor Name" v-model="input.hotel.vendorName"></TextInput>
                                    <InputError class="mt-2"></InputError>
                                </div>
                                <div class="w-full sm:w-1/2 md:w-[23%] lg:w-[10%]">
                                    <InputLabel for="hotelStatus" value="Status"></InputLabel>
                                    <Dropdown
                                        class="mt-1 w-full">
                                        <template #trigger>
                                            <select
                                                v-model="input.hotel.hotelStatus"
                                                class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                <option value="1">Active</option>
                                                <option value="0">De-Active</option>
                                            </select>
                                        </template>
                                    </Dropdown>
                                    <InputError class="mt-2"></InputError>
                                </div>
                            </div>
                        </fieldset>
                        <fieldset class="border p-1 mt-4">
                            <legend class="text-md float-none px-3 w-[15%]">Hotel Images</legend>
                            <div class="md:mb-4 flex flex-wrap gap-2">
                                <div v-for="(hotelRoom, hotelRoomIndex) in input.hotelRoomImages"
                                     :key="hotelRoomIndex"
                                     class="w-full sm:w-1/2 md:w-[23%] lg:w-[18%] p-3 border border-gray-500 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm">
                                     <label for="hotelName">{{ hotelRoom.hotelRoomType }} Photo</label> <br class="sm:block hidden" />
                                    <TextInput type="file" v-model="hotelRoom.hotelImage" :onChange="(e)=>{e.target.files[0].name}" class="mr-3 mt-3 w-[190px] h-[112]" placeholder="Hotel Photo"
                                    ></TextInput>
                                    <img v-if="hotelRoom.viewHotelimg != ''"
                                         class="mr-3 mt-3 w-[263px] h-[193px]"
                                         placeholder="Hotel Photo"
                                         :src="hotelRoom.viewHotelimg"
                                    />
                                    <InputError class="mt-2"></InputError>
                                </div>
                            </div>
                        </fieldset>
                        <fieldset class="border p-1 mt-4">
                            <legend class="text-md float-none px-3 sm:w-[13%]">Room Types</legend>
                            <div v-for="(hotelPeriodAndRoomTypePrice, hotelPeriodAndRoomTypePriceKey) in input.hotelPeriodAndRoomTypePrices"
                                 :key="hotelPeriodAndRoomTypePriceKey" class="md:flex md:flex-1 justify-center md:mb-4">
                                <div v-for="(periodAndRoomTypePrice, periodAndRoomTypePriceKey) in hotelPeriodAndRoomTypePrice" class="sm:col-span-12 md:col-span-6 lg:col-span-4 md:flex">
                                    <div v-if="periodAndRoomTypePriceKey == 'Period'" class="sm:col-span-12 md:col-span-6 lg:col-span-4">
                                        <div class="sm:col-span-12 md:col-span-4 lg:col-span-4 mr-3 mt-3">
                                            <InputLabel for="periodFrom" value="Period From"></InputLabel> <br class="sm:block hidden" />
                                            <input type="date" v-model="periodAndRoomTypePrice.periodFrom"
                                            required="required" autocomplete="off" class="w-full font-semibold lg:text-[14px] focus:outline-none border border-gray-300 rounded-md p-2 focus:ring-0" />
                                            <InputError class="mt-2"></InputError>
                                        </div>
                                        <div class="sm:col-span-12 md:col-span-4 lg:col-span-4 mr-3 mt-3">
                                            <InputLabel for="periodTo" value="Period To"></InputLabel> <br class="sm:block hidden" />
                                            <input type="date" v-model="periodAndRoomTypePrice.periodTo"
                                            required="required" autocomplete="off" class="w-full font-semibold lg:text-[14px] focus:outline-none border border-gray-300 rounded-md p-2 focus:ring-0" />
                                            <InputError class="mt-2"></InputError>
                                        </div>
                                        <div class="mt-3 mr-3">
                                            <InputLabel for="ashraType" value="Is Ashra?"></InputLabel>
                                            <label class="ml-1 mr-2"></label>
                                            <Dropdown
                                                class="w-[100px]" width="48">
                                                <template #trigger>
                                                    <select
                                                        id="ashraType"
                                                        v-model="periodAndRoomTypePrice.ashraType"
                                                        class="border-gray-300 text-xs focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                        <option value="0">No</option>
                                                        <option value="1">Yes</option>
                                                    </select>
                                                </template>
                                            </Dropdown>
                                        </div>
                                        <div class="mt-3 mr-3">
                                            <InputLabel for="ashraType" value="Period Status?"></InputLabel>
                                            <label class="ml-1 mr-2"></label>
                                            <Dropdown
                                                class="w-[100px]" width="48">
                                                <template #trigger>
                                                    <select
                                                        id="ashraType"
                                                        v-model="periodAndRoomTypePrice.periodStatus"
                                                        class="border-gray-300 text-xs focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                        <option value="1">Active</option>
                                                        <option value="0">Deactive</option>
                                                    </select>
                                                </template>
                                            </Dropdown>
                                        </div>
                                    </div>
                                    <div v-else class="sm:col-span-12 md:col-span-6 md:flex md:flex-1">
                                        <div  class="sm:col-span-12 md:col-span-4 md:mx-1 mt-3 border border-gray-500 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm sm:w-[230px] h-[250px]">
                                            <div class="row sm:col-span-12 md:col-span-12 px-2">
                                                <p class="font-semibold  text-black justify-center">{{ periodAndRoomTypePrice.roomType }} Room</p> <br class="sm:flex hidden" />
                                                <div class="flex flex-1 mt-3">
                                                    <div class="flex-col">
                                                        <label class="ml-1 mr-2 text-xs">Actual</label>
                                                        <TextInput
                                                            type="text"
                                                            class="w-[100px] onDayPrice text-xs"
                                                            placeholder="Actual"
                                                            v-on:keyup="updateDayPercentage(hotelPeriodAndRoomTypePriceKey, periodAndRoomTypePrice.roomType, periodAndRoomTypePrice.onDayPrice, 'actual')"
                                                            v-model="periodAndRoomTypePrice.onDayPrice"
                                                        ></TextInput>
                                                    </div>
                                                    <div class="flex-col">
                                                        <label class="ml-1 mr-2 text-xs">With %</label>
                                                        <TextInput
                                                            type="text"
                                                            class="w-[100px] text-xs"
                                                            placeholder="With %"
                                                            readonly
                                                            v-model="periodAndRoomTypePrice.onDayMarkup"
                                                        ></TextInput>
                                                    </div>
                                                </div>
                                                <div class="flex flex-1 mt-3">
                                                    <div class="flex-col">
                                                        <label class="ml-1 mr-2 text-xs">Weekend</label>
                                                        <TextInput
                                                            type="text"
                                                            class="w-[100px] offDayPrice text-xs"
                                                            placeholder="Weekend"
                                                            v-on:keyup="updateDayPercentage(hotelPeriodAndRoomTypePriceKey, periodAndRoomTypePrice.roomType, periodAndRoomTypePrice.offDayPrice, 'weekend')"
                                                            v-model="periodAndRoomTypePrice.offDayPrice"
                                                        ></TextInput>
                                                    </div>
                                                    <div class="md:flex-col">
                                                        <label class="ml-1 mr-2 text-xs">Weekend %</label>
                                                        <TextInput
                                                            type="text"
                                                            class="w-[100px] text-xs"
                                                            placeholder="Weekend %"
                                                            readonly
                                                            v-model="periodAndRoomTypePrice.offDayMarkup"
                                                        ></TextInput>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <div class="mt-3" v-if="hotelPeriodAndRoomTypePriceKey == input.hotelPeriodAndRoomTypePrices.length - 1 && viewType != 'view'">
                                        <DangerButton class="mr-2"  v-if="hotelPeriodAndRoomTypePriceKey > 0 && viewType != 'view'" v-on:click="removeHotelPeriodAndRoomTypePrice(hotelPeriodAndRoomTypePriceKey)"> X</DangerButton>
                                        <SuccessButton v-on:click="cloneHotelPeriodAndRoomTypePrice()"> +
                                        </SuccessButton>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                        <!-- TextArea -->
                        <div class="sm:col-span-12 md:col-span-6 lg:col-span-4 mt-3">
                            <InputLabel for="description" value="Description"></InputLabel>
                            <textarea row="10" v-model="input.hotel.hotelDesc"
                            class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500"
                            placeholder="Write your thoughts here...">
                            </textarea>
                        </div>
                        <div v-if="!submit" class="mt-6 flex justify-end mb-3">
                            <SuccessButton
                                class="mr-3"
                                v-on:click="save()"
                                v-if="viewType == 'edit'"
                            >
                                Update Hotel
                            </SuccessButton>
                            <SuccessButton
                                class="mr-3"
                                v-on:click="save()"
                                v-if="viewType == 'add'"
                            >
                                Create Hotel
                            </SuccessButton>
                            <SecondaryButton v-on:click="closeModal()"> Cancel</SecondaryButton>
                        </div>
                        <div v-else class="mt-6 flex justify-end mb-3">
                            <SuccessButton class="mr-3 cursor-wait"> 
                                Processing...
                            </SuccessButton>
                        </div>
                    </div>
                </form>
            </Modal>
        </div>
    </AuthenticatedLayout>
</template>

<script>
import moment from 'moment';
import Service from "@/Config/Service.js";
export default {
    name: "Hotel",
    data() {
        return {
            modalWidth : "sm:w-[100%] md:w-[90%]",
            viewType: 'add',
            isModalVisible: false,
            tillDateHidden : '',
            search: '',
            submit: false,
            selectAll: false,
            proceed: false,
            inputHotelMarkup: {
                markupInput:{
                    markup_type : 'percentage',
                    markup_value : '',
                    markup_status : '1',
                    vendor: 'umrah-Hotel',
                    created_by : '',
                },
                hotel:{
                    selectedHotelIds: []
                }
            },
            input: {
                deleteHotelRoom:[],
                hotel: {
                    id: '',
                    hotelName: '',
                    vendorName: '',
                    hotelLocation: '',
                    hotelDistance: '',
                    basisType: '',
                    hotelType: '',
                    hotelDesc: '',
                    markup: '',
                    hotelStatus: '1',
                    postById : '',
                    updated_by: ''
                },
                hotelRoomImages: {
                    Hotel: {
                        id: '',
                        hotelImage: '',
                        viewHotelimg: '',
                        hotelRoomType: 'Hotel',
                        hotelRoomImageStatus: 1
                    },
                    Double: {
                        id: '',
                        hotelImage: '',
                        viewHotelimg: '',
                        hotelRoomType: 'Double',
                        hotelRoomImageStatus: 1
                    },
                    Triple: {
                        id: '',
                        hotelImage: '',
                        viewHotelimg: '',
                        hotelRoomType: 'Triple',
                        hotelRoomImageStatus: 1
                    },
                    Quad: {
                        id: '',
                        hotelImage: '',
                        viewHotelimg: '',
                        hotelRoomType: 'Quad',
                        hotelRoomImageStatus: 1
                    },
                    Quint: {
                        id: '',
                        hotelImage: '',
                        viewHotelimg: '',
                        hotelRoomType: 'Quint',
                        hotelRoomImageStatus: 1
                    },
                },
                hotelPeriodAndRoomTypePrices: [{
                    Period: {
                        id: '',
                        hotelId: '',
                        periodFrom: '',
                        periodTo: '',
                        ashraType: '0',
                        periodStatus: '1'
                    },
                    Double: {
                        id: '',
                        periodId: '',
                        roomType: 'Double',
                        onDayPrice: 0,
                        onDayMarkup:0,
                        offDayPrice: 0,
                        offDayMarkup:0
                    },
                    Triple: {
                        id: '',
                        periodId: '',
                        roomType: 'Triple',
                        onDayPrice: 0,
                        onDayMarkup:0,
                        offDayPrice: 0,
                        offDayMarkup:0
                    },
                    Quad: {
                        id: '',
                        periodId: '',
                        roomType: 'Quad',
                        onDayPrice: 0,
                        onDayMarkup:0,
                        offDayPrice: 0,
                        offDayMarkup:0
                    },
                    Quint: {
                        id: '',
                        periodId: '',
                        roomType: 'Quint',
                        onDayPrice: 0,
                        onDayMarkup:0,
                        offDayPrice: 0,
                        offDayMarkup:0
                    },
                }]
            }
        }
    },
    computed: {
        filterHotels(){
            return this.$page.props.hotels.filter(item =>{
                return item.hotelDetail.hotel.hotelName.toLowerCase().indexOf(this.search.toLowerCase()) > -1;
            });
        }
    }, 
    methods: {
        toggleHotelSelection(hotelId) {
            const index = this.inputHotelMarkup.hotel.selectedHotelIds.indexOf(hotelId);
            if (index === -1) {
                this.inputHotelMarkup.hotel.selectedHotelIds.push(hotelId);
                this.selectAll = this.inputHotelMarkup.hotel.selectedHotelIds.length === this.$page.props.hotels.length;
            } else {
                this.inputHotelMarkup.hotel.selectedHotelIds.splice(index, 1);
            }
        },
        
        toggleAll() {
            if (this.selectAll) {
            this.inputHotelMarkup.hotel.selectedHotelIds = [];
            } else {
            this.inputHotelMarkup.hotel.selectedHotelIds = this.$page.props.hotels.map(hotel => hotel.hotelDetail.hotel.id);
            }
            this.selectAll = !this.selectAll;
        },
        outinboundDateDetail(dateDetail){
            this.input.hotelPeriodAndRoomTypePrices[dateDetail.initialIndex].Period.periodFrom = dateDetail.initialDate.start;
            this.input.hotelPeriodAndRoomTypePrices[dateDetail.initialIndex].Period.periodTo = dateDetail.initialDate.end;
            this.tillDateHidden = dateDetail.initialDate.end;
        },
        travellingEndDate(dateDetail){
            this.tillDateHidden = dateDetail.initialDate.start;
        },
        edit: function (hotelDetails, showType) {
            this.reset();
            this.isModalVisible = true;
            if(showType == "edit"){
                this.viewType = 'edit';
            }else{
                this.viewType = 'view';
            }
            this.input.hotel = hotelDetails.hotelDetail.hotel;
            let hotelRoomPeriodPrices = hotelDetails.hotelDetail.hotelRoomPeriodPrices;
            let hotelImages = hotelDetails.hotelDetail.hotelImages;
            for(let hotelRoomPeriodPricesIndex in hotelRoomPeriodPrices){
                this.input.hotelPeriodAndRoomTypePrices[hotelRoomPeriodPricesIndex] = hotelRoomPeriodPrices[hotelRoomPeriodPricesIndex]; 
            }
            for(let hotelIndex in hotelImages){
                let roomType = hotelImages[hotelIndex].hotelRoomType;
                this.input.hotelRoomImages[roomType].id = hotelImages[hotelIndex].id; 
                this.input.hotelRoomImages[roomType].viewHotelimg = hotelImages[hotelIndex].viewHotelimg; 
                this.input.hotelRoomImages[roomType].hotelRoomType = hotelImages[hotelIndex].hotelRoomType; 
                this.input.hotelRoomImages[roomType].hotelRoomImageStatus = hotelImages[hotelIndex].hotelRoomImageStatus; 
            }
        },
        closeModal: function () {
            this.isModalVisible = false;
            this.reset();
        },
        openModel: function () {
            this.reset();
            this.isModalVisible = true;
            this.viewType = 'add';
        },
        cloneHotelPeriodAndRoomTypePrice: function () {
            this.input.hotelPeriodAndRoomTypePrices.push({
                Period: {
                    id: '',
                    hotelId: '',
                    periodFrom: '',
                    periodTo: '',
                    ashraType: '0',
                    periodStatus: '1'
                },
                Double: {
                    id : '',
                    periodId : '',
                    roomType: 'Double',
                    onDayPrice: 0,
                    onDayMarkup:0,
                    offDayPrice: 0,
                    offDayMarkup:0
                },
                Triple: {
                    id : '',
                    periodId : '',
                    roomType: 'Triple',
                    onDayPrice: 0,
                    onDayMarkup:0,
                    offDayPrice: 0,
                    offDayMarkup:0
                },
                Quad: {
                    id : '',
                    periodId : '',
                    roomType: 'Quad',
                    onDayPrice: 0,
                    onDayMarkup:0,
                    offDayPrice: 0,
                    offDayMarkup:0
                },
                Quint: {
                    id : '',
                    periodId : '',
                    roomType: 'Quint',
                    onDayPrice: 0,
                    onDayMarkup:0,
                    offDayPrice: 0,
                    offDayMarkup:0
                }
            });
        },
        removeHotelPeriodAndRoomTypePrice: function (index) {
            this.input.hotelPeriodAndRoomTypePrices[index].Period.periodStatus = '0';
            this.input.deleteHotelRoom.push(this.input.hotelPeriodAndRoomTypePrices[index]);
            this.input.hotelPeriodAndRoomTypePrices.splice(index, 1);
        },
        removeRow: function (id) {
            if(confirm("Are you sure you want to Delete")){
                this.$inertia.delete('delete/'+id,{
                    onSuccess: (response) => {
                        console.log(response);
                    },
                    onFinish: () => {
                        console.log('successed');
                    }
                });
            }
        },
        reset: function () {
            Object.assign(this.$data.input, this.$options.data().input);
            this.viewType = "add";
        },
        updateDayPercentage: function (roomIndex, room, value, checkweekend){
            const roomMarkupPrice = 0;
            let markup = this.input.hotel.markup;
            if(checkweekend == "weekend"){
                if(this.input.hotel.markup != ""){
                    const roomMarkup = Math.round((markup * value) / 100);
                    const roomMarkupPrice = parseInt(value) + parseInt(roomMarkup);
                    this.input.hotelPeriodAndRoomTypePrices[roomIndex][room].offDayMarkup = roomMarkupPrice;
                }else{
                    this.input.hotelPeriodAndRoomTypePrices[roomIndex][room].offDayMarkup = value;
                }
            }else{
                if(this.input.hotel.markup != ""){
                    const roomMarkup = Math.round((markup * value) / 100);
                    const roomMarkupPrice = parseInt(value) + parseInt(roomMarkup);
                    this.input.hotelPeriodAndRoomTypePrices[roomIndex][room].onDayMarkup = roomMarkupPrice;
                }else{
                    this.input.hotelPeriodAndRoomTypePrices[roomIndex][room].onDayMarkup = value;
                }
            }
        },
        save: function () {
            if(this.input.hotel.id == "" && this.viewType == "add"){
                this.input.hotel.postById = this.$page.props.auth.user.id;
                this.submit = true;
                this.$inertia.post('create', {'hotelDetails' : this.input},{
                    onSuccess: (response) => {
                        this.submit = false;
                        this.isModalVisible = false;
                        this.$toast.success(this.input.hotel.hotelName + " is Inserted Successfully!");
                    }
                });
            }else{
                this.submit = true;
                this.input.hotel.updated_by = this.$page.props.auth.user.id;
                this.$inertia.put('update', {'hotelDetails' : this.input},{
                    onSuccess: (response) => {
                        this.submit = false;
                        this.isModalVisible = false;
                        this.$toast.success(this.input.hotel.hotelName + " is Updated Successfully!");
                    }
                });
            }
        },
        updateSelectedHotelMarkup(){
            if (!this.inputHotelMarkup.hotel.selectedHotelIds.length) {
                alert("Please select at least one checkbox.");
                return;
            }

            this.proceed = true;
            this.inputHotelMarkup.markupInput.created_by = this.$page.props.auth.user.id;
            Service.doRequest("/UmrahDashboard/add-selected-hotels-markup", 'POST', this.inputHotelMarkup)
            .then((data) => {
                if(!data.error){
                    this.$toast.success(data.message);
                    window.location.href= 'view-all-umrah-hotels';
                }else{
                    this.$toast.error(data.message);
                }
                this.proceed = false;
            });
        }
    }
}
</script>