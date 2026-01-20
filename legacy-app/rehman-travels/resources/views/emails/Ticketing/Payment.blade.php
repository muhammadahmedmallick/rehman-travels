<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Payment Details.</title>
    <style>
        body{
            font-family: Helvetica, Arial, sans-serif;
        }
        table{
            width: 100%;
            border-collapse: collapse;
            font-family: Helvetica, Arial, sans-serif;
        }
        .header_img {
            width: 100%;
            height: 70px;
        }
        td{
            font-size: 14px;
            text-align: left;
            font-family: Helvetica, Arial, sans-serif;
        }
        th {
            font-size: 14px;
            text-align: left;
            padding: 5px 5px 5px 0px;
            font-family: Helvetica, Arial, sans-serif;
        }
        p{
            font-size: 14px;
            line-height: 0px !important;
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
<div>
    <p>{!! (!empty($body) ? $body : '') !!}</p>
    <table class="table-main print-main-table">
        <tbody>
        <tr class="tabletitle"><th colspan="7" class="p-1"></th></tr>
        <tr class="list-item">
            <td>
                <b class="mb-2 print-mb">Name: &nbsp;</b> {{$userName}} <br>
                <b class="mb-2 print-mb">Number: &nbsp;</b>{{$phoneNumber}}<br>
                <b class="mb-2 print-mb">Email: &nbsp;</b>{{$email}}<br>
            </td>
            <td>
                <b class="mb-2 print-mb">Supplier: &nbsp;</b>{{!empty($flightItineraryInfo['supplier']) ? $flightItineraryInfo['supplier'] : $flightItineraryInfo['airType']}}<br>
                <b class="mb-2 print-mb">Booking Ref: &nbsp;</b>{{$flightItineraryInfo['itineraryRef']}}
            </td>
        </tr>
        <tr>
            <th>PaymentType</th>
            <th> Pay Total</th>
            <th>Payment Status</th>
            <th>Date Time</th>
            <th>Scope Type</th>
            <th>Bank Name</th>
        </tr>
        <tr>
            <td>{{($paymentProvider->transactionType ?? ($paymentProvider['transactionType'] ?? ''))}}</td>
            <td>{{($paymentProvider->TransactionAmount ?? ($paymentProvider['TransactionAmount'] ?? ''))}}</td>
            <td>{{($paymentProvider->TransactionStatus ?? ($paymentProvider['TransactionStatus'] ?? ''))}}</td>
            <td>{{date('dS M Y h:i:s',strtotime(($paymentProvider->OrderDateTime ?? ($paymentProvider['OrderDateTime'] ?? date('Y-m-d')))))}}</td>
            <td>{{($paymentProvider->scopeType ?? ($paymentProvider['scopeType'] ?? ''))}}</td>
            <td>{{($paymentProvider->bankType ?? ($paymentProvider['bankType'] ?? ''))}}</td>
        </tr>
        </tbody>
    </table>
</div>
<table class="table-main">
    <tbody>
    <tr class="list-item" style="color:cadetblue">
        <td class="list-item-tb-mob description PNR-description pt-2" colspan="9"> Data protection notice: your personal
            data will be processed in accordance with the applicable carriers privacy policy And, if your booking is
            made via a reservation system provider (gds), with its privacy policy. These are available at <a
                href="https://rehmantravel.com/privacy" style="color:blue"> https://rehmantravel.com/privacy</a> or from the carrier or gds
            directly. You should read this documentation, which Applies to your booking and specifies, for example, how
            your personal data is collected, stored, used, disclosed and Transferred.
        </td>
    </tr>
    </tbody>
</table>
<table class="table-main print-main-table">
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
