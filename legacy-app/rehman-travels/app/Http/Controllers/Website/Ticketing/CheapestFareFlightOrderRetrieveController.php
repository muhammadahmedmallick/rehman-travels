<?php

namespace App\Http\Controllers\Website\Ticketing;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Libraries\rest_api\AllowOnlyValidInputProvider;
use App\Libraries\rest_api\OrderRetrieveProvider;
use App\Libraries\rest_api\AirTicketingMethodProvider;
use PDF;
class CheapestFareFlightOrderRetrieveController extends Controller
{
    public function cheapestFareFlightOrderRetrieve(Request $request){
        $allowOnlyValidInputProvider = AllowOnlyValidInputProvider::allowOnlyValidInputIfOrderRetrieve($request);
        if(!empty($allowOnlyValidInputProvider)):
            return Inertia::render('Website/Ticketing/AllowedOnlyValidInput',['errors' => $allowOnlyValidInputProvider]);
        else:
            $prefix = $request->route()->getPrefix();
            if (!empty($request['irf']) && !empty($request['at'])):
                $orderRetrieveProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse([
                    "prefix" => $prefix,
                    "airType" => $request['at'],
                    "itineraryRef" => $request['irf'],
                    "reference" => $request['rf'],
                    "echoToken" => $request['et'],
                    "jSessionId" => 'jSessionId',
                    "vCarrier" => $request['vc'],
                    "currencyCode" => $request['cc'],
                    "currencyRate" => $request['cr']
                ]);
                if(!empty($orderRetrieveProvider)):
                     $flightItineraryInfo = $orderRetrieveProvider['flightItinerary']['flightItineraryInfo'];
                    if(!empty($flightItineraryInfo['errorType']) && $flightItineraryInfo['errorType'] == 'true'):
                        return Inertia::render('Website/Ticketing/AllowedOnlyValidInput',['errors' => AirTicketingMethodProvider::__error((!empty($flightItineraryInfo['status']) ? $flightItineraryInfo['status'] : 'Cancel'),$flightItineraryInfo['error'])]);
                    else:
                        return Inertia::render('Website/Ticketing/CheapestFareFlightOrderRetrieve', ['orderRetrieveProvider' => (!empty($orderRetrieveProvider['flightItinerary']) ? $orderRetrieveProvider['flightItinerary'] : [])]);
                    endif;
                else:
                    return Inertia::render('Website/Ticketing/CheapestFareFlightOrderRetrieve', ['orderRetrieveProvider' => self::__orderRetrieveProvider($request)]);
                endif;
            else:
                 return Inertia::render('Website/Ticketing/CheapestFareFlightOrderRetrieve', ['orderRetrieveProvider' => self::__orderRetrieveProvider($request)]);
            endif;
         endif;
    }

    private static function __orderRetrieveProvider($request){
        return json_decode('{
                    "flightItineraryInfo":{
                    "airType":"'.(!empty($request['at']) ? $request['at'] : '').'",
                    "jSessionId":"'.(!empty($request['irf']) ? $request['irf'] : '').'",
                    "itineraryRef":"'.(!empty($request['irf']) ? $request['irf'] : '').'",
                    "reference":"'.(!empty($request['rf']) ? $request['rf'] : '').'",
                    "echoToken":"'.(!empty($request['et']) ? $request['et'] : '').'",
                    "status":"Internal Server Error",
                    "errorType":"true",
                    "error":"Internal Server Error"
                    }
             }', true);
    }

}
