<template>
    <button type="button" @click="Topscroller" v-if="showScrollerBtn" class="fixed bottom-[10.3rem] sm:bottom-[9.5rem] right-7 md:right-5 z-1 cursor-pointer group focus:outline-none">
        <span
            class="flex items-center justify-center w-10 h-10 rounded-full hover:transition-all hover:duration-500 hover:ease-in-out transition-all duration-500 ease-in-out bg-[#006ee3] group-hover:bg-[#07315e] group-focus:outline-none">
            <i class="fas fa-arrow-up text-white"></i>
        </span>
    </button>
</template>

<script>
export default {
  data() {
    return {
      showScrollerBtn: false,
    };
  },
  methods: {
    handleScroll() {
      this.showScrollerBtn = window.scrollY > 1000;
    },
    Topscroller() {
      window.scrollTo({
        top: 0,
        behavior: 'smooth',
      });
    },
  },
  mounted() {
    window.addEventListener('scroll', this.handleScroll);
  },
  beforeUnmount() {
    window.removeEventListener('scroll', this.handleScroll);
  },
};
</script>
