<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use App\Services\CmsCallBack\VisitVisaCallbackService;
use App\Services\Customer\CustomerService;
use Illuminate\Http\Request;
use App\Helper\ClientSystemInfoHelper;
use Illuminate\Support\Facades\DB;

class VisitVisaController extends Controller
{
    protected $customerService;
    protected $visitVisaCallbackService;
    public function __construct(CustomerService $customerService, VisitVisaCallbackService $visitVisaCallbackService){
        $this->customerService = $customerService;
        $this->visitVisaCallbackService = $visitVisaCallbackService;
    }

    public function index(Request $request){
        $ip =  ClientSystemInfoHelper::get_ip();
        $currentPage =  ClientSystemInfoHelper::getCurrentPage();
        $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' , date('Y-m-d')], ['clientIp', '=', $ip], ['leadFrom', '=', $currentPage]];
        $checkVisitiorCount = $this->visitVisaCallbackService->whereQuery($where);
        if(count($checkVisitiorCount) > 3){
            return redirect('/Website/thankYou');
        }else{
            $customer = (!empty($request['customers']['mobileNo']) ? $this->__checkCustomer($request['customers']) : 0);
            if(isset($customer) && !empty($customer)){
                $clientData = array(
                    'customerId' => $customer,
                    'dob' => $request['visitVisa']['dob'],
                    'passportValidity' => $request['visitVisa']['passportValidity'],
                    'incomeSource' => $request['visitVisa']['incomeVerifiableSource'],
                    'incomeType' => $request['visitVisa']['incomeVerifiableSourceType']['type'],
                    'incomeAmount' => $request['visitVisa']['incomeVerifiableSourceType']['amount'],
                    'taxFiler' => $request['visitVisa']['taxFiler'],
                    'taxReturns' => $request['visitVisa']['taxReturns'],
                    'interest' => $request['visitVisa']['interest'],
                    'bankStatement' => $request['visitVisa']['bankStatement'],
                    'sufficientFunds' => $request['visitVisa']['sufficientFunds'],
                    'maritalStatus' => $request['visitVisa']['maritalStatus'],
                    'kids' => $request['visitVisa']['kids'],
                    'member' => $request['visitVisa']['member'],
                    'leadFrom' => $currentPage,
                    'education' => $request['visitVisa']['education'],
                    'purpose' => $request['visitVisa']['purpose'],
                    'travelHistory' => $request['visitVisa']['travelHistory'],
                    'travelledCountries' => $request['visitVisa']['travelledCountries'],
                    'clientIp' => $ip,
                );
                $getResponse = $this->visitVisaCallbackService->store($clientData);
                if($getResponse){
                    return back()->with(['errorType' => false, 'message' => 'Record Successfully Added.']);
                }else{
                    return back()->with(['errorType' => true, 'message' => 'Failed! unable to get Pakistan Tours From DataBase.']);
                }
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
