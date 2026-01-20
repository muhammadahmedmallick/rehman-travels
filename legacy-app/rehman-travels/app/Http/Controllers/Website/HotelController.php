<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\Site\ContentPageService;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class HotelController extends Controller
{
    protected $contentPageService;
    public function __construct(ContentPageService $contentPageService)
    {
        $this->contentPageService = $contentPageService;
    }

    public function hotelDetails(){
        try{
            $url = request()->path();
            $hotels = $this->contentPageService->fetch(['urlLink' => $url]);
            if($hotels):
                $headerArr = [
                    'title' => $hotels['packageTitle'],
                    'metaTitle' => $hotels['metaTitle'],
                    'description' => $hotels['metaDescription'],
                    'og:url' => 'https://www.rehmantravel.com/'. $hotels['urlLink'],
                    'schemaVal' => $hotels['schemaVal'],
                    'og:image:secure_url' => ($hotels['categories'] !== null && ($hotels['bannerImage'] !== null || !empty($hotels['bannerImage'])) ? ('assets/'. $hotels['categories'] .'/'. $hotels['bannerImage']) : 'assets/img/rgt-logo.png'),
                    'image' => ($hotels['categories'] !== null && ($hotels['bannerImage'] !== null || !empty($hotels['bannerImage']))  ? ('assets/'. $hotels['categories'] .'/'. $hotels['bannerImage']) : 'assets/img/rgt-logo.png'),
                ];
                view()->share('headerArr', $headerArr);
                return Inertia::render('Website/Hotels/HotelsDetailsPage', ['hotels' => $hotels]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Load Hotel Page']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
}
