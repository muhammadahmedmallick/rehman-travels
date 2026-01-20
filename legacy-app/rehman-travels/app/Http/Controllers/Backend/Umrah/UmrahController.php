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
        $umrahBookingCustomers = $this->umrahBookingCustomerService->allOrderBy(['*'], ['UmrahBookings', 'Customers', 'UmrahTicketFare'], "id", "DESC");
        $collection = new Collection();
        foreach($umrahBookingCustomers as $umrahBookingCustomer){
            $adultsCount  = $umrahBookingCustomer['adultsCount'];
            $childrenCount  = $umrahBookingCustomer['childrenCount'];
            $infantsCount  = $umrahBookingCustomer['infantsCount'];
            $totalTravellers = ($adultsCount + $childrenCount + $infantsCount);
            $umrahUBC = '';
            foreach($umrahBookingCustomer->UmrahBookings as $umrahIndex => $umrahBooking){
                $hotelDetails = $this->umrahHotelService->fetch(['id' => $umrahBooking["hotelId"]]);
                $hotelCheckIn = Carbon::parse($umrahBooking['checkIn']);
                $hotelCheckOut = Carbon::parse($umrahBooking['checkOut']);
                $doubleRoom = $umrahBooking['doubleRoom'];
                $tripleRoom = $umrahBooking['tripleRoom'];
                $quadRoom = $umrahBooking['quadRoom'];
                $quintRoom = $umrahBooking['quintRoom'];
                $totalNights = 
                $totalNights = $hotelCheckIn->diffInDays($hotelCheckOut);
                // dd($hotelDetails);
                if($hotelDetails){
                    $umrahUBC .= '
                    "'.$umrahIndex.'": {
                        "hotelLocation":"'.$umrahBooking["location"].'",
                        "hotelName":"'.$hotelDetails["hotelName"].'",
                        "basisType":"'.UmrahHelper::__checkBasis($hotelDetails["basisType"]).'",
                        "hotelType":"'.$hotelDetails["hotelType"].'",
                        "checkIn":"'. date("d-m-Y", strtotime($umrahBooking["checkIn"])) .'",
                        "checkOut": "'.date("d-m-Y", strtotime($umrahBooking["checkOut"])).'",
                        "doubleRoom": "'.$doubleRoom.'",
                        "tripleRoom": "'.$tripleRoom.'",
                        "quadRoom": "'.$quadRoom.'",
                        "quintRoom": "'.$quintRoom.'",
                        "hotelTotalPrice": "'.$umrahBooking["hotelTotalPrice"].'",
                        "totalNights" : "'.$totalNights.'"
                    },';
                }
            }
            $umrahUBC = rtrim($umrahUBC,',');
            if($umrahBookingCustomer){
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
                        "umrahSector" => ($umrahBookingCustomer['transport'] != 0 ? $this->__umrahSector($umrahBookingCustomer['umrahSectorId']) : 'Sector Not included in the Package.'),
                        "umrahVehicle" => ($umrahBookingCustomer['transport'] != 0 ? $this->__umrahVehicle($umrahBookingCustomer['umrahVehicleId']) : 'Transport Not Included in the Package.'),
                        "totalTravellers" => $totalTravellers,
                        "visaPriceInclude" => (!empty($umrahBookingCustomer['umrahVisaPrice']) && $umrahBookingCustomer['umrahVisaPrice'] > 0 ? " included for" :  " not included for"),
                        "visaPrice" => (!empty($umrahBookingCustomer['umrahVisaPrice']) && $umrahBookingCustomer['umrahVisaPrice'] > 0 ? $umrahBookingCustomer['umrahVisaPrice'] :  ''),
                        "umrahVehiclePrice" => (!empty($umrahBookingCustomer['umrahVehiclePrice']) ? $umrahBookingCustomer['umrahVehiclePrice'] :  ''),
                        "totalNights" => $umrahBookingCustomer['totalNight'],
                        "totalPrice" => $umrahBookingCustomer['totalPrice'],
                        "adultFare" => (!empty($umrahBookingCustomer->UmrahTicketFare) && count($umrahBookingCustomer->UmrahTicketFare) > 0 ? $umrahBookingCustomer->UmrahTicketFare[0]['adultPrice']: 0),
                        "childFare" => (!empty($umrahBookingCustomer->UmrahTicketFare) && count($umrahBookingCustomer->UmrahTicketFare) > 0 ? $umrahBookingCustomer->UmrahTicketFare[0]['childPrice'] : 0),
                        "infantFare" => (!empty($umrahBookingCustomer->UmrahTicketFare) && count($umrahBookingCustomer->UmrahTicketFare) > 0 ? $umrahBookingCustomer->UmrahTicketFare[0]['infantPrice'] : 0),
                        "totalPriceWithFare" => (!empty($umrahBookingCustomer->UmrahTicketFare) && count($umrahBookingCustomer->UmrahTicketFare) > 0 ? ($umrahBookingCustomer['totalPrice'] + $umrahBookingCustomer->UmrahTicketFare[0]['adultPrice'] + $umrahBookingCustomer->UmrahTicketFare[0]['childPrice'] + $umrahBookingCustomer->UmrahTicketFare[0]['infantPrice']) : ''),
                        'hotels' => json_decode('[{'.rtrim($umrahUBC,',').'}]')
                    ],
                ]);
            }
        }
        return Inertia::render('Backend/Umrah/UmrahUBC', ["umrahUBCs" => $collection]);
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
