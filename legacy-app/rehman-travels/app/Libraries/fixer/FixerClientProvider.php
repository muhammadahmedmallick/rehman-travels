<?php

namespace App\Libraries\fixer;
use GuzzleHttp\Client;

class FixerClientProvider
{

    private static $url = "https://data.fixer.io/api/latest?access_key=";

    public static function retrieve($base) {
        try {
            return self::__doRequest($base);
        } catch (Error $e) {

        }
    }

    private static function __doRequest($base) {
        try {
            $client = new \GuzzleHttp\Client(['http_errors' => false, 'verify' => false]);
            $response = $client->request('get', self::$url.env('FIXER_SECRET_API_KEY')."&base={$base}&symbols=PKR", [
                'headers' => [
                    'Content-Type' => 'application/json'
                ],
            ]);
            dd(json_decode($response->getBody(), true));
            return json_decode($response->getBody(), true);
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }
}
