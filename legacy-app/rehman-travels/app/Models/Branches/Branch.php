<?php

namespace App\Models\Branches;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class Branch extends Model
{
    use HasFactory;
    protected $fillable = ["branchName", "branchAddress", "branchPhone", "mapAddress", "branchStatus", "showOnHome", "branch_Type", "branchSequance"];
    
    private  $__prefix;

    public function __construct(array $attributes = [])
    {
    }
    
    public static function getBranches(){
        $branches = self::where(['branchStatus' => 'active', 'showOnHome' => '1'])->orderBy('branchSequance')->get();
        $item = [];
        foreach($branches as $branch){
            if($branch['branch_Type'] == '1'):
                $item['branches'][] = array(
                    'branchName' => $branch->branchName,
                    'ContactNumber' => $branch->branchPhone
                );
            else:
                $item['salePoints'][] = array(
                    'salePointName' => $branch->branchName,
                    'salePointNumber' => $branch->branchPhone
                );
            endif;
        }
        return $item;
    }
    
    
    public static function branches(){
        return self::where('branchStatus','active')->get(['branchName','branchAddress','branchPhone']);
    }
    
    function __destruct() {
        DB::disconnect();
    }
}
