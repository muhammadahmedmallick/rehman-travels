<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class LeadEmail
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $leadEmailEventProvider;
    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($leadEmailEventProvider)
    {
        $this->leadEmailEventProvider = $leadEmailEventProvider;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return \Illuminate\Broadcasting\Channel|array
     */
    public function broadcastOn()
    {
        return [];
    }
}