<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class OnlinePayEmail
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $onlinePayEmailEventProvider;
    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($onlinePayEmailEventProvider)
    {
        $this->onlinePayEmailEventProvider = $onlinePayEmailEventProvider;
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
