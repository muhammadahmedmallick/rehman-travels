<template>
<div :class="`${subscribe ? 'fixed' : 'hidden'} right-0 z-[999] inset-0 bg-gray-500 filter bg-opacity-75 transition-opacity`"></div>
  <div :class="`${subscribe ? 'flex fixed' : 'hidden'} w-full card duration-1000 justify-center top-[8rem] lg:top-[10rem] 2xl:top-[17rem] z-[9999] transition delay-700 ease-in-out`">
    <div class="relative w-[80%] sm:w-[45%] card-inner top-20 md:px-4 py-4 rounded-md border border-slate-300 bg-bgRGTBaseColor xs:p-6">
      <div v-if="!isSuccess">
        <svg @click="closePopup()" xmlns="http://www.w3.org/2000/svg" class="absolute text-white right-2 top-2 h-6 w-6 cursor-pointer" fill="none"
          viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
        </svg>
        <div class="p-2 md:p-12 lg:px-16">
          <div class="max-w-lg">
            <h2 class="text-lg font-bold text-white md:text-3xl"><span class="hidden sm:block">Be The First To Get The Latest Deals.</span><span class="sm:hidden text-4xl flex">Subscribe <p class="text-lg font-extralight">for free</p></span></h2>
    
            <p class="text-white mt-2">
              <span class="hidden md:block">Subscribe now to get the Cheapest Ticket Prices with All other updates!</span><span class="block md:hidden text-sm font-extralight">Be First to Get the Latest Updates. </span>
            </p>
          </div>
    
          <div class="mt-8 max-w-xl">
            <form action="#" class="sm:flex sm:gap-4" @submit.prevent="submit">
              <div class="sm:flex-1">
                <label for="email" class="sr-only">Email</label>
    
                <input type="email" @keyup="EmptyInput('msg', input.email)" placeholder="Email address" v-model="input.email" required
                  class="w-full rounded-md border-indigo-200 bg-white p-3 text-indigo-700 shadow-sm transition focus:border-white focus:outline-none focus:ring focus:ring-indigo-400" />
              </div>
              <button type="submit"
                class="group mt-4 flex w-full items-center justify-center rounded-md bg-green-600 px-5 py-3 text-white transition focus:outline-none focus:ring focus:ring-indigo-400 sm:mt-0 sm:w-auto">
                <span class="text-sm font-medium"> Subscribe </span>
    
                <svg class="ml-3 h-5 w-5 transition-all group-hover:translate-x-2" xmlns="http://www.w3.org/2000/svg"
                  fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                </svg>
              </button>
            </form>
          </div>
          <p v-if="error.msg" class="text-white text-sm">{{ error.msg }}</p>
        </div>
      </div>
      <div v-else class="text-center m-auto w-full rounded-lg">
        <svg @click="closePopup()" xmlns="http://www.w3.org/2000/svg" class="absolute text-white right-2 top-2 h-6 w-6 cursor-pointer" fill="none"
          viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
        </svg>
        <div class="p-8 md:p-12 lg:px-16">
            <h2 class="text-2xl font-bold text-white md:text-3xl">You just Subscribed 🎉🎉</h2>
            <p class="hidden text-white sm:mt-4 sm:block">You will be the first to get the Cheapest Ticket Prices with All other updates!</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      subscribe: false,
      hasSeen: false,
      isSuccess: false,
      input: {
        email: '',
      },
      error : {
        msg: ''
      }
    };
  },
  mounted() {
    const lastClosed = localStorage.getItem('subscribePopupClosedAt');
    const lastStatus = localStorage.getItem('subscribeStatus');
    if (lastClosed) {
      const now = new Date().getTime();
      const closedAt = new Date(lastClosed).getTime();
      const thirtyMinutes = 30 * 60 * 1000;
      if (now - closedAt < thirtyMinutes) {
        this.hasSeen = true;
      }
    }
    if(lastStatus !== '1'){
      this.openSubscibe();
    }
  },
  methods: {
    EmptyInput(type, input){
      if(type == 'msg' && input !== ''){
        this.error.msg = '';
      }else{
        this.error.msg = 'Please enter a valid email address';
      }

    },
    submit(){
      if(!this.validateEmail(this.input.email)){
        this.error.msg = 'Please enter a valid email address';
      } else {
        this.$inertia.post('/subscribe/addSubscribe', { contents: this.input.email }, {
          onSuccess: () => {
            this.isSuccess = true;
            this.hasSeen = true;
            setTimeout(() => {
              this.subscribe = false;
            }, 5000);
            localStorage.setItem('subscribeStatus', '1');
          }
        });
      }
    },
    validateEmail(email) {
      const emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
      return emailRegex.test(email);
    },
    closePopup() {
      this.hasSeen = true;
      this.subscribe = false;
      localStorage.setItem('subscribePopupClosedAt', new Date().toISOString());
    },
    openSubscibe() {
      if(!this.hasSeen){
        setTimeout(() => {
          this.subscribe = true;
        }, 5000);
      }
    }
  }
}
</script>

<style scoped>
.popup-overlay {
  position: fixed;
  z-index: 9999;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}

.popup-content {
  background: white;
  padding: 20px;
  width: 20%;
  border-radius: 8px;
  text-align: center;
}
.card {
  perspective: 1000px;
}

.card-inner {
  transform-style: preserve-3d;
  transition: transform 0.999s;
}
</style>