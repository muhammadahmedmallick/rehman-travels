<?php

namespace App\Listeners;
use App\Events\OnlinePayEmail;
use App\Mail\OnlinePayMail;

class OnlinePayEmailFired {

    public function __construct(){}

    public function handle(OnlinePayEmail $onlinePayEmailEventProvider) {
        try {
        $emailEventProvider = $onlinePayEmailEventProvider->onlinePayEmailEventProvider;
        if (!empty($emailEventProvider['to'])):
            foreach ($emailEventProvider['to'] as $key => $to):
                new OnlinePayMail([
                    'view' => "Ticketing.{$emailEventProvider['view'][$key]}",
                    'to' => $to,
                    'toTitle' => ($key == 0 ? $emailEventProvider['name'][0] : $emailEventProvider['name'][1]),
                    'from' => ($key == 0 ? $emailEventProvider['to'][1] : $emailEventProvider['to'][0]),
                    'fromTitle' => ($key == 0 ? $emailEventProvider['name'][1] : $emailEventProvider['name'][0]),
                    'subject' => ($key == 0 ? $emailEventProvider['subject'][0] : $emailEventProvider['subject'][1]),
                    'data' => [
                        'paymentProvider' => $emailEventProvider['paymentProvider'],
                        'flightItineraryInfo' => $emailEventProvider['flightItineraryInfo'],
                        'body' => ($key == 0 ? $emailEventProvider['body'][0] : $emailEventProvider['body'][1]),
                        'email' => ($key == 0 ? $emailEventProvider['to'][1] : $emailEventProvider['to'][0]),
                        'userName' => ($key == 0 ? $emailEventProvider['name'][1] : $emailEventProvider['name'][0]),
                        'phoneNumber' => ($key == 0 ? $emailEventProvider['phoneNumber'][0] : $emailEventProvider['phoneNumber'][1])
                    ],
                ]);
            endforeach;
        endif;
        } catch (Exception $e) {
            \Log::info('Technical issue occurred,Your are not able to sent email successfuly! .'.$e->getMessage());
        }
    }

}
