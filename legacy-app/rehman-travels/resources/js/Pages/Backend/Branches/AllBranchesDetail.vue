<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import DangerButton from '@/Components/DangerButton.vue';
import SuccessButton from '@/Components/SuccessButton.vue';
import Modal from '@/Components/Modal.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import Dropdown from '@/Components/Dropdown.vue';
import TextInput from '@/Components/TextInput.vue';
</script>
<template>
    <AuthenticatedLayout>
        <div class="mx-auto justify-center items-center w-[90%] lg:w-[80%]">
            <div class="flex justify-end m-3" v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'">
                <input type="text" v-model="search" placeholder="Search" class="rounded mr-3">
                <a @click="addBranch()" class="bg-bgRGTBaseColor text-white cursor-pointer p-2 rounded-md md:mr-3"><i class="fa fa-plus"></i> &nbsp; Add New Branch </a>
            </div>
            <div class="w-full overflow-x-auto shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15)] border-2 mt-4 md:overflow-hidden rounded-lg mb-2">
                <table class="w-full text-sm text-left rtl:text-right text-gray-500">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr class="text-center">
                            <th scope="col" class="px-6 py-3">Name </th>
                            <th scope="col" class="px-6 py-3">Address</th>
                            <th scope="col" class="px-6 py-3">Contact No</th>
                            <th scope="col" class="px-6 py-3">Type</th>
                            <th scope="col" class="px-6 py-3">Show On Home</th>
                            <th scope="col" class="px-6 py-3">Status</th>
                            <th scope="col" class="px-6 py-3">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="filteredItems == ''" class="odd:bg-white even:bg-slate-50 border-b">
                            <td
                            class="px-6 py-4 whitespace-nowrap text-center text-red-600 font-semibold text-lg"
                            colspan="12">------- No Data Found -------</td>
                        </tr>
                        <tr v-else class="odd:bg-white even:bg-slate-50"
                            v-for="(getBranch, getBranchKey) in filteredItems" :key="getBranchKey">
                            <td scope="row" class="px-6 py-4 text-center text-xs text-gray-600 w-56">
                                {{ getBranch.branchName }}</td>
                            <td scope="row" class="px-6 py-4 text-gray-600 text-xs w-80">
                                {{ getBranch.branchAddress }}</td>
                            <td scope="row" class="px-6 py-4 text-xs text-gray-900 w-30">
                                {{ getBranch.branchPhone }}</td>
                            <td scope="row" class="px-6 py-4 text-xs text-gray-900 w-30">
                                {{ (getBranch.branch_Type == 1 ? "Branch" : "Sale Point") }}</td>
                            <td scope="row" class="px-6 py-4 text-xs text-center text-gray-900">
                                {{ (getBranch.showOnHome == 1 ? 'Yes' : 'No') }}</td>
                            <td scope="row" class="px-6 py-4 text-xs text-gray-900 text-center">
                                <span :class="`${(getBranch.branchStatus == 'active' ? 'bg-green-500 text-white' : (getBranch.branchStatus == 'de-active' ? 'bg-red-500 text-white' : 'bg-yellow-500 text-black'))} p-3 font-bold rounded capitalize`">{{ getBranch.branchStatus }}</span></td>
                            <td scope="row" class="px-6 py-4 text-xs text-gray-900">
                                <a v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'" @click="edit(getBranch, 'edit')"><i
                                        class="fa fa-pen-to-square text-green-400 cursor-pointer mr-3"></i></a>
                                <a @click="edit(getBranch, 'view')"><i
                                        class="fa fa-eye text-orange-400 cursor-pointer mr-3"></i></a>
                            </td>

                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="w-full bg-gradient-to-r from-sky-800 via-sky-600 to-sky-700 mb-2">
                <div class="flex">
                    <h2 class="text-white p-1 my-auto ml-6 font-semibold text-lg">
                        Branch Details
                    </h2>
                    <div class="flex flex-1 mb-2 mr-4 justify-end">
                        <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer" @click="closeModal()"></i>
                    </div>
                </div>
            </div>
            <form @submit.prevent="submit">
                <div class="justify-center px-5">
                    <TextInput type="hidden" v-model="input.id"></TextInput>
                    <TextInput type="hidden" v-model="viewType"></TextInput>
                    <div class="md:grid md:grid-cols-12 justify-center md:mb-4">
                        <div class="block col-span-12 lg:col-span-3 md:col-span-6 xs:col-span-6 mr-3">
                            <InputLabel for="branchName" value="Name" class="text-sm"></InputLabel>
                            <TextInput id="branchName" type="text" class="mt-1 w-full capitalize placeholder:text-xs" placeholder="Name" v-model="input.branchName"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                        <div class="block col-span-12 lg:col-span-3 md:col-span-6 xs:col-span-6 mr-3">
                            <InputLabel for="branchPhone" value="Contact No" class="text-sm"></InputLabel>
                            <TextInput id="branchPhone" type="text" class="mt-1 w-full capitalize placeholder:text-xs" placeholder="Contact No" v-model="input.branchPhone"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                        <div class="block col-span-12 lg:col-span-3 md:col-span-6 xs:col-span-6 mr-3">
                            <InputLabel for="branch_Type" value="Type" class="text-sm"></InputLabel>
                            <Dropdown class="mt-1 w-full">
                                <template #trigger>
                                    <select v-model="input.branch_Type"
                                        class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                        <option value="1">Branch</option>
                                        <option value="2">Sale Point</option>
                                    </select>
                                </template>
                            </Dropdown>
                            <InputError class="mt-2"></InputError>
                        </div>
                        <div class="block col-span-12 lg:col-span-3 md:col-span-6 xs:col-span-6 mr-3">
                            <InputLabel for="showOnHome" value="Show On Home" class="text-sm"></InputLabel>
                            <Dropdown class="mt-1 w-full">
                                <template #trigger>
                                    <select v-model="input.showOnHome"
                                        class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                        <option value="1">Yes</option>
                                        <option value="0">No</option>
                                    </select>
                                </template>
                            </Dropdown>
                            <InputError class="mt-2"></InputError>
                        </div>
                    </div>
                    
                    <div class="md:grid md:grid-cols-12 justify-center md:mb-4">
                        <div class="block col-span-12 lg:col-span-3 md:col-span-6 xs:col-span-4 mr-3">
                            <InputLabel for="branchSequance" value="Sequance" class="text-sm"></InputLabel>
                            <TextInput id="branchSequance" type="text" class="mt-1 w-full capitalize placeholder:text-xs" placeholder="Sequance" v-model="input.branchSequance"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                        <div class="block col-span-12 lg:col-span-2 md:col-span-6 xs:col-span-6 mr-3">
                            <InputLabel for="branchStatus" value="Status" class="text-sm"></InputLabel>
                            <Dropdown class="mt-1 w-full">
                                <template #trigger>
                                    <select v-model="input.branchStatus"
                                        class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                        <option value="active">Active</option>
                                        <option value="pending">Pending</option>
                                        <option value="de-active">De-Active</option>
                                    </select>
                                </template>
                            </Dropdown>
                            <InputError class="mt-2"></InputError>
                        </div>
                        <div class="block col-span-12 lg:col-span-7 md:col-span-12 xs:col-span-6 mr-3">
                            <InputLabel for="mapAddress" value="Map Url" class="text-sm"></InputLabel>
                            <TextInput id="mapAddress" type="text" class="mt-1 w-full placeholder:text-xs" placeholder="Map Url" v-model="input.mapAddress"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                    </div>
                    <div class="md:grid md:grid-cols-12 justify-center md:mb-4">
                        <div class="block col-span-12 mr-3">
                            <InputLabel for="branchAddress" value="Address" class="text-sm"></InputLabel>
                            <TextInput id="branchAddress" type="text" class="mt-1 w-full capitalize placeholder:text-xs" placeholder="Address" v-model="input.branchAddress"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                    </div>
                    <div class="mt-6 flex justify-end mb-3">
                        <SuccessButton class="mr-3" @click="save()" v-if="viewType == 'edit'">
                            Update Branch
                        </SuccessButton>
                        <SuccessButton class="mr-3" @click="save()" v-if="viewType == 'add'">
                            Add Branch
                        </SuccessButton>
                        <DangerButton @click="closeModal()"> Cancel</DangerButton>
                    </div>
                </div>
            </form>
        </Modal>
    </AuthenticatedLayout>
</template>

<script>
export default {
    name: "AllBranchesDetail",
    data() {
        return {
            viewType: "",
            search: '',
            modalWidth: "sm:w-[100%] md:w-[45%]",
            input: {
                id: "",
                branchName: "",
                branchAddress: "",
                branchPhone: "",
                mapAddress: "",
                branchStatus: "active",
                showOnHome: "1",
                branch_Type: "1",
                branchSequance : "",
                method: ""
            },
            isModalVisible: false,
        }
    }, computed: {
        filteredItems () {
            return this.$page.props.branchDetails.filter(item => {
                return item.branchName.toLowerCase().indexOf(this.search.toLowerCase()) > -1
            });
        }
    },
    methods: {
        edit(branchDetails, viewType) {
            this.isModalVisible = true;
            this.viewType = viewType;
            this.input = branchDetails;
            this.input.method= "PUT";
        },
        addBranch(){
            this.reset();
            this.isModalVisible = true;
            this.viewType = "add";
            this.input.method= "POST";
        },
        save() {
            this.$inertia.post('branches/store', { 'formData': this.input }, {
                onSuccess: (response) => {
                    console.log(response);
                    this.isModalVisible = false;
                    this.reset();
                    this.$toast.success(this.input.branchName +' created Successfull! 👍');
                },
            });
        },
        closeModal() {
            this.isModalVisible = false;
            this.reset();
        },
        reset() {
            Object.assign(this.$data, this.$options.data());
        }

    }
}
</script>