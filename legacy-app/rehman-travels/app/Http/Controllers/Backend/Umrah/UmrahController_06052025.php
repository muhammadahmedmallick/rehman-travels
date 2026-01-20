<?php

namespace App\Http\Controllers\Backend\Umrah;

use App\Http\Controllers\Controller;

use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use App\Services\Site\ParentPageService;
use App\Services\Site\ContentPageService;
use App\Services\Umrah\UmrahBookingService;
use App\Services\Umrah\UmrahBookingCustomerService;
use App\Services\Umrah\UmrahHotelService;
use App\Services\Umrah\UmrahTransportSectorService;
use App\Services\Umrah\UmrahVehicleService;
use App\Helper\UmrahHelper;
use Illuminate\Support\Collection;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class UmrahController extends Controller
{
    protected $parentPageService;
    protected $contentPageService;
    protected $umrahBookingService;
    protected $umrahBookingCustomerService;
    protected $umrahHotelService;
    protected $umrahTransportSectorService;
    protected $umrahVehicleService;
    public function __construct(UmrahVehicleService $umrahVehicleService, UmrahTransportSectorService $umrahTransportSectorService,UmrahHotelService $umrahHotelService,UmrahBookingCustomerService $umrahBookingCustomerService,UmrahBookingService $umrahBookingService,ParentPageService $parentPageService, ContentPageService $contentPageService)
    {
        $this->parentPageService = $parentPageService;
        $this->contentPageService = $contentPageService;
        $this->umrahBookingService = $umrahBookingService;
        $this->umrahBookingCustomerService =$umrahBookingCustomerService;
        $this->umrahHotelService = $umrahHotelService;
        $this->umrahTransportSectorService = $umrahTransportSectorService;
        $this->umrahVehicleService = $umrahVehicleService;
    }
    public function index(Request $request){

        try{
            $parentPages = $this->parentPageService->all(['id','title','parentUrl']);
            $umrahPages = $this->contentPageService->whereWithRelation('parentId',2,['parentPages']);
            if($umrahPages):
                return Inertia::render('Backend/Umrah/AllUmrahDetails', ['umrahPages' => $umrahPages, 'parentPages' => $parentPages]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to load Umrah Pages.']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }

    public function newPage(){
        $parentPages = $this->parentPageService->all(['id', 'title']);
        try{
            if($parentPages):
                return Inertia::render('Backend/Umrah/AddNewPage', ['parentPages' => $parentPages]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to add New Pages.']);
            endif;

        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    
    public function umrahUBC(){
        // $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' ,'2024-07-01'], [DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '<=' ,'2024-07-31']];
        $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' ,date('Y-m-d', strtotime(date('Y-m-d') . '-16 days'))]];
        $umrahBookingCustomers = $this->umrahBookingCustomerService->whereCallBackRelation($where, ['UmrahBookings', 'Customers'],'id', 'DESC');
        $collection = new Collection();
        foreach($umrahBookingCustomers as $umrahBookingCustomer){
            $adultsCount  = $umrahBookingCustomer['adultsCount'];
            $childrenCount  = $umrahBookingCustomer['childrenCount'];
            $infantsCount  = $umrahBookingCustomer['infantsCount'];
            $totalTravellers = ($adultsCount + $childrenCount + $infantsCount);
            $umrahUBC = '';
            foreach($umrahBookingCustomer->UmrahBookings as $umrahIndex => $umrahBooking){
                $weekDays = $this->__calc_week_wkend_days($umrahBooking['checkIn'], $umrahBooking['checkOut']);
                $offDays = $weekDays->offDays;
                $onDays = $weekDays->onDays;
                $hotelCheckIn = Carbon::parse($umrahBooking['checkIn']);
                $hotelCheckOut = Carbon::parse($umrahBooking['checkOut']);
                $hotelDetails = $this->umrahHotelService->fetch(['id' => $umrahBooking["hotelId"]]);
                $doubleRoom = $umrahBooking['doubleRoom'];
                $tripleRoom = $umrahBooking['tripleRoom'];
                $quadRoom = $umrahBooking['quadRoom'];
                $quintRoom = $umrahBooking['quintRoom'];
                $totalNights = $hotelCheckIn->diffInDays($hotelCheckOut);
                $umrahUBC .= '
                "'.$umrahIndex.'": {
                    "id":"'.$umrahBooking["id"].'",
                    "hotelLocation":"'.$umrahBooking["location"].'",
                    "hotelName":"'.$hotelDetails["hotelName"].'",
                    "basisType":"'.UmrahHelper::__checkBasis($hotelDetails["basisType"]).'",
                    "hotelType":"'.$hotelDetails["hotelType"].'",
                    "checkIn":"'. (!empty($umrahBooking['checkIn']) && $umrahBooking['checkIn'] != 'undefined' ? date("d-m-Y", strtotime($umrahBooking["checkIn"])) : '') .'",
                    "checkOut": "'.date("d-m-Y", strtotime($umrahBooking["checkOut"])).'",
                    "doubleRoom": "'.$doubleRoom.'",
                    "tripleRoom": "'.$tripleRoom.'",
                    "quadRoom": "'.$quadRoom.'",
                    "quintRoom": "'.$quintRoom.'",
                    "offDays": "'.$offDays.'",
                    "onDays": "'.$onDays.'",
                    "hotelTotalPrice": "'.$umrahBooking["hotelTotalPrice"].'",
                    "totalNights" : "'.$totalNights.'"
                },';
            }
            $umrahUBC = rtrim($umrahUBC,',');
            if(isset($umrahBookingCustomer['totalPrice']) && $umrahBookingCustomer['totalPrice'] > 0){
                $collection->push((object)[
                    "ubcDetails"=> [
                        "UbcNo" => $umrahBookingCustomer['id'],
                        "fullName"=> $umrahBookingCustomer->Customers['firstName'],
                        "mobileNo"=> $umrahBookingCustomer->Customers['mobileNo'],
                        "email"=> $umrahBookingCustomer->Customers['email'],
                        "created_at" => date("d-m-Y h:i:s A", strtotime($umrahBookingCustomer['created_at'])),
                        "created_by" => ($umrahBookingCustomer['created_by'] != 0 ? $umrahBookingCustomer['created_by'] : 'Front User'),
                        "city"=> UmrahHelper::__checkCity($umrahBookingCustomer['city']),
                        "nationality" => (!empty($umrahBookingCustomer['nationality']) && $umrahBookingCustomer['nationality'] != 0 ? 'Foreigner' : 'Pakistani' ),
                        "transport" => $umrahBookingCustomer['transport'],
                        "umrahSector" => ($umrahBookingCustomer['transport'] != 0 ? $this->__umrahSector($umrahBookingCustomer['umrahSectorId']) : 'Sector Not included in the Package'),
                        "umrahVehicle" => ($umrahBookingCustomer['umrahVehicleId'] != 0 ? $this->__umrahVehicle($umrahBookingCustomer['umrahVehicleId']) : 'Transport Not included in the Package'),
                        "totalTravellers" => $totalTravellers,
                        "visaPriceInclude" => (!empty($umrahBookingCustomer['umrahVisaPrice']) && $umrahBookingCustomer['umrahVisaPrice'] > 0 ? " included for" :  " not included for"),
                        "visaPrice" => (!empty($umrahBookingCustomer['umrahVisaPrice']) && $umrahBookingCustomer['umrahVisaPrice'] > 0 ? $umrahBookingCustomer['umrahVisaPrice'] :  ''),
                        "umrahVehiclePrice" => (!empty($umrahBookingCustomer['umrahVehiclePrice']) && $umrahBookingCustomer['umrahVehiclePrice'] > 0 ? $umrahBookingCustomer['umrahVehiclePrice'] :  ''),
                        "totalNights" => $umrahBookingCustomer['totalNight'],
                        "totalPrice" => $umrahBookingCustomer['totalPrice'],
                        'hotels' => json_decode('[{'.rtrim($umrahUBC,',').'}]')
                    ],
                ]);
            }
        }
        return Inertia::render('Backend/Umrah/UmrahUBC', ["umrahUBCs" => $collection]);
    }
    
    public function __calc_week_wkend_days($checkIn, $checkOut)
    {
        if (!empty($checkIn) && !empty($checkOut)):
            $startDate = date('d-m-Y', strtotime($checkIn));
            $endDate = date('d-m-Y', strtotime($checkOut));
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

    public function __umrahSector($umrahSectorId){
        $umrahSector =  $this->umrahTransportSectorService->fetch(['id' => $umrahSectorId]);
        return $umrahSector->sectorName;
    }
    public function __umrahVehicle($umrahVehicleId){
        $umrahVehicle =  $this->umrahVehicleService->fetch(['id' => $umrahVehicleId]);
        return $umrahVehicle->vehicleName;
    }
}
