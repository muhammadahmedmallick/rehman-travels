<?php

namespace App\Listeners;

use App\Events\OrderRetrieveEmail;
use PDF;
use Illuminate\Support\Facades\Storage;
use App\Mail\NotifyMailFired;

class OrderRetrieveEmailFired
{

    /**
     * Create the event listener.
     *
     * @return void
     */
    public function __construct()
    {

    }

    /**
     * Handle the event.
     *
     * @param \App\Events\OrderRetrieveEmail $orderRetrieveEmailEventProvider
     * @return void
     */
    public function handle(OrderRetrieveEmail $orderRetrieveEmailEventProvider)
    {
        try {
            $emailEventProvider = $orderRetrieveEmailEventProvider->orderRetrieveEmailEventProvider;
                $pdf = PDF::loadView("emails.Ticketing.{$emailEventProvider['view']}", [
                    'orderProvider' => $emailEventProvider['orderProvider'],
                    'optionProvider' => '',
                    'title' => '',
                    'body' => '',
                ]);
                Storage::put("pdf/{$emailEventProvider['location']}/{$emailEventProvider['itineraryRef']}.pdf", $pdf->output());
                try {
                    if (!empty($emailEventProvider['to'])):
                        foreach ($emailEventProvider['to'] as $key => $to):
                            new NotifyMailFired([
                                'view' => "Ticketing.{$emailEventProvider['view']}",
                                'to' => $to,
                                'toTitle' => ($key == 0 ? $emailEventProvider['name'][0] : $emailEventProvider['name'][1]),
                                'from' => ($key == 0 ? $emailEventProvider['to'][1] : $emailEventProvider['to'][0]),
                                'fromTitle' => ($key == 0 ? $emailEventProvider['name'][1] : $emailEventProvider['name'][0]),
                                'cc' => false,
                                'subject' => ($key == 0 ? $emailEventProvider['subject'][0] : $emailEventProvider['subject'][1]),
                                'itineraryRef' => $emailEventProvider['itineraryRef'],
                                'attach' => true,
                                'location' => $emailEventProvider['location'],
                                'data' => [
                                    'orderProvider' => '',
                                    'optionProvider' => $emailEventProvider['optionProvider'],
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
