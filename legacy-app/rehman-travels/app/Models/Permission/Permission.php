<?php

namespace App\Models\Permission;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Session;

class Permission extends Model {

    use HasFactory;

    protected static function findAll($request) {
        try {
            return Permission::get();
        } catch (\Exception $e) {
            return array(
                "error" => "Error Occurred",
                "errorType" => "true"
            );
        }
    }

    protected static function __create($request) {
//        self::__delete($request->agentId, $request->parentId, $request->userId);
        DB::beginTransaction();
        try {
            if (!empty($request->permissionIds)):
                $permission = new Permission();
                $data = array();
                foreach ($request->permissionIds as $permissionId):
                    $data[] = array(
                        'postbyId' => Session::get('activeId'),
                        'postbyType' => Session::get('activeType'),
                        'agentId' => $request->agentId,
                        'parentId' => $request->parentId,
                        'userId' => $request->userId,
                        'permissionId' => $permissionId,
                        'assignType' => (!empty($request->userId) ? 'user' : 'agent'),
                        'created_at' => date('Y-m-d h:i:s'),
                        'updated_at' => date('Y-m-d h:i:s')
                    );
                endforeach;
//                activity_logs::__create_activity_log('Permission', 'New Permission', json_encode($data));
                $permission->insert($data);
                DB::commit();
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


//        DB::beginTransaction();
//        try {
//            if (self::duplicateEntry(['moduleType' => $request->moduleType, 'title' => $request->title]) > 0):
//                return array(
//                    "error" => "Can't create Module Type and Title that already exists",
//                    "errorType" => "true"
//                );
//            else:
//                $permission_type = new Permission();
//                $permission_type->title = $request->title;
//                $permission_type->moduleType = $request->moduleType;
//                $permission_type->postbyId = Session::get('activeId');
//                $permission_type->postbyType = Session::get('activeType');
////                activity_logs::__create_activity_log('Permission Type', 'create', $permission_type);
//                $permission_type->save();
//                DB::commit();
//                return array(
//                    "success" => "Permission has been Added Successfully",
//                    "errorType" => "false"
//                );
//            endif;
//        } catch (\Exception $e) {
//            DB::rollback();
//            return array(
//                "error" => "Error Occurred",
//                "errorType" => "true"
//            );
//        }
    }

    protected static function duplicateEntry($where = array()) {
        return self::where($where)->count();
    }

    protected static function updatePermissionType($request) {
        DB::beginTransaction();
        try {
            $permission_type = self::find($request->permissionTypeId);
            $permission_type->title = $request->title;
            $permission_type->moduleType = $request->moduleType;
            $permission_type->postbyId = Session::get('activeId');
            $permission_type->postbyType = Session::get('activeType');
//            activity_logs::__create_activity_log('Permission Type', 'update', $permission_type);
            $permission_type->save();
            DB::commit();
            return true;
        } catch (\Exception $e) {
            DB::rollback();
            return 'Message' . $e->getMessage() . 'File' . $e->getFile() . 'Line' . $e->getLine();
        }
    }

    protected static function findPermissionTypeById($permissionTypeId) {
        $permission_type = self::find($permissionTypeId);
//        activity_logs::__create_activity_log('Permission Type', 'edit', $permission_type);
        return $permission_type;
    }

    protected static function deletePermissionType($request) {
        DB::beginTransaction();
        try {
            $permission_type = self::find($request->permissionTypeId);
//            activity_logs::__create_activity_log('Permission Type', 'Delete', $permission_type->get());
            $permission_type->delete();
            DB::commit();
            return true;
        } catch (\Exception $e) {
            DB::rollback();
            return 'Message' . $e->getMessage() . 'File' . $e->getFile() . 'Line' . $e->getLine();
        }
    }

}
