<?php

namespace App\Http\Controllers\Website\Ticketing;

use App\Http\Controllers\Controller;
use App\Libraries\IpLogProvider;
use Illuminate\Http\Request;
use App\Libraries\rest_api\AllowOnlyValidInputProvider;
use App\Libraries\rest_api\OrderCreateProvider;
use App\Models\Ticketing\FlightItineraryInfo;
use App\Libraries\rest_api\TicketingEmailProvider;

class CheapestFareFlightOrderCreateController extends Controller
{

    public function cheapestFareFlightOrderCreateRequest(Request $request)
    {
        return "";
        try {
            $ipLogProvider = new IpLogProvider($request);
            $routes = $ipLogProvider::__routes($request->params ?? null);
            $airType = $request->airType ?? null;
            $allowOnlyValidInputProvider = AllowOnlyValidInputProvider::allowOnlyValidInputIfOrderCreating($request->input());
            if (!empty($allowOnlyValidInputProvider)):
                return $allowOnlyValidInputProvider;
            else:
                $cheapestFareOrderCreate = OrderCreateProvider::cheapestFareOrderCreateReponse($request);
                $orderCreateProvider = $cheapestFareOrderCreate["serviceProvider"] ?? [];
                $passengers = $cheapestFareOrderCreate["passengers"] ?? [];
                if (!empty($orderCreateProvider['statusCode']) && $orderCreateProvider['statusCode'] == 429):
                    return response()->json($orderCreateProvider);
                elseif (!empty($orderCreateProvider['statusCode']) && $orderCreateProvider['statusCode'] == 422):
                    return response()->json($orderCreateProvider);
                elseif (!empty($orderCreateProvider["errorType"]) && $orderCreateProvider["errorType"] == 'true'):
                    $ipLogProvider::createOrUpdate($orderCreateProvider["error"], $passengers, $airType, null, $routes);
                    return response()->json([
                        "statusCode" => 422,
                        "errorType" => "true",
                        "error" => $orderCreateProvider["error"],
                        "responseError" => $orderCreateProvider["responseError"]
                    ]);
                elseif (!empty($orderCreateProvider["error"]["code"])):
                    if ($orderCreateProvider["error"]["code"] == 401):
                        return response()->json([
                            "statusCode" => 401,
                            "errorType" => "true",
                            "error" => "Session Expired, Please refresh to continue",
                            "responseError" => "Session Expired, Please refresh to continue"
                        ]);
                    elseif ($orderCreateProvider["error"]["code"] == 419):
                        return response()->json([
                            "statusCode" => 419,
                            "errorType" => "true",
                            "error" => "Session Expired, Please refresh to continue",
                            "responseError" => "Session Expired, Please refresh to continue"
                        ]);
                    endif;
                elseif (!empty($orderCreateProvider["flightItinerary"]["flightItineraryInfo"]["errorType"]) && $orderCreateProvider["flightItinerary"]["flightItineraryInfo"]["errorType"] == "true"):
                    $error = $orderCreateProvider["flightItinerary"]["flightItineraryInfo"]["error"] ?? null;
                    $ipLogProvider::createOrUpdate($error, $passengers, $airType, null, $routes);
                    return response()->json([
                        "statusCode" => 422,
                        "errorType" => "true",
                        "error" => $error,
                        "responseError" => $error
                    ]);
                else:
                    if (!empty($orderCreateProvider["flightItinerary"]["flightItineraryInfo"]["errorType"]) && $orderCreateProvider["flightItinerary"]["flightItineraryInfo"]["errorType"] == "false"):
//                        $flightItineraryProvider = $orderCreateProvider["flightItinerary"];
//                        $airType = $flightItineraryProvider["flightItineraryInfo"]["airType"];
//                        $itineraryRef = $flightItineraryProvider["flightItineraryInfo"]["itineraryRef"];
//                        $reference =$flightItineraryProvider["flightItineraryInfo"]["reference"];
//                        $echoToken = $flightItineraryProvider["flightItineraryInfo"]["echoToken"];
                        $flightItinerary = $orderCreateProvider["flightItinerary"] ?? [];
                        $flightItineraryInfo = $flightItinerary["flightItineraryInfo"] ?? [];
                        $airType = $flightItineraryInfo["airType"];
                        $itineraryRef = $flightItineraryInfo["itineraryRef"];
                        $reference = $flightItineraryInfo["reference"];
                        $echoToken = $flightItineraryInfo["echoToken"];
                        $reason = "Itinerary $airType:$itineraryRef has been created successfully.";
                        $ipLogProvider::createOrUpdate($reason, $passengers, $airType, $itineraryRef, $routes);
                        $params = self::__paramWithNewKey($request->params);
                        $params['airType'] = $airType;
                        $params['itineraryRef'] = $itineraryRef;
                        $params['reference'] = $reference;
                        $params['echoToken'] = $echoToken;
                        $params['totalFare'] = $request["totalFare"];
                        $queryString = "at=$airType&vc={$request['vCarrier']}&irf=$itineraryRef&rf=$reference&et=$echoToken&cc={$request["cc"]}&cr={$request['cr']}";
                        if ($airType == 'Airsial'):
                            $customerName = $flightItinerary['persons'][0]['firstName'] ?? '';
                        else:
                            $customerName = ($flightItinerary['persons'][0]['lastName'] ?? '') . "/" . ($flightItinerary['persons'][0]['firstName'] ?? '');
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
                            "orderRetrieveProvider" => $flightItinerary,
                            "params" => $params,
                            'title' => "Passenger Name Record / Itinerary Reference has been successfully Created",
                            'location' => 'itinerary',
                            'pdf' => true,
                            'fileName' => 'pnr',
                            'view' => 'CheapestFareFlightOrderRetrieve'
                        ]);
                        return response()->json([
                            "statusCode" => 200,
                            "errorType" => "false",
                            "responseError" => "",
                            "error" => "",
                            "airType" => $airType,
                            "itineraryRef" => $itineraryRef,
                            "reference" => $reference,
                            "echoToken" => $echoToken,
                            "vCarrier" => $request["vCarrier"],
                            "payUrl" => "/payonline/cheapest-fare-order-pay-now?$queryString",
                        ]);
                    else:
                        return response()->json([
                            "statusCode" => 422,
                            "errorType" => "true",
                            "error" => $orderCreateProvider["flightItinerary"]['flightItineraryInfo']['error'],
                            "responseError" => $orderCreateProvider["flightItinerary"]['flightItineraryInfo']['error']
                        ]);
                    endif;
                endif;
            endif;
        } catch (\Exception $e) {
            \Log::error('PNR creation error: ' . $e->getMessage());
            return response()->json([
                "statusCode" => 500,
                "errorType" => "true",
                "error" => $e->getMessage() ?? "Internal Server Error. Please try again later.",
                "responseError" => $e->getMessage() ?? "Internal Server Error. Please try again later."
            ]);
        }
    }

    private static function __paramWithNewKey($params)
    {
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
