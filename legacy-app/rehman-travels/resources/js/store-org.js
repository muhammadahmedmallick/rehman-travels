import {createStore} from "vuex";
export default createStore({
    state: {
        currency:JSON.parse(localStorage.getItem('currency')) || "",
        cheapestFlightSearch:JSON.parse(localStorage.getItem('cheapestFlightSearch')) || "",
        flightType:JSON.parse(localStorage.getItem('flightType')) || "",
        flightCabin:JSON.parse(localStorage.getItem('flightCabin')) || "",
        flightTravelers:JSON.parse(localStorage.getItem('flightTravelers')) || "",
        phoneNumber:JSON.parse(localStorage.getItem('phoneNumber')) || "",
    },
    actions: {
        update({commit},currency) {
            commit('setCurrency', currency);
        },
        cheapestFlightSearch({commit},cheapestFlightSearch){
            commit('setCheapestFlightSearch', cheapestFlightSearch);
        },
        flightType({commit},flightType){
            commit('setFlightType', flightType);
        },
        phoneNumber({commit},phoneNumber){
            commit('setPhoneNumber', phoneNumber);
        },
        flightCabin({commit},flightCabin){
            commit('setFlightCabin', flightCabin);
        },
        flightTravelers({commit},flightTravelers){
            commit('setFlightTravelers', flightTravelers);
        },
    },
    mutations: {
        setCurrency(state, currency) {
            state.currency = currency;
            localStorage.setItem('currency', JSON.stringify(currency))
        },
        setCheapestFlightSearch(state, cheapestFlightSearch) {
            state.cheapestFlightSearch = cheapestFlightSearch;
            localStorage.setItem('cheapestFlightSearch', JSON.stringify(cheapestFlightSearch))
        },
        setFlightType(state, flightType) {
            state.flightType = flightType;
            localStorage.setItem('flightType', JSON.stringify(flightType))
        },
        setPhoneNumber(state, phoneNumber) {
            state.phoneNumber = phoneNumber;
            localStorage.setItem('phoneNumber', JSON.stringify(phoneNumber))
        },
        setFlightCabin(state, flightCabin) {
            state.flightCabin = flightCabin;
            localStorage.setItem('flightCabin', JSON.stringify(flightCabin))
        },
        setFlightTravelers(state, flightTravelers) {
            state.flightTravelers = flightTravelers;
            localStorage.setItem('flightTravelers', JSON.stringify(flightTravelers))
        },

    }
});

