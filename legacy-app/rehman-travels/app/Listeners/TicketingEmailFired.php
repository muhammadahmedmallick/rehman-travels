<?php

namespace App\Listeners;

use App\Events\TicketingEmail;
use PDF;
use Illuminate\Support\Facades\Storage;
use App\Mail\NotifyMail;
use Illuminate\Support\Facades\View;

class TicketingEmailFired {

    /**
     * Create the event listener.
     *
     * @return void
     */
    public function __construct() {
        
    }

    /**
     * Handle the event.
     *
     * @param \App\Events\TicketingEmail $ticketingEmail
     * @return void
     */
    public function handle(TicketingEmail $ticketingEmailEventProvider) {
        try {
            $emailEventProvider = $ticketingEmailEventProvider->ticketingEmailEventProvider;
            $itineraryRef = $emailEventProvider['itineraryRef'];
            if ($emailEventProvider['pdf'][0] == true):
                $paymentPdf = PDF::loadView("emails.Ticketing.{$emailEventProvider['view'][0]}", [
                            'paymentProvider' => $emailEventProvider['orderProvider'][0],
                            'orderProvider' => $emailEventProvider['orderProvider'][1],
                            'title' => '',
                            'body' => '',
                ]);
                $location = $emailEventProvider['location'][0];
                Storage::put("pdf/$location/{$emailEventProvider['fileName'][0]}-{$itineraryRef}.pdf", $paymentPdf->output());
            endif;
            if ($emailEventProvider['pdf'][1] == true):
                $orderPdf = PDF::loadView("emails.Ticketing.{$emailEventProvider['view'][1]}", [
                            'orderProvider' => $emailEventProvider['orderProvider'][1],
                            'title' => $emailEventProvider['title'],
                            'body' => '',
                ]);
                $location = $emailEventProvider['location'][1];
                Storage::put("pdf/$location/{$emailEventProvider['fileName'][1]}-{$itineraryRef}.pdf", $orderPdf->output());
            endif;
            try {
                if (!empty($emailEventProvider['to'])):
                    foreach ($emailEventProvider['to'] as $key => $to):
                        new NotifyMail([
                            'view' => "Ticketing.{$emailEventProvider['view'][$key]}",
                            'to' => $to,
                            'toTitle' => ($key == 0 ? $emailEventProvider['name'][0] : $emailEventProvider['name'][1]),
                            'from' => ($key == 0 ? $emailEventProvider['to'][1] : $emailEventProvider['to'][0]),
                            'fromTitle' => ($key == 0 ? $emailEventProvider['name'][1] : $emailEventProvider['name'][0]),
                            'cc' => ($key == 0 ? true : false),
                            'subject' => ($key == 0 ? $emailEventProvider['subject'][0] : $emailEventProvider['subject'][1]),
                            'itineraryRef' => $itineraryRef,
                            'attach' => true,
                            'location' => (!empty($emailEventProvider['location']) ? $emailEventProvider['location'] : ''),
                            'fileName' => (!empty($emailEventProvider['fileName']) ? $emailEventProvider['fileName'] : ''),
                            'data' => [
                                'paymentProvider' => (!empty($emailEventProvider['orderProvider']) ? $emailEventProvider['orderProvider'][0] : ''),
                                'orderProvider' => (!empty($emailEventProvider['orderProvider']) ? $emailEventProvider['orderProvider'][1] : ''),
                                'flightItineraryInfo' => (!empty($emailEventProvider['flightItineraryInfo']) ? $emailEventProvider['flightItineraryInfo'] : ''),
                                'title' => $emailEventProvider['title'],
                                'body' => ($key == 0 ? $emailEventProvider['body'][0] : $emailEventProvider['body'][1]),
                                'email' => $to,
                                'phoneNumber' => ($key == 0 ? $emailEventProvider['phoneNumber'][0] : $emailEventProvider['phoneNumber'][1])
                            ],
                        ]);
                    endforeach;
                endif;
            } catch (Exception $e) {
                \Log::info('Technical issue occurred,Your are not able to sent email successfuly! .' . $e->getMessage());
            }
        } catch (\Exception $e) {
            \Log::info('Technical issue occurred,Your are not able to pdf file!.' . $e->getMessage());
        }
    }

}
