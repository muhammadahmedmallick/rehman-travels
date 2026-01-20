<?php

namespace App\Http\Controllers\Backend\ArabianOryx;

use App\Http\Controllers\Controller;
use App\Services\Hotels\HotelMarkupServices;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ManageMarkupController extends Controller
{
    protected $markupServices;

    public function __construct(HotelMarkupServices $markupServices)
    {
        $this->markupServices = $markupServices;
    }
    public function index(){
        $markupDetails = $this->markupServices->all(['*'], ['users']);
        $markups = array();
        foreach($markupDetails as $markupDetail){
            $markups[] = [
                'id' => $markupDetail['id'],
                'markup_type' => $markupDetail['markup_type'],
                'markup_value' => $markupDetail['markup_value'],
                'markup_status' => $markupDetail['markup_status'],
                'currency_id' => $markupDetail['currency_id'],
                'currency_rate' => $markupDetail['currency_rate'],
                'currency_code' => $markupDetail['currency_code'],
                'converted_value' => $markupDetail['converted_value'],
                'vendor' => $markupDetail['vendor'],
                'created_user' => $markupDetail['users']['userName'],
                'created_by' => $markupDetail['created_by'],
                'created_at' => date('d-m-Y H:i:s' , strtotime($markupDetail['created_at'])),
            ];
        }
        return Inertia::render('Backend/ArabianOryx/HotelMarkup', ['markups' => $markups]);
    }

    public function store(Request $req)
    {
        $input = $req['input'];
        if($req){
           $markup = $this->markupServices->store($input);
        }else{
            return back()->with(['errorType'=> true, 'message' => 'data is added successfully.']);
        }
    }

    public function update(Request $req)
    {
        $input = $req['input'];
        if($input){
            $this->markupServices->update($input['id'], $input);
        }else{
            return back()->with(['errorType'=> true, 'message' => 'data is updated successfully.']);
        }
    }

    public function destroy($id)
    {
        if(!empty($id)){
            $destoryMarkupServices =  $this->markupServices->delete($id);
         }else{
             return back()->with(['errorType'=> true, 'message' => 'data is not removed successfully.']);
         }
    }
}
