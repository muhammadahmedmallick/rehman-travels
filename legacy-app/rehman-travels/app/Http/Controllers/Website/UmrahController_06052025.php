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
            $grandPrice = 0;
            $grandNights = 0;
            $grandRooms = 0;
            $umrahBookingId = 0;
            $callBackQuery = [];
            $get_device =  ClientSystemInfoHelper::get_device();
            $secVehiclePrice = ($req['transport'] != true || $req['vehicle'] == 5 ? 50 : $this->__umrahVehiclePrice($req['vehicle'], $req['sector']));
            $umrahVisa = ($req['umrahVisa'] != true ? 0 : $this->__checkUmrahVisa($req['nationality']));
            $umrahVisaInsurance = ($req['umrahVisa'] != true ? " not Included " : " Included for " . $req['travellers']['totalTraveller'] .' '. ($req['travellers']['totalTraveller'] > 1 ? 'Persons' : 'Person'));
            $totalUmrahVisaPrice = ($umrahVisa > 0 ? $umrahVisa * $req['travellers']['totalTraveller'] : 0);
            $totalSecVehiclePrice = ($secVehiclePrice > 0 ? ($req['vehicle'] == 5 ? $secVehiclePrice * $req['travellers']['totalTraveller'] : $secVehiclePrice) : 0);
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
            $whatsappQuery .= '*Umrah Package for '.(!empty($req['travellers']['adultCount']) ? $req['travellers']['adultCount'] .' Adult(s)' : ''). (!empty($req['travellers']['childCount']) ? ", " .$req['travellers']['childCount'] .' Child(s)' : '').(!empty($req['travellers']['infantCount']) ? ", " .$req['travellers']['infantCount'] .' Infant(s)' : '').'* %0A%0A';
            $whatsappQuery .= 'Travel Date:%0A';
            $whatsappQuery .= '• '.$req['hotel'][0]['checkIn']. '%0A%0A';
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
                            <thead
                                class="text-center h-10 capitalize">
                                <tr class="' . ($hotelKey % 2 === 0 ? 'bg-red-600' : 'bg-blue-500') . ' text-white">
                                    <th colspan="12">' . $hotel['location'] . ' Hotel</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="bg-gray-200 font-semibold  text-sm">
                                    <th class="border border-1 border-solid border-gray-300">Hotel
                                        Name</th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Type
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Basis
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Check
                                        In
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Check
                                        Out
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">
                                        Double
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">
                                        Triple
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Quad
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">Quint
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">
                                        Nights
                                    </th>
                                </tr>
                                <tr class="text-center text-sm py-2">
                                    <td class="border border-1 border-solid border-gray-300">' . $hotelName . '</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap p-1">' . $hotelType . '</td>
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
                                <span class="text-sm">('.($hotel['totalRooms']['Double'] > 0 ? $hotel['totalRooms']['Double'] .' Double, ' : '').($hotel['totalRooms']['Triple'] > 0 ? $hotel['totalRooms']['Triple'].' Triple,  ' : '').($hotel['totalRooms']['Quad'] > 0 ? $hotel['totalRooms']['Quad'].' Quad,  ' : '').($hotel['totalRooms']['Quint'] > 0 ? $hotel['totalRooms']['Quint'].' Quint' : '').')'. ($totalRooms > 1 ? ' Rooms' : ' Room').'</span> for
                                <span class="text-sm">' . $totalNights . ($totalNights > 1 ? ' Nights' : ' Night'). ' </span>
                                <span class="text-sm"> ' . $hotelBasisType . '</span>
                            </p>
                        </div>';
                    endif;
                    $whatsappQuery .= '*'.$hotel['location'] . ' Hotel:*%0A';
                    $whatsappQuery .= '• ' . Str::ucfirst($hotelName) . '%0A';
                    $whatsappQuery .= '• Room Type: '.($hotel['totalRooms']['Double'] > 0 ? $hotel['totalRooms']['Double'] .' Double' : '').($hotel['totalRooms']['Triple'] > 0 ? ','. $hotel['totalRooms']['Triple'].' Triple' : '').($hotel['totalRooms']['Quad'] > 0 ? ','. $hotel['totalRooms']['Quad'].' Quad' : '').($hotel['totalRooms']['Quint'] > 0 ? ','. $hotel['totalRooms']['Quint'].' Quint' : ''). ($totalRooms > 1 ? ' Rooms.%0A' : ' Room.%0A');
                    $whatsappQuery .= '• Nights: ' . $totalNights . '%0A';
                    $whatsappQuery .= '• Board: ' . $hotelBasisType . '%0A%0A';
                    endforeach;
                endif;
                $grandPrice += $totalPrice;
                $grandRooms += $totalRooms;
                $grandNights += $totalNights;
                $umrahHotelInsertion = $this->umrahBookingService->store($umrahHotel);
                $callBackQuery[] = $umrahHotel;
            endforeach;
            $grandPrice += $totalUmrahVisaPrice + $totalSecVehiclePrice;
            $umrahHotelGrandRoomsNights = $this->umrahBookingCustomerService->update($umrahBookingId, array("totalRoom" => $grandRooms, "totalNight" => $grandNights, "totalPrice" => $grandPrice));
            //dd($umrahHotelGrandRoomsNights);
            $this->insertCallBack($callBackQuery, $customer);
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
                                '.(!empty($req['vehicle']) ? $this->__checkVehicle($req['vehicle']) : "Transport Not included in the Package").'</td>
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
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap font-semibold text-blue-600"> SR : ' . floor($grandPrice) . '</td>
                        </tr>
                        <tr class="bg-white text-sm">
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-left pl-3">
                            All Taxes are included Till Date</td>
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-center">'.($req['travellers']['totalTraveller'] > 1 ? 'Price Per Person' : '').'</td>
                            <td class="border border-1 border-solid border-gray-300 whitespace-nowrap font-semibold text-blue-600">
                            '.($req['travellers']['totalTraveller'] > 1 ? ' SR : ' . floor($grandPrice / $req['travellers']['totalTraveller']) : ''). '</td>
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
                                    <li>1 passport-size photograph with Blue background</li>
                                </ul>
                            </td>
                            <td class="border border-1 border-solid border-gray-300 text-left pl-3">
                                <ul class="list-disc pl-4">
                                    <li>This Quotation is valid for 2 days Only. </li>
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
                                <img src="https://www.rehmantravel.com/assets/Umrah/umrah-Ubc-footer.webp" class="" />
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
                    <div>
                        <b><h4 class="bg-rose-600 text-white text-base font-nano text-center py-2 rounded">Total Package Cost :
                            <span> ' . floor($grandPrice) . ' / SR</span> </h4></b>
                    </div>
                ';
            endif;
            $packageHtml .= '</div>';
            $whatsappQuery .= '*Sector | Umrah Visa* %0A';
            $whatsappQuery .= (!empty($req['sector']) && !empty($req['vehicle']) ? '• ' .$this->__checkSector($req['sector']) . ' with ' . ($this->__checkVehicle($req['vehicle'])) . ' Included.' : '');
            $whatsappQuery .= ($req['umrahVisa'] != true ? '%0A• Umrah Visa and Insurance '.$umrahVisaInsurance : '');
            $whatsappQuery .= '%0A%0A*Cost:* %0A';
            $whatsappQuery .= '• Total Price: SR '.floor($grandPrice) .'%0A%0A';
            $whatsappQuery .= '*Note:* Price does not include airfare.';
            $whatsappApi = 'phone='. self::convertNumber($req['customers']['mobileNo']) .'&text=' .$whatsappQuery;
            $whatsappApiCustom = "&text=" .$whatsappQuery;
            if($packageHtml):
                // return $packageHtml;
                // self::sendEmail($req['customers']['firstName'], $packageHtml);
                return [
                    'ubcHTML' => $packageHtml,
                    'whatsappApi' => $whatsappApi,
                    'whatsappApiCustom' => $whatsappApiCustom
                ];
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to add New Content']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    
    public function sendEmail($firstName, $packageHtml){
        try{
            TicketingEmailProvider::umrahOrderCreateMail([
                "to" => [env('MAIL_FROM_ADDRESS'), 'khalidjavid@exalted.pk'],
                "unlink" => true,
                "name" => [env('MAIL_FROM_TITLE'), $firstName],
                "phoneNumber" => ['923345550579', '923345550579'],
                "subject" => ['Umrah UBC', 'Umrah UBC'],
                "body" => [
                    $packageHtml
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