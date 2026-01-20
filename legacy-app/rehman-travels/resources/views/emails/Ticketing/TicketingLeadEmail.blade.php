<html>
  <head>
    <title>Website Contact-us</title>
  </head>
  <body>
    <table
      cellspacing="5"
      cellpadding="5"
      style="width: 800px; border: 1px solid #333; padding: 5px"
    >
      <tr>
        <td>
          <table cellspacing="5" cellpadding="5" style="
              width: 800px;
              font-family: arial;
              background: #f0f0f0;
              border: solid 1px #0093dd;
            "
          >
            <tr>
              <td colspan="3">
                <table
                  cellspacing="5"
                  cellpadding="5"
                  border="1"
                  style="font-size: 12px; font-family: airal"
                  width="100%"
                >
                  <thead>
                    <tr style="background: #0e94e6; color: #fff">
                      <td
                        style="
                          padding: 10px 20px 20px !important;
                          font-size: 24px;
                          text-transform: capitalize;
                        "
                      >
                        Query From Rehman Travels FLIGHTS
                      </td>
                    </tr>
                  </thead>
                  <tbody></tbody>
                </table>
              </td>
            </tr>
            <tr>
              <td
                colspan="3"
                align="center"
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 16px;
                  color: #0069ab;
                "
              >
                <b>Contact Details</b>
              </td>
            </tr>
            <tr>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 14px;
                  color: #0069ab;
                  width: 110px;
                "
              >
                <b>Query Date And Time</b>
              </td>
              <td><b>:</b></td>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  color: #888888;
                  font-size: 16px;
                "
              >
                {{ date('d/m/Y h:iA') }}
              </td>
            </tr>
            <tr>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 16px;
                  color: #0069ab;
                "
              >
                <b>PHONE #</b>
              </td>
              <td><b>:</b></td>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  color: #888888;
                  font-size: 16px;
                "
              >
                <a href="'tel:'+{{$body['pn']}}">
                    {{$body['pn']}}
                </a>
              </td>
            </tr>
            <tr>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 16px;
                  color: #0069ab;
                "
              >
                <b>WEBSITE</b>
              </td>
              <td><b>:</b></td>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  color: #888888;
                  font-size: 16px;
                "
              >
                <a href="https://rehmantravel.com/">https://rehmantravel.com/</a>
              </td>
            </tr>
            <tr>
              <td
                colspan="3"
                align="center"
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 16px;
                  color: #0069ab;
                "
              >
                <b>Flight Details</b>
              </td>
            </tr>
            <tr>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 16px;
                  color: #0069ab;
                "
              >
                <b>Trip Type</b>
              </td>
              <td><b>:</b></td>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  color: #888888;
                  font-size: 16px;
                "
              > 
                {{$body['ft']}}
              </td>
            </tr>
            <tr>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 16px;
                  color: #0069ab;
                "
              >
                <b>Origin Location</b>
              </td>
              <td><b>:</b></td>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  color: #888888;
                  font-size: 16px;
                "
              >
                {{$body['ol']}}
              </td>
            </tr>
            <tr>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 16px;
                  color: #0069ab;
                "
              >
                <b>Destination Location</b>
              </td>
              <td><b>:</b></td>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  color: #888888;
                  font-size: 16px;
                "
              >
                {{$body['dl']}}
              </td>
            </tr>
            <tr>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 16px;
                  color: #0069ab;
                "
              >
                <b>Departure Date</b>
              </td>
              <td><b>:</b></td>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  color: #888888;
                  font-size: 16px;
                "
              >
                {{$body['obd']}}
              </td>
            </tr>
            <tr>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 16px;
                  color: #0069ab;
                "
              >
                <b>Return Date</b>
              </td>
              <td><b>:</b></td>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  color: #888888;
                  font-size: 16px;
                "
              >
                {{$body['ibd']}}
              </td>
            </tr>
            <tr>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 16px;
                  color: #0069ab;
                "
              >
                <b>Adult</b>
              </td>
              <td><b>:</b></td>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  color: #888888;
                  font-size: 16px;
                "
              >
                {{$body['ac']}}
              </td>
            </tr>
            <tr>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 16px;
                  color: #0069ab;
                "
              >
                <b>Child</b>
              </td>
              <td><b>:</b></td>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  color: #888888;
                  font-size: 16px;
                "
              >
                {{$body['cc']}}
              </td>
            </tr>
            <tr>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  font-size: 16px;
                  color: #0069ab;
                "
              >
                <b>Infant</b>
              </td>
              <td><b>:</b></td>
              <td
                style="
                  padding: 10px 20px 20px !important;
                  color: #888888;
                  font-size: 16px;
                "
              >
                {{$body['ic']}}
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
    <p style="font-size: 14px; color: red; font-family: calibri">
      This email and any files transmitted with it are confidential and intended
      solely for the use of the individual or entity to whom they are addressed.
      If you have received this email in error please notify the system manager.
      This message contains confidential information and is intended only for
      the individual named. If you are not the named addressee you should not
      disseminate, distribute or copy this e-mail. Please notify the sender
      immediately by e-mail if you have received this e-mail by mistake and
      delete this e-mail from your system. If you are not the intended recipient
      you are notified that disclosing, copying, distributing or taking any
      action in reliance on the contents of this information is strictly
      prohibited.
    </p>
  </body>
</html>
