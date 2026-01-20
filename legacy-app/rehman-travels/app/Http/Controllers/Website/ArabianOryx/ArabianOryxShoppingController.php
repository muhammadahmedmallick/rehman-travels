<?php

namespace App\Http\Controllers\Website\ArabianOryx;

use App\Helper\ClientSystemInfoHelper;
use App\Http\Controllers\Controller;
use App\Libraries\ArabianOryx\HotelLibrary;
use App\Services\CmsCallBack\CallbackQueriesService;
use App\Services\Customer\CustomerService;
use App\Services\Hotels\HotelMarkupServices;
use App\Services\Hotels\HotelShoppingInfoServices;
use Illuminate\Http\Request;
use App\Models\Profile\Agent;
use App\Events\RefreshAccessToken;
use App\Services\Site\ContentPageService;
use Inertia\Inertia;

class ArabianOryxShoppingController extends Controller
{
    protected $contentPageService;
    protected $markupServices;
    protected $callbackQueriesService;
    protected $customerService;
    protected $hotelShoppingInfoService;
    public function __construct(HotelMarkupServices $markupServices, ContentPageService $contentPageService, CallbackQueriesService $callbackQueriesService, CustomerService $customerService, HotelShoppingInfoServices $hotelShoppingInfoService){
        $this->callbackQueriesService = $callbackQueriesService;
        $this->customerService = $customerService;
        $this->hotelShoppingInfoService = $hotelShoppingInfoService;
        $this->markupServices = $markupServices;
        $this->contentPageService = $contentPageService;
    }
    public function index(Request $request){
        $req = $request->input();
        $customer = (!empty($req['pn']) ? $this->__checkCustomer($req['pn']) : 0);
        $getreferalUrl = ClientSystemInfoHelper::getreferalUrl();
        $ip =  ClientSystemInfoHelper::get_ip();
        $get_browsers =  ClientSystemInfoHelper::get_browsers();
        $get_device =  ClientSystemInfoHelper::get_device();
        $get_os =  ClientSystemInfoHelper::get_os();
        $message = "Destination Code: " . $req['des'] . ", Country Code: "  . $req['c'] . ", Rooms: " . $req['rm'] . ", CheckIn Date: " . $req['chi'] . ", CheckOut Date: " . $req['cho'] . ", Currency: " . 
        $req['ct'] . ", Nationality: " . $req['c'] . ", Adult: " . $req['ac'] . ", Child: " . $req['cc'];
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
            'priority_type' => 'Low',
            'uuid' => '',
            'moduleId' => '11',
            'referalUrl' => $getreferalUrl,
            'leadFrom' => (!empty(ClientSystemInfoHelper::getCurrentPage()) ? ClientSystemInfoHelper::getCurrentPage() : 'Home'),
            'lastAssign' => 0,
            'created_by' => 1
        );
        $this->callbackQueriesService->store($clientData);
        return Inertia::render('Website/Hotels/ArabianOryxShopping');
    }
    
    public function homePage(){
        $loggedIn = Agent::find(1182);
        event(new RefreshAccessToken($loggedIn));
        $result = $this->contentPageService->whereInWhereRelation('parentId', [2, 4, 6, 11, 12 ,13, 20], ['showOnHome' => 1, 'status' => 1], ['cmsVisaPackages']);
        $destinations = array();
        $airlineAndHotels = array();
        // foreach ($result as $col):
        //     $row =  [
        //         "id" => $col["id"],
        //         "parentId" => $col["parentId"],
        //         "packageTitle" => $col["packageTitle"],
        //         "urlLink" => $col["urlLink"],
        //         "cardImage"=> $col["cardImage"],
        //         "type"=> ($col["type"] == 1 ? 'New': ''),
        //         "currencyType"=> $col["currencyType"],
        //         "currencyCode"=> $col["currencyCode"],
        //         "price"=> $col["price"],
        //         "packagesPrice" => ($col["parentId"] == 4 ? $col->cmsVisaPackages[0]['cmsvisaDurations'][0]['visaPrice'] : ""),
        //         "packagesCurrencyType" => ($col["parentId"] == 4 ? $col->cmsVisaPackages[0]['cmsvisaDurations'][0]['currency'] : "")
        //     ];
        //     if($col["parentId"] == 11 || $col["parentId"] == 13 || $col["parentId"] == 20):
        //         $airlineAndHotels[self::__pages($col["parentId"])][] = $row;
        //     else:
        //         $destinations[self::__pages($col["parentId"])][] = $row;
        //     endif;
        // endforeach;
        $headerArr = [
            'title' => 'home',
            'metaTitle' => 'Cheap Flights - Visit Visa - Pakistan & World Tours - Umrah - Hajj',
            'description' => 'Get Cheap Flights, Hotel Bookings, Domestic & International Tours, Umrah Packages, Visit Visa, Corporate Deals, Travel Insurance & Rent a Car. Amazing Flight Deals.',
            'og:url' => 'https://www.rehmantravel.com/',
            'og:image:secure_url' => 'assets/img/rgt-logo.png',
            'image' => 'assets/img/rgt-logo.png',
            'image' => 'assets/img/rgt-logo.png',
            'Pagetype' => 'default'
        ];
        view()->share('headerArr', $headerArr);
        return Inertia::render('Website/Home/HotelIndex', ['destinations' => $destinations,'airlineAndHotels' => $airlineAndHotels]);
    }

    private static function __pages($page){
        $pages = array("Umrah"=> 2,"Visa"=> 4,"International Tour"=> 6,"Hotels"=>11,"Domestic Tour"=>12,"Airlines"=>13, "Routes"=>20);
        return array_search($page,$pages);
    }

    public function arabianOryxShopping(Request $req){
        $markup = $this->markupServices->whereQuery(['vendor' => 'Arabian Oryx', 'markup_status' => '1']);
        $hotelSearch = HotelLibrary::hotelSearch($req);
        if($hotelSearch['audit']['propertyCount'] > 0){
            $searchHotels = [];
            foreach($hotelSearch['hotels'] as $hotels){
                foreach($hotels as $hotel){
                    $searchHotels[] = [
                            'hotelInfos' =>  [
                                "name" => $hotel['hotelInfo']['name'],
                                "image" => $hotel['hotelInfo']['image'],
                                "description" => $hotel['hotelInfo']['description'],
                                "starRating" => $hotel['hotelInfo']['starRating'],
                                "lat" => $hotel['hotelInfo']['lat'],
                                "lon" => $hotel['hotelInfo']['lon'],
                                "add1" => $hotel['hotelInfo']['add1'],
                                "add2" => $hotel['hotelInfo']['add2'],
                                "city" => $hotel['hotelInfo']['city'],
                                "location" => $hotel['hotelInfo']['location'],
                                "hotelRemarks" => $hotel['hotelInfo']['hotelRemarks'],
                                "checkinInstruction" => $hotel['hotelInfo']['checkinInstruction'],
                                "checkOutInstruction" => $hotel['hotelInfo']['checkOutInstruction'],
                            ],
                            "rooms" => $hotel['rooms'],
                            "code" => $hotel['code'],
                            "name" => $hotel['name'],
                            "groupCode" => $hotel['groupCode'],
                            "supplierGroupCode" => $hotel['supplierGroupCode'],
                            "supplierShortCode" => $hotel['supplierShortCode'],
                            "minPrice" => (!empty($markup) ? self::__calculateMarkup($markup, $hotel['minPrice']) : $hotel['minPrice']),
                            "supplierMinPrice" => (!empty($markup) ? self::__calculateMarkup($markup, $hotel['supplierMinPrice']) : $hotel['supplierMinPrice']),
                            "supplierCurrency" => $hotel['supplierCurrency'],
                    ];
                }
            }
            return array(
                'error' => false,
                'hotels' => $searchHotels,
                'sessionId' => $hotelSearch['generalInfo']['sessionId']
            );
        }else{
            return array(
                'error' => true,
                'hotels' => '',
                'sessionId' => $hotelSearch['generalInfo']['sessionId']
            );
        }
    }

    public function __calculateMarkup($markups, $hotelAmount){
        $amount = 0;
        foreach($markups as $markup ){
            if($markup['markup_type'] == 'fixed'){
                $amount += $markup['converted_value'];
            }else{
                $amount +=  $hotelAmount * $markup['markup_value'] / 100;
            }
        }
        return $amount + $hotelAmount;
    }

    public function __checkCustomer($customerInfo)
    {
        $customerNum = $customerInfo;
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
                'firstName' => '',
                'mobileNo' => $customerNum,
                'email' => '',
            );
            $customers = $this->customerService->store($customerData);
            $customer = $customers['id'];
        endif;
        return $customer;
    }
}