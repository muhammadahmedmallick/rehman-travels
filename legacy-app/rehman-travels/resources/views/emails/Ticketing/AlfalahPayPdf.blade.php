<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Alfalah Payment Details, Itinerary:{{$orderProvider['flightItineraryInfo']['itineraryRef']}}</title>
    <style>
        table{
            width: 100%;
            border-collapse: collapse;
            font-family: Helvetica, Arial, sans-serif;
        }
        .header_img {
            width: 100%;
            height: 70px;
        }
        .PNR-description {
            text-align: justify !important;
            font-size: 11px !important;
        }
        td{
            font-size: 11px;
            text-align: left;
            font-family: Helvetica, Arial, sans-serif;
        }
        .tabletitle th {
            border-bottom: 1px dashed #666;
            font-family: Helvetica, Arial, sans-serif;
            text-align: left;
        }
        .tabletitle th:nth-child(2) {
            text-align: left;
            font-family: Helvetica, Arial, sans-serif;
        }
        th {
            font-size: 12px;
            text-align: left;
            padding: 5px 5px 5px 0px;
            font-family: Helvetica, Arial, sans-serif;
        }
        .list-item td {
            text-align: left;
            padding-bottom: 5px;
            font-size: 0.7em;
            font-family: Helvetica, Arial, sans-serif;
        }
        .list-item td:nth-child(2) {
            text-align: left;
            font-family: Helvetica, Arial, sans-serif;
        }
        .table-itinerary-ticket .list-item {
            text-align: left;
            font-size: 16px;
            font-family: Helvetica, Arial, sans-serif;
        }
    </style>
</head>
<body>
<table class="table-main print-main-table">
    <tbody>
    <tr class="list-item">
        <td>
            <table class="table-main">
                <tbody>
                <tr class="list-item">
                    <td>
                        <img class="header_img" src="https://rehmantravel.com/ticketing/header-img.png" alt="header.png">
                    </td>
                </tr>
                </tbody>
            </table>
        </td>
    </tr>
    </tbody>
</table>
<p>{!! (!empty($body) ? $body : '') !!}</p>
<table class="table-main print-main-table">
    <tbody>
    <tr class="main_detail">
        <td>
            <table class="table-itinerary-ticket">
                <tbody>
                <tr class="list-item">
                    <td><b>Traveller Name's:</b></td>
                    <td style="display: {{(!empty($orderProvider['persons'][0]['ticketNumber']) ? 'block': 'none')}}"><b>Ticket Number:</b></td>
                </tr>
                @foreach ($orderProvider['persons'] as $person)
                    <tr class="list-item">
                        <td>{{($orderProvider['flightItineraryInfo']['airType'] == 'Airsial' ?  $person['firstName'] :  $person['lastName'] .'/'. $person['firstName'])}}</td>
                        <td style="display: {{(!empty($person['ticketNumber']) ? 'block': 'none')}}">{{(!empty($person['ticketNumber']) ? $person['ticketNumber']: '')}}</td>
                    </tr>
                @endforeach
                </tbody>
            </table>
        </td>

        <td class="sateANDtime" style="width: 33.3%; vertical-align: initial;">
            <table class="table-itinerary-ticket">
                <tbody>
                <tr class="list-item">
                    <td>
                        <b class="mb-2 print-mb">Contact Details &nbsp;</b><br>
                        <b class="mb-2 print-mb">Name: &nbsp;</b>{{($orderProvider['flightItineraryInfo']['airType'] == 'Airsial' ?  $orderProvider['persons'][0]['firstName'] :  $orderProvider['persons'][0]['lastName'] .'/'. $orderProvider['persons'][0]['firstName'])}} <br>
                        <b class="mb-2 print-mb">Number: &nbsp;</b>{{(!empty($orderProvider['contacts'][0]['phone']) ? $orderProvider['contacts'][0]['phone'] : '+9251111785786')}}<br>
                        <b class="mb-2 print-mb">Email: &nbsp;</b>{{(!empty($orderProvider['contacts'][0]['email']) ? $orderProvider['contacts'][0]['email'] : 'bdm@rehmantravel.com')}}<br>
                        <b class="mb-2 print-mb">Supplier: &nbsp;</b>{{!empty($orderProvider['flightItineraryInfo']['supplier']) ? $orderProvider['flightItineraryInfo']['supplier'] : $orderProvider['flightItineraryInfo']['airType']}}<br>
                        <b class="mb-2 print-mb">Booking Ref: &nbsp;</b>{{$orderProvider['flightItineraryInfo']['itineraryRef']}}
                    </td>
                </tr>
                </tbody>
            </table>
        </td>
    </tr>
    </tbody>
</table>
@if(!empty($paymentProvider->TransactionStatus))
    <table class="table-main print-main-table">
        <tbody>
        <tr class="tabletitle"><th colspan="7" class="p-1"></th></tr>
        <tr><td>Payment Details</td></tr>
        <tr>
            <th>PaymentType</th>
            <th>Pay Total</th>
            <th>Payment Status</th>
            <th>Date Time</th>
            <th>Scope Type</th>
            <th>Bank Name</th>
        </tr>
        <tr>
            <td>{{(!empty($paymentProvider->transactionType) ? $paymentProvider->transactionType : '')}}</td>
            <td>{{(!empty($paymentProvider->TransactionAmount) ? ($paymentProvider->TransactionAmount) : '')}}</td>
            <td><b><u><i><font size='2' color='#ff0000'>{{(!empty($paymentProvider->TransactionStatus) ? $paymentProvider->TransactionStatus : '')}}</font></i></u></b></td>
            <td>{{(!empty($paymentProvider->OrderDateTime) ? date('dS M Y h:i:s',strtotime($paymentProvider->OrderDateTime)) : '')}}</td>
            <td>{{(!empty($paymentProvider->scopeType) ? $paymentProvider->scopeType : '')}}</td>
            <td>{{(!empty($paymentProvider->bankType) ? $paymentProvider->bankType : '')}}</td>
        </tr>
        <tr class="tabletitle"><th colspan="7" class="p-1"></th></tr>
        </tbody>
    </table>
@endif
<table class="table-main print-main-table">
    <tbody>
    <tr>
        <td colspan="2">FOP:{{$orderProvider['flightItineraryInfo']['receivedFrom']}}</td>
        <td colspan="1">Fare:{{(!empty($orderProvider['price']['currency']) ? $orderProvider['price']['currency'] : 'PKR')}} {{(!empty($orderProvider['price']['eqBaseFare']) ? $orderProvider['price']['baseFare'] : 0)}}</td>
        <td colspan="2">Taxes:{{(!empty($orderProvider['price']['currency']) ? $orderProvider['price']['currency'] : 'PKR')}} {{(!empty($orderProvider['price']['taxes']) ? $orderProvider['price']['taxes'] : 0)}}</td>
        <td colspan="2">Total Fare:{{(!empty($orderProvider['price']['currency']) ? $orderProvider['price']['currency'] : 'PKR')}} {{(!empty($orderProvider['price']['totalFare']) ? $orderProvider['price']['totalFare'] : 0)}}</td>
    </tr>
    <tr class="tabletitle"><th colspan="7" class="p-1"></th></tr>
    </tbody>
</table>
<table class="table-main">
    <tbody>
    <tr class="list-item">
        <td class="list-item-tb-mob description PNR-description pt-2" colspan="9"> Data protection notice: your personal data will be processed in accordance with the applicable carriers privacy policy And, if your booking is made via a reservation system provider (gds), with its privacy policy. These are available at <a href="https://rehmantravel.com/privacy"> https://rehmantravel.com/privacy</a> or from the carrier or gds directly. You should read this documentation, which Applies to your booking and specifies, for example, how your personal data is collected, stored, used, disclosed and Transferred. </td>
    </tr>
    </tbody>
</table>
<table>
    <tbody>
    <tr class="list-item">
        <td>
            <table class="table-main">
                <tbody>
                <tr class="list-item">
                    <td>
                        <img class="header_img" src="https://rehmantravel.com/ticketing/footer-img.png" alt="footer.png">
                    </td>
                </tr>
                </tbody>
            </table>
        </td>
    </tr>
    </tbody>
</table>
</body>
</html>
