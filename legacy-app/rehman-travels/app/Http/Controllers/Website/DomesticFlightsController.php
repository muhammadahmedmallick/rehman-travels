<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\Site\ContentPageService;
use Inertia\Inertia;

class DomesticFlightsController extends Controller
{
    protected $contentPageService;
    public function __construct(ContentPageService $contentPageService)
    {
        $this->contentPageService = $contentPageService;
    }
    public function index(){
        $urlLink = request()->path();
        $domesticFlights = $this->contentPageService->fetch(['urlLink' => $urlLink]);
        // dd($domesticFlights);
        if($domesticFlights):
            $headerArr = [
                'title' => $domesticFlights['packageTitle'],
                'metaTitle' => $domesticFlights['metaTitle'],
                'description' => $domesticFlights['metaDescription'],
                'og:url' => 'https://www.rehmantravel.com/'. $domesticFlights['urlLink'],
                'og:image:secure_url' => 'assets/img/rgt-logo.png',
                'image' => 'assets/img/rgt-logo.png',
                'schemaVal' => $domesticFlights['schemaVal'],
            ];
            view()->share('headerArr', $headerArr);
            return Inertia::render('Website/Flight/Domestic/DomesticFlights', ['flightDetails' => $domesticFlights]); //Website/Flight/Domestic/DomesticFlights
        else:
            return back()->with(['errorType' => true, 'message' => 'Failed! unable to Load Hajj Packages']);
        endif;
    }
}
