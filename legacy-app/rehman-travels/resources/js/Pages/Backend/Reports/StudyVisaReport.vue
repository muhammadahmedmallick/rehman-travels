<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import LoadingBar from "@/Pages/Website/Ticketing/LoadingBar.vue";
</script>

<template>
    <AuthenticatedLayout>
        <div class="mx-auto justify-center items-center w-[80%]">
            <div class="flex justify-between mr-4 w-full">
                <div class="flex justify-start mt-14">
                    <div class="gap-5">
                        <input type="date" v-model="filter.from" placeholder="from"
                            class="rounded mr-3 border border-gray-300">
                        <input type="date" v-model="filter.to" placeholder="to"
                            class="rounded mr-3 border border-gray-300">
                    </div>
                    <button @click="filterQueries()" class="bg-bgRGTBaseColor text-white py-2 px-4 mr-2 rounded-md">
                        <i class="fa fa-search"></i>
                    </button>
                    <button @click="reset()" class="bg-red-600 cursor-pointer text-white py-2 px-4 mr-2 rounded-md">
                        <i class="fa fa-recycle"></i>
                    </button>
                </div>
                <div class="justify-end mt-14 cursor-pointer">
                    <input type="text" v-model="search" placeholder="Search by Contact #"
                        class="rounded mr-3 border border-gray-300">
                    <a class="bg-bgRGTBaseColor text-white p-2 mr-2 rounded-md"><i
                            class="fa fa-file-excel"></i>
                        &nbsp; Export to Excel </a>
                </div>
            </div>
            <LoadingBar v-if="loading"></LoadingBar>
            <p class="mt-5 mr-1 float-right relative"><strong>{{ (filtercallBackQueries.length > 0 ? "Showing 1 of " +
                filtercallBackQueries.length : '') }}</strong></p>
            <div
                class="w-full overflow-x-auto shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] border-2 mt-1 md:overflow-hidden rounded-lg mb-2">
                <table class="table-auto w-full text-sm text-left text-gray-500">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr colspan="12">
                            <th class="p-3">Name</th>
                            <th class="p-3">Mobile No</th>
                            <th class="p-3">City</th>
                            <th class="p-3">Degree</th>
                            <th class="p-3">Gradutaion Year</th>
                            <th class="p-3">Is IELTS</th>
                            <th class="p-3">University</th>
                            <th class="p-3">Interest</th>
                            <th class="p-3">Created At</th>
                            <th class="p-3">Action</th>
                        </tr>
                    </thead>
                    <tbody class="w-full">
                        <tr v-if="filtercallBackQueries == ''" class="border-b odd:bg-white even:bg-slate-50">
                            <td class="px-6 py-4 whitespace-nowrap text-center text-red-600 font-semibold text-lg"
                                colspan="12">------- No Data Found -------</td>
                        </tr>
                        <tr colspan="12" v-else class="border-b odd:bg-white even:bg-gray-100"
                            v-for="(callBackQuery, callBackQuerykey) in filtercallBackQueries" :key="callBackQuerykey">
                            <td class="px-6 py-2 text-xs whitespace-nowrap"> {{ (callBackQuery.customers ?
                                callBackQuery.customers.firstName : '') }} </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                {{ (callBackQuery.customers ? callBackQuery.customers.mobileNo : '') }}
                            </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <a href="#" class="whitespace-nowrap">{{ callBackQuery.city }}</a>
                            </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <a href="#" class="whitespace-nowrap">{{ callBackQuery.degree }}</a>
                            </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <a href="#" class="whitespace-nowrap">{{ callBackQuery.gradutaionYear }}</a>
                            </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <a href="#" class="whitespace-nowrap">{{ (callBackQuery.isIelts ? 'Completed' : 'No Ietls') }}</a>
                            </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <a href="#" class="whitespace-nowrap">{{ callBackQuery.university }}</a>
                            </td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <a href="#" class="whitespace-nowrap">{{ callBackQuery.interest }}</a>
                            </td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap">
                                {{ setDate(callBackQuery.created_at) }}</td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap" @click="openModal(callBackQuery)">
                                <i class="fa fa-eye text-yellow-500"></i>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="w-full justify-between bg-bgRGTBaseColor flex">
                <div class="flex flex-1 uppercase my-2 ml-4 justify-start text-white font-bold text-xl">
                    Details
                </div>
                <div class="flex flex-1 mb-2 mr-4 justify-end">
                    <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer"
                        @click="closeModal()"></i>
                </div>
            </div>
            <div
            class="w-full px-4 overflow-x-auto md:overflow-hidden rounded-lg mb-9"
            >
                <table class="w-full shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15),0px_1px_1px_0p_rgba(0_0_0_0.05)] text-sm text-left text-gray-500 my-3">
                    <thead class="text-xs text-gray-600 uppercase bg-gray-100">
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
                                City
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
                                {{ callBackSingleDetails.city }}
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15),0px_1px_1px_0p_rgba(0_0_0_0.05)] text-sm text-left text-gray-500">
                    <thead class="text-xs text-gray-600 uppercase bg-gray-100">
                        <tr>
                            <th class="px-6 py-3">
                                Degree
                            </th>
                            <th class="px-6 py-3">
                                Gradutaion Year
                            </th>
                            <th class="px-6 py-3">
                                Grade
                            </th>
                            <th class="px-6 py-3">
                                IELTS
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border-b ">
                            <td class="px-6 py-4">
                                {{ callBackSingleDetails.degree }}
                            </td>
                            <td class="px-6 py-4">
                                {{ callBackSingleDetails.gradutaionYear }}
                            </td>
                            <td class="px-6 py-4">
                                {{ callBackSingleDetails.grade }}
                            </td>
                            <td class="px-6 py-4">
                                {{ (callBackSingleDetails.isIelts ? 'Completed' : 'No IELTS') }}
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15),0px_1px_1px_0p_rgba(0_0_0_0.05)] text-sm text-left text-gray-500 my-3">
                    <thead class="text-xs text-gray-600 uppercase bg-gray-100">
                        <tr>
                            <th class="px-6 py-3">
                                Income
                            </th>
                            <th class="px-6 py-3">
                                Account Balance
                            </th>
                            <th class="px-6 py-3">
                                University
                            </th>
                            <th class="px-6 py-3">
                                Interest
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border-b ">
                            <td class="px-6 py-4">
                               PKR {{ callBackSingleDetails.income }}
                            </td>
                            <td class="px-6 py-4">
                               PKR {{ callBackSingleDetails.accBalance }}
                            </td>
                            <td class="px-6 py-4">
                                {{ callBackSingleDetails.university }}
                            </td>
                            <td class="px-6 py-4">
                                {{ callBackSingleDetails.interest }}
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15),0px_1px_1px_0p_rgba(0_0_0_0.05)] text-sm text-left text-gray-500">
                    <thead class="text-xs text-gray-600 uppercase bg-gray-100">
                        <tr>
                            <th class="px-6 py-3">
                                Messge
                            </th>
                        </tr>
                    </thead>
                    <tbody class="w-full">
                        <tr class="bg-white border-b">
                            <td class="px-6 py-2" colspan="12">
                                <span class="text-xs break-all">
                                    {{ callBackSingleDetails.message }}
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>


        </Modal>
    </AuthenticatedLayout>
</template>

<script>
import moment from 'moment';
import Modal from '@/Components/Modal.vue';
export default {
    name: 'studyVisaReport',
    props: {
        studyVisaReport: { type: Object }
    },
    data() {
        return {
            isModalVisible: false,
            modalWidth: "sm:w-[100%] md:w-[55%]",
            search: '',
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
    methods: {
        setDate(date) {
            return moment(date).format('YYYY-MM-DD HH:mm:ss');
        },
        openModal(data) {
            console.log(data);
            this.isModalVisible = true;
            this.callBackSingleDetails = data;

        },
        closeModal: function () {
            this.isModalVisible = false;
        },
        callBackQuery() {
            let mbNo = this.studyVisaReport.filter(item => {
                return item.customers.mobileNo.toLowerCase().indexOf(this.search.toLowerCase()) > -1
            });
            return mbNo;
        },
        filterQueries() {
            this.loading = true;
            this.$inertia.post('/reports/study-report', this.filter, {
                onSuccess: (response) => {
                    console.log(response);
                    this.loading = false;
                },
            });
        },
        reset() {
            Object.assign(this.$data, this.$options.data());
        }
    }
}
</script>