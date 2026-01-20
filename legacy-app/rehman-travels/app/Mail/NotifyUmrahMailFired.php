<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Mail;

class NotifyUmrahMailFired extends Mailable
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
        $this->ubcRef = $this->data['ubcRef'];
        $this->location = $this->data['location'];
        $this->phoneNumber = $this->data['phoneNumber'];
        try {
            Mail::send('emails.Umrah.UmrahOrderCreate',$this->data['data'], function($message) {
                $message->to('umrah@rehmantravel.com', 'Umrah help desk');
                $message->from('khalidjavid@exalted.pk', 'umrah UBC');
                $message->bcc('khalidjavid@exalted.pk','umrah calculator developer');
                if($this->data['attach'] == true):
                    if(!empty($this->location) &&  File::isFile(storage_path("app/pdf/{$this->location}/{$this->ubcRef}.pdf")) == true):
                        $message->attach(storage_path("app/pdf/{$this->location}/{$this->ubcRef}.pdf"));
                    endif;
                endif;
                $message->subject('Umrah UBC contract By '. $this->phoneNumber);
            });
        } catch (Exception $e) {
            \Log::error('Your UBC has not been sent successfully!, Please try again!.'.$e->getMessage());
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
