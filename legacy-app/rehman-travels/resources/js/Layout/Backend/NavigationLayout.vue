<script setup>
import Dropdown from "@/Components/Dropdown.vue";
import DropdownLink from "@/Components/DropdownLink.vue";
</script>

<template>
  <div class="sticky top-0 z-20">
    <nav class="bg-bgRGTBaseColor flex py-1 justify-between shadow-lg">
      <div class="logo-size flex-wrap items-center justify-start py-2 px-5">
        <!-- Logo -->
        <a href="#" class="flex items-center bg-white">
          <img src="/rgt-logo.webp" alt="Logo" />
        </a>
      </div>
      <ul id="toggle-nav" :class="NavClass"
        class="bg-bgRGTBaseColor absolute right-3 justify-center items-center md:flex-row md:flex md:static md:mt-2 md:right-0 top-[4.5rem] md:top-0 md:w-full rounded-lg md:rounded-none shadow-md md:shadow-none cursor-pointer">
        <!-- Dashboard -->
        <li>
          <a class="block px-3 py-2 rounded-md hover:bg-white hover:text-rGTBaseTextColor text-white"
            :href="route('dashboard')" :active="route().current('dashboard')">Dashboard
          </a>
        </li>

        <!-- Umrah -->
        <li v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.department == 4" class="block group py-2 px-3 hover:text-rGTBaseTextColor hover:bg-white hover:rounded-md duration-300 text-white"
          @click="umrahNavMenuDropdownBtn" ref="umrahMenu" id="umrahNavMenuDropdownBtn"
          data-dropdown-toggle="umrahDropdownMenu">
          Umrah
          <ul v-if="umrahDropdown" id="umrahDropdownMenu"
            class="bg-white p-2 mt-2 absolute min-w-[200px] text-black text-xs font-normal rounded-xl shadow-xl animate">
            <li>
              <a :href="route('umrah.umrah-all-pages')"
                class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">All Umrah Pages
              </a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a :href="route('umrah.hotel')"
                class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Hotels</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a :href="route('umrah.vehicle-sector-price')"
                class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Transport-Sector
                Price</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a :href="route('umrah.visas')"
                class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Visa</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a :href="route('umrah.umrah-ubc')" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Umrah Custom Packages</a>
            </li>
          </ul>
        </li>

        <!-- Hotel -->
        <li v-if="$page.props.auth.user.department == 1" class="block py-2 px-3 hover:text-rGTBaseTextColor hover:bg-white hover:rounded-md duration-300 text-white"
          @click="hotelNavMenuDropdownBtn" ref="hotelMenu" id="hotelNavMenuDropdownBt"
          data-dropdown-toggle="hotelDropdownMenu">
          Hotels
          <!-- Hotel Dropdown List -->
          <ul v-if="hotelDropdown" id="hotelDropdownMenu"
            class="bg-white p-2 mt-2 absolute min-w-[200px] text-black text-xs font-normal rounded-xl shadow-xl animate">
            <li>
              <a :href="route('hotel.all-hotel-pages')"
                class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Hotel (Add, Edit,
                Delete)</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Bookings</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Hotel Master
                List</a>
            </li>
          </ul>
        </li>

        <!-- Visa -->
        <li v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.department == 3" class="block py-2 px-3 hover:text-rGTBaseTextColor hover:bg-white hover:rounded-md duration-300 text-white"
          @click="visaNavMenuDropdownBtn" ref="visaMenu" id="visaNavMenuDropdownBt"
          data-dropdown-toggle="visaDropdownMenu">
          Visa

          <!-- Visa Dropdown List -->
          <ul v-if="visaDropdown" id="visaDropdownMenu"
            class="bg-white p-2 mt-2 absolute min-w-[200px] text-black text-xs font-normal rounded-xl shadow-xl animate">
            <li>
              <a :href="route('visa.all-visa-pages')"
                class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">All Visa
                Pages</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a :href="route('visa.all-visa-packages')"
                class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">All Visa
                Packages</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Client Email</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Study Visa</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Visa Application</a>
            </li>
          </ul>
        </li>
        <!-- hajj -->
        <li v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.department == 4">
          <a
          :href="route('hajj.hajj-dashboard')"
          class="block py-2 px-3 hover:text-rGTBaseTextColor text-white hover:bg-white hover:rounded-md duration-300 mainDiv">
          Hajj</a>
        </li>
        <!-- world-tour -->
        <li v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.department == 3">
          <a
          :href="route('world-tour.all-world-tour-details')"
          class="block py-2 px-3 hover:text-rGTBaseTextColor text-white hover:bg-white hover:rounded-md duration-300 mainDiv">World
            Tour</a>
        </li>

        <!-- pakistan-tour -->
        <li v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.department == 9">
          <a
          :href="route('pakistan-tour.all-pakistan-tour-details')"
          class="block py-2 px-3 hover:text-rGTBaseTextColor text-white hover:bg-white hover:rounded-md duration-300 mainDiv">Pakistan Tour</a>
        </li>

        <!-- Airline Content -->
        <li v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.department == 7">
          <a :href="route('all-airlines-details')" class="block py-2 px-3 hover:text-rGTBaseTextColor text-white hover:bg-white hover:rounded-md duration-300 mainDiv">Airline
            Content</a>
        </li>

        <!-- Site Contents -->
        <li v-if="$page.props.auth.user.department == 1 || $page.props.auth.user.department == 7" class="block py-2 px-3 hover:text-rGTBaseTextColor hover:bg-white hover:rounded-md duration-300 text-white"
          @click="siteContentsNavMenuDropdownBtn" ref="siteContentsMenu" id="siteContentsNavMenuDropdownBt"
          data-dropdown-toggle="siteContentsDropdownMenu">
          Site Contents
          <!-- Site Contents Dropdown List -->
          <ul v-if="siteContentsDropdown" id="siteContentsDropdownMenu"
            class="md:grid md:grid-cols-3 md:gap-2 bg-white p-2 mt-2 absolute min-w-[400px] text-black text-xs font-normal rounded-xl shadow-xl animate">
             <li>
              <a href="/study-immigration-dashboard/all-immigration-details" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Manage Study/Immigrations</a>
            </li>
            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Deals</a>
            </li>
            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">All Bookings</a>
            </li>
            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Sightseeing</a>
            </li>
            <li>
              <a :href="route('franchise.index')" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Franchise</a>
            </li>
            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Queries</a>
            </li>
            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">About Us</a>
            </li>
            <li>
              <a :href="route('bankAccounts.index')" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Our Banks</a>
            </li>
            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Organisation Chart</a>
            </li>
            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">News Updates</a>
            </li>
            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Photo Gallary</a>
            </li>
            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Slider Image</a>
            </li>
            <li>
              <a :href="route('branches.index')" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Branches</a>
            </li>
            <li>
              <a href="/dashboard/flights" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Flight Page</a>
            </li>
          </ul>
        </li>

        <!-- Rent A Car -->
        <li v-if="$page.props.auth.user.department == 1" class="block py-2 px-3 hover:text-rGTBaseTextColor hover:bg-white hover:rounded-md duration-300 text-white"
          @click="rentCarNavMenuDropdownBtn" ref="rentCarMenu" id="rentCarNavMenuDropdownBt"
          data-dropdown-toggle="rentCarDropdownMenu">
          Online Hotel
          <!-- Rent A Car Dropdown List -->
          <ul v-if="rentCarDropdown" id="rentCarDropdownMenu"
            class="bg-white p-2 mt-2 absolute min-w-[200px] text-black text-xs font-normal rounded-xl shadow-xl animate">
            <li>
              <a href="/manage-hotel/hotels" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Manage Hotels</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a href="/manage-hotel/leads" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Active Leads</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a href="/manage-hotel/bookings" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">All Bookings</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a href="/hotel-markup/markup" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Hotel Markup %</a>
            </li>
          </ul>
        </li>

        <!-- Progress Report -->
        <li v-if="$page.props.auth.user.department == 1" class="block py-2 px-3 hover:text-rGTBaseTextColor hover:bg-white hover:rounded-md duration-300 text-white"
          @click="progressReportNavMenuDropdownBtn" ref="progressReportMenu" id="progressReportNavMenuDropdownBt"
          data-dropdown-toggle="progressReportDropdownMenu">
          Progress Report
          <!-- Progress Report Dropdown List -->
          <ul v-if="progressReportDropdown" id="progressReportDropdownMenu"
            class="bg-white p-2 mt-2 absolute min-w-[200px] text-black text-xs font-normal rounded-xl shadow-xl animate">
            <li>
              <a href="/client-concent-form" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Call Back Forms</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />
            <li>
              <a href="/reports/visa-report" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Visit Visa Reports</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a href="/reports/study-report" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Study Visa Reports</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />
            
            <li>
              <a href="/subscribe/allSubscribers" class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText">Subscribers</a>
            </li>
            <hr class="w-40 my-1 mx-auto" />

            <li>
              <a class="block px-4 py-2 rounded-md hover:bg-NavdropHoverBg hover:text-NavdropHoverText" :href="route('cmsQueries')">Reports</a>
            </li>
          </ul>
        </li>
        <!-- Users And It's Permissions -->
        <li v-if="$page.props.auth.user.department == 1">
          <a :href="route('users.index')" class="block py-2 px-3 hover:text-rGTBaseTextColor text-white hover:bg-white hover:rounded-md duration-300 mainDiv">Users</a>
        </li>
      </ul>

      <div class="items-center px-9 py-3">
        <!-- Toggle Navbar Button show below Medium Screen -->
        <button @click="toggleNav" data-collapse-toggle="toggle-nav" type="button"
          class="inline-flex md:hidden items-center justify-center p-2 w-10 h-10 rounded-md text-txtColor focus:outline-none focus:ring-2 focus:ring-txtColor"
          aria-controls="toggle-nav" aria-expanded="false">
          <!-- Cross Inside Button -->
          <img v-if="colapse" src="assets/Cross.svg" alt="Logo" />
          <!-- Bars Inside Button -->
          <svg v-else class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none"
            viewBox="0 0 17 14">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M1 1h15M1 7h15M1 13h15" />
          </svg>
        </button>
      </div>

      <div class="hidden sm:flex sm:items-center sm:mr-6">
        <div class="relative">
          <Dropdown align="right" width="48">
            <template #trigger>
              <span class="flex rounded-md">
                <button type="button"
                  class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-gray-500 bg-white hover:text-gray-700 focus:outline-none transition ease-in-out duration-150">
                  {{ $page.props.auth.user.name }}

                  <svg class="ml-2 -mr-0.5 h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"
                    fill="currentColor">
                    <path fill-rule="evenodd"
                      d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                      clip-rule="evenodd" />
                  </svg>
                </button>
              </span>
            </template>
            <template #content>
              <DropdownLink :href="route('profile.edit')">
                Profile
              </DropdownLink>
              <DropdownLink :href="route('logout')" method="post" as="button">Log Out</DropdownLink>
            </template>
          </Dropdown>
        </div>
      </div>
    </nav>
  </div>
</template>
<script>
export default {
  data() {
    return {
    vendorId:1,
    agentId:0,
    parentId:0,
    userId:0,
    markupType:"",
    colapse: false,
    umrahDropdown: false,
    hotelDropdown: false,
    visaDropdown: false,
    rentCarDropdown: false,
    progressReportDropdown: false,
    siteContentsDropdown: false,
    menuType:"",
    displayType:'hidden',
    };
  },
  computed: {
    NavClass() {
      return {
        hidden: !this.colapse, //when colapse:false - hiden:true and vice versa
        animate: this.colapse,
      };
    },
  },
    created() {
        const loggedIn = this.$page.props.auth.loggedIn
        this.vendorId = loggedIn.vendorId
        this.agentId = loggedIn.agentId
        this.parentId = loggedIn.parentId
        this.userId = loggedIn.userId
        this.markupType = loggedIn.markupType
    },
  methods: {
    dropdownNov(displayType,menuType){
          this.displayType =(displayType == "hidden" ? "block" :  "hidden")
          this.menuType = menuType
      },
    toggleNav() {
      this.colapse = !this.colapse;
    },
    umrahNavMenuDropdownBtn() {
      this.umrahDropdown = !this.umrahDropdown;
      if (this.umrahDropdown) {
        window.addEventListener("click", this.UmrahCloseDropdown);
      }
    },
    UmrahCloseDropdown(event) {
      if (this.$refs.umrahMenu && !this.$refs.umrahMenu.contains(event.target)) {
        this.umrahDropdown = false;
      }
    },
    hotelNavMenuDropdownBtn() {
      this.hotelDropdown = !this.hotelDropdown;
      if (this.hotelDropdown) {
        window.addEventListener("click", this.hotelCloseDropdown);
      }
    },
    hotelCloseDropdown(event) {
      if (
        this.$refs.hotelMenu &&
        !this.$refs.hotelMenu.contains(event.target)
      ) {
        this.hotelDropdown = false;
      }
    },
    visaNavMenuDropdownBtn() {
      this.visaDropdown = !this.visaDropdown;
      if (this.visaDropdown) {
        window.addEventListener("click", this.visaCloseDropdown);
      }
    },
    visaCloseDropdown(event) {
      if (this.$refs.visaMenu && !this.$refs.visaMenu.contains(event.target)) {
        this.visaDropdown = false;
      }
    },
    rentCarNavMenuDropdownBtn() {
      this.rentCarDropdown = !this.rentCarDropdown;
      if (this.rentCarDropdown) {
        document.addEventListener("click", this.rentCarCloseDropdown);
      }
    },
    rentCarCloseDropdown(event) {
      if (
        this.$refs.rentCarMenu &&
        !this.$refs.rentCarMenu.contains(event.target)
      ) {
        this.rentCarDropdown = false;
      }
    },
    progressReportNavMenuDropdownBtn() {
      this.progressReportDropdown = !this.progressReportDropdown;
      if (this.progressReportDropdown) {
        window.addEventListener("click", this.progressReportCloseDropdown);
      }
    },
    progressReportCloseDropdown(event) {
      if (
        this.$refs.progressReportMenu &&
        !this.$refs.progressReportMenu.contains(event.target)
      ) {
        this.progressReportDropdown = false;
      }
    },
    siteContentsNavMenuDropdownBtn() {
      this.siteContentsDropdown = !this.siteContentsDropdown;
      if (this.siteContentsDropdown) {
        window.addEventListener("click", this.siteContentsCloseDropdown);
      }
    },
    siteContentsCloseDropdown(event) {
      if (
        this.$refs.siteContentsMenu &&
        !this.$refs.siteContentsMenu.contains(event.target)
      ) {
        this.siteContentsDropdown = false;
      }
    },
  },
};
</script>

<style scoped>
.animate {
  -webkit-animation: slide-top 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94) both;
  animation: slide-top 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94) both;
}

@-webkit-keyframes slide-top {
  0% {
    -webkit-transform: translateY(10px);
  }

  100% {
    -webkit-transform: translateY(0);
  }
}

@keyframes slide-top {
  0% {
    transform: translateY(10px);
  }

  100% {
    transform: translateY(0);
  }
}
</style>
