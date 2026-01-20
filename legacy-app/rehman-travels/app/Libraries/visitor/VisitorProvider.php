<?php

namespace App\Libraries\visitor;

use App\Helper\ClientSystemInfoHelper;

class VisitorProvider {

    public static function visiter() {
        try {
            $ip = ClientSystemInfoHelper::get_ip();
            $getVisitorCountryCode = self::checkVisitor($ip);
            $ownDetails = '';
            if (!empty($getVisitorCountryCode) && $getVisitorCountryCode['country_code2'] == 'PK') {
                $ownDetails = [
                    'ip' => $ip,
                    'country_code2' => 'PK',
                    'country_name' => 'Pakistan',
                    'whatsapp' => '+92 3111 786 785',
                    'landline' => '+92 51 111 786 785',
                    'address' => 'Rehman Travels, Office No 1-3, Ground Floor, 44
                      East, Fazal E Haq Road, Blue Area, G 6/2, Islamabad, 44000, Pakistan',
                    'bankAccounts' => 'availible',
                    'googleMap' => 'https://maps.app.goo.gl/iTnFvue55XaEKrzS7'
                ];
            }else if(!empty($getVisitorCountryCode) && $getVisitorCountryCode['country_code2'] == 'AE') {
                $ownDetails = [
                    'ip' => $ip,
                    'country_code2' => $getVisitorCountryCode['country_code2'],
                    'country_name' => $getVisitorCountryCode['country_name'],
                    'whatsapp' => '',
                    'landline' => '',
                    'address' => '',
                    'bankAccounts' => '',
                    'googleMap' => ''
                ];
            }else if(!empty($getVisitorCountryCode) && $getVisitorCountryCode['country_code2'] == 'GB'){
                $ownDetails = [
                    'ip' => $ip,
                    'country_code2' => $getVisitorCountryCode['country_code2'],
                    'country_name' => $getVisitorCountryCode['country_name'],
                    'whatsapp' =>  '+447985257780',
                    'landline' => '+44 0207 183 0232',
                    'address' => '',
                    'bankAccounts' => '',
                    'googleMap' => ''
                ];
            }else if(!empty($getVisitorCountryCode) && $getVisitorCountryCode['country_code2'] == 'US'){
                $ownDetails = [
                    'ip' => $ip,
                    'country_code2' => $getVisitorCountryCode['country_code2'],
                    'country_name' => $getVisitorCountryCode['country_name'],
                    'whatsapp' =>  '',
                    'landline' => '',
                    'address' => '',
                    'bankAccounts' => '',
                    'googleMap' => ''
                ];
            } else {
                $ownDetails = [
                    'ip' => $ip,
                    'country_code2' => $getVisitorCountryCode['country_code2'],
                    'country_name' => $getVisitorCountryCode['country_name'],
                    'whatsapp' =>  '+447985257780',
                    'landline' => '+44 0207 183 0232',
                    'address' => '',
                    'bankAccounts' => '',
                    'googleMap' => ''
                ];
            }
            return $ownDetails;
        } catch (\Exception $e) {
            return [
                'ip' => '182.177.42.211',
                'country_code2' => 'PK',
                'country_name' => 'Pakistan',
                'whatsapp' => '+92 3111 786 785',
                'landline' => '+92 51 111 786 785',
                'bankAccounts' => 'availible',
                'address' => 'Rehman Travels, Office No 1-3, Ground Floor, 44
                      East, Fazal E Haq Road, Blue Area, G 6/2, Islamabad, 44000, Pakistan',
                'googleMap' => 'https://maps.app.goo.gl/iTnFvue55XaEKrzS7'
            ];
        }
    }

    public static function checkVisitor($ip) {
        $curl = curl_init();
        $url = 'https://api.iplocation.net/?ip=' . $ip;
        // $url = 'https://api.iplocation.net/?ip=83.110.250.231'; // Dubai
        // $url = 'https://api.iplocation.net/?ip=100.42.19.255'; // US
        // $url = 'https://api.iplocation.net/?ip=178.238.11.6'; // UK
        curl_setopt_array($curl, array(
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 0,
            CURLOPT_TIMEOUT => 1,
            CURLOPT_FOLLOWLOCATION => false,
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

}
