<template>
  <section>
    <!-- Backdrop -->
    <div
      v-if="complaintOpen"
      @click="tryClose"
      class="fixed top-0 left-0 h-full bg-[rgba(0, 0, 0, 0.75] w-full bg-black bg-opacity-75 z-10"
    ></div>

    <!-- Complaint Button -->
    <button aria-label="suggetions and complaints" class="fixed z-[11] bottom-12 sm:bottom-4 right-6 md:right-3 bg-bgRGTBaseColor flex items-center justify-center shadow-[0_5px_4px_0_rgba(0,0,0,.26)] h-12 w-12 md:h-[3.57rem] md:w-[3.57rem] rounded-tl-[34px] rounded-tr-[8px] rounded-br-[34px] rounded-bl-[34px] non-printable"
      @click="complaintBtn" >
      <svg width="34px" height="34px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
        <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
        <g id="SVGRepo_iconCarrier">
          <path    d="M20 12C20 8.22876 20 6.34315 18.8284 5.17157C17.6569 4 15.7712 4 12 4V4C8.22876 4 6.34315 4 5.17157 5.17157C4 6.34315 4 8.22876 4 12V18C4 18.9428 4 19.4142 4.29289 19.7071C4.58579 20 5.05719 20 6 20H12C15.7712 20 17.6569 20 18.8284 18.8284C20 17.6569 20 15.7712 20 12V12Z"
            stroke="#ffffff" stroke-width="1.6"></path>
          <path d="M9 10L15 10" stroke="#ffffff" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" ></path>
          <path    d="M9 14H12" stroke="#ffffff" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" ></path>
        </g>
      </svg>
    </button>

    <!-- Complaint Form -->
    <form
      v-if="complaintOpen"
      @submit.prevent="submit"
      class="printable bg-white fixed top-[4.5rem] ml-1 md:ml-0 right-1 z-10 lg:top-[26rem] lg:left-1/2 lg:transform lg:-translate-x-1/2 lg:-translate-y-1/2 p-6 md:px-12 sm:max-w-[635px] md:max-w-[760px] mx-auto rounded-2xl shadow-2xl sidebar-open sidebar-open-off"
    >
      <div class="flex justify-between">
        <span class="text-rGTBaseTextColor font-bold uppercase text-lg sm:text-2xl lg:text-3xl"
          >Complaint / Suggestion</span
        >
        <div @click="tryClose" class="cursor-pointer">
          <svg fill="#0181dd" width="30px" height="30px" viewBox="0 0 32.00 32.00" xmlns="http://www.w3.org/2000/svg" stroke="#ffffff" stroke-width="0.00032" >
            <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
            <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round" stroke="#CCCCCC" stroke-width="2.048" ></g>
            <g id="SVGRepo_iconCarrier">
              <path
                d="M18.8,16l5.5-5.5c0.8-0.8,0.8-2,0-2.8l0,0C24,7.3,23.5,7,23,7c-0.5,0-1,0.2-1.4,0.6L16,13.2l-5.5-5.5 c-0.8-0.8-2.1-0.8-2.8,0C7.3,8,7,8.5,7,9.1s0.2,1,0.6,1.4l5.5,5.5l-5.5,5.5C7.3,21.9,7,22.4,7,23c0,0.5,0.2,1,0.6,1.4 C8,24.8,8.5,25,9,25c0.5,0,1-0.2,1.4-0.6l5.5-5.5l5.5,5.5c0.8,0.8,2.1,0.8,2.8,0c0.8-0.8,0.8-2.1,0-2.8L18.8,16z"
              ></path>
            </g>
          </svg>
        </div>
      </div>
      <p class="mt-1 text-xs sm:text-sm text-gray-400 text-justify">
        Please fill out the following form with your complaint. We will review
        your request and follow up with you as soon as possible.
      </p>

      <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 mt-5">
        <!-- First Name -->
        <div class="relative w-full mt-2 sm:mt-0">
          <input
            type="text"
            name="enteredFname"
            id="enteredFname"
            v-model="form.customers.firstName"
            v-on:keypress="isString"
            @paste.prevent
            class="block cursor-pointer py-2.5 px-0 w-full text-sm sm:text-base text-gray-900 bg-transparent border-b-2 border-0 border-gray-300 focus:ring-0 focus:outline-none focus:border-rGTBorderColor peer"
            placeholder=""
            autocomplete="off"
            required
          />
          <label
            for="enteredFname"
            class="absolute cursor-pointer text-sm sm:text-base text-gray-400 duration-300 -translate-y-6 scale-75 top-3 origin-[0] peer-focus:start-0 peer-focus:text-rGTBaseTextColor peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6"
            >First Name</label
          >
        </div>

        <!-- Last Name -->
        <div class="relative w-full mt-2 sm:mt-0">
          <input
            type="text"
            name="enteredLname"
            id="enteredLname"
            v-on:keypress="isString"
            @paste.prevent
            class="block cursor-pointer py-2.5 px-0 w-full text-sm sm:text-base text-gray-900 bg-transparent border-b-2 border-0 border-gray-300 focus:ring-0 focus:outline-none focus:border-rGTBorderColor peer"
            placeholder=""
            autocomplete="off"
            required
          />
          <label
            for="enteredLname"
            class="absolute cursor-pointer text-sm sm:text-base text-gray-400 duration-300 -translate-y-6 scale-75 top-3 origin-[0] peer-focus:start-0 peer-focus:text-rGTBaseTextColor peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6"
            >Last Name</label>
        </div>

        <!-- Email -->
        <div class="relative w-full mt-2 sm:mt-4">
          <input
            type="email"
            name="enteredEmail"
            id="enteredEmail"
            v-on:keypress="isEmail"
            @paste.prevent
            v-model="form.customers.email"
            class="block cursor-pointer py-2.5 px-0 w-full text-sm sm:text-base text-gray-900 bg-transparent border-b-2 border-0 border-gray-300 focus:ring-0 focus:outline-none focus:border-rGTBorderColor peer"
            placeholder=""
            autocomplete="off"
            required
          />
          <label
            for="enteredEmail"
            class="absolute cursor-pointer text-sm sm:text-base text-gray-400 duration-300 -translate-y-6 scale-75 top-3 origin-[0] peer-focus:start-0 peer-focus:text-rGTBaseTextColor peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6"
            >Email</label
          >
        </div>

        <!-- Phone -->
        <div class="relative w-full mt-2 sm:mt-4">
          <input
            type="tel"
            name="enteredNum"
            id="enteredNum"
            v-on:keypress="isNumber"
            @paste.prevent
            v-model="form.customers.mobileNo"
            class="block cursor-pointer py-2.5 px-0 w-full text-sm sm:text-base text-gray-900 bg-transparent border-b-2 border-0 border-gray-300 focus:ring-0 focus:outline-none focus:border-rGTBorderColor peer"
            placeholder=""
            autocomplete="off"
            required
          />
          <label
            for="enteredNum"
            class="absolute cursor-pointer text-sm sm:text-base text-gray-400 duration-300 -translate-y-6 scale-75 top-3 origin-[0] peer-focus:start-0 peer-focus:text-rGTBaseTextColor peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6"
            >Phone</label
          >
        </div>
      </div>

      <!-- Message -->
      <div class="my-4">
        <textarea
          v-model="form.contents.message"
          v-on:keypress="isString"
          @paste.prevent
          placeholder="Write your Complaint Here"
          class="w-full h-24 md:h-32 border-b-2 focus:border-rGTBorderColor text-sm border-0 sm:text-base text-gray-900 border-gray-300 mt-2 px-0 focus:ring-0 py-3 focus:outline-none focus:shadow-outline"
        ></textarea>
      </div>

      <!-- Submit Button -->
      <div class="my-2 w-full sm:w-fit">
        <button
        @click="submitDetails()"
          class="uppercase text-xs sm:text-sm font-bold tracking-wide bg-bgRGTBaseColor text-gray-100 p-3 w-full focus:outline-none focus:shadow-outline rounded-lg"
        >
          Send Message
        </button>
      </div>
    </form>
  </section>
</template>

<script>
export default {
  data() {
    return {
      complaintOpen: false,
      form: {
          customers: {
              firstName : "",
              mobileNo : "",
              email : "",
          },
          contents: {
              message : "",
              moduleId : 10,
              leadFrom : "Complaint/Suggestions"
          }
      },
    };
  },
  methods: {
    isString(e) {
        let selectedCharCode = String.fromCharCode(e.keyCode);
        if(/^[A-Za-z @.]+$/.test(selectedCharCode)) return true;
        else e.preventDefault();
    },
    isNumber(e){
        let selectedCharCode = String.fromCharCode(e.keyCode);
        if(/^[0-9+]+$/.test(selectedCharCode)) return true;
        else e.preventDefault();
    },
    isEmail(e){
        let selectedCharCode = String.fromCharCode(e.keyCode);
        if(/^[A-Za-z 0-9@.]+$/.test(selectedCharCode)) return true;
        else e.preventDefault();
    },
    complaintBtn() {
      this.complaintOpen = !this.complaintOpen;
      document.body.style.overflow = "hidden";
    },
    tryClose() {
      this.complaintOpen = false;
      document.body.style.overflow = "auto";
    },
    submitDetails(event){
      if(this.form.customers.mobileNo == ""){
          this.$toast.error("Please Enter  mobile No.");
          return false;
      }else{
          this.$inertia.post('/addContactDetails', this.form,{
              onSuccess: (response) => {
                  window.location.href = '/Website/thankYou';
              }
          });
      }
    }
  },
};
</script>