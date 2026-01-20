<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class OrderRetrieveEmail
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $orderRetrieveEmailEventProvider;
    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($orderRetrieveEmailEventProvider)
    {
        $this->orderRetrieveEmailEventProvider = $orderRetrieveEmailEventProvider;
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
