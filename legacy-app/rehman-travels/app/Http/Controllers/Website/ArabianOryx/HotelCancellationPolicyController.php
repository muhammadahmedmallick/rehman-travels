<?php

namespace App\Http\Controllers\Website\ArabianOryx;

use App\Http\Controllers\Controller;
use App\Libraries\ArabianOryx\HotelLibrary;
use Illuminate\Http\Request;

class HotelCancellationPolicyController extends Controller
{
    public function arabianOryxCancellationPolicy(Request $req){
        $cancellationPolicies = HotelLibrary::hotelCancellationPolicy($req);
        $policies = [];
        if($cancellationPolicies && $cancellationPolicies['rooms']['room']){
            foreach($cancellationPolicies['rooms']['room'] as $room){
                $policies[$room['roomName']] = [
                    'roomName' => $room['roomName'],
                    'meal' => $room['meal'],
                    'rateType' => $room['rateType'],
                    'status' => $room['status'],
                    'remarks' => $room['remarks']['remark']
                ];

                foreach($room['policies']['policy'] as $policy){
                    foreach($policy['condition'] as $condition){
                        $policies[$room['roomName']]['condition'][] = [
                            'fromDate' => $condition['fromDate'],
                            'toDate' => $condition['toDate'],
                            'fromTime' => $condition['fromTime'],
                            'toTime' => $condition['toTime'],
                            'percentage' => $condition['percentage'],
                        ];
                    }
                    $policies[$room['roomName']]['textCondition'][] = [
                        'textCondition' => $policy['textCondition']
                    ]; 
                }
            }
        }
        return response()->json($policies); 
    }
}
