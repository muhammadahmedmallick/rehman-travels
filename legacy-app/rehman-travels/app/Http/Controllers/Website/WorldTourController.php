<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\Site\ContentPageService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Inertia\Inertia;

class WorldTourController extends Controller
{

    protected $contentPageService;
    public function __construct(ContentPageService $contentPageService)
    {
        $this->contentPageService = $contentPageService;
    }
    public function packagesTitle()
    {
        // Get the current URL including the query string.
        try{
            $getUrl = request()->path();
            $worldTour = $this->contentPageService->fetch(['urlLink' => $getUrl]);
            if($worldTour):
                $headerArr = [
                    'title' => $worldTour['packageTitle'],
                    'metaTitle' => $worldTour['metaTitle'],
                    'description' => $worldTour['metaDescription'],
                    'og:url' => 'https://www.rehmantravel.com/'. $worldTour['urlLink'],
                    'og:image:secure_url' => 'assets/img/rgt-logo.png',
                    'image' => 'assets/img/rgt-logo.png',
                    'schemaVal' => $worldTour['schemaVal'],
                ];
                view()->share('headerArr', $headerArr);
                return Inertia::render('Website/Tours/World/WorldTourDetailPage', ['worldTour' => $worldTour]);
            else:
                return back()->with(['errorType' => true, 'message' => 'No Data found Against the search.']);
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
