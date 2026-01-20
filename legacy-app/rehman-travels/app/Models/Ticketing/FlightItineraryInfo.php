<?php

namespace App\Models\Ticketing;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class FlightItineraryInfo extends Model
{

    use HasFactory;

    public function persons() {
        return $this->hasMany(FlightItineraryPersonInfo::class,'itineraryRef','itineraryRef');
    }

    public function legs() {
        return $this->hasMany(FlightItineraryLegInfo::class,'itineraryRef','itineraryRef');
    }

    protected static function findAll($request)
    {
        try {
            $query = DB::table('flight_itinerary_infos as i');
            $query->join('flight_itinerary_person_infos as p', 'p.itineraryRef', '=', 'i.itineraryRef');
            $query->join('agents as a', 'a.id', '=', 'p.partyId');
            $query->select(['i.*', 'p.*', 'a.userName', 'a.companyName', 'a.email', 'a.creditLimit', 'a.tmpCreditLimit',
                'a.tmpCreditLimit', 'a.currentCreditLimit', 'a.mobileNo', 'a.phoneNo',
                DB::raw('SUBSTRING_INDEX(SUBSTRING_INDEX(i.sectors,",",1),"-",1) as ol'),
                DB::raw('SUBSTRING_INDEX(SUBSTRING_INDEX(i.sectors,",",1),"-",-1) as dl'),
                DB::raw('DATE_FORMAT(i.createdDateTime,"%a %d %b %y") as createdDateTime'),
                DB::raw('DATE_FORMAT(i.timeLimitDateTime,"%a %d %b %y") as timeLimitDateTime'),
                DB::raw('DATE_FORMAT(i.travelDate,"%a %d %b %y") as travelDate'),
                DB::raw('DATE_FORMAT(i.returnDate,"%a %d %b %y") as returnDate'),
            ]);
            if(!empty($request['rType'])):
                if($request['rType'] == 'bk'):
                     $query->whereNotNull('p.ticketRef');
                   else:
                   $query->where('p.ticketNumber','');
                endif;
            endif;
            if(!empty($request['itineraryRef'])):
                $query->where('p.itineraryRef', $request['itineraryRef']);
            endif;
            // $query->where(DB::raw("(DATE_FORMAT(i.created_at,'%Y-%m-%d'))"),date('Y-m-d'));
            $query->orderBy('i.id','DESC');
            return $query->get();
        } catch (Exception $e) {
            return 'Message' . $e->getMessage() . 'File' . $e->getFile() . 'Line' . $e->getLine();
        }
    }

    protected static function itineraryRef($itineraryRef){
        return self::where(['itineraryRef' => $itineraryRef])->first();
    }
    
    protected static function __duplicate($request)
    {
        $results = [];
        $persons = $request->persons ?? $request['persons'];
        foreach ($persons['type'] as $key => $type):
            $results = FlightItineraryInfo::__itineraryInfo(($persons['firstName'][$key] ?? ''), ($persons['lastName'][$key] ?? ''),$request->params,$request->vCarrier);
            if (!empty($results) && count($results) >= 1):
                break;
            endif;
        endforeach;
        return $results;
    }

    private static function __itineraryInfo($firstName, $lastName,$param,$vCarrier)
    {
        try {
            $query = DB::table('flight_itinerary_infos as i');
            $query->join('flight_itinerary_person_infos as p', 'p.itineraryRef', '=', 'i.itineraryRef');
            $query->select(['i.airType', 'i.itineraryRef', 'i.tripType', 'i.sectors', 'i.vCarrier',
                DB::raw('CONCAT_WS("/", p.lastName, p.firstName) as fullName'),
                DB::raw('DATE_FORMAT(i.travelDate,"%a %d %b %y") as travelDate')
            ]);
            $query->where('p.firstName', 'LIKE', $firstName . '%');
            $query->where(['p.lastName' => $lastName,'i.sectors' => self::__sectors($param)]);
            $query->where(DB::raw("(DATE_FORMAT(i.created_at,'%Y-%m-%d'))"), date("Y-m-d"));
            return $query->get();
        } catch (Exception $e) {
            return false;
        }
    }

    private static function __sectors($param)
    {
        if ($param['ft'] == 'one-way'):
            return ($param['ol'] . '-' . $param['dl']);
        else:
            return ($param['ol'] . '-' . $param['dl'] . ',' . $param['dl'] . '-' . $param['ol']);
        endif;
    }
}
