<?php

namespace App\Http\Controllers\Backend\ConcentForm;

use App\Http\Controllers\Controller;
use App\Services\CmsCallBack\CallbackQueriesService;
use Inertia\Inertia;

class ConcentFormController extends Controller
{
    protected $callbackQueriesService;
    public function __construct(CallbackQueriesService $callbackQueriesService){
        $this->callbackQueriesService = $callbackQueriesService;
    }
    public function index(){
        $callBackQueries = $this->callbackQueriesService->whereRelation([['moduleId' , '=' , 21]], ['customer', 'users']);
        return Inertia::render('Backend/ConcentForm/AllConcentForms', ['consentForm' => $callBackQueries]);
    }
}