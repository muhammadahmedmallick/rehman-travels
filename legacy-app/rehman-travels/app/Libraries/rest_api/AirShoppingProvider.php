<?php

namespace App\Libraries\rest_api;

use App\Libraries\rest_api\ServiceProvider;

class AirShoppingProvider {

    public static function cheapestFareAirshoppingReponse($request, $actionType = null) {
        // Use provided actionType or fall back to header
        $provider = $actionType ?? $request->header('action-type');

        if($request->cabin != 'Y' && ($provider == 'AirSial' || $provider == 'Airblue')):
            return [];
        endif;
        return ServiceProvider::doRequest("POST", $provider, self::__airShoppingPayload($request));
    }

    private static function __airShoppingPayload($request) {
        return '{
                "legs": [' . self::__airShoppingLegs($request) . '],
                "adultsCount": "' . (!empty($request->adultsCount) ? $request->adultsCount : 1) . '",
                "childrenCount": "' . (!empty($request->childrenCount) ? $request->childrenCount : 0) . '",
                "infantsCount": "' . (!empty($request->infantsCount) ? $request->infantsCount : 0) . '",
                "cabin": "' . (!empty($request->cabin) ? $request->cabin : 'Y') . '",
                "stop": "' . (!is_null($request->stop) ? $request->stop : '') . '",
                "jSessionId": "' . (!empty($request->jSessionId) ? $request->jSessionId : '') . '",
                "currencyCode": "PKR",
                "tripType": "' . (!empty($request->tripType) ? $request->tripType : 'one-way') . '",
                "locale": "ar"
	            }';
    }

    private static function __airShoppingLegs($request) {
        $departureAirports = self::__explode(",", $request['departureCode']);
        $outboundDates = self::__explode(",", $request['outboundDate']);
        $inboundDates = self::__explode(",", $request['inboundDate']);
        $legs = "";
        foreach (self::__explode(",", $request['arrivalCode']) as $arrivalAirportKey => $arrivalAirport):
            if ($outboundDates[$arrivalAirportKey] !== "Invalid date"):
                $legs .= '{
                        "departureCode":"' . ($departureAirports[$arrivalAirportKey] != '' ? $departureAirports[$arrivalAirportKey] : 'ISB') . '",
                        "arrivalCode": "' . ($arrivalAirport != '' ? $arrivalAirport : 'LHR') . '",
                        "outboundDate": "' . ($outboundDates[$arrivalAirportKey] != '' ? $outboundDates[$arrivalAirportKey] : date("Y-m-d")) . '"
                    },';
                if ($request['tripType'] == "round-trip") :
                    $legs .= '{
                        "departureCode":"' . ($arrivalAirport != '' ? $arrivalAirport : 'LHR') . '",
                        "arrivalCode": "' . ($departureAirports[$arrivalAirportKey] != '' ? $departureAirports[$arrivalAirportKey] : 'ISB') . '",
                        "outboundDate": "' . ($inboundDates[$arrivalAirportKey] != '' ? $inboundDates[$arrivalAirportKey] : date("Y-m-d")) . '"
                    },';
                endif;
            endif;
        endforeach;
        return rtrim($legs, ",");
    }

    private static function __explode($delimiter, $string) {
        return explode($delimiter, $string);
    }

}
