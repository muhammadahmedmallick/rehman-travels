<?php

namespace App\Http\Controllers\Backend\Queries;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\CmsCallBack\CallbackQueriesService;
use App\Services\Customer\CustomerService;
use App\Helper\ClientSystemInfoHelper;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Support\Facades\Validator;
use Inertia\Inertia;

class CallBackQueryController extends Controller
{
    protected $callbackQueriesService;
    protected $customerService;
    public function __construct(CallbackQueriesService $callbackQueriesService, CustomerService $customerService){
        $this->callbackQueriesService = $callbackQueriesService;
        $this->customerService = $customerService;
    }

    public function addContactDetails(Request $request){
        try{
            $contents = $request['contents'];
            if($contents['leadFrom'] == "Franchise"){
                $message = "<b> Investment :</b> ".$contents['Investment'] . ", <b> City :</b> ".$contents['city'] . ", <b> Education :</b> ".$contents['education'] . ", <b> CNIC :</b> ".$contents['cnic'] . ", <b> Address :</b> ".$contents['address'] . ", <b> Message :</b> ".$contents['message'];
            }else{
                $message = $contents['message'];
            }
            $getreferalUrl = ClientSystemInfoHelper::getreferalUrl();
            $ip =  ClientSystemInfoHelper::get_ip();
            $get_browsers =  ClientSystemInfoHelper::get_browsers();
            $get_device =  ClientSystemInfoHelper::get_device();
            $get_os =  ClientSystemInfoHelper::get_os();
            $checkVisitiorCount = $this->callbackQueriesService->whereQuery([['clientIp', '=', $ip], ['moduleId', '=', $contents['moduleId']]]);
            if(count($checkVisitiorCount) > 3){
                return redirect('/Website/thankYou');
            }else{
                $customer = (!empty($request['customers']['mobileNo']) ? $this->__checkCustomer($request['customers']) : 0);
                $clientData = array(
                    'customerId' => $customer,
                    'clientIp' => $ip,
                    'clientBrowser' => $get_browsers,
                    'ismobile' => ($get_device != "Mobile" ? 2 : 1),
                    'clientPlatform' => $get_browsers . ", " . $get_os . ", " . $get_device,
                    'mobileInfo' => $get_device,
                    'message' => (!empty($message) ? $message : ''),
                    'sectors' => '',
                    'domIntl' => '',
                    'airlineCode' => '',
                    'country' => '',
                    'uuid' => '',
                    'moduleId' => ($contents['moduleId'] ? $contents['moduleId'] : '1'),
                    'referalUrl' => $getreferalUrl,
                    'leadFrom' => ($contents['leadFrom'] != "" || $contents['leadFrom'] != null ? $contents['leadFrom'] : ClientSystemInfoHelper::getCurrentPage())
                );
                $getResponse = $this->callbackQueriesService->store($clientData);
                if($getResponse){
                    return back()->with(['errorType' => false, 'message' => 'Record Successfully Added.']);
                }else{
                    return back()->with(['errorType' => true, 'message' => 'Failed! unable to get Pakistan Tours From DataBase.']);
                }
            }
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    public function getCallBackQueries(){
        try{
            $callBackQueries = $this->callbackQueriesService->all(['*'], ['customer']);
            if($callBackQueries):
                dd($callBackQueries);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to get callBack Queries From DataBase.']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
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
                $customerNum = "+92" . $customerNum;
            }else{
                $customerNum = "+" . $customerNum;
            }
        }

        $customers = $this->customerService->fetch(["mobileNo" => $customerNum]);
        $customer = "";
        if(!empty($customers)):
            $customerData = array(
                'firstName' => (!empty($customerInfo['firstName']) ? $customerInfo['firstName'] : $customers['firstName']),
                'mobileNo' => $customerNum,
                'email' => (!empty($customerInfo['email']) ? $customerInfo['email'] : $customers['email']),
                'address' => (!empty($customerInfo['address']) ? $customerInfo['address'] : $customers['address']),
            );
            $customers = $this->customerService->update($customers['id'], $customerData);
            $customer = (!empty($customers['id']) ? $customers['id'] : null);
        else:
            $customerData = array(
                'firstName' => $customerInfo['firstName'],
                'mobileNo' => $customerNum,
                'email' => $customerInfo['email'],
                'address' => (!empty($customerInfo['address']) ? $customerInfo['address'] : ''),
            );
            $customers = $this->customerService->store($customerData);
            $customer = $customers['id'];
        endif;
        return $customer;
    }

    public function __sendQuery(){
        $viciDial = "http://192.168.5.241/vicidial/non_agent_api.php?source=test&user=Sys-Entry&pass=Rgt281338R&function=add_lead&phone_number=03425332275&phone_code=1&list_id=500&first_name=Khalid&last_name=Jan&email=&comments=Lead%20Test%20Coment";
    }
    
    public function thankYou(){
        return Inertia::render('Website/ThankYou');
    }
}
