<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import LoadingBar from "@/Pages/Website/Ticketing/LoadingBar.vue";
</script>

<template>
    <AuthenticatedLayout>
        <div class="mx-auto justify-center items-center w-[90%] 2xl:w-[80%]">
            <div class="flex justify-end mr-4 w-full">
                <div class="mt-14 cursor-pointer">
                    <input type="text" v-model="search" placeholder="Search by Contact #" class="rounded mr-3 border border-gray-300">
                </div>
            </div>
            <LoadingBar v-if="loading" />
            <p class="mt-5 mr-1 float-right relative"><strong>{{ (filterHotels.length > 0 ? "Showing 1 of "+ filterHotels.length : '') }}</strong></p>
            <div class="w-full overflow-x-auto shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] border-2 mt-1 md:overflow-hidden rounded-lg mb-2">
                <table class="table-auto w-full text-sm text-left rtl:text-right text-gray-500">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr colspan="12">
                            <th class="p-3">Name</th>
                            <th class="p-3">Rating</th>
                            <th class="p-3">Code</th>
                            <th class="p-3">Address </th>
                            <th class="p-3">City</th>
                            <th class="p-3">Vendor</th>
                            <th class="p-3">Created By</th>
                            <th class="p-3">Created At</th>
                            <th class="p-3">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="w-full">
                        <tr v-if="filterHotels == ''" class="border-b odd:bg-white even:bg-slate-50">
                            <td
                                class="px-6 py-4 whitespace-nowrap text-center text-red-600 font-semibold text-lg"
                                colspan="12">------- No Data Found -------</td>
                        </tr>
                        <tr colspan="12" v-else class="border-b odd:bg-white even:bg-gray-100" v-for="(hotel, hotelkey) in filterHotels"
                            :key="hotelkey">
                            <th class="px-6 py-2 text-xs whitespace-nowrap"> {{ hotel.name }}</th>
                            <td class="px-6 py-2 text-xs whitespace-nowrap"> {{ hotel.star_rating }} Stars</td>
                            <td class="px-6 py-2 text-xs"> {{ hotel.code }}</td>
                            <td class="px-6 py-2 cursor-pointer">
                                <span class="text-xs">{{ hotel.address }}</span>
                            </td>
                            <td class="px-6 py-2">
                                <span class="text-xs"> {{ hotel.city }}</span>
                            </td>
                            <td class="px-6 py-2">
                                <span class="text-xs"> {{ hotel.vendor }}</span>
                            </td>
                            <td class="px-6 py-2">
                                <span class="text-xs"><b>{{ hotel.created_by }} </b></span>
                            </td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap"> {{ hotel.created_at }}</td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap cursor-pointer">
                                <i class="fa fa-eye text-yellow-500 text-base" title="View Details"></i>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script>
import Modal from '@/Components/Modal.vue';
export default {
    name: 'hotels',
    props: {
        hotels: { type: Object }
    },
    data(){
        return {
            isModalVisible: false,
            modalWidth: "w-[75%]",
            search:'',
            hover: '',
            loading: false,
            htlCcl : 0,
            inputData: {
                firstName: '',
                email: '',
                mobileNo: '',
                message: '',
                hotelName: '',
                check_in: '',
                check_out: '',
            },
            filter: {
                from: '',
                to: '',
                option : ''
            }
        }
    },
    computed: {
        filterHotels() {
            return this.manageHotels();
        }
    },
    methods : {
        manageHotels(){
            return this.hotels.filter(item => {
                return item.name.toLowerCase().indexOf(this.search.toLowerCase()) > -1
            });
        },
        closeModal(){
            this.isModalVisible = false;
        },
        reset(){
            Object.assign(this.$data, this.$options.data());
        },
        openModal(data){
            this.reset();
            this.isModalVisible = true;
            this.inputData = data;
            this.htlCcl = data.cancelStatus;
        },
    }
}
</script>