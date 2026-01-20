<?php

namespace App\Libraries\rest_api;

use App\Libraries\rest_api\ServiceProvider;
use App\Rules\ValidName;
use Illuminate\Support\Facades\Session;
use Storage;
use App\Libraries\IpLogProvider;


class OrderCreateProvider
{
    private static $ipLogProvider;
    private static $routes;
    private static $airType;
    private static $duplicatePax = '';

    public static function cheapestFareOrderCreateReponse($request)
    {
        self::$ipLogProvider = new IpLogProvider($request);
        self::$routes = self::$ipLogProvider::__routes($request->params ?? null);
        self::$airType = $request->airType ?? null;
        $simultaneously = self::$ipLogProvider::simultaneously(self::$airType,self::$routes);
        $persons = self::__persons($request->persons);
        $passengers = json_encode($request->passengers);
        $request->merge(['passengers' => $persons['passengers']]);
        try {
            $request->validate([
                'passengers.*.firstName' => ['required', 'string', 'regex:/^[a-zA-Z ]+$/', 'min:2', 'max:50', new ValidName('first name')],
                'passengers.*.lastName' => ['required', 'string', 'regex:/^[a-zA-Z ]+$/', 'min:2', 'max:50', new ValidName('last name')],
            ]);
            $payload = self::__orderRetrieveRequest($request, $persons['persons']);
            Storage::put("$request->airType/payload.json", $payload);
            if ($simultaneously >= 3):
                $reason = 'You have attempted more than twice simultaneously.';
                self::$ipLogProvider::createOrUpdate($reason, $passengers, self::$airType, null, self::$routes);
                self::$ipLogProvider::blocked();
                session()->flash('error', $reason);
                return [
                    'serviceProvider' => [
                        'statusCode' => 429,
                        'errorType' => true,
                        'error' => $reason,
                        'responseError' => $reason
                    ]
                ];
            else:
                if (empty(self::$duplicatePax)):
//                    $payload = '{
//                        "airType": "Sabre",
//                        "pnr": "ACBKMS",
//                        "reference": "ACBKMS",
//                        "echoToken": "ACBKMS",
//                        "jSessionId":"ACBKMS",
//                        "vCarrier":"PK",
//                        "currencyRate":"1",
//                        "currencyCode":"PKR",
//                        "receivableAccount":"REHMAN GROUP OF TRAVELS",
//                        "paymentAmount":""
//                    }';
//                orderCreate
                    return [
                        'statusCode' => 200,
                        'serviceProvider' => ServiceProvider::doRequest("POST", "orderCreate", $payload),
                        'passengers' => json_encode($persons['passengers'])
                    ];
                else:
                    session()->flash('error', self::$duplicatePax);
                    self::$ipLogProvider::createOrUpdate(self::$duplicatePax, $passengers, self::$airType, null, self::$routes);
                    return [
                        'serviceProvider' => [
                            'statusCode' => 422,
                            'errorType' => true,
                            'error' => self::$duplicatePax,
                            'responseError' => self::$duplicatePax
                        ]
                    ];
                endif;
            endif;
        } catch (Illuminate\Validation\ValidationException $e) {
            self::$ipLogProvider::createOrUpdate($e->getMessage(), $passengers, self::$airType, null, self::$routes);
            $statusCode = 422;
            if ($simultaneously >= 3):
                $statusCode = 429;
                self::$ipLogProvider::blocked();
            endif;
            session()->flash('error', $e->getMessage());
            return [
                'serviceProvider' => [
                    'statusCode' => $statusCode,
                    'errorType' => true,
                    'error' => $e->getMessage(),
                    'responseError' => $e->getMessage()
                ]
            ];
        } catch (\Exception $e) {
            self::$ipLogProvider::createOrUpdate($e->getMessage(), null, self::$airType, null, self::$routes);
            $statusCode = 422;
            if ($simultaneously >= 2):
                self::$ipLogProvider::blocked();
                $statusCode = 429;
            endif;
            session()->flash('error', $e->getMessage());
            return [
                'serviceProvider' => [
                    'statusCode' => $statusCode,
                    'errorType' => true,
                    'error' => $e->getMessage(),
                    'responseError' => $e->getMessage()
                ]
            ];
        }
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
            $nameTitle = $persons['nameTitle'][$typeKey] ?? 'Mr';
            $firstName = $persons['firstName'][$typeKey] ?? '';
            $lastName = $persons['lastName'][$typeKey] ?? '';
            $passengers[] = array(
                "nameTitle" => $nameTitle,
                "firstName" => $firstName,
                "lastName" => $lastName
            );
            $duplicate = self::$ipLogProvider::duplicate($firstName, $lastName, self::$airType, self::$routes);
            if (!empty($duplicate) && $duplicate >= 1):
                self::$duplicatePax .= "You can't create more PNRs for ";
                self::$duplicatePax .= 'Pax:' . $firstName . ' ' . $nameTitle . '/' . $lastName;
                self::$duplicatePax .= ',Routes:' . self::$routes;
                self::$duplicatePax .= ',Supplier:' . self::$airType;
                break;
            endif;
            $payload .= '{
            "type": "' . strtolower($type) . '",
            "nameTitle": "' . $nameTitle . '",
            "firstName": "' . $firstName . '",
            "lastName": "' . $lastName . '",
            "dateOfBirth": "' . $persons['dobYear'][$typeKey] . '-' . $persons['dobMonth'][$typeKey] . '-' . $persons['dobDate'][$typeKey] . '",
            "gender": "' . ($nameTitle == 'Mr' || $nameTitle == 'MSTR' ? 'M' : 'F') . '",
            "document": {
                "type": "' . (!empty($persons['nationality'][$typeKey]) && $persons['nationality'][$typeKey] == 'PK' && $persons['nationality'][$typeKey] != '-1' ? (strlen($persons['idnNmber'][$typeKey]) == 13 ? 'I' : 'P') : 'P') . '",
                "number": "' . (!empty($persons['idnNmber'][$typeKey]) ? $persons['idnNmber'][$typeKey] : '1234512345671') . '",
                "expirationDate": "' . (!empty($persons['expYear'][$typeKey]) && !empty($persons['expMonth'][$typeKey]) && !empty($persons['expDate'][$typeKey]) ? $persons['expYear'][$typeKey] . '-' . $persons['expMonth'][$typeKey] . '-' . $persons['expDate'][$typeKey] : '2035-01-01') . '",
                "nationality": "' . (!empty($persons['nationality'][$typeKey]) && $persons['nationality'][$typeKey] != '-1' ? $persons['nationality'][$typeKey] : 'PK') . '",
                "issueDate": "' . (!empty($persons['issYear'][$typeKey]) && !empty($persons['issMonth'][$typeKey]) && !empty($persons['issDate'][$typeKey]) ? $persons['issYear'][$typeKey] . '-' . $persons['issMonth'][$typeKey] . '-' . $persons['issDate'][$typeKey] : '2035-01-01') . '",
                "issueCountry": "' . (!empty($persons['issueCountry'][$typeKey]) && $persons['issueCountry'][$typeKey] != '-1' ? $persons['issueCountry'][$typeKey] : 'PK') . '"
            }
        },';
        endforeach;
        return array(
            'passengers' => $passengers,
            'persons' => rtrim($payload, ",")
        );
    }
}
