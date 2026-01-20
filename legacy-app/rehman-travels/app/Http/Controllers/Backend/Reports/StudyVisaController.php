<?php

namespace App\Http\Controllers\Backend\Reports;

use App\Http\Controllers\Controller;
use App\Services\CmsCallBack\StudyabroadCallbackService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Inertia\Inertia;

class StudyVisaController extends Controller
{
    protected $studyabroadCallbackService;

    public function __construct(StudyabroadCallbackService $studyabroadCallbackService)
    {
        $this->studyabroadCallbackService = $studyabroadCallbackService;
    }

    public function index(Request $request){
        $from = $request['from'];
        $to = $request['to'];
        try{
            $where = array();
            if(!empty($from) && !empty($to)){
                $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' ,$from],[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '<=' ,$to]];
            }else{
                $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' , date('Y-m-d')]];
            }
            $studyVisaReport = $this->studyabroadCallbackService->whereCallBackRelation($where, ['customers'],'created_at', 'DESC');
            return Inertia::render('Backend/Reports/StudyVisaReport', ['studyVisaReport' => $studyVisaReport]);
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
}
