"""
Cms models
"""
from django.db import models


class CallRecordings(models.Model):
    calldate = models.DateTimeField()
    owner = models.CharField(max_length=20)
    uuid = models.CharField(max_length=20)
    source = models.CharField(max_length=20)
    destination = models.CharField(max_length=20)
    direction = models.CharField(max_length=15)
    type = models.CharField(max_length=10)
    zulu_type = models.CharField(max_length=50, blank=True, null=True)
    exttocall = models.CharField(max_length=20, blank=True, null=True)
    cnam = models.CharField(max_length=20, blank=True, null=True)
    cnum = models.CharField(max_length=20, blank=True, null=True)
    voicemailfile = models.CharField(max_length=255, blank=True, null=True)
    recordingfile = models.CharField(max_length=255, blank=True, null=True)
    callrecordingtype = models.CharField(db_column='callRecordingType', max_length=6)  # Field name made lowercase.
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"CallRecordings {self.id}"

    class Meta:
        managed = True
        db_table = 'call_recordings'


class AssignCallRecordingFollowups(models.Model):
    id = models.BigAutoField(primary_key=True)
    followupid = models.BigIntegerField(db_column='followupId')  # Field name made lowercase.
    callrecordingid = models.BigIntegerField(db_column='callRecordingId')  # Field name made lowercase.
    statustype = models.CharField(db_column='statusType', max_length=9)  # Field name made lowercase.
    reasontype = models.CharField(db_column='reasonType', max_length=15, blank=True, null=True)  # Field name made lowercase.
    callrecordingtype = models.CharField(db_column='callRecordingType', max_length=6)  # Field name made lowercase.
    details = models.CharField(max_length=500)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"AssignCallRecordingFollowups {self.id}"

    class Meta:
        managed = True
        db_table = 'assign_call_recording_followups'


class CmsCallbackQueries(models.Model):
    id = models.BigAutoField(primary_key=True)
    customerid = models.ForeignKey('core.Customers', models.DO_NOTHING, db_column='customerId')  # Field name made lowercase.
    uuid = models.CharField(max_length=255)
    message = models.TextField(blank=True, null=True)
    leadfrom = models.CharField(db_column='leadFrom', max_length=1000)  # Field name made lowercase.
    sectors = models.CharField(max_length=255, blank=True, null=True)
    moduleid = models.IntegerField(db_column='moduleId', db_comment='1=Home,2=Umrah,3=Flights,4=Visa,6=WorldTour,7=Franchise,9=AboutUs,10=Contactus,11=Hotels,12=PKTour,13=Airlines,14=Hajj,18=TravelAgency,19=Whatsapp')  # Field name made lowercase.
    domintl = models.CharField(db_column='domIntl', max_length=20, blank=True, null=True)  # Field name made lowercase.
    airlinecode = models.CharField(db_column='airlineCode', max_length=5, blank=True, null=True)  # Field name made lowercase.
    country = models.CharField(max_length=15, blank=True, null=True)
    clientip = models.CharField(db_column='clientIp', max_length=20, blank=True, null=True, db_comment='Visitor IP Address')  # Field name made lowercase.
    clientbrowser = models.CharField(db_column='clientBrowser', max_length=254, blank=True, null=True, db_comment='Visitor Browser Information')  # Field name made lowercase.
    clientplatform = models.CharField(db_column='clientPlatform', max_length=254, blank=True, null=True, db_comment='Visitor Operating System Information')  # Field name made lowercase.
    ismobile = models.CharField(max_length=1, blank=True, null=True, db_comment='1=Mobile,2=Not Mobile')
    mobileinfo = models.CharField(db_column='mobileInfo', max_length=254, blank=True, null=True, db_comment='Visitor device')  # Field name made lowercase.
    referalurl = models.CharField(db_column='referalUrl', max_length=1000)  # Field name made lowercase.
    sourcetype = models.CharField(db_column='sourceType', max_length=20)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"CmsCallbackQueries {self.id}"

    class Meta:
        managed = True
        db_table = 'cms_callback_queries'


class CmsFaqs(models.Model):
    id = models.BigAutoField(primary_key=True)
    contentpageid = models.IntegerField(db_column='contentPageId')  # Field name made lowercase.
    question = models.CharField(max_length=255)
    answer = models.CharField(max_length=255)
    faqstatus = models.CharField(db_column='faqStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"CmsFaqs {self.id}"

    class Meta:
        managed = True
        db_table = 'cms_faqs'


class ContentPages(models.Model):
    parentid = models.ForeignKey('ParentPages', models.DO_NOTHING, db_column='parentId')  # Field name made lowercase.
    metatitle = models.CharField(db_column='metaTitle', max_length=100)  # Field name made lowercase.
    metadescription = models.TextField(db_column='metaDescription')  # Field name made lowercase.
    canonicalurl = models.CharField(db_column='canonicalUrl', max_length=100, blank=True, null=True)  # Field name made lowercase.
    urllink = models.CharField(db_column='urlLink', max_length=100)  # Field name made lowercase.
    packagetitle = models.CharField(db_column='packageTitle', max_length=50)  # Field name made lowercase.
    bannerimage = models.CharField(db_column='bannerImage', max_length=255, blank=True, null=True)  # Field name made lowercase.
    cardimage = models.CharField(db_column='cardImage', max_length=255, blank=True, null=True)  # Field name made lowercase.
    categories = models.CharField(max_length=50, blank=True, null=True)
    currencytype = models.CharField(db_column='currencyType', max_length=5)  # Field name made lowercase.
    price = models.CharField(max_length=20)
    sequence = models.IntegerField()
    shortdescription = models.TextField(db_column='shortDescription', blank=True, null=True)  # Field name made lowercase.
    includes = models.TextField(blank=True, null=True)
    excludes = models.TextField(blank=True, null=True)
    documentsrequired = models.TextField(db_column='documentsRequired', blank=True, null=True)  # Field name made lowercase.
    type = models.IntegerField()
    showonhome = models.IntegerField(db_column='showOnHome')  # Field name made lowercase.
    description = models.TextField(blank=True, null=True)
    status = models.IntegerField()
    activeid = models.IntegerField(db_column='activeId', blank=True, null=True)  # Field name made lowercase.
    activetype = models.CharField(db_column='activeType', max_length=20, blank=True, null=True)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"ContentPages {self.id}"

    class Meta:
        managed = True
        db_table = 'content_pages'


class ParentPages(models.Model):
    title = models.CharField(max_length=100)
    parenturl = models.CharField(db_column='parentUrl', max_length=100)  # Field name made lowercase.
    squanceorder = models.IntegerField(db_column='squanceOrder')  # Field name made lowercase.
    status = models.CharField(max_length=1)
    pagetype = models.CharField(db_column='pageType', max_length=1)  # Field name made lowercase.
    activeid = models.IntegerField(db_column='activeId')  # Field name made lowercase.
    activetype = models.CharField(db_column='activeType', max_length=20)  # Field name made lowercase.
    websitetype = models.CharField(db_column='websiteType', max_length=255)  # Field name made lowercase.
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.title}"

    class Meta:
        managed = True
        db_table = 'parent_pages'


class FollowupUserLogs(models.Model):
    id = models.BigAutoField(primary_key=True)
    userid = models.BigIntegerField(db_column='userId')  # Field name made lowercase.
    followupid = models.BigIntegerField(db_column='followupId')  # Field name made lowercase.
    activity = models.CharField(max_length=255)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"FollowupUserLogs {self.id}"

    class Meta:
        managed = True
        db_table = 'followup_user_logs'


class Followups(models.Model):
    id = models.BigAutoField(primary_key=True)
    branchid = models.BigIntegerField(db_column='branchId')  # Field name made lowercase.
    customerid = models.BigIntegerField(db_column='customerId')  # Field name made lowercase.
    userid = models.BigIntegerField(db_column='userId')  # Field name made lowercase.
    title = models.CharField(max_length=255)
    prioritytype = models.CharField(db_column='priorityType', max_length=6)  # Field name made lowercase.
    statustype = models.CharField(db_column='statusType', max_length=9)  # Field name made lowercase.
    moduletype = models.CharField(db_column='moduleType', max_length=19)  # Field name made lowercase.
    reasontype = models.CharField(db_column='reasonType', max_length=15, blank=True, null=True)  # Field name made lowercase.
    sourcetype = models.CharField(db_column='sourceType', max_length=14)  # Field name made lowercase.
    replyinminutes = models.CharField(db_column='replyInMinutes', max_length=25, blank=True, null=True)  # Field name made lowercase.
    estimatedreplytime = models.DateTimeField(db_column='estimatedReplyTime', blank=True, null=True)  # Field name made lowercase.
    lastcallstatus = models.CharField(db_column='lastCallStatus', max_length=15)  # Field name made lowercase.
    callrecordingtype = models.CharField(db_column='callRecordingType', max_length=6, blank=True, null=True)  # Field name made lowercase.
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.title}"

    class Meta:
        managed = True
        db_table = 'followups'
