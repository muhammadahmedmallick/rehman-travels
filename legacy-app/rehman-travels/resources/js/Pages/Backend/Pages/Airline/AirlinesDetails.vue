<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import DangerButton from '@/Components/DangerButton.vue';
import SuccessButton from '@/Components/SuccessButton.vue';
import Modal from '@/Components/Modal.vue';
import CKEditor from '@ckeditor/ckeditor5-vue';
import Autocomplete from "@/Pages/Website/Ticketing/Autocomplete.vue";
</script>
<template>
    <AuthenticatedLayout>
        <div class="flex justify-end m-3" v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'">
            <input type="text" v-model="search" placeholder="Search" class="rounded mr-3">
            <a :href="route('content.new-page')" class="bg-bgRGTBaseColor text-white p-2 rounded-md mr-3"><i
                    class="fa fa-plus"></i> &nbsp; Add New Page </a>
        </div>
        <div class="overflow-x-auto shadow-md">
            <table
                class="w-full md:w-[98%] text-sm text-left border-2 rtl:text-right text-gray-500 mx-auto mt-2 mb-2 rounded-full">
                <thead class="text-xs text-white uppercase bg-bgRGTBaseColor">
                    <tr>
                        <th scope="col" class="p-3">S.No</th>
                        <th scope="col" class="p-3">Page Name</th>
                        <th scope="col" class="p-3">Parent Page</th>
                        <th scope="col" class="p-3">Url Link</th>
                        <th scope="col" class="p-3">Current Type</th>
                        <th scope="col" class="p-3">Show On Home</th>
                        <th scope="col" class="p-3">Sequance</th>
                        <th scope="col" class="p-3">Status</th>
                        <th scope="col" class="p-3">Created At</th>
                        <th scope="col" class="p-3">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-if="filteredAirlines == ''" class="odd:bg-white even:bg-slate-50 border-b">
                        <td scope="row" class="px-6 py-4 whitespace-nowrap col-span-12" colSpan={6}> No Data Found</td>
                    </tr>
                    <tr v-else class="odd:bg-white even:bg-slate-50 border-b"
                        v-for="(ContentDetail, ContentDetailKey) in filteredAirlines" :key="ContentDetailKey">
                        <td scope="row" class="px-6 py-4 whitespace-nowrap">
                            {{ ContentDetailKey + 1 }} </td>
                        <td scope="row" class="px-6 py-4 whitespace-nowrap">
                            {{ ContentDetail.packageTitle }}</td>
                        <td scope="row" class="px-6 py-4 whitespace-nowrap">
                            {{ ContentDetail.parent_pages['title'] }}</td>
                        <td scope="row" class="px-6 py-4 whitespace-nowrap">
                            {{ ContentDetail.urlLink }}</td>
                        <td scope="row" class="px-6 py-4 whitespace-nowrap">
                            {{ (ContentDetail.type == 1 ? 'New' : 'Old') }}</td>
                        <td scope="row" class="px-6 py-4 whitespace-nowrap">
                            {{ (ContentDetail.showOnHome == 1 ? 'Yes' : 'No') }}</td>
                        <td scope="row" class="px-6 py-4 whitespace-nowrap">
                            {{ ContentDetail.sequence }}</td>
                        <td scope="row" class="px-6 py-4 whitespace-nowrap">
                            {{ (ContentDetail.status == 1 ? 'Active' : 'De-active') }}</td>
                        <td scope="row" class="px-6 py-4 whitespace-nowrap">
                            {{ ContentDetail.created_at }}</td>
                        <td scope="row" class="px-6 py-4 whitespace-nowrap">
                            <a v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'" @click="edit(ContentDetail, 'edit')"><i
                                    class="fa fa-pen-to-square text-green-400 cursor-pointer mr-3"></i></a>
                            <a @click="edit(ContentDetail, 'view')"><i
                                    class="fa fa-eye text-orange-400 cursor-pointer mr-3"></i></a>
                            <a v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.userType == 'agent' || $page.props.auth.user.userType == 'owner'" @click="removeAirline(ContentDetail.id)">
                                <i class="fa fa-trash text-red-600 cursor-pointer"></i>
                            </a>
                        </td>

                    </tr>
                </tbody>
            </table>
        </div>
        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="flex flex-1 mb-2 mr-4 justify-end">
                <i class="fa fa-close mt-2 bg-red-500 rounded-lg p-2 text-white cursor-pointer" @click="closeModal()"></i>
            </div>
            <div class="relative w-[95%] mx-auto bg-white">
                <div class="w-full bg-gradient-to-r from-sky-800 via-sky-600 to-sky-700 mt-2">
                    <div>
                        <h2 class="text-white p-1 ml-6 font-semibold text-lg">
                            Manage Pages
                        </h2>
                    </div>
                </div>
                <div class="px-4 py-2 mx-auto mt-8">
                    <form class="w-full" @submit.prevent="submit">
                        <input v-model="input.id" type="hidden" id="id" />
                        <input v-model="viewType" type="hidden" id="viewtype" />
                        <input v-model="input._method" type="hidden" />
                        <div class="flex flex-wrap -mx-3">
                            <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/6 px-1 mb-1">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    for="category-name">
                                    Category Name
                                </label>
                                <input
                                    class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.packageTitle" @input="concateUrlLink()" type="text"
                                    placeholder="Package Name" />
                                <!-- <p class="text-red-500 text-xs italic">Please fill out this field.</p> -->
                            </div>
                            <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/12 px-1 mb-5">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    for="page-parent">
                                    Page Parent
                                </label>
                                <select
                                    class="block appearance-none w-full h-10 border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.parentId" @change="concateUrlLink()">
                                    <option value="0">-- Select Parent Page --</option>
                                    <option v-for="(parentPage, parentPageIndex) in $page.props.parentPages"
                                        :key="parentPageIndex" :value="parentPage['id']">{{ parentPage['title'] }}
                                    </option>
                                </select>
                            </div>
                            <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[6%] px-1" v-if="input.parentId == 20">
                                <div :class="`appearance-none block text-[14px] mt-5 text-gray-700 border border-gray-300 hover:border-gray-400 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`">
                                    <Autocomplete v-model="input.departCode" @click="concateUrlLink()"
                                        @update:autocomplete="outinboundAirportDetail" :initialIndex="0"
                                        :initialType="'outbound'"></Autocomplete>
                                </div>
                            </div>
                            <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[6%] px-1" v-if="input.parentId == 20">
                                <div :class="`appearance-none block text-[14px] mt-5 text-gray-700 border border-gray-300 hover:border-gray-400 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`">
                                    <Autocomplete v-model="input.arrCode" @click="concateUrlLink()"
                                        @update:autocomplete="outinboundAirportDetail" :initialIndex="0"
                                        :initialType="'inbound'"></Autocomplete>
                                </div>
                            </div>
                            <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[8%] px-1 mb-5">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    for="order-sequence">
                                    Order/Sequence
                                </label>
                                <input
                                    class="appearance-none block w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.sequence" type="text" placeholder="Order/Sequence" />
                            </div>
                            <div class="relative sm:w-1/2 w-full md:w-1/4 lg:w-1/12 px-1 mb-5">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2 lg:ml-2"
                                    for="status">
                                    Status
                                </label>
                                <select
                                    class="block appearance-none w-full h-10 border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    id="status" v-model="input.status">
                                    <option>--Select Status--</option>
                                    <option value="1">Active</option>
                                    <option value="0">De-Active</option>
                                </select>
                            </div>
                            <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/6 px-1 mb-5">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    for="url-link">
                                    URL Link
                                </label>
                                <input
                                    class="appearance-none block w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    type="text" v-model="input.urlLink" placeholder="URL Link" />
                            </div>
                            <div class="relative sm:w-1/2 w-full md:w-1/4 lg:w-[8%] px-1 mb-5">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    for="type">
                                    Type
                                </label>
                                <select
                                    class="block appearance-none w-full h-10 border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.type">
                                    <option>--Select Type--</option>
                                    <option value="1">New</option>
                                    <option value="0">Old</option>
                                </select>
                            </div>
                            <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/12 px-1 mb-5">
                                <label for="currency"
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Currency</label>
                                <select v-model="input.currencyType" name="currency"
                                    class="block appearance-none w-full h-10 border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                    <option value="PKR">PKR</option>
                                    <option value="USD" selected="selected">USD</option>
                                    <option value="SR">SAR</option>
                                    <option value="AED">AED</option>
                                    <option value="EUR">EURO</option>
                                    <option value="GBP">GBP</option>
                                </select>
                            </div>
                            <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[8%] px-1 mb-5">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    for="price">
                                    Price
                                </label>
                                <input
                                    class="appearance-none block w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    type="text" v-model="input.price" placeholder="Price" />
                            </div>
                            <div class="relative sm:w-1/2 w-full md:w-1/4 lg:w-[8%] px-1 mb-5">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    for="type">
                                    Show On Home
                                </label>
                                <select
                                    class="block appearance-none w-full h-10 border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.showOnHome">
                                    <option>--Select Type--</option>
                                    <option value="1">Yes</option>
                                    <option value="0">No</option>
                                </select>
                            </div>
                            <div class="sm:w-1/2 w-full md:w-1/4 lg:w-[12%] px-1 mb-5">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    for="canonical">
                                    card Image
                                </label>
                                <input
                                    class="appearance-none block w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    :onChange="(e) => { input.card = e.target.files[0]; input.cardImage = e.target.files[0].name; }"
                                    type="file" placeholder="Canonical URL" />
                            </div>
                            <div class="sm:w-1/2 w-full md:w-1/4 lg:w-[12%] px-1 mb-5">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    for="canonical">
                                    Banner Image
                                </label>
                                <input
                                    class="appearance-none block w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    :onChange="(e) => { input.banner = e.target.files[0]; input.bannerImage = e.target.files[0].name; }"
                                    type="file" placeholder="Canonical URL" />
                            </div>
                            <div class="sm:w-1/2 w-full md:w-1/4 lg:w-1/6 px-1 mb-5">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    for="canonical">
                                    Canonical URL
                                </label>
                                <input
                                    class="appearance-none block w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.canonicalUrl" type="text" placeholder="Canonical URL" />
                            </div>
                            <div class="w-full sm:w-1/2 md:w-1/4 px-1 mb-5">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    for="meta-title">
                                    Meta Title
                                </label>
                                <input
                                    class="appearance-none block w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.metaTitle" type="text" placeholder="Meta Title" />
                            </div>
                            <div class="w-full sm:w-1/2 md:w-1/3 px-1 mb-5">
                                <label
                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                    for="grid-last-name">
                                    Meta Description
                                </label>
                                <input
                                    class="appearance-none block w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                    v-model="input.metaDescription" type="text" placeholder="Meta Description" />
                            </div>
                        </div>
                    </form>
                </div>
                <div class="mx-auto px-4 py-2">
                    <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="schema"> 
                        Schema
                    </label>
                    <textarea rows="12" cols="12" id="schema"
                     class="appearance-none block w-full text-[14px] border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    v-model="input.schemaVal"></textarea>
                </div>
                <div class=" mx-auto px-4 py-2">
                    <h2 class="mb-3 text-blue-500 text-sm sm:text-lg font-semibold">
                        Includes
                    </h2>
                    <ckeditor :editor="editor" v-model="input.includes" :config="editorConfig"></ckeditor>
                </div>
                <div class=" mx-auto px-4 py-2">
                    <h2 class="mb-3 text-blue-500 text-sm sm:text-lg font-semibold">
                        Excludes
                    </h2>
                    <ckeditor :editor="editor" v-model="input.excludes" :config="editorConfig"></ckeditor>
                </div>
                <div class="mx-auto px-4 py-2">
                    <h2 class="mb-3 text-blue-500 text-sm sm:text-lg font-semibold">
                        Short Details
                    </h2>
                    <ckeditor :editor="editor" v-model="input.shortDescription" :config="editorConfig">
                    </ckeditor>
                </div>
                <div class=" mx-auto px-4 py-2">
                    <h2 class="mb-3 text-blue-500 text-sm sm:text-lg font-semibold">
                        Details
                    </h2>
                    <ckeditor :editor="editor" v-model="input.description" :config="editorConfig"></ckeditor>
                </div>
                <div class="md:flex justify-end m-3 p-3">
                    <SuccessButton class="md:mr-3" @click="save()">Update New Page</SuccessButton>
                    <DangerButton @click="reset()">Rest Form</DangerButton>
                </div>
            </div>
        </Modal>
    </AuthenticatedLayout>
</template>

<script>
import ClassicEditor from '@ckeditor/ckeditor5-build-classic';
export default {
    name: "AllContentDetails",
    components: {
        // Use the <ckeditor> component in this view.
        ckeditor: CKEditor.component,
        Autocomplete
    },
    data() {
        return {
            editor: ClassicEditor,
            editorConfig: {
                toolbar: {
                    items: [
                        'undo', 'redo',
                        '|',
                        'heading',
                        '|',
                        'fontfamily', 'fontsize', 'fontColor', 'fontBackgroundColor',
                        '|',
                        'bold', 'italic', 'strikethrough', 'subscript', 'superscript', 'code',
                        '|',
                        'link', 'uploadImage', 'blockQuote', 'codeBlock',
                        '|',
                        'bulletedList', 'numberedList', 'todoList', 'outdent', 'indent'
                    ]
                },
                menuBar: {
                    isVisible: true
                },
                language: 'en',
                heading: {
                    options: [
                        { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
                        { model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1' },
                        { model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2' },
                        { model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3' },
                        { model: 'heading4', view: 'h4', title: 'Heading 4', class: 'ck-heading_heading4' },
                        { model: 'heading5', view: 'h5', title: 'Heading 5', class: 'ck-heading_heading5' }
                    ]
                },
            },
            modalWidth: "sm:w-[100%] md:w-[85%]",
            viewType: "",
            search: '',
            input: {
                id: '',
                packageTitle: '',
                parentId: '',
                sequence: '',
                status: '',
                urlLink: '',
                categories : '',
                currencyType: '',
                bannerImage: '',
                cardImage: '',
                schemaVal: '',
                departCode: '',
                arrCode: '',
                banner: '',
                card: '',
                price: '',
                type: '',
                showOnHome: '',
                includes: '',
                excludes: '',
                canonicalUrl: '',
                metaTitle: '',
                metaDescription: '',
                shortDescription: '',
                description: '',
                _method: ''
            },
            isModalVisible: false,
        }
    },
    computed: {
        filteredAirlines () {
            return this.$page.props.flightAirlines.filter(item => {
                return item.packageTitle.toLowerCase().indexOf(this.search.toLowerCase()) > -1
            });
        }
    },
    methods: {
        outinboundAirportDetail(initial) {
            if (initial !== undefined) {
                if (initial.initialType === 'outbound') {
                    this.input.departCode = initial.code;
                } else if (initial.initialType === 'inbound') {
                    this.input.arrCode = initial.code;
                }
            }
        },
        concateUrlLink: function () {
            let parentPages = this.$page.props.parentPages;
            let packageTitle = this.input.packageTitle;
            if (this.input.packageTitle != "" && this.input.parentId != "") {
                for (let parentPageKey in parentPages) {
                    if (this.input.parentId == parentPages[parentPageKey].id) {
                        console.log(parentPages[parentPageKey].id);
                        if(parentPages[parentPageKey].id == 20){
                            let parentTitle = (parentPages[parentPageKey].title).replace(/\s+/g, "").toLowerCase();
                            console.log(this.input.departCode, this.input.arrCode);
                            this.input.urlLink = (parentTitle + "/" + this.input.departCode + "/" + this.input.arrCode + "/" + packageTitle).replace(/\s+/g, "-").toLowerCase();
                        }else if (parentPages[parentPageKey].id == 12) {
                            let parentTitle = (parentPages[parentPageKey].title).replace(/\s+/g, "").toLowerCase()
                            this.input.urlLink = (parentTitle + "/" + packageTitle).replace(/\s+/g, "-").toLowerCase();
                        } else {
                            this.input.urlLink = (parentPages[parentPageKey].title + "/" + packageTitle).replace(/\s+/g, "-").toLowerCase();
                        }
                        if (parentPages[parentPageKey].title == "World Tours") {
                            this.input.categories = "International Tour";
                        } else if (parentPages[parentPageKey].title == "Pakistan Tours") {
                            this.input.categories = "Domestic Tour";
                        } else if(this.input.parentId == 20){
                            this.input.categories = "Flights";
                        }else{
                            this.input.categories = parentPages[parentPageKey].title;
                        }
                        console.log(this.input.categories);
                    }
                }
            } else {
                this.input.urlLink = packageTitle.replace(/\s+/g, "-").toLowerCase();
            }
        },
        edit: function (contentDetails, viewType) {
            this.isModalVisible = true;
            this.viewType = viewType;
            this.input = contentDetails;
        },
        save: function () {
            if (this.input.id != "") {
                console.log(this.input.id);
                this.$inertia.post('update-new-page', { 'formData': this.input }, {
                    onSuccess: (response) => {
                        console.log(response);
                        this.isModalVisible = false;
                        this.reset();
                        this.$toast.success(this.input.packageTitle + ' Package Successfully Updated.');
                    },
                });
            }
        },
        closeModal: function () {
            this.isModalVisible = false;
        },
        reset: function () {
            Object.assign(this.$data, this.$options.data());
        },
        removeAirline(id){
            if(confirm('Are you sure!') == true){
                this.$inertia.delete('delete/'+id,{
                    onSuccess: () => {
                        this.$toast.success(this.input.packageTitle + ' Successfully Deleted');
                    }
                }
                );
            }
        }
    }
}
</script>