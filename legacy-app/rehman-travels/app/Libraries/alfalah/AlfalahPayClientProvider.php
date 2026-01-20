<?php

namespace App\Libraries\alfalah;

use DOMDocument;

class AlfalahPayClientProvider
{

    protected $apiUrl;
    public $channel_id;
    public $merchant_id;
    public $api_mode;
    public $store_id;
    public $return_url;
    public $merchant_username;
    public $merchant_password;
    public $merchant_hash;
    protected $transactionReferenceNumber;
    protected $transactionType;
    protected $currency;
    protected $amount;
    protected $mobileNumber;
    protected $accountNumber;
    protected $countryCode;
    protected $email;
    protected $SMSOTAC;
    protected $EmailOTAC;
    protected $SMSOTP;
    public $cipher;
    public $isRedirectionRequest;
    public $isBTN;
    public $key;
    public $vi_key;
    public $secrectKey;
    public $MPGSTokenBase;
    protected $hashRequest;
    protected $auth_token;
    protected $hashKey;
    protected $orderId;
    public $handshake;
    private $_doTranUrl;
    private $_proTranUrl;
    private $_proTranStatusUrl;
    private $_fetchkeysUrl;
    private $_initiatehcUrl;
    private $_processhcUrl;

    /**
     * Constructor for AlfaPay
     * @return void
     */
    public function __construct()
    {
        $this->setApiUrl(env('ALFAPAY_HS_URL'));
        $this->channel_id = env('ALFAPAY_CHANNEL_ID');
        $this->merchant_id = env('ALFAPAY_MERCHANT_ID');
        $this->api_mode = env('ALFAPAY_MODE');
        $this->store_id = env('ALFAPAY_STORE_ID');
        $this->return_url = env('ALFAPAY_RETURN_URL');
        $this->merchant_username = env('ALFAPAY_MERCHANT_USERNAME');
        $this->merchant_password = env('ALFAPAY_MERCHANT_PASSWORD');
        $this->merchant_hash = env('ALFAPAY_MERCHANT_HASH');
        $this->setTransactionType(3); // 1: Alfa Wallet, 2: Alfalah Bank Account, 3: Credit Card
        $this->cipher = env('ALFAPAY_METHOD');
        $this->isRedirectionRequest = 0;
        $this->isBIN = 0;
        $this->key = env('ALFAPAY_KEY');
        $this->vi_key = env('ALFAPAY_IV_KEY');
        $this->secrectKey = env('ALFAPAY_SECRECT_KEY');
        $this->ipnKey = env('ALFAPAY_IPN_KEY');
        $this->ipnViKey = env('ALFAPAY_IPN_IV_KEY');
        $this->encKey = "";
        $this->encViKey = "";
        if ($this->api_mode == 'sandbox'):
            $this->_doTranUrl = env('ALFAPAY_HS_URL');
            $this->_proTranUrl = env('ALFAPAY_SSS_URL');
            $this->_proTranStatusUrl = env('ALFAPAY_STATUS_URL');
            $this->_fetchkeysUrl = env('ALFAPAY_FETCHKEYS_URL');
            $this->_initiatehcUrl = env('ALFAPAY_INITIATEHC_URL');
            $this->_processhcUrl = env('ALFAPAY_PROCESSHC_URL');
        else:
            $this->_doTranUrl = env('ALFAPAY_HS_URL');
            $this->_proTranUrl = env('ALFAPAY_SSS_URL');
            $this->_proTranStatusUrl = env('ALFAPAY_STATUS_URL');
            $this->_fetchkeysUrl = env('ALFAPAY_FETCHKEYS_URL');
            $this->_initiatehcUrl = env('ALFAPAY_INITIATEHC_URL');
            $this->_processhcUrl = env('ALFAPAY_PROCESSHC_URL');
        endif;
    }

    public function initiateHCKeys()
    {
        try {
            $curl = curl_init();
            curl_setopt_array($curl, array(
                CURLOPT_URL => $this->_fetchkeysUrl,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_ENCODING => '',
                CURLOPT_MAXREDIRS => 10,
                CURLOPT_TIMEOUT => 0,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                CURLOPT_CUSTOMREQUEST => 'POST',
                CURLOPT_POSTFIELDS => '{ "StoreId":"' . $this->store_id . '" , "SecrectKey": "' . $this->secrectKey . '" }',
                CURLOPT_HTTPHEADER => array(
                    'Content-Type: application/json'
                ),
            ));
            $response = curl_exec($curl);
            curl_close($curl);
            if (!empty(json_decode($response)->Keys)):
                $responseBody = explode("|", json_decode($response)->Keys);
                $this->encKey = $responseBody[0];
                $this->encViKey = $responseBody[1];
            endif;
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    public function initiateHC()
    {
        try {
            $mapString = "CardNumber={$this->getAccountNumber()}"
                . "&CVV={$this->getCvv()}"
                . "&ExpiryMonth={$this->getExpiryMonth()}"
                . "&ExpiryYear={$this->getExpiryYear()}"
                . "&CustomerName={$this->getCardHolderName()}"
                . "&CustomerEmailAddress={$this->getEmail()}"
                . "&CustomerMobileNumber={$this->getMobileNumber()}"
                . "&InitiateTrans=&";
            $this->setHashRequest($this->_generateHashValueRequest($mapString));
            return json_decode($this->_sendIpnRequest());
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    public function getIpnResponse()
    {
        try {
            $mapString = "CardNumber={$this->getAccountNumber()}"
                . "&CVV={$this->getCvv()}"
                . "&ExpiryMonth={$this->getExpiryMonth()}"
                . "&ExpiryYear={$this->getExpiryYear()}"
                . "&CustomerName={$this->getCardHolderName()}"
                . "&CustomerEmailAddress={$this->getEmail()}"
                . "&CustomerMobileNumber={$this->getMobileNumber()}"
                . "&InitiateTrans=&";
            $this->setHashRequest($this->_generateHashValueRequest($mapString));
            return json_decode($this->_sendIpnRequest());
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    public function getIpnToken()
    {
        try {
            $mapString = "CardNumber={$this->getAccountNumber()}"
                . "&CVV={$this->getCvv()}"
                . "&ExpiryMonth={$this->getExpiryMonth()}"
                . "&ExpiryYear={$this->getExpiryYear()}"
                . "&CustomerName={$this->getCardHolderName()}"
                . "&CustomerEmailAddress={$this->getEmail()}"
                . "&CustomerMobileNumber={$this->getMobileNumber()}"
                . "&InitiateTrans=&";
            $this->setHashRequest($this->_generateHashValueRequest($mapString));
            return $this->_sendIpnRequest();
            $responseBody = json_decode($this->_sendIpnRequest(), true);
            if (!empty($responseBody['success']) && $responseBody['success'] == 'true' && $responseBody['Is3DS'] == "Y"):
                return $responseBody['HTMLUrl'];
            else:
                return json_encode($responseBody, JSON_PRETTY_PRINT);
            endif;
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    private function _sendIpnRequest()
    {
        try {
            $fields = [
                "TransRequestHash" => $this->getHashRequest(),
                "StoreId" => $this->store_id,
                "TransactionTypeId" => $this->getTransactionType(),
                "TransactionReferenceNumber" => $this->getTransactionReferenceNumber(),
                "TransactionAmount" => $this->getAmount(),
                "CustomerName" => $this->getCardHolderName(),
                "CustomerEmailAddress" => $this->getEmail(),
                "CustomerMobileNumber" => $this->getMobileNumber(),
                "CardNumber" => $this->getAccountNumber(),
                "CVV" => $this->getCvv(),
                "ExpiryMonth" => $this->getExpiryMonth(),
                "ExpiryYear" => $this->getExpiryYear()
            ];
            $curl = curl_init();
            curl_setopt_array($curl, array(
                CURLOPT_URL => $this->_initiatehcUrl,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_ENCODING => '',
                CURLOPT_MAXREDIRS => 10,
                CURLOPT_TIMEOUT => 0,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                CURLOPT_CUSTOMREQUEST => 'POST',
                CURLOPT_POSTFIELDS => http_build_query($fields),
                CURLOPT_HTTPHEADER => array(
                    'Content-Type: application/x-www-form-urlencoded',
                ),
            ));
            $response = curl_exec($curl);
            curl_close($curl);
            return $response;
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    public function sendProcessHc()
    {
        try {
            $fields = [
                "StoreId" => $this->store_id,
                "TransactionTypeId" => $this->getTransactionType(),
                "TransactionReferenceNumber" => $this->getTransactionReferenceNumber(),
                "TransactionAmount" => $this->getAmount(),
                "CustomerName" => $this->getCardHolderName(),
                "CustomerEmailAddress" => $this->getEmail(),
                "CustomerMobileNumber" => $this->getMobileNumber(),
                "CardNumber" => $this->getAccountNumber(),
                "CVV" => $this->getCvv(),
                "ExpiryMonth" => $this->getExpiryMonth(),
                "ExpiryYear" => $this->getExpiryYear(),
                "MPGSTokenBase64" => ($this->getMPGSTokenBase64()),
                "__RequestVerificationToken" => ""
            ];
            $curl = curl_init();
            curl_setopt_array($curl, array(
                CURLOPT_URL => $this->_processhcUrl,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_ENCODING => '',
                CURLOPT_MAXREDIRS => 10,
                CURLOPT_TIMEOUT => 0,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                CURLOPT_CUSTOMREQUEST => 'POST',
                CURLOPT_POSTFIELDS => $fields
            ));
            $response = curl_exec($curl);
            curl_close($curl);
            return $response;
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    public function getCardNumber()
    {
        return $this->cardNumber;
    }

    public function setCardNumber($cardNumber)
    {
        $this->cardNumber = $cardNumber;
        return $this;
    }

    public function getCvv()
    {
        return $this->cvv;
    }

    public function setCVV($cvv)
    {
        $this->cvv = $cvv;
        return $this;
    }

    public function getExpiryMonth()
    {
        return $this->expiryMonth;
    }

    public function setExpiryMonth($expiryMonth)
    {
        $this->expiryMonth = $expiryMonth;
        return $this;
    }

    public function getExpiryYear()
    {
        return $this->expiryYear;
    }

    public function setExpiryYear($expiryYear)
    {
        $this->expiryYear = $expiryYear;
        return $this;
    }

    public function getCardHolderName()
    {
        return $this->cardHolderName;
    }

    public function setCardHolderName($cardHolderName)
    {
        $this->cardHolderName = $cardHolderName;
        return $this;
    }

    public function getCardHolderEmail()
    {
        return $this->cardHolderEmail;
    }

    public function setCardHolderEmail($cardHolderEmail)
    {
        $this->cardHolderEmail = $cardHolderEmail;
        return $this;
    }

    public function getCardHolderPhoneNo()
    {
        return $this->cardHolderPhoneNo;
    }

    public function setCardHolderPhoneNo($cardHolderPhoneNo)
    {
        $this->cardHolderPhoneNo = $cardHolderPhoneNo;
        return $this;
    }

    private function _generateHashValueRequest($mapString)
    {
        return $this->_encryptAES(substr($mapString, 0, strlen($mapString) - 1), $this->_decryptAES($this->encKey, $this->ipnKey, $this->ipnViKey), $this->_decryptAES($this->encViKey, $this->ipnKey, $this->ipnViKey));
    }

    private function _decryptAES($encryptedData, $key, $iv)
    {
        return openssl_decrypt(base64_decode($encryptedData), $this->cipher, $key, OPENSSL_RAW_DATA, $iv);
    }

    private function _encryptAES($data, $key, $iv)
    {
        return base64_encode(openssl_encrypt($data, $this->cipher, $key, OPENSSL_RAW_DATA, $iv));
    }

    /**
     * Get Token from API
     * @return hash key
     */
    public function getToken()
    {
        $mapString = "HS_ChannelId={$this->channel_id}"
            . "&HS_IsRedirectionRequest={$this->isRedirectionRequest}"
            . "&HS_MerchantId={$this->merchant_id}"
            . "&HS_StoreId={$this->store_id}"
            . "&HS_ReturnURL={$this->return_url}"
            . "&HS_MerchantHash={$this->merchant_hash}"
            . "&HS_MerchantUsername={$this->merchant_username}"
            . "&HS_MerchantPassword={$this->merchant_password}"
            . "&HS_TransactionReferenceNumber={$this->getTransactionReferenceNumber()}";
        $hashRequest = $this->_generateHashRequest($mapString);
        $this->setHashRequest($hashRequest);
        $this->_sendRequest();
        return $this->handshake;
    }


    /**
     * Send Request to API
     * @return void
     */
    private function _sendRequest()
    {
        try {
            $fields = [
                "HS_ChannelId" => $this->channel_id,
                "HS_IsRedirectionRequest" => $this->isRedirectionRequest,
                "HS_IsBIN" => $this->isBIN,
                "HS_MerchantId" => $this->merchant_id,
                "HS_StoreId" => $this->store_id,
                "HS_ReturnURL" => $this->return_url,
                "HS_MerchantHash" => $this->merchant_hash,
                "HS_MerchantUsername" => $this->merchant_username,
                "HS_MerchantPassword" => $this->merchant_password,
                "HS_TransactionReferenceNumber" => $this->getTransactionReferenceNumber(),
                "HS_RequestHash" => $this->getHashRequest()
            ];
            $fields_string = http_build_query($fields);
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $this->_doTranUrl);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $fields_string);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            $result = curl_exec($ch);
            $this->handshake = json_decode($result);
            if ($this->handshake != null && $this->handshake->success == 'true'):
                $AuthToken = $this->handshake->AuthToken;
                $this->setAuthToken($AuthToken);
            else:
                $this->setAuthToken(false);
            endif;
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    /**
     * Set/Prepare Transaction Request Values
     * @return string
     */
    public function sendTransactionRequest()
    {
        $mapString = "ChannelId={$this->channel_id}"
            . "&RequestHash=null"
            . "&MerchantId={$this->merchant_id}"
            . "&StoreId={$this->store_id}"
            . "&ReturnURL={$this->return_url}"
            . "&IsBIN={$this->isBIN}"
            . "&MerchantHash={$this->merchant_hash}"
            . "&MerchantUsername={$this->merchant_username}"
            . "&MerchantPassword={$this->merchant_password}"
            . "&TransactionReferenceNumber={$this->getTransactionReferenceNumber()}"
            . "&AuthToken={$this->getAuthToken()}"
            . "&TransactionTypeId={$this->getTransactionType()}"
            . "&Currency={$this->getCurrency()}"
            . "&MobileNumber={$this->getMobileNumber()}"
            . "&Country={$this->getCountryCode()}"
            . "&AccountNumber={$this->getAccountNumber()}"
            . "&EmailAddress={$this->getEmail()}"
            . "&TransactionAmount={$this->getAmount()}";
        $hashRequest = $this->_generateHashRequest($mapString);
        $this->setHashRequest($hashRequest);
        return $this->_sendTransactionRequest();
    }

    /**
     * Send POST Request to Transaction API
     * @return string
     */
    private function _sendTransactionRequest()
    {
        try {
            $fields = [
                "AuthToken" => $this->getAuthToken(),
                "RequestHash" => $this->getHashRequest(),
                "ChannelId" => $this->channel_id,
                "MerchantId" => $this->merchant_id,
                "StoreId" => $this->store_id,
                "MerchantHash" => $this->merchant_hash,
                "MerchantUsername" => $this->merchant_username,
                "MerchantPassword" => $this->merchant_password,
                "ReturnURL" => $this->return_url,
                "Currency" => $this->getCurrency(),
                "TransactionTypeId" => $this->getTransactionType(),
                "TransactionReferenceNumber" => $this->getTransactionReferenceNumber(),
                "TransactionAmount" => $this->getAmount(),
                "AccountNumber" => $this->getAccountNumber(),
                "IsBIN" => 0,
            ];
            $fields_string = http_build_query($fields);
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $this->_proTranUrl);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $fields_string);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            $result = curl_exec($ch);
            $doc = new DOMDocument();
            $doc->loadHTML($result);
            $byTagName = $doc->getElementsByTagName('a');
            return (!is_null($byTagName) ? $byTagName[0]->getAttribute('href') : '');
            return $result;
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    /**
     * Set/Prepare Transaction Status values
     * @param string $orderId
     * @return void
     */
    public function transactionStatus()
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, "{$this->_proTranStatusUrl}/{$this->merchant_id}/{$this->store_id}/{$this->getOrderID()}");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $result = curl_exec($ch);
        return json_decode(json_decode($result));
    }

    /**
     * Set/Prepare Process Transaction values
     * @param string $transactionReferenceNumber
     * @return void
     */
    public function processTransaction()
    {
        $mapString = "ChannelId={$this->channel_id}"
            . "&MerchantId={$this->merchant_id}"
            . "&StoreId={$this->store_id}"
            . "&MerchantHash={$this->merchant_hash}"
            . "&MerchantUsername={$this->merchant_username}"
            . "&MerchantPassword={$this->merchant_password}"
            . "&ReturnURL={$this->return_url}"
            . "&Currency={$this->getCurrency()}"
            . "&AuthToken={$this->getAuthToken()}"
            . "&TransactionType={$this->getTransactionType()}"
            . "&TransactionReferenceNumber={$this->getTransactionReferenceNumber()}"
            . "&SMSOTAC={$this->getSMSOTAC()}"
            . "&EmailOTAC={$this->getEmailOTAC()}"
            . "&SMSOTP={$this->getSMSOTP()}"
            . "&HashKey={$this->getHashKey()}"
            . "&IsOTP=true";
        $hashRequest = $this->_generateHashRequest($mapString);
        $this->setHashRequest($hashRequest);
        $response = $this->_sendProcessTransaction();
        return $response;
    }

    /**
     * Send POST Request to Process Transaction API
     * @return string
     */
    private function _sendProcessTransaction()
    {
        try {
            $fields = [
                "ChannelId" => $this->channel_id,
                "MerchantId" => $this->merchant_id,
                "StoreId" => $this->store_id,
                "MerchantHash" => $this->merchant_hash,
                "MerchantUsername" => $this->merchant_username,
                "MerchantPassword" => $this->merchant_password,
                "ReturnURL" => $this->return_url,
                "Currency" => $this->getCurrency(),
                "AuthToken" => $this->getAuthToken(),
                "TransactionTypeId" => $this->getTransactionType(),
                "TransactionReferenceNumber" => $this->getTransactionReferenceNumber(),
                "SMSOTAC" => $this->getSMSOTAC(),
                "EmailOTAC" => $this->getEmailOTAC(),
                "SMSOTP" => $this->getSMSOTP(),
                "HashKey" => $this->getHashKey(),
                "RequestHash" => $this->getHashRequest(),
                "IsOTP" => "true"
            ];
            $fields_string = http_build_query($fields);
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $this->_proTranUrl);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $fields_string);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            $result = curl_exec($ch);
            $response = json_decode($result);
            $doc = new DOMDocument();
            $doc->loadHTML($result);
            $byTagName = $doc->getElementsByTagName('a');
            return (!is_null($byTagName) ? $byTagName[0]->getAttribute('href') : '');
            return $result;
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }

    /**
     * Generate Hash/Token of Request
     * @param string $mapString
     * @return hash key
     */
    private function _generateHashRequest(string $mapString)
    {
        $cipher_text = openssl_encrypt($mapString, $this->cipher, $this->key, OPENSSL_RAW_DATA, $this->vi_key);
        $hashRequest = base64_encode($cipher_text);
        return $hashRequest;
    }

    /**
     * Get the value of apiUrl
     */
    public function getApiUrl()
    {
        return $this->apiUrl;
    }

    /**
     * Set the value of apiUrl
     *
     * @return  self
     */
    public function setApiUrl($apiUrl)
    {
        $this->apiUrl = $apiUrl;
        return $this;
    }

    /**
     * Get the value of transactionReferenceNumber
     */
    public function getTransactionReferenceNumber()
    {
        return $this->transactionReferenceNumber;
    }

    /**
     * Set the value of transactionReferenceNumber
     *
     * @return  self
     */
    public function setTransactionReferenceNumber($transactionReferenceNumber)
    {
        $this->transactionReferenceNumber = $transactionReferenceNumber;
        return $this;
    }

    /**
     * Get the value of hashRequest
     */
    public function getHashRequest()
    {
        return $this->hashRequest;
    }

    /**
     * Set the value of hasRequest
     *
     * @return  self
     */
    public function setHashRequest($hashRequest)
    {
        $this->hashRequest = $hashRequest;
        return $this;
    }

    /**
     * Get the value of auth_token
     */
    public function getAuthToken()
    {
        return $this->auth_token;
    }

    /**
     * Set the value of auth_token
     *
     * @return  self
     */
    public function setAuthToken($auth_token)
    {
        $this->auth_token = $auth_token;
        return $this;
    }

    /**
     * Get the value of transactionType
     */
    public function getTransactionType()
    {
        return $this->transactionType;
    }

    /**
     * Set the value of transactionType
     * @param 1: Alfa Wallet, 2: Alfalah Bank Account, 3: Credit Card
     * @return  self
     */
    public function setTransactionType($transactionType)
    {
        $this->transactionType = $transactionType;
        return $this;
    }

    /**
     * Get the value of currency
     */
    public function getCurrency()
    {
        return $this->currency;
    }

    /**
     * Set the value of currency
     *
     * @return  self
     */
    public function setCurrency($currency)
    {
        $this->currency = $currency;
        return $this;
    }

    /**
     * Get the value of amount
     */
    public function getAmount()
    {
        return $this->amount;
    }

    /**
     * Set the value of amount
     *
     * @return  self
     */
    public function setAmount($amount)
    {
        $this->amount = $amount;
        return $this;
    }

    /**
     * Get the value of mobileNumber
     */
    public function getMobileNumber()
    {
        return $this->mobileNumber;
    }

    /**
     * Set the value of mobileNumber
     *
     * @return  self
     */
    public function setMobileNumber($mobileNumber)
    {
        $this->mobileNumber = $mobileNumber;
        return $this;
    }

    /**
     * Get the value of accountNumber
     */
    public function getAccountNumber()
    {
        return $this->accountNumber;
    }

    /**
     * Set the value of accountNumber
     *
     * @return  self
     */
    public function setAccountNumber($accountNumber)
    {
        $this->accountNumber = $accountNumber;
        return $this;
    }

    /**
     * Get the value of countryCode
     */
    public function getCountryCode()
    {
        return $this->countryCode;
    }

    /**
     * Set the value of countryCode
     *
     * @return  self
     */
    public function setCountryCode($countryCode)
    {
        $this->countryCode = $countryCode;
        return $this;
    }

    /**
     * Get the value of email
     */
    public function getEmail()
    {
        return $this->email;
    }

    /**
     * Set the value of email
     *
     * @return  self
     */
    public function setEmail($email)
    {
        $this->email = $email;
        return $this;
    }

    /**
     * Get the value of SMSOTAC
     */
    public function getSMSOTAC()
    {
        return $this->SMSOTAC;
    }

    /**
     * Set the value of SMSOTAC
     *
     * @return  self
     */
    public function setSMSOTAC($SMSOTAC)
    {
        $this->SMSOTAC = $SMSOTAC;
        return $this;
    }

    /**
     * Get the value of EmailOTAC
     */
    public function getEmailOTAC()
    {
        return $this->EmailOTAC;
    }

    /**
     * Set the value of EmailOTAC
     *
     * @return  self
     */
    public function setEmailOTAC($EmailOTAC)
    {
        $this->EmailOTAC = $EmailOTAC;
        return $this;
    }

    /**
     * Get the value of SMSOTP
     */
    public function getSMSOTP()
    {
        return $this->SMSOTP;
    }

    /**
     * Set the value of SMSOTP
     *
     * @return  self
     */
    public function setSMSOTP($SMSOTP)
    {
        $this->SMSOTP = $SMSOTP;
        return $this;
    }

    /**
     * Get the value of hashKey
     */
    public function getHashKey()
    {
        return $this->hashKey;
    }

    /**
     * Set the value of hashKey
     *
     * @return  self
     */
    public function setHashKey($hashKey)
    {
        $this->hashKey = $hashKey;
        return $this;
    }

    /**
     * Get the value of hashKey
     */
    public function getOrderID()
    {
        return $this->orderId;
    }

    /**
     * Set the value of hashKey
     *
     * @return  self
     */
    public function setOrderID($orderId)
    {
        $this->orderId = $orderId;
        return $this;
    }

    public function getMPGSTokenBase64()
    {
        return $this->MPGSTokenBase;
    }

    /**
     * Set the value of hashKey
     *
     * @return  self
     */
    public function setMPGSTokenBase64($MPGSTokenBase)
    {
        $this->MPGSTokenBase = $MPGSTokenBase;
        return $this;
    }


}
