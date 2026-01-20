<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>{{$title}}</title>
        <style>
            table {
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

            td {
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
                                        <img class="header_img" src="https://rehmantravel.com/ticketing/header-img.png"
                                             alt="header.png">
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
        <p>{!! (!empty($body) ? $body : '') !!}</p>
        @if(!empty($orderProvider))
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
                                        <b class="mb-2 print-mb">Number:&nbsp;</b>{{(!empty($orderProvider['contacts'][0]['phone']) ? $orderProvider['contacts'][0]['phone'] : '+9251111785786')}}<br>
                                        <b class="mb-2 print-mb">Email:&nbsp;</b>{{(!empty($orderProvider['contacts'][0]['email']) ? $orderProvider['contacts'][0]['email'] : 'bdm@rehmantravel.com')}}<br>
                                        <b class="mb-2 print-mb">Supplier: &nbsp;</b>{{!empty($orderProvider['flightItineraryInfo']['supplier']) ? $orderProvider['flightItineraryInfo']['supplier'] : $orderProvider['flightItineraryInfo']['airType']}}<br>
                                        <b class="mb-2 print-mb">Booking Ref:&nbsp;</b>{{$orderProvider['flightItineraryInfo']['itineraryRef']}}
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
        <table class="table-main print-main-table">
            <thead>
                <tr class="tabletitle info_heading">
                    <th>Day</th>
                    <th>Date</th>
                    <th>City / Terminal / Stopover City</th>
                    <th>Time</th>
                    <th>Duration</th>
                    <th>Flight</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                @foreach ($orderProvider['legs'] as $leg)
                <tr>
                    <td>{{date("l",strtotime($leg['departureDate']))}}</td>
                    <td>{{date("jS M",strtotime($leg['departureDate']))}}</td>
                    <td>
                        <span>DEP {{$leg['departureCode']}}-{{$leg['departureAirportCode']}}</span><br/>
                        <span>ARR {{$leg['arrivalCode']}}-{{$leg['arrivalAirportCode']}}</span>
                    </td>
                    <td>
                        <span>{{date("h:i A",strtotime($leg['departureTime']))}}</span><br/>
                        <span>{{date("h:i A",strtotime($leg['arrivalTime']))}}</span>
                    </td>
                    <td>{{ $leg['elapsedTime']}}</td>
                    <td>{{ $leg['operatingAirlineCode']}} {{ $leg['operatingFlightNumber']}}</td>
                    <td>{{ ($leg['status'] === "HK" ? "Confirmed" : $leg['status'])}}</td>
                </tr>
                <tr class="tabletitle">
                    <th colspan="7" class="p-1"></th>
                </tr>
                @endforeach
            </tbody>
        </table>
        <table>
            <tbody>
                <tr>
                    <td style="width: 120px">Personal Details</td>
                    <td>
                        Email:{{(!empty($orderProvider['contacts'][0]['email']) ? $orderProvider['contacts'][0]['email'] : 'bdm@rehmantravel.com')}}
                        ,
                        Phone No
                        # {{(!empty($orderProvider['contacts'][0]['phone']) ? $orderProvider['contacts'][0]['phone'] : '+9251111785786')}}
                    </td>
                </tr>
                <tr class="tabletitle">
                    <th colspan="7" class="p-1"></th>
                </tr>
                <tr>
                    <td style="width: 120px">Endorsment</td>
                    <td style="text-align: justify;">
                        @foreach ($orderProvider['policy'] as $policy)
                        <span>{{$policy['text']}}</span>
                        @endforeach
                    </td>
                </tr>
                <tr class="tabletitle">
                    <th colspan="7" class="p-1"></th>
                </tr>
                <tr>
                    <td style="width: 120px">Baggage</td>
                    <td>
                        @foreach ($orderProvider['baggage'] as $baggage)
                        <span> {{$baggage['passengerType']}} {{ $baggage['segment'] }} {{$baggage['baggageAllowance']}}</span>
                        @endforeach
                    </td>
                </tr>
                <tr class="tabletitle">
                    <th colspan="7" class="p-1"></th>
                </tr>
            </tbody>
        </table>
        <table class="table-main print-main-table">
            <tbody>
                <tr>
                    <td colspan="2">FOP:{{$orderProvider['flightItineraryInfo']['receivedFrom']}}</td>
                    <td colspan="1">
                        Fare:{{(!empty($orderProvider['price']['currency']) ? $orderProvider['price']['currency'] : 'PKR')}} {{(!empty($orderProvider['price']['baseFare']) ? $orderProvider['price']['baseFare'] : 0)}}</td>
                    <td colspan="2">
                        Taxes:{{(!empty($orderProvider['price']['currency']) ? $orderProvider['price']['currency'] : 'PKR')}} {{(!empty($orderProvider['price']['taxes']) ? $orderProvider['price']['taxes'] : 0)}}</td>
                    <td colspan="2"> Total
                        Fare:{{(!empty($orderProvider['price']['currency']) ? $orderProvider['price']['currency'] : 'PKR')}} {{(!empty($orderProvider['price']['totalFare']) ? $orderProvider['price']['totalFare'] : 0)}}</td>
                </tr>
                <tr class="tabletitle">
                    <th colspan="7" class="p-1"></th>
                </tr>
            </tbody>
        </table>
        <table class="table-main print-main-table">
            <tbody>
                <tr>
                    <td colspan="2">FOP:{{$orderProvider['flightItineraryInfo']['receivedFrom']}}</td>
                    <td colspan="1">
                        Fare:{{(!empty($orderProvider['price']['currency']) ? $orderProvider['price']['currency'] : 'PKR')}} {{(!empty($orderProvider['price']['baseFare']) ? $orderProvider['price']['baseFare'] : 0)}}</td>
                    <td colspan="2">
                        Taxes:{{(!empty($orderProvider['price']['currency']) ? $orderProvider['price']['currency'] : 'PKR')}} {{(!empty($orderProvider['price']['taxes']) ? $orderProvider['price']['taxes'] : 0)}}</td>
                    <td colspan="2"> Total
                        Fare:{{(!empty($orderProvider['price']['currency']) ? $orderProvider['price']['currency'] : 'PKR')}} {{(!empty($orderProvider['price']['totalFare']) ? $orderProvider['price']['totalFare'] : 0)}}</td>
                </tr>
                <tr class="tabletitle">
                    <th colspan="7" class="p-1"></th>
                </tr>
            </tbody>
        </table>
        @endif

        @if(!empty($optionProvider))
        <h3 class="capitalize bg-bgRGTBaseColor p-3 text-white text-2xl rounded mb-5 md:pl-4">Our  {{((!empty($optionProvider[0]['bankName']) ? 'Bank Accounts' : 'Branches'))}}</h3>
        <table class="table-itinerary-ticket">
            <tbody>
                <tr class="list-item">
                    @foreach ($optionProvider as $optionKey => $option)
                    @if($optionKey % 4 == 0)
                </tr>
                <tr class="tabletitle"><th colspan="4" class="p-1"></th></tr>
                <tr class="list-item">
                    @endif
                    @if(!empty($option['bankName']))
                    <td>
                        <p>BANK NAME:{{ $option['bankName'] }}</p>
                        <p>TITLE : {{ $option['accountTitle'] }}</p>
                        <p>BR-CODE : {{ $option['branchCode'] }}</p>
                        <p>AC# : {{ $option['accountNo'] }}</p>
                        <p>IBAN# : {{ $option['ibanNo'] }}</p>
                        <p>SWIFT CODE : {{ $option['swiftCode'] }}</p>
                        <p>CONTACT NO : {{ $option['contactNo'] }}</p>
                    </td>
                    @else
                    <td>
                        <p>Branch Name:{{$option['branchName']}}</p>
                        <p>Address:{{$option['branchAddress']}}</p>
                        <p>Ph:{{$option['branchPhone']}}</p>
                    </td>
                    @endif
                    @endforeach
                </tr>
            </tbody>
        </table>
        @endif


        <table>
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
