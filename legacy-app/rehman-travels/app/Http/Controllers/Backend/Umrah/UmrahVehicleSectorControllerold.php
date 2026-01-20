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


class UmrahVehicleSectorController extends Controller {

    public function __construct(protected UmrahVehiclePriceService $umrahVehiclePriceService,
    protected UmrahTransportSectorService $umrahTransportSectorService, protected UmrahVehicleService $umrahVehicleService){}

    public function index(Request $request){
        try{
            $umrahVehiclesPrices = $this->umrahVehiclePriceService->all(['*'],['umrahTransportSectors','umrahVehicles']);
            $umrahTransportSector = $this->umrahTransportSectorService->all(['id', 'sectorName','sectorStatus']);
            $umrahVehicleService = $this->umrahVehicleService->all(['id','vehicleName', 'vehicleStatus']);
            $collection = new Collection();
            $umrahVehiclesPricesDetails = array();
            foreach($umrahVehiclesPrices as  $umrahVehiclesPrice):
                foreach($umrahVehiclesPrice->umrahTransportSectors as $umrahTransportSectors):
                    $umrahVehiclesPricesDetails[] =[
                        "id" => $umrahVehiclesPrice['id'],
                        "vehicleId" => $umrahVehiclesPrice->umrahVehicles['id'],
                        "sectorId" => $umrahTransportSectors['id'],
                        "vName" => $umrahVehiclesPrice->umrahVehicles['vehicleName'],
                        "sName" => $umrahTransportSectors['sectorName'],
                        "vehiclePrice" => $umrahVehiclesPrice['vehiclePrice'],
                        "vehicleSectorMarkup" => $umrahVehiclesPrice['vehicleSectorMarkup'],
                        "vehicleSectorMrkPrice" => $umrahVehiclesPrice['vehicleSectorMrkPrice'],
                        "vehiclePriceStatus" => $umrahVehiclesPrice['vehiclePriceStatus'],
                        "created_at" => $umrahVehiclesPrice['created_at']
                    ];
                endforeach;
            endforeach;
            $collection->push((object)[
                'vehiclePriceWiseDetails' => $umrahVehiclesPricesDetails
            ]);
            if($umrahVehiclesPricesDetails):
                return Inertia::render('Backend/Umrah/Vehicle', [
                    'vehicles' => $umrahVehiclesPricesDetails,
                    'umrahTransportSectors' => $umrahTransportSector,
                    'umrahVehicleServices' => $umrahVehicleService,
                ]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to retreive Record 500 Error.']);
            endif;
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
            // dd($request['umrahVehicleSectorDetails']);
            $vehiclePriceService = $this->umrahVehiclePriceService->update($request['umrahVehicleSectorDetails']['id'], $request['umrahVehicleSectorDetails']);
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