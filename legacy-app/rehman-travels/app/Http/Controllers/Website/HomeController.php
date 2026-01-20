<?php

namespace App\Http\Controllers\Website;

use App\Helper\AdministravtiveSettingsHelper;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\Site\ContentPageService;
use Inertia\Inertia;
use App\Helper\ClientSystemInfoHelper;
use App\Services\CmsCallBack\CallbackQueriesService;
use App\Models\Profile\Agent;
use App\Events\RefreshAccessToken;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use App\Services\Customer\CustomerService;
use Carbon\Carbon;

class HomeController extends Controller
{
    protected $contentPageService;
    protected $callbackQueriesService;
    protected $customerService;
    public function __construct(CallbackQueriesService $callbackQueriesService, ContentPageService $contentPageService, CustomerService $customerService)
    {
        $this->contentPageService = $contentPageService;
        $this->callbackQueriesService = $callbackQueriesService;
        $this->customerService = $customerService;
    }
    public function index(Request $request)
    {
        $loggedIn = Agent::find(1182);
        event(new RefreshAccessToken($loggedIn));
        $result = $this->contentPageService->whereLimit('parentId', [2, 4, 11, 13], ['showOnHome' => 1, 'status' => 1]);
        $destinations = [];
        $airlineAndHotels = [];
        
        foreach ($result as $col) {
            $pageKey = self::__pages($col['parentId']);
        
            $row = [
                'id'            => $col['id'],
                'parentId'      => $col['parentId'],
                'packageTitle'  => $col['packageTitle'],
                'urlLink'       => $col['urlLink'],
                'cardImage'     => $col['cardImage'],
                'type'          => $col['type'] == 1 ? 'New' : '',
                'currencyType'  => $col['currencyType'],
                'currencyCode'  => $col['currencyCode'],
                'price'         => $col['price'],
            ];
        
            $isAirlineOrHotel = in_array($col['parentId'], [11, 13]);
            $isDestination = in_array($col['parentId'], [2, 4]);
            $hasPrice = $col['price'] > 0;
            if ($isAirlineOrHotel) {
                $airlineAndHotels[$pageKey][] = $row;
            }
            if ($hasPrice && $isDestination) {
                $destinations[$pageKey][] = $row;
            }
        }
        $headerArr = [
            'title' => 'Best Travel and Tour Agency in Islamabad,Pakistan',
            'metaTitle' => 'Best Travel and Tour Agency in Islamabad,Pakistan',
            'description' => 'Get Cheap Flights, Hotel Bookings, Domestic & International Tours, Umrah Packages, Visit Visa, Corporate Deals, Travel Insurance & Rent a Car. Amazing Flight Deals.',
            'og:url' => '',
            'og:image:secure_url' => 'assets/img/rgt-logo.png',
            'image' => 'assets/img/rgt-logo.png',
            'schemaVal' => '',
        ];
        view()->share('headerArr', $headerArr);
        return Inertia::render('Website/Home/Index', ['destinations' => $destinations,'airlineAndHotels' =>$airlineAndHotels]);
    }

    private static function __pages($page){
        $pages = ["Umrah"=> 2,"Visa"=> 4,"International Tour"=> 6,"Hotels"=>11,"Domestic Tour"=>12,"Airlines"=>13, "Hajj"=>14];
        return array_search($page,$pages);
    }

    public function sitemap(){
        $contentDetails = $this->contentPageService->whereCallBackRelation([['status', '=', '1']], ['parents'], 'parentId', 'ASC');
        $contents = array();
        foreach($contentDetails as $contentDetail){
            $contents[] = array(
                'urlLink' => 'https://www.rehmantravel.com/' . $contentDetail['urlLink'],
                'priority' => self::__parentPriority($contentDetail->parents['id']),
                'update_at' => ($contentDetail['updated_at'] !== null || !empty($contentDetail['updated_at']) ? Carbon::parse($contentDetail['updated_at'])->format('Y-m-d\TH:i:s+00:00') : Carbon::parse($contentDetail['created_at'])->format('Y-m-d\TH:i:s+00:00'))
            );
        }
        return response()->view('siteMap', compact('contents'))->header('Content-Type', 'text/xml');
    }

    private static function __parentPriority($page){
        $pagesPriorities = array('1'=> '1.00','2'=> '0.5','3'=> '0.9','4'=> '0.5','6'=> '0.5','7'=> '0.5','9'=> '0.5','10'=> '1.00',
        '11'=> '0.6','12'=> '0.7','13'=> '0.8','14'=> '0.5');
        foreach($pagesPriorities as $key => $pagesPriority){
            if($key == $page){
                return $pagesPriority;
            }
        }
    }

    public function whatsappLead(Request $request){
        try{
            $contents = $request['contents'];
            $leadFrom = ($contents['leadFrom'] != "" || $contents['leadFrom'] != null ? $contents['leadFrom'] : ClientSystemInfoHelper::getCurrentPage());
            $referalUrl = ClientSystemInfoHelper::getreferalUrl();
            $getreferalUrl = (isset($referalUrl) ? $referalUrl : 'https://www.rehmantravel.com/');
            $ip =  ClientSystemInfoHelper::get_ip();
            $get_browsers =  ClientSystemInfoHelper::get_browsers();
            $get_device =  ClientSystemInfoHelper::get_device();
            $get_os =  ClientSystemInfoHelper::get_os();
            $checkVisitiorCount = $this->callbackQueriesService->whereQuery([['clientIp', '=', $ip], ['leadFrom', '=', $leadFrom]]);
            $administrativeDetails = AdministravtiveSettingsHelper::__adminDetails($getreferalUrl);
            $administrativeDetails['mobileNo'] = (!empty($request['whatsapp']['code']) && $request['whatsapp']['code'] == 'GB' ? '+923348881248' : ($leadFrom == 'umrah visa' ? '+923315551662' : (strpos($leadFrom, 'us visit visa') !== false  || strpos($leadFrom, 'australia visit visa') !== false ? '+923330501135' : $administrativeDetails['mobileNo'])));
            if(count($checkVisitiorCount) > 20){
                return array(
                    'getreferalUrl' => '',
                    'phone' => '+923345550579',
                    'moduleId' => ($contents['moduleId'] ? $contents['moduleId'] : '1')
                );
            }else{
                $customer = (!empty($administrativeDetails['mobileNo']) ? $this->__checkCustomer($administrativeDetails) : '03348881248');
                $message = (!empty($contents['message']) ? 'Lead From '.$contents['message'] : $leadFrom).' and diverted to ' . ($leadFrom == 'umrah visa' ? '+923345550579' : $administrativeDetails['mobileNo']);
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
                    'moduleId' => (!empty($contents['moduleId']) ? $contents['moduleId'] : '1'),
                    'referalUrl' => $getreferalUrl,
                    'leadFrom' => ($leadFrom == "" ? 'Home' : $leadFrom)
                );
                $getResponse = $this->callbackQueriesService->store($clientData);
                if($getResponse){
                    $whatsapp = '';
                    if($contents['moduleId'] == '20'):
                        $whatsapp = 'https://api.whatsapp.com/send?phone='.$administrativeDetails['mobileNo'].'&&text=For%20Tour%20Guide%20and%20Booking%2c%20please%20provide%20the%20following%20info%3b%0A%0AYour%20Name%3a%0ANo%20of%20Persons%3a%0ATour%20Date%3a%0ATour%20Destination%3a%0ADeparture%20City%3a%0ATotal%20Days%3a%0A%0A%0A';
                        return Inertia::location($whatsapp);
                        // $whatsapp = array(
                        //     'getreferalUrl' => $getreferalUrl,
                        //     'phone' => 03315551662,
                        //     'moduleId' => 20
                        // );
                    else:
                        // $whatsapp = 'https://api.whatsapp.com/send?phone='.$administrativeDetails['mobileNo'].'&&text=Need%20some%20Help%20Regarding%20%20%20'.$getreferalUrl;
                        $whatsapp = array(
                            'getreferalUrl' => '',
                            'phone' => $administrativeDetails['mobileNo'],
                            'moduleId' => ($contents['moduleId'] ? $contents['moduleId'] : '1')
                        );
                    endif;
                        return $whatsapp;
                        // $whatsapp = 'https://api.whatsapp.com/send?phone='.$administrativeDetails['mobileNo'].'&&text=Need%20some%20Help%20Regarding%20%0A%0A'.$getreferalUrl;
                        // return Inertia::location($whatsapp);
                        // return back()->with(['errorType' => false, 'message' => 'Record Successfully Added.']);
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
    
    public function reportwhatsappLead(Request $request){
        try{
            $contents = $request;
            $leadFrom = ($contents['leadFrom'] != "" || $contents['leadFrom'] != null ? $contents['leadFrom'] : '');
            $getreferalUrl = (isset($contents['referalUrl']) ? $contents['referalUrl']: '');
            $administrativeDetails = AdministravtiveSettingsHelper::__adminDetails($getreferalUrl);
            $administrativeDetails['mobileNo'] = (!empty($request['whatsapp']['code']) && $request['whatsapp']['code'] == 'AE' ? '+923348881248' : ($leadFrom == 'umrah visa' ? '+923315551662' : (strpos($leadFrom, 'student study visa') !== false || strpos($leadFrom, 'us visit visa') !== false  || strpos($leadFrom, 'australia visit visa') !== false ? '+923330501135' : $administrativeDetails['mobileNo'])));
            if($administrativeDetails['mobileNo']){
                $whatsapp = '';
                if($contents['moduleId'] == '20'):
                    $whatsapp = 'https://api.whatsapp.com/send?phone=+923315551662&&text=For%20Tour%20Guide%20and%20Booking%2c%20please%20provide%20the%20following%20info%3b%0A%0AYour%20Name%3a%0ANo%20of%20Persons%3a%0ATour%20Date%3a%0ATour%20Destination%3a%0ADeparture%20City%3a%0ATotal%20Days%3a%0A%0A%0A';
                    return Inertia::location($whatsapp);
                    $whatsapp = array(
                        'message' => 'Name:' . $contents['firstName'] .' mobileNo:' . $contents['mobileNo'] . ' Lead:' . $contents['message'],
                        'phone' => 03315551662,
                        'moduleId' => 20
                    );
                else:
                    $whatsapp = array(
                        'message' => (isset($contents['message']) ? 'name:' . $contents['firstName'] .'%3b%0A%0AmobileNo:' . $contents['mobileNo'] . '%3b%0A%0ALead:' . $contents['message'] : ''),
                        'phone' => $administrativeDetails['mobileNo'],
                        'moduleId' => ($contents['moduleId'] ? $contents['moduleId'] : '1')
                    );
                endif;
                return $whatsapp;
            }else{
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to get Pakistan Tours From DataBase.']);
            }
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
        if(!empty($customers) || !is_null($customers)):
            $customer = (!empty($customers['id']) ? $customers['id'] : null);
        else:
            $customers = $this->customerService->store($customerInfo);
            $customer = $customers['id'];
        endif;
        return $customer;
    }
}
