<?php

namespace App\Libraries\rest_api;

class AirTicketingMethodProvider
{
    public static function flightItineraryQueryParam($params){
        $flightItineraryParams = array();
        foreach(self::stringToArray("&", $params) as $param):
            $param = self::stringToArray("=", $param);
            $flightItineraryParams[$param[0]] = $param[1];
        endforeach;
        return $flightItineraryParams;
    }

    public static function stringToArray($delimiter, $string) {
        return explode($delimiter, $string);
    }

    public static function params($querys,$flag = 'q') {
        $keys = array("tripType" => "ft", "departureCode" => "ol", "arrivalCode" => "dl", "outboundDate" => "obd",
            "inboundDate" => "ibd", "adultsCount" => "ac", "childrenCount" => "cc", "infantsCount" => "ic",
            "cabin" => "cbn", "currencyRate" => "cr", "currencyCode" => "ct");
        $params = array();
        foreach ($querys as $queryKey => $query):
            if($flag == 'q') $params[array_search(preg_replace('/[^a-zA-Z0-9-,]/i', '', $queryKey), $keys)] = preg_replace('/[^a-zA-Z0-9-,.]/i', '', $query);
            else if($flag == 'p') $params[preg_replace('/[^a-zA-Z0-9-,]/i', '', $queryKey)] = preg_replace('/[^a-zA-Z0-9-,.]/i', '', $query);
        endforeach;
        return $params;
    }

    public static function __error($fieldName,$message){
        return  '{"input":"true","error":"'.$message.'"}';
    }
}
