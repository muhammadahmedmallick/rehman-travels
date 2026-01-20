<?php

namespace App\Libraries\rest_api;

use App\Libraries\rest_api\ServiceProvider;
use Illuminate\Support\Facades\Storage;

class CheapestCalendarFareProvider
{

    public static function calendarFareReponse($request)
    {
        try {
            $serviceProvider = ServiceProvider::doRequest("POST", 'calendar-fare', self::__calendarFarePayload($request));
            Storage::put('calendar-fare/' . $request['fileName'], json_encode($serviceProvider, true));
            return json_encode($serviceProvider, true);
        } catch (\Exception $e) {
            return [];
        }
    }

    private static function __calendarFarePayload($request)
    {
        return '{
                "legs": [' . self::__calendarFareLegs($request) . '],
                "adultsCount": "' . (!empty($request->adultsCount) ? $request->adultsCount : 1) . '",
                "childrenCount": "' . (!empty($request->childrenCount) ? $request->childrenCount : 0) . '",
                "infantsCount": "' . (!empty($request->infantsCount) ? $request->infantsCount : 0) . '",
                "cabin": "' . (!empty($request->cabin) ? $request->cabin : 'Y') . '",
                "jSessionId": "' . (!empty($request->jSessionId) ? $request->jSessionId : '') . '",
                "currencyCode": "PKR",
                "tripType": "' . (!empty($request->tripType) ? $request->tripType  : $request['ft']) . '",
                "locale": "ar",
                "supplier":"Sabre"
	            }';
    }

    private static function __calendarFareLegs($request)
    {
        $legs = '{
                "departureCode":"' . (!empty($request['ol']) ? $request['ol'] : $request['departureCode']) . '",
                "arrivalCode": "' . (!empty($request['dl']) ? $request['dl'] : $request['arrivalCode']) . '"
            },';
        if ($request['tripType'] == "round-trip"):
            $legs .= '{
                "departureCode":"' . (!empty($request['dl']) ? $request['dl'] : $request['arrivalCode']) . '",
                "arrivalCode": "' . (!empty($request['ol']) ? $request['ol'] : $request['departureCode']) . '"
            },';
        endif;
        return rtrim($legs, ",");
    }

}
