<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use App\Services\Site\ContentPageService;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class TravelAgencyController extends Controller
{
    protected $contentPageService;
    public function __construct(ContentPageService $contentPageService)
    {
        $this->contentPageService = $contentPageService;
    }
    public function index(){
        try{
            $urlLink = request()->path();
            $travelagency = $this->contentPageService->fetch(['urlLink' => $urlLink]);
            if($travelagency):
                $headerArr = [
                    'title' => $travelagency['packageTitle'],
                    'metaTitle' => $travelagency['metaTitle'],
                    'description' => $travelagency['metaDescription'],
                    'og:url' => 'https://www.rehmantravel.com/'. $travelagency['urlLink'],
                    'og:image:secure_url' => 'assets/img/rgt-logo.png',
                    'image' => 'assets/img/rgt-logo.png',
                    'schemaVal' => $travelagency['schemaVal'],
                ];
                view()->share('headerArr', $headerArr);
                return Inertia::render('Website/TravelAgency/TravelAgency', ['travelagency' => $travelagency]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Load Travel Agency']);
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