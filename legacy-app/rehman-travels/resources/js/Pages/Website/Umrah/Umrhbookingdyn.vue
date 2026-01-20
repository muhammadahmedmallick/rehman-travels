<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
import Modal from '@/Components/Modal.vue';
import AutocompleteUmrah from "@/Pages/Website/Umrah/AutocompleteUmrah.vue"
import ChecInCheckOutDate from "@/Pages/Website/Umrah/ChecInCheckOutDate.vue"
</script>
<template>
    <GuestLayout>
        <section>
            <div class="grid grid-cols-12">
                <div class="col-span-12">
                    <div class="banner w-full" :style="'background-image:url(' + banner + ')'">
                        <div class="container mx-auto pb-12 xl:pb-24 pt-8">
                            <h2 class="text-white capitalize text-center text-xl md:text-3xl font-medium drop-shadow[0.125rem_0.125rem_0.125rem_gray] pb-4">
                                Book Your Umrah Package</h2>
                            <LoadingBar v-if="loading" />
                            <div class="flex lg:hidden gap-1">
                                <div class="-top-[33px] sm:-top-[36px] left-0 text-white flex justify-center items-center w-[5.5rem] xs:w-[6rem] sm:w-32 py-1 text-sm sm:text-xl font-semibold bg-bgRGTBaseColor rounded-tl-xl cursor-default">
                                    <a class="flex items-center" href="/flights" target="_blank">
                                        <svg fill="white" viewBox="0 0 24 24" class="w-[25px] h-[25px]">
                                            <path
                                                d="M21 16v-2l-8-5V3.5c0-.83-.67-1.5-1.5-1.5S10 2.67 10 3.5V9l-8 5v2l8-2.5V19l-2 1.5V22l3.5-1 3.5 1v-1.5L13 19v-5.5l8 2.5z">
                                            </path>
                                        </svg>
                                        Flights
                                    </a>
                                </div>
                                <div class="-top-[33px] sm:-top-[36px] left-[11.6rem] xxs:left-[12.5rem] sm:left-[16.6rem] text-white flex justify-center items-center w-[6rem] xs:w-[5.5rem] sm:w-32 py-1 text-sm sm:text-xl font-semibold bg-bgRGTBaseColor cursor-default">
                                    <a class="flex items-center" href="/visa" target="_blank">
                                        <svg height="24px" width="24px" class="mr-1" xmlns="http://www.w3.org/2000/svg"
                                            xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="-51.2 -51.2 614.40 614.40"
                                            xml:space="preserve" fill="white" stroke="#000000">
                                            <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                                            <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"
                                                stroke="#CCCCCC" stroke-width="1.024"></g>
                                            <g id="SVGRepo_iconCarrier">
                                                <g>
                                                    <path class="st0"
                                                        d="M270.465,279.817c4.674-3.824,9.136-9.612,12.926-16.946c1.258-2.431,2.414-5.116,3.519-7.887h-26.634v29.032 c1.334-0.069,2.651-0.171,3.968-0.29C266.327,282.775,268.408,281.5,270.465,279.817z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M216.295,200.236h35.457v-37.674h-29.626C218.743,173.636,216.643,186.485,216.295,200.236z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M215.947,254.984h-21.51c1.64,2.015,3.417,3.969,5.27,5.822c8.286,8.303,18.382,14.745,29.643,18.748 c-3.059-3.714-5.83-7.98-8.295-12.774C219.159,263.134,217.493,259.182,215.947,254.984z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M241.535,279.817c2.058,1.683,4.139,2.958,6.222,3.909c1.334,0.119,2.652,0.221,3.994,0.29v-29.032h-26.703 C229.476,266.058,235.281,274.701,241.535,279.817z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M222.083,246.452h29.669v-37.682h-35.474C216.626,222.519,218.709,235.37,222.083,246.452z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M295.706,208.769h-35.43v37.682h29.626C293.259,235.37,295.341,222.537,295.706,208.769z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M282.644,279.554c11.269-4.003,21.365-10.445,29.676-18.748c1.853-1.853,3.604-3.807,5.27-5.822h-21.536 C292.536,264.656,288.049,273.019,282.644,279.554z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M289.919,162.562h-29.643v37.674h35.472C295.375,186.485,293.31,173.636,289.919,162.562z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M304.23,200.236h31.292c-0.722-13.794-4.98-26.634-11.838-37.674h-24.85 C302.029,173.908,303.899,186.69,304.23,200.236z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M296.055,154.021h21.536c-1.666-2.023-3.417-3.96-5.27-5.813c-8.303-8.294-18.399-14.737-29.651-18.748 c3.051,3.706,5.83,7.989,8.278,12.765C292.842,145.862,294.533,149.84,296.055,154.021z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M270.465,129.188c-2.057-1.666-4.139-2.941-6.221-3.892c-1.318-0.119-2.634-0.221-3.968-0.298v29.023h26.677 C282.55,142.938,276.729,134.295,270.465,129.188z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M298.817,246.452h24.867c6.858-11.048,11.116-23.881,11.838-37.682h-31.249 C303.916,222.333,302.004,235.098,298.817,246.452z">
                                                    </path>
                                                    <polygon class="st0"
                                                        points="225.329,373.625 217.307,398.467 233.692,398.467 225.651,373.625 ">
                                                    </polygon>
                                                    <path class="st0"
                                                        d="M394.486,0h-276.97C83.453,0,55.84,27.612,55.84,61.674v388.66c0,34.054,27.613,61.666,61.676,61.666h276.97 c34.062,0,61.674-27.612,61.674-61.666V61.674C456.16,27.612,428.548,0,394.486,0z M256.009,104.712 c55.113,0,99.791,44.668,99.791,99.791c0,55.131-44.678,99.791-99.791,99.8c-55.13-0.009-99.791-44.669-99.808-99.8 C156.218,149.38,200.879,104.712,256.009,104.712z M164.037,399.615h-12.629c-0.424,0-0.629,0.204-0.629,0.62v23.694 c0,0.629-0.407,1.045-1.036,1.045h-13.259c-0.628,0-1.053-0.416-1.053-1.045v-68.881c0-0.629,0.424-1.046,1.053-1.046h27.553 c15.451,0,24.731,9.289,24.731,22.853C188.768,390.215,179.385,399.615,164.037,399.615z M256.859,424.974h-13.564 c-0.731,0-1.156-0.314-1.36-1.045l-4.079-12.417h-24.833l-3.978,12.417c-0.204,0.731-0.612,1.045-1.343,1.045H194.02 c-0.731,0-0.935-0.416-0.731-1.045l24.424-68.881c0.205-0.629,0.629-1.046,1.36-1.046h13.156c0.731,0,1.139,0.417,1.36,1.046 l24,68.881C257.794,424.558,257.59,424.974,256.859,424.974z M289.765,426.122c-11.066,0-21.807-4.386-27.348-9.706 c-0.408-0.416-0.629-1.147-0.103-1.776l7.938-9.077c0.408-0.526,1.038-0.526,1.564-0.11c4.692,3.765,11.065,7.308,18.578,7.308 c7.411,0,11.592-3.442,11.592-8.456c0-4.173-2.515-6.782-10.963-7.929l-3.757-0.519c-14.414-1.988-22.454-8.77-22.454-21.298 c0-13.045,9.824-21.705,25.156-21.705c9.399,0,18.17,2.812,24.119,7.411c0.628,0.416,0.73,0.833,0.204,1.564l-6.357,9.493 c-0.424,0.526-0.952,0.628-1.461,0.314c-5.439-3.544-10.658-5.422-16.504-5.422c-6.255,0-9.485,3.23-9.485,7.717 c0,4.071,2.924,6.68,11.049,7.836l3.772,0.518c14.601,1.981,22.336,8.661,22.336,21.502 C317.642,416.628,308.14,426.122,289.765,426.122z M351.908,426.122c-11.065,0-21.825-4.386-27.348-9.706 c-0.426-0.416-0.629-1.147-0.102-1.776l7.92-9.077c0.424-0.526,1.054-0.526,1.564-0.11c4.708,3.765,11.065,7.308,18.578,7.308 c7.41,0,11.592-3.442,11.592-8.456c0-4.173-2.499-6.782-10.964-7.929l-3.756-0.519c-14.397-1.988-22.436-8.77-22.436-21.298 c0-13.045,9.807-21.705,25.156-21.705c9.4,0,18.152,2.812,24.102,7.411c0.629,0.416,0.731,0.833,0.221,1.564l-6.374,9.493 c-0.408,0.526-0.934,0.628-1.462,0.314c-5.422-3.544-10.64-5.422-16.487-5.422c-6.272,0-9.502,3.23-9.502,7.717 c0,4.071,2.923,6.68,11.065,7.836l3.756,0.518c14.618,1.981,22.334,8.661,22.334,21.502 C379.766,416.628,370.264,426.122,351.908,426.122z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M225.1,154.021h26.652v-29.023c-1.343,0.077-2.66,0.178-3.994,0.298c-2.082,0.951-4.164,2.226-6.222,3.892 c-4.674,3.825-9.118,9.62-12.909,16.946C227.36,148.582,226.195,151.259,225.1,154.021z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M163.102,367.252h-11.694c-0.424,0-0.629,0.212-0.629,0.629v17.847c0,0.416,0.205,0.628,0.629,0.628h11.694 c6.459,0,10.334-3.756,10.334-9.502C173.436,371.118,169.561,367.252,163.102,367.252z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M213.184,162.562h-24.867c-6.858,11.04-11.099,23.881-11.838,37.674h31.249 C208.085,186.681,209.997,173.908,213.184,162.562z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M229.357,129.46c-11.252,3.994-21.357,10.454-29.651,18.748c-1.853,1.853-3.629,3.79-5.27,5.813h21.51 C219.465,144.366,223.978,135.987,229.357,129.46z">
                                                    </path>
                                                    <path class="st0"
                                                        d="M213.184,246.452c-3.212-11.354-5.065-24.118-5.413-37.682h-31.292c0.739,13.802,4.98,26.634,11.838,37.682 H213.184z">
                                                    </path>
                                                </g>
                                            </g>
                                        </svg>
                                        Visa
                                    </a>
                                </div>
                                <div class="-top-[33px] sm:-top-[36px] left-[11.6rem] xxs:left-[12.5rem] sm:left-[16.6rem] text-white flex justify-center items-center w-[6rem] xs:w-[5.5rem] sm:w-32 py-1 text-sm sm:text-xl font-semibold bg-green-600 rounded-tr-xl cursor-default">
                                    <a class="flex items-center" href="https://montyesim.app.link/HXPopQSc5Wb" target="_blank">
                                        <svg class="mr-1 w-[15px] sm:w-[25px] sm:h-[25px] h-[15px]" version="1.1" id="_x32_" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 512 512" xml:space="preserve" fill="#eeeeee"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"><g><path class="st0" d="M417.926,15.89C408.142,6.092,394.51-0.007,379.566,0h-63.23l-1.85,9.086 c-0.343,1.708-1.276,3.224-2.601,4.318c-1.335,1.094-2.938,1.721-4.813,1.728c-1.869-0.007-3.478-0.633-4.813-1.728 c-1.322-1.094-2.255-2.611-2.601-4.318L297.815,0h-83.627l-1.849,9.086c-0.346,1.708-1.279,3.224-2.601,4.318 c-1.335,1.094-2.941,1.721-4.81,1.728c-1.872-0.007-3.481-0.633-4.813-1.728c-1.322-1.094-2.258-2.611-2.601-4.318L195.664,0 h-63.23c-14.944-0.007-28.579,6.092-38.356,15.89c-9.801,9.784-15.896,23.413-15.89,38.36v342.874 c0,14.387,5.716,28.187,15.89,38.367l60.626,60.626C164.874,506.284,178.67,512,193.06,512h186.506 c14.944,0.006,28.576-6.086,38.36-15.884c9.797-9.784,15.89-23.419,15.886-38.367V54.25 C433.816,39.303,427.724,25.674,417.926,15.89z M411.116,457.75c-0.007,8.75-3.514,16.569-9.241,22.312 c-5.743,5.723-13.559,9.238-22.308,9.244H193.06c-8.367,0-16.391-3.329-22.308-9.244l-60.623-60.626 c-5.92-5.914-9.24-13.944-9.24-22.312V54.25c0.003-8.749,3.511-16.569,9.24-22.311c5.743-5.723,13.556-9.238,22.305-9.244h46.302 c1.813,3.139,4.151,5.921,6.916,8.203c5.205,4.325,11.99,6.936,19.276,6.936c7.279,0,14.067-2.611,19.272-6.936 c2.766-2.282,5.103-5.064,6.913-8.203h49.766c1.814,3.139,4.154,5.921,6.92,8.203c5.209,4.325,11.993,6.936,19.272,6.936 c7.282,0,14.067-2.611,19.276-6.936c2.766-2.282,5.104-5.064,6.916-8.203h46.302c8.749,0.007,16.566,3.521,22.308,9.244 c5.727,5.742,9.234,13.562,9.241,22.311V457.75z"></path><path class="st0" d="M323.668,81.988H188.332c-11.581,0-22.13,4.728-29.719,12.33c-7.599,7.589-12.33,18.138-12.326,29.723v135.335 c-0.004,11.578,4.727,22.127,12.326,29.716c7.589,7.596,18.138,12.33,29.719,12.33h135.335c11.582,0,22.131-4.734,29.723-12.33 c7.599-7.589,12.326-18.138,12.326-29.716V124.041c0-11.585-4.728-22.134-12.326-29.723 C345.798,86.716,335.249,81.988,323.668,81.988z M158.593,124.041c0-8.209,3.323-15.62,8.72-21.02 c5.407-5.4,12.808-8.723,21.02-8.723h63.564v30.251h-93.303V124.041z M158.593,132.757h72.949 c-10.147,7.562-16.74,19.628-16.744,33.263v0.574h-56.205V132.757z M158.593,174.796h56.205v9.323l2.548,1.048 c1.282,0.521,2.39,1.424,3.171,2.558c0.775,1.14,1.226,2.492,1.23,3.975c-0.003,1.497-0.455,2.842-1.23,3.976 c-0.781,1.141-1.889,2.038-3.171,2.565l-2.548,1.042v9.35h-56.205V174.796z M251.896,289.112h-63.564 c-8.212,0-15.613-3.33-21.02-8.716c-5.396-5.407-8.72-12.811-8.72-21.02v-0.501h93.303V289.112z M158.593,250.672v-33.837h60.069 h0.234H223V204.46c1.681-1.094,3.148-2.486,4.282-4.14c1.678-2.446,2.667-5.433,2.664-8.618c0.003-3.178-0.986-6.164-2.664-8.61 c-1.134-1.656-2.601-3.046-4.282-4.141v-12.93c0.004-9.211,3.725-17.518,9.758-23.558c5.789-5.783,13.664-9.409,22.417-9.706h2.298 c8.752,0.296,16.625,3.923,22.417,9.706c6.036,6.039,9.758,14.347,9.758,23.558v12.785c-1.734,1.081-3.25,2.472-4.421,4.154 c-1.737,2.466-2.766,5.506-2.762,8.742c-0.003,3.251,1.025,6.284,2.762,8.756c1.17,1.668,2.687,3.059,4.421,4.147v12.778 c0,9.218-3.722,17.525-9.758,23.564c-5.881,5.875-13.905,9.527-22.813,9.725H158.593z M353.41,259.376 c-0.004,8.208-3.327,15.613-8.726,21.02c-5.404,5.386-12.804,8.716-21.016,8.716h-63.563v-30.237h93.306V259.376z M353.41,250.672 h-72.329c10.16-7.569,16.767-19.642,16.77-33.29v-0.547h55.559V250.672z M353.41,208.634h-55.559v-9.33l-2.634-1.009 c-1.329-0.508-2.469-1.411-3.277-2.551c-0.804-1.154-1.269-2.519-1.272-4.042c0.003-1.51,0.468-2.881,1.272-4.028 c0.808-1.154,1.948-2.05,3.277-2.558l2.634-1.01v-9.31h55.559V208.634z M353.41,166.594h-55.559v-0.574 c-0.004-13.635-6.6-25.701-16.747-33.263h72.306V166.594z M353.41,124.549h-93.306V94.298h63.563 c8.212,0,15.613,3.323,21.016,8.723c5.4,5.4,8.723,12.81,8.726,21.02V124.549z"></path><path class="st0" d="M191.461,358.144l-4.365-0.607c-9.326-1.312-13.48-4.338-13.48-9.83c0-5.986,4.507-9.712,11.766-9.712 c6.64,0,12.85,2.044,19.523,6.402c0.112,0.066,0.204,0.099,0.287,0.099c0.168,0,0.323-0.152,0.392-0.231l7.398-11.044 c0.247-0.35,0.244-0.474,0.244-0.474c0-0.007-0.033-0.092-0.333-0.297c-6.946-5.36-16.974-8.44-27.511-8.44 c-17.264,0-28.421,9.594-28.421,24.429c0,13.575,8.542,21.626,25.378,23.947l4.358,0.606c9.498,1.285,13.372,4.174,13.372,9.949 c0,6.521-5.443,10.563-14.198,10.563c-7.441,0-14.855-2.901-22.022-8.638c-0.148-0.119-0.3-0.184-0.428-0.184 c-0.047,0-0.178,0-0.35,0.21l-9.191,10.523c-0.425,0.508,0.023,0.982,0.069,1.028c5.71,5.499,17.575,11.051,31.196,11.051 c19.474,0,31.573-9.64,31.573-25.16C216.717,368.37,208.456,360.459,191.461,358.144z"></path><path class="st0" d="M237.928,325.342c-0.313,0-0.455,0.145-0.455,0.455v79.904c0,0.31,0.142,0.455,0.455,0.455H253.3 c0.306,0,0.458-0.145,0.458-0.455v-79.904c0-0.304-0.152-0.455-0.458-0.455H237.928z"></path><path class="st0" d="M338.773,325.342c-0.676,0-1.002,0.198-1.24,0.758l-20.663,47.433h-1.47l-21.026-47.44 c-0.201-0.474-0.475-0.751-1.246-0.751h-14.403c-0.31,0-0.455,0.145-0.455,0.455v79.904c0,0.31,0.145,0.455,0.455,0.455h13.678 c0.307,0,0.455-0.145,0.455-0.455v-47.116h1.734l15.458,35.196c0.353,0.804,0.804,1.121,1.606,1.121h8.357 c0.791,0,1.25-0.317,1.606-1.121l15.452-35.196h1.737v47.116c0,0.31,0.145,0.455,0.455,0.455h13.682 c0.306,0,0.455-0.145,0.455-0.455v-79.904c0-0.304-0.149-0.455-0.455-0.455H338.773z"></path></g></g></svg>
                                        eSIM
                                    </a>
                                </div>
                            </div>
                            <div>
                                <form @submit.prevent="submit" class="relative grid grid-cols-12 pb-2 sm:py-6 bg-white rounded-md border border-dashed border-[#05153f]">
                                    <div class="col-span-12 lg:col-span-9">
                                        <div class="grid grid-cols-12 gap-2 mx-4 pb-6">
                                            <div class="col-span-12 hidden md:block">
                                                <div class="flex gap-5">
                                                    <div>
                                                        <input class="h-4 w-4" type="checkbox" id="UmrahVisa" checked="checked" v-model="umrahDyn.umrahVisa">
                                                        <label for="UmrahVisa" class="text-base font-semibold">&nbsp; Umrah Visa
                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input class="h-4 w-4" type="checkbox" id="transport" checked="checked"
                                                            v-model="umrahDyn.transport"
                                                            :onChange="umrahTransport(umrahDyn.transport)">
                                                        <label for="transport" class="text-base font-semibold">&nbsp; Transport
                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input class="h-4 w-4" type="checkbox" id="isFare" checked="checked"
                                                            v-model="umrahDyn.isFare">
                                                        <label for="isFare" class="text-base font-semibold">&nbsp; Add Fare
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div
                                            class="block mx-4 xs:hidden w-[90.4%] sm:w-[22%] md:w-[21%] lg:w-[17%] xl:w-[15%] 2xl:w-[13%] mb-3">
                                            <label
                                                class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                for="Check-in">
                                                Date of Travel
                                            </label>
                                            <div
                                                class="text-sm block w-full h-11 pl-3 text-gray-700 border border-gray-300 hover:border-gray-400 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                                <TravelingChecInCheckOutDate v-model="umrahDyn.travellingDate"
                                                    @update:outinboundDateDetail="travellingDateDetail"
                                                    flightType="one-way" :initialIndex=0 />
                                            </div>
                                        </div>
                                        <div class="flex flex-wrap gap-1 mx-4 pb-6"
                                            v-for="(hotel, hotelIndex) in umrahDyn.hotel" :key="hotelIndex">
                                            <div
                                                class="w-[49%] xs:w-[23%] sm:w-[22%] md:w-[21%] lg:w-[15%] xl:w-[12%] 2xl:w-[10%]">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                    :for="'localtion_' + hotelIndex">
                                                    Location-{{ hotelIndex + 1 }}
                                                </label>
                                                <select required @change="changeLocation(hotelIndex)"
                                                    class="text-sm block w-full h-11  border border-gray-300 hover:border-gray-400 text-gray-700 pr-4 pl-3 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    :id="'localtion_' + hotelIndex" v-model="hotel.location">
                                                    <option value="Makkah" selected>Makkah</option>
                                                    <option value="Madinah">Madinah</option>
                                                </select>
                                            </div>
                                            <div
                                                class="hidden md:block w-[49%] xs:w-[49.4%] sm:w-[22%] md:w-[21%] lg:w-[17%] xl:w-[15%] 2xl:w-[13%]">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                    for="Check-in">
                                                    Check In
                                                </label>
                                                <div
                                                    class="text-sm block w-full h-11  text-gray-700 border border-gray-300 hover:border-gray-400 rounded px-2 leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                                    <ChecInCheckOutDate v-model="hotel.checkIn"
                                                    @update:outinboundDateDetail="outinboundDateDetail"
                                                    :hotel="hotel"
                                                    type="checkIn"
                                                    flightType="round-trip" :initialIndex="hotelIndex" :tillDateHidden="tillDateHidden" />
                                                </div>
                                            </div>
                                            <div
                                                class="hidden md:block w-[49%] xs:w-[49.4%] sm:w-[22%] md:w-[21%] lg:w-[17%] xl:w-[15%] 2xl:w-[13%]">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                    for="Check-out">
                                                    Check Out
                                                </label>
                                                <div
                                                    class="text-sm block w-full h-11 text-gray-700 border border-gray-300 hover:border-gray-400 rounded px-2 leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                                    <ChecInCheckOutDate v-model="hotel.checkOut"
                                                        @update:outinboundDateDetail="outinboundDateDetail"
                                                        :hotel="hotel"
                                                        type="checkOut"
                                                        flightType="round-trip" :initialIndex="hotelIndex" :tillDateHidden="tillDateHidden" />
                                                </div>
                                            </div>
                                            <div
                                                class="block md:hidden w-[49.4%] sm:w-[26.6%] md:w-[25%] lg:w-[17%] xl:w-[12%] 2xl:w-[12%]">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                    for="Select-Room">
                                                    Select Nights
                                                </label>
                                                <select @change="calculateCheckInCheckOut(hotelIndex)" v-model="hotel.getNights"
                                                    class=" flex justify-center text-center px-1 text-sm  w-full h-11 text-gray-700 border border-gray-300 hover:border-gray-400 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3">3</option>
                                                    <option value="4">4</option>
                                                    <option value="5">5</option>
                                                    <option value="6">6</option>
                                                    <option value="7">7</option>
                                                    <option value="8">8</option>
                                                    <option value="9">9</option>
                                                    <option value="10">10</option>
                                                    <option value="11">11</option>
                                                    <option value="12">12</option>
                                                    <option value="13">13</option>
                                                    <option value="14">14</option>
                                                    <option value="15">15</option>
                                                    <option value="16">16</option>
                                                    <option value="17">17</option>
                                                    <option value="18">18</option>
                                                    <option value="19">19</option>
                                                    <option value="20">20</option>
                                                </select>
                                            </div>
                                            <div v-if="hotel.location == 'Makkah'"
                                                class="w-full xs:w-[76%] sm:w-[77%] md:w-[78%] lg:w-[48%] xl:w-[31%] 2xl:w-[37%]">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                    for="Hotel-in-Makkah">
                                                    Hotel in {{ hotel.location }}
                                                </label>
                                                <AutocompleteUmrah v-model="hotel.umrahHotelName"
                                                    @click="validHotel(hotelIndex)"
                                                    @update:autocompleteValue="umrahSelectedHotels"
                                                    :umrahHotels="umrahHotels" :initialIndex="hotelIndex" />
                                            </div>
                                            <div v-if="hotel.location == 'Madinah'"
                                                class="w-full xs:w-[76%] sm:w-[77%] md:w-[78%] lg:w-[48%] xl:w-[31%] 2xl:w-[37%]">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                    for="Hotel-in-Makkah">
                                                    Hotel in {{ hotel.location }}
                                                </label>
                                                <AutocompleteUmrah v-model="hotel.umrahHotelName"
                                                    @click="validHotel(hotelIndex)"
                                                    @update:autocompleteValue="umrahSelectedHotels"
                                                    :umrahHotels="umrahHotels" :initialIndex="hotelIndex" />
                                            </div>
                                            <div
                                                class="w-full xs:w-[49.4%] sm:w-[26.6%] md:w-[25%] lg:w-[17%] xl:w-[12%] 2xl:w-[12%]">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                    for="Select-Room">
                                                    Select Room
                                                </label>
                                                <div
                                                    class="flex justify-start px-1 text-sm  w-full h-11 text-gray-700 border border-gray-300 hover:border-gray-400 rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                                    <SelectRooms @hotelRooms="hotelRooms" :hotelIndex="hotelIndex" :hotel="hotel" />
                                                </div>
                                            </div>
                                            <div
                                                class="hidden md:block w-[48.4%] xs:w-[49.4%] sm:w-[27%] md:w-[31%] lg:w-[25%] xl:w-[11%] 2xl:w-[12%]">
                                                <div class="flex gap-1">
                                                    <div class="w-1/2">
                                                        <label
                                                            class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                            for="Rooms">
                                                            Rooms
                                                        </label>
                                                        <input type="text" aria-label="disabled input"
                                                            class="text-sm block w-full h-11  text-gray-700 border border-gray-300 hover:border-gray-400 rounded text-center leading-tight focus:outline-none focus:bg-white focus:border-blue-500 cursor-not-allowed"
                                                            v-model="umrahDyn.hotel[hotelIndex].totalRooms.rooms"
                                                            v-value="umrahDyn.hotel[hotelIndex].totalRooms.rooms" disabled>
                                                    </div>
                                                    <div class="w-1/2">
                                                        <label
                                                            class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                            for="Nights">
                                                            Nights
                                                        </label>
                                                        <input type="text" id="nights" aria-label="disabled input"
                                                            class="text-sm block w-full h-11  text-gray-700 border border-gray-300 hover:border-gray-400 rounded text-center leading-tight focus:outline-none focus:bg-white focus:border-blue-500 cursor-not-allowed"
                                                            :value="umrahDyn.hotel[hotelIndex].totalNights" disabled>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="w-full">
                                                <div class="grid grid-cols-12 mt-1" v-if="hotelIndex == umrahDyn.hotel.length - 1">
                                                    <div v-if="hotelIndex < 2" class="col-span-3 xs:col-span-2 md:col-span-2">
                                                        <button class="bg-green-600 text-white rounded-md px-5 py-3 md:py-2"
                                                            @click="cloneDiv(hotelIndex)"><i class="fa fa-add block md:hidden"></i><span class="hidden md:block">Add</span></button>
                                                    </div>
                                                    <div v-if="hotelIndex > 0" class="col-span-4 md:col-span-4">
                                                        <button class="bg-red-600 text-white rounded-md px-5 py-3 md:py-2"
                                                            @click="removeDiv(hotelIndex)"><i class="fa fa-close block md:hidden"></i><span class="hidden md:block">Remove</span></button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div
                                            class="flex flex-wrap gap-1 mx-4 mt-1 pb-1 border-t-[0.063rem] border-dashed border-[#ced4da]">
                                            <div class="col-span-12 mt-3 md:hidden">
                                                <div class="flex gap-5">
                                                    <div>
                                                        <input class="h-4 w-4" type="checkbox" id="UmrahVisa" checked="checked"
                                                            v-model="umrahDyn.umrahVisa">
                                                        <label for="UmrahVisa" class="text-sm font-semibold">&nbsp; Umrah Visa
                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input class="h-4 w-4" type="checkbox" id="transport" checked="checked"
                                                            v-model="umrahDyn.transport"
                                                            :onChange="umrahTransport(umrahDyn.transport)">
                                                        <label for="transport" class="text-sm font-semibold">&nbsp; Transport
                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input class="h-4 w-4" type="checkbox" id="isFare" checked="checked"
                                                            v-model="umrahDyn.isFare">
                                                        <label for="isFare" class="text-sm font-semibold">&nbsp; Add Fare
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div
                                            class="flex flex-wrap gap-1 mx-4 mt-4 pb-6 border-b-[0.063rem] border-dashed border-[#ced4da]">
                                            <div
                                                class="w-full hidden xs:w-[29%] sm:w-[27%] md:w-[20%] xl:w-[12.5%] 2xl:w-[10%]">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                    for="Select-Nationality">
                                                    Nationality
                                                </label>
                                                <select
                                                    class=" text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="Select-Nationality" v-model="umrahDyn.nationality">
                                                    <option value="0" selected>Pakistani</option>
                                                    <option value="1">Other</option>
                                                </select>
                                            </div>
                                            <div class="w-full block xs:hidden">
                                                <div :class="`${!umrahDyn.transport ? 'w-full' : 'flex gap-1'}`">
                                                    <div :class="`${!umrahDyn.transport ? 'w-full' : 'w-[49%]'}`">
                                                        <label
                                                            class="capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">
                                                            Select Traveler
                                                        </label>
                                                        <div
                                                            class="flex  items-center px-3 text-sm  w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded  leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                                            <svg xmlns="http://www.w3.org/2000/svg" height="18px" width="24px"
                                                                fill="#0181dd" viewBox="0 0 576 512" class="block md:hidden">
                                                                <path
                                                                    d="M432 96a48 48 0 1 0 0-96 48 48 0 1 0 0 96zM347.7 200.5c1-.4 1.9-.8 2.9-1.2l-16.9 63.5c-5.6 21.1-.1 43.6 14.7 59.7l70.7 77.1 22 88.1c4.3 17.1 21.7 27.6 38.8 23.3s27.6-21.7 23.3-38.8l-23-92.1c-1.9-7.8-5.8-14.9-11.2-20.8l-49.5-54 19.3-65.5 9.6 23c4.4 10.6 12.5 19.3 22.8 24.5l26.7 13.3c15.8 7.9 35 1.5 42.9-14.3s1.5-35-14.3-42.9L505 232.7l-15.3-36.8C472.5 154.8 432.3 128 387.7 128c-22.8 0-45.3 4.8-66.1 14l-8 3.5c-32.9 14.6-58.1 42.4-69.4 76.5l-2.6 7.8c-5.6 16.8 3.5 34.9 20.2 40.5s34.9-3.5 40.5-20.2l2.6-7.8c5.7-17.1 18.3-30.9 34.7-38.2l8-3.5zm-30 135.1l-25 62.4-59.4 59.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L340.3 441c4.6-4.6 8.2-10.1 10.6-16.1l14.5-36.2-40.7-44.4c-2.5-2.7-4.8-5.6-7-8.6zM256 274.1c-7.7-4.4-17.4-1.8-21.9 5.9l-32 55.4L147.7 304c-15.3-8.8-34.9-3.6-43.7 11.7L40 426.6c-8.8 15.3-3.6 34.9 11.7 43.7l55.4 32c15.3 8.8 34.9 3.6 43.7-11.7l64-110.9c1.5-2.6 2.6-5.2 3.3-8L261.9 296c4.4-7.7 1.8-17.4-5.9-21.9z" />
                                                            </svg>
                                                            <SelectTravellers @selectedTravelers="selectedTravelers" />
                                                        </div>
                                                    </div>
                                                    <div v-if="umrahDyn.transport" class="w-[49%]">
                                                        <label
                                                            class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                            for="Vehicle-Type">
                                                            Vehicle Type
                                                        </label>
                                                        <select
                                                            class="text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                            id="Vehicle-Type" v-model="umrahDyn.vehicle">
                                                            <option
                                                                v-for="(umrahVehicleService, umrahVehicleServiceIndex) in $page.props.umrahVehicleServices"
                                                                :value="umrahVehicleService.id">{{
                                                                    umrahVehicleService.vehicleName }}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div v-if="umrahDyn.transport" class="w-full mt-2">
                                                    <label
                                                        class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                        for="Select-Sector">
                                                        Transport Sector
                                                    </label>
                                                    <select
                                                        class="text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                        id="Select-Sector" v-model="umrahDyn.sector">
                                                        <option v-for="(umrahTransportSector, umrahTransportSectorIndex) in $page.props.umrahTransportSectors"
                                                        :value="umrahTransportSector.id">
                                                         {{ umrahTransportSector.sectorName }}
                                                        </option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div v-if="umrahDyn.transport"
                                                class="hidden xs:block w-full xs:w-[70%] sm:w-[72%] md:w-[50%] xl:w-[29.5%] 2xl:w-[28%]">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                    for="Select-Sector-Desk">
                                                    Transport Sector
                                                </label>
                                                <select
                                                    class="text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="Select-Sector-Desk" v-model="umrahDyn.sector">
                                                    <option
                                                        v-for="(umrahTransportSector, umrahTransportSectorIndex) in $page.props.umrahTransportSectors"
                                                        :value="umrahTransportSector.id"> {{ umrahTransportSector.sectorName }}
                                                    </option>
                                                </select>
                                            </div>
                                            <div v-if="umrahDyn.transport"
                                                class="hidden xs:block w-[49%] xs:w-[29%] sm:w-[27%] md:w-[27%] xl:w-[17%] 2xl:w-[18%]">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                    for="Vehicle-Type-Desk">
                                                    Vehicle Type
                                                </label>
                                                <select
                                                    class="text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="Vehicle-Type-Desk" v-model="umrahDyn.vehicle">
                                                    <option
                                                        v-for="(umrahVehicleService, umrahVehicleServiceIndex) in $page.props.umrahVehicleServices"
                                                        :value="umrahVehicleService.id">{{ umrahVehicleService.vehicleName }}
                                                    </option>
                                                </select>
                                            </div>
                                            <div
                                                class="hidden xs:block w-[49%] xs:w-[27%] sm:w-[31%] md:w-[20%] xl:w-[16%] 2xl:w-[15%]">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2">
                                                    Select Traveler
                                                </label>
                                                <div
                                                    class="flex items-center px-3 text-sm  w-full h-10 text-gray-700 border border-gray-300 hover:border-gray-400 rounded  leading-tight focus:outline-none focus:bg-white focus:border-blue-500">
                                                    <svg xmlns="http://www.w3.org/2000/svg" height="18px" width="24px"
                                                        fill="#0181dd" viewBox="0 0 576 512" class="hidden xs:block">
                                                        <path
                                                            d="M432 96a48 48 0 1 0 0-96 48 48 0 1 0 0 96zM347.7 200.5c1-.4 1.9-.8 2.9-1.2l-16.9 63.5c-5.6 21.1-.1 43.6 14.7 59.7l70.7 77.1 22 88.1c4.3 17.1 21.7 27.6 38.8 23.3s27.6-21.7 23.3-38.8l-23-92.1c-1.9-7.8-5.8-14.9-11.2-20.8l-49.5-54 19.3-65.5 9.6 23c4.4 10.6 12.5 19.3 22.8 24.5l26.7 13.3c15.8 7.9 35 1.5 42.9-14.3s1.5-35-14.3-42.9L505 232.7l-15.3-36.8C472.5 154.8 432.3 128 387.7 128c-22.8 0-45.3 4.8-66.1 14l-8 3.5c-32.9 14.6-58.1 42.4-69.4 76.5l-2.6 7.8c-5.6 16.8 3.5 34.9 20.2 40.5s34.9-3.5 40.5-20.2l2.6-7.8c5.7-17.1 18.3-30.9 34.7-38.2l8-3.5zm-30 135.1l-25 62.4-59.4 59.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L340.3 441c4.6-4.6 8.2-10.1 10.6-16.1l14.5-36.2-40.7-44.4c-2.5-2.7-4.8-5.6-7-8.6zM256 274.1c-7.7-4.4-17.4-1.8-21.9 5.9l-32 55.4L147.7 304c-15.3-8.8-34.9-3.6-43.7 11.7L40 426.6c-8.8 15.3-3.6 34.9 11.7 43.7l55.4 32c15.3 8.8 34.9 3.6 43.7-11.7l64-110.9c1.5-2.6 2.6-5.2 3.3-8L261.9 296c4.4-7.7 1.8-17.4-5.9-21.9z" />
                                                    </svg>
                                                    <SelectTravellers @selectedTravelers="selectedTravelers" />
                                                </div>
                                            </div>
                                            <div class=" w-full xs:w-[42%] sm:w-[40%] md:w-[50%] xl:w-[22%] 2xl:w-[29%]">
                                                <div class="flex gap-1">
                                                    <div class="w-1/2">
                                                        <label
                                                            class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                            for="t-rooms">
                                                            Total Rooms
                                                        </label>
                                                        <input type="text" id="t-rooms" aria-label="disabled input"
                                                            class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500 cursor-not-allowed"
                                                            :value="umrahDyn.grandRooms" disabled>
                                                    </div>
                                                    <div class="w-1/2">
                                                        <label
                                                            class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2"
                                                            for="t-Nights">
                                                            Total Nights
                                                        </label>
                                                        <input type="text" id="t-Nights" aria-label="disabled input"
                                                            class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500 cursor-not-allowed"
                                                            :value="umrahDyn.grandNights" disabled>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div v-if="umrahDyn.isFare"
                                            :class="`grid grid-cols-4 gap-1 mx-4 mt-2 pb-6 bg-bgRGTBaseColor p-3 rounded`">
                                            <div
                                                class="col-span-2 sm:col-span-1">
                                                <label class="block capitalize tracking-wide text-white text-xs sm:text-sm font-semibold mb-2"
                                                    for="adultPrice">
                                                    Adult Ticket Fare
                                                </label>
                                                <input v-model="umrahDyn.fares.adultPrice"
                                                    class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="adultPrice" type="text" placeholder="Adult Price">
                                            </div>
                                            <div
                                                class="col-span-2 sm:col-span-1">
                                                <label
                                                    class="block capitalize tracking-wide text-white text-xs sm:text-sm font-semibold mb-2"
                                                    for="childPrice">
                                                    Child Ticket Fare
                                                </label>
                                                <input v-model="umrahDyn.fares.childPrice"
                                                    class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="childPrice" type="text" placeholder="Child Price">
                                            </div>
                                            
                                            <div
                                                class="col-span-2 sm:col-span-1">
                                                <label
                                                    class="block capitalize tracking-wide text-white text-xs sm:text-sm font-semibold mb-2"
                                                    for="infantPrice">
                                                    Infant Ticket Fare
                                                </label>
                                                <input v-model="umrahDyn.fares.infantPrice"
                                                    class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="infantPrice" type="text" placeholder="Infant Price">
                                            </div>
                                            
                                            <div
                                                class="col-span-2 sm:col-span-1">
                                                <label
                                                    class="block capitalize tracking-wide text-white text-xs sm:text-sm font-semibold mb-2"
                                                    for="selectedCurrency">
                                                    Fare Currency
                                                </label>
                                                <select
                                                    class="text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="selectedCurrency" v-model="umrahDyn.fares.selectedCurrency">
                                                    <option
                                                        v-for="(currency, currencyIndex) in $page.props.currencies"
                                                        :value="currency.currencyCode" :key="currencyIndex">{{ currency.currencyCode }}
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div
                                        class="col-span-12 mt-1 lg:mt-0 lg:col-span-3 mx-4 lg:border-l-[0.063rem] lg:border-dashed lg:border-gray-600 lg:px-4">
                                        <div class="grid grid-cols-12 gap-2 lg:gap-0  lg:grid-cols-1">
                                            <div class="col-span-12 xs:col-span-6 sm:col-span-6 lg:col-span-4 xl:col-span-2">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2 mt-2"
                                                    for="f-name">
                                                    Name
                                                </label>
                                                <input v-model="umrahDyn.customers.firstName"
                                                    class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="f-name" type="text" placeholder="Full Name">
                                            </div>
                                            <div
                                                class="col-span-12 hidden md:block xs:col-span-6 sm:col-span-6 lg:col-span-4 xl:col-span-2">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2 mt-2"
                                                    for="email">
                                                    Email
                                                </label>
                                                <input v-model="umrahDyn.customers.email"
                                                    class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="email" type="email" placeholder="Email">
                                            </div>
                                            <div class="col-span-6 lg:col-span-4 xl:col-span-2">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2 mt-2"
                                                    for="contactNo">
                                                    Contact <span class="text-red-500">*</span>
                                                </label>
                                                <input v-model="umrahDyn.customers.mobileNo"
                                                    class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="contactNo" type="tel" placeholder="Phone Number">
                                            </div>
                                            <div class="block md:hidden col-span-6 lg:col-span-4 xl:col-span-2">
                                                <label
                                                    class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2 mt-2"
                                                    for="customerEmail">
                                                    Email
                                                </label>
                                                <input v-model="umrahDyn.customers.email"
                                                    class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="customerEmail" type="email" placeholder="Email">
                                            </div>
                                            <div class="hidden col-span-5 xs:col-span-6 sm:col-span-6 lg:col-span-4 xl:col-span-2">
                                                <label class="block capitalize tracking-wide text-blue-500 text-xs sm:text-sm font-semibold mb-2 mt-2"
                                                    for="city">
                                                    City
                                                </label>
                                                <select 
                                                    v-model="umrahDyn.city"
                                                    class="text-sm block w-full h-10  border border-gray-300 hover:border-gray-400 text-gray-700  pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                    id="city">
                                                    <option value="1" class="leading-7 bg-[#f9f9fa] hover:bg-blue-500 h-3">Islamabad</option>
                                                    <option value="2" class="leading-7 bg-[#f9f9fa] hover:bg-blue-500 ">Karachi</option>
                                                    <option value="3" class="leading-7 bg-[#f9f9fa] hover:bg-blue-500">Lahore</option>
                                                    <option value="4" class="leading-7 bg-[#f9f9fa] hover:bg-blue-500">Peshawar</option>
                                                    <option value="5" class="leading-7 bg-[#f9f9fa] hover:bg-blue-500">Mirpur</option>
                                                    <option value="6" class="leading-7 bg-[#f9f9fa] hover:bg-blue-500">Others</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-span-12 lg:col-span-9 text-center lg:ml-10 mt-4">
                                        <button type="button" @click="reset()"
                                            class="focus:outline-none text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2">
                                            <i class="fa fa-refresh" aria-hidden="true"></i> Reset Form</button>
                                        <button type="button" @click="umrahBookingQuery()"
                                            class="focus:outline-none text-white bg-green-700 hover:bg-green-800 focus:ring-4 focus:ring-green-300 font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2">
                                            <i class="fa fa-calculator"></i> Calculate UBC</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <Modal :show="isModalVisible" @close="closeModal" :modalWidth="modalWidth">
            <div class="overflow-auto px-2 md:pt-2">
                <div class="w-[100%] mx-auto" id="printUmrah" v-html="$page.props.packageHtml.ubcHTML">
                </div>
            </div>
            <div class="px-4 py-3 flex flex-1 bg-white backdrop-blur-xl backdrop-brightness-150 rounded justify-end sm:px-6" v-if="checkCustomWhatsapp == true">
                <div class="mt-3 inline-flex w-full">
                    <input v-model="customWhatsapp"
                        class="text-sm block w-full h-10  text-gray-700 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                        id="whatsapp" type="text" placeholder="Whatsapp #">
                </div>
                <div class="ml-4 inline-flex w-full">
                    <button type="button" @click="whatsappCustom($page.props.packageHtml.whatsappApiCustom)"
                    class="mt-3 inline-flex w-full justify-center items-center rounded-md bg-green-600 px-3 py-1 text-sm font-semibold text-white shadow-sm ring-1 ring-inset sm:mt-0 sm:w-auto mr-3"><i class="fa fa-paper-plane"></i></button>
                    <button type="button" @click="customWhatsappDiv()"
                    class="mt-3 inline-flex w-full justify-center items-center rounded-md bg-red-600 px-3 py-1 text-sm font-semibold text-white shadow-sm ring-1 ring-inset sm:mt-0 sm:w-auto mr-3"><i class="fa fa-close"></i></button>
                </div>
            </div>
            <div class="px-4 py-3 flex flex-1 justify-end sm:px-6" id="UmrahUbcClosebtn">
                <button type="button" @click="customWhatsappDiv()" v-if="checkCustomWhatsapp == false"
                    class="mt-3 inline-flex whitespace-nowrap w-full justify-center items-center rounded-md bg-green-600 pr-2 md:px-3 py-3 text-sm font-semibold text-white shadow-sm ring-1 ring-inset sm:mt-0 sm:w-auto mr-3"><i class="fa-brands fa-whatsapp hidden sm:block"></i>&nbsp; Other Whatsapp</button>
                <button type="button" @click="whatsapp($page.props.packageHtml.whatsappApi)"
                    class="mt-3 inline-flex w-full justify-center items-center rounded-md bg-green-600 px-0 md:px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset sm:mt-0 sm:w-auto mr-3"><i class="fa-brands fa-whatsapp hidden sm:block"></i>&nbsp; Whatsapp</button>
                <button v-print="'#printUmrah'" type="button"
                    class="hidden mt-3 md:inline-flex w-full justify-center items-center rounded-md bg-green-600 px-0 md:px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset sm:mt-0 sm:w-auto mr-3"><i class="fa fa-print hidden sm:block"></i>&nbsp; Print</button>
                <button type="button"
                    class="mt-3 inline-flex w-full justify-center rounded-md items-center bg-rGTBorderColor px-0 md:px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset sm:mt-0 sm:w-auto mr-3"><i class="fa fa-file hidden sm:block"></i>&nbsp; PDF</button>
                <button @click="closeModal()" type="button"
                    class="hidden md:inline-flex w-full justify-center rounded-md bg-red-600 px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset sm:mt-0 sm:w-auto">Close</button>
            </div>
            <div class="md:hidden px-4 py-3 flex flex-1 justify-end sm:px-6">
                <button @click="closeModal()" type="button"
                    class="inline-flex w-full justify-center rounded-md bg-red-600 px-3 py-2 text-sm font-semibold text-white shadow-sm ring-1 ring-inset sm:mt-0 sm:w-auto">Close</button>
            </div>
        </Modal>
        <section>
            <div class="w-[90%] mx-auto">
                <div class="grid grid-cols-12 mt-4">
                    <div
                        class=" col-span-12 lg:col-span-8 mb-4 relative flex flex-col break-words bg-white bg-clip-border border-[1px] border-solid border-[rgba(0,0,0,.125)] rounded-[0.25rem]">
                        <div class="p-4">
                            <div class="col-span-12 mb-3 mt-4">
                                <h2 class="text-[#f89923] text-lg rounded py-2 px-4 w-fit bg-[#f899231c] border border-dashed border-[#f89923]">
                                    {{ $page.props.umrahPackages.packageTitle }}</h2>
                            </div>
                            <div class="col-span-12 mb-4">
                                <p class="text-justify mt-2 text-lg mb-0 frondEnd"
                                    v-html="$page.props.umrahPackages.shortDescription">
                                </p>
                            </div>
                            <div class="col-span-12 text-justify mb-5 frondEnd"
                                v-html="$page.props.umrahPackages.description">
                            </div>
                        </div>
                        <div class="md:pt-3  py-0 md:py-0 hidden md:block">
                            <div class="bg-white rounded-lg xs:text-justify">
                                <div class="my-3 w-full">
                                    <h3
                                        class="text-xl uppercase bg-bgRGTBaseColor text-white p-[0rem_0.7rem] mb-3 font-medium leading-[2.875rem] md:text-start text-center">
                                        request a callback</h3>
                                </div>
                                <form class="w-full p-3" @submit.prevent="submit">
                                    <div class="grid grid-cols-12 gap-2">
                                        <div class="col-span-12 md:col-span-4">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="text" v-model="form.customers.firstName" placeholder="Your Name">
                                        </div>
                                        <div class="col-span-12 md:col-span-4">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="number" v-model="form.customers.mobileNo" placeholder="Phone No">
                                        </div>
                                        <div class="col-span-12 md:col-span-4">
                                            <input
                                                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                                type="email" v-model="form.customers.email" placeholder="Email">
                                        </div>
                                    </div>
                                    <div class="grid grid-cols-12 gap-3">
                                        <div class="col-span-12 md:col-span-8">
                                            <textarea rows="40" cols="40" v-model="form.contents.message"
                                                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"> Message</textarea>
                                        </div>
                                        <div class="col-span-12 md:col-span-2 md:mb-0 mb-4">
                                            <input type="submit" @click="submitDetails()"
                                                class=" w-full p-2 text-xl bg-blue-100 text-blue-800 border border-solid border-blue-500 text-center transition-all duration-700 ease-in-out rounded hover:bg-bgRGTBaseColor hover:text-white hover:transition-all hover:ease-in-out hover:duration-700">
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="sm:col-span-12 lg:col-span-4 sm:mx-3 sm:mt-0 mt-4 col-span-12 w-full">
                        <div class="col-span-12 sm:mx-4">
                            <div>
                                <h3
                                    class="text-xl rounded bg-bgRGTBaseColor text-white p-[0rem_0.7rem] mb-3 font-medium text-center leading-[2.875rem]">
                                    Request a Callback</h3>
                            </div>
                        </div>
                        <div class="col-span-12 sm:mx-4">
                            <form @submit.prevent="submit">
                                <div class="relative">
                                    <input type="text" id="name" v-model="form.customers.firstName"
                                        class="block rounded-t-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="name"
                                        class="absolute text-sm text-black duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">Name
                                        <span class="text-red-600">*</span></label>
                                </div>
                                <div class="relative mt-3">
                                    <input type="tel" id="phone-number" v-model="form.customers.mobileNo"
                                        class="block rounded-t-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="phone-number"
                                        class="absolute text-sm text-black duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                                        Phone Number <span class="text-red-600">*</span></label>
                                </div>
                                <div class="relative mt-3">
                                    <input type="email" id="Email" v-model="form.customers.email"
                                        class="block rounded-t-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer"
                                        placeholder=" " />
                                    <label for="Email"
                                        class="absolute text-sm text-black duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                                        Email <span class="text-red-600">*</span></label>
                                </div>
                                <div class="relative mt-3">
                                    <textarea id="textArea" v-model="form.contents.message"
                                        class="block rounded-t-lg px-2.5 pb-2.5 pt-5 w-full text-sm text-gray-900 border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer h-24"
                                        placeholder=""></textarea>
                                    <label for="textArea"
                                        class="absolute text-sm text-black duration-300 transform -translate-y-4 scale-75 top-4 z-10 origin-[0] left-2.5 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-4">
                                        Type a Message <span class="text-red-600">*</span></label>
                                </div>
                                <div class="relative mt-3">
                                    <input type="submit" @click="submitDetails()"
                                        class=" w-full p-2 text-xl bg-blue-100 text-blue-800 border border-solid border-blue-500 text-center transition-all duration-700 ease-in-out rounded hover:bg-bgRGTBaseColor hover:text-white hover:transition-all hover:ease-in-out hover:duration-700">
                                </div>

                            </form>
                        </div>
                        <div class="col-span-12 sm:mx-4 ">
                            <div
                                class="my-3 border-2 border-dashed border-gray-400 p-3 bg-gray-200 rounded text-center justify-center">
                                <h3 class=" text-blue-800 mb-2">For additional information, kindly get in touch via:</h3>
                                <i class=" fa fa-phone text-blue-600"></i>
                                <a href="tel:923345555121" class="text-blue-800">(+92)3345555121</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </GuestLayout>
</template>

<script>
import moment from 'moment';
import SelectTravellers from '@/Layout/Website/SelectTravellers.vue';
import SelectRooms from '@/Layout/Website/SelectRooms.vue';
import LoadingBar from "../Ticketing/LoadingBar.vue";
import TravelingChecInCheckOutDate from "./TravelingChecInCheckOutDate.vue";
export default {
    components: {
        SelectTravellers,
        SelectRooms
    },
    data() {
        return {
            modalWidth: "sm:w-[100%] md:w-[85%] xl:w-[65%] umrahBanner",
            banner: "",
            loading: false,
            checkCustomWhatsapp: false,
            customWhatsapp: '',
            umrahHotels: [],
            tillDateHidden : '',
            isModalVisible: false,
            form: {
                customers: {
                    firstName: "",
                    mobileNo: "",
                    email: "",
                },
                contents: {
                    message: "",
                    moduleId: 3,
                    leadFrom: ""
                }
            },
            autoCompleteinitialIndex: {
                initialIndex: 0,
                initialDate: {
                    start: '',
                    end: ''
                }
            },
            umrahDyn: {
                travellingDate :  moment(new Date(), "DD-MM-YYYY").add(10, 'day').format("DD-MM-YYYY"),
                isFare: false,
                hotel: [{
                    location: "Makkah",
                    umrahHotelId: "",
                    umrahHotelName: "",
                    checkIn: '',
                    checkOut: '',
                    totalNights: 0,
                    getNights: 0,
                    totalRooms: {
                        Double: 0,
                        Triple: 0,
                        Quad: 0,
                        Quint: 0,
                        rooms: 0,
                    }
                }],
                travellers: {
                    adultCount: 1,
                    childCount: 0,
                    infantCount: 0,
                    totalTraveller: 1
                },
                customers: {
                    firstName: "",
                    email: "",
                    mobileNo: "",
                },
                fares: {
                    adultPrice: 0,
                    childPrice: 0,
                    infantPrice: 0,
                    bookingCustomerId: 0,
                    selectedCurrency:'USD',
                    sector:'',
                    departure: '',
                    arrival: '',
                },
                grandRooms: 0,
                grandNights: 0,
                transport: true,
                umrahVisa: true,
                sector: "",
                vehicle: "",
                nationality: "0",
                city: 1
            },
            isXlScreen : false
        }
    },
    watch: {
        modelValue(modelValue) {
            this.display = modelValue;
        }
    },
    mounted() {
        this.isXlScreen = window.innerWidth > 640;
        this.banner = '/assets/Umrah/economy-banner.webp';
        if(this.isXlScreen){
            for(let hotelIndex in this.umrahDyn.hotel){
                if(hotelIndex == 0){
                    this.umrahDyn.hotel[hotelIndex].checkIn = moment(new Date()).add(3, 'days').format('DD-MM-YYYY')
                    this.umrahDyn.hotel[hotelIndex].checkOut = moment(new Date()).add(6, 'days').format('DD-MM-YYYY')
                    this.autoCompleteinitialIndex.initialDate.start = new Date(moment().add(3, 'days').toDate())
                    this.autoCompleteinitialIndex.initialDate.end = new Date(moment().add(6, 'days').toDate())
                    this.outinboundDateDetail(this.autoCompleteinitialIndex)
                }else{
                    this.umrahDyn.hotel[hotelIndex].checkIn = moment(this.umrahDyn.hotel[hotelIndex-1].checkOut, "DD-MM-YYYY").toDate()
                    this.umrahDyn.hotel[hotelIndex].checkOut = moment(this.umrahDyn.hotel[hotelIndex-1].checkOut, "DD-MM-YYYY").add(6, 'days').toDate()
                }
            }        
        }
    },
    methods: {
        changeLocation(index){
            if(this.umrahDyn.hotel.length > 1){
                if(this.umrahDyn.hotel[index].location == 'Makkah'){
                    this.umrahDyn.hotel[index+1].location = 'Madinah';
                    this.umrahDyn.hotel[index].umrahHotelId = "";
                    this.umrahDyn.hotel[index].umrahHotelName = "";
                    this.umrahDyn.hotel[index].totalNights = 0;
                    this.hotelChangeCheckInOut(index);
                }else{
                    this.umrahDyn.hotel[index+1].location = 'Makkah';
                    this.umrahDyn.hotel[index].umrahHotelId = "";
                    this.umrahDyn.hotel[index].umrahHotelName = "";
                    this.umrahDyn.hotel[index].totalNights = 0;
                    this.hotelChangeCheckInOut(index);
                }
            }
        },
        travellingDateDetail(dateDetail){
            this.umrahDyn.travellingDate = dateDetail.initialDate.start;
            for (let hotelIndex in this.umrahDyn.hotel){
                if(hotelIndex > 0){
                    this.calculateCheckInCheckOut(hotelIndex);
                }else{
                    this.calculateCheckInCheckOut(dateDetail.initialIndex);
                }
            }
        },
        hotelChangeCheckInOut(hotelIndex){
            if(this.umrahDyn.hotel[hotelIndex].checkIn && this.umrahDyn.hotel[hotelIndex].checkOut){
                this.calculateCheckInCheckOut(hotelIndex);
            }
        },
        calculateCheckInCheckOut(hotelIndex) {
            let umrahNights = this.umrahDyn.hotel[hotelIndex].getNights;
            let travellingDate = this.umrahDyn.travellingDate;
            
            if (hotelIndex == 0) {
                if (!this.isXlScreen) {
                    this.umrahDyn.hotel[hotelIndex].checkIn = moment(travellingDate, "DD-MM-YYYY").format("DD-MM-YYYY");
                    this.umrahDyn.hotel[hotelIndex].checkOut = moment(this.umrahDyn.hotel[hotelIndex].checkIn, "DD-MM-YYYY").add(umrahNights, "days").format("DD-MM-YYYY");
                }
            } else {
                let previousHotelIndex = hotelIndex - 1;
                if (!this.isXlScreen) {
                    this.umrahDyn.hotel[hotelIndex].checkIn = moment(this.umrahDyn.hotel[previousHotelIndex].checkOut, "DD-MM-YYYY").format("DD-MM-YYYY");
                    this.umrahDyn.hotel[hotelIndex].checkOut = moment(this.umrahDyn.hotel[previousHotelIndex].checkOut, "DD-MM-YYYY").add(umrahNights, "days").format("DD-MM-YYYY");
                }
            }
            
            // Update subsequent hotels if they exist
            if (hotelIndex < this.umrahDyn.hotel.length - 1) {
                const nextIndex = hotelIndex + 1;
                this.umrahDyn.hotel[nextIndex].checkIn = this.umrahDyn.hotel[hotelIndex].checkOut;
                this.umrahDyn.hotel[nextIndex].checkOut = moment(this.umrahDyn.hotel[nextIndex].checkIn, "DD-MM-YYYY").add(this.umrahDyn.hotel[nextIndex].getNights || 6, "days").format("DD-MM-YYYY");
                
                // Trigger validation and night calculation for the next hotel
                this.checkHotelAvailability(nextIndex);
                this.checkNumDays(nextIndex);
            }
            
            let validHotel = this.validHotel(hotelIndex);
            this.checkHotelAvailability(hotelIndex);
            if (validHotel != "undefined" || validHotel != "HotelNotFound") {
                this.checkNumDays(hotelIndex);
            }
        },
        selectedTravelers(traveller) {
            this.umrahDyn.travellers.adultCount = traveller.adultsCount;
            this.umrahDyn.travellers.childCount = traveller.childrenCount;
            this.umrahDyn.travellers.infantCount = traveller.infantsCount;
            this.umrahDyn.travellers.totalTraveller = traveller.totalTraveller;
        },
        submitDetails() {
            if (this.form.customers.mobileNo == "") {
                this.$toast.error("Please Enter  mobile No.");
                return false;
            } else {
                this.$inertia.post('/addContactDetails', this.form, {
                    onSuccess: (response) => {
                        window.location.href = '/Website/thankYou';
                    }
                });
            }
        },
        umrahTransport(transport) {
            if (!transport) {
                this.umrahDyn.sector = "";
                this.umrahDyn.vehicle = "";
            };
        },
        hotelRooms(hotelRooms) {
            this.umrahDyn.grandRooms = 0;
            let hotel = this.umrahDyn.hotel;
            for (let hotelIndex in hotel) {
                if (hotelRooms.hotelIndex == hotelIndex) {
                    this.umrahDyn.hotel[hotelIndex].totalRooms = hotelRooms;
                }
                this.umrahDyn.grandRooms += this.umrahDyn.hotel[hotelIndex].totalRooms.rooms;
            }
        },
        cloneDiv(index) {
            const prevCheckOut = this.umrahDyn.hotel[index].checkOut;
            const newCheckIn = prevCheckOut;
            const newCheckOut = moment(prevCheckOut, "DD-MM-YYYY").add(6, 'days').format("DD-MM-YYYY");

            this.umrahDyn.hotel.push({
                location: (this.umrahDyn.hotel[index].location == "Makkah" ? "Madinah" : "Makkah"),
                umrahHotelId: "",
                umrahHotelName: "",
                checkIn: newCheckIn,
                checkOut: newCheckOut,
                totalNights: 6,
                totalRooms: {
                    Double: 0,
                    Triple: 0,
                    Quad: 0,
                    Quint: 0,
                    rooms: 0,
                }
            });

            
            let validHotel = this.validHotel(index+1);
            console.log("validHotel", validHotel);
            this.checkHotelAvailability(index+1);
            this.umrahDyn.grandNights += 6;
        },
        removeDiv(index) {
            let totalNights = this.umrahDyn.hotel[index].totalNights;
            let grandNights = this.umrahDyn.grandNights;
            let gdNights = grandNights - totalNights;
            this.umrahDyn.grandNights = gdNights;
            let totalRoom = this.umrahDyn.hotel[index].totalRooms.rooms;
            let grandRooms = this.umrahDyn.grandRooms;
            let gdRoom = grandRooms - totalRoom;
            this.umrahDyn.grandRooms = gdRoom;
            this.umrahDyn.hotel.splice(index, 1);
        },
        closeModal() {
            this.isModalVisible = false;
            document.body.style.overflow = "auto";
        },
        umrahSelectedHotels(umrahSelectedHotels) {
            this.umrahDyn.hotel[umrahSelectedHotels.initialIndex].umrahHotelId = umrahSelectedHotels.initialItem.id;
            this.umrahDyn.hotel[umrahSelectedHotels.initialIndex].umrahHotelName = umrahSelectedHotels.initialItem.hotelName + " " +(umrahSelectedHotels.initialItem.hotelType == 'economy' || umrahSelectedHotels.initialItem.hotelType == 'economy-plus' ? umrahSelectedHotels.initialItem.hotelType : umrahSelectedHotels.initialItem.hotelType + ' Star');
        },
        outinboundDateDetail(dateDetail) {
            console.log(dateDetail);
            if (dateDetail.initialDate !== undefined) {
                this.umrahDyn.hotel[dateDetail.initialIndex].checkIn = moment(dateDetail.initialDate.start, 'DD-MM-YYYY').format('DD-MM-YYYY');
                this.umrahDyn.hotel[dateDetail.initialIndex].checkOut = moment(dateDetail.initialDate.end, 'DD-MM-YYYY').format('DD-MM-YYYY');
                this.tillDateHidden = moment(dateDetail.initialDate.end, 'DD-MM-YYYY').format('DD-MM-YYYY');
                
                if (dateDetail.initialIndex < this.umrahDyn.hotel.length - 1) {
                    const nextIndex = dateDetail.initialIndex + 1;
                    this.umrahDyn.hotel[nextIndex].checkIn = moment(dateDetail.initialDate.end, 'DD-MM-YYYY').format('DD-MM-YYYY');
                    this.umrahDyn.hotel[nextIndex].checkOut = moment(dateDetail.initialDate.end, 'DD-MM-YYYY').add(6, 'days').format('DD-MM-YYYY');
                    
                    this.checkHotelAvailability(nextIndex);
                    this.checkNumDays(nextIndex);
                }
                
                this.checkNumDays(dateDetail.initialIndex);
            } else {
                this.$toast.error('Please select hotel first!');
                this.umrahDyn.hotel[dateDetail.initialIndex].checkIn = "";
                this.umrahDyn.hotel[dateDetail.initialIndex].checkOut = "";
                this.umrahDyn.hotel[dateDetail.initialIndex].getNights = "";
            }
        },
        validHotel(index) {
            const parseDate = (dateStr) => {
                if (!dateStr) return null;
                const [day, month, year] = dateStr.split("-");
                return year + "-" + month + "-" + day;
            };
            let umrahHotel = this.umrahDyn.hotel[index];
            let checkIn = null; 
            let checkOut = null;
            if (typeof umrahHotel?.checkIn === 'string' && umrahHotel.checkIn.includes(" - ")) { 
                const [checkInStr, checkOutStr] = umrahHotel.checkIn.split(" - ");
                checkIn = parseDate(checkInStr.trim());
                checkOut = parseDate(checkOutStr.trim());
            } else {
                checkIn = moment(umrahHotel.checkIn, "DD-MM-YYYY").format("YYYY-MM-DD");
                checkOut = moment(umrahHotel.checkOut, "DD-MM-YYYY").format("YYYY-MM-DD");
            }
            if (umrahHotel.checkIn != "" || umrahHotel.checkOut != "") {
                if (umrahHotel.location == "Makkah") {
                    let MakkahHotel = this.$page.props.umrahHotelMakkah;
                    this.umrahHotels = [];
                    for (let hotelIndex in MakkahHotel) {
                        let roomPeriods = MakkahHotel[hotelIndex].hotel_room_periods;
                        let result = "HotelNotFound";
                        for (let roomPeriodIndex in roomPeriods) {
                            // console.log('user selected ', checkIn, checkOut);
                            // console.log('hotel avaible dates ', roomPeriods[roomPeriodIndex].periodFrom, roomPeriods[roomPeriodIndex].periodTo);
                            if ((roomPeriods[roomPeriodIndex].periodFrom >= checkIn && roomPeriods[roomPeriodIndex].periodTo <= checkOut) || (roomPeriods[roomPeriodIndex].periodTo >= checkIn && roomPeriods[roomPeriodIndex].periodFrom <= checkOut)) {
                                result = "HotelFound";
                            }
                        }
                        if(result == "HotelFound"){
                            this.umrahHotels[hotelIndex] = MakkahHotel[hotelIndex];
                        }
                        // console.log('result', result);
                        // console.log(this.umrahHotels + ' asdfsdfdsafasdfd');
                        // return result;
                    }
                    if(this.umrahHotels && this.umrahHotels.length){
                        return "HotelFound";
                    }else{
                        return "HotelNotFound";
                    }
                }
                if (umrahHotel.location == "Madinah") {
                    this.umrahHotels = [];
                    let MadinahHotel = this.$page.props.umrahHotelMadinah;
                    for (let hotelIndex in MadinahHotel) {
                        let roomPeriods = MadinahHotel[hotelIndex].hotel_room_periods;
                        let result = "HotelNotFound";
                        for (let roomPeriodIndex in roomPeriods) {
                            // console.log('user selected ', checkIn, checkOut);
                            // console.log('hotel avaible dates ', roomPeriods[roomPeriodIndex].periodFrom, roomPeriods[roomPeriodIndex].periodTo);
                            if ((roomPeriods[roomPeriodIndex].periodFrom >= checkIn && roomPeriods[roomPeriodIndex].periodTo <= checkOut) || (roomPeriods[roomPeriodIndex].periodTo >= checkIn && roomPeriods[roomPeriodIndex].periodFrom <= checkOut)) {
                                result = "HotelFound";
                            }
                        }
                        if(result == "HotelFound"){
                            this.umrahHotels[hotelIndex] = MadinahHotel[hotelIndex];
                        }
                        // return result;
                    }
                    if(this.umrahHotels && this.umrahHotels.length){
                        return "HotelFound";
                    }else{
                        return "HotelNotFound";
                    }
                }
            }
        },
        checkHotelAvailability(initialIndex, initialDate = ""){
            if(initialDate != ""){
                if (initialDate.start) {
                    this.umrahDyn.hotel[initialIndex].checkIn = moment(initialDate.start, 'DD-MM-YYYY').format('DD-MM-YYYY');
                }
                if (initialDate.end) {
                    this.umrahDyn.hotel[initialIndex].checkOut = moment(initialDate.end, 'DD-MM-YYYY').format('DD-MM-YYYY');
                    this.tillDateHidden = moment(initialDate.end, 'DD-MM-YYYY').format('DD-MM-YYYY');
                }
                this.$forceUpdate();
                this.checkNumDays(initialIndex);
            }
        },
        whatsapp(url){
            window.location.href = 'https://api.whatsapp.com/send?'+ url;
        },
        whatsappCustom(url){
            if(this.customWhatsapp){  
                var clientNumber = this.customWhatsapp;
                var firstChars = clientNumber.substring(0, 1);
                var secndChars = clientNumber.substring(1, 2);
                if(clientNumber.toString().length < 10){
                    this.$toast.error('Please add a valid Whatsapp Number.');
                }else{
                    if(firstChars == 0 && secndChars == 3 && clientNumber.toString().length == 11){
                        clientNumber = "+92" + clientNumber.slice(1);
                    }else if(firstChars == 3 && clientNumber.toString().length == 10){
                        clientNumber = "+92" + clientNumber.slice(0);
                    }else if(firstChars != "+"){
                        clientNumber = "+" + clientNumber;
                    }
                }
                window.location.href = 'https://api.whatsapp.com/send?phone=' + clientNumber + url;
            }else{
                this.$toast.error('Whatsapp Number is Required!');
            }
        },
        customWhatsappDiv(){
            this.checkCustomWhatsapp = !this.checkCustomWhatsapp;
        },
        setInitialDate(initialDate, initialDay) {
            return moment(initialDate, "DD-MM-YYYY").add(initialDay, "days").format("DD-MM-YYYY");
        },
        checkNumDays(hotelIndex) {
            let checkIn = this.umrahDyn.hotel[hotelIndex].checkIn;
            let checkOut = this.umrahDyn.hotel[hotelIndex].checkOut;

            checkIn = moment(checkIn, "DD-MM-YYYY").format("YYYY-MM-DD");
            checkOut = moment(checkOut, "DD-MM-YYYY").format("YYYY-MM-DD");

            if (checkIn && checkOut) {
                if (hotelIndex > 0) {
                    let previousCheckOut = moment(this.umrahDyn.hotel[hotelIndex - 1].checkOut, "DD-MM-YYYY").format("YYYY-MM-DD");
                    if (checkIn < previousCheckOut || checkIn > checkOut) {
                        this.umrahDyn.hotel[hotelIndex].checkIn = "";
                        this.umrahDyn.hotel[hotelIndex].checkOut = "";
                        this.umrahDyn.hotel[hotelIndex].totalNights = 0;
                        this.$toast.error('Please select Date From Today, Onwards!');
                        return false;
                    }
                }
                const previousNights = Number(this.umrahDyn.hotel[hotelIndex].totalNights) || 0;
                this.umrahDyn.grandNights = Number(this.umrahDyn.grandNights) || 0;
                this.umrahDyn.grandNights -= previousNights;
                const start = new Date(checkIn);
                const end = new Date(checkOut);
                const timeDiff = end.getTime() - start.getTime();
                const daysDiff = Math.floor(timeDiff / (1000 * 60 * 60 * 24));
                this.umrahDyn.hotel[hotelIndex].totalNights = daysDiff;
                this.umrahDyn.grandNights =  (this.umrahDyn.grandNights + daysDiff);
                console.log('Nights:', daysDiff, 'Grand Nights:', this.umrahDyn.grandNights, 'index:' , hotelIndex);
            }
        },
        reset() {
            Object.assign(this.$data.umrahDyn, this.$options.data().umrahDyn);
        },
        umrahBookingQuery() {
            if (this.umrahDyn.customers.mobileNo != "") {
                if (this.umrahDyn.transport && (this.umrahDyn.sector === "" && this.umrahDyn.vehicle === "")) {
                    this.$toast.error('Sector And Vehicle Type field is required.');
                    return false;
                } else {
                    for (let hotelIndex in this.umrahDyn.hotel) {
                        if (this.umrahDyn.hotel[hotelIndex].umrahHotelId == "") {
                            this.$toast.error('Hotel Name field is required.');
                            return false;
                        } else if (this.umrahDyn.hotel[hotelIndex].checkIn == "") {
                            this.$toast.error('Hotel check In field is required.');
                            return false;
                        } else if (this.umrahDyn.hotel[hotelIndex].checkOut == "") {
                            this.$toast.error('Hotel check Out field is required.');
                            return false;
                        } else if (this.umrahDyn.hotel[hotelIndex].totalRooms.rooms == 0) {
                            this.$toast.error('Hotel Rooms are required.');
                            return false;
                        }else if(!this.isXlScreen && this.umrahDyn.hotel[hotelIndex].getNights == 0){
                            this.$toast.error('Hotel Nights are required.');
                            return false;
                        }
                    }
                    // this.loading = true;
                    // Service.doFetchRequest("/Umrhbookingdyn", '', this.umrahDyn).then((datas) => {
                    //      if (datas) {
                    //         this.isModalVisible = true;
                    //         document.body.style.overflow = "hidden";
                    //     } else {
                    //             this.$toast.error('Please Select Rooms.');
                    //      }
                    //     this.loading = false;
                    // });

                    this.checkCustomWhatsapp = false;
                    this.$inertia.post('/Umrhbookingdyn', this.umrahDyn, {
                        onSuccess: (response) => {
                            if (response) {
                                this.isModalVisible = true;
                                document.body.style.overflow = "hidden";
                            } else {
                                this.$toast.error('Please Select Rooms.');
                            }
                            this.loading = false;
                        }
                    });
                }
            } else {
                this.$toast.error('Phone Number field is required!');
                return false;
            }
        }
    }
}
</script>