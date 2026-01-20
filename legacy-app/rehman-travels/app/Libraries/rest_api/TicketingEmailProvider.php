<?php

namespace App\Libraries\rest_api;

use App\Events\OnlinePayEmail;
use Illuminate\Support\Facades\Mail;
use Request;
use App\Events\TicketingEmail;
use App\Events\OrderCreateEmail;
use App\Events\OrderRetrieveEmail;
use App\Events\UmrahOrderCreateEmail;
use App\Events\LeadEmail;

class TicketingEmailProvider {

    public static function send($ticketingEmailProvider) {
        try {
            event(new TicketingEmail($ticketingEmailProvider));
        } catch (\Exception $e) {
            return $e;
        }
    }

    public static function orderCreateMail($orderCreateEmailProvider) {
        try {
            event(new OrderCreateEmail($orderCreateEmailProvider));
        } catch (\Exception $e) {
            return $e;
        }
    }

    public static function orderRetrieveMail($orderRetrieveEmailProvider) {
        try {
            event(new OrderRetrieveEmail($orderRetrieveEmailProvider));
        } catch (\Exception $e) {
            return $e;
        }
    }

    public static function mail($onlinePayEmailProvider) {
        try {
            event(new OnlinePayEmail($onlinePayEmailProvider));
        } catch (\Exception $e) {
            return $e;
        }
    }
    
    public static function umrahOrderCreateMail($umrahOrderCreateEmail) {
       // try {;
            event(new UmrahOrderCreateEmail($umrahOrderCreateEmail));
       // } catch (\Exception $e) {
       //     return $e;
       // }
    }
    
    public static function lead($leadEmailProvider) {
        try {
            event(new LeadEmail($leadEmailProvider));
        } catch (\Exception $e) {
            return $e;
        }
    }

}
