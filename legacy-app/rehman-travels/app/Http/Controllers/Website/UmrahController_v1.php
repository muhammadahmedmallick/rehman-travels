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

class UmrahController extends Controller
{
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
    public function __construct(UmrahBookingService $umrahBookingService,UmrahBookingCustomerService $umrahBookingCustomerService,CustomerService $customerService, UmrahVehiclePriceService $umrahVehiclePriceService, UmrahVisaService $umrahVisaService, UmrahHotelRoomPriceService $umrahHotelRoomPriceService, UmrahVehicleService $umrahVehicleService, UmrahTransportSectorService $umrahTransportSectorService, ContentPageService $contentPageService, UmrahHotelService $umrahHotelService)
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
    }
    public function index(Request $request)
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
    // 18:21
    public function packagesTitle(Request $req)
    {
        try{
            $getUrl = request()->path();
            if(!empty($getUrl) && $getUrl != "Umrhbookingdyn"):
                $umrahPackages = $this->contentPageService->fetch(['urlLink' => $getUrl]);
                // $umrahPackages = $this->contentPageService->fetch(['packageTitle' => str_replace("-"," ",$packagesTitle)]);
                return Inertia::render('Website/Umrah/UmrahDetailPage', ['umrahPackages' => $umrahPackages]);
            elseif($req):
                $packageHtml = $this->umrahBooking($req);
                $umrahPackages = $this->contentPageService->fetch(['urlLink' => $getUrl]);
                $umrahHotelMakkah = $this->umrahHotelService->whereQuery(['hotelLocation' => 'Makkah', 'hotelStatus' => '1']);
                $umrahHotelMadinah = $this->umrahHotelService->whereQuery(['hotelLocation' => 'Madinah', 'hotelStatus' => '1']);
                $umrahTransportSectors = $this->umrahTransportSectorService->whereQuery(['sectorStatus' => '1']);
                $umrahVehicleServices = $this->umrahVehicleService->whereQuery(['vehicleStatus' => '1']);
                return Inertia::render('Website/Umrah/Umrhbookingdyn', ['packageHtml' => $packageHtml,'umrahPackages'=> $umrahPackages,'umrahVehicleServices' => $umrahVehicleServices, "umrahHotelMadinah" => $umrahHotelMadinah, 'umrahHotelMakkah' => $umrahHotelMakkah, 'umrahTransportSectors' => $umrahTransportSectors]);
            else:
                $umrahPackages = $this->contentPageService->fetch(['urlLink' => $getUrl]);
                $umrahHotelMakkah = $this->umrahHotelService->whereQuery(['hotelLocation' => 'Makkah', 'hotelStatus' => '1']);
                $umrahHotelMadinah = $this->umrahHotelService->whereQuery(['hotelLocation' => 'Madinah', 'hotelStatus' => '1']);
                $umrahTransportSectors = $this->umrahTransportSectorService->whereQuery(['sectorStatus' => '1']);
                $umrahVehicleServices = $this->umrahVehicleService->whereQuery(['vehicleStatus' => '1']);
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
    public function umrahBooking(Request $req)
    {
        // dd($req);
        try
        {
            $customer = (!empty($req['customers']['mobileNo']) ? $this->__checkCustomer($req['customers']) : 0);
            $grandPrice = 0;
            $grandNights = 0;
            $grandRooms = 0;
            $secVehiclePrice = ($req['transport'] == true ? $this->__umrahVehiclePrice($req['vehicle'], $req['sector']) : 0);
            $umrahVisa = ($req['umrahVisa'] == true ? $this->__checkUmrahVisa($req['nationality']) : 0);
            $totalUmrahVisaPrice = ($umrahVisa > 0 ? $umrahVisa * $req['travellers']['totalTraveller'] : 0);
            $totalSecVehiclePrice = ($secVehiclePrice > 0 ? $secVehiclePrice * $req['travellers']['totalTraveller'] : 0);
            $umrahPackage = array(
                "customerId" => $customer,
                "nationality" => $req['nationality'],
                "city" => ($req['city'] ? $req['city'] : 0),
                "transport" => ($req['transport'] == true ? "1" : "0"),
                "umrahVisaPrice" => $totalUmrahVisaPrice,
                "umrahVehiclePrice" => $totalSecVehiclePrice,
                "adultsCount" => $req['travellers']['adultCount'],
                "childrenCount" => $req['travellers']['childCount'],
                "infantsCount" => $req['travellers']['infantCount'],
                "totalRoom" => $grandRooms,
                "totalNight" => $grandNights
            );
            $umrahBookingCustomer = $this->umrahBookingCustomerService->store($umrahPackage);
            $packageHtml = '<div id="print">';
            $packageHtml .= '<table class="printable-table" height="auto" width="100%">
            <thead>
                <tr>
                    <th colspan="12" class="border">
                        <img src="/assets/Umrah/umrah-Ubc-header.webp" width="100%" height="110px" />
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="pl-4 pt-4 text-left w-1/2">Quote # : '. $umrahBookingCustomer['id'] .'</td>
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
                        <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">City
                            Name
                        </th>
                        <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                            Nationality</th>
                    </tr>
                    <tr class="text-center text-sm py-2">
                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $req['customers']['firstName'] . '</td>
                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $req['customers']['email'] . '</td>
                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap"><a
                                href="#">' . $req['customers']['mobileNo'] . '</a></td>
                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                            ' . UmrahHelper::__checkCity($req['city']) . '
                        </td>
                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                        ' . ($req['nationality'] != 0 ? 'Foreigner' : 'Pakistani') . '
                        </td>
                    </tr>
                </tbody>
            </table>';
            // dd($umrahPackage);
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
                $resultDay = $this->__calc_week_wkend_days($checkIn, $checkOut);
                $offDays = (!empty($resultDay->offDays) ? $resultDay->offDays : 0);
                $onDays = (!empty($resultDay->onDays) ? $resultDay->onDays : 0);
                $totalNights += $offDays + $onDays;
                $totalRooms += $hotel['totalRooms']['rooms'];
                // dd($totalRooms);
                if (!empty($hotel['umrahHotelId'])):
                    $hotelDetails = $this->umrahHotelService->whereRelation(['id' => $hotel['umrahHotelId']], ['hotelRoomPeriods']);
                    foreach ($hotelDetails as $hotelDetail):
                        $hotelName = $hotelDetail['hotelName'];
                        $hotelType = UmrahHelper::__checkHotelType($hotelDetail['hotelType']);
                        $hotelBasisType = UmrahHelper::__checkBasis($hotelDetail['basisType']);
                        foreach ($hotelDetail->hotelRoomPeriods as $periods):
                            foreach ($hotel['totalRooms'] as $priceIndex => $totalRooms):
                                $onOffDayPrices = 0;
                                foreach ($periods->hotelRoomPrices as $hotelRoomPrices):
                                    if ($totalRooms !== 0 && $hotelRoomPrices['roomType'] == $priceIndex):
                                        if (($periods['periodFrom'] >= $checkIn && $periods['periodTo'] <= $checkOut) || ($periods['periodTo'] >= $checkIn && $periods['periodFrom'] <= $checkOut)):
                                            // echo ($periods['periodTo'] > $hotel['checkIn'] && $periods['periodFrom'] <= $hotel['checkOut']) . "<br>";
                                            // echo "<br>" . $priceIndex . "<br>" . $hotelRoomPrices['onDayMarkup'] . "<br>";
                                            $onOffDayPrices += ($hotelRoomPrices['onDayMarkup'] * $onDays) + ( $hotelRoomPrices['offDayMarkup'] * $offDays) * $totalRooms;
                                        endif;
                                    endif;
                                endforeach;
                                $totalPrice += $onOffDayPrices;
                                // echo  '<br/>' . $onOffDayPrices . "<br>";
                            endforeach;    
                        endforeach;
                        if(!empty($umrahBookingCustomer['id'])):
                            $umrahHotel = array(
                                "bookingCustomerId" => $umrahBookingCustomer['id'],
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
                        $packageHtml .= '<table class="mt-4 bg-white printable-table" height="auto" width="100%">
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
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Type
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Basis
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Check
                                        In
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Check
                                        Out
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                                        Double
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                                        Triple
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Quad
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">Quint
                                    </th>
                                    <th class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                                        Nights
                                    </th>
                                </tr>
                                <tr class="text-center text-sm py-2">
                                    <td class="border border-1 border-solid border-gray-300">' . $hotelName . '</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $hotelType . '</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $hotelBasisType . '</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $checkIn . '</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $checkOut . '</td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $hotel['totalRooms']['Double'] . '
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $hotel['totalRooms']['Triple'] . '
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $hotel['totalRooms']['Quad'] . '
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $hotel['totalRooms']['Quint'] . '
                                    </td>
                                    <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">' . $totalNights . '
                                    </td>
                                </tr>
                            </tbody>
                        </table>';
                    endforeach;
                endif;
                $grandPrice += $totalPrice;
                $grandRooms += $totalRooms;
                $grandNights += $totalNights;
                $umrahHotelInsertion = $this->umrahBookingService->store($umrahHotel);
            endforeach;
            $grandPrice += $totalUmrahVisaPrice + $totalSecVehiclePrice;
            $packageHtml .= '
            <table class="mt-4 bg-white printable-table" height="auto" width="100%">
                <thead
                    class="text-center bg-blue-500 h-10 text-white capitalize">
                    <tr>
                        <th>Transport</th>
                        <th>Umrah Visa Services</th>
                        <th>Total Nights</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="bg-white text-center text-sm">
                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                            '.(!empty($req['vehicle']) ? $this->__checkVehicle($req['vehicle']) : "Shared Transport By Bus").'</td>
                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap">
                            <p class="inline pr-1">Umrah Visa and Insurance for ' . $req['travellers']['totalTraveller'] . ' Person</p>
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
                            '.(!empty($req['sector']) ? $this->__checkSector($req['sector']) : "Jeddah Airport- Makkah- Madinah- Jeddah Airport").'</td>
                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-center">Grand Total</td>
                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap font-semibold text-blue-600">
                            SR : ' . floor($grandPrice) . '</td>
                    </tr>
                    <tr class="bg-white text-sm">
                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-left pl-3">
                        All Taxes are included Till Date</td>
                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap text-center">Price Per Person</td>
                        <td class="border border-1 border-solid border-gray-300 whitespace-nowrap font-semibold text-blue-600">
                            SR : ' . floor($grandPrice / $req['travellers']['totalTraveller']) . '</td>
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
                                <li>Covid-19 Vaccination Card/Certificate</li>
                            </ul>
                        </td>
                        <td class="border border-1 border-solid border-gray-300 text-left pl-3">
                            <ul class="list-disc pl-4">
                                <li>This Quotation is valid for 2 days Only. </li>
                                <li>No booking(s) made yet.</li>
                                <li><mark>Availability and rates are subject to change at the time of
                                        confirmation </mark></li>
                                <li>For Makkah and Madinah standard check-in time is 5 PM and check-out
                                    time
                                    is 12 NOON.</li>
                            </ul>
                        </td>
                    </tr>
                </tbody>
            </table>
            <table class="mt-2" height="auto" width="100%">
                <thead>
                    <tr>
                        <th colspan="12" class="border"><img
                                src="/assets/Umrah/umrah-Ubc-footer.webp"
                                class="" /></th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
            </div>';
            // echo "<pre>";
            // print_r($packageHtml);
            // die();
            if($packageHtml):
                return $packageHtml;
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
        $customers = $this->customerService->fetch(["mobileNo" => $customerInfo['mobileNo']]);
        $customer = "";
        if(!empty($customers)):
            $customer = !empty($customers['id']) ? $customers['id'] : null;
        else:
            $customers = $this->customerService->store($customerInfo);
            $customer = $customers['id'];
        endif;
        return $customer;
    }
    public function __umrahVehiclePrice($umrahVehicleId, $umrahSectorId)
    {
        if($umrahVehicleId == "5"):
            return 100;
        elseif($umrahVehicleId != "" && $umrahSectorId != ""):
            $secVehiclePrice = $this->umrahVehiclePriceService->fetch(['vehicleId' => $umrahVehicleId, 'sectorId' => $umrahSectorId, 'vehiclePriceStatus' => '1']);
            return (!empty($secVehiclePrice) ? $secVehiclePrice->vehiclePrice : 0);
        else:
            return 0;
        endif;
    }
    public function __checkUmrahVisa($nationality)
    {
        $nationality = ($nationality == 0 ? "Pakistan" : "Others");
        $umrahVisa = $this->umrahVisaService->fetch(['umrahVisaNationality' => $nationality, "umrahVisaPriceStatus" => '1']);
        // dd($umrahVisa);
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
