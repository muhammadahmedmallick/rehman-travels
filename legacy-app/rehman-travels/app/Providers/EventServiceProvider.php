<?php

namespace App\Providers;

use App\Events\RefreshAccessToken;
use App\Events\StripePayEmail;
use App\Events\TicketingEmail;
use App\Events\FreshLeadGenerator;
use App\Listeners\RefreshAccessTokenFired;
use App\Listeners\FreshLeadGeneratorFired;
use App\Listeners\TicketingEmailFired;
use App\Listeners\StripePayEmailFired;
use Illuminate\Auth\Events\Registered;
use Illuminate\Auth\Listeners\SendEmailVerificationNotification;
use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Event;
use App\Events\OnlinePayEmail;
use App\Listeners\OnlinePayEmailFired;
use App\Events\OrderCreateEmail;
use App\Listeners\OrderCreateEmailFired;
use App\Events\OrderRetrieveEmail;
use App\Listeners\OrderRetrieveEmailFired;
use App\Events\UmrahOrderCreateEmail;
use App\Listeners\UmrahOrderCreateEmailFired;
use App\Events\LeadEmail;
use App\Listeners\LeadEmailFired;
use App\Events\AdvancedCalendarSearch;
use App\Listeners\AdvancedCalendarSearchFired;

class EventServiceProvider extends ServiceProvider
{
    /**
     * The event listener mappings for the application.
     *
     * @var array<class-string, array<int, class-string>>
     */
    protected $listen = [
        Registered::class => [
            SendEmailVerificationNotification::class,
        ],
        RefreshAccessToken::class =>[
            RefreshAccessTokenFired::class
        ],
        FreshLeadGenerator::class => [
            FreshLeadGeneratorFired::class
        ],
        TicketingEmail::class => [
            TicketingEmailFired::class
        ],
        StripePayEmail::class => [
            StripePayEmailFired::class
        ],
        OnlinePayEmail::class => [
            OnlinePayEmailFired::class
        ],
        OrderCreateEmail::class => [
            OrderCreateEmailFired::class
        ],
        OrderRetrieveEmail::class => [
            OrderRetrieveEmailFired::class
        ],
        UmrahOrderCreateEmail::class => [
            UmrahOrderCreateEmailFired::class
        ],
        LeadEmail::class => [
            LeadEmailFired::class
        ],
        AdvancedCalendarSearch::class => [
            AdvancedCalendarSearchFired::class
        ],
    ];

    /**
     * Register any events for your application.
     *
     * @return void
     */
    public function boot()
    {
        parent::boot();
    }
}
