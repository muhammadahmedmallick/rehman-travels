<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import LoadingBar from "@/Pages/Website/Ticketing/LoadingBar.vue";
</script>

<template>
    <AuthenticatedLayout>
        <div class="mx-auto justify-center items-center w-[90%] 2xl:w-[80%]">
            <div class="flex justify-end mr-4 w-full">
                <div class="mt-14 cursor-pointer">
                    <button class="bg-bgRGTBaseColor mr-2 px-3 py-2 text-white font-semibold rounded" @click="openModal">Add Markup</button>
                    <input type="text" v-model="search" placeholder="Search by Vendor" class="rounded mr-3 border border-gray-300">
                </div>
            </div>
            <LoadingBar v-if="loading" />
            <p class="mt-5 mr-1 float-right relative"><strong>{{ (filterMarkup.length > 0 ? "Showing 1 of "+ filterMarkup.length : '') }}</strong></p>
            <div class="w-full overflow-x-auto shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] border-2 mt-1 md:overflow-hidden rounded-lg mb-2">
                <table class="table-auto w-full text-sm text-left rtl:text-right text-gray-500">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr colspan="12">
                            <th class="p-3">Vendor</th>
                            <th class="p-3">Markup Value</th>
                            <th class="p-3">Converted Value</th>
                            <th class="p-3">Markup Type</th>
                            <th class="p-3">Markup Status</th>
                            <th class="p-3">Created By</th>
                            <th class="p-3">Created At</th>
                            <th class="p-3">Action</th>
                        </tr>
                    </thead>
                    <tbody class="w-full">
                        <tr v-if="filterMarkup == ''" class="border-b odd:bg-white even:bg-slate-50">
                            <td
                                class="px-6 py-4 whitespace-nowrap text-center text-red-600 font-semibold text-lg"
                                colspan="12">------- No Data Found -------</td>
                        </tr>
                        <tr colspan="12" v-else class="border-b odd:bg-white even:bg-gray-100" v-for="(hotelMarkup, hotelMarkupkey) in filterMarkup"
                            :key="hotelMarkupkey">
                            <td class="px-6 py-2">
                                <span class="text-xs"> {{ hotelMarkup.vendor }}</span>
                            </td>
                            <td class="px-6 py-2 text-xs"> {{ hotelMarkup.markup_value }} {{ (hotelMarkup.markup_type == 'fixed' ? 'PKR' : '%') }}</td>
                            <td class="px-6 py-2">
                                <span class="text-xs">{{ hotelMarkup.converted_value }} {{ hotelMarkup.currency_code }}</span>
                            </td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap uppercase font-bold"> {{ hotelMarkup.markup_type }}</td>
                            <td class="px-6 py-2 cursor-pointer">
                                <span :class="`${hotelMarkup.markup_status == 1 ? 'bg-green-600' : 'bg-red-600'} text-xs px-2 py-1 rounded text-white font-bold`">
                                    {{ (hotelMarkup.markup_status == 1 ? 'Active' : 'De-Active') }}
                                </span>
                            </td>
                            <td class="px-6 py-2">
                                <span class="text-xs"> {{ hotelMarkup.created_user }}</span>
                            </td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap"> {{ hotelMarkup.created_at }}</td>
                            <td class="px-6 py-2 text-xs whitespace-nowrap cursor-pointer">
                                <i class="fa fa-eye text-yellow-500" @click="editModal(hotelMarkup)"></i>
                                <i class="fa fa-trash text-red-500 ml-1" @click="removeRow(hotelMarkup)"></i>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
            <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
                <div class="sticky top-0 flex flex-1 mb-2 mr-4 justify-end">
                    <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer"
                        @click="closeModal()"></i>
                </div>
                <div class="relative w-[95%] mx-auto bg-white">
                    <div class="w-full bg-gradient-to-r from-sky-800 via-sky-600 to-sky-700 mt-2">
                        <div>
                            <h2 class="text-white p-1 ml-1 font-semibold text-lg">
                                {{type == 'add' ? 'Add' : 'Update' }} Markup
                            </h2>
                        </div>
                    </div>
                    <div class="px-4 py-2 mx-auto mt-8">
                        <form class="w-full" @submit.prevent="submit">
                            <div class="grid grid-cols-4 gap-3">
                                <div class="col-span-3">
                                    <label
                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                        for="vendor">
                                        Vendor
                                    </label>
                                    <input
                                    placeholder="Vendor Name"
                                    type="text" id="vendor" name="vendor" v-model="input.vendor"
                                    class="appearance-none placeholder:text-slate-400 placeholder:text-sm block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    />
                                </div>
                                <div class="col-span-1">
                                    <label
                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                        for="markup_type">
                                        Markup Type
                                    </label>
                                    <select @change="changeCurrency()"
                                        class="block appearance-none w-full h-10 border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                        v-model="input.markup_type">
                                        <option value="fixed">Fixed</option>
                                        <option value="percentage">Percentage</option>
                                    </select>
                                </div>
                                <div class="col-span-1">
                                    <label for="markup_value"
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    >
                                    Markup {{ (input.markup_type == 'fixed' ? '(PKR)' : '%') }}
                                    </label>
                                    <input
                                    placeholder="Markup Value" @input="changeCurrency()"
                                    type="text" id="markup_value" name="markup_value" v-model="input.markup_value"
                                    class="appearance-none placeholder:text-slate-400 placeholder:text-sm block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    />
                                </div>
                                <div class="col-span-2" v-if="input.markup_type == 'fixed'">
                                    <label for="converted_value"
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    >
                                    Converted Rate({{ input.currency_code }})
                                    </label>
                                    <input
                                    placeholder="Converted Value"
                                    type="text" id="converted_value" name="converted_value" v-model="input.converted_value"
                                    class="appearance-none placeholder:text-slate-400 placeholder:text-sm block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    />
                                </div>
                                <div class="col-span-1">
                                    <label
                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                        for="markup_status">
                                        Status
                                    </label>
                                    <select
                                        class="block appearance-none w-full h-10 border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                        v-model="input.markup_status">
                                        <option value="0">De-Active</option>
                                        <option value="1">Active</option>
                                    </select>
                                </div>
                            </div>
                            <div class="md:flex justify-end m-3">
                                <SuccessButton class="md:mr-3">{{type == 'add' ? 'Add' : 'Update' }} Markup</SuccessButton>
                                <DangerButton @click="closeModal()">Close</DangerButton>
                            </div>
                        </form>
                    </div>
                </div>
            </Modal>
    </AuthenticatedLayout>
</template>

<script>
import Modal from '@/Components/Modal.vue';
import { mapState } from "vuex";
import HotelCurrencyConverter from "@/Config/HotelCurrencyConverter.js";
import SuccessButton from "@/Components/SuccessButton.vue";
import DangerButton from "@/Components/DangerButton.vue";
export default {
    name: 'Hotel Markup',
    props: {
        markups: { type: Object }
    },
    data(){
        return {
            isModalVisible: false,
            modalWidth: "sm:w-[100%] md:w-[40%] 2xl:w-[33%]",
            search:'',
            hover: '',
            type: 'add',
            loading: false,
            input: {
                id: '',
                markup_type : 'fixed',
                markup_value : '',
                markup_status : 0,
                currency_id: 1,
                currency_rate: 0,
                currency_code: '',
                converted_value: 0,
                vendor: '',
                created_by : '',
                updated_by : '',
            },
            filter: {
                from: '',
                to: ''
            }
        }
    },
    computed: {
        ...mapState(['currency']),
        filterMarkup() {
            return this.activeMarkup();
        }
    },
    methods : {
        activeMarkup(){
            return this.markups.filter(item => {
                return item.markup_type.toLowerCase().indexOf(this.search.toLowerCase()) > -1
                || item.markup_value.toLowerCase().indexOf(this.search.toLowerCase()) > -1
                || item.vendor.toLowerCase().indexOf(this.search.toLowerCase()) > -1;
            });
        },
        filterMarkups(){
            this.loading = true;
            this.$inertia.post('/hotel-markup/markup', this.filter, {
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
        openModal(){
            this.reset();
            this.type='add';
            this.isModalVisible = true;
        },
        editModal(data){
            this.reset();
            this.type='update';
            this.isModalVisible = true;
            this.input = data;
        },
        changeCurrency(){
            console.log(this.input.markup_type)
            if(this.input.markup_type == 'fixed'){
                let currencies = this.$page.props.currencies;
                if(this.input.currency_id && this.input.markup_value){
                    for(let currencyIndex in currencies){
                        if(currencies[currencyIndex].id == this.input.currency_id){
                            this.input.currency_rate = currencies[currencyIndex].currencyRate
                            this.input.currency_code = currencies[currencyIndex].currencyCode
                            this.input.converted_value = this.setConverter(parseInt(this.input.markup_value), this.input.currency_rate, currencies[currencyIndex].currencyCode);
                        }
                    }
                }
            }else{
                this.input.currency_id = 0;
                this.input.currency_rate = 0;
                this.input.currency_code = '';
                this.input.converted_value = 0;
            }
        },
        submit(){
            if(this.type == 'add'){
                this.input.created_by = this.$page.props.auth.user.id;
               this.$inertia.post('store', {'input' : this.input}, {
                    onSuccess: (response) => {
                        console.log(response);
                        this.isModalVisible = false;
                        this.filterMarkups();
                    },
               });
            }else{
                this.input.updated_by = this.$page.props.auth.user.id;
                this.$inertia.post('update', {'input' : this.input}, {
                        onSuccess: (response) => {
                        this.isModalVisible = false;
                        this.filterMarkups();
                    },
                });
            }
        },
        removeRow(data){
            if(confirm('Are you sure you want to delete')){
                this.$inertia.delete('delete/'+ data.id, {
                        onSuccess: (response) => {
                        this.isModalVisible = false;
                        this.filterMarkups();
                    },
                });
            }
        },
        setConverter(amount, currencyRate, currencyCode) {
            console.log(amount, currencyRate, currencyCode);
            let getPKCurrency = this.$page.props.currencies[3];
            if (currencyCode != "PKR") {
                return HotelCurrencyConverter.doRequest(amount, currencyRate, getPKCurrency.currencyRate);
            } else {
                return eval(amount).toFixed();
            }
        },
    }
}
</script>