<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class UmrahOrderCreateEmail
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $umrahOrderCreateEmailEventProvider;
    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($umrahOrderCreateEmailEventProvider)
    {
        $this->umrahOrderCreateEmailEventProvider = $umrahOrderCreateEmailEventProvider;
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