<?php

namespace App\Http\Controllers\Website\Ticketing;
use App\Events\FreshLeadGenerator;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Libraries\rest_api\AirTicketingMethodProvider;
use App\Libraries\rest_api\AllowOnlyValidInputProvider;
use App\Models\PremiumAirline\PremiumAirline;
use App\Events\RefreshAccessToken;
use App\Models\Profile\Agent;
use App\Services\Site\ContentPageService;

class FlightSearchController extends Controller
{
    protected $contentPageService;
    public function __construct(ContentPageService $contentPageService)
    {
        $this->contentPageService = $contentPageService;
    }

    public function cheapestFareFlight(Request $request){
        $allowOnlyValidInputProvider = AllowOnlyValidInputProvider::allowOnlyValidInput(AirTicketingMethodProvider::params($request->query(),'q'));
        if(!empty($allowOnlyValidInputProvider)):
            return Inertia::render('Website/Ticketing/AllowedOnlyValidInput',['errors' => $allowOnlyValidInputProvider]);
        else:
            event(new FreshLeadGenerator($request, ''));
            $premiumAirline = PremiumAirline::airlines();
            $headerArr = [
                'title' => 'Cheap Flights -  Online Discounted Air Tickets Booking in Pakistan',
                'metaTitle' => 'Cheap Flights -  Online Discounted Air Tickets Booking in Pakistan',
                'description' => 'Compare cheap flights and book online air tickets with Rehman Travels. Save big on flights deals with easy payment and Cancellation policy.',
                'og:url' => 'https://www.rehmantravel.com/',
                'og:image:secure_url' => 'assets/img/rgt-logo.png',
                'image' => 'assets/img/rgt-logo.png',
            ];
            view()->share('headerArr', $headerArr);
            return Inertia::render('Website/Ticketing/CheapestFareFlight',['providers' => (!empty($premiumAirline['title']) ? $premiumAirline['title'] : 'Sabre')]);
        endif;
    }
    public function dynamicSearchFlight(){
        $loggedIn = Agent::find(1182);
        event(new RefreshAccessToken($loggedIn));
        $premiumAirline = PremiumAirline::airlines();
        $urlPath = request()->path();
        $cc = explode('routes/', request()->path());
        $cc = explode('/', $cc[1]);
        if($cc[0]){
            $popularRoutes = $this->contentPageService->whereQuery(['departCode' => $cc[0], 'status' => 1]);
            $popularArrRoutes = $this->contentPageService->whereQuery(['departCode' => $cc[1], 'status' => 1]);
        }else{
            $popularRoutes = [];
            $popularArrRoutes = [];
        }
        $seoFlightPages = $this->contentPageService->fetch(['urlLink' => $urlPath]);
        if($seoFlightPages){
            $explodeCity = (!empty($popularRoutes) ? explode('to', strtolower($seoFlightPages["packageTitle"])) : '');
            $departCity = $explodeCity[0];
            $arrCity = $explodeCity[1];
            $result = $this->contentPageService->whereInWhereRelation('parentId', [3, 13, 20], ['showOnHome' => 1, 'status' => 1], ['cmsVisaPackages']);
            $flight = array();
            $airline = array();
            foreach ($result as $col):
                $row =  [
                    "id" => $col["id"],
                    "parentId" => $col["parentId"],
                    "packageTitle" => $col["packageTitle"],
                    "departCode" => $col["departCode"],
                    "arrCode" => $col["arrCode"],
                    "urlLink" => $col["urlLink"],
                    "cardImage"=> $col["cardImage"],
                    "type"=> ($col["type"] == 1 ? 'New': ''),
                    "currencyType"=> $col["currencyType"],
                    "currencyCode"=> $col["currencyCode"],
                    "price"=> $col["price"],
                    "packagesPrice" => ($col["parentId"] == 4 ? $col->cmsVisaPackages[0]['cmsvisaDurations'][0]['visaPrice'] : ""),
                    "packagesCurrencyType" => ($col["parentId"] == 4 ? $col->cmsVisaPackages[0]['cmsvisaDurations'][0]['currency'] : "")
                ];
                if($col["parentId"] == 13):
                    if(!empty($airline[self::__pages($col["parentId"])]) && count($airline[self::__pages($col["parentId"])]) > 11):
                        continue;
                    else:
                        $airline[self::__pages($col["parentId"])][] = $row;
                    endif;
                else:
                    if(!empty($flight[self::__pages($col["parentId"])]) && count($flight[self::__pages($col["parentId"])]) > 11):
                        continue;
                    else:
                        $flight[self::__pages($col["parentId"])][] = $row;
                    endif;
                endif;
            endforeach;
            $headerArr = [
                'title' => $seoFlightPages['packageTitle'],
                'metaTitle' => $seoFlightPages['metaTitle'],
                'description' => $seoFlightPages['metaDescription'],
                'og:url' => 'https://www.rehmantravel.com/'. $seoFlightPages['urlLink'],
                'og:image:secure_url' => 'assets/img/rgt-logo.png',
                'image' => 'assets/img/rgt-logo.png',
            ];
            view()->share('headerArr', $headerArr);
            return Inertia::render('Website/Ticketing/DynamicFlightSearch/DynamicFareFlight', ['providers' => (!empty($premiumAirline['title']) ? $premiumAirline['title'] : 'Sabre'), 'dynamicFlightPages' => $seoFlightPages, 'popularRoutes' => $popularRoutes, 'popularArrRoutes' => $popularArrRoutes, 'departCity' => $departCity, 'arrCity' => $arrCity, 'airline' => $airline, 'flight' => $flight]);
        }else{
            return redirect('/');
        }
    }
    private static function __pages($page){
        $pages = array("Flight"=> 3, "Airlines"=>13, "Routes" => 20);
        // dd(array_search($page,$pages));
        return array_search($page,$pages);
    }
}
