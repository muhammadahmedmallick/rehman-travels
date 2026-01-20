<?php

namespace App\Libraries\rest_api;

class OrderVoidProvider {

    public function __construct(){
        $this->middleware('auth:agent,user');
    }
    public static function cheapestFareOrderVoidReponse($prefix,$request,$tickets) {
        return ServiceProvider::doRequest("POST",$prefix,"orderVoid", self::__orderVoidRequest($request,$tickets));
    }

    private static function __orderVoidRequest($request,$tickets) {
        return '{
                "airType": "' . $request['airType'] . '",
                "pnr": "' . ($request['airType'] != "Travelport" ? $request['itineraryRef'] : $request['echoToken']) . '",
                "reference": "' . $request['reference'] . '",
                "echoToken": "' . $request['echoToken'] . '",
                "vCarrier":"' . $request['vCarrier'] . '",
                "jSessionId":"'.$request['jSessionId'].'",
                "tickets":['.self::__tickets($tickets).']
                }';
    }

    private static function __tickets($tickets){
        $payload = "";
        if(!empty($tickets)):
        foreach($tickets as $ticket):
            $ticketRepWithNumber = explode("-",$ticket);
            $payload .='{"rph":"'.$ticketRepWithNumber[0].'","ticketNumber":"'.$ticketRepWithNumber[1].'"},';
        endforeach;
        endif;
        return rtrim($payload,",");
}

}
