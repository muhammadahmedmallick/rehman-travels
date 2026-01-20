<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Models\Site\ParentPage;
use App\Models\Branches\Branch;
use Inertia\Inertia;
use App\Models\Currency\Currency;
use App\Models\Permission\PermissionAssign;
use Illuminate\Support\Facades\Session;
use App\Libraries\visitor\VisitorProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        if(config('app.env') === 'production'):
            $this->app['request']->server->set('HTTPS', true); 
        endif;
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        if(config('app.env') === 'production'):
            $this->app['request']->server->set('HTTPS', true); 
        endif;
        
        Inertia::share([
            'menus'=> ParentPage::getContents(),
            'currencies'=> Currency::whereNotIn('currencyCode',['DEF'])->orderBy('id', 'asc')->get(),
            'footer' => Branch::getBranches(),
            'getNum' => VisitorProvider::visiter(),
            'permissions' => function () {
                if(!empty(Session::get('vendorId'))):
                    return PermissionAssign::loggedInUserPermission(Session::get('vendorId'),Session::get('agentId'),Session::get('userId'));
                endif;
            },
        ]);
    }
}
