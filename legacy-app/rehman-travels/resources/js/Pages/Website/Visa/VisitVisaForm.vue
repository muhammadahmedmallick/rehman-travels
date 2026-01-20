<template>
    <div class="w-full">
        <h3 class="text-xs 2xl:text-lg uppercase font-bold bg-bgRGTBaseColor text-white p-[0rem_0.7rem] 2xl:p-[0.7rem] mb-3 leading-[2.875rem] text-start">
            Visitor Visa UK, USA, Canada, Australia, Schengen
        </h3>
    </div>
    <form class="w-full p-3" @submit.prevent="submitDetails">
        <div class="grid grid-cols-12 gap-3 md:gap-2">
            <div class="col-span-6 md:col-span-3">
                <label for="phone-number"
                    class="text-sm font-bold duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                    Full Name</label>
                <input class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    type="text" v-on:keypress="isString" v-model="form.customers.firstName">
            </div>
            <div class="col-span-6 md:col-span-2">
                <label for="phone-number" class="text-sm font-bold duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                    Mobile No<span v-if="errors.mobileNo === 'error'" class="text-red-600 font-bold text-xs">(required)</span></label>
                <input @keyup="EmptyError('mobileNo', form.customers.mobileNo)"
                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                type="tel" v-on:keypress="isInteger" v-model="form.customers.mobileNo">
            </div>
            <div class="col-span-6 md:col-span-3">
                <label for="phone-number"
                class="text-sm font-bold duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                Email</label>
                <input
                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                type="email" v-on:keypress="isEmail" v-model="form.customers.email">
            </div>
            <div class="col-span-6 md:col-span-2">
                <label for="phone-number"
                    class="text-sm font-bold duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                    Date of Birth</label>
                <input class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    type="date" v-model="form.visitVisa.dob">
            </div>
            <div class="col-span-12 md:col-span-2">
                <label for="phone-number"
                    class="text-sm font-bold duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                    Country of Interest<span v-if="errors.interest === 'error'" class="text-red-600 font-bold text-xs">(required)</span></label>
                <input @keyup="EmptyError('interest', form.visitVisa.interest)"
                    v-on:keypress="isString"
                    class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 md:mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                    type="text" v-model="form.visitVisa.interest">
            </div>
            <!-- 1. Passport Section -->
            <div class="col-span-12 md:col-span-6 shadow-md rounded-lg border">
                <h3 class="font-semibold text-lg text-white bg-gradient-to-r from-[#0181dd] px-2 py-1 rounded-t-md">
                    1.Passport
                </h3>
                <div class="p-2">
                    <p class="mt-2 font-semibold text-gray-600">Do you have a valid passport for at least six months?</p>
                    <div class="flex items-center space-x-4 mt-2">
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="passport" v-model="form.visitVisa.passportValidity" value="1" />
                            <span>Yes</span>
                        </label>
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="passport" v-model="form.visitVisa.passportValidity" value="0" />
                            <span>No</span>
                        </label>
                    </div>
                </div>
            </div>
            <!-- 2. Monthly Source of Income -->
            <div class="col-span-12 md:col-span-6 shadow-md rounded-lg border">
                <h3 class="font-semibold text-lg text-white bg-gradient-to-r from-[#0181dd] px-2 py-1 rounded-t-md">
                    2.Monthly Source of Income
                </h3>
                <div class="p-2">
                    <p class="mt-2 font-semibold text-gray-600">Do you have a regular and verifiable source of income?</p>
                    <div class="flex items-center space-x-4 mt-2">
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="income" v-model="form.visitVisa.incomeVerifiableSource" value="1" />
                            <span>Yes</span>
                        </label>
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="income" v-model="form.visitVisa.incomeVerifiableSource" value="0" />
                            <span>No</span>
                        </label>
                    </div>
                    <div class="grid grid-cols-3 lg:grid-cols-6 items-center bg-bgRGTBaseColor mt-3 *:text-white px-2 py-1 rounded" v-if="form.visitVisa.incomeVerifiableSource === '1'">
                        <label class="flex items-center space-x-1">
                            <input type="checkbox" class="border border-white" @click="addSourceType('Business', $event.target.checked)" />
                            <span>Business</span>
                        </label>
                        <label class="flex items-center space-x-1">
                            <input type="checkbox" class="border border-white" @click="addSourceType('Rental', $event.target.checked)" />
                            <span>Rental</span>
                        </label>
                        <label class="flex items-center space-x-1">
                            <input type="checkbox" class="border border-white" @click="addSourceType('Job', $event.target.checked)" />
                            <span>Job</span>
                        </label>
                        <div class="flex items-center space-x-1 mt-4 md:mt-0">
                            <span>Approximately:</span>
                            <input type="text" v-on:keypress="isInteger" placeholder="25000" v-model="form.visitVisa.incomeVerifiableSourceType.amount" class="border border-gray-300 text-black rounded p-1 w-20 2xl:w-40" />
                        </div>
                    </div>
                </div>
            </div>
            <!-- 3. Tax Filer Status -->
            <div class="mt-3 col-span-12 md:col-span-6 shadow-md rounded-lg border">
                <h3 class="font-semibold text-lg text-white bg-gradient-to-r from-[#0181dd] px-2 py-1 rounded-t-md">
                    3.Tax Filer Status
                </h3>
                <div class="p-2">
                    <p class="mt-2 font-semibold text-gray-600">Are you an active tax filer?</p>
                    <div class="flex items-center space-x-4 mt-2">
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="tax_filer" v-model="form.visitVisa.taxFiler" value="1" />
                            <span>Yes</span>
                        </label>
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="tax_filer" v-model="form.visitVisa.taxFiler" value="0" />
                            <span>No</span>
                        </label>
                    </div>
                    <p class="mt-2 font-bold transition delay-150 duration-300 ease-in-out" v-if="form.visitVisa.taxFiler === '1'">Do you have tax returns?</p>
                    <div class="grid grid-cols-3 gap-2 mt-2"  v-if="form.visitVisa.taxFiler === '1'">
                        <input type="text" v-on:keypress="isString" :placeholder="`${n} Year`" class="border border-gray-300 rounded p-1" @input="calTax(n-1, $event.target.value)" v-for="n in 3" />
                    </div>
                </div>
            </div>
            <!-- 4. Bank Statement -->
            <div class="mt-3 col-span-12 md:col-span-6 shadow-md rounded-lg border">
                <h3 class="font-semibold text-lg text-white bg-gradient-to-r from-[#0181dd] px-2 py-1 rounded-t-md">4.Bank Statement</h3>
                <div class="p-2">
                    <p class="mt-2 font-semibold text-gray-600">Do you have a consistent 6-months bank statement?</p>
                    <div class="flex items-center space-x-4 mt-2">
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="bank_statement" v-model="form.visitVisa.bankStatement" value="1" />
                            <span>Yes</span>
                        </label>
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="bank_statement" v-model="form.visitVisa.bankStatement" value="0" />
                            <span>No</span>
                        </label>
                    </div>
                    <p class="mt-2 whitespace-break-spaces font-semibold text-gray-600">Do you have sufficient funds in your account for this trip? (Approximately 25-30 lac PKR for one person)</p>
                    <div class="flex items-center space-x-4 mt-2">
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="sufficient_funds" v-model="form.visitVisa.sufficientFunds" value="1" />
                            <span>Yes</span>
                        </label>
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="sufficient_funds" v-model="form.visitVisa.sufficientFunds" value="0" />
                            <span>No</span>
                        </label>
                    </div>
                </div>
            </div>
            <!-- 5. Marital Status -->
            <div class="mt-3 col-span-12 md:col-span-6 shadow-md rounded-lg border">
                <h3 class="font-semibold text-lg text-white bg-gradient-to-r from-[#0181dd] px-2 py-1 rounded-t-md">
                    5.Marital Status
                </h3>
                <div class="p-2">
                    <p class="mt-2 font-semibold text-gray-600">Are You Married?</p>
                    <div class="flex">
                        <div class="flex items-center space-x-4 mt-2">
                            <label class="flex items-center space-x-2">
                                <input type="radio" name="married" v-model="form.visitVisa.maritalStatus" value="0" />
                                <span>No</span>
                            </label>
                            <label class="flex items-center space-x-2">
                                <input type="radio" name="married" v-model="form.visitVisa.maritalStatus" value="1" />
                                <span>Yes</span>
                            </label>
                        </div>
                        <div class="flex items-center space-x-2 ml-4 mt-2" v-if="form.visitVisa.maritalStatus === '1'">
                            <span class="font-semibold text-gray-600">No. of Kids</span>
                            <input type="text" v-on:keypress="isInteger" class="border border-gray-300 rounded p-1 w-12" v-model="form.visitVisa.kids" />
                        </div>
                    </div>
                </div>
            </div>
            <!-- 6. Chamber of Commerce -->
            <div class="mt-3 col-span-12 md:col-span-6 shadow-md rounded-lg border">
                <h3 class="font-semibold text-lg text-white bg-gradient-to-r from-[#0181dd] px-2 py-1 rounded-t-md">
                    6.Member
                </h3>
                <div class="p-2">
                    <p class="mt-2 font-semibold text-gray-600">Member of Chamber of Commerce?</p>
                    <div class="flex items-center space-x-4 mt-2">
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="chamber" v-model="form.visitVisa.member" value="1" />
                            <span>Yes</span>
                        </label>
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="chamber" v-model="form.visitVisa.member" value="0" />
                            <span>No</span>
                        </label>
                    </div>
                </div>
            </div>
            <!-- 7. Education -->
            <div class="mt-3 col-span-12 md:col-span-6 shadow-md rounded-lg border">
                <h3 class="font-semibold text-lg text-white bg-gradient-to-r from-[#0181dd] px-2 py-1 rounded-t-md">
                    7.Education<span v-if="errors.education === 'error'" class="text-red-600 font-bold bg-white px-1 ml-2 py-[2px] rounded text-xs">(required)</span>
                </h3>
                <div class="p-2">
                    <textarea rows="40" cols="40" v-model="form.visitVisa.education" @keyup="EmptyError('education', form.visitVisa.education)"
                    v-on:keypress="isString"
                    class="appearance-none block w-full h-24 border mt-2 border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"></textarea>
                </div>
            </div>
            <!-- 8. Purpose of Visit -->
            <div class="mt-3 col-span-12 md:col-span-6 shadow-md rounded-lg border">
                <h3 class="font-semibold text-lg text-white bg-gradient-to-r from-[#0181dd] px-2 py-1 rounded-t-md">
                    8.Purpose of Your Visit<span v-if="errors.purpose === 'error'" class="text-red-600 font-bold bg-white px-1 ml-2 py-[2px] rounded text-xs">(required)</span>
                </h3>
                <div class="p-2">
                    <textarea rows="40" cols="40" v-model="form.visitVisa.purpose" @keyup="EmptyError('purpose', form.visitVisa.purpose)"
                    v-on:keypress="isString"
                    class="appearance-none block w-full h-24 border mt-2 border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"></textarea>
                </div>
            </div>
            <!-- 9. Travel History -->
            <div class="mt-3 col-span-12 md:col-span-6 shadow-md rounded-lg border">
                <h3 class="font-semibold text-lg text-white bg-gradient-to-r from-[#0181dd] px-2 py-1 rounded-t-md">
                    9.Travel History
                </h3>
                <div class="p-2">
                    <p class="mt-2 font-semibold text-gray-600">Have you traveled to any country in the last 5 years?</p>
                    <div class="flex items-center space-x-4 mt-2">
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="travel_history" v-model="form.visitVisa.travelHistory" value="1" />
                            <span>Yes</span>
                        </label>
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="travel_history" v-model="form.visitVisa.travelHistory" value="0" />
                            <span>No</span>
                        </label>
                    </div>
                    <div class="grid grid-cols-3 gap-2 mt-2" v-if="form.visitVisa.travelHistory === '1'">
                        <input type="text" v-on:keypress="isString" :placeholder="`Country ${n}`" class="border border-gray-300 rounded p-1" @input="addCountries(n-1, $event.target.value)" v-for="n in 6"  />
                    </div>
                </div>
            </div>
            <div class="col-span-12 md:col-span-2 md:mb-0 my-auto">
                <input type="submit"
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
            type:[],
            taxReturns:[],
            travelledCountries:[],
            form: {
                customers: {
                    firstName: "",
                    mobileNo: "",
                    email: "",
                },
                contents: {
                    message: "",
                    moduleId: 4,
                    leadFrom: ""
                },
                visitVisa: {
                    customerId: '',
                    dob : '',
                    interest: '',
                    passportValidity : '0',
                    incomeVerifiableSource : '0',
                    incomeVerifiableSourceType: {
                        type: '',
                        amount: 0
                    },
                    taxFiler : '0',
                    taxReturns : '',
                    bankStatement : '0',
                    sufficientFunds : '0',
                    maritalStatus : '0',
                    kids : 0,
                    member: '0',
                    education: '',
                    purpose: '',
                    travelHistory: '0',
                    travelledCountries: '',
                }
            },
            errors: {
                mobileNo: '',
                interest: '',
                education: ''
            }
        }
    },
    mounted() {
        this.banner = '/assets/banner/dubai-banner.webp';
    },
    methods: {
        EmptyError(fieldName, inputFieldName) {
            console.log(fieldName, inputFieldName);
            if (fieldName === 'mobileNo' && inputFieldName !== '') {
                this.errors.mobileNo = ''
                return true
            } else if (fieldName === 'mobileNo' && inputFieldName === '') {
                this.errors.mobileNo = 'error'
                return false
            }
            if (fieldName === 'interest' && inputFieldName !== '') {
                this.errors.interest = ''
                return true
            } else if (fieldName === 'interest' && inputFieldName === '') {
                this.errors.interest = 'error'
                return false
            }
            if (fieldName === 'education' && inputFieldName !== '') {
                this.errors.education = ''
                return true
            } else if (fieldName === 'education' && inputFieldName === '') {
                this.errors.education = 'error'
                return false
            }
            if (fieldName === 'purpose' && inputFieldName !== '') {
                this.errors.purpose = ''
                return true
            } else if (fieldName === 'purpose' && inputFieldName === '') {
                this.errors.purpose = 'error'
                return false
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
        calTax(index, value){
            this.taxReturns[index] = value;
            this.form.visitVisa.taxReturns = this.taxReturns.toString();
        },
        addCountries(index, value){
            this.travelledCountries[index] = value;
            this.form.visitVisa.travelledCountries = this.travelledCountries.toString();
        },
        addSourceType(sourcetypes, checked){
            console.log(checked);
            let sourceType = this.type;
            if(!this.type.includes(sourcetypes)){
                this.type.push(sourcetypes)
            }
            if(!checked){
                for (const [diffRoomSelection, diffRoomSelectionKey] of Object.entries(sourceType)) {
                    if (diffRoomSelectionKey === sourcetypes) {
                        console.log(diffRoomSelection, diffRoomSelectionKey, sourcetypes)
                        this.type.splice(diffRoomSelection, 1)
                    }
                }
            }
            this.form.visitVisa.incomeVerifiableSourceType.type = this.type.toString();
        },
        submitDetails() {
            if (this.form.customers.mobileNo === "") this.errors.mobileNo = "error"
            if (this.form.visitVisa.interest === "") this.errors.interest = "error"
            if (this.form.visitVisa.education === "") this.errors.education = "error"
            if (this.form.visitVisa.purpose === "") this.errors.purpose = "error"

            if (this.errors.mobileNo == "error" || this.errors.interest == "error" ||
            this.errors.education == "error" || this.errors.purpose == "error"
            ) {
                return false;
            } else {
                this.$inertia.post('/visa/add-visa-details', this.form, {
                    onSuccess: (response) => {
                        this.reset();
                        window.location.href = '/Website/thankYou';
                    }
                });
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
        reset: function () {
            Object.assign(this.$data, this.$options.data());
        }
    }
}
</script>