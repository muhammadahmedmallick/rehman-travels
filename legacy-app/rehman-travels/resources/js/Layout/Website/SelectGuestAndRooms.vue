<template>
    <div class="relative flex items-center text-[14px] cursor-pointer">
        <p  @click="toggleGuests(displayType)">{{ `${totalTraveller} Guests - ${totalRooms} Rooms` }}</p>
        <div
        :class="`${displayType} absolute top-4 -left-6 sm:-left-[5.75rem] md:-left-0 md:top-8  bg-white text-black border md:w-[22rem] w-[15rem] p-5 rounded-xl shadow-md z-20`"
        >
            <div 
                v-for="(guestRoom, guestRoomIndex) in guestRooms" :key="guestRoomIndex"
            >
                <div class="flex justify-between py-2">
                    <div class="flex items-center text-center mx-auto">
                        <span class="flex font-bold text-lg bg-bgRGTBaseColor px-3 text-white rounded-md">
                            Rooms - {{guestRoomIndex +1}}
                        </span>
                    </div>
                </div>
                <div class="flex justify-between py-2">
                    <div class="flex-col justify-start items-center">
                        <div class="flex items-center">
                            <img :src="`/travellers/traveller.svg`" />
                            <span class="flex">
                                Adult <span class="text-xs md:block hidden">(over 17 years)</span>
                            </span>
                        </div>
                        <select class="md:w-[9rem] w-[6rem] my-1 rounded p-2 leading-none text-base" v-model="guestRooms[guestRoomIndex].adultsCount">
                            <option v-for="n in 10">{{ n }}</option>
                        </select>
                    </div>
                    <div class="flex-col justify-start items-center">
                        <div class="flex items-center">
                            <img :src="`/travellers/child.svg`" />
                            <span class="flex"> 
                                Child <span class="text-xs md:block hidden">(under 18 years)</span>
                            </span>
                        </div>
                        <select class="md:w-[9rem] w-[6rem] my-1 rounded p-2 leading-none text-base" v-model="guestRooms[guestRoomIndex].childrenCount" @click="checkAge(guestRoomIndex)">
                            <option v-for="n in 6" :value="n-1">{{ n-1 }}</option>
                        </select>
                    </div>
                </div>
                <div class="grid grid-cols-4 gap-2" v-if="guestRooms[guestRoomIndex].childrenCount > 0">
                    <div class="col-span-1 py-1" v-for="ccCount in guestRooms[guestRoomIndex].childrenCount" :key="ccCount">
                        <span>
                            Age {{ ccCount }}
                        </span>
                        <select class="w-[4.5rem] my-1 rounded px-2 py-3 leading-none text-xs" v-model="guestRooms[guestRoomIndex].age[ccCount -1]" @change="event => childAge(event, ccCount -1, guestRoomIndex)">
                            <option disabled selected>Age Required</option>
                            <option v-for="n in 17" :value="n">{{n}} {{ n > 1 ? 'years' : 'year' }}</option>
                        </select>
                    </div>
                </div>
                <div class="flex justify-end" v-if="guestRoomIndex == guestRooms.length-1">
                    <button @click.prevent="addGuestRooms()" v-if="guestRoomIndex < 5"
                        class="bg-[#0d6efd] text-white text-md font-semibold py-1 px-2 rounded-full w-7"><i class="fa-solid fa-plus"></i></button>
                    <button @click.prevent="removeGuestRooms(guestRoomIndex)" v-if="guestRoomIndex != 0"
                        class="bg-red-600 text-white text-md font-semibold py-1 px-2 rounded-full w-7 ml-2"><i class="fa-solid fa-minus"></i></button>
                </div>
            </div>
            <div class="flex justify-center">
                <button @click="doneGuestRooms()"
                    class="bg-[#0d6efd] text-white text-md font-semibold py-2 mt-3 rounded-full w-1/2">Done</button>
            </div>
            <div class="flex justify-center" v-if="error.childCount">
                <p class="font-bold text-red-600 text-lg">Please select the age</p>
            </div>
            <div class="flex justify-between mt-3">
                <span class="block md:hidden text-gray-500 text-[8px] justify-start">Adult(over 17 years)</span>
                <span class="block md:hidden text-gray-500 text-[8px] justify-end">Child(below 17 years)</span>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    emits: ["selectedGuestAndRooms"],
    data() {
        return {
            displayType: 'hidden',
            totalRooms: (this.$store.state.rooms != '' ? this.$store.state.rooms : 1),
            totalTraveller: 1,
            guestRooms: [],
            error: {
                childCount: '',
            }
        }
    },
    mounted(){
        this.assignRooms()
        this.sumTravellers()
    },
    methods: {
        assignRooms(){
            let getRooms = localStorage.getItem('arabianOryxSearch');
            if(getRooms){
                this.guestRooms = JSON.parse(getRooms);
            }else{
                this.guestRooms.push({
                    adultsCount: (this.$store.state.arabianOryxSearch !== "" && this.$store.state.arabianOryxSearch.adultsCount ? this.$store.state.arabianOryxSearch.adultsCount : 1),
                    childrenCount: (this.$store.state.arabianOryxSearch !== "" && this.$store.state.arabianOryxSearch.childrenCount ? this.$store.state.arabianOryxSearch.childrenCount : 0),
                    age: (this.$store.state.arabianOryxSearch !== "" && this.$store.state.arabianOryxSearch.age ? this.$store.state.arabianOryxSearch.age : [])
                },);
                this.$store.dispatch("arabianOryxSearch", this.guestRooms)
            }
        },
        removeGuestRooms(index){
            this.guestRooms.splice(index, 1)
            this.totalRooms -= 1
        },
        checkAge(guestRoomIndex){
            if(this.guestRooms[guestRoomIndex].childrenCount < this.guestRooms[guestRoomIndex].age.length){
                this.guestRooms[guestRoomIndex].age = []
            }
        },
        childAge(event, index, guestRoomIndex){
            console.log(event.target.value, index, guestRoomIndex);
            const value = event.target.value
            this.guestRooms[guestRoomIndex].age[index] = value
            this.error.childCount = false
        },
        toggleGuests(displayType) {
            this.displayType = (displayType == "hidden" ? "block" : "hidden")
        },
        addGuestRooms(){
            this.guestRooms.push({
                adultsCount: 1,
                childrenCount: 0,
                age : []
                })
            this.totalRooms += 1
            this.totalTraveller += 1
        },
        doneGuestRooms() {
            this.sumTravellers();
            if(!this.error.childCount){
                localStorage.setItem('rooms', this.totalRooms)
                this.$emit('selectedGuestAndRooms', this.guestRooms)
                this.displayType = "hidden"
            }
        },
        sumTravellers(){
            this.totalTraveller = 0
            for(const [guestRoomKey, guestRoom] of Object.entries(this.guestRooms)){
                this.totalTraveller += parseInt(guestRoom.adultsCount) + parseInt(guestRoom.childrenCount)
                if(guestRoom.childrenCount > 0 && guestRoom.childrenCount !== guestRoom.age.length){
                    this.error.childCount = true
                }
            }
            return this.totalTraveller
        },
        close(e) {
            if (!this.$el.contains(e.target)) {
                this.displayType = 'hidden'
            }
        },
    },
};
</script>