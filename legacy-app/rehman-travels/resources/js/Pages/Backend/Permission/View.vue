<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import LoadingBar from "../loader/LoadingBar.vue";
</script>
<template>
<AuthenticatedLayout>
<div v-if="loggedInOwner === 'true' || (permissions !== undefined && permissions !== '')" class="py-3">
    <div class="w-full">
        <div class="p-2 bg-white shadow sm:rounded-lg">
            <LoadingBar v-if="loading"/>
                <div class="grid grid-cols-2 xs:grid-cols-3 xl:grid-cols-8 gap-2 md:mx-10">
                    <div class="flex items-center">
                        <input type="checkbox" id="checked-all" v-model="checkedAll" v-on:click="checkAll()" class="w-6 h-6 rounded-full text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-700 dark:focus:ring-offset-gray-700 focus:ring-2 dark:bg-gray-600 dark:border-gray-500"/>
                        <label for="checked-all" class="py-3 ms-2 text-sm font-medium text-gray-900 dark:text-gray-300">Check All</label>
                    </div>
                    <div v-if="loggedInOwner === 'true' || permissions !== undefined" class="flex justify-end md:m-3">
                     <a v-if="loggedInOwner === 'true' || (permissions !== undefined && permissions['Add'] === 1)" v-on:click="save()" class="bg-bgRGTBaseColor hover:bg-green-500 text-white px-1 py-1 md:p-2 rounded-md cursor-pointer"><i class="fa fa-plus"></i>&nbsp Save Permission</a>
                    </div>
                </div>
                <div class=" shadow-2xl py-3">
                <div v-for="(permissions,moduleTypeKey) in permissionAndModuleTypes" :key="moduleTypeKey" class="grid grid-cols-2 xs:grid-cols-3 md:grid-cols-5 xl:grid-cols-7 2xl:grid-cols-8 gap-y-1 md:gap-y-2">
                    <div class="col-span-2 xs:col-span-3 md:col-span-6 xl:col-span-7 2xl:col-span-9 text-white pl-4 py-1 rounded-sm font-bold text-base mb-2 mt-2 bg-blue-500 block text-left whitespace-nowrap dark:red">{{moduleTypeKey}}</div>
                    <div v-for="(permission,permissionKey) in permissions" :key="permissionKey" class="mx-3">
                        <div>
                            <input type="checkbox" :checked="checked" v-model="permissionIds" :id="`${permission['value']}`" v-bind:value="`${permission['value']}`" class="w-4 h-4 rounded-full text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-700 dark:focus:ring-offset-gray-700 focus:ring-2 dark:bg-gray-600 dark:border-gray-500"/>
                           <label :for="`${permission['value']}`" class="w-full py-3 ms-2 text-sm font-medium text-gray-900 dark:text-gray-300">{{permission['title']}}</label>
                        </div>
                    </div>
                </div>
               </div>
        </div>
    </div>
</div>
    <div v-else class="py-3">
        <div class="px-6 py-4 font-medium text-red-700 text-center whitespace-nowrap dark:red">
            You do not have permission to access this page
        </div>
    </div>
</AuthenticatedLayout>
</template>
<script>
import Service from "@/Config/Service.js";
export default {
    name:"ViewPermission",
    data() {
        return {
            loading: false,
            loggedInOwner:false,
            loggedIn: {type: Object},
            permissions: {type: Object},
            checkedAll:false,
            permissionAndModuleTypes:[],
            permissionAssigns:[],
            permissionIds:[],
        };
    },
    computed: {
        checked:function () {
            let permissionIds = [];
            for (const permissionAssign in this.permissionAssigns) {
                permissionIds.push(permissionAssign)
            }
            this.permissionIds = permissionIds;
        }
    },
    created() {
        this.loggedIn = this.$page.props.auth.loggedIn;
        this.loggedInOwner = (this.loggedIn['activeId'] === 1  && this.loggedIn['userType'] === 'owner' ? 'true' : 'false');
        this.permissions = (this.$page.props.permissions !== null ? this.$page.props.permissions['Permission'] :"");
        if(this.loggedInOwner === 'true' || this.$page.props.permissions !== null) this.permissionRequest()
    },
    methods: {
        permissionRequest() {
            this.start();
            const airURLSearchParam = this.airURLSearchParams();
            Service.doRequest("/b2b/permission/find-all-permission-request", "post",{
                "agentId":airURLSearchParam.get("aid"),
                "parentId":airURLSearchParam.get("paid"),
                "userId":airURLSearchParam.get("uid")
            })
                .then((response) => {
                    if (response.errorType === "false") {
                        this.permissionAndModuleTypes = response.permissions
                        this.permissionAssigns = response.permissionAssigns
                    } else if (response.errorType === "true") {
                        this.$toast.error(response.error)
                    }
                    this.finish(false);
                });
        },
        checkAll(){
            this.checkedAll = !this.checkedAll
            if(this.checkedAll){
                let permissions = [];
                    for (const [moduleType, permissionAndModuleTypes] of Object.entries(this.permissionAndModuleTypes)) {
                        for (const permissionAndModuleType in permissionAndModuleTypes) {
                            permissions.push(permissionAndModuleTypes[permissionAndModuleType]['value']);
                        }
                }
                this.permissionIds = permissions;
            }else{
                this.permissionIds = [];
            }
        },
        save(){
            const airURLSearchParam = this.airURLSearchParams();
            console.log(this.permissionIds)
            Service.doRequest("/b2b/permission/create-new-permission-request", "POST", {
                "permissions":this.permissionIds,
                "agentId":airURLSearchParam.get("aid"),
                "parentId":airURLSearchParam.get("paid"),
                "userId":airURLSearchParam.get("uid")
            }).then((response) => {
                    if (response.errorType === "true") {
                        this.$toast.error(response.error);
                    } else if (response.errorType === "false") {
                        this.permissionRequest()
                        this.$toast.success(response.success);
                    }
                    this.finish(false);
                });
        },
        start() {
            this.loading = true;
        },
        finish(option) {
            this.loading = option;
        },airURLSearchParams: function () {
            return new URLSearchParams(window.location.search);
        },
    },
}
</script>

