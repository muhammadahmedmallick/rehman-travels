<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import LoadingBar from "../loader/LoadingBar.vue";
</script>
<template>
    <AuthenticatedLayout>
        <div v-if="loggedInOwner === 'true' || (permissions !== undefined && permissions !== '' &&  permissions['View'] === 1)" class="py-3">
            <div class="w-full mx-auto sm:px-6 lg:px-6 space-y-2">
                <div class="p-2 sm:p-12 bg-white shadow sm:rounded-lg">
                    <LoadingBar v-if="loading"/>
                    <div v-if="loggedInOwner === 'true' || (permissions !== undefined && permissions !== '' &&  permissions['Add'] === 1)" class="flex justify-end m-3">
                        <a v-on:click="openModal({},'add')" class="bg-bgRGTBaseColor text-white p-2 rounded-md cursor-pointer"><i class="fa fa-plus"></i>&nbsp Add New User </a>
                    </div>
                    <div class="overflow-x-auto shadow-md">
                        <div
                            class="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6">
                            <div class="flex flex-1 justify-between sm:hidden">
                                <a href="#"
                                   class="relative inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">Previous</a>
                                <a href="#"
                                   class="relative ml-3 inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">Next</a>
                            </div>
                            <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
                                <div>
                                    <select v-model="users.perPage" v-on:change="paginate()"
                                            class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                        <option v-for="(showRecord,showRecordKey) in users.showRecords"
                                                :key="showRecordKey"
                                                :value="showRecord">{{ showRecord }}
                                        </option>
                                    </select>
                                </div>
                                <div class="flex items-center gap-1 px-4 bg-bgRGTBaseColor rounded-md">
                                    <button v-on:click.prevent="(users.currentPage = 1), paginate()"
                                            :disabled="users.currentPage === 1"
                                            class="flex items-center font-sans text-xs font-bold text-center text-white uppercase align-middle transition-all rounded-full select-none hover:bg-gray-900/50 active:bg-gray-900/20 disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
                                            type="button">First
                                    </button>
                                    <button
                                        v-on:click.prevent="(users.currentPage < 1 ? (users.currentPage = 1) : (users.currentPage -= 1)), paginate()"
                                        :disabled="users.currentPage === 1"
                                        class="flex items-center font-sans text-xs font-bold text-center text-white uppercase align-middle transition-all rounded-full select-none hover:bg-gray-900/50 active:bg-gray-900/20 disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
                                        type="button">Previous
                                    </button>
                                    <div class="flex items-center py-1 gap-2">
                                        <button v-for="(paginate,paginateKey) in paginates" :key="paginateKey"
                                                :class="`${paginate == users.currentPage ? 'select-none rounded-full bg-gray-900 text-center align-middle font-sans text-xs font-medium uppercase text-white shadow-md shadow-gray-900/10 transition-all ': ''} relative h-10 max-h-[30px] w-10 max-w-[30px] select-none rounded-full text-center align-middle font-sans text-xs font-medium uppercase text-gray-900 transition-all hover:bg-gray-900/50 active:bg-gray-900/20 disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none`"
                                                type="button" v-on:click.prevent="page(paginate)">
                                    <span class="absolute transform -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2">{{
                                            paginate
                                        }}</span>
                                        </button>
                                    </div>
                                    <button
                                        v-on:click.prevent="(users.currentPage > users.pages ? users.currentPage = users.pages: users.currentPage += 1),paginate()"
                                        :disabled="users.currentPage == users.pages"
                                        class="flex items-center font-sans text-xs font-bold text-center text-white uppercase align-middle transition-all rounded-full select-none hover:bg-gray-900/50 active:bg-gray-900/20 disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
                                        type="button">Next
                                    </button>
                                    <button v-on:click.prevent="(users.currentPage = users.pages), paginate()"
                                            :disabled="users.currentPage == users.pages"
                                            class="flex items-center font-sans text-xs font-bold text-center text-white uppercase align-middle transition-all rounded-full select-none hover:bg-gray-900/50 active:bg-gray-900/20 disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
                                            type="button">Last
                                    </button>
                                </div>
                            </div>
                        </div>
                         <div class="overflow-auto">
                            <table class="w-full  md:w-[98%] whitespace-nowrap text-sm text-left border-2 rtl:text-right text-gray-500 mx-auto mt-2 mb-2">
                                <thead class="text-xs text-white uppercase bg-[#2196F3]">
                                <tr>
                                    <th class="px-2 py-2">S.No</th>
                                    <th class="px-2 py-2">Agent Type</th>
                                    <th class="px-2 py-2">Company Name</th>
                                    <th class="px-2 py-2">Agent Name</th>
                                    <th class="px-2 py-2">User Name</th>
                                    <th class="px-2 py-2">Branch</th>
                                    <th class="px-2 py-2">Email</th>
                                    <th class="px-2 py-2">Mobile No</th>
                                    <th class="px-2 py-2">Portal Type</th>
                                    <th class="px-2 py-2">Account Status</th>
                                    <th v-if="(loggedInOwner === 'true' || (permissions !== undefined && permissions !== ''))">Action</th>
                                </tr>
                                </thead>
                                <tbody class="table-body">
                                <tr v-if="users.totalRecords === ''">
                                    <td colspan="10"
                                        class="px-6 py-4 font-bold text-red-700 text-lg text-center whitespace-nowrap dark:red">No
                                        !!!!!!!.............Record Found.............!!!!!!!
                                    </td>
                                </tr>
                                <tr v-for="(record,recordKey) in users.totalRecords" :key="recordKey"
                                    class="border-b odd:bg-white even:bg-slate-50">
                                    <td class="py-1 pl-2">{{ record.id }}</td>
                                    <td class="py-1">{{ record.agentType.replace("_", " ").toUpperCase() }}</td>
                                    <td class="py-1">{{ record.companyName }}</td>
                                    <td class="py-1">{{ record.agentName }}</td>
                                    <td class="py-1">{{ record.userName }}</td>
                                    <td class="py-1">{{ record.branchName }}</td>
                                    <td class="py-1">{{ record.mobileNo }}</td>
                                    <td class="py-1">{{ record.email }}</td>
                                    <td class="py-1">{{ record.portalType }}</td>
                                    <td class="py-1">{{ record.accountStatus }}</td>
                                    <td v-if="(loggedInOwner === 'true' || (permissions !== undefined && permissions !== ''))">
                                        <a v-if="loggedInOwner === 'true' || permissions['View'] === 1"
                                        href="javascript:void(0)" v-on:click="openModal(record,'view')"><i
                                            class="fas fa-eye text-[#fb710e] cursor-pointer mr-3"></i></a>
                                        <a v-if="loggedInOwner === 'true' || permissions['Edit'] === 1"
                                        href="javascript:void(0)" title="Edit User Information"
                                        v-on:click="openModal(record,'edit')"><i class="fas fa-pencil-alt text-blue-400 cursor-pointer mr-3"></i></a>
                                        <a v-if="loggedInOwner === 'true' || permissions['Delete'] === 1"
                                        href="javascript:void(0)" v-on:click="remove(record.id)"><i
                                            class="fas fa-trash text-red-600 cursor-pointer mr-3"></i></a>
                                        <a v-if="loggedInOwner === 'true' || permissions['Permission'] === 1"
                                        v-bind:href="'/b2b/permission/view-all-permission?aid=' +record.agentId + '&paid=' + record.parentId  +'&uid=' + record.id +'&cpny='+record.companyName +'&uname='+record.userName"
                                        title="View Permission" target="_blank"><i class="fas fa-key text-[#0081f3] cursor-pointer mr-3"></i></a>
                                        <a v-if="loggedInOwner === 'true' || permissions['Markup'] === 1"
                                        v-bind:href="'/b2b/markup/view-all-markup?aid=' +record.agentId + '&paid=' + record.parentId  + '&cpny='+record.companyName+'&uid=' + record.id + '&mt=' + (record.agentType == 'owner' ? 'b2c' : (record.agentType == 'agent' ? 'b2b2c' : 'b2b2b2c' ))"
                                        title="View Markup" target="_blank"><i class="fas fa-percent text-green-500 cursor-pointer mr-3"></i></a>
                                        <a v-if="loggedInOwner === 'true' || permissions['Payment'] === 1"
                                        v-bind:href="'/b2b/payment/view-all-payment?aid='+record.id+'&paid='+record.parentId+'&uid=' + record.id+'&cpny='+record.companyName"
                                        title="View Agent Payment" target="_blank"><i
                                            class="fas fa-dollar-sign fas fa-money-bill-alt text-gray-600 cursor-pointer mr-3"></i></a>
                                        <a v-if="loggedInOwner === 'true' || permissions['Profile'] === 1"
                                        v-bind:href="'/b2b/user/profile?aid=' + record.agentId + '&paid=' + record.parentId + '&uid=' + record.id"
                                        title="View User Profile" target="_blank"><i class="fas fa-user text-orange-500 cursor-pointer mr-3"></i></a>
                                    </td>
                                </tr>
                                </tbody>
                                </table>
                         </div>
                        <div
                            class="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6">
                            <div class="flex flex-1 justify-between sm:hidden">
                                <a href="#"
                                   class="relative inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">Previous</a>
                                <a href="#"
                                   class="relative ml-3 inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">Next</a>
                            </div>
                            <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
                                <div>
                                    <p class="text-sm text-red-700 font-semibold">
                                        Showing<span class="font-medium"> {{ pageInfo.from }}</span>
                                        to <span class="font-medium">{{ pageInfo.to }}</span>
                                        of <span class="font-medium">{{ pageInfo.of }}</span>
                                        results
                                    </p>
                                </div>
                                <div class="flex items-center gap-1 px-4 bg-bgRGTBaseColor rounded-md">
                                    <button v-on:click.prevent="(users.currentPage = 1), paginate()"
                                            :disabled="users.currentPage === 1"
                                            class="flex items-center font-sans text-xs font-bold text-center text-white uppercase align-middle transition-all rounded-full select-none hover:bg-gray-900/50 active:bg-gray-900/20 disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
                                            type="button">First
                                    </button>
                                    <button
                                        v-on:click.prevent="(users.currentPage < 1 ? (users.currentPage = 1) : (users.currentPage -= 1)), paginate()"
                                        :disabled="users.currentPage === 1"
                                        class="flex items-center font-sans text-xs font-bold text-center text-white uppercase align-middle transition-all rounded-full select-none hover:bg-gray-900/50 active:bg-gray-900/20 disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
                                        type="button">Previous
                                    </button>
                                    <div class="flex items-center py-1 gap-2">
                                        <button v-for="(paginate,paginateKey) in paginates" :key="paginateKey"
                                                :class="`${paginate == users.currentPage ? 'select-none rounded-full bg-gray-900 text-center align-middle font-sans text-xs font-medium uppercase text-white shadow-md shadow-gray-900/10 transition-all ': ''} relative h-10 max-h-[30px] w-10 max-w-[30px] select-none rounded-full text-center align-middle font-sans text-xs font-medium uppercase text-gray-900 transition-all hover:bg-gray-900/50 active:bg-gray-900/20 disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none`"
                                                type="button" v-on:click.prevent="page(paginate)">
                                    <span class="absolute transform -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2">{{
                                            paginate
                                        }}</span>
                                        </button>
                                    </div>
                                    <button
                                        v-on:click.prevent="(users.currentPage > users.pages ? users.currentPage = users.pages: users.currentPage += 1),paginate()"
                                        :disabled="users.currentPage == users.pages"
                                        class="flex items-center font-sans text-xs font-bold text-center text-white uppercase align-middle transition-all rounded-full select-none hover:bg-gray-900/50 active:bg-gray-900/20 disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
                                        type="button">Next
                                    </button>
                                    <button v-on:click.prevent="(users.currentPage = users.pages), paginate()"
                                            :disabled="users.currentPage == users.pages"
                                            class="flex items-center font-sans text-xs font-bold text-center text-white uppercase align-middle transition-all rounded-full select-none hover:bg-gray-900/50 active:bg-gray-900/20 disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
                                            type="button">Last
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <Edit :modalPopup="modalPopup" :user="user" :actionType="actionType" :permissions="permissions"
                          @refresh="refresh"
                          @closedModal="closedModal"/>
                </div>
            </div>
        </div>
        <div v-else class="py-3">
            <div class="px-6 py-4 font-medium text-red-700 text-center whitespace-nowrap dark:red">
                You do not have permission to access this page
            </div>
        </div>
    </AuthenticatedLayout>
</template>
<script>
import Service from "@/Config/Service.js";
import Edit from "@/Pages/Backend/User/Edit.vue";
import {array, object, string, number} from 'alga-js'

export default {
    name: "EditUser",
    components: {Edit},
    computed: {
        pageInfo: function () {
            return array.pageInfo(this.currentRecords(), this.users.currentPage, this.users.perPage);
        },
        paginates() {
            return array.pagination(this.users.pages, this.users.currentPage, 3);
        }
    },
    data() {
        return {
            loading: false,
            loggedInOwner: false,
            loggedIn: {type: Object},
            permissions: {type: Object},
            users: {
                records: "",
                totalRecords: [],
                pages: 1,
                currentPage: 1,
                perPage: 50,
                showRecords: [10, 25, 50, 150, 250, 500, 1000, "All"],
                search: {
                    userType: "",
                    portalType: "",
                    paymentType: "",
                    markupType: "",
                    keyword: "",
                    branchId: 0,
                    accountStatus: "",
                    totalRecords: [],
                },
            },
            records: "",
            totalRecords: "",
            modalPopup: false,
            actionType: "",
            user: "",
            legs: "",
            flightType: "lowestPrice",
            travelers: 0,
        };
    },
    created() {
        this.loggedIn = this.$page.props.auth.loggedIn
        this.loggedInOwner = (this.loggedIn['activeId'] === 1 && this.loggedIn['userType'] === 'owner' ? 'true' : 'false');
        this.permissions = (this.$page.props.permissions !== null ? this.$page.props.permissions['User'] : "");
        if (this.loggedInOwner === 'true' || this.$page.props.permissions !== null) this.allUserRequest()
    },
    methods: {
        refresh() {
            this.allUserRequest()
        },
        search() {
            this.currentPage = 1;
            this.paginate();
        },
        currentRecords: function () {
            console.log(this.users.search.totalRecords.length);
            return this.users.search.totalRecords.length <= 0 ? this.totalRecords : this.users.search.totalRecords;
        },
        page: function (page) {
            this.users.currentPage = page;
            this.paginate();
        },
        paginate: function () {
            this.users.search.totalRecords = this.totalRecords
            this.users.search.totalRecords = array.search(this.users.search.totalRecords, this.users.search.userType)
            this.users.search.totalRecords = array.search(this.users.search.totalRecords, this.users.search.portalType)
            this.users.search.totalRecords = array.search(this.users.search.totalRecords, this.users.search.paymentType)
            this.users.search.totalRecords = array.search(this.users.search.totalRecords, this.users.search.markupType)
            this.users.search.totalRecords = array.search(this.users.search.totalRecords, this.users.search.accountStatus)
            this.users.search.totalRecords = array.search(this.users.search.totalRecords, this.users.search.keyword)
            this.pagination(this.users.search.totalRecords);
        },
        pagination: function (totalRecords) {
            this.users.totalRecords = array.paginate(
                totalRecords,
                this.users.currentPage,
                this.users.perPage
            );
            this.users.pages = array.pages(totalRecords, this.users.perPage);
            this.totalCounts = totalRecords.length;
        },
        allUserRequest() {
            this.start();
            const airURLSearchParam = this.airURLSearchParams();
            Service.doRequest("/b2b/user/all-user-request", 'Post', {
                'agentId': airURLSearchParam.get("aid"),
                'parentId': airURLSearchParam.get("paid"),
                'agentType': airURLSearchParam.get("ut")
                }).then((response) => {
                    if (response.errorType === "false") {
                        this.totalRecords = response.totalRecords;
                        this.totalCounts = response.totalCounts;
                        this.pagination(this.totalRecords);
                    } else if (response.errorType === "true") {
                        this.$toast.error(response.error);
                    }
                    this.finish(false);
                });
        },
        remove: function (userId) {
            this.start();
            Service.doRequest("/b2b/user/user-delete-request/" + userId, "DELETE", "")
                .then((response) => {
                    if (response.errorType === "false") {
                        this.$toast.success(response.success);
                        this.allUserRequest()
                    } else if (response.errorType === "true") {
                        this.$toast.error(response.error);
                    }
                    this.finish(false);
                });
        },
        start() {
            this.loading = true;
        },
        finish(option) {
            this.loading = option;
        },
        openModal: function (user, actionType) {
            this.modalPopup = true
            this.user = user
            this.actionType = actionType
        },
        closedModal: function () {
            this.modalPopup = false;
        },
        airURLSearchParams: function () {
            return new URLSearchParams(window.location.search);
        },
        reset() {
            this.users.search = {
                userType: "",
                portalType: "",
                paymentType: "",
                markupType: "",
                keyword: "",
                branchId: 0,
                accountStatus: "",
                totalRecords: [],
            }
            this.pagination(this.totalRecords);
        }
    },
};
</script>
