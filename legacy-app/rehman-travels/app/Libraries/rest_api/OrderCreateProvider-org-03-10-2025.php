<?php

namespace App\Libraries\rest_api;

use App\Libraries\rest_api\ServiceProvider;
use Storage;

class OrderCreateProvider
{

    public static function cheapestFareOrderCreateReponse($request)
    {
        $persons = self::__persons($request->persons);
        $payload = self::__orderRetrieveRequest($request, $persons['persons']);
        Storage::put("$request->airType/payload.json", $payload);
        return array(
            'serviceProvider' => ServiceProvider::doRequest("POST","orderCreate", $payload),
            'passengers' => json_encode($persons['passengers'])
        );
    }

    public static function __orderRetrieveRequest($request, $persons)
    {
        return '{
            "jSessionId": "' . $request->jSessionId . '",
            "adultsCount":"' . $request->adultsCount . '",
            "childrenCount": "' . $request->childrenCount . '",
            "infantsCount": "' . $request->infantsCount . '",
            "phoneNumber": "' . (!empty($request->phoneNumber) ? $request->phoneNumber : '00923345488801') . '",
            "email": "' . $request->email . '",
            "airType": "' . $request->airType . '",
            "vCarrier": "' . $request->vCarrier . '",
            "currencyRate":"' . (!empty($request->currencyRate) ? $request->currencyRate : 1) . '",
            "currencyCode":"' . (!empty($request->currencyCode) ? $request->currencyCode : 'PKR') . '",
            "partyAccount":"Rehman Group of Travels",
            "departureDate":"' . $request->departureDate . '",
            "contactInfo": [{"type": "H","phone": "' . (!empty($request->phoneNumber) ? $request->phoneNumber : '00923345488801') . '"},{"type": "O","phone": "009251111785786"}],
            "bookingInfo":"' . $request->bookingInfo . '",
            "persons":[' . $persons . '],
            "bookingKeys": ' . json_encode($request->bookingKeys) . '
        }';
    }

    private static function __persons($persons)
    {
        $payload = '';
        $passengers = array();
        foreach ($persons['type'] as $typeKey => $type):
            $passengers[] = array(
                "nameTitle" => $persons['nameTitle'][$typeKey],
                "firstName" => $persons['firstName'][$typeKey],
                "lastName" => $persons['lastName'][$typeKey]
            );
            $payload .= '{
            "type": "' . strtolower($type) . '",
            "nameTitle": "' . $persons['nameTitle'][$typeKey] . '",
            "firstName": "' . $persons['firstName'][$typeKey] . '",
            "lastName": "' . $persons['lastName'][$typeKey] . '",
            "dateOfBirth": "' . $persons['dobYear'][$typeKey].'-'.$persons['dobMonth'][$typeKey].'-'.$persons['dobDate'][$typeKey] . '",
            "gender": "' . ($persons['nameTitle'][$typeKey] == 'Mr' || $persons['nameTitle'][$typeKey] == 'MSTR' ? 'M' : 'F') . '",
            "document": {
                "type": "'.(!empty($persons['nationality'][$typeKey]) && $persons['nationality'][$typeKey] == 'PK' && $persons['nationality'][$typeKey] != '-1' ? (strlen($persons['idnNmber'][$typeKey]) == 13 ? 'I' :'P') : 'P').'",
                "number": "'.(!empty($persons['idnNmber'][$typeKey]) ? $persons['idnNmber'][$typeKey] : rand(12345123456718,100)).'",
                "expirationDate": "'.(!empty($persons['expYear'][$typeKey]) && !empty($persons['expMonth'][$typeKey]) && !empty($persons['expDate'][$typeKey]) ? $persons['expYear'][$typeKey].'-'.$persons['expMonth'][$typeKey].'-'.$persons['expDate'][$typeKey] : date('Y-m-d', strtotime("+".rand(2,50)." years"))).'",
                "nationality": "'.(!empty($persons['nationality'][$typeKey]) && $persons['nationality'][$typeKey] != '-1' ? $persons['nationality'][$typeKey] : 'PK').'",
                "issueDate": "'.(!empty($persons['issYear'][$typeKey]) && !empty($persons['issMonth'][$typeKey]) && !empty($persons['issDate'][$typeKey]) ? $persons['issYear'][$typeKey].'-'.$persons['issMonth'][$typeKey].'-'.$persons['issDate'][$typeKey] : date('Y-m-d', strtotime("+".rand(2,50)." years"))).'",
                "issueCountry": "'.(!empty($persons['issueCountry'][$typeKey]) && $persons['issueCountry'][$typeKey] != '-1'? $persons['issueCountry'][$typeKey] : 'PK').'"
            }
        },';
        endforeach;
        return array(
            'passengers' => $passengers,
            'persons' => rtrim($payload, ",")
        );

    }

}
