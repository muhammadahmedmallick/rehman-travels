<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Flight Fare Rule Details</title>
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
            font-size: 10px;
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
    @foreach ($cheapestFlightFareRule['legs'] as $legsKey => $legs)
        <p style="color: darkred">{{$legsKey == 'leg2' ? 'Inbound Fare Rule Details': 'Outbound Fare Rule Details'}}</p>
        @foreach ($legs['penalties'] as $penalty)
            <p style="text-align: justify">{{$penalty['title']}}</p>
            <p style="text-align: justify">{{$penalty['text']}}</p>
        @endforeach
    @endforeach
</div>
<table class="table-main print-main-table">
    <tbody>
    <tr class="list-item">
        <td>
            <table class="table-main">
                <tbody>
                <tr class="list-item">
                    <td>
                        <img class="header_img" src="https://rehmantravel.com/ticketing/footer-img.png"
                             alt="footer.png">
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
