<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head} from '@inertiajs/vue3';
</script>
<template>
    <Head title="Profile" />
    <AuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">Profile</h2>
        </template>
        <div v-if="loggedInOwner === 'true' || permissions !== ''" class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-6">
                <div class="p-4 sm:p-8 bg-white shadow sm:rounded-lg">
                    <div class="grid grid-cols-3 gap-2">
                        <div>
                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">User Name</label>
                            <input  class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.userName" type="text" placeholder="User Name"/>
                        </div>
                        <div>
                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Company Name</label>
                            <input  class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.companyName" type="text" placeholder="Company Name"/>
                        </div>
                        <div>
                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Email</label>
                            <input  class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.email" type="text" placeholder="Email"/>
                        </div>
                    </div>
                    <div class="grid grid-cols-3 gap-2">
                        <div>
                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Account Status</label>
                            <input  class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.accountStatus" type="text" placeholder="Account Status"/>
                        </div>
                        <div>
                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">User Type</label>
                            <input  class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.userType" type="text" placeholder="User Type"/>
                        </div>
                        <div>
                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Payment Type</label>
                            <input  class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.paymentType" type="text" placeholder="Payment Type"/>
                        </div>
                    </div>
                    <div class="grid grid-cols-3 gap-2">
                        <div>
                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Mobile No</label>
                            <input  class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.mobileNo" type="text" placeholder="Mobile No"/>
                        </div>
                        <div>
                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Phone No</label>
                            <input  class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.phoneNo" type="text" placeholder="Phone No"/>
                        </div>
                        <div>
                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Portal Type</label>
                            <input  class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.portalType" type="text" placeholder="Portal Type"/>
                        </div>
                    </div>


                    <div class="grid grid-cols-3 gap-2">
                        <div>
                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Credit Limit</label>
                            <input  class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.creditLimit" type="text" placeholder="Credit Limit"/>
                        </div>
                        <div>
                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Tmp Credit Limit</label>
                            <input  class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.tmpCreditLimit" type="text" placeholder="Tmp Credit Limit"/>
                        </div>
                        <div>
                            <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Current Credit Limit</label>
                            <input  class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.currentCreditLimit" type="text" placeholder="Current Credit Limit"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div v-else class="py-12">
            <div class="px-6 py-4 font-medium text-red-700 text-center whitespace-nowrap dark:red">
                You do not have permission to access this page
            </div>
        </div>
    </AuthenticatedLayout>
</template>
<script>
export default {
    data() {
        return {
            loading: false,
            loggedInOwner:false,
            loggedIn: {type: Object},
            permissions: {type: Object},
            input: this.setInputs(),
        };
    },
    mounted() {
        this.input = this.$page.props.profile
        this.loggedIn = this.$page.props.auth.loggedIn
        this.loggedInOwner = (this.loggedIn['activeId'] === 1  && this.loggedIn['userType'] === 'owner' ? 'true' : 'false');
        this.permissions = (this.$page.props.permissions !== null ? this.$page.props.permissions['User'] : "");
    },
    methods: {
        setInputs() {
            return {
                "id": "",
                "agentId": "",
                "parentId": "",
                "userType": "",
                "portalType": "",
                "paymentType": "",
                "accountStatus": "",
                "accountId": 0,
                "userName": "",
                "email": "",
                "password": "",
                "branchId": "",
                "mobileNo": "",
                "phoneNo": "",
                "creditLimit": "",
                "tmpCreditLimit": "",
                "currentCreditLimit": "",
                "address": ""
            }
        }
    },
};
</script>

