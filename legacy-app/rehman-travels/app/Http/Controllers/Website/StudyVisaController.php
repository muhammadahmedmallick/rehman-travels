<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\CmsCallBack\StudyabroadCallbackService;
use App\Services\Customer\CustomerService;
use App\Helper\ClientSystemInfoHelper;

class StudyVisaController extends Controller
{
    protected $callbackQueriesService;
    protected $customerService;
    protected $studyabroadCallbackService;
    public function __construct(CustomerService $customerService, StudyabroadCallbackService $studyabroadCallbackService){
        $this->customerService = $customerService;
        $this->studyabroadCallbackService = $studyabroadCallbackService;
    }
    public function index(Request $request){
        $ip =  ClientSystemInfoHelper::get_ip();
        $currentPage =  ClientSystemInfoHelper::getCurrentPage();
        $checkVisitiorCount = $this->studyabroadCallbackService->whereQuery([['clientIp', '=', $ip], ['leadFrom', '=', $currentPage]]);
        if(count($checkVisitiorCount) > 3){
            // dd(count($checkVisitiorCount));
            return redirect('/Website/thankYou');
        }else{
            $customer = (!empty($request['customers']['mobileNo']) ? $this->__checkCustomer($request['customers']) : 0);
            $clientData = array(
                'customerId' => $customer,
                'city' => $request['studyAbroad']['city'],
                'degree' => $request['studyAbroad']['degree'],
                'gradutaionYear' => $request['studyAbroad']['gradutaionYear'],
                'grade' => $request['studyAbroad']['grade'],
                'isIelts' => $request['studyAbroad']['isIelts'],
                'income' => $request['studyAbroad']['income'],
                'accBalance' => $request['studyAbroad']['accBalance'],
                'university' => $request['studyAbroad']['university'],
                'clientIp' => $ip,
                'leadFrom' => $currentPage,
                'interest' => $request['studyAbroad']['interest'],
                'message' => $request['studyAbroad']['message'],
            );
            $getResponse = $this->studyabroadCallbackService->store($clientData);
            if($getResponse){
                return back()->with(['errorType' => false, 'message' => 'Record Successfully Added.']);
            }else{
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to get Pakistan Tours From DataBase.']);
            }
        }
    }

    public function __checkCustomer($customerInfo)
    {
        $customerNum = $customerInfo['mobileNo'];
        $customerNum = ltrim($customerNum , "0092");
        $customerNum = ltrim($customerNum , "92");
        $customerNum = ltrim($customerNum , "+92");
        $customerNum = ltrim($customerNum , "0");
        if($customerNum){
            if($customerNum[0] == "3"){
                $customerNum = "0" . $customerNum;
            }else{
                $customerNum = "+" . $customerNum;
            }
        }
        $customers = $this->customerService->fetch(["mobileNo" => $customerNum]);
        $customer = "";
        if(!empty($customers)):
            $customer = (!empty($customers['id']) ? $customers['id'] : null);
        else:
            $customerData = array(
                'firstName' => $customerInfo['firstName'],
                'mobileNo' => $customerNum,
                'email' => $customerInfo['email'],
            );
            $customers = $this->customerService->store($customerData);
            $customer = $customers['id'];
        endif;
        return $customer;
    }
}
