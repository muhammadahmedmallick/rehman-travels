<?php

namespace App\Models\Permission;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Session;

class PermissionAssign extends Model
{

    use HasFactory;

    protected static function findAll($request)
    {
        try {
            return self::where([
                "agentId" => $request->agentId,
                "parentId" => $request->parentId,
                "userId" => (!empty($request->userId) ? $request->userId : 0),
            ])->get();
        } catch (\Exception $e) {
            return array(
                "error" => "Error Occurred",
                "errorType" => "true"
            );
        }
    }

    protected static function __create($request)
    {
        self::__remove($request);
        try {
            if (!empty($request->permissions)):
                $permissionAssign = new PermissionAssign();
                $data = array();
                foreach ($request->permissions as $permission):
                    $data[] = array(
                        'postbyId' => Session::get('activeId'),
                        'postbyType' => Session::get('activeType'),
                        'agentId' => $request->agentId,
                        'parentId' => $request->parentId,
                        'userId' => (!empty($request->userId) ? $request->userId : 0),
                        'permissionId' => preg_replace('/[a-zA-Z]+/', '', $permission),
                        'moduleType' => preg_replace('/[0-9]+/', '', $permission),
                        'assignType' => (!empty($request->userId) ? 'user' : 'agent'),
                        'created_at' => date('Y-m-d h:i:s'),
                        'updated_at' => date('Y-m-d h:i:s')
                    );
                endforeach;
//                activity_logs::__create_activity_log('Permission', 'New Permission', json_encode($data));
                $permissionAssign->insert($data);
                return array(
                    "success" => "Permission has been Added Successfully",
                    "errorType" => "false"
                );
            endif;
        } catch (\Exception $e) {
            return array(
                "error" => "Error Occurred",
                "errorType" => "true"
            );
        }
    }

    private static function __remove($request)
    {
        return self::where([
            'agentId' => $request['agentId'],
            'parentId' => $request['parentId'],
            'userId' => (!empty($request['userId']) ? $request['userId'] : 0)
        ])->delete();
    }

    protected static function loggedInUserPermission($agentId,$parentId,$userId)
    {
//        $currentLoggedInGuard = Auth::guard('agent');
//        dd( Auth::user());
        $query = DB::table('permission_assigns as pa');
        $query->join('permissions as pr', 'pr.id', '=', 'pa.permissionId');
        $query->select('pr.id', 'pr.title', 'pa.agentId', 'pa.parentId', 'pa.userId', 'pa.moduleType', 'pa.permissionId');
        $query->where(['pa.agentId' => $agentId, 'pa.parentId' => $parentId, 'pa.userId' => $userId]);
        if ($query->count() > 0):
            $permissions = array();
            foreach ($query->get() as $row_set):
                $permissions[$row_set->moduleType][str_replace(" ", "", $row_set->title)] = 1;
            endforeach;
            return $permissions;
        endif;
    }
}
