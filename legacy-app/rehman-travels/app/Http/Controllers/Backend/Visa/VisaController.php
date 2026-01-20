<?php

namespace App\Http\Controllers\Backend\Visa;

use App\Services\Site\ContentPageService;
use App\Services\Site\ParentPageService;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class VisaController extends Controller
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
            $parentPages = $this->parentPageService->all(['id', 'title']);
            $visas = $this->contentPageService->whereWithRelation('parentId',4,['parentPages']);
            if($visas):
                return Inertia::render('Backend/Visa/AllVisaDetails', ['visas' => $visas, 'parentPages' => $parentPages]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! to load Visa Pages.']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }

    public function updateVisaPageContent(Request $request)
    {
        try
        {
            $categories = $request['formData']['categories'];
            if (!empty($request['formData']['card'])) {
                $cardImage = $request['formData']['card'];
                $getCardName = $cardImage->getClientOriginalName();
                $cardImage->storeAs($categories, $getCardName, 'public');
            }
            if(!empty($request['formData']['banner'])){
                $bannerImage = $request['formData']['banner'];
                $getBannerImage = $bannerImage->getClientOriginalName();
                $bannerImage->storeAs($categories, $getBannerImage, 'public');
            }
            $addNewContent = $this->contentPageService->update($request['formData']['id'] ,$request['formData']);
            if ($addNewContent){
                return back()->with(['errorType' => false, 'message' => 'Visa Page Content updated Successfully.']);
            } else {
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to update Visa Page Content.']);
            }
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
}
