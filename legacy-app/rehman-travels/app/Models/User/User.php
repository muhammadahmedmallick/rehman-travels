<?php

namespace App\Models\User;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Carbon;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Hash;
use App\Models\Agent\Agent;
use Illuminate\Database\QueryException;


class User extends Model
{

    use HasFactory;

    protected static function findAllUsers($request)
    {
        try {
            $keyword = $request->keyword;
            $query = DB::table('users as u');
            $query->join('agents as a', 'u.agentId', '=', 'a.id');
            $query->join('branches as b', 'u.branchId', '=', 'b.id');
            $query->select('u.*', 'a.userName as agentName', 'a.companyName', 'a.userType as agentType', 'b.branchName');
            if (!empty($keyword)) :
                $query->where(function ($query) use ($keyword) {
                    $query->orWhere('u.email', 'LIKE', "%$keyword%");
                    $query->orWhere('u.userName', 'LIKE', "%$keyword%");
                    $query->orWhere('u.mobileNo', 'LIKE', "%$keyword%");
                    $query->orWhere('u.phoneNo', 'LIKE', "%$keyword%");
                    $query->orWhere('b.branchName', 'LIKE', "%$keyword%");
                    $query->orWhere('u.companyName', 'LIKE', "%$keyword%");
                    $query->orWhere('u.accountStatus', 'LIKE', "%$keyword%");
                    $query->orWhere('u.paymentType', 'LIKE', "%$keyword%");
                    $query->orWhere('a.userType', 'LIKE', "%$keyword%");
                    return $query;
                });
            endif;
            if (!empty($request->accountStatus)):
                $query->orWhere(['u.accountStatus' => $request->accountStatus]);
            endif;
            if (!empty($request->portalType)):
                $query->where(['u.typeOfId' => $request->portalType]);
            endif;
            if (!empty($request->userType)) :
                $query->where(['u.userType' => $request->userType]);
            endif;
            if (!empty($request->paymentType)) :
                $query->where(['u.paymentType' => $request->paymentType]);
            endif;
            $vendorId = Session::get('vendorId');
            $agentId = Session::get('agentId');
            $parentId = Session::get('parentId');
            $userType = Session::get('userType');
            if ($vendorId == 1 && $agentId == 0 && $userType == "owner"):
                $query->where(['u.agentId' => $request->agentId,'u.parentId' => $request->parentId]);
            else:
                $query->where([
                    'u.agentId' => ($vendorId == $request->agentId ? $request->agentId : $vendorId),
                    'u.parentId' => ($vendorId == $request->agentId ? $request->parentId : $parentId)
                ]);
            endif;
            return $query->get();
        } catch (\Exception $e) {
            return 'Messagente' . $e->getMessagente() . 'File' . $e->getFile() . 'Line' . $e->getLine();
        }
    }

    protected static function __create($request)
    {
        DB::beginTransaction();
        try {
            if (self::__duplicate(['userName' => $request->userName]) > 0):
                return array(
                    "error" => "Can't create account for User Name that already exists",
                    "errorType" => "true"
                );
            elseif (self::__duplicate(['email' => $request->email]) > 0):
                return array(
                    "error" => "Can't create account for email address that already exists",
                    "errorType" => "true"
                );
            elseif (self::__agentDuplicate(['email' => $request->email]) > 0):
                return array(
                    "error" => "Can't create account for email address that already exists in Agent",
                    "errorType" => "true"
                );
            elseif (self::__duplicate(['mobileNo' => $request->mobileNo]) > 0):
                return array(
                    "error" => "Can't create account for Mobile No that already exists",
                    "messageType" => "true"
                );
            elseif (self::__agentDuplicate(['mobileNo' => $request->mobileNo]) > 0):
                return array(
                    "error" => "Can't create account for Mobile No that already exists for Agent",
                    "errorType" => "true"
                );
            elseif (self::__duplicate(['phoneNo' => $request->phoneNo]) > 0):
                return array(
                    "error" => "Can't create account for Phone No that already exists",
                    "errorType" => "true"
                );
            elseif (self::__agentDuplicate(['phoneNo' => $request->phoneNo]) > 0):
                return array(
                    "error" => "Can't create account for Phone No that already exists for Agent",
                    "errorType" => "true"
                );
            else:
                $user = new User();
                $user->agentId = $request->agentId;
                $user->parentId = $request->parentId;
                $user->postbyId = Session::get('activeId');
                $user->postbyType = Session::get('activeType');
                $user->userType = $request->userType;
                $user->paymentType = $request->paymentType;
                $user->portalType = $request->portalType;
                $user->accountStatus = $request->accountStatus;
                $user->accountId = $request->accountId;
                $user->userName = $request->userName;
                $user->email = $request->email;
                $user->secretId = Hash::make($request->email);
                $user->clientSecret = Hash::make($request->email . '-' . $request->password);
                $user->grantType = 'exaltedsys_api';
                $user->scope = 'exaltedsys_api';
                $user->password = Hash::make($request->password);
                $user->remember_token = '';
                $user->branchId = $request->branchId;
                $user->mobileNo = $request->mobileNo;
                $user->phoneNo = $request->phoneNo;
                $user->creditLimit = $request->creditLimit;
                $user->tmpCreditLimit = $request->tmpCreditLimit;
                $user->currentCreditLimit = $request->currentCreditLimit;
                $user->address = $request->address;
                $user->save();
//                activity_logs::__create_activity_log('User', 'create', $user);
                DB::commit();
                return array(
                    "error" => "User has been Added Successfully",
                    "errorType" => "false"
                );
            endif;
        } catch (\Exception $e) {
            DB::rollback();
            return array(
                "error" => $e . "User has not been Added Successfully",
                "errorType" => "true"
            );
        }
    }

    protected static function __duplicate($where = array())
    {
        return User::where($where)->count();
    }

    protected static function __agentDuplicate($where = array())
    {
        return Agent::where($where)->count();
    }

    protected static function __update($request)
    {
        DB::beginTransaction();
        try {
            $user = User::find($request->userId);
            $user->agentId = $user->agentId;
            $user->parentId = $user->parentId;
            $user->postbyId = Session::get('activeId');
            $user->postbyType = Session::get('activeType');
            $user->userType = $request->userType;
            $user->portalType = $request->portalType;
            $user->paymentType = $request->paymentType;
            $user->accountStatus = $request->accountStatus;
            $user->accountId = $request->accountId;
            $user->userName = $user->userName;
            $user->email = $user->email;
            $user->password = (!empty($request->password) ? Hash::make($request->password) : $user->password);
            $user->branchId = $request->branchId;
            $user->mobileNo = $user->mobileNo;
            $user->phoneNo = $user->phoneNo;
            $user->creditLimit = $request->creditLimit;
            $user->tmpCreditLimit = $request->tmpCreditLimit;
            $user->currentCreditLimit = $request->currentCreditLimit;
            $user->address = $request->address;
            $user->save();
//            activity_logs::__create_activity_log('User', 'update', $user);
            DB::commit();
            return array(
                "message" => "User has been Updated Successfully",
                "messageType" => "false"
            );
        } catch (\Exception $e) {
            DB::rollback();
            return array(
                "message" => "User has not been Updated Successfully",
                "messageType" => "true"
            );
        }
    }

    protected static function __remove($userId)
    {
        try {
            $user = User::find($userId);
            if ($user->delete() == 1):
                return array(
                    "success" => "User has been Deleted Successfully",
                    "errorType" => "false"
                );
            else:
                return array(
                    "error" => "User has not been Deleted Successfully",
                    "errorType" => "true"
                );
            endif;
        } catch (\Exception $e) {
            return array(
                "error" => "User has not been Deleted Successfully",
                "errorType" => "true"
            );
        }
    }

    protected static function __profile($request)
    {
        try {
            return User::where(['agentId' => $request['aid'], 'parentId' => $request['paid'], 'id' => $request['uid']])->first();
        } catch (\Exception $e) {
            return array(
                "error" => "User has no Profile",
                "errorType" => "true"
            );
        }
    }

}
