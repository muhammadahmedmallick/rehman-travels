<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use App\Services\Site\ContentPageService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Inertia\Inertia;

class StudyImmigrationController extends Controller
{
    protected $contentPageService;
    public function __construct(ContentPageService $contentPageService)
    {
        $this->contentPageService = $contentPageService;
    }
    public function packagesTitle()
    {
        $getUrl = request()->path();
        $immigrations = $this->contentPageService->fetch(['urlLink' => $getUrl]);
        if(!empty($immigrations)):
            $studyImmigration = array(
                'contentDetails' => [
                    'cardImage'=> ($immigrations['parentId'] === 21 ? 'Immigration/' : 'Study/'). $immigrations['cardImage'],
                    'packageTitle'=> $immigrations['packageTitle'],
                    'shortDescription'=> $immigrations['shortDescription'],
                    'description'=> $immigrations['description'],
                    ],
                'phoneNo' => (!empty($immigrations) && $immigrations['parentId'] == 21 ? '+923345555121' :  '+923355559354')
            );
            $headerArr = [
                    'title' => $immigrations['packageTitle'],
                    'metaTitle' => $immigrations['metaTitle'],
                    'description' => $immigrations['metaDescription'],
                    'og:url' => 'https://www.rehmantravel.com/'. $immigrations['urlLink'],
                    'og:image:secure_url' => 'assets/img/rgt-logo.png',
                    'image' => 'assets/img/rgt-logo.png',
                    'schemaVal' => $immigrations['schemaVal'],
                ];
                view()->share('headerArr', $headerArr);
            return Inertia::render('Website/StudyImmigration/StudyImmigrationsDetailPage', ['studyImmigration' => $studyImmigration]);
        else:
            return back()->with(['errorType' => true, 'message' => 'No Data found Against the search.']);
        endif;
        try{
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    public function immigrationListing(){
        dd('test');
    }
}
