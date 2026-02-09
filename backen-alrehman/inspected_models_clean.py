time="2026-01-24T22:45:40+05:00" level=warning msg="/Users/muhammadahmed/Desktop/personal/rehman-travels/backen-alrehman/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
                SELECT VERSION(),
                       @@sql_mode,
                       @@default_storage_engine,
                       @@sql_auto_is_null,
                       @@lower_case_table_names,
                       CONVERT_TZ('2001-01-01 01:00:00', 'UTC', 'UTC') IS NOT NULL
            ; args=None; alias=default
# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
            SELECT
                table_name,
                table_type,
                table_comment
            FROM information_schema.tables
            WHERE table_schema = DATABASE()
            ; args=None; alias=default
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'administrative_settings'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['administrative_settings']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'administrative_settings'
            ORDER BY kc.`ordinal_position`
        ; args=['administrative_settings']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'administrative_settings'
            ; args=['administrative_settings']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'administrative_settings' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'administrative_settings']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'administrative_settings'
                ; args=['administrative_settings']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'administrative_settings'
            ORDER BY kc.`ordinal_position`
        ; args=['administrative_settings']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'administrative_settings'
            ; args=['administrative_settings']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'administrative_settings' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'administrative_settings']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'administrative_settings'
                ; args=['administrative_settings']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'administrative_settings'
            ; args=['administrative_settings']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'administrative_settings' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'administrative_settings']; alias=default


class AdministrativeSettings(models.Model):
    name = models.CharField(max_length=50)
    email = models.CharField(max_length=25)
    contactno = models.CharField(db_column='contactNo', max_length=20)  # Field name made lowercase.
    status = models.CharField(max_length=1)
    ceated_at = models.DateTimeField()
    created_by = models.IntegerField()
    updated_at = models.DateTimeField(blank=True, null=True)
    updated_by = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'administrative_settings'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'agents'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['agents']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'agents'
            ORDER BY kc.`ordinal_position`
        ; args=['agents']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'agents'
            ; args=['agents']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'agents' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'agents']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'agents'
                ; args=['agents']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'agents'
            ORDER BY kc.`ordinal_position`
        ; args=['agents']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'agents'
            ; args=['agents']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'agents' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'agents']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'agents'
                ; args=['agents']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'agents'
            ; args=['agents']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'agents' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'agents']; alias=default


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

    class Meta:
        managed = False
        db_table = 'agents'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'airline_name_codes'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['airline_name_codes']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'airline_name_codes'
            ORDER BY kc.`ordinal_position`
        ; args=['airline_name_codes']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'airline_name_codes'
            ; args=['airline_name_codes']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'airline_name_codes' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'airline_name_codes']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'airline_name_codes'
                ; args=['airline_name_codes']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'airline_name_codes'
            ORDER BY kc.`ordinal_position`
        ; args=['airline_name_codes']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'airline_name_codes'
            ; args=['airline_name_codes']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'airline_name_codes' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'airline_name_codes']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'airline_name_codes'
                ; args=['airline_name_codes']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'airline_name_codes'
            ; args=['airline_name_codes']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'airline_name_codes' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'airline_name_codes']; alias=default


class AirlineNameCodes(models.Model):
    id = models.BigAutoField(primary_key=True)
    airlinename = models.CharField(db_column='airlineName', max_length=100)  # Field name made lowercase.
    countryname = models.CharField(db_column='countryName', max_length=100)  # Field name made lowercase.
    carriercode = models.CharField(db_column='carrierCode', max_length=10)  # Field name made lowercase.
    iatacode = models.CharField(db_column='iataCode', max_length=10)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'airline_name_codes'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'assign_call_recording_followups'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['assign_call_recording_followups']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'assign_call_recording_followups'
            ORDER BY kc.`ordinal_position`
        ; args=['assign_call_recording_followups']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'assign_call_recording_followups'
            ; args=['assign_call_recording_followups']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'assign_call_recording_followups' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'assign_call_recording_followups']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'assign_call_recording_followups'
                ; args=['assign_call_recording_followups']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'assign_call_recording_followups'
            ORDER BY kc.`ordinal_position`
        ; args=['assign_call_recording_followups']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'assign_call_recording_followups'
            ; args=['assign_call_recording_followups']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'assign_call_recording_followups' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'assign_call_recording_followups']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'assign_call_recording_followups'
                ; args=['assign_call_recording_followups']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'assign_call_recording_followups'
            ; args=['assign_call_recording_followups']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'assign_call_recording_followups' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'assign_call_recording_followups']; alias=default


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

    class Meta:
        managed = False
        db_table = 'assign_call_recording_followups'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'auth_group'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['auth_group']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_group'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_group']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group'
            ; args=['auth_group']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_group' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_group']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_group'
                ; args=['auth_group']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_group'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_group']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group'
            ; args=['auth_group']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_group' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_group']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_group'
                ; args=['auth_group']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group'
            ; args=['auth_group']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_group' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_group']; alias=default


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'auth_group_permissions'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['auth_group_permissions']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_group_permissions'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_group_permissions']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group_permissions'
            ; args=['auth_group_permissions']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_group_permissions' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_group_permissions']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_group_permissions'
                ; args=['auth_group_permissions']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_group_permissions'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_group_permissions']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group_permissions'
            ; args=['auth_group_permissions']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_group_permissions' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_group_permissions']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_group_permissions'
                ; args=['auth_group_permissions']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group_permissions'
            ; args=['auth_group_permissions']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_group_permissions' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_group_permissions']; alias=default


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_group'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_group']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group'
            ; args=['auth_group']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_group' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_group']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_group'
                ; args=['auth_group']; alias=default
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_permission'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_permission']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_permission'
            ; args=['auth_permission']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_permission' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_permission']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_permission'
                ; args=['auth_permission']; alias=default
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'auth_permission'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['auth_permission']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_permission'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_permission']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_permission'
            ; args=['auth_permission']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_permission' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_permission']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_permission'
                ; args=['auth_permission']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_permission'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_permission']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_permission'
            ; args=['auth_permission']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_permission' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_permission']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_permission'
                ; args=['auth_permission']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_permission'
            ; args=['auth_permission']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_permission' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_permission']; alias=default


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'django_content_type'
            ORDER BY kc.`ordinal_position`
        ; args=['django_content_type']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_content_type'
            ; args=['django_content_type']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_content_type' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_content_type']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'django_content_type'
                ; args=['django_content_type']; alias=default
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'auth_user'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['auth_user']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_user'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_user']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user'
            ; args=['auth_user']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_user' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_user']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_user'
                ; args=['auth_user']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_user'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_user']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user'
            ; args=['auth_user']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_user' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_user']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_user'
                ; args=['auth_user']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user'
            ; args=['auth_user']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_user' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_user']; alias=default


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'auth_user_groups'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['auth_user_groups']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_user_groups'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_user_groups']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user_groups'
            ; args=['auth_user_groups']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_user_groups' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_user_groups']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_user_groups'
                ; args=['auth_user_groups']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_user_groups'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_user_groups']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user_groups'
            ; args=['auth_user_groups']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_user_groups' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_user_groups']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_user_groups'
                ; args=['auth_user_groups']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user_groups'
            ; args=['auth_user_groups']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_user_groups' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_user_groups']; alias=default


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_user'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_user']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user'
            ; args=['auth_user']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_user' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_user']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_user'
                ; args=['auth_user']; alias=default
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_group'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_group']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group'
            ; args=['auth_group']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_group' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_group']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_group'
                ; args=['auth_group']; alias=default
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'auth_user_user_permissions'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['auth_user_user_permissions']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_user_user_permissions'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_user_user_permissions']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user_user_permissions'
            ; args=['auth_user_user_permissions']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_user_user_permissions' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_user_user_permissions']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_user_user_permissions'
                ; args=['auth_user_user_permissions']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_user_user_permissions'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_user_user_permissions']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user_user_permissions'
            ; args=['auth_user_user_permissions']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_user_user_permissions' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_user_user_permissions']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_user_user_permissions'
                ; args=['auth_user_user_permissions']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user_user_permissions'
            ; args=['auth_user_user_permissions']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_user_user_permissions' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_user_user_permissions']; alias=default


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_user'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_user']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user'
            ; args=['auth_user']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_user' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_user']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_user'
                ; args=['auth_user']; alias=default
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_permission'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_permission']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_permission'
            ; args=['auth_permission']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_permission' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_permission']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_permission'
                ; args=['auth_permission']; alias=default
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'bank_details'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['bank_details']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'bank_details'
            ORDER BY kc.`ordinal_position`
        ; args=['bank_details']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'bank_details'
            ; args=['bank_details']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'bank_details' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'bank_details']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'bank_details'
                ; args=['bank_details']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'bank_details'
            ORDER BY kc.`ordinal_position`
        ; args=['bank_details']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'bank_details'
            ; args=['bank_details']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'bank_details' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'bank_details']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'bank_details'
                ; args=['bank_details']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'bank_details'
            ; args=['bank_details']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'bank_details' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'bank_details']; alias=default


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

    class Meta:
        managed = False
        db_table = 'bank_details'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'branches'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['branches']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'branches'
            ORDER BY kc.`ordinal_position`
        ; args=['branches']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'branches'
            ; args=['branches']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'branches' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'branches']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'branches'
                ; args=['branches']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'branches'
            ORDER BY kc.`ordinal_position`
        ; args=['branches']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'branches'
            ; args=['branches']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'branches' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'branches']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'branches'
                ; args=['branches']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'branches'
            ; args=['branches']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'branches' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'branches']; alias=default


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

    class Meta:
        managed = False
        db_table = 'branches'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'call_recordings'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['call_recordings']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'call_recordings'
            ORDER BY kc.`ordinal_position`
        ; args=['call_recordings']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'call_recordings'
            ; args=['call_recordings']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'call_recordings' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'call_recordings']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'call_recordings'
                ; args=['call_recordings']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'call_recordings'
            ORDER BY kc.`ordinal_position`
        ; args=['call_recordings']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'call_recordings'
            ; args=['call_recordings']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'call_recordings' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'call_recordings']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'call_recordings'
                ; args=['call_recordings']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'call_recordings'
            ; args=['call_recordings']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'call_recordings' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'call_recordings']; alias=default


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

    class Meta:
        managed = False
        db_table = 'call_recordings'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'cms_callback_queries'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['cms_callback_queries']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'cms_callback_queries'
            ORDER BY kc.`ordinal_position`
        ; args=['cms_callback_queries']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_callback_queries'
            ; args=['cms_callback_queries']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_callback_queries' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_callback_queries']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'cms_callback_queries'
                ; args=['cms_callback_queries']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'cms_callback_queries'
            ORDER BY kc.`ordinal_position`
        ; args=['cms_callback_queries']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_callback_queries'
            ; args=['cms_callback_queries']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_callback_queries' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_callback_queries']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'cms_callback_queries'
                ; args=['cms_callback_queries']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_callback_queries'
            ; args=['cms_callback_queries']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_callback_queries' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_callback_queries']; alias=default


class CmsCallbackQueries(models.Model):
    id = models.BigAutoField(primary_key=True)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'customers'
            ORDER BY kc.`ordinal_position`
        ; args=['customers']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'customers'
            ; args=['customers']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'customers' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'customers']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'customers'
                ; args=['customers']; alias=default
    customerid = models.ForeignKey('Customers', models.DO_NOTHING, db_column='customerId')  # Field name made lowercase.
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

    class Meta:
        managed = False
        db_table = 'cms_callback_queries'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'cms_faqs'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['cms_faqs']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'cms_faqs'
            ORDER BY kc.`ordinal_position`
        ; args=['cms_faqs']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_faqs'
            ; args=['cms_faqs']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_faqs' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_faqs']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'cms_faqs'
                ; args=['cms_faqs']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'cms_faqs'
            ORDER BY kc.`ordinal_position`
        ; args=['cms_faqs']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_faqs'
            ; args=['cms_faqs']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_faqs' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_faqs']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'cms_faqs'
                ; args=['cms_faqs']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_faqs'
            ; args=['cms_faqs']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_faqs' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_faqs']; alias=default


class CmsFaqs(models.Model):
    id = models.BigAutoField(primary_key=True)
    contentpageid = models.IntegerField(db_column='contentPageId')  # Field name made lowercase.
    question = models.CharField(max_length=255)
    answer = models.CharField(max_length=255)
    faqstatus = models.CharField(db_column='faqStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'cms_faqs'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'cms_visa_durations'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['cms_visa_durations']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'cms_visa_durations'
            ORDER BY kc.`ordinal_position`
        ; args=['cms_visa_durations']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_durations'
            ; args=['cms_visa_durations']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_visa_durations' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_visa_durations']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'cms_visa_durations'
                ; args=['cms_visa_durations']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'cms_visa_durations'
            ORDER BY kc.`ordinal_position`
        ; args=['cms_visa_durations']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_durations'
            ; args=['cms_visa_durations']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_visa_durations' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_visa_durations']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'cms_visa_durations'
                ; args=['cms_visa_durations']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_durations'
            ; args=['cms_visa_durations']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_visa_durations' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_visa_durations']; alias=default


class CmsVisaDurations(models.Model):
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'cms_visa_packages'
            ORDER BY kc.`ordinal_position`
        ; args=['cms_visa_packages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_packages'
            ; args=['cms_visa_packages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_visa_packages' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_visa_packages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'cms_visa_packages'
                ; args=['cms_visa_packages']; alias=default
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

    class Meta:
        managed = False
        db_table = 'cms_visa_durations'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'cms_visa_packages'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['cms_visa_packages']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'cms_visa_packages'
            ORDER BY kc.`ordinal_position`
        ; args=['cms_visa_packages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_packages'
            ; args=['cms_visa_packages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_visa_packages' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_visa_packages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'cms_visa_packages'
                ; args=['cms_visa_packages']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'cms_visa_packages'
            ORDER BY kc.`ordinal_position`
        ; args=['cms_visa_packages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_packages'
            ; args=['cms_visa_packages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_visa_packages' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_visa_packages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'cms_visa_packages'
                ; args=['cms_visa_packages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_packages'
            ; args=['cms_visa_packages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'cms_visa_packages' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'cms_visa_packages']; alias=default


class CmsVisaPackages(models.Model):
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'content_pages'
            ORDER BY kc.`ordinal_position`
        ; args=['content_pages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'content_pages'
            ; args=['content_pages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'content_pages' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'content_pages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'content_pages'
                ; args=['content_pages']; alias=default
    cmscontentid = models.ForeignKey('ContentPages', models.DO_NOTHING, db_column='cmsContentId')  # Field name made lowercase.
    countryname = models.CharField(db_column='countryName', max_length=255)  # Field name made lowercase.
    packageurl = models.CharField(db_column='packageUrl', max_length=255, blank=True, null=True)  # Field name made lowercase.
    toururl = models.CharField(db_column='tourUrl', max_length=255, blank=True, null=True)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'cms_visa_packages'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'content_pages'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['content_pages']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'content_pages'
            ORDER BY kc.`ordinal_position`
        ; args=['content_pages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'content_pages'
            ; args=['content_pages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'content_pages' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'content_pages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'content_pages'
                ; args=['content_pages']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'content_pages'
            ORDER BY kc.`ordinal_position`
        ; args=['content_pages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'content_pages'
            ; args=['content_pages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'content_pages' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'content_pages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'content_pages'
                ; args=['content_pages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'content_pages'
            ; args=['content_pages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'content_pages' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'content_pages']; alias=default


class ContentPages(models.Model):
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'parent_pages'
            ORDER BY kc.`ordinal_position`
        ; args=['parent_pages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'parent_pages'
            ; args=['parent_pages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'parent_pages' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'parent_pages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'parent_pages'
                ; args=['parent_pages']; alias=default
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

    class Meta:
        managed = False
        db_table = 'content_pages'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'currencies'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['currencies']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'currencies'
            ORDER BY kc.`ordinal_position`
        ; args=['currencies']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'currencies'
            ; args=['currencies']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'currencies' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'currencies']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'currencies'
                ; args=['currencies']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'currencies'
            ORDER BY kc.`ordinal_position`
        ; args=['currencies']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'currencies'
            ; args=['currencies']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'currencies' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'currencies']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'currencies'
                ; args=['currencies']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'currencies'
            ; args=['currencies']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'currencies' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'currencies']; alias=default


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

    class Meta:
        managed = False
        db_table = 'currencies'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'customers'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['customers']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'customers'
            ORDER BY kc.`ordinal_position`
        ; args=['customers']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'customers'
            ; args=['customers']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'customers' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'customers']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'customers'
                ; args=['customers']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'customers'
            ORDER BY kc.`ordinal_position`
        ; args=['customers']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'customers'
            ; args=['customers']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'customers' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'customers']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'customers'
                ; args=['customers']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'customers'
            ; args=['customers']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'customers' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'customers']; alias=default


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

    class Meta:
        managed = False
        db_table = 'customers'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'django_admin_log'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['django_admin_log']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'django_admin_log'
            ORDER BY kc.`ordinal_position`
        ; args=['django_admin_log']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_admin_log'
            ; args=['django_admin_log']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_admin_log' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_admin_log']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'django_admin_log'
                ; args=['django_admin_log']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'django_admin_log'
            ORDER BY kc.`ordinal_position`
        ; args=['django_admin_log']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_admin_log'
            ; args=['django_admin_log']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_admin_log' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_admin_log']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'django_admin_log'
                ; args=['django_admin_log']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_admin_log'
            ; args=['django_admin_log']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_admin_log' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_admin_log']; alias=default


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'django_content_type'
            ORDER BY kc.`ordinal_position`
        ; args=['django_content_type']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_content_type'
            ; args=['django_content_type']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_content_type' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_content_type']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'django_content_type'
                ; args=['django_content_type']; alias=default
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'auth_user'
            ORDER BY kc.`ordinal_position`
        ; args=['auth_user']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user'
            ; args=['auth_user']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'auth_user' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'auth_user']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'auth_user'
                ; args=['auth_user']; alias=default
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'django_content_type'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['django_content_type']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'django_content_type'
            ORDER BY kc.`ordinal_position`
        ; args=['django_content_type']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_content_type'
            ; args=['django_content_type']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_content_type' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_content_type']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'django_content_type'
                ; args=['django_content_type']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'django_content_type'
            ORDER BY kc.`ordinal_position`
        ; args=['django_content_type']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_content_type'
            ; args=['django_content_type']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_content_type' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_content_type']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'django_content_type'
                ; args=['django_content_type']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_content_type'
            ; args=['django_content_type']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_content_type' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_content_type']; alias=default


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'django_migrations'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['django_migrations']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'django_migrations'
            ORDER BY kc.`ordinal_position`
        ; args=['django_migrations']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_migrations'
            ; args=['django_migrations']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_migrations' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_migrations']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'django_migrations'
                ; args=['django_migrations']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'django_migrations'
            ORDER BY kc.`ordinal_position`
        ; args=['django_migrations']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_migrations'
            ; args=['django_migrations']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_migrations' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_migrations']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'django_migrations'
                ; args=['django_migrations']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_migrations'
            ; args=['django_migrations']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_migrations' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_migrations']; alias=default


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'django_session'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['django_session']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'django_session'
            ORDER BY kc.`ordinal_position`
        ; args=['django_session']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_session'
            ; args=['django_session']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_session' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_session']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'django_session'
                ; args=['django_session']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'django_session'
            ORDER BY kc.`ordinal_position`
        ; args=['django_session']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_session'
            ; args=['django_session']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_session' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_session']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'django_session'
                ; args=['django_session']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_session'
            ; args=['django_session']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'django_session' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'django_session']; alias=default


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'failed_jobs'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['failed_jobs']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'failed_jobs'
            ORDER BY kc.`ordinal_position`
        ; args=['failed_jobs']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'failed_jobs'
            ; args=['failed_jobs']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'failed_jobs' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'failed_jobs']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'failed_jobs'
                ; args=['failed_jobs']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'failed_jobs'
            ORDER BY kc.`ordinal_position`
        ; args=['failed_jobs']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'failed_jobs'
            ; args=['failed_jobs']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'failed_jobs' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'failed_jobs']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'failed_jobs'
                ; args=['failed_jobs']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'failed_jobs'
            ; args=['failed_jobs']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'failed_jobs' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'failed_jobs']; alias=default


class FailedJobs(models.Model):
    id = models.BigAutoField(primary_key=True)
    uuid = models.CharField(unique=True, max_length=255)
    connection = models.TextField()
    queue = models.TextField()
    payload = models.TextField()
    exception = models.TextField()
    failed_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'failed_jobs'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'flight_booking_references'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['flight_booking_references']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'flight_booking_references'
            ORDER BY kc.`ordinal_position`
        ; args=['flight_booking_references']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_booking_references'
            ; args=['flight_booking_references']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_booking_references' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'flight_booking_references']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'flight_booking_references'
                ; args=['flight_booking_references']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'flight_booking_references'
            ORDER BY kc.`ordinal_position`
        ; args=['flight_booking_references']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_booking_references'
            ; args=['flight_booking_references']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_booking_references' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'flight_booking_references']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'flight_booking_references'
                ; args=['flight_booking_references']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_booking_references'
            ; args=['flight_booking_references']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_booking_references' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'flight_booking_references']; alias=default


class FlightBookingReferences(models.Model):
    bookingrefid = models.IntegerField(db_column='bookingRefId')  # Field name made lowercase.
    response = models.TextField(db_collation='utf8mb4_bin')
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'flight_booking_references'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'flight_itinerary_infos'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['flight_itinerary_infos']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'flight_itinerary_infos'
            ORDER BY kc.`ordinal_position`
        ; args=['flight_itinerary_infos']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_infos'
            ; args=['flight_itinerary_infos']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_itinerary_infos' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'flight_itinerary_infos']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'flight_itinerary_infos'
                ; args=['flight_itinerary_infos']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'flight_itinerary_infos'
            ORDER BY kc.`ordinal_position`
        ; args=['flight_itinerary_infos']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_infos'
            ; args=['flight_itinerary_infos']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_itinerary_infos' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'flight_itinerary_infos']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'flight_itinerary_infos'
                ; args=['flight_itinerary_infos']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_infos'
            ; args=['flight_itinerary_infos']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_itinerary_infos' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'flight_itinerary_infos']; alias=default


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

    class Meta:
        managed = False
        db_table = 'flight_itinerary_infos'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'flight_itinerary_leg_infos'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['flight_itinerary_leg_infos']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'flight_itinerary_leg_infos'
            ORDER BY kc.`ordinal_position`
        ; args=['flight_itinerary_leg_infos']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_leg_infos'
            ; args=['flight_itinerary_leg_infos']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_itinerary_leg_infos' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'flight_itinerary_leg_infos']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'flight_itinerary_leg_infos'
                ; args=['flight_itinerary_leg_infos']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'flight_itinerary_leg_infos'
            ORDER BY kc.`ordinal_position`
        ; args=['flight_itinerary_leg_infos']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_leg_infos'
            ; args=['flight_itinerary_leg_infos']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_itinerary_leg_infos' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'flight_itinerary_leg_infos']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'flight_itinerary_leg_infos'
                ; args=['flight_itinerary_leg_infos']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_leg_infos'
            ; args=['flight_itinerary_leg_infos']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_itinerary_leg_infos' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'flight_itinerary_leg_infos']; alias=default


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

    class Meta:
        managed = False
        db_table = 'flight_itinerary_leg_infos'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'flight_itinerary_person_infos'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['flight_itinerary_person_infos']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'flight_itinerary_person_infos'
            ORDER BY kc.`ordinal_position`
        ; args=['flight_itinerary_person_infos']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_person_infos'
            ; args=['flight_itinerary_person_infos']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_itinerary_person_infos' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'flight_itinerary_person_infos']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'flight_itinerary_person_infos'
                ; args=['flight_itinerary_person_infos']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'flight_itinerary_person_infos'
            ORDER BY kc.`ordinal_position`
        ; args=['flight_itinerary_person_infos']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_person_infos'
            ; args=['flight_itinerary_person_infos']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_itinerary_person_infos' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'flight_itinerary_person_infos']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'flight_itinerary_person_infos'
                ; args=['flight_itinerary_person_infos']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_person_infos'
            ; args=['flight_itinerary_person_infos']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_itinerary_person_infos' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'flight_itinerary_person_infos']; alias=default


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

    class Meta:
        managed = False
        db_table = 'flight_itinerary_person_infos'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'flight_itineraryref_markup_infos'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['flight_itineraryref_markup_infos']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'flight_itineraryref_markup_infos'
            ORDER BY kc.`ordinal_position`
        ; args=['flight_itineraryref_markup_infos']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itineraryref_markup_infos'
            ; args=['flight_itineraryref_markup_infos']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_itineraryref_markup_infos' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'flight_itineraryref_markup_infos']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'flight_itineraryref_markup_infos'
                ; args=['flight_itineraryref_markup_infos']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'flight_itineraryref_markup_infos'
            ORDER BY kc.`ordinal_position`
        ; args=['flight_itineraryref_markup_infos']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itineraryref_markup_infos'
            ; args=['flight_itineraryref_markup_infos']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_itineraryref_markup_infos' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'flight_itineraryref_markup_infos']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'flight_itineraryref_markup_infos'
                ; args=['flight_itineraryref_markup_infos']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itineraryref_markup_infos'
            ; args=['flight_itineraryref_markup_infos']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'flight_itineraryref_markup_infos' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'flight_itineraryref_markup_infos']; alias=default


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

    class Meta:
        managed = False
        db_table = 'flight_itineraryref_markup_infos'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'followup_user_logs'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['followup_user_logs']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'followup_user_logs'
            ORDER BY kc.`ordinal_position`
        ; args=['followup_user_logs']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'followup_user_logs'
            ; args=['followup_user_logs']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'followup_user_logs' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'followup_user_logs']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'followup_user_logs'
                ; args=['followup_user_logs']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'followup_user_logs'
            ORDER BY kc.`ordinal_position`
        ; args=['followup_user_logs']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'followup_user_logs'
            ; args=['followup_user_logs']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'followup_user_logs' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'followup_user_logs']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'followup_user_logs'
                ; args=['followup_user_logs']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'followup_user_logs'
            ; args=['followup_user_logs']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'followup_user_logs' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'followup_user_logs']; alias=default


class FollowupUserLogs(models.Model):
    id = models.BigAutoField(primary_key=True)
    userid = models.BigIntegerField(db_column='userId')  # Field name made lowercase.
    followupid = models.BigIntegerField(db_column='followupId')  # Field name made lowercase.
    activity = models.CharField(max_length=255)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'followup_user_logs'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'followups'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['followups']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'followups'
            ORDER BY kc.`ordinal_position`
        ; args=['followups']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'followups'
            ; args=['followups']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'followups' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'followups']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'followups'
                ; args=['followups']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'followups'
            ORDER BY kc.`ordinal_position`
        ; args=['followups']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'followups'
            ; args=['followups']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'followups' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'followups']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'followups'
                ; args=['followups']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'followups'
            ; args=['followups']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'followups' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'followups']; alias=default


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

    class Meta:
        managed = False
        db_table = 'followups'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'inoutbounds'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['inoutbounds']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'inoutbounds'
            ORDER BY kc.`ordinal_position`
        ; args=['inoutbounds']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'inoutbounds'
            ; args=['inoutbounds']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'inoutbounds' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'inoutbounds']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'inoutbounds'
                ; args=['inoutbounds']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'inoutbounds'
            ORDER BY kc.`ordinal_position`
        ; args=['inoutbounds']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'inoutbounds'
            ; args=['inoutbounds']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'inoutbounds' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'inoutbounds']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'inoutbounds'
                ; args=['inoutbounds']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'inoutbounds'
            ; args=['inoutbounds']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'inoutbounds' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'inoutbounds']; alias=default


class Inoutbounds(models.Model):
    id = models.BigAutoField(primary_key=True)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'agents'
            ORDER BY kc.`ordinal_position`
        ; args=['agents']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'agents'
            ; args=['agents']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'agents' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'agents']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'agents'
                ; args=['agents']; alias=default
    agentid = models.ForeignKey(Agents, models.DO_NOTHING, db_column='agentId')  # Field name made lowercase.
    postbyid = models.BigIntegerField(db_column='postbyId')  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5)  # Field name made lowercase.
    title = models.CharField(max_length=255)
    amount = models.FloatField()
    airlinetype = models.CharField(db_column='airlineType', max_length=5)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'inoutbounds'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'jobs'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['jobs']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'jobs'
            ORDER BY kc.`ordinal_position`
        ; args=['jobs']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'jobs'
            ; args=['jobs']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'jobs' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'jobs']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'jobs'
                ; args=['jobs']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'jobs'
            ORDER BY kc.`ordinal_position`
        ; args=['jobs']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'jobs'
            ; args=['jobs']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'jobs' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'jobs']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'jobs'
                ; args=['jobs']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'jobs'
            ; args=['jobs']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'jobs' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'jobs']; alias=default


class Jobs(models.Model):
    id = models.BigAutoField(primary_key=True)
    queue = models.CharField(max_length=255)
    payload = models.TextField()
    attempts = models.PositiveIntegerField()
    reserved_at = models.PositiveIntegerField(blank=True, null=True)
    available_at = models.PositiveIntegerField()
    created_at = models.PositiveIntegerField()

    class Meta:
        managed = False
        db_table = 'jobs'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'markup_and_markdowns'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['markup_and_markdowns']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'markup_and_markdowns'
            ORDER BY kc.`ordinal_position`
        ; args=['markup_and_markdowns']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'markup_and_markdowns'
            ; args=['markup_and_markdowns']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'markup_and_markdowns' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'markup_and_markdowns']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'markup_and_markdowns'
                ; args=['markup_and_markdowns']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'markup_and_markdowns'
            ORDER BY kc.`ordinal_position`
        ; args=['markup_and_markdowns']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'markup_and_markdowns'
            ; args=['markup_and_markdowns']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'markup_and_markdowns' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'markup_and_markdowns']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'markup_and_markdowns'
                ; args=['markup_and_markdowns']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'markup_and_markdowns'
            ; args=['markup_and_markdowns']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'markup_and_markdowns' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'markup_and_markdowns']; alias=default


class MarkupAndMarkdowns(models.Model):
    id = models.BigAutoField(primary_key=True)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'agents'
            ORDER BY kc.`ordinal_position`
        ; args=['agents']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'agents'
            ; args=['agents']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'agents' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'agents']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'agents'
                ; args=['agents']; alias=default
    agentid = models.ForeignKey(Agents, models.DO_NOTHING, db_column='agentId')  # Field name made lowercase.
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

    class Meta:
        managed = False
        db_table = 'markup_and_markdowns'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'migrations'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['migrations']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'migrations'
            ORDER BY kc.`ordinal_position`
        ; args=['migrations']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'migrations'
            ; args=['migrations']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'migrations' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'migrations']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'migrations'
                ; args=['migrations']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'migrations'
            ORDER BY kc.`ordinal_position`
        ; args=['migrations']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'migrations'
            ; args=['migrations']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'migrations' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'migrations']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'migrations'
                ; args=['migrations']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'migrations'
            ; args=['migrations']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'migrations' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'migrations']; alias=default


class Migrations(models.Model):
    migration = models.CharField(max_length=255)
    batch = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'migrations'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'parent_pages'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['parent_pages']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'parent_pages'
            ORDER BY kc.`ordinal_position`
        ; args=['parent_pages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'parent_pages'
            ; args=['parent_pages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'parent_pages' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'parent_pages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'parent_pages'
                ; args=['parent_pages']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'parent_pages'
            ORDER BY kc.`ordinal_position`
        ; args=['parent_pages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'parent_pages'
            ; args=['parent_pages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'parent_pages' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'parent_pages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'parent_pages'
                ; args=['parent_pages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'parent_pages'
            ; args=['parent_pages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'parent_pages' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'parent_pages']; alias=default


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

    class Meta:
        managed = False
        db_table = 'parent_pages'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'password_resets'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['password_resets']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'password_resets'
            ORDER BY kc.`ordinal_position`
        ; args=['password_resets']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'password_resets'
            ; args=['password_resets']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'password_resets' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'password_resets']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'password_resets'
                ; args=['password_resets']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'password_resets'
            ORDER BY kc.`ordinal_position`
        ; args=['password_resets']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'password_resets'
            ; args=['password_resets']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'password_resets' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'password_resets']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'password_resets'
                ; args=['password_resets']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'password_resets'
            ; args=['password_resets']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'password_resets' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'password_resets']; alias=default


class PasswordResets(models.Model):
    email = models.CharField(max_length=255)
    token = models.CharField(max_length=255)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'password_resets'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'payments'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['payments']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'payments'
            ORDER BY kc.`ordinal_position`
        ; args=['payments']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'payments'
            ; args=['payments']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'payments' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'payments']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'payments'
                ; args=['payments']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'payments'
            ORDER BY kc.`ordinal_position`
        ; args=['payments']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'payments'
            ; args=['payments']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'payments' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'payments']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'payments'
                ; args=['payments']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'payments'
            ; args=['payments']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'payments' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'payments']; alias=default


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

    class Meta:
        managed = False
        db_table = 'payments'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'permission_assigns'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['permission_assigns']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'permission_assigns'
            ORDER BY kc.`ordinal_position`
        ; args=['permission_assigns']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_assigns'
            ; args=['permission_assigns']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'permission_assigns' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'permission_assigns']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'permission_assigns'
                ; args=['permission_assigns']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'permission_assigns'
            ORDER BY kc.`ordinal_position`
        ; args=['permission_assigns']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_assigns'
            ; args=['permission_assigns']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'permission_assigns' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'permission_assigns']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'permission_assigns'
                ; args=['permission_assigns']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_assigns'
            ; args=['permission_assigns']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'permission_assigns' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'permission_assigns']; alias=default


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

    class Meta:
        managed = False
        db_table = 'permission_assigns'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'permission_types'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['permission_types']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'permission_types'
            ORDER BY kc.`ordinal_position`
        ; args=['permission_types']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_types'
            ; args=['permission_types']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'permission_types' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'permission_types']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'permission_types'
                ; args=['permission_types']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'permission_types'
            ORDER BY kc.`ordinal_position`
        ; args=['permission_types']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_types'
            ; args=['permission_types']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'permission_types' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'permission_types']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'permission_types'
                ; args=['permission_types']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_types'
            ; args=['permission_types']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'permission_types' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'permission_types']; alias=default


class PermissionTypes(models.Model):
    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=255)
    moduletype = models.CharField(db_column='moduleType', max_length=14)  # Field name made lowercase.
    postbyid = models.BigIntegerField(db_column='postbyId')  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'permission_types'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'permissions'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['permissions']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'permissions'
            ORDER BY kc.`ordinal_position`
        ; args=['permissions']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permissions'
            ; args=['permissions']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'permissions' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'permissions']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'permissions'
                ; args=['permissions']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'permissions'
            ORDER BY kc.`ordinal_position`
        ; args=['permissions']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permissions'
            ; args=['permissions']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'permissions' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'permissions']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'permissions'
                ; args=['permissions']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permissions'
            ; args=['permissions']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'permissions' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'permissions']; alias=default


class Permissions(models.Model):
    title = models.CharField(max_length=255)
    moduletype = models.CharField(db_column='moduleType', max_length=255)  # Field name made lowercase.
    agentid = models.IntegerField(db_column='agentId')  # Field name made lowercase.
    parentid = models.IntegerField(db_column='parentId')  # Field name made lowercase.
    userid = models.IntegerField(db_column='userId')  # Field name made lowercase.
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'permission_types'
            ORDER BY kc.`ordinal_position`
        ; args=['permission_types']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_types'
            ; args=['permission_types']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'permission_types' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'permission_types']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'permission_types'
                ; args=['permission_types']; alias=default
    permissiontypeid = models.ForeignKey(PermissionTypes, models.DO_NOTHING, db_column='permissionTypeId')  # Field name made lowercase.
    assigntype = models.CharField(db_column='assignType', max_length=5)  # Field name made lowercase.
    postbyid = models.IntegerField(db_column='postbyId')  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'permissions'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'personal_access_tokens'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['personal_access_tokens']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'personal_access_tokens'
            ORDER BY kc.`ordinal_position`
        ; args=['personal_access_tokens']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'personal_access_tokens'
            ; args=['personal_access_tokens']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'personal_access_tokens' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'personal_access_tokens']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'personal_access_tokens'
                ; args=['personal_access_tokens']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'personal_access_tokens'
            ORDER BY kc.`ordinal_position`
        ; args=['personal_access_tokens']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'personal_access_tokens'
            ; args=['personal_access_tokens']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'personal_access_tokens' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'personal_access_tokens']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'personal_access_tokens'
                ; args=['personal_access_tokens']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'personal_access_tokens'
            ; args=['personal_access_tokens']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'personal_access_tokens' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'personal_access_tokens']; alias=default


class PersonalAccessTokens(models.Model):
    id = models.BigAutoField(primary_key=True)
    tokenable_type = models.CharField(max_length=255)
    tokenable_id = models.PositiveBigIntegerField()
    name = models.CharField(max_length=255)
    token = models.CharField(unique=True, max_length=64)
    abilities = models.TextField(blank=True, null=True)
    last_used_at = models.DateTimeField(blank=True, null=True)
    expires_at = models.DateTimeField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'personal_access_tokens'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'premium_airlines'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['premium_airlines']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'premium_airlines'
            ORDER BY kc.`ordinal_position`
        ; args=['premium_airlines']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'premium_airlines'
            ; args=['premium_airlines']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'premium_airlines' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'premium_airlines']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'premium_airlines'
                ; args=['premium_airlines']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'premium_airlines'
            ORDER BY kc.`ordinal_position`
        ; args=['premium_airlines']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'premium_airlines'
            ; args=['premium_airlines']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'premium_airlines' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'premium_airlines']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'premium_airlines'
                ; args=['premium_airlines']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'premium_airlines'
            ; args=['premium_airlines']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'premium_airlines' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'premium_airlines']; alias=default


class PremiumAirlines(models.Model):
    id = models.BigAutoField(primary_key=True)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'agents'
            ORDER BY kc.`ordinal_position`
        ; args=['agents']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'agents'
            ; args=['agents']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'agents' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'agents']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'agents'
                ; args=['agents']; alias=default
    agentid = models.ForeignKey(Agents, models.DO_NOTHING, db_column='agentId')  # Field name made lowercase.
    postbyid = models.BigIntegerField(db_column='postbyId')  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5)  # Field name made lowercase.
    title = models.CharField(max_length=255)
    amount = models.FloatField()
    airlinetype = models.CharField(db_column='airlineType', max_length=10)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'premium_airlines'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'rest_api_credentials'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['rest_api_credentials']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'rest_api_credentials'
            ORDER BY kc.`ordinal_position`
        ; args=['rest_api_credentials']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'rest_api_credentials'
            ; args=['rest_api_credentials']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'rest_api_credentials' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'rest_api_credentials']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'rest_api_credentials'
                ; args=['rest_api_credentials']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'rest_api_credentials'
            ORDER BY kc.`ordinal_position`
        ; args=['rest_api_credentials']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'rest_api_credentials'
            ; args=['rest_api_credentials']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'rest_api_credentials' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'rest_api_credentials']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'rest_api_credentials'
                ; args=['rest_api_credentials']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'rest_api_credentials'
            ; args=['rest_api_credentials']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'rest_api_credentials' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'rest_api_credentials']; alias=default


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

    class Meta:
        managed = False
        db_table = 'rest_api_credentials'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'sectors'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['sectors']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'sectors'
            ORDER BY kc.`ordinal_position`
        ; args=['sectors']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'sectors'
            ; args=['sectors']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'sectors' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'sectors']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'sectors'
                ; args=['sectors']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'sectors'
            ORDER BY kc.`ordinal_position`
        ; args=['sectors']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'sectors'
            ; args=['sectors']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'sectors' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'sectors']; alias=default


class Sectors(models.Model):
    id = models.BigAutoField(primary_key=True)
    code = models.CharField(max_length=3)
    city = models.CharField(max_length=45)
    country = models.CharField(max_length=45)
    sectortype = models.CharField(db_column='sectorType', max_length=3)  # Field name made lowercase.
    allowtype = models.CharField(db_column='allowType', max_length=255)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'sectors'
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'sectors'
                ; args=['sectors']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'sectors'
            ; args=['sectors']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'sectors' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'sectors']; alias=default
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'tour_images'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['tour_images']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'tour_images'
            ORDER BY kc.`ordinal_position`
        ; args=['tour_images']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_images'
            ; args=['tour_images']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'tour_images' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'tour_images']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'tour_images'
                ; args=['tour_images']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'tour_images'
            ORDER BY kc.`ordinal_position`
        ; args=['tour_images']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_images'
            ; args=['tour_images']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'tour_images' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'tour_images']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'tour_images'
                ; args=['tour_images']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_images'
            ; args=['tour_images']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'tour_images' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'tour_images']; alias=default


class TourImages(models.Model):
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'tour_packages'
            ORDER BY kc.`ordinal_position`
        ; args=['tour_packages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_packages'
            ; args=['tour_packages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'tour_packages' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'tour_packages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'tour_packages'
                ; args=['tour_packages']; alias=default
    tour_package = models.ForeignKey('TourPackages', models.DO_NOTHING)
    images = models.CharField(max_length=255, blank=True, null=True)
    banner_image = models.CharField(max_length=255, blank=True, null=True)
    created_by = models.BigIntegerField()
    created_at = models.DateTimeField()
    updated_by = models.BigIntegerField()
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'tour_images'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'tour_packages'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['tour_packages']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'tour_packages'
            ORDER BY kc.`ordinal_position`
        ; args=['tour_packages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_packages'
            ; args=['tour_packages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'tour_packages' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'tour_packages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'tour_packages'
                ; args=['tour_packages']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'tour_packages'
            ORDER BY kc.`ordinal_position`
        ; args=['tour_packages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_packages'
            ; args=['tour_packages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'tour_packages' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'tour_packages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'tour_packages'
                ; args=['tour_packages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_packages'
            ; args=['tour_packages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'tour_packages' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'tour_packages']; alias=default


class TourPackages(models.Model):
    id = models.BigAutoField(primary_key=True)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'content_pages'
            ORDER BY kc.`ordinal_position`
        ; args=['content_pages']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'content_pages'
            ; args=['content_pages']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'content_pages' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'content_pages']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'content_pages'
                ; args=['content_pages']; alias=default
    cms_cp = models.ForeignKey(ContentPages, models.DO_NOTHING)
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

    class Meta:
        managed = False
        db_table = 'tour_packages'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_booking_customers'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_booking_customers']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_booking_customers'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_booking_customers']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_customers'
            ; args=['umrah_booking_customers']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_booking_customers' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'umrah_booking_customers']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_booking_customers'
                ; args=['umrah_booking_customers']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_booking_customers'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_booking_customers']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_customers'
            ; args=['umrah_booking_customers']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_booking_customers' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'umrah_booking_customers']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_booking_customers'
                ; args=['umrah_booking_customers']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_customers'
            ; args=['umrah_booking_customers']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_booking_customers' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'umrah_booking_customers']; alias=default


class UmrahBookingCustomers(models.Model):
    id = models.BigAutoField(primary_key=True)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'customers'
            ORDER BY kc.`ordinal_position`
        ; args=['customers']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'customers'
            ; args=['customers']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'customers' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'customers']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'customers'
                ; args=['customers']; alias=default
    customerid = models.ForeignKey(Customers, models.DO_NOTHING, db_column='customerId')  # Field name made lowercase.
    umrahvisaprice = models.FloatField(db_column='umrahVisaPrice')  # Field name made lowercase.
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_transport_sectors'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_transport_sectors']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_transport_sectors'
            ; args=['umrah_transport_sectors']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_transport_sectors' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_transport_sectors']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_transport_sectors'
                ; args=['umrah_transport_sectors']; alias=default
    umrahsectorid = models.ForeignKey('UmrahTransportSectors', models.DO_NOTHING, db_column='umrahSectorId')  # Field name made lowercase.
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_vehicles'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_vehicles']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicles'
            ; args=['umrah_vehicles']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_vehicles' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_vehicles']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_vehicles'
                ; args=['umrah_vehicles']; alias=default
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

    class Meta:
        managed = False
        db_table = 'umrah_booking_customers'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_booking_hotel_room'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_booking_hotel_room']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_booking_hotel_room'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_booking_hotel_room']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_hotel_room'
            ; args=['umrah_booking_hotel_room']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_booking_hotel_room' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'umrah_booking_hotel_room']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_booking_hotel_room'
                ; args=['umrah_booking_hotel_room']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_booking_hotel_room'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_booking_hotel_room']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_hotel_room'
            ; args=['umrah_booking_hotel_room']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_booking_hotel_room' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'umrah_booking_hotel_room']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_booking_hotel_room'
                ; args=['umrah_booking_hotel_room']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_hotel_room'
            ; args=['umrah_booking_hotel_room']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_booking_hotel_room' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'umrah_booking_hotel_room']; alias=default


class UmrahBookingHotelRoom(models.Model):
    id = models.BigAutoField(primary_key=True)
    umrahbookingid = models.BigIntegerField(db_column='umrahBookingId')  # Field name made lowercase.
    hotelroompriceid = models.BigIntegerField(db_column='hotelRoomPriceId')  # Field name made lowercase.
    totalhotelperroom = models.IntegerField(db_column='totalhotelPerRoom')  # Field name made lowercase.
    hotelperroomtype = models.CharField(db_column='hotelPerRoomType', max_length=6)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'umrah_booking_hotel_room'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_bookings'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_bookings']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_bookings'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_bookings']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_bookings'
            ; args=['umrah_bookings']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_bookings' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'umrah_bookings']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_bookings'
                ; args=['umrah_bookings']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_bookings'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_bookings']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_bookings'
            ; args=['umrah_bookings']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_bookings' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'umrah_bookings']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_bookings'
                ; args=['umrah_bookings']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_bookings'
            ; args=['umrah_bookings']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_bookings' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'umrah_bookings']; alias=default


class UmrahBookings(models.Model):
    id = models.BigAutoField(primary_key=True)
    location = models.CharField(max_length=20)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_booking_customers'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_booking_customers']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_customers'
            ; args=['umrah_booking_customers']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'latin1_swedish_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_booking_customers' AND table_schema = DATABASE()
            ; args=['latin1_swedish_ci', 'umrah_booking_customers']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_booking_customers'
                ; args=['umrah_booking_customers']; alias=default
    bookingcustomerid = models.ForeignKey(UmrahBookingCustomers, models.DO_NOTHING, db_column='bookingCustomerId')  # Field name made lowercase.
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

    class Meta:
        managed = False
        db_table = 'umrah_bookings'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_hotel_images'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_hotel_images']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_hotel_images'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_hotel_images']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_images'
            ; args=['umrah_hotel_images']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotel_images' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotel_images']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_hotel_images'
                ; args=['umrah_hotel_images']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_hotel_images'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_hotel_images']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_images'
            ; args=['umrah_hotel_images']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotel_images' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotel_images']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_hotel_images'
                ; args=['umrah_hotel_images']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_images'
            ; args=['umrah_hotel_images']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotel_images' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotel_images']; alias=default


class UmrahHotelImages(models.Model):
    id = models.BigAutoField(primary_key=True)
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_hotels'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_hotels']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotels'
            ; args=['umrah_hotels']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotels' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotels']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_hotels'
                ; args=['umrah_hotels']; alias=default
    hotelid = models.ForeignKey('UmrahHotels', models.DO_NOTHING, db_column='hotelId')  # Field name made lowercase.
    hotelimage = models.CharField(db_column='hotelImage', max_length=255, blank=True, null=True)  # Field name made lowercase.
    hotelroomtype = models.CharField(db_column='hotelRoomType', max_length=6)  # Field name made lowercase.
    hotelroomimagestatus = models.CharField(db_column='hotelRoomImageStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'umrah_hotel_images'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_hotel_room_periods'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_hotel_room_periods']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_hotel_room_periods'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_hotel_room_periods']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_room_periods'
            ; args=['umrah_hotel_room_periods']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotel_room_periods' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotel_room_periods']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_hotel_room_periods'
                ; args=['umrah_hotel_room_periods']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_hotel_room_periods'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_hotel_room_periods']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_room_periods'
            ; args=['umrah_hotel_room_periods']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotel_room_periods' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotel_room_periods']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_hotel_room_periods'
                ; args=['umrah_hotel_room_periods']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_room_periods'
            ; args=['umrah_hotel_room_periods']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotel_room_periods' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotel_room_periods']; alias=default


class UmrahHotelRoomPeriods(models.Model):
    id = models.BigAutoField(primary_key=True)
    hotelid = models.PositiveBigIntegerField(db_column='hotelId')  # Field name made lowercase.
    periodfrom = models.DateField(db_column='periodFrom')  # Field name made lowercase.
    periodto = models.DateField(db_column='periodTo')  # Field name made lowercase.
    ashratype = models.CharField(db_column='ashraType', max_length=1)  # Field name made lowercase.
    periodstatus = models.CharField(db_column='periodStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'umrah_hotel_room_periods'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_hotel_room_prices'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_hotel_room_prices']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_hotel_room_prices'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_hotel_room_prices']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_room_prices'
            ; args=['umrah_hotel_room_prices']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotel_room_prices' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotel_room_prices']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_hotel_room_prices'
                ; args=['umrah_hotel_room_prices']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_hotel_room_prices'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_hotel_room_prices']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_room_prices'
            ; args=['umrah_hotel_room_prices']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotel_room_prices' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotel_room_prices']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_hotel_room_prices'
                ; args=['umrah_hotel_room_prices']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_room_prices'
            ; args=['umrah_hotel_room_prices']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotel_room_prices' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotel_room_prices']; alias=default


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

    class Meta:
        managed = False
        db_table = 'umrah_hotel_room_prices'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_hotels'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_hotels']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_hotels'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_hotels']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotels'
            ; args=['umrah_hotels']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotels' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotels']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_hotels'
                ; args=['umrah_hotels']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_hotels'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_hotels']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotels'
            ; args=['umrah_hotels']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotels' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotels']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_hotels'
                ; args=['umrah_hotels']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotels'
            ; args=['umrah_hotels']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_hotels' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_hotels']; alias=default


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

    class Meta:
        managed = False
        db_table = 'umrah_hotels'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_transport_sectors'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_transport_sectors']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_transport_sectors'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_transport_sectors']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_transport_sectors'
            ; args=['umrah_transport_sectors']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_transport_sectors' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_transport_sectors']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_transport_sectors'
                ; args=['umrah_transport_sectors']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_transport_sectors'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_transport_sectors']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_transport_sectors'
            ; args=['umrah_transport_sectors']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_transport_sectors' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_transport_sectors']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_transport_sectors'
                ; args=['umrah_transport_sectors']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_transport_sectors'
            ; args=['umrah_transport_sectors']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_transport_sectors' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_transport_sectors']; alias=default


class UmrahTransportSectors(models.Model):
    id = models.BigAutoField(primary_key=True)
    sectorname = models.CharField(db_column='sectorName', max_length=255)  # Field name made lowercase.
    sectormarkup = models.CharField(db_column='sectorMarkup', max_length=255)  # Field name made lowercase.
    sectorstatus = models.CharField(db_column='sectorStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'umrah_transport_sectors'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_vehicle_prices'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_vehicle_prices']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_vehicle_prices'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_vehicle_prices']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicle_prices'
            ; args=['umrah_vehicle_prices']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_vehicle_prices' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_vehicle_prices']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_vehicle_prices'
                ; args=['umrah_vehicle_prices']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_vehicle_prices'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_vehicle_prices']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicle_prices'
            ; args=['umrah_vehicle_prices']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_vehicle_prices' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_vehicle_prices']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_vehicle_prices'
                ; args=['umrah_vehicle_prices']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicle_prices'
            ; args=['umrah_vehicle_prices']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_vehicle_prices' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_vehicle_prices']; alias=default


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

    class Meta:
        managed = False
        db_table = 'umrah_vehicle_prices'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_vehicles'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_vehicles']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_vehicles'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_vehicles']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicles'
            ; args=['umrah_vehicles']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_vehicles' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_vehicles']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_vehicles'
                ; args=['umrah_vehicles']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_vehicles'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_vehicles']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicles'
            ; args=['umrah_vehicles']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_vehicles' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_vehicles']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_vehicles'
                ; args=['umrah_vehicles']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicles'
            ; args=['umrah_vehicles']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_vehicles' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_vehicles']; alias=default


class UmrahVehicles(models.Model):
    id = models.BigAutoField(primary_key=True)
    vehiclename = models.CharField(db_column='vehicleName', max_length=255)  # Field name made lowercase.
    vehiclemarkup = models.CharField(db_column='vehicleMarkup', max_length=255)  # Field name made lowercase.
    vehiclestatus = models.CharField(db_column='vehicleStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'umrah_vehicles'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_visas'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_visas']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_visas'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_visas']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_visas'
            ; args=['umrah_visas']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_visas' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_visas']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_visas'
                ; args=['umrah_visas']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'umrah_visas'
            ORDER BY kc.`ordinal_position`
        ; args=['umrah_visas']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_visas'
            ; args=['umrah_visas']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_visas' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_visas']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'umrah_visas'
                ; args=['umrah_visas']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_visas'
            ; args=['umrah_visas']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_unicode_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'umrah_visas' AND table_schema = DATABASE()
            ; args=['utf8mb4_unicode_ci', 'umrah_visas']; alias=default


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

    class Meta:
        managed = False
        db_table = 'umrah_visas'
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'users'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['users']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'users'
            ORDER BY kc.`ordinal_position`
        ; args=['users']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'users'
            ; args=['users']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'users' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'users']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'users'
                ; args=['users']; alias=default
            SELECT kc.`constraint_name`, kc.`column_name`,
                kc.`referenced_table_name`, kc.`referenced_column_name`,
                c.`constraint_type`
            FROM
                information_schema.key_column_usage AS kc,
                information_schema.table_constraints AS c
            WHERE
                kc.table_schema = DATABASE() AND
                c.table_schema = kc.table_schema AND
                c.constraint_name = kc.constraint_name AND
                c.constraint_type != 'CHECK' AND
                kc.table_name = 'users'
            ORDER BY kc.`ordinal_position`
        ; args=['users']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'users'
            ; args=['users']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'users' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'users']; alias=default
                    SELECT cc.constraint_name, cc.check_clause
                    FROM
                        information_schema.check_constraints AS cc,
                        information_schema.table_constraints AS tc
                    WHERE
                        cc.constraint_schema = DATABASE() AND
                        tc.table_schema = cc.constraint_schema AND
                        cc.constraint_name = tc.constraint_name AND
                        tc.constraint_type = 'CHECK' AND
                        tc.table_name = 'users'
                ; args=['users']; alias=default
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'users'
            ; args=['users']; alias=default
            SELECT
                column_name, data_type, character_maximum_length,
                numeric_precision, numeric_scale, extra, column_default,
                CASE
                    WHEN collation_name = 'utf8mb4_0900_ai_ci' THEN NULL
                    ELSE collation_name
                END AS collation_name,
                CASE
                    WHEN column_type LIKE '% unsigned' THEN 1
                    ELSE 0
                END AS is_unsigned,
                column_comment
            FROM information_schema.columns
            WHERE table_name = 'users' AND table_schema = DATABASE()
            ; args=['utf8mb4_0900_ai_ci', 'users']; alias=default


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

    class Meta:
        managed = False
        db_table = 'users'
