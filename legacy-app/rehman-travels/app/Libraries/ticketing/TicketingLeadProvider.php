<?php

namespace App\Libraries\ticketing;
use App\Helper\ClientSystemInfoHelper;
use App\Models\Customers;
use App\Models\Queries\CmsCallbackQueries;
use GuzzleHttp\Client;
use Illuminate\Support\Facades\DB;

class TicketingLeadProvider {
    
    private static $vicidialApiUrl = "http://110.39.60.126:58479/vicidial/non_agent_api.php";

    public static function ticketingLeadFired($request) {
        if(!empty($request['pn'])):
          self::__save($request);
        endif;
    }
    
    private static function __save($request){
        try{
            $ignoreNum = ["03425332275", "923425332275", "+923425332275", "00923425332275", "03345555121", "923345555121", "+923345555121", "00923345555121", "03345169764", "923345169764", "+923345169764", "00923345169764",
            "03345164637", "923345164637", "+923345164637", "00923345164637", "03345550579", "923345550579", "+923345550579", "00923345550579"];
            $getreferalUrl = ClientSystemInfoHelper::getreferalUrl();
            $ip =  ClientSystemInfoHelper::get_ip();
            $get_browsers =  ClientSystemInfoHelper::get_browsers();
            $get_device =  ClientSystemInfoHelper::get_device();
            $get_os =  ClientSystemInfoHelper::get_os();
            $getCurrentPage = ClientSystemInfoHelper::getCurrentPage();
            $mobileNo = self::__diallingCode($request['pn']);
            $customerId = self::__checkCustomer($mobileNo);
            $duplicateQuery = CmsCallbackQueries::where([['customerId', '=', $customerId], [DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '=' , date('Y-m-d')]])->first();
            $sector = $request['ol'] . "," . $request['dl'];
            $leadFrom = ($getCurrentPage == "" ? 'Home' : ($getCurrentPage != "flights" ? $getCurrentPage : 'flights'));
            $message = $request['ft'] . " From:" . $request['ol'] . " To:" . $request['dl'] . " Dept Date:" . $request['obd'] . " Arr Date:" . $request['ibd'] . " Adult:" . $request['ac'] . " Child:" . $request['cc'] . ", Infant:" . $request['ic'];
            $queryString = "?source=test&user=Sys-Entry&pass=Rgt281338R&function=add_lead&phone_number={$mobileNo}&phone_code=1&list_id=500&first_name=&last_name={$request['dl']}&email=&address1={$sector}&Address2=Ticketing&address3=&city=&province=&security_phrase={$ip}&comments=".str_replace(' ','%20',$message);
            $curlResponse = (is_null($duplicateQuery) || empty($duplicateQuery) ? (!in_array($request['pn'], $ignoreNum) && $mobileNo[1] == 3 ? self::__doRequest($queryString) : "") : "");
            // $curlResponse = (is_null($duplicateQuery) || empty($duplicateQuery) ? (!in_array($request['pn'], $ignoreNum) && $mobileNo[1] == 3 ? "" : "") : "");
            $res = (!empty($curlResponse) ? explode("|", $curlResponse) : "");
            CmsCallbackQueries::create([
                'customerId' => $customerId,
                'clientIp' => $ip,
                'clientBrowser' => $get_browsers,
                'ismobile' => ($get_device != "Mobile" ? 2 : 1),
                'clientPlatform' => $get_browsers . ", " . $get_os . ", " . $get_device,
                'mobileInfo' => $get_device,
                'message' => (!empty($message) ? $message : ''),
                'sectors' => $sector,
                'domIntl' => $request['st'],
                'airlineCode' => '',
                'country' => '',
                'uuid' => (!empty($res) ? $res[2] : (!in_array($request['pn'], $ignoreNum) && $mobileNo[1] == 3 ? $duplicateQuery['uuid'] : 56)),
                'moduleId' => ($getCurrentPage == "" ? '1' : ($getCurrentPage != "flights" ? '13' : '3')),
                'referalUrl' => $getreferalUrl,
                'leadFrom' => $leadFrom
                ]);

        } catch (\Exception $e) {
          return $e->getMessage();
        }
    }

    private static function __checkCustomer($customerInfo){
        $customer = Customers::where(["mobileNo" => $customerInfo])->first();
        if(!empty($customer)): return (!empty($customer['id']) ? $customer['id'] : 0);
        else:
           $customer = Customers::create(["mobileNo" => $customerInfo]);
           return  $customer['id'];
        endif;
    }
    
    private static function __diallingCode($customerInfo){
        $customerInfo = ltrim($customerInfo , "0092");
        $customerInfo = ltrim($customerInfo , "92");
        $customerInfo = ltrim($customerInfo , "+92");
        $customerInfo = ltrim($customerInfo , "0");
        return ($customerInfo[0] == "3" ? "0" . $customerInfo : "+" . $customerInfo);
    }
    
    private static function __doRequest($queryString) {
        self::$vicidialApiUrl = self::$vicidialApiUrl."$queryString";
        $curl = curl_init();
        curl_setopt_array($curl, array(
        CURLOPT_URL => self::$vicidialApiUrl,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_MAXREDIRS => 1,
        CURLOPT_TIMEOUT => 1000,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'GET' )
        );
        $response = curl_exec($curl);
        curl_close($curl);
        return $response;
    }
}
