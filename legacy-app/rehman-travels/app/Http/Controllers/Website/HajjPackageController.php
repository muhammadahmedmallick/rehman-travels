<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use App\Services\Site\ContentPageService;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class HajjPackageController extends Controller
{
    protected $contentPageService;
    public function __construct(ContentPageService $contentPageService)
    {
        $this->contentPageService = $contentPageService;
    }
    public function packagesTitle()
    {
        try{
            // return Inertia::location('/');
            $urlLink = request()->path();
            $hajjPackages = $this->contentPageService->fetch(['urlLink' => $urlLink]);
            if($hajjPackages):
                $headerArr = [
                    'title' => $hajjPackages['packageTitle'],
                    'metaTitle' => $hajjPackages['metaTitle'],
                    'description' => $hajjPackages['metaDescription'],
                    'og:url' => 'https://www.rehmantravel.com/'. $hajjPackages['urlLink'],
                    'og:image:secure_url' => 'assets/img/rgt-logo.png',
                    'image' => 'assets/img/rgt-logo.png',
                    'schemaVal' => $hajjPackages['schemaVal'],
                ];
                view()->share('headerArr', $headerArr);
                return Inertia::render('Website/Hajj/Hajj', ['hajjPackages' => $hajjPackages]);
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
