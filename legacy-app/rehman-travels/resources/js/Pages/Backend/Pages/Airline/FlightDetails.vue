<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import SuccessButton from '@/Components/SuccessButton.vue';
import DangerButton from '@/Components/DangerButton.vue';
import CKEditor from '@ckeditor/ckeditor5-vue';
import Autocomplete from "@/Pages/Website/Ticketing/Autocomplete.vue"
</script>

<template>
    <AuthenticatedLayout>
        <div class="w-[95%] mx-auto bg-white">
            <div class="w-full bg-gradient-to-r from-sky-800 via-sky-600 to-sky-700 mt-2">
                <div>
                    <h2 class="text-white p-1 ml-6 font-semibold text-lg">
                        Manage Pages
                    </h2>
                </div>
            </div>
            <div class="px-4 pt-4 mx-auto">
                <form class="w-full" @submit.prevent="submit">
                    <input v-model="input._method" type="hidden" />
                    <div class="flex flex-wrap -mx-3 mb-5">
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/6 px-1 mb-1">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="category-name">
                                Page Title
                            </label>
                            <input
                                :class="`appearance-none block w-full h-10 text-[14px] border ${errors.packageTitle == 'error' ? 'border-red-400' : 'border-gray-300'}  hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.packageTitle" type="text"
                                v-on:keyup="isEmpty('packageTitle')" placeholder="Package Name" />
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-1/12 px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2 lg:ml-2"
                                for="status">
                                Status
                            </label>
                            <select v-on:change="isEmpty('status')"
                                :class="`block appearance-none w-full h-10 text-[14px] border ${errors.status == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                id="status" v-model="input.status">
                                <option>--Select Status--</option>
                                <option value="1">Active</option>
                                <option value="0">De-Active</option>
                            </select>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/6 px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="url-link">
                                URL Link
                            </label>
                            <input v-on:input="isEmpty('urlLink')"
                                :class="`appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.urlLink == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                type="text" v-model="input.urlLink" placeholder="URL Link" />
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-[6%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="type">
                                Type
                            </label>
                            <select v-on:change="isEmpty('type')"
                                :class="`block appearance-none w-full h-10 text-[14px] border ${errors.type == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.type">
                                <option>--Select Type--</option>
                                <option value="1">New</option>
                                <option value="0">Old</option>
                            </select>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[5%] px-1 mb-5">
                            <label for="currency"
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2">Currency</label>
                            <select v-model="input.currencyType" name="currency" v-on:change="isEmpty('currencyType')"
                                :class="`block appearance-none w-full h-10 text-[14px] border ${errors.currencyType == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`">
                                <option value="PKR">PKR</option>
                                <option value="USD" selected="selected">USD</option>
                                <option value="SR">SAR</option>
                                <option value="AED">AED</option>
                                <option value="EUR">EURO</option>
                                <option value="GBP">GBP</option>
                            </select>
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[6%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="price">
                                Price
                            </label>
                            <input v-on:input="isEmpty('price')"
                                :class="`appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.price == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                type="text" v-model="input.price" placeholder="Price" />
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-1/12 px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="type">
                                Show On Home
                            </label>
                            <select v-on:change="isEmpty('showOnHome')"
                                :class="`block appearance-none w-full h-10 text-[14px] border ${errors.showOnHome == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.showOnHome">
                                <option>--Select Type--</option>
                                <option value="1">Yes</option>
                                <option value="0">No</option>
                            </select>
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-[12%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="URL">
                                Card Image
                            </label>
                            <input
                                class="appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.cardImage == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                :onChange="(e) => { input.cardImage = e.target.files[0];}"
                                type="file" placeholder="URL" />
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-[12%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="canonical">
                                Banner Image
                            </label>
                            <input
                                class="appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.bannerImage == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                :onChange="(e) => { input.bannerImage = e.target.files[0];}"
                                type="file" placeholder="Canonical URL" />
                        </div>
                        <div class="sm:w-1/2 w-full md:w-1/4 lg:w-1/6 px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="canonical">
                                Canonical URL
                            </label>
                            <input v-on:input="isEmpty('canonicalUrl')"
                                :class="`appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.canonicalUrl == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.canonicalUrl" type="text" placeholder="Canonical URL" />
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[13%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="meta-title">
                                Meta Title
                            </label>
                            <input v-on:input="isEmpty('metaTitle')"
                                :class="`appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.metaTitle == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
                                v-model="input.metaTitle" type="text" placeholder="Meta Title" />
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-[30.5%] px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2"
                                for="grid-last-name">
                                Meta Description
                            </label>
                            <input v-on:input="isEmpty('metaDescription')"
                                :class="`appearance-none block w-full h-10 text-[14px] text-gray-700 border ${errors.metaDescription == 'error' ? 'border-red-400' : 'border-gray-300'} hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500`"
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
            <div class="mx-auto p-4">
                <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="category-name"> 
                    Includes
                </label>
                <ckeditor :editor="editor" v-model="input.includes" :config="editorConfig"></ckeditor>
            </div>
            <div class="mx-auto p-4">
                <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="category-name"> 
                    Excludes
                </label>
                <ckeditor :editor="editor" v-model="input.excludes" :config="editorConfig"></ckeditor>
            </div>
            <div class="mx-auto p-4">
                <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="category-name"> 
                    Short Details
                </label>
                <ckeditor :editor="editor" v-model="input.shortDescription" :config="editorConfig"></ckeditor>
            </div>
            <div class="mx-auto p-4">
                <label class="block capitalize tracking-wide text-blue-500 text-[13px] font-semibold mb-2" for="category-name"> 
                    Details<span v-if="errors.description"> <i><small class="text-red-600 text-[9px]">(Please fill the field)</small></i></span>
                </label>
                <ckeditor :editor="editor" v-model="input.description" :config="editorConfig"></ckeditor>
            </div>
            <div class="md:flex justify-end m-3 p-3">
                <SuccessButton class="mr-3" @click="save()">Add New Page</SuccessButton>
                <DangerButton>Rest Form</DangerButton>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script>
import ClassicEditor from '@ckeditor/ckeditor5-build-classic';
export default {
    name: "addNewPage",
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
            errors: {
                packageTitle: '',
                parentId: '',
                sequence: '',
                status: '',
                urlLink: '',
                currencyType: '',
                cardImage: '',
                bannerImage: '',
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
                flight: {
                    departCode: '',
                    arrCode: '',
                },
            },
            input: {
                id: '',
                parentId: '3',
                metaTitle: '',
                metaDescription: '',
                canonicalUrl: '',
                urlLink: '',
                packageTitle: '',
                departCode: '',
                arrCode: '',
                schemaVal: '',
                cardImage: '',
                bannerImage: '',
                categories:  'Flights',
                currencyType: 'PKR',
                price: '',
                sequence: '',
                shortDescription: '',
                includes: '',
                excludes: '',
                documentsRequired: '',
                type: '1',
                showOnHome: '1',
                description: '',
                status: '1',
                _method: ''
            },
        }
    },
    mounted(){
      this.input = this.$page.props.flightDetails;  
    },
    methods: {
        isEmpty(title) {
            if (title === 'packageTitle')
                this.errors.packageTitle = "";
            else if (title === "parentId")
                this.errors.parentId = "";
            else if (title === "sequence")
                this.errors.sequence = "";
            else if (title === "status")
                this.errors.status = "";
            else if (title === "urlLink")
                this.errors.urlLink = "";
            else if (title === "currencyType")
                this.errors.currencyType = "";
            else if (title === "price")
                this.errors.price = "";
            else if (title === "cardImage")
                this.errors.cardImage = "";
            else if (title === "bannerImage")
                this.errors.bannerImage = "";
            else if (title === "type")
                this.errors.type = "";
            else if (title === "showOnHome")
                this.errors.showOnHome = "";
            else if (title === "canonicalUrl")
                this.errors.canonicalUrl = "";
            else if (title === "metaTitle")
                this.errors.metaTitle = "";
            else if (title === "metaDescription")
                this.errors.metaDescription = "";
            else if (title === "description")
                this.errors.description = "";
        },
        save: function () {
            if (this.input.packageTitle === "") {
                this.errors.packageTitle = 'error';
                return false;
            } else if (this.input.parentId === "") {
                this.errors.parentId = 'error';
                return false;
            } else if (this.input.sequence === "") {
                this.errors.sequence = 'error';
                return false;
            } else if (this.input.status === "") {
                this.errors.status = 'error';
                return false;
            } else if (this.input.urlLink === "") {
                this.errors.urlLink = 'error';
                return false;
            } else if (this.input.type === "") {
                this.errors.type = 'error';
                return false;
            } else if (this.input.currencyType === "") {
                this.errors.currencyType = 'error';
                return false;
            } else if (this.input.price === "") {
                this.errors.price = 'error';
                return false;
            } else if (this.input.showOnHome === "") {
                this.errors.showOnHome = 'error';
                return false;
            } else if (this.input.canonicalUrl === "") {
                this.errors.canonicalUrl = 'error';
                return false;
            } else if (this.input.metaTitle === "") {
                this.errors.metaTitle = 'error';
                return false;
            } else if (this.input.metaDescription === "") {
                this.errors.metaDescription = 'error';
                return false;
            } else if (this.input.description === "") {
                this.errors.description = 'error';
                return false;
            } else {
                this.$inertia.post('/content/update-new-page', { 'formData': this.input }, {
                    onSuccess: (response) => {
                        console.log(response, "data inserted successfully.");
                        this.$toast.success(this.input.packageTitle + ' is added successfully!');
                    }
                });
            }
        }
    }
}
</script>