<?php

namespace App\Http\Controllers\Backend\Tours\World;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\Site\ContentPageService;
use App\Services\Site\ParentPageService;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class WorldTourController extends Controller
{
    protected $parentPageService;
    protected $contentPageService;
    public function __construct(ParentPageService $parentPageService, ContentPageService $contentPageService)
    {
        $this->parentPageService = $parentPageService;
        $this->contentPageService = $contentPageService;
    }
    public function index(Request $request){
        try{
            $worldTours = $this->contentPageService->whereWithRelation('parentId',6,['parentPages']);
            $parentPages = $this->parentPageService->all(['id', 'title']);
            return Inertia::render('Backend/Tours/World/AllWorldTourDetails', ['worldTours' => $worldTours, 'parentPages' => $parentPages]);
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
}
