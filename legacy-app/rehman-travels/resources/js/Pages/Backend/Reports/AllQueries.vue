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
                        <input type="date" v-model="filter.from" placeholder="from" class="rounded mr-3 border border-gray-300">
                        <input type="date" v-model="filter.to" placeholder="to" class="rounded mr-3 border border-gray-300">
                        <select v-model="filter.moduleId" class="rounded mr-3 border border-gray-300">
                            <option v-for="(moduleData, moduleKey) in $page.props.modules" :key="moduleKey" :value="moduleData.id">
                            {{ moduleData.title }}
                            </option>
                            <option value="gad_source=">Google</option>
                            <option value="ft=">Facebook-Instagram</option>
                        </select>
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
            <div class="w-full shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15),0px_1px_1px_0p_rgba(0_0_0_0.05)] border-2 mt-1 overflow-x-auto rounded-lg mb-2">
                <table class="table-auto w-full text-sm text-left rtl:text-right text-gray-500">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr colspan="12">
                            <th class="p-3">Name</th>
                            <th class="p-3">Mobile No</th>
                            <th class="p-3">Lead From</th>
                            <th class="p-3">Message</th>
                            <th class="p-3">Referal Url</th>
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
                                {{ callBackQuery.firstName }}</td>
                            <td class="px-6 py-2 text-xs cursor-pointer">
                                <a :href="'tel:' + callBackQuery.mobileNo" class="whitespace-nowrap">{{ callBackQuery.mobileNo }}</a>
                            </td>
                            <td class="px-6 py-2 text-xs truncate w-48 line-clamp-1">
                                {{ callBackQuery.leadFrom }}</td>
                            <td class="px-6 py-2 cursor-pointer">
                                <span class="text-xs line-clamp-3" @mouseenter="hover = true" @mouseleave="hover = false" v-html="callBackQuery.message"></span>
                            </td>
                            <td class="px-6 py-2 text-justify">
                                <span class="text-xs truncate w-48 line-clamp-3">{{ callBackQuery.referalUrl }}</span>
                            </td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap">
                                {{ callBackQuery.created_at }}</td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap cursor-pointer">
                                <i class="fa fa-eye text-yellow-500" @click="openModal(callBackQuery)"></i>
                                <i class="fa-brands fa-xl fa-whatsapp text-[#25D366] ml-2" v-if="callBackQuery.moduleId != '19'" @click="sendWhatsapp(callBackQuery)"></i>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="w-full justify-between bg-bgRGTBaseColor flex">
                <div class="flex flex-1 uppercase my-2 ml-4 justify-start text-white font-bold text-xl">
                    Query Details
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
                                Module
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border-b">
                            <td class="px-6 py-4">
                                {{ inputData.firstName }}
                            </td>
                            <td class="px-6 py-4">
                                {{ inputData.email }}
                            </td>
                            <td class="px-6 py-4">
                                {{ inputData.mobileNo }}
                            </td>
                            <td class="px-6 py-4">
                                {{ inputData.moduleId }}
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15),0px_1px_1px_0p_rgba(0_0_0_0.05)] text-sm text-left text-gray-500 my-3">
                    <thead class="text-xs text-gray-600 uppercase bg-gray-100">
                        <tr>
                            <th class="px-6 py-3">
                                Device Info
                            </th>
                            <th class="px-6 py-3">
                                Browser
                            </th>
                            <th class="px-6 py-3">
                                Client IP
                            </th>
                            <th class="px-6 py-3">
                                Client Platform
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border-b">
                            <td class="px-6 py-4">
                                {{ inputData.mobileInfo }}
                            </td>
                            <td class="px-6 py-4">
                                {{ inputData.clientBrowser }}
                            </td>
                            <td class="px-6 py-4">
                                {{ inputData.clientIp }}
                            </td>
                            <td class="px-6 py-4">
                                {{ inputData.clientPlatform }}
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15),0px_1px_1px_0p_rgba(0_0_0_0.05)] text-sm text-left text-gray-500 my-3">
                    <thead class="text-xs text-gray-600 uppercase bg-gray-100">
                        <tr>
                            <th class="px-6 py-3">
                                Lead From
                            </th>
                            <th class="px-6 py-3">
                                Referal Url
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border-b">
                            <td class="px-6 py-4">
                                <span class="text-xs text-justify break-all">{{ (inputData.leadFrom ? inputData.leadFrom : 'Home') }}</span>
                            </td>
                            <td class="px-6 py-4">
                                <span class="text-xs text-justify break-all">{{ inputData.referalUrl }}</span>
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
                                    {{ inputData.message }}
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <p class="text-slate-300 text-sm pr-5 mb-2 float-right"> Created at: {{ inputData.created_at }}</p>
        </Modal>
    </AuthenticatedLayout>
</template>

<script>
import Modal from '@/Components/Modal.vue';
import Service from "@/Config/Service.js";
export default {
    name: 'callBackQueries',
    props: {
        callBackQueries: { type: Object }
    },
    data(){
        return {
            search:'',
            hover: '',
            isModalVisible: false,
            modalWidth: "sm:w-[100%] md:w-[75%] 2xl:w-[55%]",
            loading: false,
            inputData: {
                firstName: '',
                email: '',
                mobileNo: '',
                leadFrom: '',
                message: '',
                mobileInfo: '',
                moduleId: '',
                clientBrowser: '',
                clientIp: '',
                clientPlatform: '',
                referalUrl: '',
                created_at: '',
            },
            filter: {
                from: '',
                to: '',
                moduleId : ''
            }
        }
    },
    computed: {
        filtercallBackQueries() {
            return this.callBackQuery();    
        }
    },
    methods : {
        sendWhatsapp(data){
            Service.doFetchRequest("/lead-whatsapp", '', data).then((data) => {
                const url = 'https://api.whatsapp.com/send?phone='+data['phone']+'&text='+ encodeURIComponent(data['message']);
                window.open(url, "_blank")
            });
        },
        callBackQuery(){
            return this.callBackQueries.filter(item => {
                return item.mobileNo.toLowerCase().indexOf(this.search.toLowerCase()) > -1
            });
        },
        filterQueries(){
            this.loading = true;
            this.$inertia.post('reports', this.filter, {
                onSuccess: (response) => {
                    this.loading = false;
                },
            });
        },
        reset(){
            Object.assign(this.$data, this.$options.data());
        },
        closeModal(){
            this.isModalVisible = false;
        },
        openModal(data){
            this.isModalVisible = true;
            this.inputData = data;
            console.log(data);
        }
    }
}
</script>