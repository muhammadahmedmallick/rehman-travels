<?php

namespace App\Http\Controllers\Backend\Banks;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\Banks\BankDetailServices;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class BankController extends Controller
{
    protected $bankDetailServices;
    public function __construct(BankDetailServices $bankDetailServices){
        $this->bankDetailServices = $bankDetailServices;
    }
    public function index(){
        try{
            $bankDetails = $this->bankDetailServices->all(['*']);
            if($bankDetails):
                return Inertia::render('Backend/Banks/BankDetails', ['bankDetails' => $bankDetails]);
            else:
                return back()->with(['errorType' => true, 'message' => 'No Data found Against the search.']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType' => true, 'message' => $ex->getMessage()]);
        }catch(\Throwable $ex){
            return back()->with(['errorType' => true, 'message' => $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType' => true, 'message' => $ex->getMessage()]);
        }
    }
    public function storeBankAccount(Request $request){
        try{
            $bankDetailsData = $request['formData'];
            if (!empty($bankDetailsData['bankLogo'])) {
                $cardImage = $bankDetailsData['bankLogo'];
                $getCardName = $cardImage->getClientOriginalName();
                $cardImage->storeAs('BankLogo', $getCardName, 'public');
            }
            if($bankDetailsData['method'] == "PUT"):
                $bankDetailsData =  $this->bankDetailServices->update($bankDetailsData['id'], $bankDetailsData);
            else:
                $bankDetailsData = $this->bankDetailServices->store($bankDetailsData);
            endif;
            if($bankDetailsData):
                return back()->with(['errorType' => false, 'message' => 'Bank Data Inserted Successfully.']);
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
}
