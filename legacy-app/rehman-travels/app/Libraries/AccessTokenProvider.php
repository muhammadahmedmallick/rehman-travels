<?php

namespace App\Libraries;

use Request;
use Session;

class AccessTokenProvider {

    public static function accessToken($loggedIn) {
        try {
            return self::__authentication($loggedIn);
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    private static function __authentication($loggedIn) {
        try {
            $payload = '{
                 "clientId": "'.(!empty($loggedIn['email']) ? $loggedIn['email'] : '').'",
                 "grantType": "exaltedsys_api",
                 "userType":"'.(!empty($loggedIn['activeType']) ? $loggedIn['activeType'] :'agent').'",
                 "secretId":"'.(!empty($loggedIn['secretId']) ? $loggedIn['secretId'] : '').'",
                 "clientSecret": "'.(!empty($loggedIn['clientSecret']) ? $loggedIn['clientSecret'] : '').'",
                 "password":"'.(!empty($loggedIn['password']) ? $loggedIn['password'] : '').'"
               }';
            $client = new \GuzzleHttp\Client(['http_errors' => true, 'verify' => true]);
            $response = $client->request('post', env('API_URL')."authenticate", [
                'headers' => [
                    'Content-Type' => 'application/json'
                ],
                'body' => $payload,
            ]);
            return json_decode($response->getBody(), true);
        } catch (\Exception $e) {
            return '';
        }
    }

}
