<?php

namespace App\Listeners;

use App\Events\OrderCreateEmail;
use PDF;
use Illuminate\Support\Facades\Storage;
use App\Mail\NotifyMail;
use App\Mail\NotifyMailFired;
use Illuminate\Support\Facades\View;

class OrderCreateEmailFired
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
     * @param \App\Events\OrderCreateEmail $orderCreateEmailEventProvider
     * @return void
     */
    public function handle(OrderCreateEmail $orderCreateEmailEventProvider)
    {
       try {
            $emailEventProvider = $orderCreateEmailEventProvider->orderCreateEmailEventProvider;
            $itineraryRef = $emailEventProvider['itineraryRef'];
                $pdf = PDF::loadView("emails.Ticketing.{$emailEventProvider['view']}", [
                    'orderRetrieveProvider' => $emailEventProvider['orderRetrieveProvider'],
                    'title' => '',
                    'body' => '',
                ]);
                Storage::put("pdf/{$emailEventProvider['location']}/{$itineraryRef}.pdf", $pdf->output());
              try {
                    if (!empty($emailEventProvider['to'])):
                        foreach ($emailEventProvider['to'] as $key => $to):
                            new NotifyMailFired([
                                'view' => "Ticketing.{$emailEventProvider['view']}",
                                'to' => $to,
                                'toTitle' => ($key == 0 ? $emailEventProvider['name'][0] : $emailEventProvider['name'][1]),
                                'from' => ($key == 0 ? $emailEventProvider['to'][1] : $emailEventProvider['to'][0]),
                                'fromTitle' => ($key == 0 ? $emailEventProvider['name'][1] : $emailEventProvider['name'][0]),
                                'cc' => ($key == 0 ? false : false),
                                'subject' => ($key == 0 ? $emailEventProvider['subject'][0] : $emailEventProvider['subject'][1]),
                                'itineraryRef' => $itineraryRef,
                                'attach' => true,
                                'location' => $emailEventProvider['location'],
                                'fileName' => $emailEventProvider['fileName'],
                                'data' => [
                                    'orderRetrieveProvider' => $emailEventProvider['orderRetrieveProvider'],
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
           \Log::info('Technical issue occurred,Your are not able to order create pdf file!.' . $e);
        }
    }

}
