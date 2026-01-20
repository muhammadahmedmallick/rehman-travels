<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\Site\ContentPageService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Inertia\Inertia;

class FlightController extends Controller
{
    protected $contentPageService;
    public function __construct(ContentPageService $contentPageService)
    {
        $this->contentPageService = $contentPageService;
    }
    public function index(){
        try
        { 
            $flightDetails = $this->contentPageService->fetch(['urlLink' => 'flights']);
            $result = $this->contentPageService->whereLimit('parentId', [11, 13], ['showOnHome' => 1, 'status' => 1]);
            $airlineAndHotels = array();
            foreach ($result as $col):
               $row =  [
                    "id" => $col["id"],
                    "packageTitle" => $col["packageTitle"],
                    "urlLink" => $col["urlLink"],
                    "parentId" => $col["parentId"],
                ];
                $airlineAndHotels[self::__pages($col["parentId"])][] = $row;
            endforeach;
            $headerArr = [
                'title' => (!empty($flightDetails['metaTitle'] ) ? $flightDetails['metaTitle'] : 'Cheap Flights - Visit Visa - Pakistan & World Tours - Umrah'),
                'metaTitle' => (!empty($flightDetails['metaTitle'] ) ? $flightDetails['metaTitle'] : 'Cheap Flights - Visit Visa - Pakistan & World Tours - Umrah'),
                'description' => (!empty($flightDetails['metaDescription']) ? $flightDetails['metaDescription'] : 'Get Cheap Flights, Hotel Bookings, Domestic & International Tours, Umrah Packages, Visit Visa, Corporate Deals, Travel Insurance & Rent a Car. Amazing Flight Deals.'),
                'og:url' => (!empty($flightDetails['urlLink']) ? 'https://www.rehmantravel.com/'.$flightDetails['urlLink'] : 'https://www.rehmantravel.com/flights'),
                'og:image:secure_url' => 'assets/img/rgt-logo.png',
                'image' => 'assets/img/rgt-logo.png',
                'schemaVal' => $flightDetails['schemaVal'],
            ];
            view()->share('headerArr', $headerArr);
            return Inertia::render('Website/Flight/Flight', ['flightDetails' => $flightDetails, 'airlineAndHotels' =>$airlineAndHotels]);
        }catch(\Exception $ex){
            return back()->with(['errorType' => true, 'message' => $ex->getMessage()]);
        }catch(\Throwable $ex){
            return back()->with(['errorType' => true, 'message' => $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType' => true, 'message' => $ex->getMessage()]);
        }
    }
    private static function __pages($page){
        $pages = array("Hotels"=>11, "Airlines"=>13);
        return array_search($page,$pages);
    }

    public function flightDetails(){
        try
        {
            $url = request()->path();
            $flightDetails = $this->contentPageService->fetch(['urlLink' => $url]);
            if($flightDetails):
                $headerArr = [
                    'title' => $flightDetails['packageTitle'] . " - Rehman Travel",
                    'metaTitle' => $flightDetails['metaTitle'],
                    'description' => $flightDetails['metaDescription'],
                    'og:url' => 'https://www.rehmantravel.com/'. $flightDetails['urlLink'],
                    'og:image:secure_url' => 'assets/img/rgt-logo.png',
                    'image' => 'assets/img/rgt-logo.png',
                    'schemaVal' => $flightDetails['schemaVal'],
                ];
                view()->share('headerArr', $headerArr);
                return Inertia::render('Website/Flight/FlightsPages', ['flightDetails' => $flightDetails]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Load Data, Please Check DB.']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType' => true, 'message' => $ex->getMessage()]);
        }catch(\Throwable $ex){
            return back()->with(['errorType' => true, 'message' => $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType' => true, 'message' => $ex->getMessage()]);
        }
    }
}
