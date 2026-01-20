<?php

namespace App\Http\Controllers\Website\Ticketing;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Ticketing\FlightItineraryInfo;
use App\Mail\NotifyMail;

class CheapestFareFlightOrderRetrieveEmailController extends Controller
{

    public function cheapestFareFlightOrderRetrieveSendPdf(Request $request)
    {
        try {
            $orderRetrieveProvider = $request['orderRetrieveProvider'];
            if(!empty($orderRetrieveProvider['flightItineraryInfo']['itineraryRef'])):
                $itineraryRef = $orderRetrieveProvider['flightItineraryInfo']['itineraryRef'];
                $flightItineraryInfo = FlightItineraryInfo::where('itineraryRef', $itineraryRef)->first();
                if(!empty($flightItineraryInfo->itineraryRef)):
                    $subjec = "Passenger Name Record / Itinerary Reference";
                    $customerName = '';
                        if( $orderRetrieveProvider["flightItineraryInfo"]["airType"] == 'Airsial'):
                            $customerName = $orderRetrieveProvider['persons'][0]['firstName'];
                        else:
                            $customerName = $orderRetrieveProvider['persons'][0]['lastName'] . "/" . $orderRetrieveProvider['persons'][0]['firstName'];
                        endif;
                    $params = json_decode($flightItineraryInfo['params'],true);
                    try{
                        new NotifyMail([
                            'view' => "Ticketing.OrderRetrievePdf",
                            'to' => $flightItineraryInfo['email'],
                            'toTitle' => $customerName,
                            'from' => env('MAIL_FROM_ADDRESS'),
                            'fromTitle' => env('MAIL_FROM_TITLE'),
                            'subject' => "Passenger Name Record / Itinerary Reference",
                            'itineraryRef' => $itineraryRef,
                            'cc' => false,
                            'attach' => true,
                            'location' => [(!empty($flightItineraryInfo->ticketStatus) ? 'ticket': 'itinerary')],
                            'fileName' => ['pnr'],
                            'data' => [
                                'paymentProvider' => '',
                                'orderProvider' => $orderRetrieveProvider,
                                'flightItineraryInfo' => $flightItineraryInfo,
                                'title' => 'Passenger Name Record / Itinerary Reference',
                                'body' => "Dear {$customerName},<br/>Your Passenger Name Record (PNR) / Itinerary Reference: <b><u><i>{$itineraryRef}</i></u></b>,if there is an issue please contact with our Help Desk Team.",
                                'email' => $flightItineraryInfo['email'],
                                'phoneNumber' => (!empty($flightItineraryInfo['phone']) ? $flightItineraryInfo['phone'] : '923345550579')
                            ],
                        ]);
                    return response()->json([
                        'message' => 'Passenger Name Record / Itinerary Reference Pdf has been sent successfully.Please check your email. Thank you',
                        'errorType' => false
                    ]);
                }catch (Exception $e) {
                    return response()->json([
                    'message' => 'Passenger Name Record / Itinerary Reference Pdf has not been sent successfully ! Please try again',
                    'errorType' => true
            ]);
                }
                endif;
            endif;
        } catch (Exception $e) {
            return response()->json([
                'message' => 'An unexpected error has occurred. Please try again',
                'errorType' => true
            ]);
        }
    }
}
