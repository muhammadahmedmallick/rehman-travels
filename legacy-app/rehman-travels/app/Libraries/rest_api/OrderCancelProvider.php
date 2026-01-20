<?php

namespace App\Libraries\rest_api;


class OrderCancelProvider {

    public function __construct(){
        $this->middleware('auth:agent,user');
    }

    public static function cheapestFareOrderCancelReponse($prefix,$request) {
        return ServiceProvider::doRequest("POST",$prefix,"orderCancel", self::__orderCancelRequest($request));
    }
    private static function __orderCancelRequest($request) {
        return '{
            "airType": "' . $request['airType'] . '",
            "pnr": "' . ($request['airType'] != "Travelport" ? $request['itineraryRef'] : $request['echoToken']) . '",
            "reference": "' . $request['reference'] . '",
            "echoToken": "' . $request['echoToken'] . '",
            "jSessionId":"'.$request['jSessionId'].'",
            "vCarrier":"' . $request['vCarrier'] . '"
        }';
    }
}
