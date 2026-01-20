<?php

namespace App\Libraries\stripepay;
use Stripe\StripeClient;
use Illuminate\Support\Facades\Storage;
class StripeClientProvider
{

    public static function retrieve($sessionId) {
        try {
            $stripeClientProvider = new StripeClient(env('STRIPE_SECRET_API_KEY'));
            return $stripeClientProvider->checkout->sessions->retrieve($sessionId);
        } catch (Error $e) {

        }
    }

    public static function create($currencyCode,$currencyRate,$itineraryRef,$airType,$totalFare) {
        try {
         $stripeClientProvider = new StripeClient(env('STRIPE_SECRET_API_KEY'));
            $session = $stripeClientProvider->checkout->sessions->create(self::__payload($currencyCode,$currencyRate,$itineraryRef,$airType,$totalFare));
            return [
                "payUrl" =>  $session->url,
                "paySessionId" => $session->id,
                "error" => "",
                "errorType" => "false"
            ];
        } catch (Error $e) {
            return [
                "payUrl" =>  "",
                "error" => $e->getMessage(),
                "errorType" => "true"
            ];
        }
    }

    private static function __payload($currencyCode,$currencyRate,$itineraryRef,$airType,$totalFare) {
        $payload = [
            'line_items' => [[
                'price_data' => [
                    'currency' => $currencyCode,
                    'product_data' => [
                        'name' => $itineraryRef,
                    ],
                    'unit_amount' =>  round((($totalFare * 100) / $currencyRate)),
                ],
                'quantity' => 1,
            ]],
            'mode' => 'payment',
            'success_url' => env('APP_URL')."ticketing/cheapest-fare-stripe-pay-success-response?sessionId={CHECKOUT_SESSION_ID}&itineraryRef=$itineraryRef&airType=$airType",
            'cancel_url' => env('APP_URL')."ticketing/cheapest-fare-stripe-pay-fail-response?sessionId={CHECKOUT_SESSION_ID}&itineraryRef=$itineraryRef&airType=$airType"
        ];
        Storage::put("stripe/{$itineraryRef}.json", json_encode($payload));
        return $payload;
    }
}
