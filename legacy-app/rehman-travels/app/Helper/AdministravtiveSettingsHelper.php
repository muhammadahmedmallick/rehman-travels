<?php
namespace App\Helper;

use App\Models\Admin\AdministrativeSetting;

class AdministravtiveSettingsHelper {
    public static function __adminDetails($module){
        $moduleName = explode('/', $module);
        if($moduleName['3'] ==  'umrah' || $moduleName['3'] ==  'Umrhbookingdyn' || $moduleName['3'] ==  'hotels' || $moduleName['3'] == 'umrah-packages'):
            $where = ['id' => 2];
        elseif($moduleName['3'] ==  'visa' || $moduleName['3'] ==  'world-tours'):
            $where = ['id' => 3];
        elseif($moduleName['3'] ==  'study'):
            $where = ['id' => 12];
        elseif($moduleName['3'] == 'pakistantours'):
            $where = ['id' => 11];
        elseif($moduleName['3'] == 'hajj'):
            $where = ['id' => 4];
        else:
            $where = ['id' => 1];
        endif;
        $admin = AdministrativeSetting::where($where)->first();
        return array(
            "firstName" => $admin['name'],
            "email" => $admin['email'],
            "mobileNo" => $admin['contactNo'],
        );
    }
}