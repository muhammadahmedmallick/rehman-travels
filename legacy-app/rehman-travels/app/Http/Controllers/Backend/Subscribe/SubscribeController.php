<?php

namespace App\Http\Controllers\Backend\Subscribe;

use App\Helper\ClientSystemInfoHelper;
use App\Http\Controllers\Controller;
use App\Services\Subscriber\SubscriberServices;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Inertia\Inertia;

class SubscribeController extends Controller
{
    protected $subscriberServices;

    public function __construct(SubscriberServices $subscriberServices)
    {
        $this->subscriberServices = $subscriberServices;
    }
    public function store(Request $request){
        try{
            $getSubscriberResponse = $this->subscriberServices->allOrderBy(['*'], [], 'created_at', 'desc');
            return Inertia::render('Backend/Subscribe/getSubscribers', ['getSubscriberResponse' => $getSubscriberResponse]);

        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
        
    }
}
