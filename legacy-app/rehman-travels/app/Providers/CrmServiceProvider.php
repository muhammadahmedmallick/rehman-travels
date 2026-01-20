<?php

namespace App\Providers;

use App\Interfaces\BaseInterface;
use App\Services\BaseService;
use App\Interfaces\Crm\UserInterface;
use App\Services\Crm\UserService;
use App\Interfaces\Crm\CurrencyInterface;
use App\Services\Crm\CustomerService;
use App\Interfaces\Crm\QueryRecordingFollowupInterface;
use App\Services\Crm\QueryRecordingFollowupService;
use Illuminate\Support\ServiceProvider;


class CrmServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void {
        $this->app->bind(BaseInterface::class,BaseService::class);
        $this->app->bind(UserInterface::class,UserService::class);
        $this->app->bind(CurrencyInterface::class,CustomerService::class);
        $this->app->bind(QueryInterface::class,QueryService::class);
        $this->app->bind(QueryRecordingFollowupInterface::class,QueryRecordingFollowupService::class);

    }

    /**
     * Bootstrap services.
     */
    public function boot(): void{
        //
    }
}
