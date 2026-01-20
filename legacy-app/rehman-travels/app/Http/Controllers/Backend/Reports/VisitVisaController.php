<?php

namespace App\Http\Controllers\Backend\Reports;

use App\Http\Controllers\Controller;
use App\Services\CmsCallBack\VisitVisaCallbackService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class VisitVisaController extends Controller
{
    protected $visitVisaCallbackService;

    public function __construct(VisitVisaCallbackService $visitVisaCallbackService)
    {
        $this->visitVisaCallbackService = $visitVisaCallbackService;
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
            $visitVisaReport = $this->visitVisaCallbackService->whereCallBackRelation($where, ['customers'],'created_at', 'DESC');
            return Inertia::render('Backend/Reports/VisitVisaReport', ['visitVisaReport' => $visitVisaReport]);
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
}
