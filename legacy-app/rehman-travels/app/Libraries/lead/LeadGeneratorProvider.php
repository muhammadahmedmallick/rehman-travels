<?php

namespace App\Libraries\lead;
use App\Helper\ClientSystemInfoHelper;
use App\Models\Customers;
use App\Models\Queries\CmsCallbackQueries;
use GuzzleHttp\Client;
use Illuminate\Support\Facades\DB;
use App\Libraries\rest_api\TicketingEmailProvider;

class LeadGeneratorProvider {
    
    private static $vicidialApiUrl = "http://110.39.60.126:58479/vicidial/non_agent_api.php";

    public static function LeadGenerator($request) {
        if(!empty($request['pn'])):
          self::__save($request);
        endif;
    }
    
    private static function __save($request){
        try{
            $ignoreNumArrSets = ["03330597128", "03425332275", "923425332275", "+923425332275", "00923425332275", "03345555121", "923345555121", "+923345555121", "00923345555121", "03345169764", "923345169764", "+923345169764", "00923345169764",
            "03345164637", "923345164637", "+923345164637", "00923345164637", "03345550579", "923345550579", "+923345550579", "00923345550579", "03111786785", "923111786785", "+923111786785", "00923111786785"];
            $getreferalUrl = ClientSystemInfoHelper::getreferalUrl();
            $ip =  ClientSystemInfoHelper::get_ip();
            $get_browsers =  ClientSystemInfoHelper::get_browsers();
            $get_device =  ClientSystemInfoHelper::get_device();
            $get_os =  ClientSystemInfoHelper::get_os();
            $getCurrentPage = ClientSystemInfoHelper::getCurrentPage();
            $mobileNo = self::__diallingCode($request['pn']);
            $customerId = self::__checkCustomer($mobileNo);
            $duplicateQuery = CmsCallbackQueries::where([['customerId', '=', $customerId], [DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '=' , date('Y-m-d')]])->first();
            $duplicatCustomer = Customers::where([['mobileNo', '=', $mobileNo], [DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '=' , date('Y-m-d')]])->first();
            $sector = $request['ol'] . "," . $request['dl'];
            $leadFrom = ($getCurrentPage == "" ? 'Home' : ($getCurrentPage != "flights" ? $getCurrentPage : 'flights'));
            $message = $request['ft'] . " From:" . $request['ol'] . " To:" . $request['dl'] . " Dept Date:" . $request['obd'] . " Arr Date:" . $request['ibd'] . " Adult:" . $request['ac'] . " Child:" . $request['cc'] . ", Infant:" . $request['ic'];
            $queryString = "?source=test&user=Sys-Entry&pass=Rgt281338R&function=add_lead&phone_number={$mobileNo}&phone_code=1&list_id=500&first_name=&last_name={$request['dl']}&email=&address1={$sector}&Address2=Ticketing&address3=&city=&province=&security_phrase={$ip}&comments=".str_replace(' ','%20',$message);
            $curlResponse = (is_null($duplicatCustomer) && (is_null($duplicateQuery) || empty($duplicateQuery)) ? (!in_array($request['pn'], $ignoreNumArrSets) && $mobileNo[1] == 3 ? self::__doRequest($queryString) : "") : "");
            $email = (is_null($duplicateQuery) || empty($duplicateQuery) ? ($mobileNo[1] != 3 ? self::__doEmailRequest($request) : "") : "");
            //$email = self::__doEmailRequest($request);
            \Log::info('Email Response:', ['Response' => $email, 'num' => $mobileNo]);
            // $curlResponse = (!is_null($duplicateQuery) || !empty($duplicateQuery) ? "" : (!in_array($request['pn'], $ignoreNumArrSets) && $mobileNo[1] == 3 ? "" : ""));
            // $res = ($curlResponse != "" ? explode("|", $curlResponse) : "");
            $result = CmsCallbackQueries::create([
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
                'uuid' => 56,
                'moduleId' => ($getCurrentPage == "" ? 1 : ($getCurrentPage != "flights" ? 13 : 3)),
                'referalUrl' => $getreferalUrl,
                'leadFrom' => $leadFrom
            ]);
            \Log::info('Response From CRM:', ['Response' => $curlResponse, 'mobileNo' => $mobileNo, 'customerId' => $customerId, 'currentQuery' => $result['id']]);
        } catch (\Exception $e) {
          return $e->getMessage();
        }
    }

    private static function __checkCustomer($customerInfo){
        $customer = Customers::where(["mobileNo" => $customerInfo])->first();
        if(!empty($customer)): return (!empty($customer['id']) ? $customer['id'] : 0);
        else:
           $customer = Customers::create(["mobileNo" => $customerInfo]);
           return $customer['id'];
        endif;
    }
    
    private static function __diallingCode($customerInfo){
        $customerInfo = ltrim($customerInfo , "0092");
        $customerInfo = ltrim($customerInfo , "92");
        $customerInfo = ltrim($customerInfo , "+92");
        $customerInfo = ltrim($customerInfo , "0");
        return ($customerInfo[0] == "3" ? "0" . $customerInfo : "+" . $customerInfo);
    }
    
    private static function __doEmailRequest($request){
        try{
            if($request){
                TicketingEmailProvider::lead([
                    "to" => ['khalidjavid@exalted.pk'],
                    "unlink" => true,
                    "name" => [env('MAIL_FROM_TITLE'), ''],
                    "phoneNumber" => [$request['pn']],
                    "subject" => ['FLIGHTS Query from Rehman Group Of Travels -' . $request['pn']],
                    "body" => [
                        'request' =>$request
                    ],
                    'pdf' => false,
                    'fileName' => 'lead',
                    'location' => 'Ticketing',
                    'view' => 'TicketingLeadEmail'
                ]);
            }
        }catch(Exception $e){
            return response()->json([
                'message' => 'An unexpected error has occurred. Please try again',
                'errorType' => true
            ]);
        }
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
