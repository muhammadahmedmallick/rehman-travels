<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import DangerButton from '@/Components/DangerButton.vue';
import SuccessButton from '@/Components/SuccessButton.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import Modal from '@/Components/Modal.vue';
import SecondaryButton from '@/Components/SecondaryButton.vue';
import Dropdown from '@/Components/Dropdown.vue';
import TextInput from '@/Components/TextInput.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
</script>
<template>
    <AuthenticatedLayout>
        <div class="mx-auto justify-center items-center w-[90%]">
            <div class="w-full overflow-x-auto shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] border-2 mt-4 md:overflow-hidden rounded-lg mb-2">
                <table class="table-auto w-full text-sm text-left rtl:text-right text-gray-500">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr class="text-center">
                            <th scope="col" class="p-3">Name</th>
                            <th scope="col" class="p-3">Email</th>
                            <th scope="col" class="p-3">Contact No</th>
                            <th scope="col" class="p-3">Hotels</th>
                            <th scope="col" class="p-3">Create Date</th>
                            <th scope="col" class="p-3">Check In</th>
                            <th scope="col" class="p-3">Receivable</th>
                            <th scope="col" class="p-3">Created By</th>
                            <th scope="col" class="p-3">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="$page.props.umrahUBC == ''" class="odd:bg-white even:bg-slate-50 border-b">
                            <td scope="row" class="px-6 py-4 whitespace-nowrap col-span-12" colSpan={6}> No Data Found</td>
                        </tr>
                        <tr v-else class="border-b odd:bg-white text-center even:bg-slate-50"
                            v-for="(umrahUBC, umrahUBCkey) in $page.props.umrahUBCs" :key="umrahUBCkey">
                            <td scope="row" class="px-6 py-4 text-xs"> {{ umrahUBC.ubcDetails.fullName }}</td>
                            <td scope="row" class="px-6 py-4 text-xs"> {{ umrahUBC.ubcDetails.email }}</td>
                            <td scope="row" class="px-6 py-4 text-xs"> <a :href="'tel:' + umrahUBC.ubcDetails.mobileNo">{{ umrahUBC.ubcDetails.mobileNo }}</a></td>
                            <td scope="row" class="px-6 py-4 text-xs whitespace-nowrap">
                                <span v-for="(hotel, hotelKey) in umrahUBC.ubcDetails.hotels" :key="hotelKey">
                                    <span v-for="(hotelDetails, hotelDetailsKey) in hotel" :key="hotelDetailsKey"><b>{{ hotelDetails.hotelType }}</b><i
                                            class="fa fa-star text-yellow-500"></i>&nbsp;</span>
                                </span>
                            </td>
                            <td scope="row" class="px-6 py-4 text-xs whitespace-nowrap"> {{ umrahUBC.ubcDetails.created_at }}</td>
                            <td scope="row" class="px-6 py-4 text-xs" v-for="(hotel, hotelKey) in umrahUBC.ubcDetails.hotels" :key="hotelKey"> 
                                <span v-if="hotel[0]">
                                    {{ hotel[0].checkIn }}
                                </span>
                            </td>
                            <td scope="row" class="px-6 py-4 text-xs"><b>SR: {{ umrahUBC.ubcDetails.totalPrice }}</b></td>
                            <td scope="row" class="px-6 py-4 text-xs"> {{ umrahUBC.ubcDetails.created_by }}</td>
                            <td scope="row" class="px-6 py-4 text-xs whitespace-nowrap">
                                <a @click="viewUBCDetails(umrahUBC)"><i class="fa fa-eye text-orange-400 cursor-pointer mr-3"></i></a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="overflow-auto bg-white px-5 pt-2">
                <button class="fa fa-close bg-red-500 text-white p-2 rounded flex flex-1 justify-end" @click="closeModal()"></button>
                <div class="w-[100%] mx-auto bg-white">
                    <div id="print">
                        <table class="printable-table" height="auto" width="100%">
                            <thead>
                                <tr>
                                    <th colspan="12" class="border">
                                        <img src="/assets/Umrah/umrah-Ubc-header.webp" />
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="pl-4 pt-4 text-left w-1/2">Quote # : {{ umrahUBCDetails.ubcDetails.UbcNo }}</td>
                                    <td class=" pt-4 text-right pr-4 w-1/2">{{ umrahUBCDetails.ubcDetails.created_at }}
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <table class="mt-4 bg-white printable-table" height="auto" width="100%">
                            <thead
                                class="text-center bg-blue-500 h-10 text-white capitalize border border-1 border-solid border-blue-500">
                                <tr>
                                    <th colspan="12">Umrah Quotation</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="bg-gray-200 font-semibold text-sm">
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Name
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Email
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Mobile No
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">City
                                        Name
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                                        Nationality</th>
                                </tr>
                                <tr class="text-center text-sm py-2">
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ umrahUBCDetails.ubcDetails.fullName }}</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ umrahUBCDetails.ubcDetails.email }}</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap"><a :href="'tel:'+umrahUBCDetails.ubcDetails.mobileNo">{{ umrahUBCDetails.ubcDetails.mobileNo }}</a></td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                                        {{ umrahUBCDetails.ubcDetails.city }}
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                                        {{ umrahUBCDetails.ubcDetails.nationality }}
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <div v-for="(hotel, hotelKey) in umrahUBCDetails.ubcDetails.hotels" :key="hotelKey">
                            <table class="mt-4 bg-white printable-table" height="auto" width="100%" v-for="(hotelDetails, hotelDetailsKey) in hotel" :key="hotelDetailsKey">
                                <thead
                                    class="text-center h-10 capitalize">
                                    <tr  :class="`${hotelDetailsKey % 2 === 0 ? 'bg-red-500' : 'bg-blue-500'} text-white`">
                                        <th colspan="12"> {{ hotelDetails.hotelLocation }} Hotel</th>
                                    </tr>
                                </thead>
                                
                                <tbody>
                                    <tr class="bg-gray-200 font-semibold  text-sm">
                                        <th class="border border-1 border-solid border-gray-300">Hotel Name</th>
                                        <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Type</th>
                                        <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Basis</th>
                                        <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Check In</th>
                                        <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Check Out</th>
                                        <th class="border border-1 border-solid border-gray-300 whitespace-nowrap"> Double</th>
                                        <th class="border border-1 border-solid border-gray-300 whitespace-nowrap"> Triple</th>
                                        <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Quad
                                        </th>
                                        <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Quint
                                        </th>
                                        <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                                            Nights
                                        </th>
                                        <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Price</th>
                                    </tr>
                                    <tr class="text-center text-sm py-2">
                                        <td class="border border-1 border-solid border-gray-300 capitalize">{{ hotelDetails.hotelName }}</td>
                                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ hotelDetails.hotelType }} Stars</td>
                                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ hotelDetails.basisType }}</td>
                                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ hotelDetails.checkIn }}</td>
                                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ hotelDetails.checkOut }}</td>
                                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ hotelDetails.doubleRoom }}</td>
                                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ hotelDetails.tripleRoom }}</td>
                                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ hotelDetails.quadRoom }}</td>
                                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ hotelDetails.quintRoom }}</td>
                                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ hotelDetails.totalNights }}</td>
                                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ hotelDetails.hotelTotalPrice }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <table class="mt-4 bg-white printable-table" height="auto" width="100%">
                            <thead
                                class="text-center bg-blue-500 h-10 text-white capitalize">
                                <tr>
                                    <th>Transport</th>
                                    <th>Umrah Visa Services</th>
                                    <th>Total Nights</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="bg-white text-center text-sm">
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                                        {{ umrahUBCDetails.ubcDetails.umrahVehicle }}</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                                        <p class="inline pr-1">Umrah Visa and Insurance {{ umrahUBCDetails.ubcDetails.visaPriceInclude }} {{ umrahUBCDetails.ubcDetails.totalTravellers }} Persons. </p>
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">{{ umrahUBCDetails.ubcDetails.totalNights }} Nights/ {{ umrahUBCDetails.ubcDetails.totalNights + 1 }} Days</td>
                                </tr>
                            </tbody>
                        </table>
                        <table class="mt-4 bg-white printable-table" height="auto" width="100%">
                            <thead
                                class="text-center bg-red-600 h-10 text-white capitalize">
                                <tr>
                                    <th colspan="12">Sector</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="bg-white text-sm">
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-left pl-3">
                                        {{ umrahUBCDetails.ubcDetails.umrahSector }}</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-center">Grand Total</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap font-semibold text-blue-600">
                                        SR : {{ umrahUBCDetails.ubcDetails.totalPrice }}</td>
                                </tr>
                                <tr class="bg-white text-sm">
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-left pl-3">
                                    All Taxes are included Till Date</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-center">Price Per Person</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap font-semibold text-blue-600">
                                        SR : {{ umrahUBCDetails.ubcDetails.totalPrice /  umrahUBCDetails.ubcDetails.totalTravellers}}                                    
                                    </td>
                                </tr>
                                <tr class="bg-white text-sm">
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-left pl-3">
                                        
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-center">Transport Price</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap font-semibold text-blue-600">
                                        SR : {{ umrahUBCDetails.ubcDetails.umrahVehiclePrice }}                                    
                                    </td>
                                </tr>
                                <tr class="bg-white text-sm">
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-left pl-3">
                                        
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-center">Visa Price</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap font-semibold text-blue-600">
                                        SR : {{ umrahUBCDetails.ubcDetails.visaPrice }}                                    
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <table class="mt-4 bg-white" height="auto" width="100%">
                            <thead class="text-center  h-10 text-white capitalize ">
                                <tr>
                                    <th class="bg-blue-500">Requirements
                                    </th>
                                    <th class="bg-red-600">Note</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="text-sm">
                                    <td class="border border-1 border-solid  border-gray-300  text-left pl-3">
                                        <ul class="list-disc pl-4">
                                            <li>Passport valid for 8 months</li>
                                            <li>Copy of C.N.I.C/ POC</li>
                                            <li>1 passport-size photograph with Blue background</li>
                                        </ul>
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 text-left pl-3">
                                        <ul class="list-disc pl-4">
                                            <li>This Quotation is valid for 2 days Only. </li>
                                            <li>No booking(s) made yet.</li>
                                            <li><mark>Availability and rates are subject to change at the time of confirmation </mark></li>
                                            <li>For Makkah and Madinah standard check-in time is 5 PM and check-out time is 12 NOON.</li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <table class="mt-2" height="auto" width="100%">
                            <thead>
                                <tr>
                                    <th colspan="12" class="border">
                                        <img src="/assets/Umrah/umrah-Ubc-footer.webp" class="" />
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-1 justify-end sm:px-6" id="UmrahUbcClosebtn">
                <button @click="printModal()" type="button"
                    class="mt-3 inline-flex w-full justify-center rounded-md bg-[#006ee3] px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset  sm:mt-0 sm:w-auto mr-3">Print</button>
                <button @click="closeModal()" type="button"
                    class="mt-3 inline-flex w-full justify-center rounded-md bg-[#006ee3] px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset  sm:mt-0 sm:w-auto">Close</button>
            </div>
        </Modal>
    </AuthenticatedLayout>
</template>

<script>
export default {
    name: "UmrahVisa",
    data() {
        return {
            modalWidth: "sm:w-[100%] md:w-[65%]",
            viewType: "",
            isModalVisible: false,
            search: '',
            umrahUBCDetails: ''
        }
    },
    computed: {
        filterUmrahVisa() {
            return this.$page.props.umrahUBC.filter(item => {
                return item.umrahVisaName.toLowerCase().indexOf(this.search.toLowerCase()) > -1;
            });
        }
    },
    methods: {
        closeModal: function () {
            this.isModalVisible = false;
        },
        viewUBCDetails: function (ubcDetail) {
            this.isModalVisible = true;
            this.viewType = "edit";
            this.umrahUBCDetails = ubcDetail;
            console.log(this.umrahUBCDetails);
        },
        openModel: function () {
            this.reset();
            this.isModalVisible = true;
            this.viewType = "add";
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
            window.location.href = '/UmrahDashboard/umrah-ubc';
        },
    }
}
</script>