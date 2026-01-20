<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\Site\ContentPageService;
use App\Services\Umrah\UmrahHotelService;
use App\Services\Umrah\UmrahTransportSectorService;
use App\Services\Umrah\UmrahHotelRoomPriceService;
use App\Services\Umrah\UmrahVehicleService;
use App\Services\Umrah\UmrahVisaService;
use App\Services\Umrah\UmrahVehiclePriceService;
use App\Services\Umrah\UmrahBookingCustomerService;
use App\Services\Umrah\UmrahBookingService;
use App\Services\Customer\CustomerService;
use App\Helper\UmrahHelper;
use Inertia\Inertia;
use Carbon\Carbon;
use Illuminate\Support\Facades\Mail;
use App\Mail\MyCustomEmail;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use App\Helper\ClientSystemInfoHelper;
use App\Services\CmsCallBack\CallbackQueriesService;
use Illuminate\Support\Str;
use App\Libraries\rest_api\TicketingEmailProvider;
use App\Models\Currency\Currency;
use App\Models\Umrah\UmrahTicketDetail;
use App\Services\Umrah\UmrahTicketDetailsService;
use Exception;

class UmrahController extends Controller
{
    protected $callbackQueriesService;
    protected $umrahHotelService;
    protected $contentPageService;
    protected $umrahTransportSectorService;
    protected $umrahVehicleService;
    protected $umrahHotelRoomPriceService;
    protected $umrahVisaService;
    protected $umrahVehiclePriceService;
    protected $customerService;
    protected $umrahBookingCustomerService;
    protected $umrahBookingService;
    public function __construct(CallbackQueriesService $callbackQueriesService, UmrahBookingService $umrahBookingService,UmrahBookingCustomerService $umrahBookingCustomerService,CustomerService $customerService, UmrahVehiclePriceService $umrahVehiclePriceService, UmrahVisaService $umrahVisaService, UmrahHotelRoomPriceService $umrahHotelRoomPriceService, UmrahVehicleService $umrahVehicleService, UmrahTransportSectorService $umrahTransportSectorService, ContentPageService $contentPageService, UmrahHotelService $umrahHotelService)
    {
        $this->contentPageService = $contentPageService;
        $this->umrahHotelService = $umrahHotelService;
        $this->umrahTransportSectorService = $umrahTransportSectorService;
        $this->umrahVehicleService = $umrahVehicleService;
        $this->umrahHotelRoomPriceService = $umrahHotelRoomPriceService;
        $this->umrahVisaService = $umrahVisaService;
        $this->umrahVehiclePriceService = $umrahVehiclePriceService;
        $this->customerService = $customerService;
        $this->umrahBookingCustomerService =$umrahBookingCustomerService;
        $this->umrahBookingService = $umrahBookingService;
        $this->callbackQueriesService = $callbackQueriesService;
    }   
    public function index()
    {
        try{
            $getallUmrah = $this->contentPageService->where('parentId', 2);
            if($getallUmrah):
                return Inertia::render('Website/Umrah/UmrahPackages', ['getallUmrah' => $getallUmrah]);
            else:
                return back()->with(['errorType' => false, 'message' => 'Failed! unable to delete Umrah Visa']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    
    public function packagesTitle(Request $req)
    {
        try{
            $getUrl = request()->path();
            if(!empty($getUrl) && $getUrl != "Umrhbookingdyn"):
                $umrahPackages = $this->contentPageService->fetch(['urlLink' => $getUrl]);
                // $umrahPackages = $this->contentPageService->fetch(['packageTitle' => str_replace("-"," ",$packagesTitle)]);
                $headerArr = [
                    'title' => $umrahPackages['packageTitle'],
                    'metaTitle' => $umrahPackages['metaTitle'],
                    'description' => $umrahPackages['metaDescription'],
                    'og:url' => 'https://www.rehmantravel.com/'. $umrahPackages['urlLink'],
                    'og:image:secure_url' => 'assets/img/rgt-logo.png',
                    'image' => 'assets/img/rgt-logo.png',
                    'schemaVal' => $umrahPackages['schemaVal'],
                ];
                view()->share('headerArr', $headerArr);
                return Inertia::render('Website/Umrah/UmrahDetailPage', ['umrahPackages' => $umrahPackages]);
            elseif($req && request()->method() == 'POST'):
                //return redirect('/');
                $packageHtml = $this->umrahBooking($req);
                $umrahPackages = $this->contentPageService->fetch(['urlLink' => $getUrl]);
                //dd(request()->method());
                $umrahHotelMakkah = $this->umrahHotelService->whereRelation(['hotelLocation' => 'Makkah', 'hotelStatus' => '1'], ['hotelRoomPeriods']);
                $umrahHotelMadinah = $this->umrahHotelService->whereRelation(['hotelLocation' => 'Madinah', 'hotelStatus' => '1'], ['hotelRoomPeriods']);
                $umrahTransportSectors = $this->umrahTransportSectorService->whereQuery(['sectorStatus' => '1']);
                $umrahVehicleServices = $this->umrahVehicleService->whereQuery(['vehicleStatus' => '1']);
                $headerArr = [
                    'title' => $umrahPackages['packageTitle'],
                    'metaTitle' => $umrahPackages['metaTitle'],
                    'description' => $umrahPackages['metaDescription'],
                    'og:url' => 'https://www.rehmantravel.com/'. $umrahPackages['urlLink'],
                    'og:image:secure_url' => 'assets/img/rgt-logo.png',
                    'image' => 'assets/img/rgt-logo.png',
                    'schemaVal' => $umrahPackages['schemaVal'],
                ];
                view()->share('headerArr', $headerArr);
                return Inertia::render('Website/Umrah/Umrhbookingdyn', ['packageHtml' => $packageHtml,'umrahPackages'=> $umrahPackages,'umrahVehicleServices' => $umrahVehicleServices, "umrahHotelMadinah" => $umrahHotelMadinah, 'umrahHotelMakkah' => $umrahHotelMakkah, 'umrahTransportSectors' => $umrahTransportSectors]);
            else:
                $umrahPackages = $this->contentPageService->fetch(['urlLink' => $getUrl]);
                $umrahHotelMakkah = $this->umrahHotelService->whereRelation(['hotelLocation' => 'Makkah', 'hotelStatus' => '1'], ['hotelRoomPeriods']);
                $umrahHotelMadinah = $this->umrahHotelService->whereRelation(['hotelLocation' => 'Madinah', 'hotelStatus' => '1'], ['hotelRoomPeriods']);
                $umrahTransportSectors = $this->umrahTransportSectorService->whereQuery(['sectorStatus' => '1']);
                $umrahVehicleServices = $this->umrahVehicleService->whereQuery(['vehicleStatus' => '1']);
                $headerArr = [
                    'title' => $umrahPackages['packageTitle'],
                    'metaTitle' => $umrahPackages['metaTitle'],
                    'description' => $umrahPackages['metaDescription'],
                    'og:url' => 'https://www.rehmantravel.com/'. $umrahPackages['urlLink'],
                    'og:image:secure_url' => 'assets/img/rgt-logo.png',
                    'image' => 'assets/img/rgt-logo.png',
                    'schemaVal' => $umrahPackages['schemaVal'],
                ];
                view()->share('headerArr', $headerArr);
                // return Inertia::render('Website/Umrah/UmrahDetailPage', ['umrahPackages' => $umrahPackages]);
                return Inertia::render('Website/Umrah/Umrhbookingdyn', ['umrahPackages'=> $umrahPackages,'umrahVehicleServices' => $umrahVehicleServices, "umrahHotelMadinah" => $umrahHotelMadinah, 'umrahHotelMakkah' => $umrahHotelMakkah, 'umrahTransportSectors' => $umrahTransportSectors]);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    
    public function hotelById(Request $req){
        $hotelDetails = $this->umrahHotelService->fetchWithRelation('id', $req[0], ['hotelRoomPeriods']);
        if(is_null($hotelDetails))  return [];
        $periods =[];
        $hotelRoomPeriods = $hotelDetails->hotelRoomPeriods()->where(['periodStatus' => '1'])->get();
        foreach ($hotelRoomPeriods as $hotelRoomPeriod):
            $hotelRoomPrices = [];
            foreach ($hotelRoomPeriod->hotelRoomPrices as $hotelRoomPrice):
                $hotelRoomPrices[] = [
                    'id' => $hotelRoomPrice['id'],
                    'roomType' => $hotelRoomPrice['roomType'],
                    'onDayMarkup' => $hotelRoomPrice['onDayMarkup'],
                    'offDayMarkup' => $hotelRoomPrice['offDayMarkup'],
                    ];
            endforeach;
            $periods[] = [
                'periodFrom' => $hotelRoomPeriod['periodFrom'],
                'periodTo' => $hotelRoomPeriod['periodTo'],
                "hotelRoomPrices" => $hotelRoomPrices
            ];
        endforeach;
        $collection = [
            "id" => $hotelDetails['id'],
            "hotelName" => $hotelDetails['hotelName'],
            'hotel_room_periods' => $periods
        ];
        return $collection;
    }
    
    public function umrahBooking(Request $req)
    {
        try
        {
            $customer = (!empty($req['customers']['mobileNo']) ? $this->__checkCustomer($req['customers']) : 0);
            $clientNumber =  (!empty($req['customers']['mobileNo']) ? self::convertNumber($req['customers']['mobileNo']) : '');
            $clientFirstName =  (!empty($req['customers']['firstName']) ? $req['customers']['firstName'] : '');
            $clientEmail =  (!empty($req['customers']['email']) ? $req['customers']['email'] : '');
            $adultFare = ($req['isFare'] && !empty($req['fares']['adultPrice']) ? $this->convertToSR($req['fares']['adultPrice'], $req['fares']['selectedCurrency']) : 0);
            $childFare = ($req['isFare'] && !empty($req['fares']['childPrice']) ? $this->convertToSR($req['fares']['childPrice'], $req['fares']['selectedCurrency']) : 0);
            $infantFare = ($req['isFare'] && !empty($req['fares']['infantPrice']) ? $this->convertToSR($req['fares']['infantPrice'], $req['fares']['selectedCurrency']) : 0);
            $grandPrice = 0;
            $grandPriceWithoutFare = 0;
            $grandNights = 0;
            $grandRooms = 0;
            $umrahBookingId = 0;
            $callBackQuery = [];
            $get_device =  ClientSystemInfoHelper::get_device();
            $secVehiclePrice = ($req['transport'] == true ? ($req['vehicle'] == 5 ? 50 : $this->__umrahVehiclePrice($req['vehicle'], $req['sector'])) : 0);
            $umrahVisa = ($req['umrahVisa'] == true ? $this->__checkUmrahVisa($req['nationality']) : 0);
            $umrahVisaInsurance = ($req['umrahVisa'] != true ? " Not Included " : " Included for " . $req['travellers']['totalTraveller'] .' '. ($req['travellers']['totalTraveller'] > 1 ? 'Persons' : 'Person'));
            $totalUmrahVisaPrice = ($umrahVisa > 0 ? $umrahVisa * $req['travellers']['totalTraveller'] : 0);
            $totalSecVehiclePrice = ($secVehiclePrice > 0 ? ($req['vehicle'] == 5 ? ($secVehiclePrice * ($req['travellers']['adultCount'] + $req['travellers']['childCount']))  : $secVehiclePrice) : 0);
            $whatsappQuery = '';
            $umrahPackage = array(
                "customerId" => $customer,
                "nationality" => $req['nationality'],
                "city" => ($req['city'] ? $req['city'] : '0'),
                "transport" => ($req['transport'] ? '1' : '0'),
                "umrahVisaPrice" => $totalUmrahVisaPrice,
                "umrahSectorId" => ( $req['transport'] ? $req['sector'] : 5),
                "umrahVehicleId" => ( $req['transport'] ? $req['vehicle'] : 5),
                "umrahVehiclePrice" => $totalSecVehiclePrice,
                "adultsCount" => $req['travellers']['adultCount'],
                "childrenCount" => $req['travellers']['childCount'],
                "infantsCount" => $req['travellers']['infantCount'],
                "totalRoom" => $grandRooms,
                "totalNight" => $grandNights,
                "totalPrice" => $grandPrice
            );
            $umrahBookingCustomer = $this->umrahBookingCustomerService->store($umrahPackage);
            $umrahBookingId = $umrahBookingCustomer['id'];
            if($req['isFare']){
                $umrahTicketDetails = array(
                    "adultPrice" => $adultFare,
                    "childPrice" => $childFare,
                    "infantPrice" => $infantFare,
                    "bookingCustomerId" => $umrahBookingId,
                    "selectedCurrency" => (!empty($req['fares']['selectedCurrency']) ? $req['fares']['selectedCurrency'] : "USD"),
                    "created_by" => 1,
                );
                $res = UmrahTicketDetail::create($umrahTicketDetails);
            }
            $packageHtml = '<div id="print">';
            if($get_device != "Mobile"):
                $packageHtml .= '<table class="printable-table" height="auto" width="100%">
                <thead>
                    <tr>
                        <th colspan="12" class="border">
                            <img src="https://www.rehmantravel.com/assets/Umrah/umrah-Ubc-header.webp" width="100%" height="110px" />
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="pl-4 pt-4 text-left w-1/2">Quote # : '. $umrahBookingId .'</td>
                        <td class=" pt-4 text-right pr-4 w-1/2">' . date("l jS  F Y h:i:s A") . '
                        </td>
                    </tr>
                </tbody>
                </table>
                <table class="mt-4 bg-white printable-table" height="auto" width="100%">
                    <thead
                        class="text-center bg-blue-500 h-10 text-white capitalize border border-1 border-solid border-blue-500">
                        <tr>
                            <th colspan="12">Umrah Quotation</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-gray-200 font-semibold text-sm">
                            <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Name
                            </th>
                            <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Email
                            </th>
                            <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Mobile No
                            </th>
                        </tr>
                        <tr class="text-center text-sm py-2">
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $req['customers']['firstName'] . '</td>
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $req['customers']['email'] . '</td>
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap"><a
                                    href="tel:'.$req['customers']['mobileNo'].'">' . $req['customers']['mobileNo'] . '</a></td>
                        </tr>
                    </tbody>
                </table>';
            else:
                $packageHtml .= '
                <div class="w-11/12 mx-auto">
                    <div class="grid grid-cols-12">
                        <div class="col-span-12">
                            <div class="flex flex-col justify-center items-center mb-6 mt-6">
                                <h3 class="text-white text-center text-2xl font-serif"> Umrah Package <br>
                                <img src="/assets/Umrah/main-title.webp" alt="" class="mt-3 ml-3"> </h3>
                            </div>';
            endif;
            $whatsappQuery .= '🕋 *Umrah Package for '.(!empty($req['travellers']['adultCount']) ? $req['travellers']['adultCount'] . ($req['travellers']['adultCount'] > 1 ? ' Adults' : ' Adult') : ''). (!empty($req['travellers']['childCount']) ? ", " .$req['travellers']['childCount'] . ($req['travellers']['childCount'] > 1 ? ' Childern' : ' Child') : '').(!empty($req['travellers']['infantCount']) ? ", " .$req['travellers']['infantCount'] . ($req['travellers']['infantCount'] > 1 ? ' Infants' : ' Infant') : '').'* %0A%0A';
            $whatsappQuery .= '📅 Travel Date:%0A';
            $whatsappQuery .= '• ' . $req['hotel'][0]['checkIn']. '%0A%0A';
            $whatsappQuery .= '*Accommodation Details:*%0A%0A';
            foreach ($req['hotel'] as $hotelKey => $hotel):
                $totalPrice = 0;
                $totalNights = 0;
                $totalRooms = 0;
                $umrahHotel = [];
                $hotelName = "";
                $hotelType = "";
                $hotelBasisType = "";
                $checkIn = date("Y-m-d", strtotime($hotel['checkIn']));
                $checkOut = date("Y-m-d", strtotime($hotel['checkOut']));
                $resultDay = self::__calc_week_wkend_days($checkIn, $checkOut);
                $offDays = (!empty($resultDay->offDays) ? $resultDay->offDays : 0);
                $onDays = (!empty($resultDay->onDays) ? $resultDay->onDays : 0);
                $totalNights += $offDays + $onDays;
                $totalRooms += $hotel['totalRooms']['rooms'];
                if (!empty($hotel['umrahHotelId'])):
                    $hotelDetails = $this->umrahHotelService->whereRelation(['id' => $hotel['umrahHotelId']], ['hotelRoomPeriods']);
                    foreach ($hotelDetails as $hotelDetail):
                        $hotelName = $hotelDetail['hotelName'];
                        $hotelType = UmrahHelper::__checkHotelType($hotelDetail['hotelType']);
                        $hotelBasisType = UmrahHelper::__checkBasis($hotelDetail['basisType']);
                        $days = 0;
                        foreach ($hotelDetail->hotelRoomPeriods as $key => $periods):
                            foreach ($hotel['totalRooms'] as $priceIndex => $totalRooms):
                                $onOffDayPrices = 0;
                                foreach ($periods->hotelRoomPrices as $hotelRoomPrices):
                                    if ($totalRooms !== 0 && $hotelRoomPrices['roomType'] == $priceIndex):
                                        if (($periods['periodFrom'] >= $checkIn && $periods['periodTo'] <= $checkOut) || ($periods['periodTo'] >= $checkIn && $periods['periodFrom'] <= $checkOut) && $periods['periodStatus'] != 0):
                                            if($periods['ashraType'] != 0):
                                                $onOffDayPrices += $hotelRoomPrices['onDayMarkup'] * $hotel['totalRooms'][$priceIndex];
                                            else:
                                                $periodcount = count($hotelDetail->hotelRoomPeriods);
                                                if ($periodcount == 1) {
                                                    $days = self::__calc_week_wkend_days($checkIn, $checkOut);
                                                } else {
                                                    $lastIndex = $periodcount - 1;
                                                    if($periods['periodFrom'] <= $checkIn && $periods['periodTo'] <= $checkOut){
                                                        $days = self::__calc_week_wkend_days($checkIn, $hotelDetail->hotelRoomPeriods[$key+1]['periodFrom']);
                                                    } else if($periods['periodFrom'] <= $checkIn && $periods['periodTo'] >= $checkOut){
                                                        $days = self::__calc_week_wkend_days($checkIn, $checkOut);
                                                    } else if ($key == 1 && $lastIndex == $key) {
                                                        $days = self::__calc_week_wkend_days($periods['periodFrom'], $checkOut);
                                                    } else if ($key > 1 && $lastIndex > $key) {
                                                        $days = self::__calc_week_wkend_days($periods['periodFrom'], $checkOut);
                                                    } else if ($lastIndex == $key) {
                                                        $days = self::__calc_week_wkend_days($periods['periodFrom'], $checkOut);
                                                    }
                                                }
                                                $onOffDayPrices += (($hotelRoomPrices['onDayMarkup'] * $days->onDays) + ( $hotelRoomPrices['offDayMarkup'] * $days->offDays)) * $hotel['totalRooms'][$priceIndex];
                                            endif;
                                        endif;
                                    endif;
                                endforeach;
                                $totalPrice += $onOffDayPrices;
                            endforeach;    
                        endforeach;
                        if(!empty($umrahBookingId)):
                            $umrahHotel = array(
                                "bookingCustomerId" => $umrahBookingId,
                                "location" => $hotel['location'],
                                "hotelId" => $hotel['umrahHotelId'],
                                "checkIn" => $checkIn,
                                "checkOut" => $checkOut,
                                "doubleRoom" => $hotel['totalRooms']['Double'],
                                "tripleRoom" => $hotel['totalRooms']['Triple'],
                                "quadRoom" => $hotel['totalRooms']['Quad'],
                                "quintRoom" => $hotel['totalRooms']['Quint'],
                                "hotelTotalPrice" => $totalPrice
                            );
                        endif;                        
                    if($get_device != "Mobile"):
                        $packageHtml .= '
                        <table class="mt-4 bg-white printable-table" height="auto" width="100%">
                            <thead class="text-center h-10 capitalize">
                                <tr class="' . ($hotelKey % 2 === 0 ? 'bg-red-600' : 'bg-blue-500') . ' text-white">
                                    <th colspan="12">' . $hotel['location'] . ' Hotel</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="bg-gray-200 font-semibold  text-sm">
                                    <th class="border border-1 border-solid border-gray-300">Hotel Name
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Type
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Basis
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Check In
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Check Out
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Double
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Triple
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Quad
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Quint
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Nights
                                    </th>
                                </tr>
                                <tr class="text-center text-sm py-2">
                                    <td class="border border-1 border-solid border-gray-300">' . $hotelName . '</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1 capitalize">' . $hotelType . '</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">' . $hotelBasisType . '</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">' . date("d-m-Y", strtotime($hotel['checkIn'])) . '</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">' . date("d-m-Y", strtotime($hotel['checkOut'])) . '</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">' . $hotel['totalRooms']['Double'] . '
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">' . $hotel['totalRooms']['Triple'] . '
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">' . $hotel['totalRooms']['Quad'] . '
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">' . $hotel['totalRooms']['Quint'] . '
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">' . $totalNights . '
                                    </td>
                                </tr>
                            </tbody>
                        </table>';
                    else:
                        $packageHtml .= '<div>
                            <h5 class="text-white flex justify-center text-lg">
                                <img src="/assets/Umrah/sub-title-left.webp" alt="sub-title-left">
                                ' . $hotel['location'] . ' Hotel 
                                <img src="/assets/Umrah/sub-title-right.webp" alt="sub-title-right">
                            </h5>
                            <p class="text-white text-center mb-4 mt-3 font-sans">
                                <b class="text-base">' . $hotelName . ' </b> <br>
                                <span class="text-sm">('.($hotel['totalRooms']['Double'] > 0 ? $hotel['totalRooms']['Double'] .' Double, ' : '').($hotel['totalRooms']['Triple'] > 0 ? $hotel['totalRooms']['Triple'].' Triple,  ' : '').($hotel['totalRooms']['Quad'] > 0 ? $hotel['totalRooms']['Quad'].' Quad,  ' : '').($hotel['totalRooms']['Quint'] > 0 ? $hotel['totalRooms']['Quint'].' Quint' : '').')'. ($totalRooms > 1 ? ' Room' : ' Room').'</span> for
                                <span class="text-sm">' . $totalNights . ($totalNights > 1 ? ' Nights' : ' Night'). ' </span>
                                <span class="text-sm"> ' . $hotelBasisType . '</span>
                            </p>
                        </div>';
                    endif;
                    $whatsappQuery .= '*'.$hotel['location'] . ' Hotel:*%0A';
                    $whatsappQuery .= '🏨 ' . Str::ucfirst($hotelName) . '%0A';
                    $whatsappQuery .= '🚻 Room Type: '.($hotel['totalRooms']['Double'] > 0 ? $hotel['totalRooms']['Double'] .' Double' : '').($hotel['totalRooms']['Triple'] > 0 ? ' ,'. $hotel['totalRooms']['Triple'].' Triple' : '').($hotel['totalRooms']['Quad'] > 0 ? ' ,'. $hotel['totalRooms']['Quad'].' Quad' : '').($hotel['totalRooms']['Quint'] > 0 ? ' ,'. $hotel['totalRooms']['Quint'].' Quint' : ''). ($totalRooms > 1 ? ' Room.%0A' : ' Room.%0A');
                    $whatsappQuery .= '🛏️  Nights: ' . $totalNights . '%0A';
                    $whatsappQuery .= '🍽️ Meal: ' . $hotelBasisType . '%0A%0A';
                    endforeach;
                endif;
                $grandPrice += $totalPrice;
                $grandPriceWithoutFare += $totalPrice;
                $grandRooms += $totalRooms;
                $grandNights += $totalNights;
                $umrahHotelInsertion = $this->umrahBookingService->store($umrahHotel);
                $callBackQuery[] = $umrahHotel;
            endforeach;
            $grandPrice += $totalUmrahVisaPrice + $totalSecVehiclePrice + $adultFare + $childFare + $infantFare;
            $grandPriceWithoutFare += $totalUmrahVisaPrice + $totalSecVehiclePrice;
            $umrahHotelGrandRoomsNights = $this->umrahBookingCustomerService->update($umrahBookingId, array("totalRoom" => $grandRooms, "totalNight" => $grandNights, "totalPrice" => $grandPriceWithoutFare));
            //dd($umrahHotelGrandRoomsNights);
            // $this->insertCallBack($callBackQuery, $customer);
            if($get_device != "Mobile"):
                $packageHtml .= '
                <table class="mt-4 bg-white printable-table" height="auto" width="100%">
                    <thead
                        class="text-center bg-blue-500 h-10 text-white capitalize">
                        <tr>
                            <th>Transport</th>
                            <th>Umrah Visa</th>
                            <th>Total Nights</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white text-center text-sm">
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                                '.(!empty($req['vehicle']) ? $this->__checkVehicle($req['vehicle']) : "Transport Not Included in the Package.").'</td>
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                                <p class="inline pr-1">Umrah Visa and Insurance '.$umrahVisaInsurance.' </p>
                            </td>
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $grandNights . ' Nights/' . ($grandNights + 1) . ' Days</td>
                        </tr>
                    </tbody>
                </table>
                <table class="mt-4 bg-white printable-table" height="auto" width="100%">
                    <thead
                        class="text-center bg-red-600 h-10 text-white capitalize">
                        <tr>
                            <th colspan="12">Sector</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white text-sm">
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-left pl-3">
                                '.(!empty($req['sector']) ? $this->__checkSector($req['sector']) : "Sector Not included in the Package").'</td>
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-center">Grand Total</td>
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap font-semibold text-blue-600"> SR : ' . floor($grandPriceWithoutFare) . '</td>
                        </tr>';
                        if($req['isFare']){
                            $packageHtml .= '
                            <tr class="bg-white text-sm">
                                <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-right pl-3">Ticket Fare of Adult: SR '.$adultFare.', Child: SR '.$childFare.', Infant: SR '.$infantFare.'</td>
                                <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-center">With Ticket Fare</td>
                                <td class="border border-1 border-solid border-gray-300 whitespace-nowrap font-semibold text-blue-600">SR : ' . floor($grandPrice) . '</td>
                            </tr>';
                        }
                        $packageHtml .= '
                        <tr class="bg-white text-sm">
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-left pl-3">All Taxes are included Till Date</td>
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-center"></td>
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap font-semibold text-blue-600">USD : ' . self::convertToOtherCurrency($grandPrice, 'USD') . '</td>
                        </tr>
                        <tr class="bg-white text-sm">
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-left pl-3"></td>
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-center"></td>
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap font-semibold text-blue-600">GBP : ' . self::convertToOtherCurrency($grandPrice, 'GBP') . '</td>
                        </tr>
                    </tbody>
                </table>
                <table class="mt-4 bg-white" height="auto" width="100%">
                    <thead class="text-center  h-10 text-white capitalize ">
                        <tr>
                            <th class="bg-blue-500">Requirements
                            </th>
                            <th class="bg-red-600">Note</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="text-sm">
                            <td class="border border-1 border-solid  border-gray-300  text-left pl-3">
                                <ul class="list-disc pl-4">
                                    <li>Passport valid for 8 months</li>
                                    <li>Copy of C.N.I.C/ POC</li>
                                    <li>1 passport-size photograph with Any background</li>
                                </ul>
                            </td>
                            <td class="border border-1 border-solid border-gray-300 text-left pl-3">
                                <ul class="list-disc pl-4">
                                    <li>No booking(s) made yet.</li>
                                    <li>Availability and rates are subject to change at the time of
                                            confirmation.</li>
                                    <li>For Makkah and Madinah standard check-in time is 5 PM and check-out time is 12 NOON.</li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="mt-2" height="auto" width="100%">
                    <thead>
                        <tr>
                            <th colspan="12" class="border">
                                <img src="https://www.rehmantravel.com/assets/Umrah/umrah-Ubc-footer.webp" class="w-full" />
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>';
            else:
                $packageHtml .= '
                    <div>
                        <h4 class="text-white flex justify-center text-xl">
                            <img src="/assets/Umrah/sub-title-left.webp" alt="sub-title-left">
                                Transport
                            <img src="/assets/Umrah/sub-title-right.webp" alt="sub-title-right">
                        </h4>
                        <p class="text-center text-white mb-4 mt-3 font-sans">
                            <span class="text-sm block">'.(!empty($req['vehicle']) && !empty($req['sector']) ? $this->__checkSector($req['sector']) . " With " . ($this->__checkVehicle($req['vehicle']) . " Included." ) : "Transport Not Selected").'</span>
                        </p>
                    </div>
                    <div>
                        <h4 class="text-white flex justify-center text-xl">
                            <img src="/assets/Umrah/sub-title-left.webp" alt="sub-title-left">
                             Umrah Visa
                            <img src="/assets/Umrah/sub-title-right.webp" alt="sub-title-right">
                        </h4>
                        <p class="text-center text-white mb-4 mt-3 font-sans">
                            <span class="text-sm block">Umrah Visa and Insurance '.$umrahVisaInsurance.'</span>
                        </p>
                    </div>
                ';
                if($req['isFare']){
                    $packageHtml .= '<div>
                        <b>
                        <h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded">Total cost without Ticket: </h4>
                        </b>
                    </div>
                    <div class="flex items-center justify-center gap-2">
                        <h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded"> SR :
                            <span> ' . floor($grandPriceWithoutFare) . '</span> </h4>
                        <h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded"> USD :
                            <span> ' . self::convertToOtherCurrency($grandPriceWithoutFare, 'USD') . '</span> </h4>
                        <h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded"> GBP :
                            <span> ' . self::convertToOtherCurrency($grandPriceWithoutFare, 'GBP') . '</span> </h4>
                    </div>
                    
                    <div>
                        <b>
                        <h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded">Total cost with Ticket: </h4>
                        </b>
                    </div>
                    <div class="flex items-center justify-center gap-2">
                        <h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded"> SR :
                            <span> ' . floor($grandPrice) . '</span> </h4>
                        <h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded"> USD :
                            <span> ' . self::convertToOtherCurrency($grandPrice, 'USD') . '</span> </h4>
                        <h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded"> GBP :
                            <span> ' . self::convertToOtherCurrency($grandPrice, 'GBP') . '</span> </h4>
                    </div>
                    ';
                }else{
                    $packageHtml .= '<div>
                        <b>
                        <h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded">Total cost without Ticket: </h4>
                        </b>
                    </div>
                    <div class="flex items-center justify-center gap-2">
                       <h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded"> SR :
                            <span> ' . floor($grandPrice) . '</span> </h4>
                        <h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded"> USD :
                            <span> ' . self::convertToOtherCurrency($grandPrice, 'USD') . '</span> </h4>
                        <h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded"> GBP :
                            <span> ' . self::convertToOtherCurrency($grandPrice, 'GBP') . '</span> </h4>
                    </div>';
                    
                }
            endif;
            $packageHtml .= '</div>';
            $whatsappQuery .= '🚗*Transport Sector* %0A';
            $whatsappQuery .= (!empty($req['sector']) && !empty($req['vehicle']) ? '• ' . $this->__checkSector($req['sector']) . ' with ' . ($this->__checkVehicle($req['vehicle'])) . ' Included. %0A' : '• Not Included');
            $whatsappQuery .= ' %0A%0A*Umrah Visa and Insurance:* %0A';
            $whatsappQuery .= '• ' .$umrahVisaInsurance;
            $whatsappQuery .= '%0A%0A*Package Total Price With Out Ticket:* %0A';
            $whatsappQuery .= '💵 SR '.floor($grandPriceWithoutFare) .'%0A';
            $whatsappQuery .= '💳 USD '.self::convertToOtherCurrency($grandPriceWithoutFare, 'USD') .'%0A';
            $whatsappQuery .= '💷 GBP '.self::convertToOtherCurrency($grandPriceWithoutFare, 'GBP'). '%0A%0A';
            if($req['isFare']):
            $whatsappQuery .= '*Package Total Price With Ticket:* %0A';
            $whatsappQuery .= '💵 SR '.floor($grandPrice) .'%0A';
            $whatsappQuery .= '💳 USD '.self::convertToOtherCurrency($grandPrice, 'USD') .'%0A';
            $whatsappQuery .= '💷 GBP '.self::convertToOtherCurrency($grandPrice, 'GBP');
            $whatsappQuery .= '%0A%0A*Ticket Fare:* %0A';
            $whatsappQuery .= 'Adult SR : '.$adultFare .'%0A';
            $whatsappQuery .= 'Child SR : '.$childFare .'%0A';
            $whatsappQuery .= 'Infant SR : '.$infantFare .'%0A%0A';
            endif;
            $whatsappQuery .= '*Contact Details:*%0A';
            $whatsappQuery .= '• Name: '.$clientFirstName.'%0A';
            $whatsappQuery .= '• Email: '.$clientEmail.'%0A';
            $whatsappQuery .= '• Contact No: '.$clientNumber.'%0A%0A';
            $whatsappQuery .= '*Important Notes:*%0A';
            $whatsappQuery .= '• Total Duration of stay: '.$grandNights.' Nights and '.($grandNights+1).' Days .%0A';
            $whatsappQuery .= '• Number of Travellers: '.(!empty($req['travellers']['adultCount']) ? $req['travellers']['adultCount'] . ($req['travellers']['adultCount'] > 1 ? ' Adults' : ' Adult') : ''). (!empty($req['travellers']['childCount']) ? ", " .$req['travellers']['childCount'] . ($req['travellers']['childCount'] > 1 ? ' Childern' : ' Child') : '').(!empty($req['travellers']['infantCount']) ? ", " .$req['travellers']['infantCount'] . ($req['travellers']['infantCount'] > 1 ? ' Infants' : ' Infant') : '');
            if($req['isFare']):
                $whatsappQuery .= '%0A• Price includes Airfare.';
            else:
                $whatsappQuery .= '%0A• Price does not include Airfare.';
            endif;
            $whatsappApi = 'phone='. self::convertNumber($req['customers']['mobileNo']) .'&text=' .$whatsappQuery;
            $whatsappApiCustom = "&text=" .$whatsappQuery;
            if($packageHtml):
                self::sendEmail($req['customers']['firstName'], $clientNumber, $whatsappQuery);
                return [
                    'ubcHTML' => $packageHtml,
                    'whatsappApi' => $whatsappApi,
                    'whatsappApiCustom' => $whatsappApiCustom
                ];
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Create UBC']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    
    public function sendEmail($firstName, $clientNumber, $packageHtml){
        $updatePackageHtml = '';
        $packageHtml = str_replace("%0A", "<br />", $packageHtml);
        $packageHtml = str_replace("*", " ", $packageHtml);
        $packageHtml = str_replace(":*", ":", $packageHtml);
        $updatePackageHtml .= '<img src="https://www.rehmantravel.com/assets/Umrah/umrah-Ubc-header.png" width="100%" height="110px" /> <br /><br />';
        $updatePackageHtml .= $packageHtml;
        $updatePackageHtml .= '<br /><br /><img src="https://www.rehmantravel.com/assets/Umrah/umrah-Ubc-footer.png" width="100%" />';
        try{
            TicketingEmailProvider::umrahOrderCreateMail([
                "to" => ['khalidjavid@exalted.pk'],
                "unlink" => true,
                "name" => [$firstName],
                "phoneNumber" => [$clientNumber, '923345550579'],
                "subject" => ['Umrah UBC', 'Umrah UBC'],
                "body" => [
                    'packageHtml' => $updatePackageHtml
                ],
                "ubcRef" => 'UBC',
                'title' => "Passenger Name Record / Itinerary Reference has been successfully Created",
                'location' => 'umrah',
                'pdf' => false,
                'fileName' => 'ubc',
                'view' => 'UmrahOrderCreate'
            ]);
        }catch(Exception $e){
            return response()->json([
                'message' => 'An unexpected error has occurred. Please try again',
                'errorType' => true
            ]);
        }
    }
    
    public function insertCallBack($callBackQuery, $customer){
        $message = "";
        foreach($callBackQuery as $callBackQueryItem){
            $hotel = $this->umrahHotelService->fetch(['id' => $callBackQueryItem['hotelId']]);
            //dd($hotel);
            $message .= "<b>" . $callBackQueryItem['location'] . ":</b> ". $hotel['hotelName'] . ", <b>Check In:</b> ". date("d-m-Y", strtotime($callBackQueryItem['checkIn'])) . ", <b>Check Out:</b> ". date("d-m-Y", strtotime($callBackQueryItem['checkOut'])) . ", <b>Double:</b> " . $callBackQueryItem['doubleRoom']. ", <b>Triple:</b> " . $callBackQueryItem['tripleRoom']. ", <b>Quad:</b> " . $callBackQueryItem['quadRoom']. ", <b>Quint:</b> " . $callBackQueryItem['quintRoom'] . ", ";
        }
        $getreferalUrl = ClientSystemInfoHelper::getreferalUrl();
        $ip =  ClientSystemInfoHelper::get_ip();
        $get_browsers =  ClientSystemInfoHelper::get_browsers();
        $get_device =  ClientSystemInfoHelper::get_device();
        $get_os =  ClientSystemInfoHelper::get_os();
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
            'moduleId' => '2',
            'referalUrl' => $getreferalUrl,
            'leadFrom' => ($get_device != "Mobile" ? "Umrah UBC" : "Umrah Mobile UBC"),
        );
        $getResponse = $this->callbackQueriesService->store($clientData);
    }
    public function packagesTitle_() {
        $data = [
            'name' => 'John Doe',
            'message' => 'This is a test email.',
        ];

        Mail::to('khalidjavid@exalted.pk')->send(new MyCustomEmail($data));

        return 'Email sent successfully!';
    }
    public function convertToOtherCurrency($amount, $currencyCode)
    {
        $currencySR = Currency::where('currencyCode', 'SAR')->first();
        $currency = Currency::where('currencyCode', $currencyCode)->first();
        $convertToPKR = round(($amount * $currencySR->currencyRate));
        $rate = $currency->currencyRate;
        return round($convertToPKR / $rate);
    }

    public function convertToSR($amount, $currencyCode)
    {
        if($currencyCode == 'SAR'){
            return $amount;
        }else{
            $currencySR = Currency::where('currencyCode', 'SAR')->first();
            $currency = Currency::where('currencyCode', $currencyCode)->first();
            $convertToPKR = round(($amount * $currency->currencyRate));
            $rate = $currencySR->currencyRate;
            return round($convertToPKR / $rate);
        }
    }

    public function __checkCustomer($customerInfo)
    {
        $customerNum = $customerInfo['mobileNo'];
        $convertedNumber = self::convertNumber($customerNum);
        $customers = $this->customerService->fetch(["mobileNo" => $convertedNumber]);
        $customer = "";
        if(!empty($customers)):
            $customer = (!empty($customers['id']) ? $customers['id'] : null);
        else:
            $customerData = array(
                'firstName' => $customerInfo['firstName'],
                'mobileNo' => $convertedNumber,
                'email' => $customerInfo['email'],
            );
            $customers = $this->customerService->store($customerData);
            $customer = $customers['id'];
        endif;
        return $customer;
    }
    
    public function convertNumber($cusNum){
        $cusNum = ltrim($cusNum , "0092");
        $cusNum = ltrim($cusNum , "92");
        $cusNum = ltrim($cusNum , "+92");
        $cusNum = ltrim($cusNum , "0");
        if($cusNum){
            if($cusNum[0] == "3"){
                $cusNum = "+92" . $cusNum;
            }else{
                $cusNum = "+" . $cusNum;
            }
        }
        return $cusNum;
    }
    
    public function __umrahVehiclePrice($umrahVehicleId, $umrahSectorId)
    {
        if($umrahVehicleId != "" && $umrahSectorId != ""):
            $secVehiclePrice = $this->umrahVehiclePriceService->fetch(['vehicleId' => $umrahVehicleId, 'sectorId' => $umrahSectorId, 'vehiclePriceStatus' => '1']);
            return (!empty($secVehiclePrice) ? $secVehiclePrice->vehicleSectorMrkPrice : 0);
        else:
            return 0;
        endif;
    }
    public function __checkUmrahVisa($nationality)
    {
        $nationality = ($nationality == 0 ? "Pakistan" : "Others");
        $umrahVisa = $this->umrahVisaService->fetch(['umrahVisaNationality' => $nationality, "umrahVisaPriceStatus" => '1']);
        return (!empty($umrahVisa) ? $umrahVisa->umrahVisaPrice : 0);
    }
    public function __checkSector($sectorId){
        $sectorDetails = $this->umrahTransportSectorService->fetch(['id' => $sectorId]);
        $sectorName = $sectorDetails->sectorName;
        return $sectorName;
    }
    public function __checkVehicle($vehicleId){
        $vehicleDetails = $this->umrahVehicleService->fetch(['id'=> $vehicleId]);
        $vehicleName = $vehicleDetails->vehicleName;
        return $vehicleName;
    }
    public function __calc_week_wkend_days($checkIn, $checkOut)
    {
        if (!empty($checkIn) && !empty($checkOut)):
            $startDate = date('d-m-Y', strtotime($checkIn));
            $endDate = date('d-m-Y', strtotime($checkOut));
            $resultDays = array('Mon' => 0, 'Tue' => 0, 'Wed' => 0, 'Thu' => 0, 'Fri' => 0, 'Sat' => 0, 'Sun' => 0);
            $resultDays = array('offDays' => 0, 'onDays' => 0);
            $startDate = Carbon::parse($startDate);
            $endDate = Carbon::parse($endDate);
            while ($startDate < $endDate):
                $timestamp = strtotime($startDate->format('d-m-Y'));
                $weekDay = date('D', $timestamp);
                if ($weekDay == 'Thu' || $weekDay == 'Fri'):
                    $resultDays['offDays'] = $resultDays['offDays'] + 1;
                else:
                    $resultDays['onDays'] = $resultDays['onDays'] + 1;
                endif;
                $startDate->modify('+1 day');
            endwhile;
            return (object) $resultDays;
        else:
            return false;
        endif;
    }
}