<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import SuccessButton from '@/Components/SuccessButton.vue';
import SecondaryButton from '@/Components/SecondaryButton.vue';
import Modal from '@/Components/Modal.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import Dropdown from '@/Components/Dropdown.vue';
import TextInput from '@/Components/TextInput.vue';
</script>
<template>
    <AuthenticatedLayout>
        <div class="mx-auto w-[80%]">
            <div class="flex justify-end my-3 w-full" v-if="$page.props.auth.user.department == 1">
                <input type="text" v-model="search" placeholder="Search" class="rounded mr-3">
                <a @click="openModal()" class="bg-bgRGTBaseColor text-white p-2 rounded-md cursor-pointer">
                    <i class="fa fa-user"></i>
                    &nbsp; Add New User
                </a>
            </div>
            <div class="w-full overflow-x-auto shadow-[0_35px_60px_-15px_rgba(50_50_105_0.15),0px_1px_1px_0p_rgba(0_0_0_0.05)] border-2 mt-4 md:overflow-hidden rounded-lg mb-2">
                <table
                    class="table-auto w-full text-sm text-left rtl:text-right text-gray-500">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr>
                            <th class="p-3">User Name</th>
                            <th class="p-3">Email</th>
                            <th class="p-3">Designation</th>
                            <th class="p-3">Mobile No</th>
                            <th class="p-3">Branch</th>
                            <th class="p-3">Department</th>
                            <th class="p-3">Status</th>
                            <th class="p-3">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr 
                        v-if="filterAllUsers == '' || $page.props.auth.user.department != 1"
                        class="odd:bg-white even:bg-slate-50 border-b">
                            <td scope="row" class="px-6 py-4 whitespace-nowrap col-span-12 text-center font-bold text-red-600" colspan="12">
                                ........No Data Found........
                            </td>
                        </tr>
                        <tr v-else class="border-b odd:bg-white even:bg-slate-50"
                            v-for="(getAllUser, getAllUserkey) in filterAllUsers" :key="getAllUserkey">
                            <td class="px-6 py-4 whitespace-nowrap">
                                {{ getAllUser.userName }}</td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                {{ getAllUser.email }}</td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                {{ getAllUser.designation }}</td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                {{ getAllUser.mobileNo }}</td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                {{ getAllUser.branchName }}</td>
                            <td class="px-6 py-4 whitespace-nowrap">
                               <p class="p-1 bg-bgRGTBaseColor font-medium text-white  font-xs rounded text-center">{{ getAllUser.departmentName }}</p></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span :class="`p-1 text-xs rounded capitalize text-white font-semibold ${(getAllUser.accountStatus == 'active' ? 'bg-green-500' : 'bg-red-500' )}`">{{ getAllUser.accountStatus }}</span></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <a v-if="$page.props.auth.user.department == 1" @click="edit(getAllUser, 'edit')"><i class="fa fa-pen-to-square text-green-400 cursor-pointer mr-3"></i></a>
                                <a v-if="$page.props.auth.user.department == 1" @click="updateUserPass(getAllUser)"><i class="fa fa-key text-blue-600 cursor-pointer mr-3"></i></a>
                                <a v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'owner'" @click="edit(getAllUser, 'view')"><i class="fa fa-eye text-orange-400 cursor-pointer mr-3"></i></a>
                                <a v-if="$page.props.auth.user.department == 1" @click="destroyAgent(getAllUser, 'delete')"><i class="fa fa-trash text-red-500 cursor-pointer mr-3"></i></a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="bg-white">
                <div class="flex flex-1 mb-2 mr-4 justify-end">
                    <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer"
                        @click="closeModal()"></i>
                </div>
                <form @submit.prevent="submit" class="pb-2">
                    <div class="justify-center px-5">
                        <TextInput type="hidden" v-model="input.id" />
                        <TextInput type="hidden" v-model="viewType" />
                        <fieldset class="border p-3">
                            <legend class="text-md float-none px-3 w-[33%]">User Details</legend>
                            <div class="grid grid-cols-12 justify-center md:mb-3 md:mt-3 gap-3">
                                <div class="col-span-12 md:col-span-6 lg:col-span-4">
                                    <InputLabel value="User Name" />
                                    <TextInput type="text" class="mt-1 w-full" placeholder="User Name"
                                        v-model="input.userName" />
                                    <InputError class="mt-2" />
                                </div>
                                <div class="col-span-12 md:col-span-6 lg:col-span-4">
                                    <InputLabel value="Email" />
                                    <TextInput type="email" class="mt-1 w-full" placeholder="Email" v-model="input.email" />
                                    <InputError class="mt-2" />
                                </div>
                                <div class="col-span-12 md:col-span-6 lg:col-span-4">
                                    <InputLabel value="Designation" />
                                    <TextInput type="text" class="mt-1 w-full" placeholder="Designation"
                                        v-model="input.designation" />
                                    <InputError class="mt-2" />
                                </div>
                            </div>
                            <div class="grid grid-cols-12 justify-center md:mb-3 gap-3">
                                <div class="col-span-12 md:col-span-6 lg:col-span-4">
                                    <InputLabel value="Branch" />
                                    <Dropdown class="mt-1 w-full">
                                        <template #trigger>
                                            <select v-model="input.branchId"
                                                class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                <option v-for="(branch, branchKey) in $page.props.branches" :key="branchKey"
                                                    :value="branch.id">{{ branch.branchName }}</option>
                                            </select>
                                        </template>
                                    </Dropdown>
                                    <InputError class="mt-2" />
                                </div>
                                <div class="col-span-12 md:col-span-6 lg:col-span-4">
                                    <InputLabel value="Mobile No" />
                                    <TextInput type="text" class="mt-1 w-full" placeholder="Mobile No"
                                        v-model="input.mobileNo" />
                                    <InputError class="mt-2" />
                                </div>
                                <div class="col-span-12 md:col-span-6 lg:col-span-4">
                                    <InputLabel value="Phone No" />
                                    <TextInput type="text" class="mt-1 w-full" placeholder="Phone No"
                                        v-model="input.phoneNo" />
                                    <InputError class="mt-2" />
                                </div>
                            </div>
                            <div class="grid grid-cols-12 justify-center md:mb-3 gap-3">
                                <div v-if="viewType == 'add'" :class="`col-span-12 md:col-span-6 ${viewType == 'add' ? 'lg:col-span-3' : 'lg:col-span-4'} gap-3`">
                                    <InputLabel value="Password" />
                                    <TextInput type="text" class="mt-1 w-full" placeholder="Password"
                                        v-model="input.password" />
                                    <InputError class="mt-2" />
                                </div>
                                <div :class="`col-span-12 md:col-span-6 ${viewType == 'add' ? 'lg:col-span-3' : 'lg:col-span-4'} gap-3`">
                                    <InputLabel value="Department" />
                                    <Dropdown class="mt-1 w-full">
                                        <template #trigger>
                                            <select v-model="input.department"
                                                class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                <option value="1">All</option>
                                                <option value="2">Ticketing</option>
                                                <option value="3">Visa, International Tour</option>
                                                <option value="4">Umrah, Hajj</option>
                                                <option value="5">Consultance</option>
                                                <option value="6">IT</option>
                                                <option value="7">Marketing</option>
                                                <option value="8">Accounts</option>
                                                <option value="9">Domestic Tour</option>
                                            </select>
                                        </template>
                                    </Dropdown>
                                    <InputError class="mt-2" />
                                </div>
                                <div :class="`col-span-12 md:col-span-6 ${viewType == 'add' ? 'lg:col-span-3' : 'lg:col-span-4'} gap-3`">
                                    <InputLabel value="User Type" />
                                    <Dropdown class="mt-1 w-full">
                                        <template #trigger>
                                            <select v-model="input.userType"
                                                class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                <option value="agent">Agent</option>
                                                <option value="sub_agent">Sub Agent</option>
                                                <option value="owner">Owner</option>
                                            </select>
                                        </template>
                                    </Dropdown>
                                    <InputError class="mt-2" />
                                </div>
                                <div :class="`col-span-12 md:col-span-6 ${viewType == 'add' ? 'lg:col-span-3' : 'lg:col-span-4'} gap-3`">
                                    <InputLabel value="Status" />
                                    <Dropdown class="mt-1 w-full">
                                        <template #trigger>
                                            <select v-model="input.accountStatus"
                                                class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full">
                                                <option value="pending">Pending</option>
                                                <option value="active">Active</option>
                                                <option value="de-active">De-Active</option>
                                            </select>
                                        </template>
                                    </Dropdown>
                                    <InputError class="mt-2" />
                                </div>
                            </div>
                            <div class="grid grid-cols-12 justify-center md:mb-3 gap-3">
                                <div class="col-span-12">
                                    <label>Address</label>
                                    <textarea v-model="input.address"
                                        class="border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm w-full"> {{ input.address }}</textarea>
                                </div>
                            </div>
                        </fieldset>
                        <div class="mt-6 flex justify-end mb-3">
                            <SuccessButton class="mr-3" @click="save()" v-if="viewType === 'edit'">
                                <i class="fa fa-passport"></i> &nbsp Update User
                            </SuccessButton>
                            <SuccessButton class="mr-3" @click="save()" v-if="viewType === 'add'">
                                <i class="fa fa-passport"></i> &nbsp Create User
                            </SuccessButton>
                            <SecondaryButton @click="closeModal()"> Cancel</SecondaryButton>
                        </div>
                    </div>
                </form>
            </div>
        </Modal>
    </AuthenticatedLayout>
</template>

<script>

export default {
    name: "AllUser",
    data() {
        return {
            modalWidth: "sm:w-[100%] md:w-[50%]",
            search: '',
            viewType: "",
            isModalVisible: false,
            input: {
                id: "",
                userName: "",
                email: "",
                branchId: "",
                designation: "",
                accountStatus: "",
                password: "",
                department: "",
                userType: "",
                mobileNo: "",
                phoneNo: "",
                address: "",
                _method: 'POST'
            }
        }
    }, computed: {
        filterAllUsers() {
            return this.$page.props.users.filter(item => {
                return item.userName.toLowerCase().indexOf(this.search.toLowerCase()) > -1;
            });
        }
    },
    methods: {
        edit(getAllUser, viewType) {
            this.reset();
            this.isModalVisible = true;
            this.viewType = viewType;
            this.input = getAllUser;
            this.input._method = 'PUT';
        },
        destroyAgent(AgentDetails, viewtype) {
            if(AgentDetails.id != ""){
                this.$inertia.delete('users/destroy/'+AgentDetails.id, {
                    onSuccess: (response) => {
                        console.log(response);
                        this.$toast.success("User has been successfully Deleted!")
                    },
                })
            }else{
                this.$toast.error('User Not Found to Trash');
            }
        },
        save() {
            if (this.input._method == 'PUT') {
                this.$inertia.post('users/update', { 'formData': this.input }, {
                    onSuccess: (response) => {
                        this.isModalVisible = false;
                        this.$toast.success(this.input.userName + ' User Successfully Updated.');
                        this.reset();
                    },
                });
            } else {
                this.$inertia.post('users/add', { 'formData': this.input }, {
                    onSuccess: (response) => {
                        console.log(response);
                        this.isModalVisible = false;
                        this.$toast.success(this.input.userName + ' User Successfully Added.');
                        this.reset();
                    },
                });
            }
        },
        closeModal() {
            this.isModalVisible = false;
            this.reset();
        },
        updateUserPass(getAllUser) {
            this.$inertia.get('users/user-profile/'+getAllUser.id);
        },
        openModal() {
            this.isModalVisible = true;
            this.viewType = "add";
            this.reset();
        },
        reset() {
            this.input.value = '';
        }
    }
}
</script>