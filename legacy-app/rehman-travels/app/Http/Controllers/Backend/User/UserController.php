<?php

namespace App\Http\Controllers\Backend\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;
use Inertia\Inertia;
use App\Models\User\User;

class UserController extends Controller {

    public function __construct() {
        $this->middleware('auth:agent,user');
    }

    public function index(Request $request)
    {
        $prefix = $request->route()->getPrefix();
        if (!empty(Session::get('vendorId') && $prefix == '/b2b/user')):
            return Inertia::render('Backend/User/View');
        else:
            return Inertia::render('404');
        endif;
    }

    public function findAllUsers(Request $request) {
        try {
            $agents = User::findAllUsers($request);
            return array(
                "errorType" => "false",
                'totalRecords' => $agents,
                'totalCounts' => count($agents)
            );
        } catch (\Exception $e) {
            return array(
                "errorType" => "true",
                'totalRecords' => 0,
                'totalCounts' => 0
            );
        }
    }
    public function create(Request $request)
    {
        try {
            return $request;
            $input = (object)$request->all();
            return User::__create($request);
        } catch (\Exception $e) {
            return response()->json($e->getMessage());
        }
    }

    public function update(Request $request) {
        try {
            return $request;
            if(empty($request['id']) || is_null($request['id'])):
                return User::__create($request);
            else:
                return User::__update($request);
            endif;
        } catch (\Exception $e) {
            return back()->withError($e->getMessage())->withInput();
        }
    }

    public function remove($userId) {
        return User::__remove($userId);
    }

    public function profile(Request $request){
        $prefix = $request->route()->getPrefix();
        if (!empty(Session::get('vendorId') && $prefix == '/b2b/user')):
            $profile = User::__profile($request);
            return Inertia::render('Backend/User/Profile/Edit',['profile' =>$profile]);
        else:
            return Inertia::render('404');
        endif;
    }

}
