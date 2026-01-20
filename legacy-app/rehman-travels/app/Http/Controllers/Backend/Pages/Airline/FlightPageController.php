<?php

namespace App\Http\Controllers\Backend\Pages\Airline;

use App\Http\Controllers\Controller;
use App\Services\Site\ContentPageService;
use Inertia\Inertia;

class FlightPageController extends Controller
{
    private $contentPageService;
    
    public function __construct(ContentPageService $contentPageService){
        $this->contentPageService = $contentPageService;
    }
    public function index(){
        $flightDetails = $this->contentPageService->single(['urlLink' => '/flights']);
        return Inertia::render('Backend/Pages/Airline/FlightDetails', ['flightDetails' => $flightDetails]);
    }
}