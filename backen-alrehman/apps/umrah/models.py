"""
Umrah models
"""
from django.db import models


class CmsVisaDurations(models.Model):
    visaid = models.ForeignKey('CmsVisaPackages', models.DO_NOTHING, db_column='visaId')  # Field name made lowercase.
    visatitle = models.CharField(db_column='visaTitle', max_length=255)  # Field name made lowercase.
    visaprice = models.CharField(db_column='visaPrice', max_length=45)  # Field name made lowercase.
    currency = models.CharField(max_length=5)
    numentries = models.CharField(db_column='numEntries', max_length=25)  # Field name made lowercase.
    duration = models.CharField(max_length=45)
    validity = models.CharField(max_length=45)
    validforcityid = models.CharField(db_column='validForCityId', max_length=45)  # Field name made lowercase.
    visatype = models.CharField(db_column='visaType', max_length=20)  # Field name made lowercase.
    visaincludes = models.TextField(db_column='visaIncludes')  # Field name made lowercase.
    durationstatus = models.IntegerField(db_column='durationStatus')  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"CmsVisaDurations {self.id}"

    class Meta:
        managed = True
        db_table = 'cms_visa_durations'


class CmsVisaPackages(models.Model):
    cmscontentid = models.ForeignKey('cms.ContentPages', models.DO_NOTHING, db_column='cmsContentId')  # Field name made lowercase.
    countryname = models.CharField(db_column='countryName', max_length=255)  # Field name made lowercase.
    packageurl = models.CharField(db_column='packageUrl', max_length=255, blank=True, null=True)  # Field name made lowercase.
    toururl = models.CharField(db_column='tourUrl', max_length=255, blank=True, null=True)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"CmsVisaPackages {self.id}"

    class Meta:
        managed = True
        db_table = 'cms_visa_packages'


class TourImages(models.Model):
    tour_package = models.ForeignKey('TourPackages', models.DO_NOTHING)
    images = models.CharField(max_length=255, blank=True, null=True)
    banner_image = models.CharField(max_length=255, blank=True, null=True)
    created_by = models.BigIntegerField()
    created_at = models.DateTimeField()
    updated_by = models.BigIntegerField()
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"TourImages {self.id}"

    class Meta:
        managed = True
        db_table = 'tour_images'


class TourPackages(models.Model):
    id = models.BigAutoField(primary_key=True)
    cms_cp = models.ForeignKey('cms.ContentPages', models.DO_NOTHING)
    domestic_states_id = models.BigIntegerField(blank=True, null=True, db_comment='kpk,punjab etc')
    meta_keyword = models.CharField(max_length=255, blank=True, null=True)
    tour_days = models.IntegerField(blank=True, null=True)
    tour_availability = models.DateField(blank=True, null=True, db_comment='tour starting date')
    price_label = models.CharField(max_length=1, blank=True, null=True, db_comment='0=couple, 1=per person')
    discount_price = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    departure_location = models.CharField(max_length=50, blank=True, null=True)
    destination_location = models.CharField(max_length=50, blank=True, null=True)
    tour_services = models.TextField(blank=True, null=True)
    map = models.TextField(blank=True, null=True)
    days_details = models.TextField(blank=True, null=True)
    show_departure = models.CharField(max_length=1, blank=True, null=True, db_comment='0=hidden, 1=show')
    fixed_date = models.CharField(max_length=10, blank=True, null=True)
    tour_status = models.CharField(max_length=1)
    created_by = models.BigIntegerField()
    created_at = models.DateTimeField()
    updated_by = models.BigIntegerField()
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"TourPackages {self.id}"

    class Meta:
        managed = True
        db_table = 'tour_packages'


class UmrahBookingCustomers(models.Model):
    id = models.BigAutoField(primary_key=True)
    customerid = models.ForeignKey('core.Customers', models.DO_NOTHING, db_column='customerId')  # Field name made lowercase.
    umrahvisaprice = models.FloatField(db_column='umrahVisaPrice')  # Field name made lowercase.
    umrahsectorid = models.ForeignKey('UmrahTransportSectors', models.DO_NOTHING, db_column='umrahSectorId')  # Field name made lowercase.
    umrahvehicleid = models.ForeignKey('UmrahVehicles', models.DO_NOTHING, db_column='umrahVehicleId')  # Field name made lowercase.
    umrahvehicleprice = models.FloatField(db_column='umrahVehiclePrice')  # Field name made lowercase.
    nationality = models.CharField(max_length=1, db_comment='0=Pakistan, 1=Others')
    transport = models.CharField(max_length=1, db_comment='0=No Transport, 1=Have Transport')
    city = models.IntegerField()
    adultscount = models.IntegerField(db_column='adultsCount')  # Field name made lowercase.
    childrencount = models.IntegerField(db_column='childrenCount')  # Field name made lowercase.
    infantscount = models.IntegerField(db_column='infantsCount')  # Field name made lowercase.
    totalroom = models.IntegerField(db_column='totalRoom')  # Field name made lowercase.
    totalnight = models.IntegerField(db_column='totalNight')  # Field name made lowercase.
    totalprice = models.FloatField(db_column='totalPrice')  # Field name made lowercase.
    created_by = models.BigIntegerField()
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"UmrahBookingCustomers {self.id}"

    class Meta:
        managed = True
        db_table = 'umrah_booking_customers'


class UmrahBookingHotelRoom(models.Model):
    id = models.BigAutoField(primary_key=True)
    umrahbookingid = models.BigIntegerField(db_column='umrahBookingId')  # Field name made lowercase.
    hotelroompriceid = models.BigIntegerField(db_column='hotelRoomPriceId')  # Field name made lowercase.
    totalhotelperroom = models.IntegerField(db_column='totalhotelPerRoom')  # Field name made lowercase.
    hotelperroomtype = models.CharField(db_column='hotelPerRoomType', max_length=6)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"UmrahBookingHotelRoom {self.id}"

    class Meta:
        managed = True
        db_table = 'umrah_booking_hotel_room'


class UmrahBookings(models.Model):
    id = models.BigAutoField(primary_key=True)
    location = models.CharField(max_length=20)
    bookingcustomerid = models.ForeignKey('UmrahBookingCustomers', models.DO_NOTHING, db_column='bookingCustomerId')  # Field name made lowercase.
    hotelid = models.BigIntegerField(db_column='hotelId')  # Field name made lowercase.
    checkin = models.DateField(db_column='checkIn')  # Field name made lowercase.
    checkout = models.DateField(db_column='checkOut')  # Field name made lowercase.
    doubleroom = models.IntegerField(db_column='doubleRoom')  # Field name made lowercase.
    tripleroom = models.IntegerField(db_column='tripleRoom')  # Field name made lowercase.
    quadroom = models.IntegerField(db_column='quadRoom')  # Field name made lowercase.
    quintroom = models.IntegerField(db_column='quintRoom')  # Field name made lowercase.
    hoteltotalprice = models.IntegerField(db_column='hotelTotalPrice')  # Field name made lowercase.
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"UmrahBookings {self.id}"

    class Meta:
        managed = True
        db_table = 'umrah_bookings'


class UmrahHotelImages(models.Model):
    id = models.BigAutoField(primary_key=True)
    hotelid = models.ForeignKey('UmrahHotels', models.DO_NOTHING, db_column='hotelId')  # Field name made lowercase.
    hotelimage = models.CharField(db_column='hotelImage', max_length=255, blank=True, null=True)  # Field name made lowercase.
    hotelroomtype = models.CharField(db_column='hotelRoomType', max_length=6)  # Field name made lowercase.
    hotelroomimagestatus = models.CharField(db_column='hotelRoomImageStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"UmrahHotelImages {self.id}"

    class Meta:
        managed = True
        db_table = 'umrah_hotel_images'


class UmrahHotelRoomPeriods(models.Model):
    id = models.BigAutoField(primary_key=True)
    hotelid = models.PositiveBigIntegerField(db_column='hotelId')  # Field name made lowercase.
    periodfrom = models.DateField(db_column='periodFrom')  # Field name made lowercase.
    periodto = models.DateField(db_column='periodTo')  # Field name made lowercase.
    ashratype = models.CharField(db_column='ashraType', max_length=1)  # Field name made lowercase.
    periodstatus = models.CharField(db_column='periodStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"UmrahHotelRoomPeriods {self.id}"

    class Meta:
        managed = True
        db_table = 'umrah_hotel_room_periods'


class UmrahHotelRoomPrices(models.Model):
    id = models.BigAutoField(primary_key=True)
    periodid = models.PositiveBigIntegerField(db_column='periodId')  # Field name made lowercase.
    ondayprice = models.FloatField(db_column='onDayPrice')  # Field name made lowercase.
    ondaymarkup = models.FloatField(db_column='onDayMarkup')  # Field name made lowercase.
    offdayprice = models.FloatField(db_column='offDayPrice')  # Field name made lowercase.
    offdaymarkup = models.FloatField(db_column='offDayMarkup')  # Field name made lowercase.
    roomtype = models.CharField(db_column='roomType', max_length=6)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"UmrahHotelRoomPrices {self.id}"

    class Meta:
        managed = True
        db_table = 'umrah_hotel_room_prices'


class UmrahHotels(models.Model):
    id = models.BigAutoField(primary_key=True)
    postbyid = models.PositiveBigIntegerField(db_column='postById')  # Field name made lowercase.
    hotelname = models.CharField(db_column='hotelName', max_length=255)  # Field name made lowercase.
    vendorname = models.CharField(db_column='vendorName', max_length=255)  # Field name made lowercase.
    hotellocation = models.CharField(db_column='hotelLocation', max_length=7)  # Field name made lowercase.
    hoteldistance = models.CharField(db_column='hotelDistance', max_length=25)  # Field name made lowercase.
    basistype = models.CharField(db_column='basisType', max_length=2)  # Field name made lowercase.
    hoteltype = models.CharField(db_column='hotelType', max_length=1)  # Field name made lowercase.
    hoteldesc = models.CharField(db_column='hotelDesc', max_length=1000)  # Field name made lowercase.
    markup = models.CharField(max_length=25)
    hotelstatus = models.CharField(db_column='hotelStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"UmrahHotels {self.id}"

    class Meta:
        managed = True
        db_table = 'umrah_hotels'


class UmrahTransportSectors(models.Model):
    id = models.BigAutoField(primary_key=True)
    sectorname = models.CharField(db_column='sectorName', max_length=255)  # Field name made lowercase.
    sectormarkup = models.CharField(db_column='sectorMarkup', max_length=255)  # Field name made lowercase.
    sectorstatus = models.CharField(db_column='sectorStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"UmrahTransportSectors {self.id}"

    class Meta:
        managed = True
        db_table = 'umrah_transport_sectors'


class UmrahVehiclePrices(models.Model):
    id = models.BigAutoField(primary_key=True)
    vehicleid = models.PositiveBigIntegerField(db_column='vehicleId')  # Field name made lowercase.
    sectorid = models.PositiveBigIntegerField(db_column='sectorId')  # Field name made lowercase.
    vehicleprice = models.FloatField(db_column='vehiclePrice')  # Field name made lowercase.
    vehiclesectormarkup = models.IntegerField(db_column='vehicleSectorMarkup')  # Field name made lowercase.
    vehiclesectormrkprice = models.FloatField(db_column='vehicleSectorMrkPrice')  # Field name made lowercase.
    vehiclepricestatus = models.CharField(db_column='vehiclePriceStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"UmrahVehiclePrices {self.id}"

    class Meta:
        managed = True
        db_table = 'umrah_vehicle_prices'


class UmrahVehicles(models.Model):
    id = models.BigAutoField(primary_key=True)
    vehiclename = models.CharField(db_column='vehicleName', max_length=255)  # Field name made lowercase.
    vehiclemarkup = models.CharField(db_column='vehicleMarkup', max_length=255)  # Field name made lowercase.
    vehiclestatus = models.CharField(db_column='vehicleStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"UmrahVehicles {self.id}"

    class Meta:
        managed = True
        db_table = 'umrah_vehicles'


class UmrahVisas(models.Model):
    id = models.BigAutoField(primary_key=True)
    umrahvisaname = models.CharField(db_column='umrahVisaName', max_length=255)  # Field name made lowercase.
    umrahvisaperiodfrom = models.DateField(db_column='umrahVisaPeriodFrom')  # Field name made lowercase.
    umrahvisaperiodto = models.DateField(db_column='umrahVisaPeriodTo')  # Field name made lowercase.
    umrahvisaprice = models.FloatField(db_column='umrahVisaPrice')  # Field name made lowercase.
    umrahvisanationality = models.CharField(db_column='umrahVisaNationality', max_length=8)  # Field name made lowercase.
    umrahvisapricestatus = models.CharField(db_column='umrahVisaPriceStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"UmrahVisas {self.id}"

    class Meta:
        managed = True
        db_table = 'umrah_visas'
