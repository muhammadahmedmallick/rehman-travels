<?php

namespace App\Libraries\hblpay;

use Request;
use GuzzleHttp\Client;
use Session;
use Storage;

class HblpayResponseProvider {

    private static $privatePEMKey = "-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----";

    public static function hblpaySuccess() {
        $rsaParamsDecryptions = explode("&", self::__rsaParamsDecryption());
        $rsaParams = array();
        $subParamNames = array('HBLPAYPNR','HBLPAYTOTALFARE');
        foreach ($rsaParamsDecryptions as $rsaParamsDecryption):
            $paramsDecryption = explode("=", $rsaParamsDecryption);
            $subParamsDecryptions = explode("|", $paramsDecryption[1]);
            if (array_key_exists(1, $subParamsDecryptions)):
                foreach ($subParamsDecryptions as $subParamsDecryptionKey => $subParamsDecryption):
                    $rsaParams[$subParamNames[$subParamsDecryptionKey]] = $subParamsDecryption;
                endforeach;
            endif;
            $rsaParams[$paramsDecryption[0]] = $paramsDecryption[1];
        endforeach;
        return $rsaParams;
    }

    public static function hblpayFail() {
        $rsaParamsDecryptions = explode("&", self::__rsaParamsDecryption());
        $rsaParams = array();
        $subParamNames = array('HBLPAYPNR','HBLPAYTOTALFARE');
        foreach ($rsaParamsDecryptions as $rsaParamsDecryption):
            $paramsDecryption = explode("=", $rsaParamsDecryption);
            $subParamsDecryptions = explode("|", $paramsDecryption[1]);
            if (array_key_exists(1, $subParamsDecryptions)):
                foreach ($subParamsDecryptions as $subParamsDecryptionKey => $subParamsDecryption):
                    $rsaParams[$subParamNames[$subParamsDecryptionKey]] =  $subParamsDecryption;
                endforeach;
            endif;
            $rsaParams[$paramsDecryption[0]] = $paramsDecryption[1];
        endforeach;
        return $rsaParams;
    }

    private static function __rsaParamsDecryption() {
        $response = parse_url($_SERVER['REQUEST_URI'], PHP_URL_QUERY);
        $response = str_replace("data=", "", $response);
        $decryptBlockSize = 512;
        $decrypted = '';
        $response = str_split(base64_decode($response), $decryptBlockSize);
        foreach ($response as $chunk) :
            $partial = '';
            $decryption = openssl_private_decrypt($chunk, $partial, self::$privatePEMKey, OPENSSL_PKCS1_PADDING);
            if ($decryption === false) :
                $decrypted = '';
                return $decrypted;
            endif;
            $decrypted .= $partial;
        endforeach;
        return utf8_decode($decrypted);
    }

    private static function __queryEncode($array = array()) {
        return str_replace('/', '_', rtrim(base64_encode(gzcompress(serialize($array))), '='));
    }

    private static function __queryDecode($str = '') {
        return (is_string($str) && strlen($str)) ? @unserialize(gzuncompress(base64_decode(str_replace('_', '/', $str)))) : FALSE;
    }

}
