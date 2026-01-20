<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Mail;

class NotifyLeadMail extends Mailable
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
        $this->subject = $this->data['subject'];
        $this->location = $this->data['location'];
        try {
            Mail::send('emails.Ticketing.TicketingLeadEmail',$this->data['data'], function($message) {
                $message->to('bdm@rehmantravel.com', '');
                $message->from('khalidjavid@exalted.pk', 'help desk');
                $message->cc('khalidjavid@exalted.pk',env('MAIL_CC_TTILE'));
                if($this->data['attach'] == true):
                    if(!empty($this->location) &&  File::isFile(storage_path("app/pdf/{$this->location}/{$this->ubcRef}.pdf")) == true):
                        $message->attach(storage_path("app/pdf/{$this->location}/{$this->ubcRef}.pdf"));
                    endif;
                endif;
                $message->subject($this->data['subject']);
            });
            \Log::error('Your Lead has been sent successfully!.');
        } catch (Exception $e) {
            \Log::error('Your Lead has not been sent successfully!, Please try again!.'.$e->getMessage());
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
