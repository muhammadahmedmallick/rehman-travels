<?php

namespace App\Http\Controllers\Backend\Pages\Airline;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\Site\ContentPageService;
use App\Services\Site\ParentPageService;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class AirlineController extends Controller
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
            $flightAirlines = $this->contentPageService->whereInRelation('parentId',[3, 13, 19, 20], ['parentPages']);
            $parentPages = $this->parentPageService->all(['id', 'title']);
            if($flightAirlines):
                return Inertia::render('Backend/Pages/Airline/AirlinesDetails', ['flightAirlines' => $flightAirlines, 'parentPages' => $parentPages]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable fetch flight/Airlines Data.']);
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
