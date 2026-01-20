<?php

namespace App\Http\Controllers\Backend\StudyImmigration;

use App\Http\Controllers\Controller;
use App\Services\Site\ContentPageService;
use App\Services\Site\ParentPageService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Inertia\Inertia;

class StudyImmigrationController extends Controller
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
            $studyImmigration = $this->contentPageService->whereInRelation('parentId', [21, 22], ['parentPages']);
            $parentPages = $this->parentPageService->all(['id', 'title']);
            return Inertia::render('Backend/StudyImmigration/StudyImmigrationsDetails', ['immigrations' => $studyImmigration, 'parentPages' => $parentPages]);
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
}