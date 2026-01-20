<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import Modal from '@/Components/Modal.vue';
import moment from "moment";
import LoadingBar from "@/Pages/Website/Ticketing/LoadingBar.vue";
</script>
<template>
    <AuthenticatedLayout>
        <div class="mx-auto justify-center items-center w-[90%] 2xl:w-[80%]">
            <div class="flex justify-end m-3" v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'">
                <input type="text" v-model="search" placeholder="Search" class="rounded mr-3 border border-gray-400" />
                <a @click="openModal" class="bg-bgRGTBaseColor text-white p-2 rounded-md md:mr-3 cursor-pointer"><i
                class="fa fa-plus"></i> &nbsp; Add New Client Details  </a>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full md:w-[98%] text-sm text-left border-2 rtl:text-right text-gray-500 mx-auto mt-2 mb-2 rounded-full">
                    <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                        <tr>
                            <th scope="col" class="p-3">S.No</th>
                            <th scope="col" class="p-3">Name</th>
                            <th scope="col" class="p-3">Mobile No</th>
                            <th scope="col" class="p-3">City</th>
                            <th scope="col" class="p-3">Remarks</th>
                            <th scope="col" class="p-3">Agent</th>
                            <th scope="col" class="p-3">Created At</th>
                            <th scope="col" class="p-3">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-if="filterConsentForm == ''" class="odd:bg-white even:bg-slate-50 border-b">
                            <td scope="row"
                                class="px-6 py-4 whitespace-nowrap col-span-12"
                                colSpan={6}> No Data Found</td>
                        </tr>
                        <tr v-else class="odd:bg-white even:bg-slate-50 border-b"
                            v-for="(clientDetails, clientDetailsKey) in filterConsentForm" :key="clientDetailsKey">
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ clientDetailsKey + 1 }} </td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ clientDetails.customer.firstName }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ clientDetails.customer.mobileNo }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ clientDetails.customer.address }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ clientDetails.message }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ clientDetails.users.userName }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                {{ dateFormate(clientDetails.created_at) }}</td>
                            <td scope="row" class="px-6 py-4 whitespace-nowrap">
                                <a @click="edit(clientDetails, 'view')"><i
                                        class="fa fa-eye text-orange-400 cursor-pointer mr-3"></i></a>
                            </td>

                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="flex flex-1 mb-2 mr-4 justify-end">
                <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer"
                    @click="closeModal()"></i>
            </div>
            <div  @submit.prevent class="mx-auto p-10 mt-10" id="printDiv">
                <form class="space-y-6">
                    <div class="flex gap-6">
                        <div class="w-1/2 flex items-center">
                            <label class="text-gray-700 font-medium w-12">Date:</label>
                            <input type="text" v-model="input.contents.date" readonly="readonly"
                                class="flex-1 border-0 border-b-2 border-gray-400 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer bg-transparent" />
                        </div>
                        <div class="w-1/2 flex items-center">
                            <label class="text-gray-700 font-medium w-8">City:</label>
                            <input type="text" v-model="input.customers.address"
                                class="ml-4 flex-1 border-0 border-b-2 border-gray-400 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer bg-transparent" />
                        </div>
                    </div>

                    <div class="flex gap-6">
                        <div class="w-1/2 flex items-center">
                            <label class="text-gray-700 font-medium w-12">Name:</label>
                            <input type="text" v-model="input.customers.firstName"
                                class="ml-4 flex-1 border-0 border-b-2 border-gray-400 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer bg-transparent" />
                        </div>
                        <div class="w-1/2 flex items-center">
                            <label class="text-gray-700 font-medium w-12">Phone:</label>
                            <input type="tel" v-model="input.customers.mobileNo"
                                class="ml-4 flex-1 border-0 border-b-2 border-gray-400 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer bg-transparent" />
                        </div>
                    </div>

                    <div>
                        <label class="block text-gray-700 font-medium">Remarks:</label>
                        <textarea v-model="input.contents.message" rows="5"
                            class="w-full border-2 border-gray-400 focus:outline-none focus:ring focus:ring-blue-300 p-2 rounded-md resize-none"></textarea>
                    </div>

                    <div class="flex justify-end">
                        <div class="w-1/2 flex items-center">
                            <label class="text-gray-700 font-medium w-24 print:w-56">Agent Name & Signature:</label>
                            <input type="text" v-model="input.contents.agent"
                                class="ml-4 flex-1 font-bold border-0 border-b-2 border-gray-400 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer bg-transparent" />
                        </div>
                    </div>

                    <div class="flex justify-end space-x-4">
                        <button v-print="'#printDiv'" v-if="isPrintVisible" class="bg-rose-500 print:hidden text-white py-2 px-6 rounded-md hover:bg-blue-600">
                            Print
                        </button>
                        <button @click="submitForm" v-if="!isPrintVisible" class="bg-blue-500 text-white py-2 px-6 rounded-md hover:bg-blue-600">
                            Submit
                        </button>
                    </div>
                    <div class="print:block" v-if="isPrintVisible">
                        <p>Print Date: {{ dateFormate(new Date()) }}</p>
                    </div>
                </form>
            </div>
            <LoadingBar v-if="process" />
        </Modal>
    </AuthenticatedLayout>
</template>

<script>
export default {
    data() {
        return {
            isModalVisible: false,
            isPrintVisible: false,
            process: false,
            viewType: "",
            search: '',
            modalWidth: "sm:w-[100%] md:w-[55%]",
            input: {
                customers: {
                    firstName: '',
                    mobileNo: '',
                    address: '',
                },
                contents: {
                    date: this.setDate(new Date()),
                    message: '',
                    leadFrom: 'Concent Form',
                    moduleId: 21,
                    agent: '',
                    created_by: '',
                    updated_by: ''
                }
            },
            errors: {
                mobileNo: ''
            }
        };
    },
    mounted() {
        this.input.contents.date = this.setDate(new Date());
        this.input.contents.agent = this.$page.props.auth.user['userName'];
        this.input.contents.created_by = this.$page.props.auth.user['id'];
    },
    computed: {
        filterConsentForm() {
            return this.$page.props.consentForm.filter(item => {
                return item.message.toLowerCase().indexOf(this.search.toLowerCase()) > -1 ||
                (item.customer.firstName != null ? item.customer.firstName.toLowerCase().indexOf(this.search.toLowerCase()) > -1 : '') ||
                (item.customer.address != null ? item.customer.address.toLowerCase().indexOf(this.search.toLowerCase()) > -1 : '')||
                item.users.userName.toLowerCase().indexOf(this.search.toLowerCase()) > -1
            });
        }
    },
    methods: {
        openModal(){
            this.resetForm();
            this.process = false;
            this.isModalVisible = true
        },
        edit(data){
            this.isModalVisible = true
            this.isPrintVisible = true
            this.process = false;
            this.input.customers.firstName = data.customer.firstName
            this.input.customers.mobileNo = data.customer.mobileNo
            this.input.customers.address = data.customer.address
            this.input.contents.date = this.setDate(data.created_at)
            this.input.contents.message = data.message
            this.input.contents.agent = data.users.userName
            this.input.contents.created_by = data.created_by

        },
        setDate(currentdate) {
            const current = (currentdate == '' ? new Date() : currentdate);
            const date = moment(current).format('D/M/YYYY')
            return date;
        },
        submitForm() {
            this.process = true;
            (this.input.customers.mobileNo == '' ? this.errors.mobileNo = 'errors' : this.errors.mobileNo = '');
            if (this.errors.mobileNo == 'errors') {
                this.$toast.error('Please fill the phone number');
                this.process = false
                return false;
            } else {
                this.process = false
                this.$inertia.post('/client-concent-form/add', this.input, {
                    onSuccess: () => {
                        this.$toast.success('Form submitted successfully');
                        this.isPrintVisible = false;
                    }
                });
            }
        },
        dateFormate(data){
            return moment(data).format('D/M/YYYY h:mm A');
        },
        closeModal() {
            this.isModalVisible = false;
            this.isPrintVisible = false;
            this.process = true;
        },
        resetForm(){
            // Object.assign(this.$data.input, this.$options.data().input);
        }
    }
};
</script>

<style scoped>
@media print {
    body {
        background: white;
    }

    .w-\[210mm\] {
        width: 210mm !important;
    }

    .h-\[297mm\] {
        height: 297mm !important;
    }

    input {
        border: none !important;
        border-bottom: 2px solid black !important;
    }
}
</style>