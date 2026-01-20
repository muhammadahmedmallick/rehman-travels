<script setup>
import AuthenticatedLayout from "@/Layouts/AuthenticatedLayout.vue";
import SuccessButton from '@/Components/SuccessButton.vue';
import DangerButton from '@/Components/DangerButton.vue';
import CKEditor from '@ckeditor/ckeditor5-vue';
</script>


<template>
    <AuthenticatedLayout>
        <section class="bg-white w-full md:w-[70%] mx-auto" style="box-shadow:0px 0px 4px 0px #626262;;">
            <div class="w-full bg-gradient-to-r from-sky-800 via-sky-600 to-sky-700 mt-2">
                <div>
                    <h2 class="text-white p-1 ml-6 font-semibold text-lg">Add New Visa Package</h2>
                </div>
            </div>
            <div class="w-[90%] mx-auto mt-8">
                <form class="w-full" @submit.prevent="submit">
                    <div class="flex flex-wrap">
                        <div class=" w-full sm:w-1/2 md:w-1/4 lg:w-1/4 px-1  mb-1">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                for="country-name">
                                Country Name
                            </label>
                            <input
                                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.countryName" type="text" placeholder="Country Name">
                            <!-- <p class="text-red-500 text-xs italic">Please fill out this field.</p> -->
                        </div>
                        <div class=" w-full sm:w-1/2 md:w-1/4 lg:w-1/4 px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                for="type">
                                Visa Name
                            </label>
                            <select
                                class="block appearance-none w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.cmsContentId">
                                <option>--Select Visa--</option>
                                <option v-for="(visaPage, visaPageKey) in $page.props.visaPages" :key="visaPageKey"
                                    :value="visaPage['id']"> {{ visaPage['packageTitle'] }}</option>
                            </select>
                        </div>
                        <div class=" w-full sm:w-1/2 md:w-1/4 lg:w-1/4  px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                for="order-sequence">
                                Package Url
                            </label>
                            <input
                                class="appearance-none block w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.packageUrl" type="text" placeholder="Package Url">
                        </div>
                        <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/4 px-1 mb-5">
                            <label
                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                for="tour-url">
                                Tour Url
                            </label>
                            <input
                                class="appearance-none block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                v-model="input.tourUrl" type="text" placeholder="Tour Url">
                        </div>
                        <div v-for="(visaPackage, visaPackageKey) in input.visaPackages" :key="visaPackageKey" class="w-full">
                            <div class="md:flex  md:flex-1">
                                <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/4 px-1 mb-5">
                                    <label
                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                        for="visa-title">
                                        Visa Title
                                    </label>
                                    <input
                                        class="appearance-none block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                        v-model="visaPackage.visaTitle" type="text" placeholder="Visa Title">
                                </div>
                                <div class="sm:w-1/2 w-full md:w-1/4 lg:w-1/4 px-1 mb-5">
                                    <label
                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                        for="type">
                                        Visa Duration
                                    </label>
                                    <select
                                        class="block appearance-none w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                        v-model="visaPackage.duration">
                                        <option value="">-- Select Duration --</option>
                                        <option value="48 Hours">48 Hours</option>
                                        <option value="96 Hours">96 Hours</option>
                                        <option value="3 days">3 days</option>
                                        <option value="5 Days">5 Days</option>
                                        <option value="6 days">6 days</option>
                                        <option value="14 Days">14 Days</option>
                                        <option value="28 Days">28 Days</option>
                                        <option value="30 Days" selected="selected">30 Days</option>
                                        <option value="60 Days">60 Days</option>
                                        <option value="90 Days">90 Days</option>
                                        <option value="1 Year">1 Year</option>
                                        <option value="As Per Hotel Reservation">As Per Hotel Reservation</option>
                                    </select>
                                    <div
                                        class="pointer-events-none absolute top-6 inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                        <svg class="fill-current h-4 w-8" xmlns="http://www.w3.org/2000/svg"
                                            viewBox="0 0 20 20">
                                            <path
                                                d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" />
                                        </svg>
                                    </div>
                                </div>
                                <div class="sm:w-1/2 w-full md:w-1/4 lg:w-1/4 px-1 mb-5">
                                    <label
                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                        for="no-entries">
                                        No of Entries
                                    </label>
                                    <select
                                        class="block appearance-none w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                        v-model="visaPackage.numEntries">
                                        <option value="">-- Select Entry --</option>
                                        <option value="Single Entry" selected="selected">Single Entry</option>
                                        <option value="Double Entry">Double Entry</option>
                                        <option value="Multiple Entry">Multiple Entry</option>
                                        <option value="Single / Double Entry">Single / Double Entry</option>
                                    </select>
                                    <div
                                        class="pointer-events-none absolute top-6 inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                        <svg class="fill-current h-4 w-8" xmlns="http://www.w3.org/2000/svg"
                                            viewBox="0 0 20 20">
                                            <path
                                                d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" />
                                        </svg>
                                    </div>
                                </div>
                                <div class="sm:w-1/2 w-full md:w-1/4 lg:w-1/4 px-1 mb-5">
                                    <label
                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                        for="visa-type">
                                        Visa Type
                                    </label>
                                    <select
                                        class="block appearance-none w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                        v-model="visaPackage.visaType">
                                        <option value="">-- Select Type --</option>
                                        <option value="Visit Visa">Visit Visa</option>
                                        <option value="Tourist Visa" selected="selected">Tourist Visa</option>
                                        <option value="Study Visa">Study Visa</option>
                                        <option value="E-Visa">E-Visa</option>
                                        <option value="Sticker Visa">Sticker Visa</option>
                                        <option value="Transit Visa">Transit Visa</option>
                                        <option value="Umrah Visa">Umrah Visa</option>
                                    </select>
                                    <div
                                        class="pointer-events-none absolute top-6 inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                        <svg class="fill-current h-4 w-8" xmlns="http://www.w3.org/2000/svg"
                                            viewBox="0 0 20 20">
                                            <path
                                                d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" />
                                        </svg>
                                    </div>
                                </div>
                            </div>
                            <div class="md:flex md:flex-1">
                                <div class="sm:w-1/2 w-full md:w-1/4 lg:w-1/4 px-1 mb-5">
                                    <label
                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                        for="validity-of-visa">
                                        Vaildity Of Visa
                                    </label>
                                    <select
                                        class="block appearance-none w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                        v-model="visaPackage.validity">
                                        <option>--Vaildity Type--</option>
                                        <option value="14 Days">14 Days</option>
                                        <option value="30 Days" selected="selected">30 Days</option>
                                        <option value="60 Days">60 Days</option>
                                        <option value="90 Days">90 Days</option>
                                        <option value="180 Days">180 Days</option>
                                        <option value="1 Year">1 Year</option>
                                    </select>
                                    <div
                                        class="pointer-events-none absolute top-6 inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                        <svg class="fill-current h-4 w-8" xmlns="http://www.w3.org/2000/svg"
                                            viewBox="0 0 20 20">
                                            <path
                                                d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" />
                                        </svg>
                                    </div>
                                </div>
                                <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/4 px-1 mb-5">
                                    <label
                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                        for="vaildity-of-cities">
                                        Vaildity Of Cities
                                    </label>
                                    <input
                                        class="appearance-none block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                        v-model="visaPackage.validForCityId" type="text" placeholder="Vaildity Of Cities">
                                </div>
                                <div class="w-full sm:w-1/2 md:w-1/4 lg:w-1/4 px-1 mb-5">
                                    <label for="price"
                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">Price</label>
                                    <div class="mt-2 rounded-md shadow-sm flex flex-1">
                                        <input type="text" name="price" v-model="visaPackage.visaPrice"
                                            class="appearance-none flex w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                            placeholder="0.00">
                                        <div class="inset-y-0 right-0 flex items-center">
                                            <label for="currency" class="sr-only">Currency</label>
                                            <select  v-model="visaPackage.currency" name="currency"
                                                class="h-full  border bg-transparent py-0 pl-2 pr-7 text-gray-500 focus:bg-white focus:border-blue-500 outline-none sm:text-sm">
                                                <option value="PKR">PKR</option>
                                                <option value="USD" selected="selected">USD</option>
                                                <option value="SR">SAR</option>
                                                <option value="AED">AED</option>
                                                <option value="EUR">EURO</option>
                                                <option value="GBP">GBP</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="sm:w-1/2 w-full md:w-1/4 lg:w-1/4 px-1 mb-5">
                                    <label
                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                        for="status">
                                        Status
                                    </label>
                                    <select
                                        class="block appearance-none w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                        v-model="visaPackage.durationStatus">
                                        <option value="1">Enable</option>
                                        <option value="0">Disables</option>
                                    </select>
                                    <div
                                        class="pointer-events-none absolute top-6 inset-y-0 right-0 flex items-center px-2 text-gray-700">
                                        <svg class="fill-current h-4 w-8" xmlns="http://www.w3.org/2000/svg"
                                            viewBox="0 0 20 20">
                                            <path
                                                d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" />
                                        </svg>
                                    </div>
                                </div>
                            </div>
                            <div class="w-full mx-auto">
                                <h2 class="mb-3 text-blue-500 text-sm sm:text-lg font-semibold">Includes</h2>
                                <ckeditor :editor="editor" v-model="visaPackage.visaIncludes" :config="editorConfig"></ckeditor>
                                <div class="justify-start mt-3" v-if="visaPackageKey === input.visaPackages.length - 1">
                                    <SuccessButton @click="addMore(visaPackageKey)" class="mr-2">+</SuccessButton>
                                    <DangerButton @click="removeRow(visaPackageKey)">x</DangerButton>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="md:flex justify-end md:m-3 md:p-3 p-1">
                        <SuccessButton class="w-full md:w-[20%] mr-3" @click="save()">Add New Package</SuccessButton>
                        <DangerButton class="w-full md:w-[12%] mt-3 md:mt-0">Rest Form</DangerButton>
                    </div>
                </form>
            </div>
        </section>
    </AuthenticatedLayout>
</template>

<script>
import ClassicEditor from '@ckeditor/ckeditor5-build-classic';
export default {
    name: "addVisaPackages",
    components: {
        ckeditor: CKEditor.component
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
            input: {
                id: '',
                cmsContentId : '',
                countryName : '',
                packageUrl : '',
                tourUrl : '',
                visaPackages: [{
                    visaTitle: '',
                    visaPrice: '',
                    currency: '',
                    numEntries: '',
                    duration: '',
                    validity: '',
                    validForCityId: '',
                    visaType: '',
                    visaIncludes: '',
                    durationStatus: ''
                }],
            }
        }
    }, created() {
    },
    methods: {
        save: function () {
            if (this.input.id != "") {
                console.log(this.input.id);
                this.$inertia.put('update-new-page', { 'formData': this.input }, {
                    onSuccess: (response) => {
                        this.$toast.success(this.input.countryName + ' package is successfully added.');
                        this.reset();
                    },
                });
            } else {
                console.log(this.input);
                this.$inertia.post('add-visa-package', { 'formData': this.input }, {
                    onSuccess: (response) => {
                        this.$toast.success(this.input.countryName + ' package is successfully added.');
                        this.reset();
                    }
                });
            }
        },
        reset: function () {
            Object.assign(this.$data, this.$options.data());
        },
        addMore: function (){
            this.input.visaPackages.push({
                visaTitle: '',
                visaPrice: '',
                currency: '',
                numEntries: '',
                duration: '',
                validity: '',
                validForCityId: '',
                visaType: '',
                visaIncludes: '',
                durationStatus: ''
            });
        },
        removeRow: function (visaPackageKey){
            this.input.visaPackages.splice(visaPackageKey, 1);
        }
    }
}
</script>