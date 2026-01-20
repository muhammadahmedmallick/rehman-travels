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
                    <button @click="filterLeads()" class="bg-bgRGTBaseColor text-white py-2 px-4 mr-2 rounded-md">
                        <i class="fa fa-search"></i>
                    </button>
                    <button @click="reset()" class="bg-red-600 cursor-pointer text-white py-2 px-4 mr-2 rounded-md">
                        <i class="fa fa-recycle"></i>
                    </button>
                </div>
                <div class="justify-end mt-14 cursor-pointer">
                    <input type="text" v-model="search" placeholder="Search by Contact #" class="rounded mr-3 border border-gray-300">
                </div>
            </div>
            <LoadingBar v-if="loading" />
            <p class="mt-5 mr-1 float-right relative"><strong>{{ (filterActiveLeads.length > 0 ? "Showing 1 of "+ filterActiveLeads.length : '') }}</strong></p>
            <div class="w-full overflow-x-auto shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] border-2 mt-1 md:overflow-hidden rounded-lg mb-2">
                <table class="table-auto w-full text-sm text-left rtl:text-right text-gray-500">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr colspan="12">
                            <th class="p-3">Name</th>
                            <th class="p-3">City</th>
                            <th class="p-3">Check In</th>
                            <th class="p-3">Check Out</th>
                            <th class="p-3">Nights</th>
                            <th class="p-3">Rooms</th>
                            <th class="p-3">Total Passengers</th>
                            <th class="p-3">Created</th>
                            <th class="p-3">Action</th>
                        </tr>
                    </thead>
                    <tbody class="w-full">
                        <tr v-if="filterActiveLeads == ''" class="border-b odd:bg-white even:bg-slate-50">
                            <td
                                class="px-6 py-4 whitespace-nowrap text-center text-red-600 font-semibold text-lg"
                                colspan="12">------- No Data Found -------</td>
                        </tr>
                        <tr colspan="12" v-else class="border-b odd:bg-white even:bg-gray-100" v-for="(hotelConfirmation, hotelConfirmationkey) in filterActiveLeads"
                            :key="hotelConfirmationkey">
                            <td class="px-6 py-2 text-xs whitespace-nowrap"> {{ hotelConfirmation.name }}</td>
                            <td class="px-6 py-2 text-xs"> {{ hotelConfirmation.city }}</td>
                            <td class="px-6 py-2 cursor-pointer">
                                <span class="text-xs"> {{ hotelConfirmation.check_in }}</span>
                            </td>
                            <td class="px-6 py-2">
                                <span class="text-xs"> {{ hotelConfirmation.check_out }}</span>
                            </td>
                            <td class="px-6 py-2">
                                <span class="text-xs"> {{ hotelConfirmation.t_nights }}</span>
                            </td>
                            <td class="px-6 py-2">
                                <span class="text-xs"> {{ hotelConfirmation.t_rooms }}</span>
                            </td>
                            <td class="px-6 py-2">
                                <span class="text-xs"> {{ (hotelConfirmation.t_adults > 0 ? 'Adults(s): '+ hotelConfirmation.t_adults +',' : '' ) }} {{ (hotelConfirmation.t_childs > 0 ? 'Child(s): '+ hotelConfirmation.t_childs : '' ) }}</span>
                            </td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap"> {{ hotelConfirmation.created_at }}</td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap cursor-pointer" @click="openModal(hotelConfirmation)">
                                <i class="fa fa-eye text-yellow-500"></i>
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
import Service from "@/Config/Service.js";
export default {
    name: 'HotelBookings',
    props: {
        confirmationDetails: { type: Object }
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
                name: '',
                city : '',
                vendor : '',
                group_code : '',
                hotel_code : '',
                check_in : '',
                check_out : '',
                t_nights : '',
                t_rooms : '',
                t_adults : '',
                t_childs : '',
                created_at : '',
            },
            filter: {
                from: '',
                to: ''
            }
        }
    },
    computed: {
        filterActiveLeads() {
            return this.activeLeads();
        }
    },
    methods : {
        activeLeads(){
            return this.confirmationDetails.filter(item => {
                return item.name.toLowerCase().indexOf(this.search.toLowerCase()) > -1
                || item.city.toLowerCase().indexOf(this.search.toLowerCase()) > -1;
            });
        },
        filterLeads(){
            this.loading = true;
            this.$inertia.post('/manage-hotel/leads', this.filter, {
                onSuccess: (response) => {
                    console.log(response);
                    this.loading = false;
                },
            });
        },
        closeModal(){
            this.isModalVisible = false;
        },
        reset(){
            Object.assign(this.$data, this.$options.data());
        },
        // openModal(data){
        //     this.reset();
        //     this.isModalVisible = true;
        //     this.inputData = data;
        //     this.htlCcl = data.cancelStatus;
        //     Service.doFetchRequest("/manage-hotel/bookings-hotel", '', data['hotelDetails']).then((resp) => {
        //         this.inputData.hotelName = resp['hotelInfo'].name;
        //     });
        // }
    }
}
</script>