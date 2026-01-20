<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
</script>
<template>
  <AuthenticatedLayout>
    <template #header>
      <h6 class="font-semibold text-xl text-gray-800 leading-tight">View Permission</h6>
    </template>
    <div class="content nonPrintableDiv">
      <div class="container-fluid">
        <div class="row">
          <div class="col-lg-12">
            <div class="card card-primary card-outline">
               <div class="card-header">
               <div class="row">
                  <div class="col-sm-6" v-if="$page.props.auth.currentLoggedIn.activeId !=0 && $page.props.auth.currentLoggedIn.permissions != null  && $page.props.auth.currentLoggedIn.permissions.Permission">
                     <button v-if="$page.props.auth.currentLoggedIn.permissions.Permission.Add !='undefined'" class="btn add-permission-btn" @click="savePermission"> <i class="fas fa-key"></i> Add Permission </button>
                  </div>
               </div>
              </div>
              <div  class="row">
                  <div class="col-sm-12">
                  <p class="card-header persmission-header">Company Name :{{companyName}} | User Name: {{userName}}</p>
               </div>
               </div>
              <div class="card card-primary card-outline"></div>
              <div class="card-body">
                <div class="row">
                  <div class="col-sm-12">
                    <div class="form-group">
                      <div class="form-group clearfix">
                        <div class="icheck-primary d-inline">
                          <input type="checkbox" id="check-all" class="check-all " v-model="isCheckPermissionTypes" @click="permissionTypes()"/>
                          <label for="check-all" class="check-label"> Check All </label>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <table
                  id="permission-type"
                  class="table table-striped table-hover responsive permission-type data-table">
                  <tbody v-for="allPermissionTypes,allPermissionModuleTypeKey in allPermissionModuleTypes" :key="allPermissionModuleTypeKey">
                     <p class="card-header persmission-header-type">{{allPermissionModuleTypeKey}} Details  </p>
                     <tr v-for="allPermissionType,allPermissionTypeKey in allPermissionTypes" :key="allPermissionTypeKey" style="display: inline;">
                     <td> 
                        <div class="form-group clearfix">
                        <div class="icheck-primary d-inline">
                        <input type="checkbox"  :id="allPermissionType.id" class="permission-type" v-bind:value="allPermissionType.id" v-model="permissionTypeIds" @checked="assignPermissionType(assignPermissionTypes,allPermissionModuleTypeKey,allPermissionType.id)" @change="updatePermissionTypes(allPermissionType.id)"/>
                        <label :for="allPermissionType.id" class="check-label"> {{allPermissionType.title}}</label>
                     </div>
                  </div>
                  </td>
                </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AuthenticatedLayout>
</template>
<style scoped>
.mycol:nth-child(3n+1){
   clear:left;
  }
</style>
<script>
import Service from "@/Config/Service";
export default {
	data() {
		return {
			allPermissionModuleTypes: "",
			totalCounts: 0,
			moduleTypes: [],
			moduleTypeId: "",
			isCheckPermissionTypes: false,
			permissionTypeIds: [],
			isCheckAll: false,
			assignPermissionTypes: "",
			companyName: "",
			userName: ""
		};
	},
	created() {
		this.findAllPermissionTypes();
		this.findAssignPermissionTypes();
		this.companyName = this.airURLSearchParams().get("cpny")
		this.userName = this.airURLSearchParams().get("uname");
	},
	methods: {
		permissionTypes: function() {
			this.isCheckAll = !this.isCheckAll;
			let permissionTypeIds = [];
			if (this.isCheckAll) {
				for (let allPermissionModuleType in this.allPermissionModuleTypes) {
					this.allPermissionModuleTypes[allPermissionModuleType].forEach(function(permissionType) {
						permissionTypeIds.push(permissionType.id);
					});
				}
				this.permissionTypeIds = permissionTypeIds;
			} else {
				this.permissionTypeIds = [];
			}
		},
		updatePermissionTypes: function(permissionTypeId) {
			let permissionTypeIds = [];
			for (let allPermissionModuleType in this.allPermissionModuleTypes) {
				this.allPermissionModuleTypes[allPermissionModuleType].forEach(function(permissionType) {
					permissionTypeIds.push(permissionType.id);
				});
			}
			if (this.permissionTypeIds.length == permissionTypeIds.length) {
				this.isCheckPermissionTypes = true;
			} else {
				this.isCheckPermissionTypes = false;
			}
		},
		deletePermissionById: function(permissionTypeId) {
			const airURLSearchParam = this.airURLSearchParams();
			Service.doDeleteRequest("delete-permission-by-id", {
				'agentId': airURLSearchParam.get("aid"),
				'parentId': airURLSearchParam.get("paid"),
				'userId': airURLSearchParam.get("uid"),
				'permissionTypeId': permissionTypeId
			}).then(response => {
				toastr.success("Permission Type has been Deleted Successfully");
				this.findAssignPermissionTypes();
			}).catch((error) => {
				toastr.error("Permission Type Not Deleted Successfully,Please Try Again !");
			});
		},
		findAssignPermissionTypes: function() {
			const airURLSearchParam = this.airURLSearchParams();
			Service.doGetRequest("find-all-permission-types-by-current-agent-user-id", {
				agentId: airURLSearchParam.get("aid"),
				parentId: airURLSearchParam.get("paid"),
				userId: airURLSearchParam.get("uid")
			}).then(response => {
				this.assignPermissionTypes = response.data.totalRecords;
				this.totalCounts = response.data.totalCounts;
				for (let allPermissionModuleType in response.data.totalRecords) {
					for (let assignPermissionTypeId in this.assignPermissionTypes[allPermissionModuleType]) {
						if (!this.permissionTypeIds.includes(assignPermissionTypeId)) {
							this.permissionTypeIds.push(assignPermissionTypeId);
						}
					}
				}
			});
		},
		findAllPermissionTypes: function() {
			const airURLSearchParam = this.airURLSearchParams();
			Service.doGetRequest("all-permission-types", {
				agentId: airURLSearchParam.get("aid"),
				parentId: airURLSearchParam.get("paid"),
				userType: airURLSearchParam.get("ut")
			}).then(response => {
				this.allPermissionModuleTypes = response.data.totalRecords;
				this.totalCounts = response.data.totalCounts;
			});
		},
		assignPermissionType: function(permissionModuleTypes, allPermissionModuleTypeKey, permissionTypeId) {
			if (permissionModuleTypes != undefined && permissionModuleTypes[allPermissionModuleTypeKey] != undefined && permissionModuleTypes[allPermissionModuleTypeKey][permissionTypeId] != undefined) {
				return (permissionModuleTypes[allPermissionModuleTypeKey][permissionTypeId].id == permissionTypeId ? true : false);
			}
		},
		savePermission: function() {
			const airURLSearchParam = this.airURLSearchParams();
			Service.doPostRequest("add-new-permission", {
				'agentId': airURLSearchParam.get("aid"),
				'parentId': airURLSearchParam.get("paid"),
				'userId': airURLSearchParam.get("uid"),
				'permissionTypeIds': this.permissionTypeIds
			}).then(response => {
				toastr.success("Permission has been Added Successfully!");
				this.findAllPermissionTypes();
			}).catch((error) => {
				toastr.error("Permission Not Added Successfully,Please Try Again !");
			});
		},
		airURLSearchParams: function() {
			return new URLSearchParams(window.location.search);
		},
	},
};
</script>
