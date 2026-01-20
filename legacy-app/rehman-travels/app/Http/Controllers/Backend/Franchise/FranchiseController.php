<?php

namespace App\Http\Controllers\Backend\Franchise;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Services\Site\ContentPageService;
use App\Services\Site\ParentPageService;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class FranchiseController extends Controller
{
    protected $contentPageService;
    protected $parentPageService;
    public function __construct(ContentPageService $contentPageService, ParentPageService $parentPageService)
    {
        $this->contentPageService = $contentPageService;
        $this->parentPageService = $parentPageService;
    }
    public function index(){
        try{
            $parentPages = $this->parentPageService->all(['id', 'title']);
            $franchisePackages = $this->contentPageService->whereInRelation('parentId', [7,18], ['parentPages']);
            if($franchisePackages):
                return Inertia::render('Backend/Franchise/Franchise', ['franchisePackages' => $franchisePackages, 'parentPages' => $parentPages]);
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
