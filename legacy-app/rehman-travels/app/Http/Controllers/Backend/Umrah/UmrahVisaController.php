<?php

namespace App\Http\Controllers\Backend\Umrah;

use App\Http\Controllers\Controller;
use App\Services\Umrah\UmrahVisaService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Inertia\Inertia;


class UmrahVisaController extends Controller {

    public function __construct(protected UmrahVisaService $umrahVisaService){}

    public function index(Request $request){
        $visas = $this->umrahVisaService->all();
        try{
            if($visas):
                return Inertia::render('Backend/Umrah/UmrahVisa', [
                    'UmrahVisa' => $visas,
                ]);
            else:
                return back()->with(['errorType' => false, 'message' => 'Failed! unable to load visas']);
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
            $umrahVisa = $this->umrahVisaService->store($request[0]);
            if ($umrahVisa) :
                return redirect('Backend/Umrah/visas')->with(['errorType' => true, 'message' => 'Success! Umrah Visa has been Added successfully']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Add Umrah Visa']);
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
            $umrahVisa = "";
            foreach($request['updateVisaDetail'] as $umrahVisaUpdate):
                $umrahVisa = $this->umrahVisaService->update($umrahVisaUpdate['id'], $umrahVisaUpdate);
            endforeach;
            if ($umrahVisa) :
                return back()->with(['errorType' => false, 'message' => 'Update Umrah Visa']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Update Umrah Visa']);
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
        // dd($id);
        try{
            $umrahVisa = $this->umrahVisaService->delete($id);
            if ($umrahVisa) :
                return redirect('Backend/Umrah/visas')->with(['errorType' => true, 'message' => 'Success! Umrah Visa has been deleted successfully']);
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
}
