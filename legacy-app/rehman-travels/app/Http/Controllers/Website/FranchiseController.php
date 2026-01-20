<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use App\Services\Site\ContentPageService;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class FranchiseController extends Controller
{
    protected $contentPageService;
    public function __construct(ContentPageService $contentPageService)
    {
        $this->contentPageService = $contentPageService;
    }
    public function index(){
        try{
            $urlLink = request()->path();
            $franchisePackages = $this->contentPageService->fetch(['urlLink' => $urlLink]);
            if($franchisePackages):
                $headerArr = [
                    'title' => $franchisePackages['packageTitle'],
                    'metaTitle' => $franchisePackages['metaTitle'],
                    'description' => $franchisePackages['metaDescription'],
                    'og:url' => 'https://www.rehmantravel.com/'. $franchisePackages['urlLink'],
                    'og:image:secure_url' => 'assets/img/rgt-logo.png',
                    'image' => 'assets/img/rgt-logo.png',
                    'schemaVal' => $franchisePackages['schemaVal'],
                ];
                view()->share('headerArr', $headerArr);
                return Inertia::render('Website/Franchise/Franchise', ['franchisePackages' => $franchisePackages]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Load Hajj Packages']);
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