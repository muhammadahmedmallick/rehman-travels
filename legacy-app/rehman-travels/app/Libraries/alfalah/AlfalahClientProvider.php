<?php

namespace App\Libraries\alfalah;

use App\Models\Ticketing\FlightItineraryInfo;
use Storage;

class AlfalahClientProvider
{
    private static $alfalahPayClientProvider;

//
    public function __construct(AlfalahPayClientProvider $alfalahPayClientProvider)
    {
        self::$alfalahPayClientProvider = $alfalahPayClientProvider;
    }

    public static function sendInitiateHCRequest($request)
    {
        try {
            $queryString = "at={$request['airType']}&vc=FZ&irf={$request['itineraryRef']}&rf={$request['itineraryRef']}&et={$request['itineraryRef']}&cc=&cr=";
            if (!empty($request['itineraryRef'])):
                $flightItineraryInfo = FlightItineraryInfo::itineraryRef($request['itineraryRef']);
                if (!empty($flightItineraryInfo->itineraryRef)):
                    $flightItineraryInfo = FlightItineraryInfo::itineraryRef($request['itineraryRef']);
                    $refNumber = (!empty($request['itineraryRef']) ? $request['itineraryRef'] : '') . '@';
                    $refNumber .= (!empty($request['airType']) ? $request['airType'] : '') . '@';
                    $refNumber .= (!empty($flightItineraryInfo->eqDiscountFare) ? $flightItineraryInfo->eqDiscountFare : $flightItineraryInfo->eqTotalFare) . '@';
                    $refNumber .= (!empty($request['countryCode']) ? $request['countryCode'] : 164) . '@';
                    $refNumber .= (!empty($request['countryCode']) ? 'PKR' : (!empty($request['currencyCode']) ? $request['currencyCode'] : 'PKR')) . '@';
                    $refNumber .= rand(0, 1786612);
                    Storage::put("alfalahIpn/" . time() . ".json", $refNumber);
                    self::$alfalahPayClientProvider->setTransactionType((!empty($request->transactionType) ? $request->transactionType : 3));
                    self::$alfalahPayClientProvider->setAmount((!empty($flightItineraryInfo->eqDiscountFare) ? $flightItineraryInfo->eqDiscountFare : $flightItineraryInfo->eqTotalFare));
                    self::$alfalahPayClientProvider->setTransactionReferenceNumber($refNumber);
                    self::$alfalahPayClientProvider->setAccountNumber($request->cardNumber);
                    self::$alfalahPayClientProvider->setCVV($request->cvv);
                    self::$alfalahPayClientProvider->setCardHolderName($request->userName);
                    self::$alfalahPayClientProvider->setExpiryMonth($request->expMonth);
                    self::$alfalahPayClientProvider->setExpiryYear($request->expYear);
                    self::$alfalahPayClientProvider->setEmail($request->email);
                    self::$alfalahPayClientProvider->setMobileNumber($request->mobileNo);
                    self::$alfalahPayClientProvider->initiateHCKeys();
                    $response = self::$alfalahPayClientProvider->initiateHC();
                    if (!empty($response->success) && $response->success == 'true' && $response->Is3DS == "Y"):
                        return response()->json([
                            "payUrl" => $response->HTMLUrl,
                            "refNumber" => $refNumber,
                            "itineraryRef" => $request['itineraryRef'],
                            "pageUrl" => "alfalah",
                            "error" => "",
                            "responseError" => "",
                            "errorType" => "false"
                        ]);
                    else:
                        return response()->json([
                            "payUrl" => "/payonline/cheapest-fare-order-pay-now?$queryString",
                            "pageUrl" => "htmlUrl",
                            "refNumber" => $refNumber,
                            "itineraryRef" => $request['itineraryRef'],
                            "error" => "your bank connection is out of reach,please try again",
                            "responseError" => "your bank connection is out of reach,please try again",
                            "errorType" => "true"
                        ]);
                    endif;
                else:
                    return response()->json([
                        "payUrl" => "/payonline/cheapest-fare-order-pay-now?$queryString",
                        "pageUrl" => "htmlUrl",
                        "refNumber" => "",
                        "itineraryRef" => $request['itineraryRef'],
                        "error" => "PNR not found",
                        "responseError" => "PNR not found",
                        "errorType" => "true"
                    ]);
                endif;
            else:
                return response()->json([
                    "payUrl" => "/payonline/cheapest-fare-order-pay-now?$queryString",
                    "pageUrl" => "htmlUrl",
                    "refNumber" => "",
                    "itineraryRef" => $request['itineraryRef'],
                    "error" => "Invalid PNR,first create PNR",
                    "responseError" => "Invalid PNR,first create PNR",
                    "errorType" => "true"
                ]);
            endif;
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    public static function sendProcessHcRequest($request)
    {
        try {
        self::$alfalahPayClientProvider->setTransactionReferenceNumber($request->refNumber);
        self::$alfalahPayClientProvider->setAmount($request->payAmount);
        self::$alfalahPayClientProvider->setTransactionType((!empty($request->transactionType) ? $request->transactionType : 3));
        self::$alfalahPayClientProvider->setAccountNumber($request->cardNumber);
        self::$alfalahPayClientProvider->setCVV($request->cvv);
        self::$alfalahPayClientProvider->setCardHolderName($request->userName);
        self::$alfalahPayClientProvider->setExpiryMonth($request->expMonth);
        self::$alfalahPayClientProvider->setExpiryYear($request->expYear);
        self::$alfalahPayClientProvider->setEmail($request->email);
        self::$alfalahPayClientProvider->setMobileNumber($request->mobileNo);
        self::$alfalahPayClientProvider->setMPGSTokenBase64($request->response);
        return self::$alfalahPayClientProvider->sendProcessHc();
        } catch (Error $e) {
            return $e->getMessage();
        }
    }

    public static function create($request)
    {
        try {
            $flightItineraryInfo = FlightItineraryInfo::itineraryRef($request['itineraryRef']);
            $referenceNumber = (!empty($request['itineraryRef']) ? $request['itineraryRef'] : '') . '@';
            $referenceNumber .= (!empty($request['airType']) ? $request['airType'] : '') . '@';
            $referenceNumber .= (!empty($flightItineraryInfo->eqDiscountFare) ? $flightItineraryInfo->eqDiscountFare : $flightItineraryInfo->eqTotalFare) . '@';
            $referenceNumber .= (!empty($request['countryCode']) ? $request['countryCode'] : 164) . '@';
            $referenceNumber .= (!empty($request['countryCode']) ? 'PKR' : (!empty($request['currencyCode']) ? $request['currencyCode'] : 'PKR')) . '@';
            $referenceNumber .= rand(0, 1786612);
            $response = self::$alfalahPayClientProvider->setTransactionReferenceNumber($referenceNumber)->getToken();
            if ($response != null && $response->success == 'true'):
                return self::__payload($response->AuthToken, $request, $referenceNumber);
            else:
                return $response;
            endif;
        } catch (Error $e) {
            return $e->getMessage();
        }
    }

    private static function __payload($authToken, $request, $referenceNumber)
    {
        try {
            $flightItineraryInfo = FlightItineraryInfo::itineraryRef($request['itineraryRef']);
            self::$alfalahPayClientProvider->setAuthToken($authToken);
            self::$alfalahPayClientProvider->setCurrency((!empty($request['countryCode']) ? 'PKR' : (!empty($request['currencyCode']) ? $request['currencyCode'] : 'PKR')));
            self::$alfalahPayClientProvider->setTransactionReferenceNumber($referenceNumber);
            self::$alfalahPayClientProvider->setTransactionType((!empty($request['transactionType']) ? $request['transactionType'] : 3));
            // self::$alfalahPayClient->setAccountNumber((!empty($request['accNumber']) ? $request['accNumber'] :''));
            self::$alfalahPayClientProvider->setCountryCode((!empty($request['countryCode']) ? $request['countryCode'] : '164'));
            self::$alfalahPayClientProvider->setAmount((!empty($flightItineraryInfo->eqDiscountFare) ? $flightItineraryInfo->eqDiscountFare : $flightItineraryInfo->eqTotalFare));
            //  self::$alfalahPayClientProvider->setMobileNumber((!empty($request['mobileNo']) ? $request['mobileNo'] : '923345550579'));
            //  self::$alfalahPayClientProvider->setEmail((!empty($request['email']) ? $request['email'] : 'info@rehmantravel.com'));
            $response = self::$alfalahPayClientProvider->sendTransactionRequest();
            if ($response == '/SSO/SSO/InvalidRequest'):
                return [
                    "payUrl" => "/payonline/cheapest-fare-order-pay-now?at={$request['airType']}&irf={$request['itineraryRef']}",
                    "payType" => "alfalah",
                    "error" => "",
                    "errorType" => "false"
                ];
            else:
                return [
                    "payUrl" => $response,
                    "payType" => "alfalah",
                    "error" => "",
                    "errorType" => "false"
                ];
            endif;
        } catch (Error $e) {
            return [
                "payType" => "alfalah",
                "payUrl" => "",
                "error" => $e->getMessage(),
                "errorType" => "true"
            ];
        }
    }

    public static function transactionStatus($oderId)
    {
        try {
            self::$alfalahPayClientProvider->setOrderID($oderId);
            return self::$alfalahPayClientProvider->transactionStatus();
        } catch (Error $e) {
            return $e->getMessage();
        }
    }

}
