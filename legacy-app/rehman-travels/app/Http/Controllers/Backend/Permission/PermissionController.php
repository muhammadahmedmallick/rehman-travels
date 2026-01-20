<?php

namespace App\Http\Controllers\Backend\Permission;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Session;
use App\Models\Permission\Permission;
use App\Models\Permission\PermissionAssign;
class PermissionController extends Controller
{

    public function __construct()
    {
        $this->middleware('auth:agent,user');
    }

    public function index(Request $request)
    {
        $prefix = $request->route()->getPrefix();
        if (!empty(Session::get('vendorId') && $prefix == '/b2b/permission')):
            return Inertia::render('Backend/Permission/View');
        else:
            return Inertia::render('404');
        endif;
    }

    public function findAll(Request $request){
        try {
            $permissions = Permission::findAll($request);
            $collections = [];
            $moduleTypes = array('Agent', 'SubAgent', 'User', 'Ticketing', 'Markup','Permission','Payment','Umrah','Visa','Hajji','Hotel','Airlines','Progress Report','World Tours','Pakistan Tours');
            foreach ($moduleTypes as $moduleType):
                foreach ($permissions as $permission):
                    if ($permission->moduleType == "All"):
                        $collections[$moduleType][$permission->id] = [
                            "title" => $permission->title,
                            "value"=> $moduleType.$permission->id,
                        ];
                    endif;
                    if (strpos($permission->moduleType, ",") !== false && $permission->moduleType != "All"):
                        foreach(explode(",",$permission->moduleType) as $explodeModuleType):
                            $collections[$explodeModuleType][$permission->id] = [
                                "title" => $permission->title,
                                "value"=> $explodeModuleType.$permission->id,
                            ];
                        endforeach;
                    endif;
                    if ($moduleType == "Ticketing" && $permission->moduleType != "All"):
                        $collections['Ticketing'][$permission->id] = [
                            "title" => $permission->title,
                            "value"=> $moduleType.$permission->id,
                        ];
                    endif;
                endforeach;
            endforeach;
            $permissionAssigns = PermissionAssign::findAll($request);
            $assigns = [];
            foreach ($permissionAssigns as $permissionAssign):
                $assigns[$permissionAssign->moduleType.$permissionAssign->permissionId] = $permissionAssign->moduleType.$permissionAssign->permissionId;
            endforeach;
            return array(
                "errorType" => "false",
                'permissions' => $collections,
                'permissionAssigns' => $assigns
            );
        } catch (\Exception $e) {
            return response()->json($e->getMessage());
        }
    }

    public function create(Request $request)
    {
        try {
            $input = (object)$request->all();
            return PermissionAssign::__create($request);
        } catch (\Exception $e) {
            return response()->json($e->getMessage());
        }
    }

}
