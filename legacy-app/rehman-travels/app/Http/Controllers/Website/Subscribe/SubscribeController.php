<?php

namespace App\Http\Controllers\Website\Subscribe;

use App\Helper\ClientSystemInfoHelper;
use App\Http\Controllers\Controller;
use App\Services\Subscriber\SubscriberServices;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;

class SubscribeController extends Controller
{
    protected $subscriberServices;

    public function __construct(SubscriberServices $subscriberServices)
    {
        $this->subscriberServices = $subscriberServices;
    }
    public function store(Request $request){
        try{
            $getreferalUrl = ClientSystemInfoHelper::getreferalUrl();
            $ip =  ClientSystemInfoHelper::get_ip();
            $get_browsers =  ClientSystemInfoHelper::get_browsers();
            $get_device =  ClientSystemInfoHelper::get_device();
            $get_os =  ClientSystemInfoHelper::get_os();
            $checkIp = $this->subscriberServices->single(['clientIp' => $ip]);
            if($checkIp){
                return back()->with(['errorType' => false, 'message' => 'Record Successfully Added.']);
            }else{
                $clientData = array(
                    'email' => $request['contents'],
                    'clientIp' => $ip,
                    'clientBrowser' => $get_browsers,
                    'clientPlatform' => $get_browsers . ", " . $get_os . ", " . $get_device,
                    'ismobile' => ($get_device != "Mobile" ? 2 : 1),
                    'mobileInfo' => $get_device,
                    'referalUrl' => $getreferalUrl,
                    'leadFrom' => (!empty(ClientSystemInfoHelper::getCurrentPage()) ? ClientSystemInfoHelper::getCurrentPage() : 'Home'),
                );
                $getResponse = $this->subscriberServices->store($clientData);
            }
            return back()->with(['errorType' => false, 'message' => 'Record Successfully Added.']);
            // if($getResponse){
            // }else{
                // return back()->with(['errorType' => true, 'message' => 'Failed! unable to get Pakistan Tours From DataBase.']);
            // }
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
        
    }
}
