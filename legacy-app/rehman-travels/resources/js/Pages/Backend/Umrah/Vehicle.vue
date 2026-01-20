<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import SuccessButton from '@/Components/SuccessButton.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import Modal from '@/Components/Modal.vue';
import SecondaryButton from '@/Components/SecondaryButton.vue';
import Dropdown from '@/Components/Dropdown.vue';
import TextInput from '@/Components/TextInput.vue';
import Service from "@/Config/Service";
</script>
<template>
    <AuthenticatedLayout>
        <div class="mx-auto justify-center items-center w-[90%] lg:w-[80%]">
            <div class="flex justify-between m-3" v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'">
                <div class="justify-start">
                    <form @submit.prevent class="flex gap-6 items-center" v-if="inputTransportMarkup.transport.selectedTransportIds != ''">
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Markup Type</label>
                            <select v-model="inputTransportMarkup.markupInput.markup_type" class="border border-gray-300 text-gray-900 rounded-lg focus:shadow-[0_0_0_.25rem_rgba(10,173,10,.25)] focus:ring-green-600 focus:ring-0 focus:border-green-600 block p-2 px-3 disabled:opacity-50 disabled:pointer-events-none w-full text-base mt-2">
                                <option value="percentage">Percentage</option>
                                <option value="fixed">Flat</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Markup Value</label>
                            <input type="number" v-model="inputTransportMarkup.markupInput.markup_value" class="w-full border border-gray-300 text-gray-900 rounded-lg focus:shadow-[0_0_0_.25rem_rgba(10,173,10,.25)] focus:ring-green-600 focus:ring-0 focus:border-green-600 block p-2 px-3 disabled:opacity-50 disabled:pointer-events-none text-base mt-2" />
                        </div>
                        <div class="mt-7 items-center">
                            <button type="submit" @click="updateSelectedTransportMarkup"
                                class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition">Submit</button>
                        </div>
                    </form>
                </div>
                <div class="justify-end items-center">
                    <input type="text" v-model="search" placeholder="Search Sector Name" class="border border-gray-300 text-gray-900 rounded-lg focus:shadow-[0_0_0_.25rem_rgba(10,173,10,.25)] focus:ring-green-600 focus:ring-0 focus:border-green-600 placeholder:text-base placeholder:text-gray-400 mr-3 w-80">
                    <a @click="openSectorModal()" class="bg-bgRGTBaseColor text-white p-2 rounded-md mx-3 cursor-pointer"><i
                        class="fa fa-plus"></i> &nbsp; Add New Sector </a>
                </div>
                <div v-if="proceed"
                    class="absolute -translate-x-1/2 -translate-y-1/2 top-2/4 left-1/2 z-50">
                    <svg aria-hidden="true" class="w-16 h-16 text-gray-200 animate-spin fill-blue-600"
                        viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path
                            d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
                            fill="currentColor" />
                        <path
                            d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
                            fill="currentFill" />
                    </svg>
                    <span class="sr-only">Loading...</span>
                </div>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full md:w-[98%] text-sm text-left border-2 rtl:text-right text-gray-500 mx-auto mt-2 mb-2 rounded-full">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                    <tr>
                        <th scope="col" class="p-3 text-center whitespace-nowrap">
                            <input 
                                type="checkbox" 
                                class="border border-gray-400 rounded-md focus:border-white" 
                                :checked="selectAll"
                                @change="toggleAll"
                            />
                        </th>
                        <th scope="col" class="p-3 text-center whitespace-nowrap">Sector Id</th>
                        <th scope="col" class="p-3 text-center whitespace-nowrap">Sector Name</th>
                        <th scope="col" class="p-3 text-center whitespace-nowrap">Transport Included</th>
                        <th scope="col" class="p-3 text-center whitespace-nowrap">Sector Status</th>
                        <th scope="col" class="p-3 text-center whitespace-nowrap">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-if="filterVehicles == ''" class="odd:bg-white even:bg-slate-50 border-b">
                        <td scope="row" class="px-6 py-4 whitespace-nowrap col-span-12" colSpan={6}> No Data Found</td>
                    </tr>
                    <tr v-else class="odd:bg-white even:bg-slate-50 border-b" v-for="(vehicleDetails, vehiclekey) in filterVehicles" :key="vehiclekey">
                        <td scope="row" class="px-6 py-4 text-gray-900 text-xs w-10">
                            <input 
                                type="checkbox" :id="vehiclekey"
                                :checked="inputTransportMarkup.transport.selectedTransportIds.includes(vehicleDetails.sectorId)"
                                @change="toggleTransportSelection(vehicleDetails.sectorId)"
                                class="border border-gray-400 rounded-md"
                            />
                        </td>
                        <td scope="row" class="px-6 py-4 text-xs text-center"> {{ vehicleDetails.sectorId }}</td>
                        <td scope="row" class="px-6 py-4 text-xs w-72"> {{ vehicleDetails.sectorName }}</td>
                        <td scope="row" class="px-6 py-4 text-xs"> <span v-if="vehicleDetails.vehicle" v-for="(vehicle, vehicleIndex) in vehicleDetails.vehicle" :key="vehicleIndex" class="border border-blue-400 border-dashed mx-1 p-1 rounded-sm">{{ vehicle.vehicleName }} </span></td>
                        <td scope="row" class="px-6 py-4 text-xs text-center"> {{ (vehicleDetails.sectorStatus == 1 ? 'Active' : 'De-active') }}</td>
                        <td scope="row" class="px-6 py-4 text-center whitespace-nowrap"> 
                            <a v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'"
                            @click="edit(vehicleDetails,'edit')"><i class="fa fa-pen-to-square text-green-400 cursor-pointer mr-3"></i></a>
                            <a @click="edit(vehicleDetails,'view')"><i class="fa fa-eye text-orange-400 cursor-pointer mr-3"></i></a>
                            <a
                            @click="removeUmrahVisa(vehicleDetails['id'])"><i class="fa fa-trash text-red-600 cursor-pointer"></i></a>
                        </td>

                    </tr>
                    </tbody>
                </table>
            </div>
            <!-- New Sector -->
            <Modal :show="isSectorVisible" @close="closeModal" :modalWidth="modalWidth">
                <div class="flex flex-1 mb-2 mr-4 justify-end">
                    <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer"
                       @click="closeModal()"></i>
                </div>
                <form @submit.prevent="submit">
                    <div class="justify-center px-5">
                        <fieldset class="border p-1">
                            <legend class="text-md float-none px-3 w-[45%] lg:w-[28%] bg-bgRGTBaseColor text-white rounded-sm font-semibold">Umrah New Sector Details</legend>
                            <div class="grid grid-cols-12 md:mb-4 gap-3">
                                <div class="sm:col-span-12 md:col-span-6 lg:col-span-6">
                                    <InputLabel class="text-sm" value="Sector"/>
                                    <TextInput
                                        type="text"
                                        class="mt-1 w-full text-sm"
                                        placeholder="Sector Name"
                                        v-model="sector.sectorName"
                                    />

                                    <InputError class="mt-2" v-if="error.sectorName != ''" :value="error.sectorName"/>
                                </div>
                                <div class="sm:col-span-12 md:col-span-6 lg:col-span-3">
                                    <InputLabel class="text-sm" value="Status"/>
                                    <Dropdown
                                        class="mt-1 w-full">
                                        <template #trigger>
                                            <select
                                            v-model="sector.sectorStatus"
                                                class="border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                <option value="1">Active</option>
                                                <option value="0">De-Active</option>
                                            </select>
                                        </template>
                                    </Dropdown>
                                    <InputError class="mt-2" v-if="error.sectorStatus != ''" :value="error.sectorStatus"/>
                                </div>
                            </div>
                            <div class="md:grid md:grid-cols-12 md:mb-3 gap-3" v-for="(umrahVehicle, umrahVehicleIndex) in sector.vehicle" :key="umrahVehicleIndex">
                                <div class="sm:col-span-12 md:col-span-6 lg:col-span-3 pt-8">
                                    <span class="text-sm">{{ umrahVehicleIndex + 1 }}) &nbsp;</span>
                                    <InputLabel class="mt-8 w-full text-sm" :value="umrahVehicle.vehicleName"/>
                                    <InputError class="mt-2"/>
                                </div>
                                <div class="sm:col-span-12 md:col-span-6 lg:col-span-2">
                                    <InputLabel class="text-sm" value="Vehicle Price"/>
                                    <TextInput
                                        type="number"
                                        class="mt-1 w-full text-sm"
                                        placeholder="Actual Price"
                                        @input="calculateNewSecMarkup(sector.vehicle[umrahVehicleIndex].vehiclePrice, sector.vehicle[umrahVehicleIndex].vehicleSectorMarkup, umrahVehicleIndex)"
                                        v-model="sector.vehicle[umrahVehicleIndex].vehiclePrice"
                                    />

                                    <InputError class="mt-2" v-if="error.vehiclePrice != ''" :value="error.vehiclePrice"/>
                                </div>
                                <div class="sm:col-span-12 md:col-span-6 lg:col-span-2">
                                    <InputLabel class="text-sm" value="Markup %"/>
                                    <TextInput
                                        type="number"
                                        class="mt-1 w-full text-sm"
                                        placeholder="Markup %"
                                        @input="calculateNewSecMarkup(sector.vehicle[umrahVehicleIndex].vehiclePrice, sector.vehicle[umrahVehicleIndex].vehicleSectorMarkup, umrahVehicleIndex)"
                                        v-model="sector.vehicle[umrahVehicleIndex].vehicleSectorMarkup"
                                    />

                                    <InputError class="mt-2" v-if="error.vehicleSectorMarkup != ''" :value="error.vehicleSectorMarkup"/>
                                </div>
                                <div class="sm:col-span-12 md:col-span-6 lg:col-span-2">
                                    <InputLabel class="text-sm" value="Price With %"/>
                                    <TextInput
                                        type="number"
                                        class="mt-1 w-full text-sm"
                                        placeholder="Price With %"
                                        disabled="disabled"
                                        v-model="sector.vehicle[umrahVehicleIndex].vehicleSectorMrkPrice"
                                    />
                                    <InputError class="mt-2" v-if="error.vehicleSectorMarkup != ''" :value="error.vehicleSectorMarkup" />
                                </div>
                            </div>
                        </fieldset>
                        <div class="mt-6 flex justify-end mb-3">
                            <SuccessButton
                                class="mr-3"
                                @click="save()"
                                v-if="viewType === 'add'"
                            >
                            <i class="fa fa-car-alt"></i> &nbsp; Add
                            </SuccessButton>
                            <SuccessButton
                                class="mr-3"
                                @click="save()"
                                v-else
                            >
                            <i class="fa fa-car-alt"></i> &nbsp; Update
                            </SuccessButton>
                            <SecondaryButton @click="closeModal()"> Cancel</SecondaryButton>
                        </div>
                    </div>
                </form>
            </Modal>
        </div>
    </AuthenticatedLayout>
</template>

<script>
export default {
    name: "vehicles",
    props:{
        vehicles:{type:Object},
        umrahVehicle : {type:Object}
    },
    data(){
        return {
            modalWidth : "sm:w-[100%] md:w-[55%]",
            viewType:"add",
            isSectorVisible: false,
            search : '',
            selectAll: false,
            proceed: false,
            sector:{
                id:"",
                sectorName: "",
                sectorStatus: "1",
                vehicle: []
            },
            inputTransportMarkup: {
                markupInput:{
                    markup_type : 'fixed',
                    markup_value : '',
                    markup_status : '1',
                    vendor: 'umrah-Transport',
                    created_by : '',
                },
                transport:{
                    selectedTransportIds: []
                }
            },
            error:{
                sectorName : "",
                sectorStatus : "",
                vehiclePrice : "",
                vehicleSectorMarkup : "",
                vehicleSectorMrkPrice : "",
                vehiclePriceStatus :""
            }
        }
    },
    computed: {
        filterVehicles(){
            return this.vehicles.filter(item => {
                return item.sectorName.toLowerCase().indexOf(this.search.toLowerCase()) > -1;
            });
        }
    }, 
    methods: {
        toggleAll() {
            if (this.selectAll) {
            this.inputTransportMarkup.transport.selectedTransportIds = [];
            } else {
            this.inputTransportMarkup.transport.selectedTransportIds = this.vehicles.map(vehicle => vehicle.id);
            }
            this.selectAll = !this.selectAll;
        },
        toggleTransportSelection(transportId) {
            const index = this.inputTransportMarkup.transport.selectedTransportIds.indexOf(transportId);
            if (index === -1) {
                this.inputTransportMarkup.transport.selectedTransportIds.push(transportId);
                this.selectAll = this.inputTransportMarkup.transport.selectedTransportIds.length === this.vehicles.length;
            } else {
                this.inputTransportMarkup.transport.selectedTransportIds.splice(index, 1);
            }
        },
        calculateMarkup(price,markup){
            console.log(price, markup);
            if(this.input.vehicleSectorMarkup != 0){
                const roomMarkup = Math.round((markup * price) / 100);
                const roomMarkupPrice = parseInt(price) + parseInt(roomMarkup);
                this.input.vehicleSectorMrkPrice = roomMarkupPrice;
            }else{
                this.input.vehicleSectorMrkPrice = price;
            }
        },
        calculateNewSecMarkup(price,markup, index){
            console.log(price, markup, index);
            if(price != 0 && markup != 0){
                const roomMarkup = Math.round((markup * price) / 100);
                console.log(roomMarkup);
                const roomMarkupPrice = parseInt(price) + parseInt(roomMarkup);
                console.log(roomMarkupPrice);
                this.sector.vehicle[index].vehicleSectorMrkPrice = roomMarkupPrice;
            }else{
                this.sector.vehicle[index].vehicleSectorMrkPrice = price;
            }
        },
        removeUmrahVisa: function(id){
            if(confirm('Are you sure while Removing Umrah Visa')){
                console.log(id);
                this.$inertia.delete('delete-sectortransportPrice/'+id, {
                    onSuccess: (response) => {

                    },
                    onFinish: () => {
                        console.log('Delete Successfully')
                    }
                });
            }
        },
        edit: function(umrahTransportDetail,viewTypes){
            this.isSectorVisible = true;
            this.viewType = viewTypes;
            this.sector = umrahTransportDetail;
        },
        closeModal: function(){
            this.isSectorVisible = false;
        },
        openSectorModal(){
            this.reset();
            this.isSectorVisible = true;
            this.umrahVehicle.forEach( vehicleDetails => {
                this.sector.vehicle.push({
                    vehicleId: vehicleDetails.id,
                    vehicleName: vehicleDetails.vehicleName,
                    vehiclePrice : 0,
                    vehicleSectorMarkup : 10,
                    vehicleSectorMrkPrice : 0,
                    vehiclePriceStatus : '1'
                });
            });
            this.viewType = "add";
        },
        save(){
            console.log(this.sector);
            if(this.sector.id != ""){
                this.proceed = true;
                this.inputTransportMarkup.markupInput.created_by = this.$page.props.auth.user.id;
                Service.doRequest("/UmrahDashboard/update-sectortransportPrice", 'PUT', this.sector)
                .then((data) => {
                    if(!data.error){
                        this.isSectorVisible = false;
                        this.$toast.success(data.message);
                        window.location.href= 'vehicle-sector-price';
                        this.reset();
                    }else{
                        this.$toast.error(data.message);
                    }
                    this.proceed = false;
                });
            }else{
                this.proceed = true;
                this.inputTransportMarkup.markupInput.created_by = this.$page.props.auth.user.id;
                Service.doRequest("/UmrahDashboard/create-newsectortransportPrice", 'POST', this.sector)
                .then((data) => {
                    if(!data.error){
                        this.isSectorVisible = false;
                        this.$toast.success(data.message);
                        window.location.href= 'vehicle-sector-price';
                        this.reset();
                    }else{
                        this.$toast.error(data.message);
                    }
                    this.proceed = false;
                });
            }
        },
        reset: function() {
            Object.assign(this.$data, this.$options.data());
            this.viewType = "add";
        },
        updateSelectedTransportMarkup(){
            if (!this.inputTransportMarkup.transport.selectedTransportIds.length) {
                alert("Please select at least one checkbox.");
                return;
            }
            this.proceed = true;
            this.inputTransportMarkup.markupInput.created_by = this.$page.props.auth.user.id;
            Service.doRequest("/UmrahDashboard/add-selected-transport-markup", 'POST', this.inputTransportMarkup)
            .then((data) => {
                if(!data.error){
                    this.$toast.success(data.message);
                    window.location.href= 'vehicle-sector-price';
                }else{
                    this.$toast.error(data.message);
                }
                this.proceed = false;
            });
        }
    },
}
</script>