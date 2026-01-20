<?php

namespace App\Http\Controllers\Common\Alfalah;

use App\Http\Controllers\Controller;
use App\Libraries\rest_api\OrderIssueProvider;
use App\Models\Profile\Agent;
use App\Models\Payment\Payment;
use Illuminate\Http\Request;
use App\Models\Ticketing\FlightItineraryInfo;
use App\Libraries\rest_api\OrderRetrieveProvider;
use App\Events\TicketingEmail;
use App\Libraries\alfalah\AlfalahClientProvider;
use App\Libraries\rest_api\TicketingEmailProvider;
use App\Models\Ticketing\FlightItineraryPersonInfo;
use Illuminate\Support\Facades\Mail;
use App\Events\OnlinePayEmail;
use Storage;

class AlfalahpayController extends Controller {

    private static $info;
    private static $alfalahClientProvider;
    private static $message = array(
        "backFromPayment" => "You came back from the payment page without paying:We noticed that you returned from the payment page without completing the transaction. If you encountered any issues during the payment process, please try again or contact our support team for assistance. Please note that your order is not guaranteed until payment is completed.Thank you for choosing our services.",
        "fareNotMatched" => "PNR Total Amount Mismatch Detected:It appears there is a discrepancy between the total fare shown in the PNR and the amount paid. Please verify the fare details and ensure that the correct amount has been entered for payment. If you need any assistance or have questions, feel free to contact our support team.",
        "invalidPaymentSession" => "Technical Issue: Invalid Payment Session:We're sorry for the inconvenience caused during the payment process. A technical issue has resulted in an invalid payment session. Please ensure your internet connection is stable and try the payment again. If the issue continues, try clearing your browser's cache and cookies or switch to a different browser.For immediate assistance, please contact our technical support team.",
        "invalidPnr" => "Technical Issue: Passenger Name Record (PNR) Not Found or Invalid",
        "already" => "Ticket Already Issued:The ticket for this Passenger Name Record (PNR) has already been issued. Reissuing the same PNR is not allowed.To proceed, please create a new PNR, complete the payment, and then issue the ticket."
    );
    private static $errorUrl = "/ticketing/cheapest-fare-flight-error?";
    private static $orderUrl = "/ticketing/cheapest-fare-flight-order-retrieve?";
    private static $payUrl = "/payonline/cheapest-fare-order-pay-now?";
    
    public function __construct(AlfalahClientProvider $alfalahClientProvider) {
         return "";
        self::$alfalahClientProvider = $alfalahClientProvider;
    }

    public function alfalahPay(Request $request) {
        try {
            return self::$alfalahClientProvider->create($request);
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    public function initiateHc(Request $request) {
        return self::$alfalahClientProvider->sendInitiateHCRequest($request);
    }

    public function processHc(Request $request) {
        $itineraryRef = (!empty($request->itineraryRef) ? $request->itineraryRef : $request['itineraryRef']);
        $airType = (!empty($request->airType) ? $request->airType : $request['airType']);
        $refNumber = (!empty($request->refNumber) ? $request->refNumber : $request['refNumber']);
        $queryString = "at=$airType&irf=$itineraryRef&rf=$itineraryRef&et=$itineraryRef&cc=&cr=";
        // if (!empty($request['response']) && $request['response']['success'] == "false"):
        if (!empty($request['response'])):
            // if (!empty($response->success) && $response->success == 'true'):
                return self::__issueTicketRequest($request);
            // else:
            //     return response()->json([
            //         "queryUrl" => self::$payUrl . $queryString,
            //         "pageUrl" => "payUrl",
            //         "refNumber" => $refNumber,
            //         "itineraryRef" => $itineraryRef,
            //         "errorType" => "true",
            //         "error" => $response->ErrorMessage,
            //         "responseError" => $response->ErrorMessage
            //     ]);
            // endif;
        elseif (!empty($request['response']["action"]) && $request['response']["action"] == "FB_LOG"):
            return response()->json([
                "queryUrl" => self::$payUrl . $queryString,
                "pageUrl" => "payUrl",
                "refNumber" => $refNumber,
                "itineraryRef" => $itineraryRef,
                "error" => $request['response']['logMessage'],
                "responseError" => $request['response']['logMessage'],
                "errorType" => "true",
            ]);
        elseif (!empty($request['response']['result']) && $request['response']['result'] == "FAILURE"):
            return response()->json([
                "queryUrl" => self::$payUrl . $queryString,
                "pageUrl" => "payUrl",
                "refNumber" => $refNumber,
                "itineraryRef" => $itineraryRef,
                "error" => $request['response']['result'],
                "responseError" => $request['response']['result'],
                "errorType" => "true",
            ]);
        else:
            return response()->json([
                "queryUrl" => self::$payUrl . $queryString,
                "pageUrl" => "payUrl",
                "refNumber" => $refNumber,
                "itineraryRef" => $itineraryRef,
                "error" => $request['response']['ErrorMessage'],
                "responseError" => $request['response']['ErrorMessage'],
                "errorType" => "true",
            ]);
        endif;
    }

    private static function __issueTicketRequest($request) {
        try {
            $itineraryRef = (!empty($request->itineraryRef) ? $request->itineraryRef : $request['itineraryRef']);
            $refNumber = (!empty($request->refNumber) ? $request->refNumber : $request['refNumber']);
            if (!empty($request->refNumber)):
                $alfalahClientProvider = self::$alfalahClientProvider->transactionStatus($request->refNumber);
                dd('issueTicketRequest',$alfalahClientProvider);
                if (!empty($alfalahClientProvider->TransactionReferenceNumber)):
                    $transactionRefNumber = explode("@", $alfalahClientProvider->TransactionReferenceNumber);
                    $flightItineraryInfo = FlightItineraryInfo::itineraryRef($transactionRefNumber[0]);
                    if (!empty($flightItineraryInfo->itineraryRef)):
                        $orderRetrieveProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse($flightItineraryInfo);
                        $alfalahClientProvider->transactionType = self::__transactionType($alfalahClientProvider->TransactionTypeId);
                        $alfalahClientProvider->vendorType = (!empty($flightItineraryInfo->airType) ? $flightItineraryInfo->airType : '');
                        $alfalahClientProvider->scopeType = 'rehmantravel';
                        $alfalahClientProvider->sourceType = 'online';
                        $alfalahClientProvider->bankType = 'Alfalah';
                        $alfalahClientProvider->cardType = 'Debit / Credit Card';
                        $authenticate = Agent::find(1182);
                         try {
                                FlightItineraryInfo::where(['itineraryRef' => $flightItineraryInfo->itineraryRef])->update(['bankType' => 'Alfalah', 'payResponse' => json_encode($alfalahClientProvider), 'paySessionId' => $request['O']]);
                                $subject = "Alfalah payment details have been submitted successfully.";
                                $flightItineraryPersonInfo = FlightItineraryPersonInfo::where(["itineraryRef" => $orderId[0]])->first(['lastName','firstName']);
                                $customerName =( $flightItineraryPersonInfo->lastName ?? '') .'/'.($flightItineraryPersonInfo->firstName ?? '');
                                TicketingEmailProvider::mail([
                                    'view' => ['Payment', 'Payment'],
                                    "to" => [env('MAIL_BC_ADDRESS'), $flightItineraryInfo['email']],
                                    "name" => [env('MAIL_BC_TTILE'), $customerName],
                                    "phoneNumber" => [($flightItineraryInfo['phone'] ?? $alfalahClientProvider->MobileNumber), '+923345550579'],
                                    'flightItineraryInfo' => $flightItineraryInfo,
                                    'paymentProvider' => $alfalahClientProvider,
                                    "subject" => [$subject, $subject],
                                    "itineraryRef" => $orderId[0],
                                    "body" => [
                                        "Dear Administrator,<br/><b><u><i>{$customerName}</i></u></b> have successfully created Passenger Name Record (PNR) / Itinerary Reference:<b><u><i>{$orderId[0]}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='#C55A11'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='#ff0000'>{$alfalahClientProvider->TransactionStatus}</font></i></u></b>.",
                                        "Dear {$customerName},<br/>You have successfully created Passenger Name Record (PNR) / Itinerary Reference: <br/><b><u><i>{$orderId[0]}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='#C55A11'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='#ff0000'>{$alfalahClientProvider->TransactionStatus}</font></i></u></b>."
                                    ]
                                ]);
                        } catch (\Exception $e) {}
                        $queryString = "at=$flightItineraryInfo->airType&vc=$flightItineraryInfo->vCarrier&irf=$flightItineraryInfo->itineraryRef&rf=$flightItineraryInfo->reference&et=$flightItineraryInfo->echoToken";
                        if (!empty($flightItineraryInfo->payType) && $flightItineraryInfo->payType == 'no'):
                            if (!empty($alfalahClientProvider->TransactionStatus) && $alfalahClientProvider->TransactionStatus == 'Paid'):
                                $priceInfo = json_decode($flightItineraryInfo->priceInfo, JSON_PRETTY_PRINT);
                                if ((intval($alfalahClientProvider->TransactionAmount) == intval($transactionRefNumber[2])) &&
                                    (intval($transactionRefNumber[2]) == intval($flightItineraryInfo->eqTotalFare)) &&
                                    (intval($alfalahClientProvider->TransactionAmount) == intval($priceInfo['eqDiscountFare']))):
                                    $itineraryRef = $flightItineraryInfo->itineraryRef;
                                    FlightItineraryInfo::where(['itineraryRef' => $flightItineraryInfo->itineraryRef])->update(['payType' => 'no']);
                                    if (!empty($orderRetrieveProvider["errorType"]) && !empty($orderRetrieveProvider["error"]) && $orderRetrieveProvider["errorType"] == true):
                                        self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider);
                                        return response()->json([
                                            "queryUrl" => self::$errorUrl . $queryString,
                                            "pageUrl" => "errorUrl",
                                            "refNumber" => $refNumber,
                                            "itineraryRef" => $itineraryRef,
                                            "error" => $orderRetrieveProvider["error"],
                                            "responseError" => $orderRetrieveProvider["error"],
                                            "errorType" => "true"
                                        ]);
                                    elseif (!empty($orderRetrieveProvider["error"]["code"]) && $orderRetrieveProvider["error"]["code"] == 401):
                                        self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider);
                                        return response()->json([
                                            "queryUrl" => self::$errorUrl . $queryString,
                                            "pageUrl" => "errorUrl",
                                            "refNumber" => $refNumber,
                                            "itineraryRef" => $itineraryRef,
                                            "error" => 'Session Expired, Please refresh to continue',
                                            "responseError" => 'Session Expired, Please refresh to continue',
                                            "errorType" => "true"
                                        ]);
                                    elseif (!empty($orderRetrieveProvider["flightItinerary"]["flightItineraryInfo"]["errorType"]) && $orderRetrieveProvider["flightItinerary"]["flightItineraryInfo"]["errorType"] == "true"):
                                        self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider);
                                        return response()->json([
                                            "queryUrl" => self::$errorUrl . $queryString,
                                            "pageUrl" => "errorUrl",
                                            "refNumber" => $refNumber,
                                            "itineraryRef" => $itineraryRef,
                                            "error" => $orderRetrieveProvider["flightItinerary"]["flightItineraryInfo"]["error"],
                                            "responseError" => $orderRetrieveProvider["flightItinerary"]["flightItineraryInfo"]["error"],
                                            "errorType" => "true"
                                        ]);
                                    else:
                                        $orderIssueProvider = OrderIssueProvider::cheapestFareOrderChangeReponse($flightItineraryInfo);
                                        if (empty($orderIssueProvider)):
                                            $orderIssueProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse($flightItineraryInfo);
                                            $subject = "Attempt on Ticket Issuance but not successfully Issued";
                                            self::saveAndSend($authenticate, $flightItineraryInfo, $alfalahClientProvider, $orderIssueProvider["flightItinerary"]);
                                            return response()->json([
                                                "queryUrl" => self::$orderUrl . $queryString,
                                                "pageUrl" => "orderUrl",
                                                "refNumber" => $refNumber,
                                                "itineraryRef" => $itineraryRef,
                                                "error" => $subject,
                                                "responseError" => $subject,
                                                "errorType" => "true"
                                            ]);
                                        else:
                                            $subject = "Ticket has been successfully Issued";
                                            if (!empty($orderIssueProvider["errorType"]) && !empty($orderIssueProvider["error"]) && $orderIssueProvider["errorType"] == true):
                                                self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider);
                                                return response()->json([
                                                    "queryUrl" => self::$orderUrl . $queryString,
                                                    "pageUrl" => "orderUrl",
                                                    "refNumber" => $refNumber,
                                                    "itineraryRef" => $itineraryRef,
                                                    "error" => $orderIssueProvider["error"],
                                                    "responseError" => $orderIssueProvider["error"],
                                                    "errorType" => "true"
                                                ]);
                                            elseif (!empty($orderIssueProvider["error"]["code"]) && $orderIssueProvider["error"]["code"] == 401):
                                                self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider);
                                                return response()->json([
                                                    "queryUrl" => self::$orderUrl . $queryString,
                                                    "pageUrl" => "orderUrl",
                                                    "refNumber" => $refNumber,
                                                    "itineraryRef" => $itineraryRef,
                                                    "error" => 'Session Expired, Please refresh to continue',
                                                    "responseError" => 'Session Expired, Please refresh to continue',
                                                    "errorType" => "true"
                                                ]);
                                            elseif (!empty($orderIssueProvider["flightItinerary"]["flightItineraryInfo"]["errorType"]) && $orderIssueProvider["flightItinerary"]["flightItineraryInfo"]["errorType"] == "true"):
                                                self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider);
                                                return response()->json([
                                                    "queryUrl" => self::$orderUrl . $queryString,
                                                    "pageUrl" => "orderUrl",
                                                    "refNumber" => $refNumber,
                                                    "itineraryRef" => $itineraryRef,
                                                    "error" => $orderIssueProvider["flightItinerary"]["flightItineraryInfo"]["error"],
                                                    "responseError" => $orderIssueProvider["flightItinerary"]["flightItineraryInfo"]["error"],
                                                    "errorType" => "true"
                                                ]);
                                            else:
                                                if (!empty($flightOrderIssueProvider["flightItinerary"]['flightItineraryInfo']['errorType']) && $flightOrderIssueProvider["flightItinerary"]['flightItineraryInfo']['errorType'] == 'true'):
                                                    $orderIssueProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse($flightItineraryInfo);
                                                    $subject = "";
                                                endif;
                                                self::saveAndSend($authenticate, $flightItineraryInfo, $alfalahClientProvider, $orderIssueProvider["flightItinerary"]);
                                                return response()->json([
                                                    "queryUrl" => self::$orderUrl . $queryString,
                                                    "pageUrl" => "orderUrl",
                                                    "refNumber" => $refNumber,
                                                    "itineraryRef" => $itineraryRef,
                                                    "error" => $subject,
                                                    "responseError" => $subject,
                                                    "errorType" => "false"
                                                ]);
                                            endif;
                                        endif;
                                    endif;
                                else:
                                    self::saveAndSend($authenticate, $flightItineraryInfo, $alfalahClientProvider, $orderRetrieveProvider["flightItinerary"]);
                                    return response()->json([
                                        "queryUrl" => self::$orderUrl . $queryString,
                                        "pageUrl" => "orderUrl",
                                        "refNumber" => $refNumber,
                                        "itineraryRef" => $itineraryRef,
                                        "error" => self::$message['fareNotMatched'],
                                        "responseError" => self::$message['fareNotMatched'],
                                        "errorType" => "true"
                                    ]);
                                endif;
                            else:
                                self::saveAndSend($authenticate, $flightItineraryInfo, $alfalahClientProvider, $orderRetrieveProvider["flightItinerary"]);
                                return response()->json([
                                    "queryUrl" => self::$orderUrl . $queryString,
                                    "pageUrl" => "orderUrl",
                                    "refNumber" => $refNumber,
                                    "itineraryRef" => $itineraryRef,
                                    "error" => self::$message['backFromPayment'],
                                    "responseError" => self::$message['backFromPayment'],
                                    "errorType" => "true"
                                ]);
                            endif;
                        else:
                            return response()->json([
                                "queryUrl" => self::$orderUrl . $queryString,
                                "pageUrl" => "orderUrl",
                                "refNumber" => $refNumber,
                                "itineraryRef" => $itineraryRef,
                                "error" => self::$message['already'],
                                "responseError" => self::$message['already'],
                                "errorType" => "true"
                            ]);
                        endif;
                    else:
                        return response()->json([
                            "queryUrl" => self::$errorUrl . $itineraryRef,
                            "pageUrl" => "errorUrl",
                            "refNumber" => $itineraryRef,
                            "itineraryRef" => $itineraryRef,
                            "error" => self::$message['invalidPnr'],
                            "responseError" => self::$message['invalidPnr'],
                            "errorType" => "true"
                        ]);
                    endif;
                else:
                    return response()->json([
                        "queryUrl" => self::$errorUrl . $itineraryRef,
                        "pageUrl" => "errorUrl",
                        "refNumber" => $itineraryRef,
                        "itineraryRef" => $itineraryRef,
                        "error" => self::$message['backFromPayment'],
                        "responseError" => self::$message['backFromPayment'],
                        "errorType" => "true"
                    ]);
                endif;
            else:
                return response()->json([
                    "queryUrl" => self::$errorUrl . $itineraryRef,
                    "pageUrl" => "errorUrl",
                    "refNumber" => $itineraryRef,
                    "itineraryRef" => $itineraryRef,
                    "error" => 'itineraryRef / OrderId not found,please try again',
                    "responseError" => 'itineraryRef / OrderId not found,please try again',
                    "errorType" => "true"
                ]);
            endif;
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    public function alfalahPaySuccessResponse(Request $request) {
        return "";
        try {
            if (!empty($request['O'])):
                $alfalahClientProvider = self::$alfalahClientProvider->transactionStatus($request['O']);
                if (!empty($alfalahClientProvider)):
                    $orderId = explode("@", (!empty($request['O']) ? $request['O'] : '@@@'));
                    $flightItineraryInfo = FlightItineraryInfo::itineraryRef($orderId[0]);
                    if (!empty($flightItineraryInfo->itineraryRef)):
                        $orderRetrieveProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse($flightItineraryInfo);
                        $alfalahClientProvider->transactionType = self::__transactionType($alfalahClientProvider->TransactionTypeId);
                        $alfalahClientProvider->vendorType = (!empty($flightItineraryInfo->airType) ? $flightItineraryInfo->airType : '');
                        $alfalahClientProvider->scopeType = 'rehmantravel';
                        $alfalahClientProvider->sourceType = 'online';
                        $alfalahClientProvider->bankType = 'Alfalah';
                        $alfalahClientProvider->cardType = 'Direct Debit / Credit Card';
                        $authenticate = Agent::find(1182);
                        try {
                                FlightItineraryInfo::where(['itineraryRef' => $flightItineraryInfo->itineraryRef])->update(['bankType' => 'Alfalah', 'payResponse' => json_encode($alfalahClientProvider), 'paySessionId' => $request['O']]);
                                $subject = "Alfalah payment details have been submitted successfully.";
                                $flightItineraryPersonInfo = FlightItineraryPersonInfo::where(["itineraryRef" => $orderId[0]])->first(['lastName','firstName']);
                                $customerName =( $flightItineraryPersonInfo->lastName ?? '') .'/'.($flightItineraryPersonInfo->firstName ?? '');
                                TicketingEmailProvider::mail([
                                    'view' => ['Payment', 'Payment'],
                                    "to" => [env('MAIL_BC_ADDRESS'), $flightItineraryInfo['email']],
                                    "name" => [env('MAIL_BC_TTILE'), $customerName],
                                    "phoneNumber" => [($flightItineraryInfo['phone'] ?? $alfalahClientProvider->MobileNumber), '+923345550579'],
                                    'flightItineraryInfo' => $flightItineraryInfo,
                                    'paymentProvider' => $alfalahClientProvider,
                                    "subject" => [$subject, $subject],
                                    "itineraryRef" => $orderId[0],
                                    "body" => [
                                        "Dear Administrator,<br/><b><u><i>{$customerName}</i></u></b> have successfully created Passenger Name Record (PNR) / Itinerary Reference:<b><u><i>{$orderId[0]}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='#C55A11'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='#ff0000'>{$alfalahClientProvider->TransactionStatus}</font></i></u></b>.",
                                        "Dear {$customerName},<br/>You have successfully created Passenger Name Record (PNR) / Itinerary Reference: <br/><b><u><i>{$orderId[0]}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='#C55A11'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='#ff0000'>{$alfalahClientProvider->TransactionStatus}</font></i></u></b>."
                                    ]
                                ]);
                        } catch (\Exception $e) {}
                        $queryString = "at=$flightItineraryInfo->airType&vc=$flightItineraryInfo->vCarrier&irf=$flightItineraryInfo->itineraryRef&rf=$flightItineraryInfo->reference&et=$flightItineraryInfo->echoToken";
                        if (!empty($flightItineraryInfo->payType) && $flightItineraryInfo->payType == 'yes'):
                            if (!empty($alfalahClientProvider->TransactionStatus) && $alfalahClientProvider->TransactionStatus == 'Paid'):
                                $priceInfo = json_decode($flightItineraryInfo->priceInfo,JSON_PRETTY_PRINT);
                                if ((intval($alfalahClientProvider->TransactionAmount) == intval($orderId[2])) &&
                                    (intval($orderId[2]) == intval($flightItineraryInfo->eqTotalAmount)) &&
                                    (intval($alfalahClientProvider->TransactionAmount) == intval($priceInfo['eqDiscountFare']))
                                ):
                                    $itineraryRef = $flightItineraryInfo->itineraryRef;
                                    FlightItineraryInfo::where(['itineraryRef' => $flightItineraryInfo->itineraryRef])->update(['payType' => 'no']);
                                    // FlightItineraryInfo::where(['itineraryRef' => $flightItineraryInfo->itineraryRef])->update(['bankType' => 'Alfalah', 'payResponse' => json_encode($alfalahClientProvider), 'paySessionId' => $request['O'], 'payType' => 'no']);
                                    if (!empty($orderRetrieveProvider["errorType"]) && !empty($orderRetrieveProvider["error"]) && $orderRetrieveProvider["errorType"] == true):
                                        self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider);
                                        return redirect("/ticketing/cheapest-fare-flight-error")->with(['error' => $orderRetrieveProvider["error"]]);
                                    elseif (!empty($orderRetrieveProvider["error"]["code"]) && $orderRetrieveProvider["error"]["code"] == 401):
                                        self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider);
                                        return redirect("/ticketing/cheapest-fare-flight-error")->with(['error' => 'Session Expired, Please refresh to continue']);
                                    elseif (!empty($orderRetrieveProvider["flightItinerary"]["flightItineraryInfo"]["errorType"]) && $orderRetrieveProvider["flightItinerary"]["flightItineraryInfo"]["errorType"] == "true"):
                                        self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider);
                                        return redirect("/ticketing/cheapest-fare-flight-error")->with(['error' => $orderRetrieveProvider["flightItinerary"]["flightItineraryInfo"]["error"]]);
                                    else:
                                        $orderIssueProvider = OrderIssueProvider::cheapestFareOrderChangeReponse($flightItineraryInfo);
                                        if (empty($orderIssueProvider)):
                                            $orderIssueProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse($flightItineraryInfo);
                                            $subject = "Attempt on Ticket Issuance but not successfully Issued";
                                            self::saveAndSend($authenticate, $flightItineraryInfo, $alfalahClientProvider, $orderIssueProvider["flightItinerary"]);
                                            return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=$subject");
                                        else:
                                            $subject = "Ticket has been successfully Issued";
                                            if (!empty($orderIssueProvider["errorType"]) && !empty($orderIssueProvider["error"]) && $orderIssueProvider["errorType"] == true):
                                                self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider);
                                                return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=" . $orderIssueProvider["error"]);
                                            elseif (!empty($orderIssueProvider["error"]["code"]) && $orderIssueProvider["error"]["code"] == 401):
                                                self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider);
                                                return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=Session Expired, Please refresh to continue");
                                            elseif (!empty($orderIssueProvider["flightItinerary"]["flightItineraryInfo"]["errorType"]) && $orderIssueProvider["flightItinerary"]["flightItineraryInfo"]["errorType"] == "true"):
                                                self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider);
                                                return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=" . $orderIssueProvider["flightItinerary"]["flightItineraryInfo"]["error"]);
                                            else:
                                                if (!empty($flightOrderIssueProvider["flightItinerary"]['flightItineraryInfo']['errorType']) && $flightOrderIssueProvider["flightItinerary"]['flightItineraryInfo']['errorType'] == 'true'):
                                                    $orderIssueProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse($flightItineraryInfo);
                                                    $subject = "";
                                                endif;
                                                self::saveAndSend($authenticate, $flightItineraryInfo, $alfalahClientProvider, $orderIssueProvider["flightItinerary"]);
                                                return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=$subject");
                                            endif;
                                        endif;
                                    endif;
                                else:
                                    self::saveAndSend($authenticate, $flightItineraryInfo, $alfalahClientProvider, $orderRetrieveProvider["flightItinerary"]);
                                    return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=" . self::$message['fareNotMatched']);
                                endif;
                            else:
                                self::saveAndSend($authenticate, $flightItineraryInfo, $alfalahClientProvider, $orderRetrieveProvider["flightItinerary"]);
                                return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=" . self::$message['backFromPayment']);
                            endif;
                        else:
                            return redirect("/ticketing/cheapest-fare-flight-order-retrieve?$queryString&message=" . self::$message['already']);
                        endif;
                    else:
                        return redirect("/ticketing/cheapest-fare-flight-error")->with(['error' => self::$message['invalidPnr']]);
                    endif;
                else:
                    return redirect("/ticketing/cheapest-fare-flight-error")->with(['error' => self::$message['backFromPayment']]);
                endif;
            else:
                return redirect("/ticketing/cheapest-fare-flight-error")->with(['error' => 'itineraryRef / OrderId not found,please try again']);
            endif;
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    private function saveAndSendThrowError($authenticate, $flightItineraryInfo, $alfalahClientProvider) {
        $itineraryRef = $flightItineraryInfo->itineraryRef;
        $flightItineraryPersonInfo = FlightItineraryPersonInfo::where(['itineraryRef' => $itineraryRef])->first();
        $customerName = '';
        if ($flightItineraryInfo->airType == 'Airsial'):
            $customerName =  $flightItineraryPersonInfo['firstName'];
        else:
            $customerName = $flightItineraryPersonInfo['lastName'] . "/" . $flightItineraryPersonInfo['firstName'];
        endif;
        $subject = "Attempt on Ticket Issuance but not successfully Issued";
        Payment::depositAmountSave($authenticate, $flightItineraryInfo, $alfalahClientProvider, $flightItineraryPersonInfo);
        TicketingEmailProvider::mail([
            'view' => ['company', 'company'],
            "to" => [env('MAIL_FROM_ADDRESS'), $flightItineraryInfo['email']],
            "name" => [env('MAIL_FROM_TITLE'), $customerName],
            "phoneNumber" => [$flightItineraryInfo['phone'], '+923345550579'],
            'flightItineraryInfo' => $flightItineraryInfo,
            'paymentProvider' => $alfalahClientProvider,
            "subject" => [$subject, $subject],
            "itineraryRef" => $itineraryRef,
            "body" => [
                "Dear Administrator,<br/><b><u><i>{$customerName}</i></u></b> have successfully created Passenger Name Record (PNR) / Itinerary Reference:<b><u><i>{$itineraryRef}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='#C55A11'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='#ff0000'>{$alfalahClientProvider->TransactionStatus}</font></i></u></b>.",
                "Dear {$customerName},<br/>You have successfully created Passenger Name Record (PNR) / Itinerary Reference: <br/><b><u><i>{$itineraryRef}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='#C55A11'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='#ff0000'>{$alfalahClientProvider->TransactionStatus}</font></i></u></b>."
            ]
        ]);
    }

    private static function saveAndSend($authenticate, $flightItineraryInfo, $alfalahClientProvider, $orderIssueProvider) {
        try {
            if (!empty($orderIssueProvider['flightItineraryInfo']['errorType']) && $orderIssueProvider['flightItineraryInfo']['errorType'] == 'false'):
                $itineraryRef = $flightItineraryInfo->itineraryRef;
                Payment::depositAmountSave($authenticate, $flightItineraryInfo, $alfalahClientProvider, $orderIssueProvider);
                $phoneNumber = (!empty($orderIssueProvider['contacts'][0]['phone']) ? $orderIssueProvider['contacts'][0]['phone'] : '03345550579');
                $email = $orderIssueProvider['contacts'][0]['email'];
                if (!empty($orderIssueProvider['persons'])):
                    $customerName = '';
                    if ($flightItineraryInfo->airType == 'Airsial'):
                        $customerName = $orderIssueProvider['persons'][0]['firstName'];
                    else:
                        $customerName = $orderIssueProvider['persons'][0]['lastName'] . "/" . $orderIssueProvider['persons'][0]['firstName'];
                    endif;
                    if (!empty($orderIssueProvider['persons'][0]['ticketNumber'])):
                        $subject = "Ticket has been successfully Issued:";
                        $body = "Now you are ready for flying for more information please contact on below numbers";
                        $message = "";
                    else:
                        $subject = "Ticket Issuance was not successful";
                        $body = "And An unexpected error has occurred.";
                        $message = "Please direct contact on contact on below numbers";
                    endif;
                    TicketingEmailProvider::send([
                        "to" => [env('MAIL_FROM_ADDRESS'), $email],
                        "unlink" => [false, false],
                        "name" => [env('MAIL_FROM_TITLE'), $customerName],
                        "phoneNumber" => [$phoneNumber, '923345550579'],
                        "subject" => ['Alfalah Payment Details', $subject],
                        "body" => [
                            "Dear Administrator,<br/><b><u><i>{$customerName}</i></u></b> have successfully created Passenger Name Record (PNR) / Itinerary Reference:<b><u><i>{$itineraryRef}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='".(!empty($message) ? '#C55A11': '#0b2e13')."'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='".(!empty($message) ? '#ff0000': '#0b2e13')."'>{$alfalahClientProvider->TransactionStatus}</font></i></u></b>.",
                            "Dear {$customerName},<br/>You have successfully created Passenger Name Record (PNR) / Itinerary Reference: <b><u><i>{$itineraryRef}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='".(!empty($message) ? '#C55A11': '#0b2e13')."'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='".(!empty($message) ? '#ff0000': '#0b2e13')."'>{$alfalahClientProvider->TransactionStatus}</font></i></u></b>."
                        ],
                        "itineraryRef" => $itineraryRef,
                        "orderProvider" => [$alfalahClientProvider, $orderIssueProvider],
                        "flightItineraryInfo" => $flightItineraryInfo,
                        'title' => $subject,
                        'location' => ['payment', 'ticket'],
                        'pdf' => [true, true],
                        'fileName' => ['alfalahpay', 'pnr'],
                        'view' => ['AlfalahPayPdf', 'OrderRetrievePdf']
                    ]);
                endif;
            endif;
        } catch (\Exception $e) {
            return redirect("/ticketing/not-found");
        }
    }

    private static function __transactionType($transactionType = 3) {
        $transactionTypes = array("Alfa Wallet" => 1, "Alfalah Bank Account" => 2, "Credit Card" => 3, "Card on Delivery" => 6, "Other Bank Accounts" => 4);
        return array_search($transactionType, $transactionTypes);
    }

}
