<?php

namespace App\Http\Controllers\Backend\Reports;

use App\Http\Controllers\Controller;
use App\Services\CmsCallBack\CallbackQueriesService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Support\Collection;
use Illuminate\Http\Request;
use App\Services\Site\ParentPageService;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
class ReportController extends Controller
{
    protected $callbackQueriesService;
    protected $parentPageService;
    public function __construct(ParentPageService $parentPageService, CallbackQueriesService $callbackQueriesService)
    {
        $this->callbackQueriesService = $callbackQueriesService;
        $this->parentPageService = $parentPageService;
    }
    public function index(Request $request)
    {
        $from = $request['from'];
        // $to = date('Y-m-d', strtotime($request['to'] . '+1 days'));
        $to = $request['to'];
        $moduleId = $request['moduleId'];
        try{
            $callBackQueries = [];
            $where = array();
            if(!empty($from) && !empty($to)){
                if(!is_null($moduleId) && !empty($moduleId)){
                    if($moduleId == 'gad_source=' || $moduleId == 'ft='){
                       $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' ,$from],[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '<=' ,$to], ['leadFrom', 'LIKE', '%'.$moduleId.'%']];
                    }else{
                        $where =  [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' ,$from],[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '<=' ,$to], ['moduleId', '=', $moduleId]];
                    }
                }else{
                    $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' ,$from],[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '<=' ,$to]];
                }
            }elseif(empty($from) && empty($to) && !empty($moduleId)){
                if($moduleId == 'gad_source=' || $moduleId == 'ft='){
                    $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' ,date('Y-m-d', strtotime(date('Y-m-d') . '-10 days'))], ['leadFrom', 'LIKE', '%'.$moduleId.'%']];
                }else{
                    $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' ,date('Y-m-d', strtotime(date('Y-m-d') . '-10 days'))], ['moduleId', '=', $moduleId]];
                }
            }else{
                $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' , date('Y-m-d')]];
            }
            //dd($where);
            $callBackQueries = $this->callbackQueriesService->whereCallBackRelation($where, ['customer'],'created_at', 'DESC');
            $modules = $this->parentPageService->all(['*']);
            $collection = new Collection();
            foreach ($callBackQueries as $getCallBackQueries):
                // $module = $this->getModule($getCallBackQueries['moduleId']);
                $collection->push((object)[
                        "id" => $getCallBackQueries->customer['id'],
                        "message" => $getCallBackQueries['message'],
                        "leadFrom" => $getCallBackQueries['leadFrom'],
                        "clientIp" => $getCallBackQueries['clientIp'],
                        "clientBrowser" => $getCallBackQueries['clientBrowser'],
                        "clientPlatform" => $getCallBackQueries['clientPlatform'],
                        "mobileInfo" => $getCallBackQueries['mobileInfo'],
                        "firstName" => $getCallBackQueries->customer['firstName'],
                        "mobileNo" => $getCallBackQueries->customer['mobileNo'],
                        "email" => $getCallBackQueries->customer['email'],
                        "moduleId" => self::getModule($getCallBackQueries['moduleId']),
                        "referalUrl" => $getCallBackQueries['referalUrl'],
                        "created_at" => date('h:i A | d-m-Y', strtotime($getCallBackQueries['created_at']))
                ]);
            endforeach;
            if($collection):
                return Inertia::render('Backend/Reports/AllQueries', ['callBackQueries' => $collection, 'modules' => $modules]);
            else:
                return back()->with(['errorType'=> true,'message'=> 'No Report Exists']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }

    public function getModule($moduleId){
        if($moduleId == 1):
            return "Home";
        elseif($moduleId == 2):
            return "Umrah";
        elseif($moduleId == 3):
            return "Flights";
        elseif($moduleId == 4):
            return "Visa";
        elseif($moduleId == 6):
            return "World Tours";
        elseif($moduleId == 7):
            return "Franchise";
        elseif($moduleId == 9):
            return "About Us";
        elseif($moduleId == 10):
            return "Contact Us";
        elseif($moduleId == 11):
            return "Hotels";
        elseif($moduleId == 12):
            return "Pakistan Tours";
        elseif($moduleId == 13):
            return "Airlines";
        elseif($moduleId == 14):
            return "Hajj";
        elseif($moduleId == 19):
            return "Whatsapp";
        elseif($moduleId == 21):
            return "Call Back Form";
        endif;
    }
}