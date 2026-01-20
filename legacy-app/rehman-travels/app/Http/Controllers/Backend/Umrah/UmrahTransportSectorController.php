<?php

namespace App\Http\Controllers\Backend\Umrah;

use App\Http\Controllers\Controller;
use App\Services\Umrah\UmrahTransportSectorService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Collection;


class UmrahTransportSectorController extends Controller {

    public function __construct(protected UmrahTransportSectorService $umrahTransportSectorServiceService){}

    public function index(Request $request){
        try{
            $umrahTransportSector = $this->umrahTransportSectorServiceService->all(['id', 'sectorName','sectorStatus']);
            if($umrahTransportSector):
                return Inertia::render('Backend/Umrah/Vehicle', [
                    'umrahTransportSector' => $umrahTransportSector,
                ]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to create Currency']);
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
            $currencies = $this->umrahTransportSectorServiceService->all();
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
            $umrahVehiclePriceService = $this->umrahTransportSectorServiceService->store($request[0]);
            if ($umrahVehiclePriceService) :
                return redirect('Backend/Umrah/vehicles')->with(['errorType' => true, 'message' => 'Success! Currency has been save successfully Added']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to create Currency']);
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
            $currency = $this->umrahTransportSectorServiceService->find($id);
            if ($currency) :
                return Inertia::render('Backend/Umrah/Vehicle', [
                    'currency' => $currency,
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
            foreach($request['umrahVehicleSectorDetails'] as $umrahVehicleDetails):
                $vehiclePriceService = $this->umrahTransportSectorServiceService->update($umrahVehicleDetails['id'], $umrahVehicleDetails);
            endforeach;
            if ($vehiclePriceService) :
                return redirect('Backend/Umrah/vehicles')->with(['errorType' => true, 'message' => 'Success! Currency has been save successfully updated']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Update Currency']);
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
            $currency = $this->umrahTransportSectorServiceService->delete($id);
            if ($currency) :
                return redirect('Backend/Umrah/vehicles')->with(['errorType' => true, 'message' => 'Success! Currency has been save successfully Delete']);
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
