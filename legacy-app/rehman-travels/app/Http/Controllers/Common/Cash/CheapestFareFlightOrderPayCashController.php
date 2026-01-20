<?php

namespace App\Http\Controllers\Common\Cash;

use App\Http\Controllers\Controller;
use App\Libraries\rest_api\TicketingEmailProvider;
use App\Models\Branches\Branch;
use App\Models\Banks\BankDetail;
use App\Models\Ticketing\FlightItineraryInfo;
use Illuminate\Http\Request;
use App\Libraries\rest_api\OrderRetrieveProvider;
use PDF;

class CheapestFareFlightOrderPayCashController extends Controller
{
    public function cheapestFareFlightOrderPayCash(Request $request)
    {
        try {
            if (!empty($request->itineraryRef)):
                $flightItineraryInfo = FlightItineraryInfo::itineraryRef($request->itineraryRef);
                if (!empty($flightItineraryInfo->itineraryRef)):
                    $orderRetrieveProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse([
                        "airType" => $flightItineraryInfo['airType'],
                        "itineraryRef" => $flightItineraryInfo['itineraryRef'],
                        "reference" => $flightItineraryInfo['reference'],
                        "echoToken" => $flightItineraryInfo['echoToken'],
                        "jSessionId" => 'jSessionId',
                        "vCarrier" => $flightItineraryInfo['vCarrier'],
                        "currencyCode" => $flightItineraryInfo['currencyCode'],
                        "currencyRate" => $flightItineraryInfo['currencyRate']
                    ])["flightItinerary"];
                    $customerName ='';
                    if($flightItineraryInfo['airType'] == 'Airsial'):
                        $customerName = $orderRetrieveProvider['persons'][0]['firstName'];
                    else:
                        $customerName = $orderRetrieveProvider['persons'][0]['lastName'] . "/" . $orderRetrieveProvider['persons'][0]['firstName'];
                    endif;
                    $subject = "Passenger Name Record / Itinerary Reference has been successfully Created";
                    try {
                        TicketingEmailProvider::orderRetrieveMail([
                            "to" => [env('MAIL_FROM_ADDRESS'), $flightItineraryInfo['email']],
                            "unlink" => true,
                            "name" => [env('MAIL_FROM_TITLE'), $customerName],
                            "phoneNumber" => [(!empty($flightItineraryInfo['phoneNumber']) ? $flightItineraryInfo['phoneNumber'] : '923345550579'), '923345550579'],
                            "subject" => [$subject, $subject],
                            "body" => [
                                "Dear Administrator,<br/><b><u><i> MR {$customerName}</i></u></b> Created Passenger Name Record (PNR) / Itinerary Reference <b><u><i>{$flightItineraryInfo['itineraryRef']}</i></u></b> has been successfully.",
                                "Dear {$customerName},<br/>You have Created Passenger Name Record (PNR) / Itinerary Reference: <b><u><i>{$flightItineraryInfo['itineraryRef']}</i></u></b> has been successfully."
                            ],
                            "itineraryRef" => $flightItineraryInfo['itineraryRef'],
                            "orderProvider" => $orderRetrieveProvider,
                            'optionProvider' => (!empty($request->paymentType) ? ($request->paymentType == 'cash' ? Branch::branches() : BankDetail::banks()) : ""),
                            "params" => $flightItineraryInfo['params'],
                            'title' => "Passenger Name Record / Itinerary Reference has been successfully Created",
                            'location' => 'itinerary',
                            'pdf' => true,
                            'view' => 'OrderRetrieve'
                        ]);
                        return response()->json([
                            'message' => 'Passenger Name Record / Itinerary Reference Pdf has been sent successfully.Please check your email. Thank you',
                            'payUrl' => true,
                            'errorType' => false
                        ]);
                    } catch (Exception $e) {
                        return response()->json([
                            'message' => 'Passenger Name Record / Itinerary Reference Pdf has not been sent successfully ! Please try again',
                            'payUrl' => false,
                            'errorType' => true
                        ]);
                    }
                    else:
                        return response()->json([
                            'message' => 'itineraryRef is not found,invalid itineraryRef',
                            'payUrl' => false,
                            'errorType' => true
                        ]);
                endif;
            else:
                return response()->json([
                    'message' => 'itineraryRef is empty',
                    'payUrl' => false,
                    'errorType' => true
                ]);
            endif;
        } catch (Exception $e) {
            return response()->json([
                'message' => 'An unexpected error has occurred. Please try again',
                'payUrl' => false,
                'errorType' => true
            ]);
        }
    }
}
