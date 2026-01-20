export default {
    setCheapestFareFlightStorage: function(inoutboundAirportDateDetails,outboundAirportDetails,inboundAirportDetails,
                                           outinboundDateDetails,departureType,arrivalType,flightType,adultsCount,childrenCount,
                                           infantsCount,totalpassengers,cabin,cabinName) {
        localStorage.setItem("cheapestFareFlight", JSON.stringify({
            "inoutboundAirportDateDetails":JSON.stringify(inoutboundAirportDateDetails),
            "outboundAirportDetails":JSON.stringify(outboundAirportDetails),
            "inboundAirportDetails":JSON.stringify(inboundAirportDetails),
            "outinboundDateDetails":JSON.stringify(outinboundDateDetails),
            "departureType":(departureType == "Dom" && arrivalType == "Dom" ? "DOM" : "INT"),
            "flightType":flightType,
            "adultsCount":adultsCount,
            "childrenCount":childrenCount,
            "infantsCount":infantsCount,
            "totalpassengers":totalpassengers,
            "cabin":cabin,
            "cabinType":cabinName
        }));
    },
    setCurrency: function(currency) {localStorage.setItem("currency", JSON.stringify(currency));},
};
