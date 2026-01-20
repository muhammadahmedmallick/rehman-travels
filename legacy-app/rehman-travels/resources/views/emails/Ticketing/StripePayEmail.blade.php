<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Stripe Payment Customer Has Been  Done, Itinerary:{{(!empty($params['pnr']) ? $params['pnr'] : '')}}</title>
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
<p>{!! (!empty($body) ? $body : '') !!}</p>
<br/>
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
<table class="table-main print-main-table">
    <tbody>
    <tr class="main_detail">
        <td>
            <table class="table-itinerary-ticket">
                <tbody>
                <tr class="list-item">
                    <td><b>Traveller Name's:</b></td>
                    <td style="display: {{(!empty($orderRetrieveProvider['persons'][0]['ticketNumber']) ? 'block': 'none')}}";><b>Ticket Number:</b></td>
                </tr>
                @foreach ($orderRetrieveProvider['persons'] as $person)
                    <tr class="list-item">
                        <td>{{$person['lastName']}} / {{$person['firstName']}}</td>
                        <td style="display: {{(!empty($person['ticketNumber']) ? 'block': 'none')}}";>{{(!empty($person['ticketNumber']) ? $person['ticketNumber']: '')}}</td>
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
                        <b class="mb-2 print-mb">Name: &nbsp;</b> {{$orderRetrieveProvider['persons'][0]['lastName']}} / {{$orderRetrieveProvider['persons'][0]['firstName']}} <br>
                        <b class="mb-2 print-mb">Number: &nbsp;</b>{{$orderRetrieveProvider['contacts'][0]['phone'] ?? ''}}<br>
                        <b class="mb-2 print-mb">Airline Vendor: &nbsp;</b>{{$orderRetrieveProvider['flightItineraryInfo']['airType']}}<br>
                        <b class="mb-2 print-mb">Booking Ref: &nbsp;</b>{{$orderRetrieveProvider['flightItineraryInfo']['itineraryRef']}}
                    </td>
                </tr>
                </tbody>
            </table>
        </td>
    </tr>
    </tbody>
</table>
@if(!empty($stripeClientProvider['payment_status']))
<table class="table-main print-main-table">
    <tbody>
        <tr class="tabletitle"><th colspan="7" class="p-1"></th></tr>
        <tr><td>Payment Details</td></tr>
    <tr>
        <td>Status:{{(!empty($stripeClientProvider['status']) ? $stripeClientProvider['status'] : '')}}</td>
        <td>Payment Method Type:{{(!empty($stripeClientProvider['payment_method_types']) ? $stripeClientProvider['payment_method_types'][0] : '')}}</td>
        <td> Pay Total Amount:{{(!empty($stripeClientProvider['amount_total']) ? ($stripeClientProvider['amount_total'] / 100) : '')}}</td>
        <td>Payment Status:{{(!empty($stripeClientProvider['payment_status']) ? $stripeClientProvider['payment_status'] : '')}}</td>
        <td>Date Time:{{(!empty($stripeClientProvider['created']) ? date('dS M Y h:i:s',$stripeClientProvider['created']) : '')}}</td>
    </tr>
    <tr class="tabletitle"><th colspan="7" class="p-1"></th></tr>
    </tbody>
</table>
@endif
<table class="table-main print-main-table">
    <tbody>
    <tr>
        <td colspan="2">FOP:{{$orderRetrieveProvider['flightItineraryInfo']['receivedFrom']}}</td>
        <td colspan="1">Fare:{{(!empty($orderRetrieveProvider['price']['currency']) ? $orderRetrieveProvider['price']['currency'] : 'PKR')}} {{(!empty($orderRetrieveProvider['price']['baseFare']) ? $orderRetrieveProvider['price']['baseFare'] : 0)}}</td>
        <td colspan="2">Taxes:{{(!empty($orderRetrieveProvider['price']['currency']) ? $orderRetrieveProvider['price']['currency'] : 'PKR')}} {{(!empty($orderRetrieveProvider['price']['taxes']) ? $orderRetrieveProvider['price']['taxes'] : 0)}}</td>
        <td colspan="2"> Total Fare:{{(!empty($orderRetrieveProvider['price']['currency']) ? $orderRetrieveProvider['price']['currency'] : 'PKR')}} {{(!empty($orderRetrieveProvider['price']['totalFare']) ? $orderRetrieveProvider['price']['totalFare'] : 0)}}</td>
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

