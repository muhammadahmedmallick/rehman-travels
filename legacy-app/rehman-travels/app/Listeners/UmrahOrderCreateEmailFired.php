<?php

namespace App\Listeners;

use App\Events\UmrahOrderCreateEmail;
use PDF;
use Illuminate\Support\Facades\Storage;
use App\Mail\NotifyMail;
use App\Mail\NotifyUmrahMailFired;
use Illuminate\Support\Facades\View;

class UmrahOrderCreateEmailFired
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
     * @param \App\Events\UmrahOrderCreateEmail $orderCreateEmailEventProvider
     * @return void
     */
    public function handle(UmrahOrderCreateEmail $umrahOrderCreateEmailEventProvider)
    {
       try {
            $emailEventProvider = $umrahOrderCreateEmailEventProvider->umrahOrderCreateEmailEventProvider;
              try {
                    if (!empty($emailEventProvider['to'])):
                        foreach ($emailEventProvider['to'] as $key => $to):
                            new NotifyUmrahMailFired([
                                'view' => "",
                                'to' => 'khalidjavid@exalted.pk',
                                'toTitle' => ($key == 0 ? $emailEventProvider['name'][0] : $emailEventProvider['name'][1]),
                                'from' => 'bdm@rehmantravel.com',
                                'fromTitle' => '',
                                'cc' => false,
                                'subject' => 'UBC Booking',
                                'ubcRef' =>  $emailEventProvider['ubcRef'],
                                'attach' => false,
                                'location' => $emailEventProvider['location'],
                                'fileName' => $emailEventProvider['fileName'],
                                'phoneNumber' => $emailEventProvider['phoneNumber'][0],
                                'data' => [
                                    'title' => 'Umrah UBC',
                                    'body' => $emailEventProvider['body']['packageHtml'],
                                ],
                            ]);
                        endforeach;
                    endif;
               } catch (Exception $e) {
                   \Log::info('Technical issue occurred,Your are not able to sent UBC successfuly ! .' . $e->getMessage());
               }
       } catch (\Exception $e) {
           \Log::info('Technical issue occurred,Your are not able to create pdf UBC!.' . $e);
        }
    }

}
