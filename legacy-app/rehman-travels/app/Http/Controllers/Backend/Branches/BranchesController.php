<?php

namespace App\Http\Controllers\Backend\Branches;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\Branches\BranchService;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class BranchesController extends Controller
{
    protected $branchService;
    public function __construct(BranchService $branchService){
        $this->branchService = $branchService;
    }

    public function index(){
        try{
            $branches = $this->branchService->all(['*']);
            if($branches):
                return Inertia::render('Backend/Branches/AllBranchesDetail', ['branchDetails' => $branches]);
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
    public function storeBranch(Request $request){
        try{
            
            $branches = "";
            $branchData = $request['formData'];
            if($branchData['method'] == "PUT"):
                $branches =  $this->branchService->update($branchData['id'], $branchData);
            else:
               $branches = $this->branchService->store($branchData);
            endif;
            if($branches):
                return back()->with(['errorType' => false, 'message' => 'Branch Data Inserted Successfully.']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to add New Content']);
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
