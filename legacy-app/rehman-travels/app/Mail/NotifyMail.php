<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Mail;

class NotifyMail extends Mailable
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
        $this->itineraryRef = $this->data['itineraryRef'];
        $this->location = $this->data['location'];
        $this->fileName = $this->data['fileName'];
        try {
            Mail::send('emails.'.$this->data['view'],$this->data['data'], function($message) {
                $message->to($this->data['to'],$this->data['toTitle']);
                $message->from($this->data['from'],$this->data['fromTitle']);
                 $message->cc(env('MAIL_CC_ADDRESS'),env('MAIL_CC_TTILE'));
                if($this->data['cc'] == true):
                    $message->bcc(env('MAIL_BC_ADDRESS'),env('MAIL_BC_TTILE'));
                    $message->bcc('info@rehmantravel.com','Rehman Travel');
                    $message->bcc('rt.webmaster15@gmail.com','Hamza Shah');
                endif;
                if($this->data['attach'] == true):
                    if(!empty($this->location[0]) &&  File::isFile(storage_path("app/pdf/{$this->location[0]}/{$this->fileName[0]}-{$this->itineraryRef}.pdf")) == true):
                        $message->attach(storage_path("app/pdf/{$this->location[0]}/{$this->fileName[0]}-{$this->itineraryRef}.pdf"));
                    endif;
                    if(!empty($this->location[1]) && File::isFile(storage_path("app/pdf/{$this->location[1]}/{$this->fileName[1]}-{$this->itineraryRef}.pdf")) == true):
                        $message->attach(storage_path("app/pdf/{$this->location[1]}/{$this->fileName[1]}-{$this->itineraryRef}.pdf"));
                    endif;
                endif;
                $message->subject($this->data['subject'].' '. $this->itineraryRef);
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
