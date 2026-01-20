<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
</script>
<template>
    <AuthenticatedLayout>
        <div class="mx-auto justify-center items-center w-[80%]">
            <div class="pb-0 w-full md:w-[98%] mt-6 border-b-0 border-b-solid rounded-t-2xl items-center border-b-transparent justify-end flex">
                <div class="mr-3">
                    <input type="search" placeholder="Search here..." name="searchInput"
                        class="min-h-[46px] z-1 block w-[320px] border-blue-200 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500 [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none disabled:opacity-50 disabled:pointer-events-none"
                        v-model="searchInput" @keyup="searchEvent" />
                </div>
                <div>
                    <select
                        class="min-h-[46px] block border-blue-200 text-sm text-center w-[80px] z-50 duration-300 mb-2 bg-white rounded-lg p-2"
                        v-model="currentEntry" v-on:change="paginateEnteries">
                        <option v-for="(showEntry, indexEntry) in showEntries[1]" :key="indexEntry"
                            :value="showEntries[0][indexEntry]">
                            {{ showEntry }}
                        </option>
                    </select>
                </div>
            </div>
            <div class="overflow-x-auto shadow-md">
                <table
                    class="w-full text-sm text-left border-2 rtl:text-right text-gray-500 mx-auto mt-2 mb-2 rounded-full">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr>
                            <th scope="col" class="p-3">S.No</th>
                            <th scope="col" class="p-3">Email</th>
                            <th scope="col" class="p-3">Client Ip</th>
                            <th scope="col" class="p-3">Client Browser</th>
                            <th scope="col" class="p-3">Client Platform</th>
                            <th scope="col" class="p-3">Device Info</th>
                            <th scope="col" class="p-3">Referal Url</th>
                            <th scope="col" class="p-3">Lead From</th>
                            <th scope="col" class="p-3">Date/Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="subscribers == ''" class="odd:bg-white even:bg-slate-50 border-b">
                            <td scope="row" class="px-6 py-4 whitespace-nowrap col-span-12" colSpan={6}> No Data Found
                            </td>
                        </tr>
                        <tr v-else class="odd:bg-white even:bg-slate-50 border-b"
                            v-for="(getSubscriber, getSubscriberkey) in subscribers" :key="getSubscriberkey">
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getSubscriberkey + 1 }} </td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getSubscriber.email }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getSubscriber.clientIp }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getSubscriber.clientBrowser }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getSubscriber.clientPlatform }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getSubscriber.mobileInfo }}</td>
                            <td scope="row" class="px-6 py-4">
                                {{ getSubscriber.referalUrl }}</td>
                            <td scope="row" class="px-6 py-4">
                                {{ getSubscriber.leadFrom }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ setDate(getSubscriber.created_at) }}</td>

                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between my-2 mx-3">
                <div>
                    <p class="text-sm text-gray-700">
                        Showing
                        <span class="font-medium">{{ (totalEntries > 0 ? 1 : 0) }}</span> to
                        <span class="font-medium">{{ (totalEntries < currentEntry ? totalEntries : currentEntry) }}</span> of <span class="font-medium">{{ totalEntries }}</span> results
                    </p>
                </div>
                <div>
                    <nav class="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
                        <a href="#"
                            @click.prevent="currentPage < 2 ? (currentPage = 1) : ((currentPage -= 1), paginateEnteries())"
                            class="relative inline-flex items-center rounded-l-md px-2 py-2 text-gray-400 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0">
                            <a class="sr-only" href="#">Previous</a>
                            <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                <path fill-rule="evenodd"
                                    d="M12.79 5.23a.75.75 0 01-.02 1.06L8.832 10l3.938 3.71a.75.75 0 11-1.04 1.08l-4.5-4.25a.75.75 0 010-1.08l4.5-4.25a.75.75 0 011.06.02z"
                                    clip-rule="evenodd" />
                            </svg>
                        </a>
                        <div v-for="paginate in showPagination" :key="paginate">
                            <!-- Current: "z-10 bg-indigo-600 text-white focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600", Default: "text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:outline-offset-0" -->
                            <a aria-current="page" href="#" @click.prevent="paginateEvent(paginate)"
                                :class="`relative z-10 inline-flex items-center ${currentPage == paginate ? 'bg-blue-600 text-white' : 'text-black'} px-4 py-2 text-sm font-semibold rounded-full focus:z-20 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600`">
                                {{ paginate }}</a>
                        </div>
                        <a href="#"
                            @click.prevent="currentPage > allPages ? (currentPage = allPages) : ((currentPage += 1), paginateEnteries())"
                            class="relative inline-flex items-center rounded-r-md px-2 py-2 text-gray-400 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0">
                            <a class="sr-only" href="#">Next</a>
                            <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                                <path fill-rule="evenodd"
                                    d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z"
                                    clip-rule="evenodd" />
                            </svg>
                        </a>
                    </nav>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script>
import moment from 'moment';
import { paginate, pages, pagination, search } from 'alga-js/array';
export default {
    name: "All Response Subscribe",
    data() {
        return {
            entries: [],
            subscribers : [],
            showEntries: [
                [10, 25, 50, 150, 250, this.totalEntries],
                [10, 25, 50, 150, 250, "All"]
            ],
            currentEntry: 25,
            totalEntries: 1000,
            currentPage: 1,
            allPages: 1,
            searchInput: "",
            searchEntries: [],
            totalCounts: 0,
            unValidateNumbers: [],
            search: '',
        }
    },
    computed: {
        showPagination: function () {
            return pagination(this.allPages, this.currentPage, 3);
        },
    },
    mounted(){
        this.filterSubscriber();
    },
    methods: {
        filterSubscriber() {
            this.entries = this.$page.props.getSubscriberResponse;
            this.subscribers = this.$page.props.getSubscriberResponse.filter(item => {
                return item.email.toLowerCase().indexOf(this.search.toLowerCase()) > -1
            });
            this.paginateEnteries();
        },
        setDate(date) {
            return moment(date).format('YYYY-MM-DD HH:mm:ss');
        },
        paginateEnteries: function () {
            console.log('sdfdsf');
            if (this.searchInput.length >= 3) {
                this.searchEntries = search(this.entries, this.searchInput);
                this.paginationData(this.searchEntries);
            } else {
                this.searchEntries = [];
                this.paginationData(this.entries);
            }
        },
        paginationData: function (totalRecords) {
            this.subscribers = paginate(
                totalRecords,
                this.currentPage,
                this.currentEntry
            );
            this.allPages = pages(totalRecords, this.currentEntry);
            this.totalEntries = totalRecords.length;
        },
        paginateEvent: function (page) {
            this.currentPage = page;
            this.paginateEnteries();
        },
        searchEvent: function () {
            this.currentPage = 1;
            this.paginateEnteries();
        },
    }
}
</script>