"""
Payments models
"""
from django.db import models


class Payments(models.Model):
    agentid = models.PositiveIntegerField(db_column='agentId')  # Field name made lowercase.
    parentid = models.IntegerField(db_column='parentId')  # Field name made lowercase.
    refnumber = models.CharField(db_column='refNumber', max_length=255)  # Field name made lowercase.
    depositaccount = models.CharField(db_column='depositAccount', max_length=45)  # Field name made lowercase.
    createdid = models.PositiveIntegerField(db_column='createdId')  # Field name made lowercase.
    createdtype = models.CharField(db_column='createdType', max_length=5)  # Field name made lowercase.
    createdby = models.CharField(db_column='createdBy', max_length=45)  # Field name made lowercase.
    createddatetime = models.DateTimeField(db_column='createdDateTime')  # Field name made lowercase.
    approvedid = models.PositiveIntegerField(db_column='approvedId')  # Field name made lowercase.
    approvedtype = models.CharField(db_column='approvedType', max_length=5)  # Field name made lowercase.
    approvedby = models.CharField(db_column='approvedBy', max_length=45)  # Field name made lowercase.
    approveddatetime = models.DateTimeField(db_column='approvedDateTime', blank=True, null=True)  # Field name made lowercase.
    paymenttype = models.CharField(db_column='paymentType', max_length=25)  # Field name made lowercase.
    creditlimit = models.FloatField(db_column='creditLimit')  # Field name made lowercase.
    currentcreditlimit = models.FloatField(db_column='currentCreditLimit')  # Field name made lowercase.
    depositdate = models.DateTimeField(db_column='depositDate')  # Field name made lowercase.
    depositamount = models.FloatField(db_column='depositAmount')  # Field name made lowercase.
    attachment = models.CharField(max_length=255)
    details = models.CharField(max_length=1000)
    paymentstatus = models.CharField(db_column='paymentStatus', max_length=25)  # Field name made lowercase.
    transactiontype = models.CharField(db_column='transactionType', max_length=20)  # Field name made lowercase.
    scopetype = models.CharField(db_column='scopeType', max_length=25)  # Field name made lowercase.
    sourcetype = models.CharField(db_column='sourceType', max_length=20)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"Payments {self.id}"

    class Meta:
        managed = True
        db_table = 'payments'


class MarkupAndMarkdowns(models.Model):
    id = models.BigAutoField(primary_key=True)
    agentid = models.ForeignKey('accounts.Agents', models.DO_NOTHING, db_column='agentId')  # Field name made lowercase.
    parentid = models.PositiveBigIntegerField(db_column='parentId')  # Field name made lowercase.
    userid = models.PositiveBigIntegerField(db_column='userId')  # Field name made lowercase.
    postbyid = models.BigIntegerField(db_column='postbyId')  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5)  # Field name made lowercase.
    title = models.CharField(max_length=45)
    itinerarytype = models.CharField(db_column='itineraryType', max_length=3)  # Field name made lowercase.
    faretype = models.CharField(db_column='fareType', max_length=2)  # Field name made lowercase.
    servicefeetype = models.CharField(db_column='serviceFeeType', max_length=3)  # Field name made lowercase.
    passengertype = models.CharField(db_column='passengerType', max_length=5)  # Field name made lowercase.
    servicetype = models.CharField(db_column='serviceType', max_length=5)  # Field name made lowercase.
    markuptype = models.CharField(db_column='markupType', max_length=10)  # Field name made lowercase.
    servicefee = models.FloatField(db_column='serviceFee')  # Field name made lowercase.
    airlinetype = models.CharField(db_column='airlineType', max_length=25, blank=True, null=True)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.title}"

    class Meta:
        managed = True
        db_table = 'markup_and_markdowns'
