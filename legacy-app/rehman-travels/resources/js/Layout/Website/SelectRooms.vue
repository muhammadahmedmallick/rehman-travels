<template>
  <!-- Total Travelers -->
  <div class="relative flex items-center cursor-pointer w-full">
    <button type="button"
    @click="totalTravelersModal"
      class="text-sm pr-6 py-2 xl:pr-0 w-full block"
      ref="RoomsMenu"
      id="select-totalTravelers"
      data-dropdown-toggle="toggle-totalTravelers"
    >
      <i class="fas fa-hotel text-[#0d6efd] mr-1 text-lg"></i>
      {{ `${totalRooms} Rooms` }}
    </button>
    <div
    @click.stop
    v-if="totalTravelersPopup"
    id="toggle-totalTravelers"
    class="absolute top-7 -left-3 md:-left-0 md:top-8  bg-white border w-52 p-2 rounded-xl shadow-md z-10"
    >
      <!-- double -->
      <div class="flex justify-between py-2">
        <div class="flex items-center">
          <img src="assets/bed-icon.svg" alt="Bed-Icon SVG" class="mr-2">
          <span class="flex flex-col font-bold">
            Double
          </span>
        </div>

        <div class="flex items-center">
          <button
            @click="decreaseRooms('double')"
            :disabled="hotelRooms.Double === 0"
          >
            <i class="fa fa-minus-circle text-lg md:text-base text-[#0d6efd]"></i>
          </button>
          <span class="mx-2 text-base" :model="hotelRooms.Double">{{ hotelRooms.Double }}</span>
          <button
            @click="increaseRooms('double')"
            :disabled="totalRooms >= 40"
          >
            <i class="fa fa-plus-circle text-lg md:text-base text-[#0d6efd]"></i>
          </button>
        </div>
      </div>

      <!-- trippleren -->
      <div class="flex justify-between py-2">
        <div class="flex items-center">
          <i class="fa-solid fa-bed text-xl text-[#0d6efd] mr-2"></i>
          <span class="flex flex-col font-bold">
            Tripple
          </span>
        </div>
        <div class="flex items-center">
          <button
            @click="decreaseRooms('tripple')"
            :disabled="hotelRooms.Triple === 0"
          >
            <i class="fa fa-minus-circle text-lg md:text-base text-[#0d6efd]"></i>
          </button>
          <span class="mx-2 text-base" :model="hotelRooms.Triple">{{ hotelRooms.Triple }}</span>
          <button
            @click="increaseRooms('tripple')"
            :disabled="totalRooms >= 40"
          >
            <i class="fa fa-plus-circle text-lg md:text-base text-[#0d6efd]"></i>
          </button>
        </div>
      </div>

      <!-- quad -->
      <div class="flex justify-between py-2">
        <div class="flex items-center">
          <i class="fas fa-hotel text-xl text-[#0d6efd] mr-2"></i>
          <span class="flex flex-col font-bold">
            Quad
          </span>
        </div>

        <div class="flex items-center">
          <button
            @click="decreaseRooms('quad')"
            :disabled="hotelRooms.Quad === 0"
          >
            <i class="fa fa-minus-circle text-lg md:text-base text-[#0d6efd]"></i>
          </button>

          <span class="mx-2 text-base" :model="hotelRooms.Quad">{{ hotelRooms.Quad }}</span>

          <button
            @click="increaseRooms('quad')"
            :disabled="totalRooms >= 40"
          >
            <i class="fa fa-plus-circle text-lg md:text-base text-[#0d6efd]"></i>
          </button>
        </div>
      </div>
      <!-- Quint -->
      <div class="flex justify-between py-2">
        <div class="flex items-center">
          <i class="fas fa-hotel text-xl text-[#0d6efd] mr-2"></i>
          <span class="flex flex-col font-bold">
            Quint
          </span>
        </div>

        <div class="flex items-center">
          <button
            @click="decreaseRooms('quint')"
            :disabled="hotelRooms.Quint === 0"
          >
            <i class="fa fa-minus-circle text-lg md:text-base text-[#0d6efd]"></i>
          </button>

          <span class="mx-2 text-base" :model="hotelRooms.Quint">{{ hotelRooms.Quint }}</span>

          <button
            @click="increaseRooms('quint')"
            :disabled="totalRooms >= 40"
          >
            <i class="fa fa-plus-circle text-lg md:text-base text-[#0d6efd]"></i>
          </button>
        </div>
      </div>
      <!-- error -->
      <div class="flex justify-between py-2" v-if="error">
        <div class="flex items-center">
          <span class="flex flex-col text-xs text-red-600 font-semibold">
            *{{ error }} room price is not availible in selected dates
          </span>
        </div>
      </div>

      <div class="flex justify-center">
        <button
          @click="doneRooms"
          class="bg-[#0d6efd] text-white text-md font-semibold py-2 mt-3 rounded w-full md:w-1/2"
        >
          Done
        </button>
      </div>
    </div>
  </div>
</template>
<script>
import Service from '@/Config/Service';

export default {
  props:{
    hotelIndex: {type : Number},
    hotel: {type : Object}
  },
  data() {
    return {
      error: "",
      //Rooms
      totalTravelersPopup: false,
      hotelRooms: {
        hotelIndex: this.hotelIndex,
        Double: 0,
        Triple: 0,
        Quad: 0,
        Quint: 0,
        rooms: 0,
      }
    };
  },
  // For Rooms
  computed: {
    totalRooms() {
      return this.hotelRooms.rooms =  this.hotelRooms.Double + this.hotelRooms.Triple + this.hotelRooms.Quad + this.hotelRooms.Quint;
    },
  },
  methods: {
    //Travelers
    totalTravelersModal() {
      this.totalTravelersPopup = !this.totalTravelersPopup;
      // if (this.totalTravelersPopup) {
      //   window.addEventListener("click", this.toggleRoomsClickHandler);
      // }
    },
    toggleRoomsClickHandler(event) {
      if (
        this.$refs.RoomsMenu &&
        !this.$refs.RoomsMenu.contains(event.target)
      ) {
        this.totalTravelersPopup = false;
      }
    },
    increaseRooms(type) {
      if (
        (type === "double" && this.hotelRooms.rooms >= 0) ||
        (type === "tripple" && this.hotelRooms.rooms >= 0) ||
        (type === "quad" && this.hotelRooms.rooms >= 0) ||
        (type === "quint" && this.hotelRooms.rooms >= 0)
      ) {
        if (type === "double") {
          this.hotelRooms.Double++;
        } else if (type === "tripple") {
          this.hotelRooms.Triple++;
        } else if (type === "quad") {
          this.hotelRooms.Quad++;
        }else if (type === "quint") {
          this.hotelRooms.Quint++;
        }
      }
    },
    decreaseRooms(type) {
      if (
        (type === "double" && this.hotelRooms.rooms >= 0) ||
        (type === "tripple" && this.hotelRooms.rooms >= 0) ||
        (type === "quad" && this.hotelRooms.rooms >= 0) ||
        (type === "quint" && this.hotelRooms.rooms >= 0)
      ) {
        if (type === "double") {
          this.hotelRooms.Double--;
        } else if (type === "tripple") {
          this.hotelRooms.Triple--;
        } else if (type === "quad") {
          this.hotelRooms.Quad--;
        }else if (type === "quint") {
          this.hotelRooms.Quint--;
        }
      }
    },
    doneRooms() {
      this.totalRooms = this.hotelRooms.Double + this.hotelRooms.Triple + this.hotelRooms.Quad + this.hotelRooms.Quint;
      // console.log(this.hotelRooms);
      this.error = "";
      if(this.totalRooms == 0){
        alert('please select atleast one Room');
      }else{
        try {
          if(this.hotel){
            Service.doFetchRequest('/Umrhbookingdyn/hoteldetails', '', this.hotel.umrahHotelId).then( (response) => {
              let currentHotelData = response;
              if(currentHotelData.hotel_room_periods){
                for(let index in currentHotelData.hotel_room_periods){
                  let roomPeriods = currentHotelData.hotel_room_periods[index];
                  let result = "";
                  if ((roomPeriods.periodFrom >= this.hotel.checkIn && roomPeriods.periodTo <= this.hotel.checkOut) || (roomPeriods.periodTo >= this.hotel.checkIn && roomPeriods.periodFrom <= this.hotel.checkOut)) {
                      result = "HotelFound";
                  }
                  if(result = "HotelFound"){
                    for(let roomPrice in roomPeriods.hotelRoomPrices){
                      let roomTypeName = roomPeriods.hotelRoomPrices[roomPrice].roomType;
                      if(roomPeriods.hotelRoomPrices[roomPrice].offDayMarkup == 0 && roomPeriods.hotelRoomPrices[roomPrice].onDayMarkup == 0 && roomPeriods.hotelRoomPrices[roomPrice].roomType && this.hotelRooms[roomTypeName] > 0){
                        if(!this.error.includes(roomPeriods.hotelRoomPrices[roomPrice].roomType)){
                          this.error += roomPeriods.hotelRoomPrices[roomPrice].roomType;
                        }
                      }
                    }
                  }
                }
              }else{
                this.error = 'Selected Hotel ';
              }

              if(this.error == ''){
                this.$emit('hotelRooms', this.hotelRooms);
                this.totalTravelersPopup = false;
              }
            });
          }
        } catch (error) {
          console.log(error);
        }
      }
    },
  },
};
</script>