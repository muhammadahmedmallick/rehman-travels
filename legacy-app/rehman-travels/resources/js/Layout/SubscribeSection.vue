<template>
  <section class="px-2 sm:px-4 pb-6 mx-auto w-[90%] sm:w-[78%] xl:w-[88%] 2xl:w-[78%]">
      <div class="bg-white rounded-lg xs:text-justify p-4">
          <div class="mx-auto sm:text-center">
              <form class="items-center" @submit.prevent="submit">
                  <div class="items-center mb-3 space-y-4 sm:flex sm:space-y-0">
                      <div class="relative w-full align-middle">
                          <h2 class="mb-4 text-xl md:text-2xl 2xl:text-4xl tracking-tight font-extrabold text-left text-gray-900">
                              Get the Latest Deals</h2>
                          <p class="text-left font-light text-gray-500 sm:text-sm dark:text-gray-400">Stay
                              up to date with announcements and exclusive discounts feel free to subscribe 
                              with your email.</p>
                      </div>
                      <div class="relative w-full">
                          <label for="email"
                              class="hidden mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Email
                              address</label>
                          <div class="flex absolute inset-y-0 left-0 items-center pl-3 pointer-events-none">
                              <svg class="w-5 h-5 text-gray-500 dark:text-gray-400" fill="currentColor"
                                  viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                                  <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z">
                                  </path>
                                  <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"></path>
                              </svg>
                          </div>
                          <input  @keyup="EmptyInput('email', input.email)" v-model="input.email"
                              class="block p-3 pl-10 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 sm:rounded-none sm:rounded-l-lg focus:ring-primary-500 focus:border-primary-500"
                              placeholder="Enter your email" type="email" id="email" required>
                      </div>
                      <div class="sm:ml-3">
                          <button type="submit"
                              class="py-3 px-5 w-full text-sm font-medium text-center text-white rounded-lg border cursor-pointer bg-bgRGTBaseColor border-primary-600 sm:rounded-none sm:rounded-r-lg hover:bg-primary-800 focus:ring-4 focus:ring-primary-300">Subscribe</button>
                      </div>
                  </div>
                  <p v-if="msg.error" class="text-red-600 font-bold text-end text-sm">{{ msg.error }}</p>
                  <p v-if="msg.success" class="text-green-600 font-semibold text-end text-xs">{{ msg.success }}</p>
              </form>
          </div>
      </div>
  </section>
</template>
<script>
import Service from "@/Config/Service.js";
export default {
data() {
  return {
    totalCount : 0,
    input: {
      email: '',
    },
    msg : {
      error: '',
      success: '',
    }
  };
},
mounted (){
  this.totalCount = localStorage.getItem('subscribeCount');
},
methods: {
  EmptyInput(type, input){
    if(type == 'email' && input !== ''){
      this.msg.error= '';
    }else{
      this.msg.error = 'Please enter a valid email address';
    }
  },
  submit(){
    if(!this.validateEmail(this.input.email)){
      this.msg.error = 'Please enter a valid email address';
        this.checkError();
    } else {
      if(this.totalCount > 3){
        this.msg.error = 'You are already Subscribed.';
        this.checkError();
      }else{
        this.msg.error = 'Please Wait.........!';
        Service.doFetchRequest("/subscribe/addSubscribe", 'POST', { contents: this.input.email }).then((data) => {
          this.msg.error = '';
          this.input.email = '';
          this.msg.success = 'You are the first to Get exclusive deals and discounts!';
          this.totalCount = ++this.totalCount;
          this.checkError();
          localStorage.setItem('subscribeCount', this.totalCount);
        });
      }
    }
  },
  checkError(){
    setTimeout(() => {
      this.msg.success = '';
      this.msg.error = '';
    }, 4000);
  },
  validateEmail(email) {
    const emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    return emailRegex.test(email);
  },
}
}
</script>