<script setup>
import LoadingBar from "../loader/LoadingBar.vue";
</script>
<template>
    <LoadingBar v-if="loading"/>
    <input @click="cheapestFareFlightOrderPay" id="cash" type="radio" value="cash" name="list-credit" class="w-5 h-5 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 focus:ring-2"/>
</template>

<script>
import Service from "@/Config/Service.js";
export default {
    name: "CashInOffice",
    props:{
        payInput:{},
        payTotalFare:0,
        currencyCode:''
    },
    data() {
        return {
            loading: false,
            input:this.setInputs(),
            errors: this.setErrors(""),
        };
    },
    methods: {
        setInputs() {
            return {"paymentType":'cash',"currencyCode":this.currencyCode,"airType":this.payInput.airType,"itineraryRef":this.payInput.itineraryRef,"payAmount":this.payTotalFare};
        },
        setErrors(errorType) {
            const  error = (errorType === undefined ? 'error': errorType);
            return {"paymentType": error}
        },
        isEmpty(fieldName, inputFieldName) {
            if (fieldName === 'paymentType' && inputFieldName !== '')
                this.errors.paymentType = ''
            else if (fieldName === 'paymentType' && inputFieldName === '')
                this.errors.paymentType = 'error'
        },
        cheapestFareFlightOrderPay(){
            if(this.input.paymentType === '') this.errors.paymentType ='error'
            if (this.errors.paymentType.includes('error')) {
                return false;
            } else {
                this.start();
                Service.doFetchRequest("/cash/cheapest-fare-order-pay-cash-request", "Create", this.input)
                    .then((response) => {
                        if (response.errorType === true) {
                            this.responseError = response.message;
                            this.redirectToUrl = true;
                            this.$toast.error(response.message);
                        } else if (response.errorType === false) {
                            if (response.payUrl === true) {
                                this.$toast.success(response.message);
                                window.location.href = `${this.$page.props.ziggy.url}/ticketing/cheapest-fare-flight-order-retrieve${new URL(location.href).search}`;
                            } else {
                                this.$toast.error(response.message);
                                this.redirectToUrl = false;
                            }
                        }
                        this.finish(false);
                    });
            }
        },
        start() {this.loading = true },
        finish(option) {this.loading = option},
    }
}
</script>

<style scoped>

</style>
