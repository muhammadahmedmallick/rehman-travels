<?php

namespace App\Http\Controllers\Backend\Pages\Site;

use App\Http\Controllers\Controller;
use App\Services\Site\ParentPageService;
use Exception;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ParentController extends Controller
{
    protected $parentPageService;
    public function __construct(ParentPageService $parentPageService)
    {
        $this->parentPageService = $parentPageService;
    }
    public function index(Request $request){
        try{
            $allParents = $this->parentPageService->all(['title']);
            if($allParents):
                return Inertia::render('./Layouts/FrontHeaderLayout',['allParents' => $allParents]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to fetch Parent Pages']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }

    public function getParentById($id){
        $getParent = $this->parentPageService->find($id);
        return json_encode($getParent);
        // return back()->with([
        //     'data' => $getParent,
        // ]);
        // return Inertia::render($getParent);
    }
}
