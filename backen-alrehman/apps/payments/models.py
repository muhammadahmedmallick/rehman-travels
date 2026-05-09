"""
Payments models
"""
from django.db import models
from apps.core.base_models import LegacyModel


class APGTransaction(models.Model):
    """
    Tracks every Alfa Payment Gateway (APG) transaction initiated from the
    mobile app.  This is a fully managed PostgreSQL table (not legacy).

    Flow:
      1. Flutter calls POST /api/payments/apg/initiate/ → record created (pending)
      2. APG calls POST /api/payments/apg/ipn/         → record updated (paid/failed)
      3. Flutter calls GET  /api/payments/apg/status/<ref>/ → reads current status
    """

    STATUS_PENDING   = 'pending'
    STATUS_PAID      = 'paid'
    STATUS_FAILED    = 'failed'
    STATUS_CANCELLED = 'cancelled'

    STATUS_CHOICES = [
        (STATUS_PENDING,   'Pending'),
        (STATUS_PAID,      'Paid'),
        (STATUS_FAILED,    'Failed'),
        (STATUS_CANCELLED, 'Cancelled'),
    ]

    # ── Merchant reference (we generate this, also sent to APG as
    #    TransactionReferenceNumber so it comes back in IPN responses)
    transaction_ref = models.CharField(
        max_length=150, unique=True, db_index=True,
        help_text="Merchant-generated unique ref (= booking PNR sent to APG)",
    )

    # ── APG identifiers (populated after APG responds)
    order_id = models.CharField(
        max_length=150, blank=True, null=True, db_index=True,
        help_text="APG Order ID returned in return-URL query param ?O=",
    )
    apg_transaction_id = models.CharField(
        max_length=150, blank=True, null=True,
        help_text="APG's internal TransactionId from IPN response",
    )

    # ── Booking context (passed in by Flutter at initiation)
    booking_pnr       = models.CharField(max_length=150, blank=True, null=True)
    booking_reference = models.CharField(max_length=150, blank=True, null=True)
    air_type          = models.CharField(max_length=50,  blank=True, null=True)

    # ── Financial details
    amount   = models.DecimalField(max_digits=14, decimal_places=2, default=0)
    currency = models.CharField(max_length=10, default='PKR')

    # ── Status
    transaction_status = models.CharField(
        max_length=20, choices=STATUS_CHOICES,
        default=STATUS_PENDING, db_index=True,
    )

    # ── APG response fields (flattened for easy querying)
    response_code        = models.CharField(max_length=10,  blank=True, null=True)
    account_number       = models.CharField(max_length=50,  blank=True, null=True)
    mobile_number        = models.CharField(max_length=20,  blank=True, null=True)
    order_datetime       = models.CharField(max_length=50,  blank=True, null=True)
    transaction_datetime = models.CharField(max_length=50,  blank=True, null=True)

    # ── Full APG JSON response stored for auditing / debugging
    apg_response = models.JSONField(blank=True, null=True)

    # ── Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'apg_transactions'
        ordering = ['-created_at']
        verbose_name = 'APG Transaction'
        verbose_name_plural = 'APG Transactions'

    def __str__(self):
        return f"APGTxn {self.transaction_ref} [{self.transaction_status}]"

    @property
    def is_paid(self):
        return self.transaction_status == self.STATUS_PAID

    def update_from_apg_response(self, apg_data: dict):
        """Apply an IPN / inquiry JSON response to this transaction."""
        apg_status = apg_data.get('TransactionStatus', '').lower()
        self.transaction_status = (
            self.STATUS_PAID if apg_status == 'paid' else self.STATUS_FAILED
        )
        self.order_id            = apg_data.get('TransactionReferenceNumber', self.order_id)
        self.apg_transaction_id  = apg_data.get('TransactionId', '')
        self.response_code       = apg_data.get('ResponseCode', '')
        self.account_number      = apg_data.get('AccountNumber', '')
        self.mobile_number       = apg_data.get('MobileNumber', '')
        self.order_datetime      = apg_data.get('OrderDateTime', '')
        self.transaction_datetime = apg_data.get('TransactionDateTime', '')
        self.apg_response        = apg_data
        self.save()



class Payments(LegacyModel):
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
        managed = False
        db_table = 'payments'


class MarkupAndMarkdowns(LegacyModel):
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
        managed = False
        db_table = 'markup_and_markdowns'
