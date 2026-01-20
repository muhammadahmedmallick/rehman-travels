<template>
  <footer class="bg-bgRGTBaseColor">
    <div class="mx-auto w-full max-w-screen-xl py-6 lg:py-8">
      <div class="grid grid-cols-12 mr-[1rem] px-2 ml-[1rem]">
        <div class="col-span-12 md:col-span-3 mb-6 md:mb-0 md:mr-9">
          <a href="/" class="relative flex items-center align-middle justify-center mx-auto">
            <img :src="`${baseUrl}/rgt-logo_footer.webp`" class="md:w-[60%] me-3" alt="Rehman Travel Logo" width="163px" height="90px" />
          </a>
        </div>
        <div class="col-span-12 md:col-span-9">
          <div class="grid grid-cols-12 mr-[1rem]">
            <div :class="`col-span-6 ${$page.props.footer.salePoints ? 'md:col-span-3' : 'md:col-span-4'}`">
              <p class="mb-6 text-base xxs:text-lg font-semibold text-white uppercase underline md:no-underline">Quick Links</p>
              <ul class="text-white">
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="/" target="_blank" class="hover:underline text-white capitalize text-sm">Home</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a :href="route('flights')" target="_blank" class="hover:underline text-white capitalize text-sm">Flights</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a :href="route('aboutUs')" target="_blank" class="hover:underline text-white capitalize text-sm">About Us</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="/travel-agency/best-travel-agent-in-islamabad-pakistan"
                    class="hover:underline text-white capitalize text-sm">Travel Agency</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="/privacy" class="hover:underline text-white capitalize text-sm">Privacy Policy</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="/refund-policy" class="hover:underline text-white capitalize text-sm">Refund Policy</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a :href="route('contactUs')" target="_blank" class="hover:underline text-white capitalize text-sm">Contact
                    Us</a>
                </li>
              </ul>
            </div>
            <div :class="`col-span-6 ml-4 md:ml-0 ${$page.props.footer.salePoints ? 'md:col-span-3' : 'md:col-span-4'}`">
              <p class="mb-6 text-base xxs:text-lg font-semibold text-white uppercase underline md:no-underline">
              {{($page.props.getNum.country_code2 !== "PK" ? 'Best Visas' : 'Our Branches')}}
              </p>
              <ul class="text-white" v-if="$page.props.getNum.country_code2 === 'PK'">
                <li v-for="(branch, branchIndex) in $page.props.footer.branches" :key="branchIndex">
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a :href="'tel:' + branch.ContactNumber" target="_blank"
                    class="hover:underline text-white capitalize text-sm">{{ branch.branchName }}</a>
                </li>
              </ul>
              <ul class="text-white" v-else>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/visa/thailand-visa" target="_blank"
                    class="hover:underline text-white capitalize text-sm">Thailand</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/visa/malaysia-visa" target="_blank"
                    class="hover:underline text-white capitalize text-sm">Malaysia</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/visa/singapore" target="_blank"
                    class="hover:underline text-white capitalize text-sm">Singapore</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/visa/azerbaijan-visa" target="_blank"
                    class="hover:underline text-white capitalize text-sm">Azerbaijan</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/visa/canada-visit-visa" target="_blank"
                    class="hover:underline text-white capitalize text-sm">Canada</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/visa/us-visit-visa" target="_blank"
                    class="hover:underline text-white capitalize text-sm">United States</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/visa/turkey-visa" target="_blank"
                    class="hover:underline text-white capitalize text-sm">Turkey</a>
                </li>
              </ul>
            </div>
            <div v-if="$page.props.footer.salePoints" class="col-span-12 md:col-span-3">
              <p class="mb-3 md:mb-6 text-base mt-6 md:mt-0 xxs:text-lg font-semibold text-white uppercase underline md:no-underline">
                {{($page.props.getNum.country_code2 !== "PK" ? 'Umrah Packages' : 'Sale Points')}}
                </p>
              <ul class="text-white" v-if="$page.props.getNum.country_code2 === 'PK'">
                <li v-for="(salePoint, salePointIndex) in $page.props.footer.salePoints" :key="salePointIndex">
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a :href="'tel:' + salePoint.salePointNumber" target="_blank"
                    class="hover:underline text-white capitalize text-sm">{{ salePoint.salePointName }}</a>
                </li>
              </ul>
              <ul class="text-white" v-else>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/umrah-packages/executive" target="_blank"
                    class="hover:underline text-white capitalize text-sm">Executive</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/umrah-packages/economy" target="_blank"
                    class="hover:underline text-white capitalize text-sm">Economy</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/umrah-packages/umrah-e-visa" target="_blank"
                    class="hover:underline text-white capitalize text-sm">Umrah E Visa</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/umrah-packages/15-days-umrah-packages-from-pakistan" target="_blank"
                    class="hover:underline text-white capitalize text-sm">15 Days Umrah</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/umrah-packages/best-umrah-packages" target="_blank"
                    class="hover:underline text-white capitalize text-sm">Best Umrah Packages</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/umrah-packages/ramzan-umrah-packages" target="_blank"
                    class="hover:underline text-white capitalize text-sm">Ramazan Umrah Package</a>
                </li>
                <li>
                  <i class="fas fa-arrow-right text-xs"></i>&nbsp;
                  <a href="https://www.rehmantravel.com/umrah-packages/guide" target="_blank"
                    class="hover:underline text-white capitalize text-sm">Umrah Guide</a>
                </li>
              </ul>
            </div>
            <div :class="`col-span-12 ${$page.props.footer.salePoints ? 'md:col-span-3' : 'md:col-span-4'}`">
              <p class="mb-3 md:mb-6 mt-6 md:mt-0 text-base xxs:text-lg font-semibold text-white uppercase underline md:no-underline"> 
              Contact Us
              </p>
              <ul class="text-white">
                <li v-if="$page.props.getNum.landline">
                  <a target="_blank" :href="'tel:'+ $page.props.getNum.landline" class="hover:underline text-white flex">
                    <i class="fa fa-phone text-sm"></i>&nbsp; {{ $page.props.getNum.landline }}</a>
                </li>
                <li class="mt-3">
                  <a target="_blank" href="mailto:info@rehmantravel.com" class="hover:underline text-white flex">
                    <i class="fa fa-envelope-open text-sm"></i>&nbsp; info@rehmantravel.com</a>
                </li>
                <li class="mt-3" v-if="$page.props.getNum.address">
                  <a target="_blank"
                    :href="$page.props.getNum.googleMap" class="hover:underline text-white text-justify capitalize flex"><i
                      class="fa fa-map-marker-alt items-center"></i>
                    <p class="mr-3 ml-4 text-justify text-sm">{{ $page.props.getNum.address }}</p>
                  </a>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
      <hr class="my-6 border-gray-200 sm:mx-auto lg:my-8" />
      <div class="sm:flex px-4 sm:items-center sm:justify-between">
        <span class="text-sm text-white sm:text-center">© 2024 <a href="/" class="hover:underline">Exalted System™</a>.
          All Rights Reserved.
        </span>
        <div class="flex mt-4 sm:justify-center sm:mt-0">
          <a target="_blank" href="https://www.facebook.com/rehmantravelofficial" title="Facebook"
            class="text-white hover:text-gray-900">
            <svg class="w-4 h-4" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor"
              viewBox="0 0 8 19">
              <path fill-rule="evenodd"
                d="M6.135 3H8V0H6.135a4.147 4.147 0 0 0-4.142 4.142V6H0v3h2v9.938h3V9h2.021l.592-3H5V3.591A.6.6 0 0 1 5.592 3h.543Z"
                clip-rule="evenodd" />
            </svg>
            <span class="sr-only">Facebook page</span>
          </a>
          <a target="_blank" href="https://twitter.com/rehmantravelcom" title="Twitter"
            class="text-white hover:text-gray-900 ms-5">
            <svg class="w-4 h-4" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor"
              viewBox="0 0 20 17">
              <path fill-rule="evenodd"
                d="M20 1.892a8.178 8.178 0 0 1-2.355.635 4.074 4.074 0 0 0 1.8-2.235 8.344 8.344 0 0 1-2.605.98A4.13 4.13 0 0 0 13.85 0a4.068 4.068 0 0 0-4.1 4.038 4 4 0 0 0 .105.919A11.705 11.705 0 0 1 1.4.734a4.006 4.006 0 0 0 1.268 5.392 4.165 4.165 0 0 1-1.859-.5v.05A4.057 4.057 0 0 0 4.1 9.635a4.19 4.19 0 0 1-1.856.07 4.108 4.108 0 0 0 3.831 2.807A8.36 8.36 0 0 1 0 14.184 11.732 11.732 0 0 0 6.291 16 11.502 11.502 0 0 0 17.964 4.5c0-.177 0-.35-.012-.523A8.143 8.143 0 0 0 20 1.892Z"
                clip-rule="evenodd" />
            </svg>
            <span class="sr-only">Twitter page</span>
          </a>
          <a target="_blank" href="https://www.instagram.com/rehmantravel/" title="Instagram"
            class="text-white hover:text-gray-900 ms-5">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" fill="currentColor" class="w-4 h-4">
              <path
                d="M16 0c-4.349 0-4.891 0.021-6.593 0.093-1.709 0.084-2.865 0.349-3.885 0.745-1.052 0.412-1.948 0.959-2.833 1.849-0.891 0.885-1.443 1.781-1.849 2.833-0.396 1.020-0.661 2.176-0.745 3.885-0.077 1.703-0.093 2.244-0.093 6.593s0.021 4.891 0.093 6.593c0.084 1.704 0.349 2.865 0.745 3.885 0.412 1.052 0.959 1.948 1.849 2.833 0.885 0.891 1.781 1.443 2.833 1.849 1.020 0.391 2.181 0.661 3.885 0.745 1.703 0.077 2.244 0.093 6.593 0.093s4.891-0.021 6.593-0.093c1.704-0.084 2.865-0.355 3.885-0.745 1.052-0.412 1.948-0.959 2.833-1.849 0.891-0.885 1.443-1.776 1.849-2.833 0.391-1.020 0.661-2.181 0.745-3.885 0.077-1.703 0.093-2.244 0.093-6.593s-0.021-4.891-0.093-6.593c-0.084-1.704-0.355-2.871-0.745-3.885-0.412-1.052-0.959-1.948-1.849-2.833-0.885-0.891-1.776-1.443-2.833-1.849-1.020-0.396-2.181-0.661-3.885-0.745-1.703-0.077-2.244-0.093-6.593-0.093zM16 2.88c4.271 0 4.781 0.021 6.469 0.093 1.557 0.073 2.405 0.333 2.968 0.553 0.751 0.291 1.276 0.635 1.844 1.197 0.557 0.557 0.901 1.088 1.192 1.839 0.22 0.563 0.48 1.411 0.553 2.968 0.072 1.688 0.093 2.199 0.093 6.469s-0.021 4.781-0.099 6.469c-0.084 1.557-0.344 2.405-0.563 2.968-0.303 0.751-0.641 1.276-1.199 1.844-0.563 0.557-1.099 0.901-1.844 1.192-0.556 0.22-1.416 0.48-2.979 0.553-1.697 0.072-2.197 0.093-6.479 0.093s-4.781-0.021-6.48-0.099c-1.557-0.084-2.416-0.344-2.979-0.563-0.76-0.303-1.281-0.641-1.839-1.199-0.563-0.563-0.921-1.099-1.197-1.844-0.224-0.556-0.48-1.416-0.563-2.979-0.057-1.677-0.084-2.197-0.084-6.459 0-4.26 0.027-4.781 0.084-6.479 0.083-1.563 0.339-2.421 0.563-2.979 0.276-0.761 0.635-1.281 1.197-1.844 0.557-0.557 1.079-0.917 1.839-1.199 0.563-0.219 1.401-0.479 2.964-0.557 1.697-0.061 2.197-0.083 6.473-0.083zM16 7.787c-4.541 0-8.213 3.677-8.213 8.213 0 4.541 3.677 8.213 8.213 8.213 4.541 0 8.213-3.677 8.213-8.213 0-4.541-3.677-8.213-8.213-8.213zM16 21.333c-2.948 0-5.333-2.385-5.333-5.333s2.385-5.333 5.333-5.333c2.948 0 5.333 2.385 5.333 5.333s-2.385 5.333-5.333 5.333zM26.464 7.459c0 1.063-0.865 1.921-1.923 1.921-1.063 0-1.921-0.859-1.921-1.921 0-1.057 0.864-1.917 1.921-1.917s1.923 0.86 1.923 1.917z">
              </path>
            </svg>
            <span class="sr-only">Instagram page</span>
          </a>
          <a target="_blank" href="https://www.pinterest.com/rehmantravel" title="Pinterest"
            class="text-white hover:text-gray-900 ms-5">
            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="w-4 h-4" viewBox="0 0 16 16">
              <path
                d="M8 0a8 8 0 0 0-2.915 15.452c-.07-.633-.134-1.606.027-2.297.146-.625.938-3.977.938-3.977s-.239-.479-.239-1.187c0-1.113.645-1.943 1.448-1.943.682 0 1.012.512 1.012 1.127 0 .686-.437 1.712-.663 2.663-.188.796.4 1.446 1.185 1.446 1.422 0 2.515-1.5 2.515-3.664 0-1.915-1.377-3.254-3.342-3.254-2.276 0-3.612 1.707-3.612 3.471 0 .688.265 1.425.595 1.826a.24.24 0 0 1 .056.23c-.061.252-.196.796-.222.907-.035.146-.116.177-.268.107-1-.465-1.624-1.926-1.624-3.1 0-2.523 1.834-4.84 5.286-4.84 2.775 0 4.932 1.977 4.932 4.62 0 2.757-1.739 4.976-4.151 4.976-.811 0-1.573-.421-1.834-.919l-.498 1.902c-.181.695-.669 1.566-.995 2.097A8 8 0 1 0 8 0z">
              </path>
            </svg>
            <span class="sr-only">Pinterest page</span>
          </a>
          <a target="_blank" href="https://www.youtube.com/RehmanTravelsOfficial" title="Youtube"
            class="text-white hover:text-gray-900 ms-5">
            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="w-4 h-4" viewBox="0 0 16 16">
              <path
                d="M8.051 1.999h.089c.822.003 4.987.033 6.11.335a2.01 2.01 0 0 1 1.415 1.42c.101.38.172.883.22 1.402l.01.104.022.26.008.104c.065.914.073 1.77.074 1.957v.075c-.001.194-.01 1.108-.082 2.06l-.008.105-.009.104c-.05.572-.124 1.14-.235 1.558a2.007 2.007 0 0 1-1.415 1.42c-1.16.312-5.569.334-6.18.335h-.142c-.309 0-1.587-.006-2.927-.052l-.17-.006-.087-.004-.171-.007-.171-.007c-1.11-.049-2.167-.128-2.654-.26a2.007 2.007 0 0 1-1.415-1.419c-.111-.417-.185-.986-.235-1.558L.09 9.82l-.008-.104A31.4 31.4 0 0 1 0 7.68v-.123c.002-.215.01-.958.064-1.778l.007-.103.003-.052.008-.104.022-.26.01-.104c.048-.519.119-1.023.22-1.402a2.007 2.007 0 0 1 1.415-1.42c.487-.13 1.544-.21 2.654-.26l.17-.007.172-.006.086-.003.171-.007A99.788 99.788 0 0 1 7.858 2h.193zM6.4 5.209v4.818l4.157-2.408L6.4 5.209z">
              </path>
            </svg>
            <span class="sr-only">Youtube page</span>
          </a>
        </div>
      </div>
    </div>
  </footer>
</template>
<script>
export default {
  data() {
    return {
      baseUrl: "",
    }
  },
  created() {
    this.baseUrl = this.$page.props.ziggy.url;
  }
}
</script>