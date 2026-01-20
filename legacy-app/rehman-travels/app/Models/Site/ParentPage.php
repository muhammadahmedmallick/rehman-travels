<?php

namespace App\Models\Site;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use App\Helper\ClientSystemInfoHelper;

class ParentPage extends Model
{
    use HasFactory;

    protected $fillable = ["title", "parentUrl"];

    private  $__prefix;

    public function __construct(array $attributes = [])
    {
    }

    public function ContentPages()
    {
        return $this->hasMany(ContentPage::class, 'parentId', 'id');
    }

    public static function getContents()
    {
        $parents = self::where(['status' => '1', 'pageType' => 'w'])->orderBy('squanceOrder')->get("*");
        $items = [];
        foreach ($parents as $parent) {
            if($parent->title  == "Flights" || empty($parent->contents)){
                $items[$parent->title][] = [
                    "contentId" => "",
                    "parentId" => "",
                    "packageTitle" => $parent->title,
                    "parentUrl" => $parent->parentUrl
                ];
            }else{
                foreach ($parent->contents as $content) {
                    if($content->status == 1 && $content->showOnHome == 1){
                        $items[$parent->title][] = [
                            "contentId" => $content->id,
                            "parentId" => $content->parentId,
                            "packageTitle" => $content->packageTitle,
                            "parentUrl" => $content->urlLink
                        ];
                    }
                }
            }
        }
        return $items;
    }

    public function contents()
    {
        return $this->hasMany(ContentPage::class, 'parentId', 'id')->orderBy('sequence', 'asc');
    }

    public static function getVisition(){
        
        return [
            'ip' => '182.177.42.211',
            'country_code2' => 'PK',
            'country_name' => 'Pakistan',
            'whatsapp' =>  '+92 3111 786 785',
            'landline' => '+92 51 111 786 785',
            'address' => 'Rehman Travels Office No 3 Ground Floor, Office Tower 44
                  East Fazal E Haq Road Blue Area, G 6/2, Islamabad, 44000, Pakistan',
            'googleMap' => 'https://maps.app.goo.gl/iTnFvue55XaEKrzS7'
        ];
        
        $ip = ClientSystemInfoHelper::get_ip();
        $getVisitorCountryCode = self::checkVisitor($ip);
        $ownDetails = '';
        if(!empty($getVisitorCountryCode) && $getVisitorCountryCode['country_code2'] == 'AE'){
          return [
                'ip' => $ip,
                'country_code2' => $getVisitorCountryCode['country_code2'],
                'country_name' => $getVisitorCountryCode['country_name'],
                'whatsapp' =>  '+971 5 29 84 9567',
                'landline' => '+971 4 55 43 482',
                'address' => 'Office Number 14, Building Number Y16, England Cluster, International City Dubai, UAE',
                'googleMap' => 'https://maps.app.goo.gl/J2BdDmGDKQFNHNF9A'
            ];
        }else{
           return  [
                'ip' => $ip,
                'country_code2' => 'PK',
                'country_name' => 'Pakistan',
                'whatsapp' =>  '+92 3111 786 785',
                'landline' => '+92 51 111 786 785',
                'address' => 'Rehman Travels Office No 3 Ground Floor, Office Tower 44
                      East Fazal E Haq Road Blue Area, G 6/2, Islamabad, 44000, Pakistan',
                'googleMap' => 'https://maps.app.goo.gl/iTnFvue55XaEKrzS7'
            ];
        }
        //dd($ownDetails);
        return $ownDetails;
    }
    
    public static function checkVisitor($ip){
        $curl = curl_init();
        $url = 'https://api.iplocation.net/?ip=' . $ip; // Dubai
        //$url = 'https://api.iplocation.net/?ip=83.110.250.231'; // Dubai
        curl_setopt_array($curl, array(
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'GET',
            CURLOPT_HTTPHEADER => array(
                'Content-Type: application/json',
                'Accept: application/json',
            ),
        ));
        $response = curl_exec($curl);
        curl_close($curl);
        $data = json_decode($response, true);
        return $data;
    }
    
    function __destruct() {
        DB::disconnect();
    }
}
