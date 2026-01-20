<?php

namespace App\Models\Payment;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Payment extends Model {

    use HasFactory;

    protected static function depositAmountSave($authenticate,$flightItineraryInfo,$alfalahClientProvider,$orderIssueProvider){
        try{
            $payment = new Payment();
            $payment->agentId = $authenticate->id ?? 0;
            $payment->parentId = $authenticate->parentId ?? 0;
            $payment->refNumber = $flightItineraryInfo->itineraryRef ?? '';
            $payment->refType ='TE';
            $payment->refTitle =  $flightItineraryInfo->itineraryRef ?? '';
            $payment->reference = $flightItineraryInfo->airType ?? '';
            $payment->depositAccount = $authenticate->companyName ?? '';
            $payment->createdId = $authenticate->id ?? 0;
            $payment->createdType = 'agent';
            $payment->createdBy = $authenticate->userName ?? '';
            $payment->createdDateTime = date("Y-m-d h:i:s");
            $payment->approvedId = $authenticate->id  ?? 0;
            $payment->approvedType = 'agent';
            $payment->approvedBy =  $authenticate->userName ?? '';
            $payment->approvedDateTime = date("Y-m-d h:i:s",strtotime($alfalahClientProvider->TransactionDateTime));
            $payment->paymentType = 'issue-ticket';
            $payment->creditLimit =$authenticate->creditLimit ?? 0;
            $payment->currentCreditLimit = $authenticate->currentCreditLimit ?? 0;
            $payment->depositDate = date("Y-m-d h:i:s",strtotime($alfalahClientProvider->OrderDateTime));
            $payment->totalAmount =  '+'.($alfalahClientProvider->TransactionAmount ?? 0);
            $payment->depositAmount = '+'.($alfalahClientProvider->TransactionAmount ?? 0);
            $payment->attachment = '';
            $payment->details = json_encode($alfalahClientProvider);
            $payment->paymentStatus =  $alfalahClientProvider->TransactionStatus ?? '';
            $payment->transactionType = $alfalahClientProvider->transactionType ?? 3;
            $payment->scopeType = $alfalahClientProvider->scopeType ?? '';
            $payment->sourceType = $alfalahClientProvider->sourceType ?? '';
            $payment->save();
        } catch (\Exception $e) {
        }
    }
    private static function __alfalahClientProvider($alfalahClientProvider){
        $details = "";
        foreach ($alfalahClientProvider as $alfalahKey => $alfalah):
            $details .= $alfalahKey.":".$alfalah.'---';
        endforeach;
        return $details;
    }
    private static function __persons($flightItinerary){
        $details ='';
        foreach ($flightItinerary['persons'] as $person):
            $details .= $person['passengerType'].'-';
            $details .= (!empty($person['ticketNumber']) ? $person['ticketNumber'].'-' : '');
            $details .= (!empty($person['ticketStatus']) ? $person['ticketStatus'].'-' : '');
            $details .= (!empty($person['eqTotalFare']) ? ($person['eqTotalFare']) : 0).'|';
        endforeach;
        return rtrim($details,"|");
    }

    function __destruct() {
        DB::disconnect();
    }

}
