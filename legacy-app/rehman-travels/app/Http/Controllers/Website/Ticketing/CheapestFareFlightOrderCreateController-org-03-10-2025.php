<?php

namespace App\Http\Controllers\Website\Ticketing;

use App\Events\TicketingEmail;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Libraries\rest_api\AllowOnlyValidInputProvider;
use App\Libraries\rest_api\OrderCreateProvider;
use App\Libraries\stripepay\StripeClientProvider;
use App\Models\Ticketing\FlightItineraryInfo;
use App\Libraries\rest_api\TicketingEmailProvider;
class CheapestFareFlightOrderCreateController extends Controller {

    public function cheapestFareFlightOrderCreateRequest(Request $request) {
        try {
            $allowOnlyValidInputProvider = AllowOnlyValidInputProvider::allowOnlyValidInputIfOrderCreating($request->input());
            if (!empty($allowOnlyValidInputProvider)):
                return $allowOnlyValidInputProvider;
            else:
            $orderCreateProvider = OrderCreateProvider::cheapestFareOrderCreateReponse($request)["serviceProvider"];
            if(!empty($orderCreateProvider["errorType"]) && !empty($orderCreateProvider["error"]) && $orderCreateProvider["errorType"] == true):
                    return response()->json([
                        "errorType" => "true",
                        "error" => $orderCreateProvider["error"],
                        "responseError" => $orderCreateProvider["responseError"]
                    ]);
                elseif (!empty($orderCreateProvider["serviceProvider"]["error"]["code"])):
                    if ($orderCreateProvider["serviceProvider"]["error"]["code"] == 401):
                        return response()->json([
                                    "errorType" => "true",
                                    "error" => "Session Expired, Please refresh to continue",
                                    "responseError" => "Session Expired, Please refresh to continue"
                        ]);
                    endif;
                elseif (!empty($orderCreateProvider["flightItinerary"]["flightItineraryInfo"]["errorType"]) && $orderCreateProvider["flightItinerary"]["flightItineraryInfo"]["errorType"] == "true"):
                    return response()->json([
                                "errorType" => "true",
                                "error" => $orderCreateProvider["flightItinerary"]['flightItineraryInfo']['error'],
                                "responseError" => $orderCreateProvider["flightItinerary"]['flightItineraryInfo']['error']
                    ]);
                else:
                    if (!empty($orderCreateProvider["flightItinerary"]["flightItineraryInfo"]["errorType"]) && $orderCreateProvider["flightItinerary"]["flightItineraryInfo"]["errorType"] == "false"):
                        $flightItineraryProvider = $orderCreateProvider["flightItinerary"];
                        $airType = $flightItineraryProvider["flightItineraryInfo"]["airType"];
                        $itineraryRef = $flightItineraryProvider["flightItineraryInfo"]["itineraryRef"];
                        $reference =$flightItineraryProvider["flightItineraryInfo"]["reference"];
                        $echoToken = $flightItineraryProvider["flightItineraryInfo"]["echoToken"];
                        $params = self::__paramWithNewKey($request->params);
                        $params['airType'] = $airType;
                        $params['itineraryRef'] = $itineraryRef;
                        $params['reference'] = $reference;
                        $params['echoToken'] = $echoToken;
                        $params['echoToken'] = $echoToken;
                        $params['totalFare'] = $request["totalFare"];
                        $queryString = "at=$airType&vc={$request['vCarrier']}&irf=$itineraryRef&rf=$reference&et=$echoToken&cc={$request["cc"]}&cr={$request['cr']}";
//                        FlightItineraryInfo::where(['itineraryRef' => $itineraryRef])->update(["paySessionId" => 'b2c','payType' => 'yes']);
                        $customerName ='';
                        if($airType == 'Airsial'):
                            $customerName = $flightItineraryProvider['persons'][0]['firstName'];
                        else:
                            $customerName = $flightItineraryProvider['persons'][0]['lastName'] . "/" . $flightItineraryProvider['persons'][0]['firstName'];
                        endif;
                        $subject = "Passenger Name Record / Itinerary Reference has been successfully Created";
                        TicketingEmailProvider::orderCreateMail([
                            "to" => [env('MAIL_FROM_ADDRESS'), $request['email']],
                            "unlink" => true,
                            "name" => [env('MAIL_FROM_TITLE'), $customerName],
                            "phoneNumber" => [(!empty($request['phoneNumber']) ? $request['phoneNumber'] : '923345550579'), '923345550579'],
                            "subject" => [$subject, $subject],
                            "body" => [
                                "Dear Administrator,<br/><b><u><i> MR {$customerName}</i></u></b> Created Passenger Name Record (PNR) / Itinerary Reference <b><u><i>{$itineraryRef}</i></u></b> has been successfully.",
                                "Dear {$customerName},<br/>You have Created Passenger Name Record (PNR) / Itinerary Reference: <b><u><i>{$itineraryRef}</i></u></b> has been successfully."
                            ],
                            "itineraryRef" => $itineraryRef,
                            "orderRetrieveProvider" => $flightItineraryProvider,
                            "params" => $params,
                            'title' => "Passenger Name Record / Itinerary Reference has been successfully Created",
                            'location' => 'itinerary',
                            'pdf' => true,
                            'fileName' => 'pnr',
                            'view' => 'CheapestFareFlightOrderRetrieve'
                        ]);
                        return response()->json([
                                    "errorType" => "false",
                                    "responseError" => "",
                                    "error" => "",
                                    "airType" => $airType,
                                    "itineraryRef" => $itineraryRef,
                                    "reference" => $reference,
                                    "echoToken" => $echoToken,
                                    "vCarrier" => $request["vCarrier"],
                                    "payUrl" => "/payonline/cheapest-fare-order-pay-now?$queryString",
//                                     "payUrl" => "/ticketing/cheapest-fare-flight-order-retrieve?$queryString"
//                                    "payUrl" => $stripeClientProvider["payUrl"]
                        ]);
                    else:
                        return response()->json([
                            "errorType" => "true",
                            "error" => $orderCreateProvider["flightItinerary"]['flightItineraryInfo']['error'],
                            "responseError" => $orderCreateProvider["flightItinerary"]['flightItineraryInfo']['error']
                        ]);
                    endif;
                endif;
            endif;
        } catch (\Exception $e) {
            return response()->json([
                        "errorType" => "true",
                        "error" => "500",
                        "responseError" => $e->getMessage()
            ]);
        }
    }

    private static function __paramWithNewKey($params) {
        $keys = array("tripType" => "ft", "ol" => "ol", "dl" => "dl", "obd" => "obd", "ibd" => "ibd", "adultsCount" => "ac", "childrenCount" => "cc", "infantsCount" => "ic",
            "cabin" => "cbn", "currencyRate" => "cr", "currencyCode" => "ct", "currencySymbol" => "cs", "currencyFlag" => "cf", "pfa" => "pfa", "markupType" => "mt",
            "sectorType" => "st", "airType" => "airType", "vCarrier" => "vCarrier", "phoneNumber" => "phoneNumber", "email" => "email"
        );
        $paramWithNewKeys = array();
        foreach ($params as $paramKey => $param):
            $paramWithNewKeys[array_search($paramKey, $keys)] = $param;
        endforeach;
        return $paramWithNewKeys;
    }

}
