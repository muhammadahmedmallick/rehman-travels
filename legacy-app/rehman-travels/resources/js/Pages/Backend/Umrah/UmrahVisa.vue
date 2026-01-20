<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import SuccessButton from '@/Components/SuccessButton.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import Dropdown from '@/Components/Dropdown.vue';
import TextInput from '@/Components/TextInput.vue';
import Modal from '@/Components/Modal.vue';
import SecondaryButton from '@/Components/SecondaryButton.vue';
</script>
<template>
    <AuthenticatedLayout>
        <div class="">
            <div class="flex justify-end m-3" v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'">
                <input type="text" v-model="search" placeholder="Search" class="rounded mr-3">
                <a @click="openModel()" class="bg-bgRGTBaseColor text-white p-2 rounded-md"><i
                        class="fa fa-plus"></i> &nbsp Add New UmrahVisa </a>
            </div>
            <div class="overflow-x-auto shadow-md">
                <table class="w-full md:w-[98%] text-sm text-left border-2 rtl:text-right text-gray-500 mx-auto mt-2 mb-2 rounded-full">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                    <tr>
                        <th scope="col" class="p-3">umrah Visa Name</th>
                        <th scope="col" class="p-3">Period From</th>
                        <th scope="col" class="p-3">Period To</th>
                        <th scope="col" class="p-3">Visa Price</th>
                        <th scope="col" class="p-3">Nationality</th>
                        <th scope="col" class="p-3">Status</th>
                        <th scope="col" class="p-3">Created At</th>
                        <th scope="col" class="p-3">Updated At</th>
                        <th scope="col" class="p-3">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-if="filterUmrahVisa == ''" class="odd:bg-white even:bg-slate-50 border-b">
                        <td scope="row"
                            class="px-6 py-4 whitespace-nowrap col-span-12"
                            colSpan={6}> No Data Found</td>
                    </tr>
                    <tr v-else class="border-b odd:bg-white even:bg-slate-50" v-for="(UmrahVisa,UmrahVisakey) in filterUmrahVisa" :key="UmrahVisakey">
                        <td scope="row" class="px-6 py-4 text-xs"> {{ UmrahVisa['umrahVisaName'] }}</td>
                        <td scope="row" class="px-6 py-4 text-xs"> {{ UmrahVisa['umrahVisaPeriodFrom'] }}</td>
                        <td scope="row" class="px-6 py-4 text-xs"> {{ UmrahVisa['umrahVisaPeriodTo'] }}</td>
                        <td scope="row" class="px-6 py-4 text-xs"> {{ UmrahVisa['umrahVisaPrice'] }}</td>
                        <td scope="row" class="px-6 py-4 text-xs"> {{ UmrahVisa['umrahVisaNationality'] }}</td>
                        <td scope="row" class="px-6 py-4 text-xs"> {{ (UmrahVisa['umrahVisaPriceStatus'] == 1 ? 'Active' : 'De-active')}}</td>
                        <td scope="row" class="px-6 py-4 text-xs line-clamp-3 w-32 truncate"> {{ Date("DD-MM-YYYY h:i:s", UmrahVisa['created_at']) }}</td>
                        <td scope="row" class="px-6 py-4 text-xs"> {{ UmrahVisa['updated_at'] }}</td>
                        <td scope="row" class="px-6 py-4 whitespace-nowrap"> 
                            <a  v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'"
                            @click="edit(UmrahVisa)"><i class="fa fa-pen-to-square text-green-400 cursor-pointer mr-3"></i></a>
                            <a><i class="fa fa-eye text-orange-400 cursor-pointer mr-3"></i></a>
                            <a  v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'owner'"
                             @click="removeUmrahVisa(UmrahVisa['id'])"><i class="fa fa-trash text-red-600 cursor-pointer"></i></a>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
                <div class="flex flex-1 mb-2 mr-4 justify-end">
                    <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer"
                       @click="closeModal()"></i>
                </div>
                <form @submit.prevent="submit">
                    <div class="justify-center px-5">
                        <TextInput
                            type="hidden"
                            v-model="input[0].id"
                        />
                        <TextInput
                            type="hidden"
                            v-model="viewType"
                        />
                        
                        <fieldset class="border p-3">
                            <legend class="text-md float-none px-3 w-[33%]">UmrahVisa Details</legend>
                            <div class="grid grid-cols-12 justify-center md:mb-3 md:mt-3 gap-3">
                                <div class="sm:col-span-12 md:col-span-6 lg:col-span-4">
                                    <InputLabel value="Visa Name"/>
                                    <TextInput
                                        type="text"
                                        class="mt-1 w-full"
                                        placeholder="Visa Name"
                                        v-model="input[0].umrahVisaName"
                                    />

                                    <InputError class="mt-2"/>
                                </div>
                                <div class="sm:col-span-12 md:col-span-6 lg:col-span-4">
                                    <InputLabel value="Visa Price"/>
                                    <TextInput
                                        type="text"
                                        class="mt-1 w-full"
                                        placeholder="Visa Price"
                                        v-model="input[0].umrahVisaPrice"
                                    />

                                    <InputError class="mt-2"/>
                                </div>
                                <div class="sm:col-span-12 md:col-span-6 lg:col-span-4">
                                    <InputLabel value="Nationality"/>
                                    <Dropdown
                                        class="mt-1 w-full">
                                        <template #trigger>
                                            <select
                                                v-model="input[0].umrahVisaNationality"
                                                class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                <option value="Pakistan">Pakistan</option>
                                                <option value="Others">Others</option>
                                            </select>
                                        </template>
                                    </Dropdown>
                                    <InputError class="mt-2"/>
                                </div>
                            </div>
                            <div class="grid grid-cols-12 justify-center md:mb-3 gap-3">
                                <div class="sm:col-span-12 md:col-span-6 lg:col-span-4">
                                    <InputLabel value="Period From"/>
                                    <TextInput
                                        type="date"
                                        class="mt-1 w-full"
                                        placeholder="Period From"
                                        v-model="input[0].umrahVisaPeriodFrom"
                                    />

                                    <InputError class="mt-2"/>
                                </div>
                                <div class="sm:col-span-12 md:col-span-6 lg:col-span-4">
                                    <InputLabel value="Period To"/>
                                    <TextInput
                                        type="date"
                                        class="mt-1 w-full"
                                        placeholder="Period to"
                                        v-model="input[0].umrahVisaPeriodTo"
                                    />

                                    <InputError class="mt-2"/>
                                </div>
                                <div class="sm:col-span-12 md:col-span-6 lg:col-span-4 gap-3">
                                    <InputLabel value="Status"/>
                                    <Dropdown
                                        class="mt-1 w-full">
                                        <template #trigger>
                                            <select
                                            v-model="input[0].umrahVisaPriceStatus"
                                                class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                <option value="1">Active</option>
                                                <option value="0">De-Active</option>
                                            </select>
                                        </template>
                                    </Dropdown>
                                    <InputError class="mt-2"/>
                                </div>
                            </div>
                        </fieldset>
                        <div class="mt-6 flex justify-end mb-3">
                            <SuccessButton
                                class="mr-3"
                                @click="save()"
                                v-if="viewType === 'edit'"
                            >
                            <i class="fa fa-passport"></i> &nbsp Update Umrah Visa
                            </SuccessButton>
                            <SuccessButton
                                class="mr-3"
                                @click="save()"
                                v-if="viewType === 'add'"
                            >
                            <i class="fa fa-passport"></i> &nbsp Create Umrah Visa
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
    name: "UmrahVisa",
    data(){
        return {
            modalWidth : "sm:w-[100%] md:w-[45%]",
            viewType:"",
            isModalVisible: false,
            search : '',
            input: [{
                id : "",
                umrahVisaName : "",
                umrahVisaPeriodFrom : "",
                umrahVisaPeriodTo : "",
                umrahVisaPrice : "",
                umrahVisaNationality : "",
                umrahVisaPriceStatus : ""
            }],
        }
    }, computed: {
        filterUmrahVisa(){
            return this.$page.props.UmrahVisa.filter(item => {
                return item.umrahVisaName.toLowerCase().indexOf(this.search.toLowerCase()) > -1;
            });
        }
    }, 
    methods: {
        edit: function(umrahVisa){
            this.isModalVisible = true;
            this.viewType = "edit";
            this.input[0] = umrahVisa;
        },
        closeModal: function(){
            this.isModalVisible = false;
        },
        save: function(){
            if(this.input[0].id != "" && this.input[0].id != null){
                this.$inertia.put('visas-update', {'updateVisaDetail' : this.input},{
                    onSuccess: (response) => {
                        console.log(response);
                        this.$toast.success(this.input[0].umrahVisaName + ' is updated successfully.');
                    },
                    onFinish: ()=> {
                        this.isModalVisible = false;
                        this.reset();
                    }
                })
            }else{
                console.log('add');
                this.$inertia.post('visas-create', this.input,{
                    onSuccess: (response) => {
                        this.$toast.success(this.input[0].umrahVisaName + ' is added successfully.');
                        this.isModalVisible = false;
                        this.reset();
                    }
                })
            }

        },
        removeUmrahVisa: function(id){
            if(confirm('Are you sure while Removing Umrah Visa')){
                this.$inertia.delete('visa-delete/'+id,{
                    onSuccess: (response) => {
                        this.$toast.error(this.input[0].umrahVisaName + ' is added successfully.');
                    }
                });
            }
        },
        openModel: function (){
            this.reset();
            this.isModalVisible = true;
            this.viewType = "add";
        },
        reset: function() {
            Object.assign(this.$data, this.$options.data());
            this.viewType = "";
        }
    }
}
</script>