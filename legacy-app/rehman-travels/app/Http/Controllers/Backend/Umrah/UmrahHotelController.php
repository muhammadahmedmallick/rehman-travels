<?php

namespace App\Http\Controllers\Backend\Umrah;

use App\Http\Controllers\Controller;
use App\Services\Umrah\UmrahHotelService;
use App\Services\Umrah\UmrahHotelImageService;
use App\Services\Umrah\UmrahHotelRoomPeriodService;
use App\Services\Umrah\UmrahHotelRoomPriceService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use App\Models\Umrah\UmrahHotel;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Auth;
use App\Libraries\rest_api\TicketingEmailProvider;
use App\Services\Hotels\HotelMarkupServices;


class UmrahHotelController extends Controller {
    protected $umrahHotelService;
    protected $umrahHotelImageService;
    protected $umrahHotelRoomPeriodService;
    protected $umrahHotelRoomPriceService;
    protected $markupServices;
    
    public function __construct(HotelMarkupServices $markupServices, UmrahHotelService $umrahHotelService, UmrahHotelRoomPeriodService $umrahHotelRoomPeriodService, UmrahHotelImageService $umrahHotelImageService, UmrahHotelRoomPriceService $umrahHotelRoomPriceService){
        $this->umrahHotelService = $umrahHotelService;
        $this->umrahHotelRoomPeriodService = $umrahHotelRoomPeriodService;
        $this->umrahHotelRoomPriceService = $umrahHotelRoomPriceService;
        $this->umrahHotelImageService = $umrahHotelImageService;
        $this->markupServices = $markupServices;
    }

    public function index(Request $request){
        $hotelDetails = $this->umrahHotelService->all(['*'], ['hotelImages', 'hotelRoomPeriods', 'hotelUsers']);
        $collection = new Collection();
        foreach ($hotelDetails as $hotel):
            $hotelImages = array();
            foreach ($hotel->hotelImages as $hotelImage):
                $hotelImages[] = [
                "id" => $hotelImage["id"],
                "hotelId" => $hotelImage["hotelId"],
                "hotelImage" => $hotelImage["hotelImage"],
                "hotelRoomType" => $hotelImage["hotelRoomType"],
                "hotelRoomImageStatus" => $hotelImage["hotelRoomImageStatus"]
              ];
            endforeach;
            $periods ='';
            $hotelRoomPeriods = $hotel->hotelRoomPeriods()->where(['periodStatus' => '1'])->get();
            foreach ($hotelRoomPeriods as $hotelRoomPeriod):
                $periods .= '{
                "Period": {
                    "id": "'.$hotelRoomPeriod['id'].'",
                    "periodFrom": "'.$hotelRoomPeriod['periodFrom'].'",
                    "hotelId": "'.$hotelRoomPeriod['hotelId'].'",
                    "periodTo": "'.$hotelRoomPeriod['periodTo'].'",
                    "ashraType": "'.$hotelRoomPeriod['ashraType'].'",
                    "periodStatus": "'.$hotelRoomPeriod['periodStatus'].'"
                },';
                foreach ($hotelRoomPeriod->hotelRoomPrices as $hotelRoomPrice):
                    $periods .= '
                        "'.$hotelRoomPrice['roomType'].'": {
                            "id":"'.$hotelRoomPrice["id"].'",
                            "periodId":"'.$hotelRoomPrice["periodId"].'",
                            "roomType": "'.$hotelRoomPrice['roomType'].'",
                            "onDayPrice": "'.$hotelRoomPrice['onDayPrice'].'",
                            "onDayMarkup": "'.$hotelRoomPrice['onDayMarkup'].'",
                            "offDayPrice": "'.$hotelRoomPrice['offDayPrice'].'",
                            "offDayMarkup": "'.$hotelRoomPrice['offDayMarkup'].'"
                     },';
                endforeach;
                $periods = rtrim($periods,',');
                $periods .= '},';
            endforeach;
            $collection->push((object)[
                'hotelDetail' => [
                    'hotel' => [
                        "id" => $hotel['id'],
                        "postById" => $hotel['postById'],
                        "hotelName" => $hotel['hotelName'],
                        "vendorName" => $hotel['vendorName'],
                        "hotelLocation" => $hotel['hotelLocation'],
                        "hotelDistance" => $hotel['hotelDistance'],
                        "basisType" => $hotel['basisType'],
                        "hotelType" => $hotel['hotelType'],
                        "hotelDesc" => $hotel['hotelDesc'],
                        "markup" => $hotel['markup'],
                        "hotelStatus" => $hotel['hotelStatus'],
                        "created_user" => ($hotel->hotelUsers ? $hotel->hotelUsers['userName'] : '-'),
                        "created_at" => ($hotel['created_at'] ? date('d-m-Y H:i:s', strtotime($hotel['created_at'])) : '-'),
                        "updated_at" => ($hotel['updated_at'] && !is_null($hotel['updated_at']) ? date('d-m-Y H:i:s', strtotime($hotel['updated_at'])) : '-')
                    ],
                    'hotelImages' => $hotelImages,
                    'hotelRoomPeriodPrices' => json_decode('['.rtrim($periods,',').']')
            ]]);
        endforeach;
        try{
            return Inertia::render('Backend/Umrah/Hotel',['hotels' => $collection]);
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    
    public function show(Request $request){
        try{
            $currencies = $this->umrahHotelService->all();
            return Inertia::render('Backend/Currency/Show', [
                'currencies' => $currencies,
            ]);
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }

    public function create(Request $request){
        try{
            $hotel = array();
            foreach ($request['hotelDetails'] as $hotelDetailKey => $hotelDetail):
                if($hotelDetailKey == 'hotel'):
                $hotel = $this->umrahHotelService->store($hotelDetail);
                // elseif ($hotelDetailKey == 'hotelRoomImages'):
                //     foreach ($hotelDetail as  $hotelRoomImage):
                //         $hotel->hotelImages()->create($hotelRoomImage);
                //     endforeach;
                elseif ($hotelDetailKey == 'hotelPeriodAndRoomTypePrices'):
                    foreach ($hotelDetail as  $hotelPeriodAndRoomTypePrices):
                        $period = array();
                        foreach ($hotelPeriodAndRoomTypePrices as $hotelPeriodAndRoomTypePriceKey => $hotelPeriodAndRoomTypePrice):
                            if ($hotelPeriodAndRoomTypePriceKey == 'Period'):
                                $period = $hotel->hotelRoomPeriods()->create($hotelPeriodAndRoomTypePrice);
                            else:
                               $period->hotelRoomPrices()->create($hotelPeriodAndRoomTypePrice);
                            endif;
                        endforeach;
                    endforeach;
                endif;
            endforeach;
            if ($hotel) :
                return back()->with(['errorType' => false, 'message' => 'Hotel Is added successfully']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable added Hotel']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }

    public function edit($id){
        try{
            $currency = $this->umrahHotelService->find($id);
            if ($currency) :
                return Inertia::render('Backend/Currency/Show', [
                    'currency' => $currency,
                ]);
            else:
                return back()->with(['errorType' => false, 'message' => 'Failed! unable to Edit Currency']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }

    public function update(Request $request){
        try{
            $hoteldet = $request['hotelDetails'];
            $currentUser = Auth::User();
            self::updateEmailPattern($hoteldet, $currentUser);
            $hoteldet['hotelPeriodAndRoomTypePrices'] = (count($hoteldet['deleteHotelRoom']) > 0 ? array_merge($hoteldet['hotelPeriodAndRoomTypePrices'], $hoteldet['deleteHotelRoom']) : $hoteldet['hotelPeriodAndRoomTypePrices']);
            $umrahHotelRoomPriceStore = '';
            foreach ($hoteldet as $hotelDetailKey => $hotelDetail){
                if(!empty($hotelDetail['id'])){
                    $hotel = $this->umrahHotelService->update($hotelDetail['id'], $hotelDetail);
                    foreach ($hoteldet['hotelPeriodAndRoomTypePrices'] as $hotelPeriodAndRoomTypePrices):
                        foreach ($hotelPeriodAndRoomTypePrices as $hotelPeriodAndRoomTypePriceKey => $hotelPeriodAndRoomTypePrice):
                            if ($hotelPeriodAndRoomTypePriceKey == "Period"):
                                if($hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['id']):
                                    $this->umrahHotelRoomPeriodService->update($hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['id'], $hotelPeriodAndRoomTypePrice);
                                else:
                                    $arrPeriods = array(
                                        "hotelId" => $hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['hotelId'],
                                        "periodFrom" => $hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['periodFrom'],
                                        "periodTo" => $hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['periodTo'],
                                        "ashraType" => $hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['ashraType'],
                                        "periodStatus" => $hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['periodStatus']
                                    );
                                    $umrahHotelRoomPriceStore = $hotel->hotelRoomPeriods()->create($arrPeriods);
                                endif;
                            endif;
                            if($hotelPeriodAndRoomTypePriceKey != "Period"):
                                if($hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['id']):
                                    $this->umrahHotelRoomPriceService->update($hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['id'], $hotelPeriodAndRoomTypePrice);
                                else:
                                    $arrRooms = array(
                                        "periodId" => $umrahHotelRoomPriceStore['id'],
                                        "roomType" => $hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['roomType'],
                                        "onDayPrice" => $hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['onDayPrice'],
                                        "onDayMarkup" => $hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['onDayMarkup'],
                                        "offDayPrice" => $hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['offDayPrice'],
                                        "offDayMarkup" => $hotelPeriodAndRoomTypePrices[$hotelPeriodAndRoomTypePriceKey]['offDayMarkup']
                                    );
                                    $umrahHotelRoomPriceStore->hotelRoomPrices()->create($arrRooms);
                                endif;
                            endif;
                        endforeach;
                    endforeach;
                    foreach ($hoteldet['hotelRoomImages'] as $hotelRoomImageIndex => $hotelRoomImage):
                        if(!empty($hoteldet['hotelRoomImages']) || $hoteldet['hotelRoomImages'] != "null"):
                            $this->umrahHotelImageService->update($hoteldet['hotelRoomImages'][$hotelRoomImageIndex]['id'], $hotelRoomImage);
                        endif;
                    endforeach;
                }
            }
            if ($hotel) :
                return redirect('Backend/UmrahDashboard/view-all-umrah-hotels')->with(['errorType' => true, 'message' => 'Success! Hotel has been save successfully updated']);
            else:
                return back()->with(['errorType' => false, 'message' => 'Failed! unable to Update Hotel']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    
    public function updateEmailPattern($hoteldet, $currentUser){
        $emailPattern = '
            <p style="border-left: 20px solid #019BDB;color: #002C48;background: #F0F0F0; text-transform: capitalize; font-size: 20px;padding-top: 20px;padding-bottom: 20px;">Umrah Hotel Insert / Update Notification</p>
            <table cellspacing="1" cellpadding="1" border="1" width="98%">
             <tr>
             <td align="center" colspan="18" style="padding: 10px 20px 20px !important;"><i style="color: #888888;font-size: 24px;">'.$hoteldet['hotel']['hotelName'].'</i></td>
             </tr>
             <tr>
             <td align="center" style="background: #e7b401;color: #000; padding: 5px;">Location:</td>
             <td style="background: #e7b401;color: #000; padding: 5px;"><b>'.$hoteldet['hotel']['hotelLocation'].'</b></td>
             <td align="center" style="background: #e7b401;color: #000; padding: 5px;">Hotel Type:</td>
             <td style="background: #e7b401;color: #000; padding: 5px;"><b>'.$hoteldet['hotel']['hotelType'].' Star</b></td>
             <td align="center" style="background: #e7b401;color: #000; padding: 5px;">Basis :</td>
             <td colspan="2" style="background: #e7b401;color: #000; padding: 5px;"><b>'.$hoteldet['hotel']['basisType'].'</b></td>
             <td align="center" colspan="2" style="background: #e7b401;color: #000; padding: 5px;">Hotel Vendor :</td>
             <td colspan="2" style="background: #e7b401;color: #000; padding: 5px;"><b>'.$hoteldet['hotel']['vendorName'].'</b></td>
             <td align="center" colspan="2" style="background: #e7b401;color: #000; padding: 5px;">Status :</td>
             <td colspan="5" style="background: #e7b401;color: #000; padding: 5px;"><b>'.($hoteldet['hotel']['hotelStatus'] == '0' ? 'Disable' : 'Active').'</b></td>
             </tr><tr>
             <td align="center" style="background: #009bdb;color: #fff; padding: 5px;" rowspan="2"><b>Date From</b></td>
             <td align="center" style="background: #009bdb;color: #fff; padding: 5px;" rowspan="2"><b>Date To</b></td>
             <td align="center" style="background: #009bdb;color: #fff; padding: 5px;" colspan="4"><b>Double Room</b></td>
             <td align="center" style="background: #009bdb;color: #fff; padding: 5px;" colspan="4"><b>Triple Room</b></td>
             <td align="center" style="background: #009bdb;color: #fff; padding: 5px;" colspan="4"><b>Quad Room</b></td>
             <td align="center" style="background: #009bdb;color: #fff; padding: 5px;" colspan="4"><b>Quint Room</b></td>
             </tr>
             <tr>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>Actual Price</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>With %</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>Weekend</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>Weekend %</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>Actual Price</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>With %</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>Weekend</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>Weekend %</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>Actual Price</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>With %</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>Weekend</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>Weekend %</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>Actual Price</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>With %</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>Weekend</b></td>
             <td align="center" style="background: #e7b401;padding: 5px;"><b>Weekend %</b></td>
             </tr>';
                foreach($hoteldet['hotelPeriodAndRoomTypePrices'] as $hotelPeriodAndRoomTypePrices ):
                 $emailPattern .= '
                      <tr style="background-color:  #f9fafb;">
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem">'.$hotelPeriodAndRoomTypePrices['Period']['periodFrom'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem">'.$hotelPeriodAndRoomTypePrices['Period']['periodTo'].'</td>
                        
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Double']['onDayPrice'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Double']['onDayMarkup'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Double']['offDayPrice'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Double']['offDayMarkup'].'</td>
                        
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Triple']['onDayPrice'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Triple']['onDayMarkup'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Triple']['offDayPrice'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Triple']['offDayMarkup'].'</td>
                        
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Quad']['onDayPrice'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Quad']['onDayMarkup'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Quad']['offDayPrice'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Quad']['offDayMarkup'].'</td>
                        
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Quint']['onDayPrice'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Quint']['onDayMarkup'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Quint']['offDayPrice'].'</td>
                        <td style="border: 1px solid #e5e7eb; padding: 0.5rem; text-align: right">'.$hotelPeriodAndRoomTypePrices['Quint']['offDayMarkup'].'</td>
                      </tr>
                 ';
                
                endforeach;
                $emailPattern .= '
                <tr>
                 <td align="left" colspan="6" style="background: #e7b401;color: #000; padding: 5px;">Inserted / Updated By: <b>'.$currentUser['userName'].'</b></td>
                 <td align="center" colspan="4" style="background: #e7b401;color: #000; padding: 5px;">Email : <b>'.$currentUser['email'].'</b></td>
                 <td align="right" colspan="8" style="background: #e7b401;color: #000; padding: 5px;">Create / Update Date Time : <b>'.date('d-M-Y h:i:s A').'</b></td>
                </tr>
              </table>';
          self::sendEmail($hoteldet['hotel']['hotelName'], $emailPattern);
    }
    
    public function sendEmail($firstName, $packageHtml){
        try{
            TicketingEmailProvider::umrahOrderCreateMail([
                "to" => ['khalidjavid@exalted.pk'],
                "unlink" => true,
                "name" => [$firstName],
                "phoneNumber" => ['03425332275'],
                "subject" => ['Umrah Hotel Notification: '.$firstName ],
                "body" => [
                    'packageHtml' => $packageHtml
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

    public function addmarkupToSelectedHotels(Request $request){
        if($request['markupInput'] && $request['markupInput']['markup_value']){
            $markupDetails = $this->markupServices->store($request['markupInput']);
            foreach($request['hotel']['selectedHotelIds'] as $selectedHotelIds){
                $hotel = $this->umrahHotelService->single(['id' => $selectedHotelIds]);
                $newMarkup = ($hotel ? ((int)$hotel['markup'] + $request['markupInput']['markup_value']) : (int)$hotel['markup']);
                $hotel = $this->umrahHotelService->update($selectedHotelIds, ['markup' => $newMarkup]);
                $periods = $this->umrahHotelRoomPeriodService->whereQuery(['hotelId' => $selectedHotelIds]);
                if($periods){
                    foreach($periods as $period){
                        $periodprices = $this->umrahHotelRoomPriceService->whereQuery(['periodId' => $period['id']]);
                        foreach($periodprices as $periodprice){
                            $arrRooms = array(
                                "periodId" =>$periodprice['periodId'],
                                "roomType" => $periodprice['roomType'],
                                "hotel_markup_id" => $markupDetails['id'],
                                "onDayMarkup" => ($periodprice['onDayPrice'] > 0 ? (self::setExtraMarkup($periodprice['onDayPrice'], $newMarkup)) : 0),
                                "offDayMarkup" => ($periodprice['offDayPrice'] > 0 ? (self::setExtraMarkup($periodprice['offDayPrice'], $newMarkup)) : 0),
                            );
                            $this->umrahHotelRoomPriceService->update($periodprice['id'], $arrRooms);
                        }
                    }
                }
            }
            if($markupDetails){
                return response()->json(['error' => false, 'message' => 'Markup is added successfully.']);
            }else 
            {
                return response()->json(['error' => true, 'message' => 'Error, while adding Markup.']);
            }
        }else{
            return response()->json(['error' => true, 'message' => 'Error, while adding Markup.']);
        }
    }

    public function setExtraMarkup($value, $markupValue){
        if(!empty($value) && !empty($markupValue)){
            $newPrice = round(($value * $markupValue) / 100);
            return $value + $newPrice;
        }
    }

    public function delete($id){
        try{
            // dd($id);
            $currency = $this->umrahHotelService->delete($id);
            if ($currency) :
                return back()->with(['errorType' => false, 'message' => 'Failed! Currency Deleted Successfully!']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Delete Currency']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    
}
