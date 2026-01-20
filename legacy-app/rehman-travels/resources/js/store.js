import {createStore} from "vuex";
export default createStore({
    state: {
        currency:JSON.parse(localStorage.getItem('currency')) || "",
        cheapestFlightSearch:JSON.parse(localStorage.getItem('cheapestFlightSearch')) || "",
        flightType:JSON.parse(localStorage.getItem('flightType')) || "",
        flightCabin:JSON.parse(localStorage.getItem('flightCabin')) || "",
        flightStop:JSON.parse(localStorage.getItem('flightStop')) || "",
        flightTravelers:JSON.parse(localStorage.getItem('flightTravelers')) || "",
        phoneNumber:JSON.parse(localStorage.getItem('phoneNumber')) || "",
        searchQuery:JSON.parse(localStorage.getItem('searchQuery')) || "",
        initialObdIbdDates:JSON.parse(localStorage.getItem('initialObdIbdDates')) || "",
        throwError:JSON.parse(localStorage.getItem('throwError')) || "",
        arabianOryxSearch:JSON.parse(localStorage.getItem('arabianOryxSearch')) || "",
        arabianOryxSearchIternary: JSON.parse(localStorage.getItem('arabianOryxSearchIternary')) || "",
        rooms: JSON.parse(localStorage.getItem('rooms')) || "",
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
        flightStop({commit},flightStop){
            commit('setFlightStop', flightStop);
        },
        flightTravelers({commit},flightTravelers){
            commit('setFlightTravelers', flightTravelers);
        },
        initialObdIbdDates({commit},initialObdIbdDates){
            commit('setInitialObdIbdDates', initialObdIbdDates);
        },
        searchQuery({commit},searchQuery){
            commit('setSearchQuery', searchQuery);
        },
        arabianOryxSearch({commit},arabianOryxSearch){
            commit('setArabianOryxSearch', arabianOryxSearch);
        },
        arabianOryxSearchIternary({commit},arabianOryxSearchIternary){
            commit('setarabianOryxSearchIternary', arabianOryxSearchIternary);
        },
        rooms({commit},rooms){
            commit('setRooms', rooms);
        },
        throwError({commit},throwError){
            commit('setThrowError', throwError);
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
        setFlightStop(state, flightStop){
            state.flightStop = flightStop;
            localStorage.setItem('flightStop', JSON.stringify(flightStop))
        },
        setFlightTravelers(state, flightTravelers) {
            state.flightTravelers = flightTravelers;
            localStorage.setItem('flightTravelers', JSON.stringify(flightTravelers))
        },
        setInitialObdIbdDates(state, initialObdIbdDates) {
            state.initialObdIbdDates = initialObdIbdDates;
            localStorage.setItem('initialObdIbdDates', JSON.stringify(initialObdIbdDates))
        },
        setSearchQuery(state, searchQuery) {
            state.searchQuery = searchQuery;
            localStorage.setItem('searchQuery', JSON.stringify(searchQuery))
        },
        setThrowError(state, throwError) {
            state.throwError = throwError;
            localStorage.setItem('throwError', JSON.stringify(throwError))
        },
        setArabianOryxSearch(state, arabianOryxSearch) {
            state.arabianOryxSearch = arabianOryxSearch;
            localStorage.setItem('arabianOryxSearch', JSON.stringify(arabianOryxSearch))
        },
        setarabianOryxSearchIternary(state, arabianOryxSearchIternary) {
            state.arabianOryxSearchIternary = arabianOryxSearchIternary;
            localStorage.setItem('arabianOryxSearchIternary', JSON.stringify(arabianOryxSearchIternary))
        },
        setRooms(state, rooms) {
            state.rooms = rooms;
            localStorage.setItem('rooms', JSON.stringify(rooms))
        },
    }
});

