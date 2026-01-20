<template>
  <div :class="`flex items-center px-2 py-2 h-[3.42rem] border ${checkNum == '' ? 'border-gray-300' : 'border-red-300'} bg-white hover:border-gray-400 rounded-md`">
  <i class="fa-solid fa-phone text-rGTBaseTextColor text-md"></i>
    <input
      type="tel"
      id="phone-number"
      @paste.prevent
      minlength="5"
      maxlength="15"
      class="w-full p-1 font-semibold lg:text-[14px] focus:outline-none border-none focus:ring-0"
      placeholder="Contact No."
      autocomplete="off"
      v-model="phoneNumber"
      @input="isPhoneNumber"
      v-on:keypress="isInteger"
    />
    <small v-if='checkNum != ""' class="text-[8px] text-red-600 align-top">(required)</small>
  </div>
</template>
<script>
export default {
    emits: ["selectedPhoneNumber"],
    props:{
      checkNum: String,
      phoneNumberValue: String
    },
    data() {
        return {
            phoneNumber: (this.phoneNumberValue != "" ? this.phoneNumberValue : ''),
        }
    },
    methods: {
        isInteger(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[0-9+]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isPhoneNumber() {
            this.$emit('selectedPhoneNumber', this.phoneNumber);
        },
    },
};
</script>
