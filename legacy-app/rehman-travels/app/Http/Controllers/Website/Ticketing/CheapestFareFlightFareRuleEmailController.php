<?php

namespace App\Http\Controllers\Website\Ticketing;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Mail;
use PDF;

class CheapestFareFlightFareRuleEmailController extends Controller {

    public function cheapestFareFlightFareRuleSendPdf(Request $request) {
        try {
            $cheapestFlightFareRule = $request['cheapestFlightFareRule'];
            if(empty($cheapestFlightFareRule['email'])):
                return response()->json([
                    "errorType" => true,
                    "error" => "email address is empty.Please try again"
                ]);
            elseif (!preg_match("/^([a-z0-9\+_\-]+)(\.[a-z0-9\+_\-]+)*@([a-z0-9\-]+\.)+[a-z]{2,6}$/ix", $cheapestFlightFareRule['email'])):
                return response()->json([
                    "errorType" => true,
                    "error" => "invalid email.Please try again"
                ]);
            elseif(!array_key_exists('fareRules',$cheapestFlightFareRule)):
                return response()->json([
                    "errorType" => true,
                    "error" => "Fare Rules is empty.Please try again"
                ]);
            elseif(empty($cheapestFlightFareRule['fareRules'])):
                return response()->json([
                    "errorType" => true,
                    "error" => "Fare Rules is empty.Please try again"
                ]);
            else:
                $email = $cheapestFlightFareRule['email'];
                $tripTpye = $cheapestFlightFareRule['tripTpye'];
                $obd = $cheapestFlightFareRule['obd'];
                $ibd = $cheapestFlightFareRule['ibd'];
                $ol = $cheapestFlightFareRule['ol'];
                $dl = $cheapestFlightFareRule['dl'];
                $subject = $tripTpye.','.$ol.','.$dl.','.$obd.(!empty($ibd) ? $ibd : '');
                $fareRules = $cheapestFlightFareRule['fareRules'][0];
                $pdf = PDF::loadView('emails.Ticketing.TicketingFareRulePdfEmail', ['cheapestFlightFareRule' => $fareRules])->setPaper('a4');
                Mail::send('emails.Ticketing.TicketingFareRuleTextEmail',['cheapestFlightFareRule' => $fareRules], function($message) use ($email,$subject,$pdf) {
                    $message->to($email);
                    $message->from(env('MAIL_FROM_ADDRESS'), 'Help Desk(zamatrip.com)');
                    $message->cc(env('MAIL_CC_ADDRESS'), 'Help Desk(zamatrip.com)');
                    $message->subject('Flight Fare Rule Details: ' .$subject);
                    $message->attachData($pdf->output(),"$subject.pdf");
                });
                return response()->json([
                    'errorType' => false,
                    'message' => 'Your email has been sent successfully! Thank you'

                ]);
            endif;
        } catch (\Exception $e) {
            return response()->json([
                "errorType" => true,
                "error" => "Your email has not been sent successfully! Please try again"
            ]);
        }
    }

}
