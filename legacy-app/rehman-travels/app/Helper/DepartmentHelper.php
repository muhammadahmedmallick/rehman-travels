<?php
namespace App\Helper;

class DepartmentHelper {
    public static function __departments($id){
        $departments = [1 => "All", 2 => "Ticketing", 3 => "Visa, International Tour",
        4 => "Umrah, Hajj", 5 => "Consultance", 6 => "IT", 7 => "Marketing",
        8 => "Accounts", 9 => "Domestic Tour"];
        $departmentName = "";
        foreach($departments as $index => $department){
            if($id == $index){
                $departmentName = $department;
            }
        }
        return $departmentName;
    }
}