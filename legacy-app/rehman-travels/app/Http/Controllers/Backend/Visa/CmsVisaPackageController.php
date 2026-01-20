<?php

namespace App\Http\Controllers\Backend\Visa;

use App\Http\Controllers\Controller;
use App\Services\Site\ContentPageService;
use App\Services\Visa\CmsVisaPackageService;
use App\Services\Visa\CmsVisaDurationService;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class CmsVisaPackageController extends Controller
{
    protected $contentPageService;
    protected $cmsVisaPackageService;
    protected $cmsVisaDurationService;
    public function __construct(ContentPageService $contentPageService, CmsVisaPackageService $cmsVisaPackageService, CmsVisaDurationService $cmsVisaDurationService)
    {
        $this->contentPageService = $contentPageService;
        $this->cmsVisaPackageService = $cmsVisaPackageService;
        $this->cmsVisaDurationService = $cmsVisaDurationService;
    }
    public function newVisaPackages(Request $request)
    {
        try{
            $visaPages = $this->contentPageService->where('parentId', 4);
            return Inertia::render('Backend/Visa/AddVisaPackages', ['visaPages' => $visaPages]);
        }catch(\Exception $ex){
            return back()->with(['errorType' => true, 'message' => $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }

    public function addVisaPackages(Request $request)
    {
        try
        {
            $visaPackages = $this->cmsVisaPackageService->store($request['formData']);
            if($visaPackages):
                foreach ($request['formData'] as $cmsVisaPackagesIndex => $cmsVisaPackages):
                    if ($cmsVisaPackagesIndex == 'visaPackages') :
                        foreach ($cmsVisaPackages as $cmsVisaPackage) :
                            $visaPackages->cmsvisaDurations()->create($cmsVisaPackage);
                        endforeach;
                    endif;
                endforeach;
                return Inertia::return('Backend/Visa/AllVisaPackages');
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! Visa Packages could Not created.']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    public function updateVisaPackages(Request $request)
    {
        try
        {
            $visaPackages = $this->cmsVisaPackageService->update($request['formData']['id'] , $request['formData']);
            foreach ($request['formData'] as $cmsVisaPackagesIndex => $cmsVisaPackages):
                if ($cmsVisaPackagesIndex == 'cmsvisa_durations') :
                    foreach ($cmsVisaPackages as $cmsVisaPackage) :
                        if(!empty($cmsVisaPackage['id'])){
                            $this->cmsVisaDurationService->update($cmsVisaPackage['id'] ,$cmsVisaPackage);
                        }else{
                            $visaPackages->cmsvisaDurations()->create($cmsVisaPackage);
                        }
                    endforeach;
                endif;
            endforeach;
            if($visaPackages):
                return back()->with(['errorType' => false, 'message' => 'Failed! Package Updated Successfully.']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! Package could Not Updated.']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }

    public function allVisaPackages()
    {
        try{
            $visaPackages = $this->cmsVisaPackageService->all(['*'], ['cmsvisaDurations']);
            $parentPages = $this->contentPageService->where('parentId', 4);
            // $packageArray = array();
            // foreach ($getAllVisaPackages as $mainKey => $getAllVisaPackage) {
            //     foreach ($getAllVisaPackage['cmsvisaDurations'] as $cmsvisaDurations) {
            //         $packageArray[$mainKey][] = array(
            //             'id' => $getAllVisaPackage['id'],
            //             'countryName' => $getAllVisaPackage['countryName'],
            //             'packageUrl' => $getAllVisaPackage['packageUrl'],
            //             'tourUrl' => $getAllVisaPackage['tourUrl'],
            //             'visaPackages' => $getAllVisaPackage['cmsvisaDurations']
            //         );
            //     }
            // }
            // dd($packageArray);
            if($visaPackages):
                return Inertia::render('Backend/Visa/AllVisaPackages', ['visaPackages' => $visaPackages, 'parentPages' => $parentPages]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! Package could Not Updated.']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }

    public function delete($id){
        try{
            $destroyVisaPackages = $this->cmsVisaPackageService->delete($id);
            if($destroyVisaPackages):
                return back()->with(['errorType' => false, 'message' => 'Package deleted Successfully.']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! Unable to deleted Package Successfully.']);
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
