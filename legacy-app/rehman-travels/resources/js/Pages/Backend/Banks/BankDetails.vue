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
        <section class="">
            <div class="flex justify-end m-3" v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'">
                <input type="text" v-model="search" placeholder="Search" class="rounded mr-3">
                <a @click="addBranch()" class="bg-bgRGTBaseColor text-white p-2 rounded-md md:mr-3"><i
                        class="fa fa-plus"></i> &nbsp Add New Bank </a>
            </div>
            <div class="overflow-x-auto shadow-md">
                <table
                    class="w-full md:w-[98%] text-sm text-left border-2 rtl:text-right text-gray-500 mx-auto mt-2 mb-2 rounded-full">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr>
                            <th scope="col" class="p-3">S.No</th>
                            <th scope="col" class="p-3">Bank Name </th>
                            <th scope="col" class="p-3">Account Title</th>
                            <th scope="col" class="p-3">Branch Code</th>
                            <th scope="col" class="p-3">Account No</th>
                            <th scope="col" class="p-3">IBAN No</th>
                            <th scope="col" class="p-3">Swift Code</th>
                            <th scope="col" class="p-3">Contact No</th>
                            <th scope="col" class="p-3">Status</th>
                            <th scope="col" class="p-3">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="filteredBank == ''" class="odd:bg-white even:bg-slate-50 border-b">
                            <td scope="row" class="px-6 py-4 whitespace-nowrap col-span-12" colSpan={6}> No Data Found</td>
                        </tr>
                        <tr v-else class="odd:bg-white even:bg-slate-50 border-b"
                            v-for="(getBankDetail, getBankDetailKey) in filteredBank" :key="getBankDetailKey">
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getBankDetailKey + 1 }} </td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getBankDetail.bankName }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getBankDetail.accountTitle }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getBankDetail.branchCode }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getBankDetail.accountNo }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getBankDetail.ibanNo }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getBankDetail.swiftCode }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ getBankDetail.contactNo }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ (getBankDetail.bankStatus == 1 ? 'Active' : 'De-Active') }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                <a v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'" @click="edit(getBankDetail, 'edit')"><i
                                        class="fa fa-pen-to-square text-green-400 cursor-pointer mr-3"></i></a>
                                <a @click="edit(getBankDetail, 'view')"><i
                                        class="fa fa-eye text-orange-400 cursor-pointer mr-3"></i></a>
                            </td>

                        </tr>
                    </tbody>
                </table>
            </div>
        </section>
        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="flex flex-1 mb-2 mr-4 justify-end">
                <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer" @click="closeModal()"></i>
            </div>
            <div class="w-full bg-gradient-to-r from-sky-800 via-sky-600 to-sky-700 mt-2 mb-2">
                <div>
                    <h2 class="text-white p-1 ml-6 font-semibold text-lg">
                        Bank Account Details
                    </h2>
                </div>
            </div>
            <form @submit.prevent="submit">
                <div class="px-5">
                    <TextInput type="hidden" v-model="input.id"></TextInput>
                    <TextInput type="hidden" v-model="viewType"></TextInput>
                    <TextInput type="hidden" v-model="input.bankLogoName"></TextInput>
                    <div class="md:flex md:flex-1 gap-2 md:mb-4">
                        <div class="block col-span-12 lg:col-span-3 md:col-span-4 xs:col-span-6">
                            <InputLabel for="bankName" value="Bank Name"></InputLabel>
                            <TextInput id="bankName" type="text" class="mt-1 w-full capitalize" placeholder="Branch Name" v-model="input.bankName"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                        <div class="block col-span-12 lg:col-span-3 md:col-span-4 xs:col-span-6">
                            <InputLabel for="accountTitle" value="Account Title"></InputLabel>
                            <TextInput id="accountTitle" type="text" class="mt-1 w-full capitalize" placeholder="Account Title" v-model="input.accountTitle"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                        <div class="block col-span-12 lg:col-span-3 md:col-span-4 xs:col-span-6">
                            <InputLabel for="branchCode" value="Branch Code"></InputLabel>
                            <TextInput id="branchCode" type="text" class="mt-1 w-full capitalize" placeholder="Branch Code" v-model="input.branchCode"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                        <div class="block col-span-12 lg:col-span-3 md:col-span-4 xs:col-span-6">
                            <InputLabel for="accountNo" value="Account No"></InputLabel>
                            <TextInput id="accountNo" type="text" class="mt-1 w-full capitalize" placeholder="Account No" v-model="input.accountNo"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                        <div class="block col-span-12 lg:col-span-2 md:col-span-4 xs:col-span-6">
                            <InputLabel for="bankStatus" value="Bank Status"></InputLabel>
                            <Dropdown class="mt-1 w-full">
                                <template #trigger>
                                    <select v-model="input.bankStatus"
                                        class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                        <option value="1">Active</option>
                                        <option value="0">De-Active</option>
                                    </select>
                                </template>
                            </Dropdown>
                            <InputError class="mt-2"></InputError>
                        </div>
                    </div>
                    <div class="md:mb-4 md:flex md:flex-1 gap-2 ">
                        <div class="block col-span-12 lg:col-span-3 md:col-span-4 xs:col-span-6 md:w-[25%]">
                            <InputLabel for="bankLogo" value="Bank Logo"></InputLabel>
                            <TextInput id="bankLogo" type="file" :onChange="(e) => { input.bankLogo = e.target.files[0]; input.bankLogoName = e.target.files[0].name;}" class="mt-1" placeholder="Bank Logo"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                        <div class="block col-span-12 lg:col-span-3 md:col-span-4 xs:col-span-6">
                            <InputLabel for="ibanNo" value="IBAN No"></InputLabel>
                            <TextInput id="ibanNo" type="text" class="mt-1 w-full" placeholder="IBAN No" v-model="input.ibanNo"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                        <div class="block col-span-12 lg:col-span-3 md:col-span-4 xs:col-span-6">
                            <InputLabel for="swiftCode" value="Swift Code"></InputLabel>
                            <TextInput id="swiftCode" type="text" class="mt-1 w-full" placeholder="Swift Code" v-model="input.swiftCode"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                        <div class="block col-span-12 lg:col-span-2 md:col-span-4 xs:col-span-6">
                            <InputLabel for="contactNo" value="Contact No"></InputLabel>
                            <TextInput id="contactNo" type="text" class="mt-1 w-full" placeholder="Contact No" v-model="input.contactNo"></TextInput>
                            <InputError class="mt-2"></InputError>
                        </div>
                    </div>
                    <div class="mt-6 md:flex justify-end mb-3">
                        <SuccessButton class="mr-3 md:mb-0 mb-3" @click="save()" v-if="viewType == 'edit'">
                            Update Bank Details
                        </SuccessButton>
                        <SuccessButton class="mr-3" @click="save()" v-if="viewType == 'add'">
                            Add Bank Details
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
    name: "BankDetails",
    props: {
        bankDetails: { type: Object }
    },
    data() {
        return {
            viewType: "",
            search : '',
            modalWidth: "sm:w-[100%] md:w-[65%]",
            input: {
                id: "",
                bankName: "",
                accountTitle: "",
                branchCode: "",
                accountNo: "",
                ibanNo: "",
                swiftCode: "",
                contactNo: "",
                bankStatus: "",
                bankLogo: "",
                bankLogoName: "",
                method: ""
            },
            isModalVisible: false,
        }
    },
    computed: {
        filteredBank () {
            return this.bankDetails.filter(item => {
                return item.bankName.toLowerCase().indexOf(this.search.toLowerCase()) > -1
            });
        }
    },
    methods: {
        edit(bankAccounts, viewType) {
            this.isModalVisible = true;
            this.viewType = viewType;
            this.input = bankAccounts;
            this.input.method = "PUT";
        },
        addBranch() {
            this.isModalVisible = true;
            this.viewType = "add";
            this.reset();
        },
        save() {
            this.$inertia.post('bankAccounts/store', { 'formData': this.input }, {
                onSuccess: (response) => {
                    console.log(response);
                    this.isModalVisible = false;
                    this.reset();
                    this.$toast.success(this.input.bankName +' created successfully.');
                },
            });
        },
        closeModal() {
            this.isModalVisible = false;
        },
        reset() {
            Object.assign(this.$data, this.$options.data());
        }
    }
}
</script>