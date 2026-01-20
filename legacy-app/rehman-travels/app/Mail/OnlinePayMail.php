<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Mail;

class OnlinePayMail extends Mailable
{
    use Queueable, SerializesModels;

    public $data = array();
    public $itineraryRef;
    public $location;
    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($data)
    {
        $this->data = $data;
        try {
            Mail::send('emails.'.$this->data['view'],$this->data['data'], function($message) {
                $message->to($this->data['to'],$this->data['toTitle']);
                $message->from($this->data['from'],$this->data['fromTitle']);
                $message->subject($this->data['subject'].' '. $this->itineraryRef);
                $message->cc(env('MAIL_CC_ADDRESS'),env('MAIL_CC_TTILE'));
                $message->bcc(env('MAIL_BC_ADDRESS'),env('MAIL_BC_TTILE'));
                $message->bcc('info@rehmantravel.com','Rehman Travel');
                $message->bcc('rt.webmaster15@gmail.com','Hamza Shah');
            });
        } catch (Exception $e) {
            \Log::error('Your Notify Mail has not been sent successfully!, Please try again!.'.$e->getMessage());
        }
    }
    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {

    }
}
