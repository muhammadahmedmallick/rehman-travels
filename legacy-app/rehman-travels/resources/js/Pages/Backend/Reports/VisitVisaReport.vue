<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import LoadingBar from "@/Pages/Website/Ticketing/LoadingBar.vue";
</script>

<template>
    <AuthenticatedLayout>
        <div class="mx-auto justify-center items-center w-[90%] 2xl:w-[80%]">
            <div class="flex justify-between mr-4 w-full">
                <div class="flex justify-start mt-14">
                    <div class="gap-5">
                        <input type="date" v-model="filter.from" placeholder="from" class="rounded mr-3 border border-gray-300">
                        <input type="date" v-model="filter.to" placeholder="to" class="rounded mr-3 border border-gray-300">
                    </div>
                    <button @click="filterQueries()" class="bg-bgRGTBaseColor text-white py-2 px-4 mr-2 rounded-md">
                        <i class="fa fa-search"></i>
                    </button>
                    <button @click="reset()" class="bg-red-600 cursor-pointer text-white py-2 px-4 mr-2 rounded-md">
                        <i class="fa fa-recycle"></i>
                    </button>
                </div>
                <div class="justify-end mt-14 cursor-pointer">
                    <input type="text" v-model="search" placeholder="Search by Contact #" class="rounded mr-3 border border-gray-300">
                    <a class="bg-bgRGTBaseColor text-white p-2 mr-2 rounded-md"><i class="fa fa-file-excel"></i>
                        &nbsp; Export to Excel </a>
                </div>
            </div>
            <LoadingBar v-if="loading" />
            <p class="mt-5 mr-1 float-right relative"><strong>{{ (filtercallBackQueries.length > 0 ? "Showing 1 of "+ filtercallBackQueries.length : '') }}</strong></p>
            <div class="w-full overflow-x-auto shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] border-2 mt-1 md:overflow-hidden rounded-lg mb-2">
                <table class="table-auto w-full text-sm text-left rtl:text-right">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr colspan="12">
                            <th class="p-3">Name</th>
                            <th class="p-3">Mobile No</th>
                            <th class="p-3">Income Type</th>
                            <th class="p-3">Income Amount</th>
                            <th class="p-3">Tax Returns</th>
                            <th class="p-3">Bank Statement</th>
                            <th class="p-3">Marital Status</th>
                            <th class="p-3">Member</th>
                            <th class="p-3">Created At</th>
                            <th class="p-3">Action</th>
                        </tr>
                    </thead>
                    <tbody class="w-full">
                        <tr v-if="filtercallBackQueries == ''" class="border-b odd:bg-white even:bg-slate-50">
                            <td
                                class="px-6 py-4 whitespace-nowrap text-center text-red-600 font-semibold text-lg"
                                colspan="12">------- No Data Found -------</td>
                        </tr>
                        <tr colspan="12" v-else class="border-b odd:bg-white even:bg-gray-100" v-for="(callBackQuery, callBackQuerykey) in filtercallBackQueries"
                            :key="callBackQuerykey">
                            <td class="px-6 py-2 text-xs whitespace-nowrap">
                                {{ (callBackQuery.customers ? callBackQuery.customers.firstName : '') }}</td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <a href="#" class="whitespace-nowrap">{{ (callBackQuery.customers ? callBackQuery.customers.mobileNo : '')  }}</a>
                            </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <a href="#" class="whitespace-nowrap">{{ (callBackQuery.incomeType !== null ? callBackQuery.incomeType : 'No Available Income Type') }}</a>
                            </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <a href="#" class="whitespace-nowrap">{{ callBackQuery.incomeAmount }}</a>
                            </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <a href="#" class="whitespace-nowrap">{{ callBackQuery.taxReturns }}</a>
                            </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <span :class="`${callBackQuery.bankStatement === '1' ? 'bg-green-600 text-white' : 'bg-red-600 text-white'} px-2 py-1 rounded font-bold whitespace-nowrap`">
                                    {{ (callBackQuery.bankStatement === '1' ? 'Have consistent 6-months' : 'No Consistent 6 Months') }}
                                </span>
                            </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <a href="#" class="whitespace-nowrap">
                                    {{ (callBackQuery.maritalStatus === '1' ? 'Married' : 'Single') }}</a>
                            </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <span :class="`${callBackQuery.member === '1' ? 'bg-green-600 text-white' : 'bg-red-600 text-white'} px-2 py-1 rounded font-bold whitespace-nowrap`">
                                    {{ (callBackQuery.member === '1' ? 'Yes' : 'No') }}
                                </span>
                            </td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap">
                                {{ convertDate(callBackQuery.created_at) }}</td>
                            <td class="px-6 py-2 text-xs cursor-pointer" @click="openModal(callBackQuery)">
                                <i class="fa fa-eye text-yellow-500"></i>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="w-full justify-between border-rGTBorderColor border-b flex">
                <div class="flex flex-1 uppercase my-2 ml-4 justify-start text-black font-bold text-xl">
                    Visit Visa Details
                </div>
                <div class="flex flex-1 mb-2 mr-4 justify-end">
                    <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer"
                        @click="closeModal()"></i>
                </div>
            </div>
            <div class="w-full px-4 overflow-x-auto md:overflow-hidden rounded mb-9" >
                <table class="w-full shadow border text-sm text-left rounded-lg text-gray-500 my-3">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr>
                            <th class="px-6 py-3">
                                First Name
                            </th>
                            <th class="px-6 py-3">
                                Email
                            </th>
                            <th class="px-6 py-3">
                                Mobile
                            </th>
                            <th class="px-6 py-3">
                                Date of Birth
                            </th>
                            <th class="px-6 py-3">
                                Interest
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border-b ">
                            <td class="px-6 py-4">
                                {{ callBackSingleDetails.customers.firstName }}
                            </td>
                            <td class="px-6 py-4">
                                {{ callBackSingleDetails.customers.email }}
                            </td>
                            <td class="px-6 py-4">
                                {{ callBackSingleDetails.customers.mobileNo }}
                            </td>
                            <td class="px-6 py-4">
                                {{ callBackSingleDetails.dob }}
                            </td>
                            <td class="px-6 py-4">
                                {{ callBackSingleDetails.interest }}
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow border text-sm text-left rounded-lg text-gray-500">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr>
                            <th class="px-6 py-3">
                                Passport Validity
                            </th>
                            <th class="px-6 py-3">
                                Income Source
                            </th>
                            <th class="px-6 py-3">
                                Income Type
                            </th>
                            <th class="px-6 py-3">
                                Income Amount
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border-b ">
                            <td class="px-6 py-4">
                                <span :class="`${callBackSingleDetails.passportValidity === '1' ? 'bg-green-600 text-white' : 'bg-red-600 text-white'} px-2 py-1 rounded font-bold`">
                                    {{ (callBackSingleDetails.passportValidity === '1' ? 'Valid Passport' : 'Passport Not Valid') }}
                                </span>
                            </td>
                            <td class="px-6 py-4">
                                <span :class="`${callBackSingleDetails.incomeSource === '1' ? 'bg-green-600 text-white' : 'bg-red-600 text-white'} px-2 py-1 rounded font-bold`">
                                    {{ (callBackSingleDetails.incomeSource === '1' ? 'Yes' : 'No') }}
                                </span>
                            </td>
                            <td class="px-6 py-4">
                                {{ (callBackSingleDetails.incomeType !== null ? callBackSingleDetails.incomeType : 'No Available Income Type') }}
                            </td>
                            <td class="px-6 py-4">
                               {{ callBackSingleDetails.incomeAmount }}
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow border text-sm text-left rounded-lg text-gray-500 my-3">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr>
                            <th class="px-6 py-3">
                                Tax Filer
                            </th>
                            <th class="px-6 py-3">
                                Tax Returns
                            </th>
                            <th class="px-6 py-3">
                                Bank Statement
                            </th>
                            <th class="px-6 py-3">
                                Sufficient Funds
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border-b ">
                            <td class="px-6 py-4">
                                <span :class="`${callBackSingleDetails.taxFiler === '1' ? 'bg-green-600 text-white' : 'bg-red-600 text-white'} px-2 py-1 rounded font-bold`">
                                    {{ (callBackSingleDetails.taxFiler === '1' ? 'Filler' : 'Non-Filler') }}
                                </span>
                            </td>
                            <td class="px-6 py-4">
                                {{ callBackSingleDetails.taxReturns }}
                            </td>
                            <td class="px-6 py-4">
                                <span :class="`${callBackSingleDetails.bankStatement === '1' ? 'bg-green-600 text-white' : 'bg-red-600 text-white'} px-2 py-1 rounded font-bold`">
                                    {{ (callBackSingleDetails.bankStatement === '1' ? 'Have consistent 6-months' : 'No Consistent 6 Months') }}
                                </span>
                            </td>
                            <td class="px-6 py-4 break-all">
                                <span :class="`${callBackSingleDetails.sufficientFunds === '1' ? 'bg-green-600 text-white' : 'bg-red-600 text-white'} px-2 py-1 rounded font-bold`">
                                    {{ (callBackSingleDetails.sufficientFunds === '1' ? 'Yes' : 'No') }}
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow border text-sm text-left rounded-lg text-gray-500">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr>
                            <th class="px-6 py-3">
                                Marital Status
                            </th>
                            <th class="px-6 py-3">
                                Kids
                            </th>
                            <th class="px-6 py-3">
                                Commerce Member
                            </th>
                            <th class="px-6 py-3">
                                Lead From
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border-b ">
                            <td class="px-6 py-4">
                                <span class="px-2 py-1 rounded font-bold">
                                    {{ (callBackSingleDetails.maritalStatus === '1' ? 'Married' : 'Single') }}
                                </span>
                            </td>
                            <td class="px-6 py-4">
                                {{ callBackSingleDetails.kids }}
                            </td>
                            <td class="px-6 py-4">
                                <span :class="`${callBackSingleDetails.member === '1' ? 'bg-green-600 text-white' : 'bg-red-600 text-white'} px-2 py-1 rounded font-bold`">
                                    {{ (callBackSingleDetails.member === '1' ? 'Yes' : 'No') }}
                                </span>
                            </td>
                            <td class="px-6 py-4 break-all">
                                {{ callBackSingleDetails.leadFrom }}
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow border text-sm text-left rounded-lg text-gray-500 my-3">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr>
                            <th class="px-6 py-3">
                                Education
                            </th>
                            <th class="px-6 py-3">
                                Purpose
                            </th>
                        </tr>
                    </thead>
                    <tbody class="w-full">
                        <tr class="bg-white border-b">
                            <td class="px-6 py-2 w-[50%]">
                                <span class="text-xs break-all">
                                    {{ callBackSingleDetails.education }}
                                </span>
                            </td>
                            <td class="px-6 py-2 w-[50%]">
                                <span class="text-xs break-all">
                                    {{ callBackSingleDetails.purpose }}
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow border text-sm text-left rounded-lg text-gray-500">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr>
                            <th class="px-6 py-3">
                                Travel History
                            </th>
                            <th class="px-6 py-3">
                                Travelled Countries
                            </th>
                        </tr>
                    </thead>
                    <tbody class="w-full">
                        <tr class="bg-white border-b">
                            <td class="px-6 py-2 w-[25%]">
                                <span :class="`${callBackSingleDetails.travelHistory === '1' ? 'bg-green-600 text-white' : 'bg-red-600 text-white'} px-2 py-1 rounded font-bold`">
                                    {{ (callBackSingleDetails.travelHistory === '1' ? 'Yes' : 'No') }}
                                </span>
                            </td>
                            <td class="px-6 py-2 w-[75%]">
                                <span class="text-xs break-all">
                                    {{ (callBackSingleDetails.travelHistory === '1' ? callBackSingleDetails.travelledCountries : 'No Avaliable History') }}
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="w-40 my-4 mr-3 float-end">
                <button @click="closeModal()" class="w-full p-2 text-xl bg-red-600 text-white text-center transition-all duration-700 ease-in-out rounded hover:bg-bgRGTBaseColor hover:text-white hover:transition-all hover:ease-in-out hover:duration-700">
                Close
                </button>
            </div>
        </Modal>
    </AuthenticatedLayout>
</template>

<script>
import Modal from '@/Components/Modal.vue';
import moment from "moment";
export default {
    name: 'visitVisaReport',
    props: {
        visitVisaReport: { type: Object }
    },
    data(){
        return {
            isModalVisible: false,
            modalWidth : "sm:w-[100%] md:w-[55%]",
            search:'',
            hover: '',
            loading: false,
            callBackSingleDetails: '',
            filter: {
                from: '',
                to: ''
            }
        }
    },
    computed: {
        filtercallBackQueries() {
            return this.callBackQuery();
        }
    },
    methods : {
        openModal(data) {
            this.isModalVisible = true;
            this.callBackSingleDetails = data;

        },
        closeModal: function () {
            this.isModalVisible = false;
        },
        convertDate(date){
            return moment(date).format('DD-MM-YYYY');
        },
        callBackQuery(){
            let mbNo = this.visitVisaReport.filter(item => {
                return item.customers.mobileNo.toLowerCase().indexOf(this.search.toLowerCase()) > -1
            });
            return mbNo;
        },
        filterQueries(){
            this.loading = true;
            this.$inertia.post('/reports/visa-report', this.filter, {
                onSuccess: (response) => {
                    this.loading = false;
                },
            });
        },
        reset(){
            console.log(this.filter);
            Object.assign(this.$data, this.$options.data());
        }
    }
}
</script>