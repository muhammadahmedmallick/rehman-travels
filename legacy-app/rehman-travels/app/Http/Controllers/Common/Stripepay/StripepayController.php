<?php

namespace App\Http\Controllers\Common\Stripepay;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Ticketing\FlightItineraryInfo;
use App\Libraries\stripepay\StripeClientProvider;
use App\Libraries\rest_api\OrderIssueProvider;
use App\Libraries\rest_api\OrderRetrieveProvider;
use App\Events\StripePayEmail;
use App\Events\TicketingEmail;

class StripepayController extends Controller
{

    private $stripeClientProvider;
    private static $message = array(
        "backFromPayment" => "You came back from the payment page without paying: We noticed that you returned from the payment page without completing the transaction. If you encountered any issues during the payment process, please try again or contact our support team for assistance. There is no surety of your order holding. Thank you for choosing our services.",
        "fareNotMatched" => "PNR Total Amount Not Matched With Paying Total Fare: It seems there might be a discrepancy between the total fare displayed and the amount paid. Please double-check the details and ensure that the correct amount is entered for payment. If you have any questions or need further assistance, please reach out to our support team.",
        "invalidPaymentSession" =>"Technical Issue Occurred, Invalid Payment Session: We apologize for the inconvenience you've encountered during the payment process. It appears that a technical issue has occurred, leading to an invalid payment session. Please ensure that your browser and internet connection are stable, and then attempt the payment again. If the problem persists, please clear your browser's cache and cookies or try using a different browser. For immediate help, don't hesitate to get in touch with our technical support team.",
        "invalidPnr" =>"Technical Issue Occurred, Passenger Name Record (PNR) not found or invalid Passenger Name Record (PNR)"
    );

    public function __construct(StripeClientProvider $stripeClientProvider)
    {
        $this->stripeClientProvider = $stripeClientProvider;
    }

    public function stripepaySuccessResponse(Request $request)
    {
        try {
            if (!empty($request['itineraryRef'])):
                $itineraryRef = $request['itineraryRef'];
                $flightItineraryInfo = FlightItineraryInfo::where('itineraryRef', $itineraryRef)->first();
                if(!empty($flightItineraryInfo->itineraryRef)):
                    $queryString = "at=$request->airType&vc=$request->vCarrier&irf=$request->itineraryRef&rf=$request->reference&et=$request->echoToken";
                    if (!empty($flightItineraryInfo->paySessionId) && $request->sessionId == $flightItineraryInfo->paySessionId):
                        $stripeClientProvider = stripeClientProvider::retrieve($request->sessionId);
                        $totalStripeAmount = ($stripeClientProvider->amount_total / 100);
                        if (!empty($flightItineraryInfo->totalFare) && $stripeClientProvider->payment_status == "paid" && $stripeClientProvider->status == "complete"):
                            FlightItineraryInfo::where(['itineraryRef' => $itineraryRef])->update(['payResponse' => json_encode($stripeClientProvider)]);
                            $request['jSessionId'] = $flightItineraryInfo->jSessionId;
                            $orderIssueProvider = OrderIssueProvider::cheapestFareOrderChangeReponse($request)["flightItinerary"];
                                if(!empty($orderIssueProvider['flightItineraryInfo']['errorType']) && $orderIssueProvider['flightItineraryInfo']['errorType'] == 'true'):
                                    $orderIssueProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse($request)["flightItinerary"];
                                endif;
                            $customerName = $orderIssueProvider['persons'][0]['lastName']."/".$orderIssueProvider['persons'][0]['firstName'];
                            $params = json_decode($flightItineraryInfo['params'],true);
                            if(!empty($orderIssueProvider['persons'][0]['ticketNumber'])):
                                $subject = "Ticket has been successfully Issued:";
                                $body = "Now you are ready for flying for more information please contact on below numbers";
                                $message = "";
                            else:
                                $subject = "Attempt on Ticket Issuance but not successfully Issued";
                                $body = "And An unexpected error has occurred.";
                                $message = "Please direct contact on contact on below numbers";
                            endif;
                            event(new TicketingEmail([
                                    "unlink" => false,
                                    "to" => [env('MAIL_FROM_ADDRESS'), $orderIssueProvider['contacts'][0]['email']],
                                    "name" => [env('MAIL_FROM_TITLE'), $customerName],
                                    "phoneNumber" => (!empty($orderIssueProvider['contacts'][0]['phone']) ? $orderIssueProvider['contacts'][0]['phone'] : '03345550579'),
                                    "subject" => 'Stripe Payment Details ' . $subject,
                                    "body" => [
                                        "Dear Administrator,<br/><b><u><i> MR {$customerName}</i></u></b> Created Passenger Name Record (PNR) / Itinerary Reference <b><u><i>{$itineraryRef}</i></u></b> has been successfully And successfully {$stripeClientProvider->payment_status}.",
                                        "Dear {$customerName},<br/>You have Created Passenger Name Record (PNR) / Itinerary Reference: <b><u><i>{$itineraryRef}</i></u></b> has been successfully And successfully {$stripeClientProvider->payment_status}.You will be received Ticket Issuance email with ticket number."
                                    ],
                                    "stripeClientProvider" => $stripeClientProvider,
                                    "orderRetrieveProvider" => $orderIssueProvider,
                                    "params" => $request,
                                    'title' => $subject,
                                    'location' => 'ticket',
                                    'pdf' => true,
                                    'view' => 'StripePayEmail'
                            ]));
                            event(new TicketingEmail([
                                    "unlink" => false,
                                    "to" => [env('MAIL_FROM_ADDRESS'), $orderIssueProvider['contacts'][0]['email']],
                                    "name" => [env('MAIL_FROM_TITLE'), $customerName],
                                    "phoneNumber" => (!empty($orderIssueProvider['contacts'][0]['phone']) ? $orderIssueProvider['contacts'][0]['phone'] : '03345550579'),
                                    "subject" => $subject,
                                    "body" => [
                                        "Dear Administrator,<br/><b><u><i> MR {$customerName}</i></u></b> Created Passenger Name Record (PNR) / Itinerary Reference <b><u><i>{$itineraryRef}</i></u></b> has been successfully: {$subject} {$body}.",
                                        "Dear {$customerName},<br/>You have Created Passenger Name Record (PNR) / Itinerary Reference: <b><u><i>{$itineraryRef}</i></u></b> {$subject} {$body} {$message}."
                                    ],
                                    "stripeClientProvider" => "",
                                    "orderRetrieveProvider" => $orderIssueProvider,
                                    "params" => $params,
                                    'title' => $subject,
                                    'location' => 'ticket',
                                    'pdf' => false,
                                    'view' => 'CheapestFareFlightOrderRetrieve'
                                ]));
//                            return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString");
                            else:
//                                return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=".self::$message['fareNotMatched']);
                            endif;
                        else:
//                            return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=".self::$message['invalidPaymentSession']);
                        endif;
                    else:
                        $queryString = "at={$request['airType']}&vc=&irf={$request['itineraryRef']}&rf={$request['itineraryRef']}&et={$request['itineraryRef']}";
//                        return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=".self::$message['invalidPnr']);
                endif;
            endif;
        } catch (\Stripe\Exception\CardException $e) {
//           return redirect("/ticketing/not-found");
        }
    }

    public function stripepayFailResponse(Request $request)
    {
        try {
            $subject = "Payment Cancel own by customer";
            if (!empty($request['itineraryRef'])):
                $prefix = $request->route()->getPrefix();
                $itineraryRef = $request['itineraryRef'];
                $flightItineraryInfo = FlightItineraryInfo::where('itineraryRef', $itineraryRef)->first();
                if(!empty($flightItineraryInfo->itineraryRef)):
                    $queryString = "at=$flightItineraryInfo->airType&vc=$flightItineraryInfo->vCarrier&irf=$flightItineraryInfo->itineraryRef&rf=$flightItineraryInfo->reference&et=$flightItineraryInfo->echoToken";
                    if (!empty($flightItineraryInfo->paySessionId) && $request->sessionId == $flightItineraryInfo->paySessionId):
                        $stripeClientProvider = stripeClientProvider::retrieve($request->sessionId);
                        if (!empty($flightItineraryInfo->totalFare) && $stripeClientProvider->payment_status == "unpaid" && $stripeClientProvider->status == "open"):
                            FlightItineraryInfo::where(['itineraryRef' => $itineraryRef])->update(['payResponse' => json_encode($stripeClientProvider)]);
                            $orderIssueProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse([
                                            "prefix" => $prefix,
                                            "airType" => $flightItineraryInfo->airType,
                                            "itineraryRef" => $flightItineraryInfo->itineraryRef,
                                            "reference" => $flightItineraryInfo->itineraryRef,
                                            "echoToken" => $flightItineraryInfo->itineraryRef,
                                            "jSessionId" => (!empty($flightItineraryInfo->jSessionId) ? $flightItineraryInfo->jSessionId : 'jSessionId'),
                                            "vCarrier" => $flightItineraryInfo->vCarrier
                                        ])['flightItinerary'];
                                        $customerName = $orderIssueProvider['persons'][0]['lastName']."/".$orderIssueProvider['persons'][0]['firstName'];
                                        $params = json_decode($flightItineraryInfo['params'],true);
                                        $subject ="{$customerName}  cancel the payment. Payment Status:{$stripeClientProvider->payment_status}";
                                        $message = "";
                                        event(new TicketingEmail([
                                                "unlink" => false,
                                                "to" => [env('MAIL_FROM_ADDRESS'), $flightItineraryInfo['email']],
                                                "name" => [env('MAIL_FROM_TITLE'), $customerName],
                                                "phoneNumber" => (!empty($flightItineraryInfo['phone']) ? $flightItineraryInfo['phone'] : '03345550579'),
                                                "subject" => "Passenger Name Record / Itinerary Reference has been successfully Created:",
                                                "body" => [
                                                    "Dear Administrator,<br/><b><u><i> MR {$customerName}</i></u></b> Created Passenger Name Record (PNR) / Itinerary Reference <b><u><i>{$itineraryRef}</i></u></b> has been successfully,but cancel the payment, payment status: {$stripeClientProvider->payment_status}.",
                                                    "Dear {$customerName},<br/>You have Created Passenger Name Record (PNR) / Itinerary Reference: <b><u><i>{$itineraryRef}</i></u></b> has been successfully,but You have cancel the payment, payment status: {$stripeClientProvider->payment_status}"
                                                ],
                                                "stripeClientProvider" => $stripeClientProvider,
                                                "orderRetrieveProvider" => $orderIssueProvider,
                                                "params" => $params,
                                                'title' => "Passenger Name Record / Itinerary Reference has been successfully Created:",
                                                'location' => 'itinerary',
                                                'pdf' => true,
                                                'view' => 'StripePayEmail'
                                        ]));
                                        event(new TicketingEmail([
                                                "unlink" => false,
                                                "to" => [env('MAIL_FROM_ADDRESS'), $flightItineraryInfo['email']],
                                                "name" => [env('MAIL_FROM_TITLE'), $customerName],
                                                "phoneNumber" => (!empty($flightItineraryInfo['phone']) ? $flightItineraryInfo['phone'] : '03345550579'),
                                                "subject" => $subject,
                                                "body" => [
                                                    "Dear Administrator,<br/><b><u><i> MR {$customerName}</i></u></b> Created Passenger Name Record (PNR) / Itinerary Reference <b><u><i>{$itineraryRef}</i></u></b> has been successfully,but cancel the payment, payment status: {$stripeClientProvider->payment_status}.",
                                                    "Dear {$customerName},<br/>You have Created Passenger Name Record (PNR) / Itinerary Reference: <b><u><i>{$itineraryRef}</i></u></b> has been successfully,but cancel the payment, payment status: {$stripeClientProvider->payment_status}."
                                                ],
                                                "stripeClientProvider" => "",
                                                "orderRetrieveProvider" => $orderIssueProvider,
                                                "params" => $params,
                                                'title' => $subject,
                                                'location' => 'itinerary',
                                                'pdf' => false,
                                                'view' => 'CheapestFareFlightOrderRetrieve'
                                            ]));
                            return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=$subject");
                        else:
                          return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=$subject");
                        endif;
                        else:
                            return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=$subject");
                        endif;
                    else:
                        $queryString = "at={$request['airType']}&vc=&irf={$request['itineraryRef']}&rf={$request['itineraryRef']}&et={$request['itineraryRef']}";
                        return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=".self::$message['invalidPnr']);
                endif;
            endif;
        } catch (\Stripe\Exception\CardException $e) {
            return redirect("/ticketing/not-found");
        }
    }
}
