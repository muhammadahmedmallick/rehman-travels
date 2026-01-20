<?php

namespace App\Http\Controllers\Website\ArabianOryx;

use App\Http\Controllers\Controller;
use App\Libraries\ArabianOryx\HotelLibrary;
use App\Services\Customer\CustomerService;
use App\Services\Hotels\HotelBookingCustomersServices;
use App\Services\Hotels\HotelShoppingConfirmationServices;
use Illuminate\Http\Request;

class ArabianOryxShoppingOrderCreateController extends Controller
{
    protected $hotelBookingCustomersServices;
    protected $customerService;
    protected $hotelBookingConfirmation;

    public function __construct(HotelBookingCustomersServices $hotelBookingCustomersServices, CustomerService $customerService, HotelShoppingConfirmationServices $hotelBookingConfirmation)
    {
        $this->hotelBookingCustomersServices = $hotelBookingCustomersServices;
        $this->customerService = $customerService;
        $this->hotelBookingConfirmation = $hotelBookingConfirmation;
    }

    public function arabianOryxOrderCreate(Request $req){
        
        $hotelConfirmation = HotelLibrary::hotelBooking($req);
        // dd($hotelConfirmation);
        \Log::info($hotelConfirmation);
        if(!empty($hotelConfirmation) && empty($hotelConfirmation['errorInfo'])){
            $customerId = self::__checkCustomer($req['contactDetails']);
            foreach($req['persons'] as $personsIndex =>  $personsDetails){
                foreach($personsDetails as $personsDetailKey => $personsDetail){
                    $hotelBookingCustomersData = [
                        'hotel_booking_room_id' => $req['bookingIds'][0][$personsIndex],
                        'hotel_customer_id' => $customerId,
                        'title' => $personsDetail['title'],
                        'firstName' => $personsDetail['firstName'],
                        'lastName' => $personsDetail['lastName'],
                        'age' => $personsDetail['age'],
                        'isLeadPax' => $personsDetail['isLeadPax'],
                    ];
                    $this->hotelBookingCustomersServices->store($hotelBookingCustomersData);
                }
            }
            if($hotelConfirmation['adsConfirmationNumber']){
                $this->hotelBookingConfirmation->store([
                    'confirmation_key' => $hotelConfirmation['adsConfirmationNumber'],
                    'hotel_booking_id' => $req['payload']['bckId'],
                    'hotel_confirmation_status' => $hotelConfirmation['status'],
                    'booking_creation' => $hotelConfirmation['bookingCreation'],
                    'supplier_confirmation_number' => $hotelConfirmation['supplierConfirmationNumber'],
                    'tass_pro_booking_no' => $hotelConfirmation['tassProBookingNo'],
                    'customer_ref_number' => $hotelConfirmation['customerRefNumber'],
                    'registration_number' => (!empty($hotelConfirmation['invoiceCompany']) ? $hotelConfirmation['invoiceCompany']['registrationNumber'] : ''),
                    'inv_company_code' => (!empty($hotelConfirmation['invoiceCompany']) ? $hotelConfirmation['invoiceCompany']['code'] : ''),
                    'inv_company_name' => (!empty($hotelConfirmation['invoiceCompany']) ? $hotelConfirmation['invoiceCompany']['name'] : ''),
                    'accounts' => '',
                    'created_by' => 1,
                ]);
                return array(
                    'error' => false,
                    'data' => $hotelConfirmation['adsConfirmationNumber']
                );
            }else{
                return array(
                    'error' => true,
                    'data' => 'Failed to reserve rooms, hotel Confirmation are not found'
                );
            }
        }else{
            return array(
                'error' => true,
                'data' => (!empty($hotelConfirmation) ? $hotelConfirmation['errorInfo']['description'] : 'Failed to reserve rooms, Please reach us at +923345555121' )
            );
        }
    }

    public function __checkCustomer($customerData)
    {
        $customerNum = $customerData['mobileNo'];
        $customerNum = ltrim($customerNum , "0092");
        $customerNum = ltrim($customerNum , "92");
        $customerNum = ltrim($customerNum , "+92");
        $customerNum = ltrim($customerNum , "0");
        if($customerNum){
            $customerNum = $customerData['countryCode'] . $customerNum;
        }
        $customers = $this->customerService->fetch(["mobileNo" => $customerNum]);
        $customerId = "";
        if(!empty($customers) || !is_null($customers)):
            $customerId = (!empty($customers['id']) ? $customers['id'] : null);
        else:
            $customerInfo = array(
                'mobileNo' => $customerNum,
                'email' => $customerData['email']
            );
            $customers = $this->customerService->store($customerInfo);
            $customerId = $customers['id'];
        endif;
        return $customerId;
    }
}
