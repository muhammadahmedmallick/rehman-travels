<?php

namespace App\Libraries\rest_api;

use Request;
use GuzzleHttp\Client;
use Storage;
use App\Events\RefreshAccessToken;
use Session;
use App\Models\Profile\Agent;
class ServiceProvider {
    public static function doRequest($method, $actionType, $payload) {
        try {
            $loggedIn = Agent::find(1182);
            $accessToken =  json_decode(Storage::get('AccessToken/1182owner.json',true));
            $client = new \GuzzleHttp\Client(['http_errors' => false, 'verify' => false]);
            $response = $client->request($method, env('API_URL').$actionType, [
                'headers' => [
                    "Accept" => "application/json",
                    "Content-Type" => "application/json",
                    "Access-Control-Allow-Origin" => "*",
                    "Access-Control-Allow-Headers" => "Content-Type, Authorization, Accept, Accept-Language,",
                    "Access-Control-Allow-Methods" => "GET, POST",
                    "Authorization" => "Bearer ".$accessToken->data->access_token,
                    "secretId" => (!empty($loggedIn['secretId']) ? $loggedIn['secretId'] : ''),
                    "clientId" => (!empty($loggedIn['email']) ? $loggedIn['email'] : ''),
                    "clientSecret" => (!empty($loggedIn['clientSecret']) ? $loggedIn['clientSecret'] : ''),
                    "password" => (!empty($loggedIn['password']) ? $loggedIn['password'] : ''),
                    "grantType" => "exaltedsys_api",
                    "userType" => 'agent'
                ],
                'body' => $payload,
            ]);
            return json_decode($response->getBody(), true);
        } catch (\Exception $e) {
            return [];
        }
    }
    public static function doHotelRequest($method, $url, $payload) {
        try {
            $client = new \GuzzleHttp\Client(['http_errors' => false, 'verify' => false]);
            $response = $client->request($method, $url, [
                'headers' => [
                    'Content-Type' => 'application/xml',
                    'APIKey' => 'inrA02LyBUe4klzNCLI1AO=='
                ],
                'body' => $payload,
            ]);
            return json_decode($response->getBody(), true);
        } catch (\Exception $e) {
            return [];
        }
    }
}
