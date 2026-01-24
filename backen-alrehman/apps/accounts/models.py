"""
Accounts models
"""
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager


class Agents(models.Model):
    id = models.BigAutoField(primary_key=True)
    parentid = models.PositiveBigIntegerField(db_column='parentId')  # Field name made lowercase.
    accountid = models.BigIntegerField(db_column='accountId')  # Field name made lowercase.
    postbyid = models.BigIntegerField(db_column='postbyId')  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5)  # Field name made lowercase.
    branchid = models.PositiveBigIntegerField(db_column='branchId')  # Field name made lowercase.
    username = models.CharField(db_column='userName', max_length=255)  # Field name made lowercase.
    companyname = models.CharField(db_column='companyName', max_length=255)  # Field name made lowercase.
    email = models.CharField(max_length=255)
    secretid = models.CharField(db_column='secretId', max_length=500)  # Field name made lowercase.
    clientsecret = models.CharField(db_column='clientSecret', max_length=500)  # Field name made lowercase.
    password = models.CharField(max_length=500)
    remember_token = models.CharField(max_length=100)
    granttype = models.CharField(db_column='grantType', max_length=45)  # Field name made lowercase.
    scope = models.CharField(max_length=20)
    assignapi = models.CharField(db_column='assignApi', max_length=255)  # Field name made lowercase.
    ordercreate = models.CharField(db_column='orderCreate', max_length=255)  # Field name made lowercase.
    orderretrieve = models.CharField(db_column='orderRetrieve', max_length=255)  # Field name made lowercase.
    ordercancel = models.CharField(db_column='orderCancel', max_length=255)  # Field name made lowercase.
    orderissuance = models.CharField(db_column='orderIssuance', max_length=255)  # Field name made lowercase.
    ordervoid = models.CharField(db_column='orderVoid', max_length=255)  # Field name made lowercase.
    accountstatus = models.CharField(db_column='accountStatus', max_length=10)  # Field name made lowercase.
    usertype = models.CharField(db_column='userType', max_length=5)  # Field name made lowercase.
    markuptype = models.CharField(db_column='markupType', max_length=10)  # Field name made lowercase.
    portaltype = models.CharField(db_column='portalType', max_length=20)  # Field name made lowercase.
    paymenttype = models.CharField(db_column='paymentType', max_length=10)  # Field name made lowercase.
    creditlimit = models.FloatField(db_column='creditLimit')  # Field name made lowercase.
    tmpcreditlimit = models.FloatField(db_column='tmpCreditLimit')  # Field name made lowercase.
    currentcreditlimit = models.FloatField(db_column='currentCreditLimit')  # Field name made lowercase.
    businesstype = models.CharField(db_column='businessType', max_length=255)  # Field name made lowercase.
    careof = models.CharField(db_column='careOf', max_length=255)  # Field name made lowercase.
    mobileno = models.CharField(db_column='mobileNo', max_length=25)  # Field name made lowercase.
    phoneno = models.CharField(db_column='phoneNo', max_length=25)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.username}"

    class Meta:
        managed = True
        db_table = 'agents'


class Users(models.Model):
    id = models.BigAutoField(primary_key=True)
    agentid = models.PositiveIntegerField(db_column='agentId', blank=True, null=True)  # Field name made lowercase.
    parentid = models.IntegerField(db_column='parentId', blank=True, null=True)  # Field name made lowercase.
    postbyid = models.IntegerField(db_column='postById', blank=True, null=True)  # Field name made lowercase.
    postbytype = models.CharField(db_column='postByType', max_length=5, blank=True, null=True)  # Field name made lowercase.
    branchid = models.PositiveIntegerField(db_column='branchId')  # Field name made lowercase.
    accountid = models.IntegerField(db_column='accountId')  # Field name made lowercase.
    username = models.CharField(db_column='userName', max_length=255)  # Field name made lowercase.
    email = models.CharField(unique=True, max_length=255)
    designation = models.CharField(max_length=200, blank=True, null=True)
    department = models.CharField(max_length=11, blank=True, null=True)
    secretid = models.CharField(db_column='secretId', max_length=500, blank=True, null=True)  # Field name made lowercase.
    clientsecret = models.CharField(db_column='clientSecret', max_length=500, blank=True, null=True)  # Field name made lowercase.
    granttype = models.CharField(db_column='grantType', max_length=45)  # Field name made lowercase.
    markuptype = models.CharField(db_column='markupType', max_length=7)  # Field name made lowercase.
    scope = models.CharField(max_length=14)
    assignapi = models.CharField(db_column='assignApi', max_length=255)  # Field name made lowercase.
    ordercreate = models.CharField(db_column='orderCreate', max_length=255)  # Field name made lowercase.
    orderretrieve = models.CharField(db_column='orderRetrieve', max_length=255)  # Field name made lowercase.
    ordercancel = models.CharField(db_column='orderCancel', max_length=255)  # Field name made lowercase.
    orderissuance = models.CharField(db_column='orderIssuance', max_length=255)  # Field name made lowercase.
    ordervoid = models.CharField(db_column='orderVoid', max_length=255)  # Field name made lowercase.
    password = models.CharField(max_length=500, blank=True, null=True)
    remember_token = models.CharField(max_length=100, blank=True, null=True)
    typeofid = models.CharField(db_column='typeOfId', max_length=13)  # Field name made lowercase.
    accountstatus = models.CharField(db_column='accountStatus', max_length=9)  # Field name made lowercase.
    paymenttype = models.CharField(db_column='paymentType', max_length=6)  # Field name made lowercase.
    usertype = models.CharField(db_column='userType', max_length=9)  # Field name made lowercase.
    creditlimit = models.FloatField(db_column='creditLimit')  # Field name made lowercase.
    tmpcreditlimit = models.FloatField(db_column='tmpCreditLimit')  # Field name made lowercase.
    currentcreditlimit = models.FloatField(db_column='currentCreditLimit')  # Field name made lowercase.
    mobileno = models.CharField(db_column='mobileNo', max_length=25)  # Field name made lowercase.
    phoneno = models.CharField(db_column='phoneNo', max_length=25)  # Field name made lowercase.
    address = models.CharField(max_length=500)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.username}"

    class Meta:
        managed = True
        db_table = 'users'


class Permissions(models.Model):
    title = models.CharField(max_length=255)
    moduletype = models.CharField(db_column='moduleType', max_length=255)  # Field name made lowercase.
    agentid = models.IntegerField(db_column='agentId')  # Field name made lowercase.
    parentid = models.IntegerField(db_column='parentId')  # Field name made lowercase.
    userid = models.IntegerField(db_column='userId')  # Field name made lowercase.
    permissiontypeid = models.ForeignKey('PermissionTypes', models.DO_NOTHING, db_column='permissionTypeId')  # Field name made lowercase.
    assigntype = models.CharField(db_column='assignType', max_length=5)  # Field name made lowercase.
    postbyid = models.IntegerField(db_column='postbyId')  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.title}"

    class Meta:
        managed = True
        db_table = 'permissions'


class PermissionAssigns(models.Model):
    agentid = models.IntegerField(db_column='agentId')  # Field name made lowercase.
    parentid = models.IntegerField(db_column='parentId')  # Field name made lowercase.
    userid = models.IntegerField(db_column='userId')  # Field name made lowercase.
    permissionid = models.PositiveIntegerField(db_column='permissionId')  # Field name made lowercase.
    moduletype = models.CharField(db_column='moduleType', max_length=15)  # Field name made lowercase.
    assigntype = models.CharField(db_column='assignType', max_length=5)  # Field name made lowercase.
    postbyid = models.IntegerField(db_column='postbyId')  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"PermissionAssigns {self.id}"

    class Meta:
        managed = True
        db_table = 'permission_assigns'


class PermissionTypes(models.Model):
    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=255)
    moduletype = models.CharField(db_column='moduleType', max_length=14)  # Field name made lowercase.
    postbyid = models.BigIntegerField(db_column='postbyId')  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.title}"

    class Meta:
        managed = True
        db_table = 'permission_types'
