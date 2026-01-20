<?php

namespace App\Libraries\hblpay;

use Request;
use Session;
use Storage;
use App\Models\Ticketing\FlightItineraryParamInfo;

class HblpayTokenProvider
{

private static $publicPEMKey = '-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEApwD31YSC7DHP67bwkAjY
8PQydi9NnMIdExYMGmXbNC9UNeH1NRhUMAwqVvTCBtH1d64h9rcfdHC/MsbpW8YP
YMEaI1C3uKHephotlot2X6o1z6E3QS4lGiSJ55rDERzqX/Zx0j8z3QLCAZXEjUPG
sDrf9RrII+hic1CupZGSTEzdOy3tajxSTDlQ88utUu/gKyFVKWnDFysivsGXtQCY
T7R7vMNChdRoMEq3Rt/mFxpE+lIPQKcYR1N7S9CE+JX+7iPkLbG+2qpwcnaixngg
3165M1Oi7paqVqs+4SoXD6A83+Fu1LZyK19olQt3F7IZY0JttoBdLjdaB3AADBqJ
Cc+LrgGCdyfV+04bPfYFo3OqMmP8ec3Y8sarT133gNTySn85ZU8VxTZ3xGHXKD9p
V+SjOBF3FNb7P8kyOc0IrBa8e/i7q1/BUtRqpR0mzL9SQjVhUx7hkPtEny9V5wnS
3zMmjpvPe9Tc+CYqenkUSWVIkTLKjl3TkxrPeWUoJW2BlLfFXEOhIptQSood00L4
Fqc3/GiPzo/bW+j+PO4DHK5t5JBxSwbymDvK27Rr4QV5KypFtdfEqgQvUPuqe+B5
6B/saxejqGhsFrAOtG9QdpzUnp4UtKjn+22K4NyJul+FisplTGL02FVRv9zuEOit
dof+xw5bbwzncMUxag+OIOECAwEAAQ==
-----END PUBLIC KEY-----';

    public static function hblpayToken($request)
    {
        $hblRequestPayload = json_decode(self::__hblpayRequestPayload($request), true);
        $payload = json_encode(self::__recParamsEncryption($hblRequestPayload, self::$publicPEMKey));
        $response = self::__doRequest('post', $payload);
        if (!empty($response['Data']) && !empty($response['IsSuccess'])):
            return [
                "payUrl" => env('HBL_PAYURL').'#/checkout?data=' . base64_encode($response['Data']['SESSION_ID']),
                "error" => "",
                "responseError" => "",
                "errorType" => "false"
            ];
        else:
            return [
                "payUrl" => "",
                "error" => $response["ResponseMessage"] ?? '',
                "responseError" => $response["ResponseMessage"] ?? '',
                "errorType" => "true"
            ];
        endif;
    }

    private static function __hblpayRequestPayload($request)
    {
        $pnr = $request->itineraryRef ?? $request['itineraryRef'] ?? '';
        $totalFare = $request->payAmount ?? $request['payAmount'] ?? 0;
        $referenceNumber = $pnr . "|" . $totalFare;
        $payload = '{
                "USER_ID": "'.env('HBL_USER_ID').'",
                "PASSWORD": "'.env('HBL_PASSWORD').'",
                "CLIENT_NAME": "'.env('HBL_CLIENT_NAME').'",
                "RETURN_URL": "'.env('HBL_RETURN_URL').'",
                "CANCEL_URL": "'.env('HBL_CANCEL_URL').'",
                "CHANNEL": "HBLPay_RehmanT_Website",
                "TYPE_ID": "",
                "ORDER": {
                    "DISCOUNT_ON_TOTAL": "0",
                    "SUBTOTAL": "' . $totalFare . '",
                    "OrderSummaryDescription": [{
                            "ITEM_NAME": "' . $pnr . '",
                            "QUANTITY": "1",
                            "UNIT_PRICE": "' . $totalFare . '",
                            "OLD_PRICE": "0",
                            "CATEGORY": "' . $pnr . '",
                            "SUB_CATEGORY": "' . $pnr . '"
                        }
                    ]
                },
                "SHIPPING_DETAIL": {
                    "NAME": "Rehman Travels",
                    "ICON_PATH": null,
                    "DELIEVERY_DAYS": "1",
                    "SHIPPING_COST": "' . $totalFare . '"
                },
                "ADDITIONAL_DATA": {
                    "REFERENCE_NUMBER": "' . $referenceNumber . '",
                    "CUSTOMER_ID": "' . $pnr . '",
                    "CURRENCY": "PKR",
                    "BILL_TO_FORENAME": "' . ($request->firstName ?? 'Nouman') . '",
                    "BILL_TO_SURNAME": "' . ($request->lastName ?? 'Khan') . '",
                    "BILL_TO_EMAIL": "' . ($request->email ?? 'itmanager@rehmantravel.com') . '",
                    "BILL_TO_PHONE": "' . ($request->mobileNo ??  '+923345550579') . '",
                    "BILL_TO_ADDRESS_LINE": "' . ($request->nationality ?? 'Islamabad') . '",
                    "BILL_TO_ADDRESS_CITY": "' . ($request->nationality ?? 'Islamabad') . '",
                    "BILL_TO_ADDRESS_STATE": "Islamabad",
                    "BILL_TO_ADDRESS_COUNTRY": "' . ($request->nationality ?? 'PK') . '",
                    "BILL_TO_ADDRESS_POSTAL_CODE": "44000",
                    "SHIP_TO_FORENAME": "Nouman",
                    "SHIP_TO_SURNAME": "Khan",
                    "SHIP_TO_EMAIL": "itmanager@rehmantravel.com",
                    "SHIP_TO_PHONE": "00923345550579",
                    "SHIP_TO_ADDRESS_LINE": "Allay Plaza",
                    "SHIP_TO_ADDRESS_CITY": "Islamabad",
                    "SHIP_TO_ADDRESS_STATE": "Islamabad",
                    "SHIP_TO_ADDRESS_COUNTRY": "PK",
                    "SHIP_TO_ADDRESS_POSTAL_CODE": "44000",
                    "MerchantFields": {
                        "MDD1": "WC",
                        "MDD2": "YES",
                        "MDD3": "Travel and Transportation",
                        "MDD4": "' . $pnr . '",
                        "MDD5": "NO",
                        "MDD7": "1",
                        "MDD9": "' . $pnr . '",
                        "MDD10": "' . ($request->flightType ?? 'one-way') . '",
                        "MDD11": "' . $pnr . '",
                        "MDD20": "NO"
                    }
                }
            }';
        Storage::put("hbl/$pnr.json", $payload);
        return $payload;
    }

    private static function __recParamsEncryption($recParamsEncryptions, $publicPemKey)
    {
        foreach ($recParamsEncryptions as $recParamsEncryptionIndex => $recParamsEncryption) :
            if (!is_array($recParamsEncryption)):
                if ($recParamsEncryptionIndex !== "USER_ID"):
                    $recParamsEncryptions[$recParamsEncryptionIndex] = self::__rsaParamsEncryption($recParamsEncryption, $publicPemKey);
                else:
                    $recParamsEncryptions[$recParamsEncryptionIndex] = $recParamsEncryption;
                endif;
            else:
                $recParamsEncryptions[$recParamsEncryptionIndex] = self::__recParamsEncryption($recParamsEncryption, $publicPemKey);
            endif;
        endforeach;
        return $recParamsEncryptions;
    }

    private static function __rsaParamsEncryption($plainData, $publicPemKey = null)
    {
        if (!empty($publicPemKey)):
            $encryption = openssl_public_encrypt($plainData, $rsaParamsEncryption, $publicPemKey, OPENSSL_PKCS1_PADDING);
            if ($encryption === false):
                return false;
            endif;
            return base64_encode($rsaParamsEncryption);
        else:
            return false;
        endif;
    }

    private static function __explode($delimiter, $string)
    {
        return explode($delimiter, $string);
    }

    private static function __queryEncode($array = array())
    {
        return str_replace('/', '_', rtrim(base64_encode(gzcompress(serialize($array))), '='));
    }

    private static function __queryDecode($str = '')
    {
        return (is_string($str) && strlen($str)) ? @unserialize(gzuncompress(base64_decode(str_replace('_', '/', $str)))) : FALSE;
    }

    private static function __doRequest($method, $payload)
    {
        try {
            $client = new \GuzzleHttp\Client(['http_errors' => false, 'verify' => false]);
            $response = $client->request($method, env('HBL_ENDPOINT_URL'), [
                'headers' => [
                    'Content-Type' => 'application/json'
                ],
                'body' => $payload,
            ]);
            return json_decode($response->getBody(), true);
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

}
