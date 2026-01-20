<?php

namespace App\Http\Controllers\Common\Hblpay;

use App\Http\Controllers\Controller;
use App\Events\HblPay;
use App\Libraries\hblpay\HblpayTokenProvider;
use App\Libraries\hblpay\HblpayResponseProvider;
use App\Models\Ticketing\FlightItineraryParamInfo;
use App\Libraries\rest_api\OrderIssueProvider;
use App\Models\Profile\Agent;
use App\Models\Payment\Payment;
use Illuminate\Http\Request;
use App\Models\Ticketing\FlightItineraryInfo;
use App\Libraries\rest_api\OrderRetrieveProvider;
use App\Events\TicketingEmail;
use App\Libraries\rest_api\TicketingEmailProvider;
use App\Models\Ticketing\FlightItineraryPersonInfo;
use Illuminate\Support\Facades\Mail;

class HblpayController extends Controller
{

    private static $message = array(
        "backFromPayment" => "You came back from the payment page without paying:We noticed that you returned from the payment page without completing the transaction. If you encountered any issues during the payment process, please try again or contact our support team for assistance. Please note that your order is not guaranteed until payment is completed.Thank you for choosing our services.",
        "fareNotMatched" => "PNR Total Amount Mismatch Detected:It appears there is a discrepancy between the total fare shown in the PNR and the amount paid. Please verify the fare details and ensure that the correct amount has been entered for payment. If you need any assistance or have questions, feel free to contact our support team.",
        "invalidPaymentSession" => "Technical Issue: Invalid Payment Session:We're sorry for the inconvenience caused during the payment process. A technical issue has resulted in an invalid payment session. Please ensure your internet connection is stable and try the payment again. If the issue continues, try clearing your browser's cache and cookies or switch to a different browser.For immediate assistance, please contact our technical support team.",
        "invalidPnr" => "Technical Issue: Passenger Name Record (PNR) Not Found or Invalid",
        "already" => "Ticket Already Issued:The ticket for this Passenger Name Record (PNR) has already been issued. Reissuing the same PNR is not allowed.To proceed, please create a new PNR, complete the payment, and then issue the ticket."
    );
    private static $errorUrl = "/ticketing/cheapest-fare-flight-error";
    private static $orderUrl = "/ticketing/cheapest-fare-flight-order-retrieve?";
    private static $payUrl = "/payonline/cheapest-fare-order-pay-now?";

    public function __construct()
    {
//        $this->middleware('auth:sanctum');
    }

    public function hblpayToken(Request $request)
    {
        // return HblpayTokenProvider::hblpayToken($request);
    }

    public function hblpaySuccess(Request $request)
    {
        $hblpaySuccess = HblpayResponseProvider::hblpaySuccess($request);
        if ($hblpaySuccess['RESPONSE_CODE'] == 100 && !empty($hblpaySuccess['ORDER_REF_NUMBER']) && !empty($hblpaySuccess['PAYMENT_TYPE']) && strpos($hblpaySuccess['RESPONSE_MESSAGE'], 'Your transaction has been received successfully.') !== false):
            if (!empty($hblpaySuccess['HBLPAYPNR']) && !empty($hblpaySuccess['HBLPAYTOTALFARE'])):
                if (!empty($hblpaySuccess['HBLPAYPNR'])):
//                    $alfalahClientProvider = self::$alfalahClientProvider->transactionStatus($request['O']);
//                    if (!empty($alfalahClientProvider)):
                    $flightItineraryInfo = FlightItineraryInfo::itineraryRef($hblpaySuccess['HBLPAYPNR']);
                    if (!empty($flightItineraryInfo->itineraryRef)):
                        if ($hblpaySuccess['RESPONSE_CODE'] == 100 && str_replace([" ", ",", "."], "", $hblpaySuccess['RESPONSE_MESSAGE']) == 'DearCustomerThankyouforyourpaymentYourtransactionhasbeenreceivedsuccessfully'):
                            $hblpaySuccess['TransactionStatus'] = 'Paid';
                            $hblpaySuccess['TransactionAmount'] = $hblpaySuccess['HBLPAYTOTALFARE'];
                        else:
                            $hblpaySuccess['TransactionStatus'] = 'Unpaid';
                            $hblpaySuccess['TransactionAmount'] = '';
                        endif;
                        $orderRetrieveProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse($flightItineraryInfo);
                        $hblpaySuccess['transactionType'] = $hblpaySuccess['PAYMENT_TYPE'];
                        $hblpaySuccess['vendorType'] = (!empty($flightItineraryInfo->airType) ? $flightItineraryInfo->airType : '');
                        $hblpaySuccess['scopeType'] = 'rehmantravel';
                        $hblpaySuccess['sourceType'] = 'online';
                        $hblpaySuccess['bankType'] = 'HBL Bank';
                        $hblpaySuccess['cardType'] = 'Direct Debit / Credit Card';
                        $hblpaySuccess['OrderDateTime'] = date("Y-m-d h:i:s");
                        $hblpaySuccess['TransactionDateTime'] = date("Y-m-d h:i:s");
                        $hblpaySuccess['TransactionReferenceNumber'] = $hblpaySuccess['CARD_NUM_MASKED'] . '|' . $hblpaySuccess['GUID'];
                        $authenticate = Agent::find(1182);
                        $itineraryRef = $flightItineraryInfo->itineraryRef ?? '';
                        try {
                            FlightItineraryInfo::where(['itineraryRef' => $flightItineraryInfo->itineraryRef])->update(['bankType' => 'hbl', 'payResponse' => json_encode($hblpaySuccess), 'paySessionId' => $itineraryRef]);
                            $subject = "HBL Bank payment details have been submitted successfully.";
                            $flightItineraryPersonInfo = FlightItineraryPersonInfo::where(["itineraryRef" => $hblpaySuccess['HBLPAYPNR']])->first(['lastName', 'firstName']);
                            $customerName = ($flightItineraryPersonInfo->lastName ?? '') . '/' . ($flightItineraryPersonInfo->firstName ?? '');
                            TicketingEmailProvider::mail([
                                'view' => ['Payment', 'Payment'],
                                "to" => [env('MAIL_BC_ADDRESS'), $flightItineraryInfo['email']],
                                // "to" => ['kabirsafi@exalted.pk', 'khalidjavid@exalted.pk'],
                                "name" => [env('MAIL_BC_TTILE'), $customerName],
                                "phoneNumber" => [$flightItineraryInfo['phone'], '+923345550579'],
                                'flightItineraryInfo' => $flightItineraryInfo,
                                'paymentProvider' => $hblpaySuccess,
                                "subject" => [$subject, $subject],
                                "itineraryRef" => $hblpaySuccess['HBLPAYPNR'],
                                "body" => [
                                    "Dear Administrator,<br/><b><u><i>{$customerName}</i></u></b> have successfully created Passenger Name Record (PNR) / Itinerary Reference:<b><u><i>{$hblpaySuccess['HBLPAYPNR']}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='#C55A11'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='#ff0000'>{$hblpaySuccess['TransactionStatus']}</font></i></u></b>.",
                                    "Dear {$customerName},<br/>You have successfully created Passenger Name Record (PNR) / Itinerary Reference: <br/><b><u><i>{$hblpaySuccess['HBLPAYPNR']}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='#C55A11'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='#ff0000'>{$hblpaySuccess['TransactionStatus']}</font></i></u></b>."
                                ]
                            ]);
                        } catch (\Exception $e) {
                        }
                        $queryString = "at=$flightItineraryInfo->airType&vc=$flightItineraryInfo->vCarrier&irf=$flightItineraryInfo->itineraryRef&rf=$flightItineraryInfo->itineraryRef&et=$flightItineraryInfo->itineraryRef";
                        if (!empty($flightItineraryInfo->payType) && $flightItineraryInfo->payType == 'yes'):
                            if (!empty($hblpaySuccess['TransactionStatus']) && $hblpaySuccess['TransactionStatus'] == 'Paid'):
                                $priceInfo = json_decode($flightItineraryInfo->priceInfo, JSON_PRETTY_PRINT);
                                if ((intval($hblpaySuccess['TransactionAmount']) == intval($flightItineraryInfo->eqTotalAmount)) && (intval($hblpaySuccess['TransactionAmount']) == intval($priceInfo['eqDiscountFare']))):
                                    FlightItineraryInfo::where(['itineraryRef' => $flightItineraryInfo->itineraryRef])->update(['payType' => 'no']);
                                    if (!empty($orderRetrieveProvider["errorType"]) && !empty($orderRetrieveProvider["error"]) && $orderRetrieveProvider["errorType"] == true):
                                        self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $hblpaySuccess);
                                        return redirect(self::$errorUrl)->with(['error' => $orderRetrieveProvider["error"]]);
                                    elseif (!empty($orderRetrieveProvider["error"]["code"]) && $orderRetrieveProvider["error"]["code"] == 401):
                                        self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $hblpaySuccess);
                                        return redirect(self::$errorUrl)->with(['error' => 'Session Expired, Please refresh to continue']);
                                    elseif (!empty($orderRetrieveProvider["flightItinerary"]["flightItineraryInfo"]["errorType"]) && $orderRetrieveProvider["flightItinerary"]["flightItineraryInfo"]["errorType"] == "true"):
                                        self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $hblpaySuccess);
                                        return redirect(self::$errorUrl)->with(['error' => $orderRetrieveProvider["flightItinerary"]["flightItineraryInfo"]["error"]]);
                                    else:
                                        $orderIssueProvider = OrderIssueProvider::cheapestFareOrderChangeReponse($flightItineraryInfo);
                                        if (empty($orderIssueProvider)):
                                            $orderIssueProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse($flightItineraryInfo);
                                            $subject = "Attempt on Ticket Issuance but not successfully Issued";
                                            self::saveAndSend($authenticate, $flightItineraryInfo, $hblpaySuccess, $orderIssueProvider["flightItinerary"]);
                                            return redirect(self::$orderUrl . "$queryString&message=$subject");
                                        else:
                                            $subject = "Ticket has been successfully Issued";
                                            if (!empty($orderIssueProvider["errorType"]) && !empty($orderIssueProvider["error"]) && $orderIssueProvider["errorType"] == true):
                                                self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $hblpaySuccess);
                                                return redirect(self::$orderUrl . "$queryString&message=" . $orderIssueProvider["error"]);
                                            elseif (!empty($orderIssueProvider["error"]["code"]) && $orderIssueProvider["error"]["code"] == 401):
                                                self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $hblpaySuccess);
                                                return redirect(self::$orderUrl . "$queryString&message=Session Expired, Please refresh to continue");
                                            elseif (!empty($orderIssueProvider["flightItinerary"]["flightItineraryInfo"]["errorType"]) && $orderIssueProvider["flightItinerary"]["flightItineraryInfo"]["errorType"] == "true"):
                                                self::saveAndSendThrowError($authenticate, $flightItineraryInfo, $hblpaySuccess);
                                                return redirect(self::$orderUrl . "$queryString&message=" . $orderIssueProvider["flightItinerary"]["flightItineraryInfo"]["error"]);
                                            else:
                                                if (!empty($flightOrderIssueProvider["flightItinerary"]['flightItineraryInfo']['errorType']) && $flightOrderIssueProvider["flightItinerary"]['flightItineraryInfo']['errorType'] == 'true'):
                                                    $orderIssueProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse($flightItineraryInfo);
                                                    $subject = "";
                                                endif;
                                                self::saveAndSend($authenticate, $flightItineraryInfo, $hblpaySuccess, $orderIssueProvider["flightItinerary"]);
                                                return redirect(self::$orderUrl . "$queryString&message=$subject");
                                            endif;
                                        endif;
                                    endif;
                                else:
                                    self::saveAndSend($authenticate, $flightItineraryInfo, $hblpaySuccess, $orderRetrieveProvider["flightItinerary"]);
                                    return redirect(self::$orderUrl . "$queryString&message=" . self::$message['fareNotMatched']);
                                endif;
                            else:
                                self::saveAndSend($authenticate, $flightItineraryInfo, $hblpaySuccess, $orderRetrieveProvider["flightItinerary"]);
                                return redirect(self::$orderUrl . "$queryString&message=" . self::$message['backFromPayment']);
                            endif;
                        else:
                            return redirect(self::$orderUrl . "$queryString&message=" . self::$message['already']);
                        endif;
                    else:
                        return redirect(self::$errorUrl)->with(['error' => self::$message['invalidPnr']]);
                    endif;
//                    else:
//                        return redirect(self::$errorUrl)->with(['error' => self::$message['backFromPayment']]);
//                    endif;
                else:
                    return redirect(self::$errorUrl)->with(['error' => 'itineraryRef / OrderId not found,please try again']);
                endif;
            endif;
        endif;
    }

    private function saveAndSendThrowError($authenticate, $flightItineraryInfo, $hblpaySuccess)
    {
        $itineraryRef = $flightItineraryInfo->itineraryRef ?? '';
        $flightItineraryPersonInfo = FlightItineraryPersonInfo::where(['itineraryRef' => $itineraryRef])->first();
        if ($flightItineraryInfo->airType == 'Airsial'):
            $customerName = $flightItineraryPersonInfo['firstName'];
        else:
            $customerName = $flightItineraryPersonInfo['lastName'] . "/" . $flightItineraryPersonInfo['firstName'];
        endif;
        $subject = "Attempt on Ticket Issuance but not successfully Issued";
        Payment::depositAmountSave($authenticate, $flightItineraryInfo, $hblpaySuccess, $flightItineraryPersonInfo);
        TicketingEmailProvider::mail([
            'view' => ['company', 'company'],
            "to" => [env('MAIL_FROM_ADDRESS'), $flightItineraryInfo['email']],
            "name" => [env('MAIL_FROM_TITLE'), $customerName],
            "phoneNumber" => [$flightItineraryInfo['phone'], '+923345550579'],
            'flightItineraryInfo' => $flightItineraryInfo,
            'paymentProvider' => $hblpaySuccess,
            "subject" => [$subject, $subject],
            "itineraryRef" => $itineraryRef,
            "body" => [
                "Dear Administrator,<br/><b><u><i>{$customerName}</i></u></b> have successfully created Passenger Name Record (PNR) / Itinerary Reference:<b><u><i>{$itineraryRef}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='#C55A11'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='#ff0000'>{$hblpaySuccess['TransactionStatus']}</font></i></u></b>.",
                "Dear {$customerName},<br/>You have successfully created Passenger Name Record (PNR) / Itinerary Reference: <br/><b><u><i>{$itineraryRef}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='#C55A11'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='#ff0000'>{$hblpaySuccess['TransactionStatus']}</font></i></u></b>."
            ]
        ]);
    }

    private static function saveAndSend($authenticate, $flightItineraryInfo, $hblpaySuccess, $orderIssueProvider)
    {
        try {
            if (!empty($orderIssueProvider['flightItineraryInfo']['errorType']) && $orderIssueProvider['flightItineraryInfo']['errorType'] == 'false'):
                $itineraryRef = $flightItineraryInfo->itineraryRef ?? '';
                Payment::depositAmountSave($authenticate, $flightItineraryInfo, $hblpaySuccess, $orderIssueProvider);
                $phoneNumber = (!empty($orderIssueProvider['contacts'][0]['phone']) ? $orderIssueProvider['contacts'][0]['phone'] : '03345550579');
                $email = $orderIssueProvider['contacts'][0]['email'];
                if (!empty($orderIssueProvider['persons'])):
                    if ($flightItineraryInfo->airType == 'Airsial'):
                        $customerName = $orderIssueProvider['persons'][0]['firstName'];
                    else:
                        $customerName = $orderIssueProvider['persons'][0]['lastName'] . "/" . $orderIssueProvider['persons'][0]['firstName'];
                    endif;
                    if (!empty($orderIssueProvider['persons'][0]['ticketNumber'])):
                        $subject = "Ticket has been successfully Issued:";
                        $message = "";
                    else:
                        $subject = "Ticket Issuance was not successful";
                        $message = "Please direct contact on contact on below numbers";
                    endif;
                    TicketingEmailProvider::send([
                        "to" => [env('MAIL_FROM_ADDRESS'), $email],
                        "unlink" => [false, false],
                        "name" => [env('MAIL_FROM_TITLE'), $customerName],
                        "phoneNumber" => [$phoneNumber, '923345550579'],
                        "subject" => ['HBL Bank Payment Details', $subject],
                        "itineraryRef" => $itineraryRef,
                        "orderProvider" => [$hblpaySuccess, $orderIssueProvider],
                        "flightItineraryInfo" => $flightItineraryInfo,
                        'title' => $subject,
                        'location' => ['payment', 'ticket'],
                        'pdf' => [true, true],
                        'fileName' => ['hblpay', 'pnr'],
                        'view' => ['PaymentPdf', 'OrderRetrievePdf'],
                        "body" => [
                            "Dear Administrator,<br/><b><u><i>{$customerName}</i></u></b> have successfully created Passenger Name Record (PNR) / Itinerary Reference:<b><u><i>{$itineraryRef}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='" . (!empty($message) ? '#C55A11' : '#0b2e13') . "'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='" . (!empty($message) ? '#ff0000' : '#0b2e13') . "'>{$hblpaySuccess['TransactionStatus']}</font></i></u></b>.",
                            "Dear {$customerName},<br/>You have successfully created Passenger Name Record (PNR) / Itinerary Reference: <b><u><i>{$itineraryRef}</i></u></b>.Furthermore your attempt for <b><u><i><font size='3' color='" . (!empty($message) ? '#C55A11' : '#0b2e13') . "'>{$subject}</font></i></u></b>. The payment status is <b><u><i><font size='3' color='" . (!empty($message) ? '#ff0000' : '#0b2e13') . "'>{$hblpaySuccess['TransactionStatus']}</font></i></u></b>."
                        ]
                    ]);
                endif;
            endif;
        } catch (\Exception $e) {
            return redirect("/ticketing/not-found");
        }
    }

    public function hblpayFail(Request $request)
    {
        $hblpayFail = HblpayResponseProvider::hblpayFail($request);
        if (!empty($hblpayFail['HBLPAYPNR'])):
            $flightItineraryInfo = FlightItineraryInfo::itineraryRef($hblpayFail['HBLPAYPNR']);
            if ($hblpayFail['RESPONSE_CODE'] == 112):
                $itineraryRef = $hblpayFail['HBLPAYPNR'] ?? '';
                $authenticate = Agent::find(1182);
                $queryString = "at=$flightItineraryInfo->airType&vc=$flightItineraryInfo->vCarrier&irf=$flightItineraryInfo->itineraryRef&rf=$flightItineraryInfo->itineraryRef&et=$flightItineraryInfo->itineraryRef";
                $orderRetrieveProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse($flightItineraryInfo);
                $hblpayFail['transactionType'] = 0;
                $hblpayFail['vendorType'] = (!empty($flightItineraryInfo->airType) ? $flightItineraryInfo->airType : '');
                $hblpayFail['TransactionStatus'] = 'Cancelled';
                $hblpayFail['TransactionAmount'] = $hblpayFail['HBLPAYTOTALFARE'];
                $hblpayFail['scopeType'] = 'rehmantravel';
                $hblpayFail['sourceType'] = 'online';
                $hblpayFail['bankType'] = 'HBL Bank';
                $hblpayFail['cardType'] = 'Direct Debit / Credit Card';
                $hblpayFail['OrderDateTime'] = date("Y-m-d h:i:s");
                $hblpayFail['TransactionDateTime'] = date("Y-m-d h:i:s");
                $hblpayFail['TransactionReferenceNumber'] = ($hblpayFail['CARD_NUM_MASKED'] ?? '') . '|' . ($hblpayFail['GUID'] ?? '');
                self::saveAndSend($authenticate, $flightItineraryInfo, $hblpayFail, $orderRetrieveProvider["flightItinerary"]);
//                FlightItineraryInfo::where(['itineraryRef' => $itineraryRef])->update(['bankType' => 'hbl', 'payResponse' => json_encode($hblpayFail), 'paySessionId' => $itineraryRef, 'payType' => 'yes']);
            endif;
            return redirect(self::$orderUrl . "{$queryString}&message=Dear Customer, We have received notice that you have cancelled your recent order on the payment page.");
        endif;
    }

}
