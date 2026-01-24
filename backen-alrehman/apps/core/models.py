"""
Core models
"""
from django.db import models


class AdministrativeSettings(models.Model):
    name = models.CharField(max_length=50)
    email = models.CharField(max_length=25)
    contactno = models.CharField(db_column='contactNo', max_length=20)  # Field name made lowercase.
    status = models.CharField(max_length=1)
    ceated_at = models.DateTimeField()
    created_by = models.IntegerField()
    updated_at = models.DateTimeField(blank=True, null=True)
    updated_by = models.IntegerField(blank=True, null=True)

    def __str__(self):
        return f"{self.name}"

    class Meta:
        managed = True
        db_table = 'administrative_settings'


class BankDetails(models.Model):
    id = models.BigAutoField(primary_key=True)
    postbyid = models.BigIntegerField(db_column='postbyId', blank=True, null=True)  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5, blank=True, null=True)  # Field name made lowercase.
    bankname = models.CharField(db_column='bankName', max_length=100)  # Field name made lowercase.
    accounttitle = models.CharField(db_column='accountTitle', max_length=100)  # Field name made lowercase.
    branchcode = models.CharField(db_column='branchCode', max_length=10)  # Field name made lowercase.
    accountno = models.CharField(db_column='accountNo', max_length=25)  # Field name made lowercase.
    ibanno = models.CharField(db_column='ibanNo', max_length=50)  # Field name made lowercase.
    swiftcode = models.CharField(db_column='swiftCode', max_length=15)  # Field name made lowercase.
    contactno = models.CharField(db_column='contactNo', max_length=30)  # Field name made lowercase.
    bankstatus = models.CharField(db_column='bankStatus', max_length=1)  # Field name made lowercase.
    banklogoname = models.CharField(db_column='bankLogoName', max_length=50)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"BankDetails {self.id}"

    class Meta:
        managed = True
        db_table = 'bank_details'


class Branches(models.Model):
    id = models.BigAutoField(primary_key=True)
    branchname = models.CharField(db_column='branchName', unique=True, max_length=45)  # Field name made lowercase.
    branchaddress = models.CharField(db_column='branchAddress', max_length=255)  # Field name made lowercase.
    branchphone = models.CharField(db_column='branchPhone', max_length=30)  # Field name made lowercase.
    mapaddress = models.CharField(db_column='mapAddress', max_length=500)  # Field name made lowercase.
    branchstatus = models.CharField(db_column='branchStatus', max_length=9)  # Field name made lowercase.
    branchsequance = models.IntegerField(db_column='branchSequance')  # Field name made lowercase.
    showonhome = models.CharField(db_column='showOnHome', max_length=1)  # Field name made lowercase.
    branch_type = models.CharField(db_column='branch_Type', max_length=1, blank=True, null=True, db_comment='1=Branch, 2=Sale Point')  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"Branches {self.id}"

    class Meta:
        managed = True
        db_table = 'branches'


class Currencies(models.Model):
    currencyname = models.CharField(db_column='currencyName', max_length=50)  # Field name made lowercase.
    currencyflag = models.CharField(db_column='currencyFlag', max_length=255)  # Field name made lowercase.
    currencycode = models.CharField(db_column='currencyCode', max_length=10)  # Field name made lowercase.
    currencysymbol = models.CharField(db_column='currencySymbol', max_length=20, db_collation='utf8mb3_general_ci')  # Field name made lowercase.
    countryname = models.CharField(db_column='countryName', max_length=255)  # Field name made lowercase.
    countrycode = models.CharField(db_column='countryCode', max_length=10)  # Field name made lowercase.
    currencyrate = models.FloatField(db_column='currencyRate')  # Field name made lowercase.
    status = models.CharField(max_length=11)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"Currencies {self.id}"

    class Meta:
        managed = True
        db_table = 'currencies'


class Customers(models.Model):
    id = models.BigAutoField(primary_key=True)
    firstname = models.CharField(db_column='firstName', max_length=25, blank=True, null=True)  # Field name made lowercase.
    lastname = models.CharField(db_column='lastName', max_length=25, blank=True, null=True)  # Field name made lowercase.
    dob = models.DateField(blank=True, null=True)
    cnic = models.CharField(max_length=20, blank=True, null=True)
    cnicissuedate = models.DateField(db_column='cnicIssueDate', blank=True, null=True)  # Field name made lowercase.
    cnicexpirydate = models.DateField(db_column='cnicExpiryDate', blank=True, null=True)  # Field name made lowercase.
    mobileno = models.CharField(db_column='mobileNo', max_length=25)  # Field name made lowercase.
    phoneno = models.CharField(db_column='phoneNo', max_length=25, blank=True, null=True)  # Field name made lowercase.
    email = models.CharField(max_length=45, blank=True, null=True)
    passportno = models.CharField(db_column='passportNo', max_length=20, blank=True, null=True)  # Field name made lowercase.
    passportissuedate = models.DateField(db_column='passportIssueDate', blank=True, null=True)  # Field name made lowercase.
    passportexpirydate = models.DateField(db_column='passportExpiryDate', blank=True, null=True)  # Field name made lowercase.
    details = models.TextField(blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    createdby = models.IntegerField(db_column='createdBy', blank=True, null=True)  # Field name made lowercase.
    dnd = models.CharField(max_length=3)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.email}"

    class Meta:
        managed = True
        db_table = 'customers'


class RestApiCredentials(models.Model):
    versiontype = models.CharField(db_column='versionType', max_length=45)  # Field name made lowercase.
    version = models.CharField(max_length=45)
    ipcc = models.CharField(db_column='Ipcc', max_length=45)  # Field name made lowercase.
    usernameorid = models.CharField(db_column='userNameOrID', max_length=255)  # Field name made lowercase.
    password = models.CharField(max_length=255)
    agentusernameorid = models.CharField(db_column='agentUserNameOrID', max_length=500)  # Field name made lowercase.
    agtpassword = models.CharField(db_column='agtPassword', max_length=500)  # Field name made lowercase.
    useridorkey = models.CharField(db_column='userIDOrKey', max_length=255)  # Field name made lowercase.
    target = models.CharField(max_length=10)
    echotoken = models.CharField(db_column='echoToken', max_length=255)  # Field name made lowercase.
    host = models.CharField(max_length=255)
    bookingurl = models.CharField(db_column='bookingUrl', max_length=255)  # Field name made lowercase.
    ancillaryurl = models.CharField(db_column='ancillaryUrl', max_length=255)  # Field name made lowercase.
    partyinfo = models.TextField(db_column='partyInfo')  # Field name made lowercase.
    senderinfo = models.TextField(db_column='senderInfo')  # Field name made lowercase.
    credentialtype = models.CharField(db_column='credentialType', max_length=10)  # Field name made lowercase.
    airlinetype = models.CharField(db_column='airlineType', max_length=45)  # Field name made lowercase.
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"RestApiCredentials {self.id}"

    class Meta:
        managed = True
        db_table = 'rest_api_credentials'


class Sectors(models.Model):
    id = models.BigAutoField(primary_key=True)
    code = models.CharField(max_length=3)
    city = models.CharField(max_length=45)
    country = models.CharField(max_length=45)
    sectortype = models.CharField(db_column='sectorType', max_length=3)  # Field name made lowercase.
    allowtype = models.CharField(db_column='allowType', max_length=255)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"Sectors {self.id}"

    class Meta:
        managed = True
        db_table = 'sectors'
