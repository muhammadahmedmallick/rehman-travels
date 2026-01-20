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
                        <select v-model="filter.option" class="rounded mr-3 border border-gray-300">
                            <option value=""></option>
                            <option class="text-green-700" value="2">Confirmed</option>
                            <option class="text-red-700" value="4">Cancelled</option>
                        </select>
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
                            <th class="p-3">Lead Pax Name</th>
                            <th class="p-3">Hotel</th>
                            <th class="p-3">Check In/Out</th>
                            <th class="p-3">Markup </th>
                            <th class="p-3">Nights / Rooms</th>
                            <th class="p-3">Total Passengers</th>
                            <th class="p-3">Net</th>
                            <th class="p-3">Status</th>
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
                        <tr colspan="12" v-else class="border-b odd:bg-white even:bg-gray-100" v-for="(hotelBooking, hotelBookingkey) in filterActiveLeads" :key="hotelBookingkey">
                            <th class="px-6 py-2 text-xs whitespace-nowrap"> {{ hotelBooking.isLead }}</th>
                            <td class="px-6 py-2 text-xs whitespace-nowrap"> {{ hotelBooking['hotelDetails'].name }}</td>
                            <td class="px-6 py-2 text-xs"> {{ hotelBooking['shoppingDetails'].check_in }} /  {{ hotelBooking['shoppingDetails'].check_out }}</td>
                            <td class="px-6 py-2 cursor-pointer">
                                <span class="text-xs">{{ hotelBooking.markup }} - {{ hotelBooking.markupType }}</span>
                            </td>
                            <td class="px-6 py-2">
                                <span class="text-xs"> Nights:{{ hotelBooking['shoppingDetails'].t_nights }} - Rooms: {{ hotelBooking['shoppingDetails'].t_rooms }}</span>
                            </td>
                            <td class="px-6 py-2">
                                <span class="text-xs"> {{ (hotelBooking['shoppingDetails'].t_adults > 0 ? 'Adults(s): '+ hotelBooking['shoppingDetails'].t_adults +',' : '' ) }} {{ (hotelBooking['shoppingDetails'].t_childs > 0 ? 'Child(s): '+ hotelBooking['shoppingDetails'].t_childs : '' ) }}</span>
                            </td>
                            <td class="px-6 py-2">
                                <span class="text-xs"><b>{{ hotelBooking.d_currency }} - {{ hotelBooking.eqnet }}</b></span>
                            </td>
                            <td class="px-6 py-2">
                                <span :class="`${(hotelBooking.status == '2' && hotelBooking.cancelStatus == '2' ? 'text-green-500' : 'text-red-600')} font-bold`">{{ (hotelBooking.status == '2' && hotelBooking.cancelStatus == '2' ? 'Confirmed' : 'Cancelled') }}</span>
                            </td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap"> {{ hotelBooking.created_at }}</td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap cursor-pointer">
                                <i class="fa fa-eye text-yellow-500 text-base" @click="openModal(hotelBooking)" title="View Details"></i>
                                <i class="fa fa-window-close text-red-600 ml-1 text-lg" v-if="hotelBooking.status == '2' && hotelBooking.cancelStatus == '2'" @click="cancelShopping(hotelBooking)" title="Cancel Reservation"></i>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="w-full justify-between bg-[#52525B] flex">
                <div class="flex flex-1 uppercase my-2 ml-4 justify-start text-white font-bold text-xl">
                    Hotel Booking Details
                </div>
                <div class="flex flex-1 mb-2 mr-4 justify-end">
                    <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer"
                        @click="closeModal()"></i>
                </div>
            </div>
            <div class="w-full px-4 overflow-x-auto md:overflow-hidden rounded-lg mb-3" id="printDiv">
                <LoadingBar v-if="loading" />
                <table class="w-full shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] text-sm text-left text-gray-500 mt-3">
                    <tbody>
                        <tr>
                            <th colspan="7">
                                <img src="/ticketing/header-img.webp" alt="header-img.webp" class="w-full">
                            </th>
                        </tr>
                        <tr>
                            <td class="flex justify-between *:font-bold">
                                <span class="justify-start text-xs">
                                    Booking Id: {{ inputData['booking_id'] }}
                                </span>
                                <span class="justify-end text-xs">
                                    Created at: {{ inputData['created_at'] }}
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] text-sm text-left text-gray-500 my-3">
                    <thead class="text-xs text-white uppercase bg-[#006ee3]">
                        <tr>
                            <th class="px-6 py-2 print:py-2 mx-auto text-center text-base print:text-sm">
                                Confirmation No
                            </th>
                            <th class="px-6 py-2 print:py-2 mx-auto text-center text-base print:text-sm">
                                Confirmation Status
                            </th>
                            <th class="px-6 py-2 print:py-2 mx-auto text-center text-base print:text-sm">
                                Adult(s)
                            </th>
                            <th class="px-6 py-2 print:py-2 mx-auto text-center text-base print:text-sm">
                                Child(s)
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border">
                            <td class="p-1 mx-auto text-center font-bold">
                                {{ inputData.bckConfirmId }}
                            </td>
                            <td class="p-1 mx-auto text-center">
                                <span :class="`${(inputData.status == '2' && inputData.cancelStatus == '2' ? 'text-green-500' : 'text-red-600')} font-bold`">{{ (inputData.status == '2' && inputData.cancelStatus == '2' ? 'Confirmed' : 'Cancelled') }}</span>
                            </td>
                            <td class="p-1 mx-auto text-center">
                                {{ inputData['shoppingDetails'].t_adults }}
                            </td>
                            <td class="p-1 mx-auto text-center">
                                {{ inputData['shoppingDetails'].t_childs }}
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] text-sm text-left text-gray-500 my-3">
                    <thead class="text-xs text-white uppercase bg-[#006ee3]">
                        <tr class="*:print:py-2">
                            <th class="px-6 py-2 text-base print:text-sm">
                                Hotel Info
                            </th>
                            <th class="px-6 py-2 text-base print:text-sm" v-if="inputData['hotelRoomDetails'].room_name !== ''">
                                Room Details
                            </th>
                            <th class="px-6 py-2 text-base print:text-sm">
                                Contact Details
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border">
                            <td class="px-6 py-4 print:px-2 print:py-1 *:pb-1 *:print:text-xs align-baseline">
                                <span><b>Hotel Name: </b> &nbsp;{{inputData['hotelDetails'].name}}</span><br />
                                <span><b>City: </b> &nbsp;{{inputData['hotelDetails'].city}}</span><br />
                                <span><b>Check-In/Out: </b> &nbsp;{{ inputData['shoppingDetails'].check_in }}</span><br />
                                <span><b>Check Out: </b> &nbsp;{{ inputData['shoppingDetails'].check_out }}</span><br />
                                <span><b>Nights: </b> &nbsp;{{ inputData['shoppingDetails'].t_nights }}</span><br />
                                <span><b>Rooms: </b> &nbsp;{{ inputData['shoppingDetails'].t_rooms }}</span>
                            </td>
                            <td class="px-6 py-4 print:px-2 print:py-1 *:pb-1 *:print:text-xs align-baseline" v-if="inputData['hotelRoomDetails'].room_name !== ''">
                                <span><b>Room Name :</b> {{ inputData['hotelRoomDetails'].room_name }}</span><br />
                                <span><b>Meal :</b> {{ inputData['hotelRoomDetails'].meal }}</span><br />
                                <span class="flex"><b>Rate Type :&nbsp;</b> <p :class="`${(inputData['hotelRoomDetails'].rate_type == 'Refundable' ? 'text-green-500' : 'text-red-600')} font-bold`">{{ inputData['hotelRoomDetails'].rate_type }}</p></span>
                                <span><b>Status  :</b> {{ inputData['hotelRoomDetails'].status }}</span>
                            </td>
                            <td class="px-6 py-4 print:px-2 print:py-1 *:pb-1 *:print:text-xs *:items-start align-baseline">
                                <span><b>Mobile No: </b> &nbsp;{{ inputData['customerInfo'].mobileNo }}</span><br />
                                <span><b>Email: </b> &nbsp;{{ inputData['customerInfo'].email }}</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="w-full shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] text-sm text-left text-gray-500 my-3">
                    <thead class="text-xs text-white uppercase bg-[#006ee3]">
                        <tr>
                            <th class="px-6 py-2 mx-auto text-center text-base print:text-sm" col="{12}">
                                Room Details
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border">
                            <td class="flex mx-auto text-center" col="{12}">
                                <table v-for="(roomGuests, roomGuestsIndex) in inputData['roomGuests']" :key="roomGuestsIndex"
                                    class="w-full border text-center text-sm text-gray-500"
                                >
                                    <thead class="text-white uppercase bg-[#da2d44]">
                                        <th class="py-1 text-xs">
                                            <b>Room {{ roomGuestsIndex+1 }}</b>
                                        </th>
                                    </thead>
                                    <tbody>
                                        <td class="flex flex-col *:pb-1 print:p-1 px-6 py-4 items-baseline text-center justify-center *:print:text-xs">
                                            <span v-for="(roomGuest, roomGuestIndex) in roomGuests" :key="roomGuestIndex"><b>{{ roomGuestIndex+1 + ')' }}</b> &nbsp; {{ roomGuest.guestName }} {{ (roomGuest.age > 0 ? "("+ roomGuest.age + "Years" + ")" : '') }}</span>
                                        </td>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <img src="/assets/Hotels/shopping-cancelled.png" alt="Cancel Hotel"
                v-if="htlCcl == '4'"
                    class="rounded-md object-cover absolute top-80 left-1/2 transform -translate-x-1/2 -rotate-[14deg] w-80 h-80 md:w-96 md:h-96" />
                <table class="w-full shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] text-sm text-left text-gray-500 my-3">
                    <thead class="text-xs text-white uppercase bg-[#006ee3]">
                        <tr>
                            <th class="px-6 py-3 print:py-2 mx-auto text-center text-base print:text-sm" col="{12}">
                                Payment Details
                            </th>
                        </tr>
                        <tr></tr>
                    </thead>
                    <tbody class="border">
                        <tr class="bg-white border-b">
                            <td class="px-6 print:px-0 py-4 print:py-0 *:pr-9 *:print:p-2 *:print:text-xs flex flex-row">
                                <span><b>Base Fare :</b> {{ inputData.gross }}</span>
                                <span><b>Tax :</b> {{ inputData.tax }}</span>
                                <span><b>Total Fare :</b> {{ inputData.net }}</span>
                                <span><b>Default Currency  :</b> {{ inputData.d_currency }}</span>
                                <span><b>Currency Rate  :</b> {{ inputData.d_currency_rate }} (1$ in PKR)</span>
                            </td>
                        </tr>
                        <tr class="bg-white border-b" v-if="inputData.markup !== 0">
                            <td class="px-6 print:px-0 py-4 print:py-0 *:pr-9 *:print:p-2 *:print:text-xs flex flex-row">
                                <span><b>EqBase Fare :</b> {{ inputData.eqgross }}</span>
                                <span><b>EqTax :</b> {{ inputData.eqtax }}</span>
                                <span><b>EqTotal Fare :</b> {{ inputData.eqnet }}</span>
                                <span><b>Markup  :</b> {{ inputData.markup }}</span>
                                <span><b>Markup Type  :</b> {{ inputData.markupType }}</span>
                            </td>
                        </tr>
                        <tr class="bg-white border-b">
                            <td class="px-6 print:px-0 py-4 print:py-0 *:pr-9 *:print:p-2 *:print:text-xs flex flex-row">
                                <span v-if="inputData.d_currency !== inputData.s_currency"><b>Selected Currency  :</b> {{ inputData.s_currency }}</span>
                                <span v-if="inputData.d_currency !== inputData.s_currency"><b>Selected Rate  :</b> {{ inputData.s_currency_rate }}</span>
                                <span v-if="inputData.d_currency !== inputData.s_currency"><b>Selected Total  :</b> {{ inputData.s_currency }} - {{ setConverter(inputData.eqnet, inputData.s_currency, inputData.s_currency_rate, inputData.d_currency_rate) }}</span>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="7">
                                <img src="/ticketing/footer-img.webp" alt="footer-img.webp" class="w-full">
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="flex items-center justify-center">
                    <button v-if="htlCcl != '4'" class="px-6 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 shadow-md w-full sm:w-auto print:hidden" @click="cancelShopping(inputData)">Cancel Booking</button>
                    <button class="justify-center px-6 py-2 bg-bgRGTBaseColor text-white rounded-lg hover:bg-red-600 shadow-md w-full sm:w-auto print:hidden ml-3" v-print="'#printDiv'">Print</button>
                </div>
            </div>
            <p class="text-slate-300 text-sm pr-5 mb-2 float-right"> Created at: {{ inputData.created_at }}</p>
        </Modal>
    </AuthenticatedLayout>
</template>

<script>
import { mapState } from "vuex";
import Modal from '@/Components/Modal.vue';
import Service from "@/Config/Service.js";
export default {
    name: 'HotelBookings',
    props: {
        hotelBookings: { type: Object }
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
        ...mapState(['currency']),
        filterActiveLeads() {
            return this.activeLeads();
        }
    },
    methods : {
        setConverter(amount, sCurrency, currentRate, defaultRate) {
            let getUAECurrency = this.$page.props.currencies[0]
            if (sCurrency !== "USD") {
                return (sCurrency === 'PKR' ? (eval(amount * getUAECurrency.currencyRate) / currentRate).toFixed(2) : (eval(amount * defaultRate) / currentRate).toFixed(2) )
            } else {
                return eval(amount).toFixed()
            }
        },
        activeLeads(){
            return this.hotelBookings.filter(item => {
                return item.isLead.toLowerCase().indexOf(this.search.toLowerCase()) > -1
                || item.d_currency.toLowerCase().indexOf(this.search.toLowerCase()) > -1
                || item.hotelDetails.name.toLowerCase().indexOf(this.search.toLowerCase()) > -1
                || item.hotelDetails.city.toLowerCase().indexOf(this.search.toLowerCase()) > -1
            });
        },
        filterLeads(){
            this.loading = true;
            this.$inertia.post('/manage-hotel/bookings', this.filter, {
                onSuccess: (response) => {
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
        openModal(data){
            this.reset();
            this.isModalVisible = true;
            this.inputData = data;
            this.htlCcl = data.cancelStatus;
        },
        cancelShopping(data){
            let guestCancellationPayload = {
                'cfrm' : data.bckConfirmId,
                'rooms' : data.shoppingDetails.t_rooms,
                'bck' : data.booking_id,
                'hotelSessionId': data.shoppingDetails.session_id,
            };
            let text = "Are you sure, You want to Cancel the Hotel!";
            if (confirm(text) == true) {
                this.loading = true;
                Service.doFetchRequest("/manage-hotel/cancellationShopping", '', guestCancellationPayload).then((resp) => {
                    if(!resp.error){
                        this.htlCcl = resp.status;
                        this.$toast.success(resp.message);
                    }else{
                        this.htlCcl = resp.status;
                        this.$toast.error(resp.message);
                    }
                    this.loading = false;
                    this.filterLeads();
                });
            }
        }
    }
}
</script>