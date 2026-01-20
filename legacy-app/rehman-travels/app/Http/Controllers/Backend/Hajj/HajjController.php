<?php

namespace App\Http\Controllers\Backend\Hajj;

use App\Http\Controllers\Controller;
use App\Services\Site\ContentPageService;
use App\Services\Site\ParentPageService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Inertia\Inertia;

class HajjController extends Controller
{
    protected $contentPageService;
    protected $parentPageService;
    public function __construct(ContentPageService $contentPageService,ParentPageService $parentPageService)
    {
        $this->contentPageService = $contentPageService;
        $this->parentPageService = $parentPageService;
    }
    public function index(Request $request){
        try{
            $parents = $this->parentPageService->all(['id', 'title']);
            $hajjPackages = $this->contentPageService->whereWithRelation('parentId',14,['parentPages']);
            if($hajjPackages):
                return Inertia::render('Backend/Hajj/Hajj', ['hajjPackages' => $hajjPackages, 'parents' => $parents]);
            else:
                return back()->with(['errorType'=> true,'message'=> 'No Data found Against the search.']);
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
