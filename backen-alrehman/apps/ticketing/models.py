"""
Ticketing models
"""
from django.db import models


class AirlineNameCodes(models.Model):
    id = models.BigAutoField(primary_key=True)
    airlinename = models.CharField(db_column='airlineName', max_length=100)  # Field name made lowercase.
    countryname = models.CharField(db_column='countryName', max_length=100)  # Field name made lowercase.
    carriercode = models.CharField(db_column='carrierCode', max_length=10)  # Field name made lowercase.
    iatacode = models.CharField(db_column='iataCode', max_length=10)  # Field name made lowercase.

    def __str__(self):
        return f"{self.airlinename}"

    class Meta:
        managed = True
        db_table = 'airline_name_codes'


class FlightBookingReferences(models.Model):
    bookingrefid = models.IntegerField(db_column='bookingRefId')  # Field name made lowercase.
    response = models.TextField(db_collation='utf8mb4_bin')
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"FlightBookingReferences {self.id}"

    class Meta:
        managed = True
        db_table = 'flight_booking_references'


class FlightItineraryInfos(models.Model):
    id = models.BigAutoField(primary_key=True)
    partyid = models.IntegerField(db_column='partyId')  # Field name made lowercase.
    receivableid = models.IntegerField(db_column='receivableId')  # Field name made lowercase.
    jsessionid = models.CharField(db_column='jSessionId', max_length=1000)  # Field name made lowercase.
    paysessionid = models.CharField(db_column='paySessionId', max_length=255)  # Field name made lowercase.
    paytype = models.CharField(db_column='payType', max_length=3)  # Field name made lowercase.
    banktype = models.CharField(db_column='bankType', max_length=20)  # Field name made lowercase.
    itineraryref = models.CharField(db_column='itineraryRef', max_length=20)  # Field name made lowercase.
    reference = models.CharField(max_length=45)
    tpcreference = models.CharField(db_column='tpcReference', max_length=45)  # Field name made lowercase.
    echotoken = models.CharField(db_column='echoToken', max_length=45)  # Field name made lowercase.
    cabin = models.CharField(max_length=15)
    triptype = models.CharField(db_column='tripType', max_length=15)  # Field name made lowercase.
    airtype = models.CharField(db_column='airType', max_length=20)  # Field name made lowercase.
    devicetype = models.CharField(db_column='deviceType', max_length=1)  # Field name made lowercase.
    sourcetype = models.CharField(db_column='sourceType', max_length=10)  # Field name made lowercase.
    sectortype = models.CharField(db_column='sectorType', max_length=3)  # Field name made lowercase.
    itinerarytype = models.CharField(db_column='itineraryType', max_length=3)  # Field name made lowercase.
    markuptype = models.CharField(db_column='markupType', max_length=10)  # Field name made lowercase.
    scopetype = models.CharField(db_column='scopeType', max_length=20)  # Field name made lowercase.
    vcarrier = models.CharField(db_column='vCarrier', max_length=5)  # Field name made lowercase.
    receivedfrom = models.CharField(db_column='receivedFrom', max_length=45)  # Field name made lowercase.
    querystring = models.CharField(db_column='queryString', max_length=1000)  # Field name made lowercase.
    pnrstatus = models.CharField(db_column='pnrStatus', max_length=10)  # Field name made lowercase.
    ticketstatus = models.CharField(db_column='ticketStatus', max_length=2)  # Field name made lowercase.
    payresponse = models.TextField(db_column='payResponse', db_collation='utf8mb4_bin', blank=True, null=True)  # Field name made lowercase.
    paytotalfare = models.FloatField(db_column='payTotalFare', blank=True, null=True)  # Field name made lowercase.
    createdbyuser = models.CharField(db_column='createdByUser', max_length=25)  # Field name made lowercase.
    createdbyid = models.IntegerField(db_column='createdById')  # Field name made lowercase.
    createdbytype = models.CharField(db_column='createdByType', max_length=5)  # Field name made lowercase.
    createddatetime = models.DateTimeField(db_column='createdDateTime')  # Field name made lowercase.
    cancelbyuser = models.CharField(db_column='cancelByUser', max_length=25)  # Field name made lowercase.
    cancelbyid = models.IntegerField(db_column='cancelById')  # Field name made lowercase.
    cancelbytype = models.CharField(db_column='cancelByType', max_length=5)  # Field name made lowercase.
    canceldatetime = models.DateTimeField(db_column='cancelDateTime')  # Field name made lowercase.
    issuedbyid = models.IntegerField(db_column='issuedById')  # Field name made lowercase.
    issuedbytype = models.CharField(db_column='issuedByType', max_length=5)  # Field name made lowercase.
    issuedbyuser = models.CharField(db_column='issuedByUser', max_length=45)  # Field name made lowercase.
    issueddatetime = models.DateTimeField(db_column='issuedDateTime')  # Field name made lowercase.
    voidbyid = models.IntegerField(db_column='voidById')  # Field name made lowercase.
    voidbytype = models.CharField(db_column='voidByType', max_length=5)  # Field name made lowercase.
    voidbyuser = models.CharField(db_column='voidByUser', max_length=45)  # Field name made lowercase.
    voiddatetime = models.DateTimeField(db_column='voidDateTime')  # Field name made lowercase.
    timelimitdatetime = models.DateTimeField(db_column='timeLimitDateTime')  # Field name made lowercase.
    sectors = models.CharField(max_length=25)
    traveldate = models.DateField(db_column='travelDate')  # Field name made lowercase.
    returndate = models.DateField(db_column='returnDate')  # Field name made lowercase.
    adultscount = models.IntegerField(db_column='adultsCount')  # Field name made lowercase.
    childrencount = models.IntegerField(db_column='childrenCount')  # Field name made lowercase.
    infantscount = models.IntegerField(db_column='infantsCount')  # Field name made lowercase.
    phone = models.CharField(max_length=25)
    email = models.CharField(max_length=255)
    partyname = models.CharField(db_column='partyName', max_length=255)  # Field name made lowercase.
    receivablename = models.CharField(db_column='receivableName', max_length=45)  # Field name made lowercase.
    totalfare = models.FloatField(db_column='totalFare')  # Field name made lowercase.
    basefare = models.FloatField(db_column='baseFare')  # Field name made lowercase.
    taxes = models.FloatField()
    eqtotalfare = models.FloatField(db_column='eqTotalFare')  # Field name made lowercase.
    eqbasefare = models.FloatField(db_column='eqBaseFare')  # Field name made lowercase.
    eqtaxes = models.FloatField(db_column='eqTaxes')  # Field name made lowercase.
    currencyratesofday = models.CharField(db_column='currencyRatesOfDay', max_length=1000, db_collation='utf8mb4_bin')  # Field name made lowercase.
    currencycode = models.CharField(db_column='currencyCode', max_length=5)  # Field name made lowercase.
    eqcurrencycode = models.CharField(db_column='eqCurrencyCode', max_length=5)  # Field name made lowercase.
    rccurrencycode = models.CharField(db_column='rcCurrencyCode', max_length=5)  # Field name made lowercase.
    currencyrate = models.FloatField(db_column='currencyRate')  # Field name made lowercase.
    eqcurrencyrate = models.FloatField(db_column='eqCurrencyRate')  # Field name made lowercase.
    rccurrencyrate = models.FloatField(db_column='rcCurrencyRate')  # Field name made lowercase.
    b2c = models.FloatField()
    eqb2c = models.FloatField(db_column='eqB2c')  # Field name made lowercase.
    b2b = models.FloatField()
    eqb2b = models.FloatField(db_column='eqB2b')  # Field name made lowercase.
    b2b2c = models.FloatField()
    eqb2b2c = models.FloatField(db_column='eqB2b2c')  # Field name made lowercase.
    b2b2b = models.FloatField()
    eqb2b2b = models.FloatField(db_column='eqB2b2b')  # Field name made lowercase.
    b2b2b2c = models.FloatField()
    eqb2b2b2c = models.FloatField(db_column='eqB2b2b2c')  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.email}"

    class Meta:
        managed = True
        db_table = 'flight_itinerary_infos'


class FlightItineraryLegInfos(models.Model):
    id = models.BigAutoField(primary_key=True)
    itineraryref = models.CharField(db_column='itineraryRef', max_length=10)  # Field name made lowercase.
    segno = models.CharField(db_column='segNo', max_length=20, blank=True, null=True)  # Field name made lowercase.
    flightnumber = models.CharField(db_column='flightNumber', max_length=20)  # Field name made lowercase.
    bookingcode = models.CharField(db_column='bookingCode', max_length=20, blank=True, null=True)  # Field name made lowercase.
    bookingclass = models.CharField(db_column='bookingClass', max_length=20, blank=True, null=True)  # Field name made lowercase.
    segbookdate = models.CharField(db_column='segBookDate', max_length=25, blank=True, null=True)  # Field name made lowercase.
    depdate = models.DateField(db_column='depDate')  # Field name made lowercase.
    deptime = models.CharField(db_column='depTime', max_length=10, blank=True, null=True)  # Field name made lowercase.
    arrdate = models.DateField(db_column='arrDate')  # Field name made lowercase.
    arrtime = models.CharField(db_column='arrTime', max_length=10, blank=True, null=True)  # Field name made lowercase.
    elapsedtime = models.CharField(db_column='elapsedTime', max_length=20)  # Field name made lowercase.
    equipment = models.CharField(max_length=45, blank=True, null=True)
    airlinepnr = models.CharField(db_column='airlinePnr', max_length=25)  # Field name made lowercase.
    stop = models.CharField(max_length=10)
    spmeal = models.CharField(db_column='spMeal', max_length=20, blank=True, null=True)  # Field name made lowercase.
    smoking = models.CharField(max_length=20, blank=True, null=True)
    status = models.CharField(max_length=20, blank=True, null=True)
    depcode = models.CharField(db_column='depCode', max_length=10, blank=True, null=True)  # Field name made lowercase.
    depairportcode = models.CharField(db_column='depAirportCode', max_length=200, blank=True, null=True)  # Field name made lowercase.
    depterminal = models.CharField(db_column='depTerminal', max_length=45, blank=True, null=True)  # Field name made lowercase.
    arrcode = models.CharField(db_column='arrCode', max_length=20, blank=True, null=True)  # Field name made lowercase.
    arrairportcode = models.CharField(db_column='arrAirportCode', max_length=200, blank=True, null=True)  # Field name made lowercase.
    arrterminal = models.CharField(db_column='arrTerminal', max_length=45, blank=True, null=True)  # Field name made lowercase.
    marairlinecode = models.CharField(db_column='marAirlineCode', max_length=10, blank=True, null=True)  # Field name made lowercase.
    marairlineflag = models.CharField(db_column='marAirlineFlag', max_length=100, blank=True, null=True)  # Field name made lowercase.
    marflightnumber = models.CharField(db_column='marFlightNumber', max_length=20, blank=True, null=True)  # Field name made lowercase.
    oprairlinecode = models.CharField(db_column='oprAirlineCode', max_length=20, blank=True, null=True)  # Field name made lowercase.
    oprairlineflag = models.CharField(db_column='oprAirlineFlag', max_length=100, blank=True, null=True)  # Field name made lowercase.
    oprflightnumber = models.CharField(db_column='oprFlightNumber', max_length=20, blank=True, null=True)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"FlightItineraryLegInfos {self.id}"

    class Meta:
        managed = True
        db_table = 'flight_itinerary_leg_infos'


class FlightItineraryPersonInfos(models.Model):
    id = models.BigAutoField(primary_key=True)
    pnrstatus = models.CharField(db_column='pnrStatus', max_length=10)  # Field name made lowercase.
    partyid = models.IntegerField(db_column='partyId')  # Field name made lowercase.
    receivableid = models.IntegerField(db_column='receivableId')  # Field name made lowercase.
    createdbyid = models.IntegerField(db_column='createdById')  # Field name made lowercase.
    createdbytype = models.CharField(db_column='createdByType', max_length=5)  # Field name made lowercase.
    createdbyuser = models.CharField(db_column='createdByUser', max_length=45)  # Field name made lowercase.
    createddatetime = models.DateTimeField(db_column='createdDateTime')  # Field name made lowercase.
    cancelbyid = models.IntegerField(db_column='cancelById')  # Field name made lowercase.
    cancelbytype = models.CharField(db_column='cancelByType', max_length=5)  # Field name made lowercase.
    cancelbyuser = models.CharField(db_column='cancelByUser', max_length=45)  # Field name made lowercase.
    canceldatetime = models.DateTimeField(db_column='cancelDateTime', blank=True, null=True)  # Field name made lowercase.
    issuedbyid = models.IntegerField(db_column='issuedById')  # Field name made lowercase.
    issuedbytype = models.CharField(db_column='issuedByType', max_length=5, blank=True, null=True)  # Field name made lowercase.
    issuedbyuser = models.CharField(db_column='issuedByUser', max_length=45)  # Field name made lowercase.
    issueddatetime = models.DateTimeField(db_column='issuedDateTime', blank=True, null=True)  # Field name made lowercase.
    voidbyid = models.IntegerField(db_column='voidById')  # Field name made lowercase.
    voidbytype = models.CharField(db_column='voidByType', max_length=5, blank=True, null=True)  # Field name made lowercase.
    voidbyuser = models.CharField(db_column='voidByUser', max_length=45)  # Field name made lowercase.
    voiddatetime = models.DateTimeField(db_column='voidDateTime', blank=True, null=True)  # Field name made lowercase.
    partyname = models.CharField(db_column='partyName', max_length=255, blank=True, null=True)  # Field name made lowercase.
    receivablename = models.CharField(db_column='receivableName', max_length=45)  # Field name made lowercase.
    itineraryref = models.CharField(db_column='itineraryRef', max_length=20)  # Field name made lowercase.
    paxtype = models.CharField(db_column='paxType', max_length=5)  # Field name made lowercase.
    refnumber = models.CharField(db_column='refNumber', max_length=20)  # Field name made lowercase.
    firstname = models.CharField(db_column='firstName', max_length=45)  # Field name made lowercase.
    lastname = models.CharField(db_column='lastName', max_length=45)  # Field name made lowercase.
    gender = models.CharField(max_length=5)
    doctype = models.CharField(db_column='docType', max_length=5, blank=True, null=True)  # Field name made lowercase.
    countryofissue = models.CharField(db_column='countryOfIssue', max_length=5, blank=True, null=True)  # Field name made lowercase.
    docnumber = models.CharField(db_column='docNumber', max_length=25, blank=True, null=True)  # Field name made lowercase.
    docnationality = models.CharField(db_column='docNationality', max_length=5, blank=True, null=True)  # Field name made lowercase.
    dateofbirth = models.DateField(db_column='dateOfBirth', blank=True, null=True)  # Field name made lowercase.
    docexpdate = models.DateField(db_column='docExpDate', blank=True, null=True)  # Field name made lowercase.
    docissuedate = models.DateField(db_column='docIssueDate', blank=True, null=True)  # Field name made lowercase.
    rph = models.CharField(max_length=20)
    elementid = models.CharField(db_column='elementId', max_length=20)  # Field name made lowercase.
    ticketref = models.CharField(db_column='ticketRef', max_length=20, blank=True, null=True)  # Field name made lowercase.
    ticketnumber = models.CharField(db_column='ticketNumber', max_length=20, blank=True, null=True)  # Field name made lowercase.
    ticketstatus = models.CharField(db_column='ticketStatus', max_length=3)  # Field name made lowercase.
    validatingcarrier = models.CharField(db_column='validatingCarrier', max_length=10)  # Field name made lowercase.
    basefare = models.FloatField(db_column='baseFare', blank=True, null=True)  # Field name made lowercase.
    eqbasefare = models.FloatField(db_column='eqBaseFare', blank=True, null=True)  # Field name made lowercase.
    taxes = models.FloatField(blank=True, null=True)
    eqtaxes = models.FloatField(db_column='eqTaxes', blank=True, null=True)  # Field name made lowercase.
    totalfare = models.FloatField(db_column='totalFare', blank=True, null=True)  # Field name made lowercase.
    eqtotalfare = models.FloatField(db_column='eqTotalFare', blank=True, null=True)  # Field name made lowercase.
    currencycode = models.CharField(db_column='currencyCode', max_length=5, blank=True, null=True)  # Field name made lowercase.
    eqcurrencycode = models.CharField(db_column='eqCurrencyCode', max_length=5, blank=True, null=True)  # Field name made lowercase.
    rccurrencycode = models.CharField(db_column='rcCurrencyCode', max_length=5)  # Field name made lowercase.
    currencyrate = models.FloatField(db_column='currencyRate', blank=True, null=True)  # Field name made lowercase.
    eqcurrencyrate = models.FloatField(db_column='eqCurrencyRate', blank=True, null=True)  # Field name made lowercase.
    rccurrencyrate = models.FloatField(db_column='rcCurrencyRate')  # Field name made lowercase.
    commission = models.FloatField(blank=True, null=True)
    taxbreakdowns = models.CharField(db_column='taxBreakdowns', max_length=1000)  # Field name made lowercase.
    eqtaxbreakdowns = models.CharField(db_column='eqTaxBreakdowns', max_length=1000)  # Field name made lowercase.
    messages = models.CharField(max_length=1000, blank=True, null=True)
    segment = models.CharField(max_length=25, blank=True, null=True)
    baggage = models.CharField(max_length=25, blank=True, null=True)
    faretype = models.CharField(db_column='fareType', max_length=25, blank=True, null=True)  # Field name made lowercase.
    pnrtype = models.CharField(db_column='pnrType', max_length=20, blank=True, null=True)  # Field name made lowercase.
    b2c = models.FloatField(blank=True, null=True)
    eqb2c = models.FloatField(db_column='eqB2c', blank=True, null=True)  # Field name made lowercase.
    b2b = models.FloatField(blank=True, null=True)
    eqb2b = models.FloatField(db_column='eqB2b', blank=True, null=True)  # Field name made lowercase.
    b2b2c = models.FloatField(blank=True, null=True)
    eqb2b2c = models.FloatField(db_column='eqB2b2c', blank=True, null=True)  # Field name made lowercase.
    b2b2b = models.FloatField(blank=True, null=True)
    eqb2b2b = models.FloatField(db_column='eqB2b2b', blank=True, null=True)  # Field name made lowercase.
    b2b2b2c = models.FloatField(blank=True, null=True)
    eqb2b2b2c = models.FloatField(db_column='eqB2b2b2c', blank=True, null=True)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"FlightItineraryPersonInfos {self.id}"

    class Meta:
        managed = True
        db_table = 'flight_itinerary_person_infos'


class FlightItineraryrefMarkupInfos(models.Model):
    id = models.BigAutoField(primary_key=True)
    agentid = models.PositiveBigIntegerField(db_column='agentId')  # Field name made lowercase.
    parentid = models.PositiveBigIntegerField(db_column='parentId')  # Field name made lowercase.
    userid = models.PositiveBigIntegerField(db_column='userId')  # Field name made lowercase.
    itineraryref = models.CharField(db_column='itineraryRef', max_length=20)  # Field name made lowercase.
    title = models.CharField(max_length=45)
    itinerarytype = models.CharField(db_column='itineraryType', max_length=3)  # Field name made lowercase.
    faretype = models.CharField(db_column='fareType', max_length=2)  # Field name made lowercase.
    servicefeetype = models.CharField(db_column='serviceFeeType', max_length=3)  # Field name made lowercase.
    passengertype = models.CharField(db_column='passengerType', max_length=3)  # Field name made lowercase.
    servicetype = models.CharField(db_column='serviceType', max_length=11)  # Field name made lowercase.
    markuptype = models.CharField(db_column='markupType', max_length=7)  # Field name made lowercase.
    servicefee = models.FloatField(db_column='serviceFee')  # Field name made lowercase.
    airlinetype = models.CharField(db_column='airlineType', max_length=14, blank=True, null=True)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.title}"

    class Meta:
        managed = True
        db_table = 'flight_itineraryref_markup_infos'


class Inoutbounds(models.Model):
    id = models.BigAutoField(primary_key=True)
    agentid = models.ForeignKey('accounts.Agents', models.DO_NOTHING, db_column='agentId')  # Field name made lowercase.
    postbyid = models.BigIntegerField(db_column='postbyId')  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5)  # Field name made lowercase.
    title = models.CharField(max_length=255)
    amount = models.FloatField()
    airlinetype = models.CharField(db_column='airlineType', max_length=5)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.title}"

    class Meta:
        managed = True
        db_table = 'inoutbounds'


class PremiumAirlines(models.Model):
    id = models.BigAutoField(primary_key=True)
    agentid = models.ForeignKey('accounts.Agents', models.DO_NOTHING, db_column='agentId')  # Field name made lowercase.
    postbyid = models.BigIntegerField(db_column='postbyId')  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5)  # Field name made lowercase.
    title = models.CharField(max_length=255)
    amount = models.FloatField()
    airlinetype = models.CharField(db_column='airlineType', max_length=10)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.title}"

    class Meta:
        managed = True
        db_table = 'premium_airlines'
