<?php

namespace App\Http\Controllers\Backend\Umrah;

use App\Http\Controllers\Controller;
use App\Services\Umrah\UmrahVehiclePriceService;
use App\Services\Umrah\UmrahTransportSectorService;
use App\Services\Umrah\UmrahVehicleService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Collection;
use App\Services\Hotels\HotelMarkupServices;
use Illuminate\Support\Facades\Auth;

class UmrahVehicleSectorController extends Controller {

    protected $umrahVehiclePriceService;
    protected $umrahVehicleService;
    protected $umrahTransportSectorService;
    protected $markupServices;


    public function __construct(HotelMarkupServices $markupServices, UmrahVehiclePriceService $umrahVehiclePriceService, UmrahTransportSectorService $umrahTransportSectorService, UmrahVehicleService $umrahVehicleService){
        $this->umrahVehiclePriceService = $umrahVehiclePriceService;
        $this->umrahTransportSectorService = $umrahTransportSectorService;
        $this->umrahVehicleService = $umrahVehicleService;
        $this->markupServices = $markupServices;
    }

    public function index(Request $request){
        try{
            $umrahTransportSectors = $this->umrahTransportSectorService->all(['id', 'sectorName','sectorStatus']);
            $umrahVehicle = $this->umrahVehicleService->all(['id', 'vehicleName']);
            $collection = new Collection();
            $umrahVehiclesPricesDetails = array();
            if(!empty($umrahTransportSectors)){
                
                foreach($umrahTransportSectors as  $umrahTransportSector):
                    $umrahVehiclesPrices = $this->umrahVehiclePriceService->whereRelation([['sectorId', '=', $umrahTransportSector['id']]],['umrahTransportSectors','umrahVehicles']);
                    $vehicle = [];
                    foreach($umrahVehiclesPrices as $umrahVehiclesPrice):
                        $vehicle[] = [
                            "id" => $umrahVehiclesPrice['id'],
                            "vehicleId" => $umrahVehiclesPrice['vehicleId'],
                            "vehicleName" => $umrahVehiclesPrice->umrahVehicles['vehicleName'],
                            "vehiclePrice" => $umrahVehiclesPrice['vehiclePrice'],
                            "vehicleSectorMarkup" => $umrahVehiclesPrice['vehicleSectorMarkup'],
                            "vehicleSectorMrkPrice" => $umrahVehiclesPrice['vehicleSectorMrkPrice'],
                            "vehiclePriceStatus" => $umrahVehiclesPrice['vehiclePriceStatus'],
                        ];
                    endforeach;
                    $umrahVehiclesPricesDetails[] =[
                        "id" => $umrahTransportSector['id'],
                        "sectorId" => $umrahTransportSector['id'],
                        "sectorName" => $umrahTransportSector['sectorName'],
                        "sectorStatus" => ($vehicle ? $umrahTransportSector['sectorStatus'] : '0'),
                        "vehicle" => $vehicle,
                    ];
                endforeach;
                $collection->push((object)[
                    'vehiclePriceWiseDetails' => $umrahVehiclesPricesDetails
                ]);
            }
            return Inertia::render('Backend/Umrah/Vehicle', [
                'vehicles' => $umrahVehiclesPricesDetails,
                'umrahVehicle' => $umrahVehicle
            ]);
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }

    public function addmarkupToSelectedTransport(Request $request){
        $markupDetails = $this->markupServices->store($request['markupInput']);
        foreach($request['transport']['selectedTransportIds'] as $selectedHotelIds){
            $sectorPrices = $this->umrahVehiclePriceService->whereQuery(['sectorId' => $selectedHotelIds]);
            if($sectorPrices){
                foreach($sectorPrices as $sectorPrice){
                    $arrRooms = array(
                        "vehicleId" =>$sectorPrice['vehicleId'],
                        "sectorId" => $sectorPrice['sectorId'],
                        "transport_markup_id" => $markupDetails['id'],
                        "vehiclePrice" => ($sectorPrice['vehiclePrice'] > 0 ? ($request['markupInput'] && $request['markupInput']['markup_type'] === 'fixed' ? ($sectorPrice['vehiclePrice'] + $request['markupInput']['markup_value']) : self::setExtraMarkup($sectorPrice['vehiclePrice'], $request['markupInput']['markup_value'])) : 0),
                        "vehicleSectorMrkPrice" => ($sectorPrice['vehicleSectorMrkPrice'] > 0 ? ($request['markupInput'] && $request['markupInput']['markup_type'] === 'fixed' ? ($sectorPrice['vehicleSectorMrkPrice'] + $request['markupInput']['markup_value']) : self::setExtraMarkup($sectorPrice['vehicleSectorMrkPrice'], $request['markupInput']['markup_value'])) : 0),
                    );
                    $this->umrahVehiclePriceService->update($sectorPrice['id'], $arrRooms);
                }
            }
        }
        if($markupDetails){
            return response()->json(['error' => false, 'message' => 'Markup is added successfully.']);
        }else 
        {
            return response()->json(['error' => true, 'message' => 'Error, while adding Markup.']);
        }
    }

    public function setExtraMarkup($value, $markupValue){
        if(!empty($value) && !empty($markupValue)){
            $newPrice = round(($value * $markupValue) / 100);
            return $value + $newPrice;
        }
    }

    public function show(Request $request){
        try{
            $umrahVehicleService = $this->umrahVehicleService->all();
            if($umrahVehicleService):
                return Inertia::render('Backend/Currency/Show', [
                    'umrahVehicleService' => $umrahVehicleService,
                ]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to create Umrah Vehicle']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    public function newSector(Request $req){
        if(!empty($req)){
            $newSector = [
                'sectorName' => $req['sectorName'],
                'sectorMarkup' => 10,
                'sectorStatus' => $req['sectorStatus'],
            ];
            $umrahTransportSector = $this->umrahTransportSectorService->store($newSector);
            if($umrahTransportSector){
                foreach($req['vehicle'] as $vehicleDetails){
                    $newVehiclePrices = [
                        'vehicleId' => $vehicleDetails['vehicleId'],
                        'sectorId' => $umrahTransportSector['id'],
                        'vehiclePrice' => $vehicleDetails['vehiclePrice'],
                        'vehicleSectorMarkup' => $vehicleDetails['vehicleSectorMarkup'],
                        'vehicleSectorMrkPrice' => $vehicleDetails['vehicleSectorMrkPrice'],
                        'vehiclePriceStatus' => $vehicleDetails['vehiclePriceStatus'],
                        'created_by' => Auth::getUser()->id
                    ];
                    $vehiclePrices = $this->umrahVehiclePriceService->store($newVehiclePrices);
                }
                if($umrahTransportSector){
                    return back()->with(['successType' => true, 'message' => 'Successfully created new']);
                }
            }
        }
    }
    public function create(Request $request){
        try{
            $umrahVehiclePriceService = $this->umrahVehiclePriceService->store($request['umrahVehicleSectorDetails']);
            if ($umrahVehiclePriceService) :
                return back()->with(['errorType' => false, 'message' => 'Success! Umrah Vehicle Price has been save successfully Added']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to create Umrah Vehicle Price']);
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
            $umrahVehiclePrice = $this->umrahVehiclePriceService->find($id);
            if ($umrahVehiclePrice) :
                return Inertia::render('Backend/Umrah/Vehicle', [
                    'umrahVehiclePrice' => $umrahVehiclePrice,
                ]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Edit Currency']);
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
            $vehiclePriceService = '';
            $newSector = [
                'sectorName' => $request['sectorName'],
                'sectorStatus' => $request['sectorStatus'],
            ];
            $umrahTransportSector = $this->umrahTransportSectorService->update($request['id'],$newSector);
            foreach($request['vehicle'] as $vehicleDetails){
                $newVehiclePrices = [
                    'vehicleId' => $vehicleDetails['vehicleId'],
                    'sectorId' => $umrahTransportSector['id'],
                    'vehiclePrice' => $vehicleDetails['vehiclePrice'],
                    'vehicleSectorMarkup' => $vehicleDetails['vehicleSectorMarkup'],
                    'vehicleSectorMrkPrice' => $vehicleDetails['vehicleSectorMrkPrice'],
                    'vehiclePriceStatus' => $vehicleDetails['vehiclePriceStatus'],
                    'updated_by' => Auth::getUser()->id
                ];
                $vehiclePrices = $this->umrahVehiclePriceService->update($vehicleDetails['id'], $newVehiclePrices);
            }
            if ($vehiclePriceService) :
                return back()->with(['errorType' => false, 'message' => 'Success! Umrah Vehicle Price has been save successfully Updated']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Update Umrah Vehicle Price']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }

    public function delete($id){
        try{
            $umrahVehiclePrice = $this->umrahVehiclePriceService->delete($id);
            if ($umrahVehiclePrice) :
                return redirect('Backend/Umrah/vehicles')->with(['errorType' => true, 'message' => 'Success! Umrah Vehicle Price has been Deleted successfully.']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Delete Umrah Vehicle Price']);
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