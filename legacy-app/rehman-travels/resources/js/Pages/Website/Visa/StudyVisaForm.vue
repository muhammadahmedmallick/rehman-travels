<template>
    <div class="w-full">
        <h3 class="text-base 2xl:text-xl uppercase font-bold bg-bgRGTBaseColor text-white p-[0rem_0.7rem] 2xl:p-[0.7rem] mb-3 leading-[2.875rem] text-start">
            Book Your Free Consultation
        </h3>
    </div>
    <form class="w-full p-3" @submit.prevent="submit">
        <div class="grid grid-cols-12 gap-2">
            <div class="col-span-12 md:col-span-3">
            <label for="name"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                Full Name</label>
                <input id="name" v-on:keypress="isString" class="appearance-none block text-xs 2xl:text-sm w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                type="text" v-model="form.customers.firstName">
            </div>
            <div class="col-span-12 md:col-span-3">
            <label for="phone-number"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                Mobile No<span v-if="errors.mobileNo === 'error'" class="text-red-600 font-bold text-xs">(required)</span></label>
            <input id="phone-number" v-on:keypress="isInteger" @keyup="EmptyError('mobileNo')" class="appearance-none block text-xs 2xl:text-sm w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                type="text" v-model="form.customers.mobileNo"
                >
            </div>
            <div class="col-span-12 md:col-span-3">
            <label for="email"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                Email</label>
                <input id="email" v-on:keypress="isEmail" class="appearance-none block text-xs 2xl:text-sm w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    type="email" v-model="form.customers.email">
            </div>
            <div class="col-span-12 md:col-span-3">
            <label for="city"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                City<span v-if="errors.city === 'error'" class="text-red-600 font-bold text-xs">(required)</span></label>
                <input id="city" v-on:keypress="isString" @keyup="EmptyError('city')" class="appearance-none block text-xs 2xl:text-sm w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    type="text" v-model="form.studyAbroad.city">
            </div>
            <div class="col-span-12 md:col-span-3">
            <label for="degree"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                Qualificaton/Last Degree<span v-if="errors.degree === 'error'" class="text-red-600 font-bold text-xs">(required)</span></label>
                <input id="degree" v-on:keypress="isString" @keyup="EmptyError('degree')" class="appearance-none block text-xs 2xl:text-sm w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    type="text" v-model="form.studyAbroad.degree">
            </div>
            <div class="col-span-12 md:col-span-3">
            <label for="gradutaionYear"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                Completion year<span v-if="errors.gradutaionYear === 'error'" class="text-red-600 font-bold text-xs">(required)</span></label>
                <input id="gradutaionYear" v-on:keypress="isInteger" @keyup="EmptyError('gradutaionYear')" class="appearance-none block text-xs 2xl:text-sm w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    type="text" v-model="form.studyAbroad.gradutaionYear">
            </div>
            <div class="col-span-12 md:col-span-3">
            <label for="grade"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                Marks/Grade<span v-if="errors.grade === 'error'" class="text-red-600 font-bold text-xs">(required)</span></label>
                <input id="grade" v-on:keypress="isString" @keyup="EmptyError('grade')" class="appearance-none block text-xs 2xl:text-sm w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    type="text" v-model="form.studyAbroad.grade">
            </div>
            <div class="col-span-12 md:col-span-3">
            <label for="isIelts"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                IELTS<span v-if="errors.isIelts === 'error'" class="text-red-600 font-bold text-xs">(required)</span></label>
                    <select id="isIelts"
                        class="block appearance-none w-full h-10 text-xs 2xl:text-sm border border-gray-300 hover:border-gray-400 text-gray-700 pr-7 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                        v-model="form.studyAbroad.isIelts">
                        <option value="0">No</option>
                        <option value="1">Yes</option>
                    </select>
            </div>
            <div class="col-span-12 md:col-span-3">
            <label for="income"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                Yearly Income<span v-if="errors.income === 'error'" class="text-red-600 font-bold text-xs">(required)</span></label>
                <input id="income" v-on:keypress="isInteger" @keyup="EmptyError('income')" class="appearance-none block text-xs 2xl:text-sm w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    type="text" v-model="form.studyAbroad.income">
            </div>
            <div class="col-span-12 md:col-span-3">
            <label for="accBalance"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                Available Account Balance<span v-if="errors.accBalance === 'error'" class="text-red-600 font-bold text-xs">(required)</span></label>
                <input id="accBalance" v-on:keypress="isInteger" @keyup="EmptyError('accBalance')" class="appearance-none block text-xs 2xl:text-sm w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    type="text" v-model="form.studyAbroad.accBalance">
            </div>
            <div class="col-span-12 md:col-span-3">
            <label for="university"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                Interset in University<span v-if="errors.university === 'error'" class="text-red-600 font-bold text-xs">(required)</span></label>
                <input id="university" v-on:keypress="isString" @keyup="EmptyError('university')" class="appearance-none block text-xs 2xl:text-sm w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    type="text" v-model="form.studyAbroad.university">
            </div>
            <div class="col-span-12 md:col-span-3">
            <label for="interest"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                Field of Interest/Admission<span v-if="errors.interest === 'error'" class="text-red-600 font-bold text-xs">(required)</span></label>
                <input id="interest" v-on:keypress="isString" @keyup="EmptyError('interest')" class="appearance-none block text-xs 2xl:text-sm w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    type="text" v-model="form.studyAbroad.interest">
            </div>
        </div>
        <div class="grid grid-cols-12 gap-3">
            <div class="col-span-12 md:col-span-6">
            <label for="message"
                class="text-xs 2xl:text-sm font-bold text-gray-600 duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                Comments</label>
                <textarea rows="40" cols="40" v-model="form.studyAbroad.message" id="message"
                v-on:keypress="isString"
                class="appearance-none block text-xs 2xl:text-sm w-full h-24 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"> Message</textarea>
            </div>
            <div class="col-span-12 md:col-span-2 md:mb-0 my-auto">
                <input type="submit" @click="submitDetails()"
                    class=" w-full p-2 text-xl bg-blue-100 text-blue-800 border border-solid border-blue-500 text-center transition-all duration-700 ease-in-out rounded hover:bg-bgRGTBaseColor hover:text-white hover:transition-all hover:ease-in-out hover:duration-700">
            </div>
        </div>
    </form>
</template>
<script>
import CurrencyConverter from "@/Config/CurrencyConverter.js";
import { mapState } from "vuex";
export default {
    name: 'visaPackages',
    computed: { ...mapState(['currency']) },
    data() {
        return {
            banner: "",
            form: {
                customers: {
                    firstName: "",
                    mobileNo: "",
                    email: "",
                },
                contents: {
                    message : "",
                    moduleId : 4,
                    leadFrom : ""
                },
                studyAbroad: {
                    customerId:'' , 
                    city:'',
                    degree:'',
                    gradutaionYear:'',
                    grade:'',
                    isIelts:'0',
                    income:'',
                    accBalance: '',
                    university: '',
                    interest: '',
                    message: ''
                }
            },
            errors:{
                mobileNo: "",
                city:"",
                degree:"",
                gradutaionYear:"",
                grade:"",
                isIelts:"",
                income:"",
                accBalance: "",
                university: "",
                interest: "",
            }
        }
    },
    mounted() {
        this.banner = '/assets/banner/dubai-banner.webp';
    },
    methods: {
        EmptyError(value){
            if(this.form.studyAbroad[value] === ""){
                this.errors[value] = "error";
            }else{
                this.errors[value] = "";
            }
            
            if(value === 'mobileNo' && this.form.customers.mobileNo === ""){
                this.errors[value] = "error";
            }else{
                this.errors[value] = "";
            }
        },
        isString(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z @.]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isInteger(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[0-9+]$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isEmail(e){
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z 0-9@.]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        submitDetails() {
            if(this.form.customers.mobileNo === "") this.errors.mobileNo = 'error'
            if(this.form.studyAbroad.city === "") this.errors.city = 'error'
            if(this.form.studyAbroad.degree === "") this.errors.degree = 'error'
            if(this.form.studyAbroad.gradutaionYear === "") this.errors.gradutaionYear = 'error'
            if(this.form.studyAbroad.grade === "") this.errors.grade = 'error'
            if(this.form.studyAbroad.income === "") this.errors.income = 'error'
            if(this.form.studyAbroad.accBalance === "") this.errors.accBalance = 'error'
            if(this.form.studyAbroad.university === "") this.errors.university = 'error'
            if(this.form.studyAbroad.interest === "") this.errors.interest = 'error'
            if(this.errors.mobileNo === "" && this.errors.city === "" && this.errors.degree === "" && this.errors.gradutaionYear === "" && this.errors.grade === ""
                && this.errors.isIelts === "" && this.errors.income === "" && this.errors.accBalance === ""
                && this.errors.university === "" && this.errors.interest === ""
            ){
                this.$inertia.post('/visa/add-study-details', this.form, {
                    onSuccess: (response) => {
                        window.location.href = '/Website/thankYou';
                    }
                });
            }else{
                return false;
            }
        },
        setConverter(amount, currencyCode, currency) {
            const packageCurrencyInfo = this.$page.props.currencies.filter(e => e.currencyCode === currencyCode)[0];
            if (currencyCode === currency.currencyCode) {
                return amount;
            } else if (currencyCode === "PKR" && currency.currencyCode === "PKR") {
                return amount;
            } else if (currencyCode !== "PKR" && currency.currencyCode === "PKR") {
                return Math.floor(eval(amount) * packageCurrencyInfo.currencyRate);
            } else {
                return Math.floor(CurrencyConverter.doRequest((eval(amount) * packageCurrencyInfo.currencyRate), currency.currencyRate));
            }
        },
    }
}
</script>