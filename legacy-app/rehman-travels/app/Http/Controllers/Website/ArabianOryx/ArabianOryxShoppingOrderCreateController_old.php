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
        $customerId = self::__checkCustomer($req['contactDetails']);
            if($customerId){
                foreach($req['persons'] as $personsIndex =>  $personsDetails){
                    foreach($personsDetails as $personsDetailKey => $personsDetail){
                        $checkExistingGuests = $this->hotelBookingCustomersServices->fetch(['hotel_booking_room_id'=> $req['bookingIds'][0][$personsIndex], 'title' => $personsDetail['title'], 'firstName' => $personsDetail['firstName'], 'lastName' => $personsDetail['lastName'], 'isLeadPax' => $personsDetail['isLeadPax']]);
                        if($checkExistingGuests){
                            $this->hotelBookingCustomersServices->delete($checkExistingGuests['id']);
                        }
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
                // $hotelConfirmation = HotelLibrary::hotelBooking($req);
                // \Log::info($hotelConfirmation);
                $hotelConfirmation = $this->hotelBookingConfirmation->store([
                    'confirmation_key' => '123456789',
                    'hotel_booking_id' => $req['payload']['bckId'],
                    'hotel_confirmation_status' => '2',
                    'booking_creation' => '30122024 14:32',
                    'supplier_confirmation_number' => 'AOXDMY557',
                    'tass_pro_booking_no' => '123456789',
                    'customer_ref_number' => '501728-1249743',
                    'registration_number' => 'CHE566735948',
                    'inv_company_code' => 'CHE566735948',
                    'inv_company_name' => 'asds',
                    'accounts' => '',
                    'created_by' => 1,
                ]);
                if($hotelConfirmation){
                    return array(
                        'error' => false,
                        'data' => '123456789'
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
                    'data' => 'Failed to reserve rooms, Error in Customer Details'
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
