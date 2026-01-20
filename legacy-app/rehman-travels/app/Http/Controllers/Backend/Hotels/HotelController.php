<?php

namespace App\Http\Controllers\Backend\Hotels;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use App\Services\Site\ParentPageService;
use App\Services\Site\ContentPageService;

class HotelController extends Controller
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
            $parents = $this->parentPageService->all(['id', 'title']);
            $hotels = $this->contentPageService->whereWithRelation('parentId',11,['parentPages']);
            if($hotels):
                return Inertia::render('Backend/Hotels/AllHotelDetails', ['hotels' => $hotels, 'parents' => $parents]);
            else:
                return back()->with(['errorType' => true, 'message'=> 'Failed! unable to Load Hotel Page.']);
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
