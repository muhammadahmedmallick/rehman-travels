time="2026-01-24T22:45:40+05:00" level=warning msg="/Users/muhammadahmed/Desktop/personal/rehman-travels/backen-alrehman/docker-compose.yml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion"
DEBUG 2026-01-24 22:45:41,960 utils (0.002) 
                SELECT VERSION(),
                       @@sql_mode,
                       @@default_storage_engine,
                       @@sql_auto_is_null,
                       @@lower_case_table_names,
                       CONVERT_TZ('2001-01-01 01:00:00', 'UTC', 'UTC') IS NOT NULL
            ; args=None; alias=default
DEBUG 2026-01-24 22:45:41,962 utils (0.001) SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; args=None; alias=default
# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
DEBUG 2026-01-24 22:45:41,969 utils (0.007) 
            SELECT
                table_name,
                table_type,
                table_comment
            FROM information_schema.tables
            WHERE table_schema = DATABASE()
            ; args=None; alias=default
DEBUG 2026-01-24 22:45:41,978 utils (0.008) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'administrative_settings'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['administrative_settings']; alias=default
DEBUG 2026-01-24 22:45:41,984 utils (0.005) 
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
DEBUG 2026-01-24 22:45:41,985 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'administrative_settings'
            ; args=['administrative_settings']; alias=default
DEBUG 2026-01-24 22:45:41,990 utils (0.005) 
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
DEBUG 2026-01-24 22:45:41,991 utils (0.001) SELECT * FROM `administrative_settings` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:41,993 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,007 utils (0.014) SHOW INDEX FROM `administrative_settings`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,013 utils (0.005) 
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
DEBUG 2026-01-24 22:45:42,015 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'administrative_settings'
            ; args=['administrative_settings']; alias=default
DEBUG 2026-01-24 22:45:42,016 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,017 utils (0.000) SELECT * FROM `administrative_settings` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,018 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,019 utils (0.001) SHOW INDEX FROM `administrative_settings`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,020 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'administrative_settings'
            ; args=['administrative_settings']; alias=default
DEBUG 2026-01-24 22:45:42,021 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,021 utils (0.000) SELECT * FROM `administrative_settings` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,022 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'agents'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['agents']; alias=default
DEBUG 2026-01-24 22:45:42,026 utils (0.004) 
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
DEBUG 2026-01-24 22:45:42,028 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'agents'
            ; args=['agents']; alias=default
DEBUG 2026-01-24 22:45:42,034 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,035 utils (0.001) SELECT * FROM `agents` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,036 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,039 utils (0.003) SHOW INDEX FROM `agents`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,042 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,043 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'agents'
            ; args=['agents']; alias=default
DEBUG 2026-01-24 22:45:42,044 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,044 utils (0.000) SELECT * FROM `agents` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,045 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,046 utils (0.001) SHOW INDEX FROM `agents`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,047 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'agents'
            ; args=['agents']; alias=default
DEBUG 2026-01-24 22:45:42,049 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,050 utils (0.000) SELECT * FROM `agents` LIMIT 1; args=None; alias=default
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
DEBUG 2026-01-24 22:45:42,052 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'airline_name_codes'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['airline_name_codes']; alias=default
DEBUG 2026-01-24 22:45:42,053 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,054 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'airline_name_codes'
            ; args=['airline_name_codes']; alias=default
DEBUG 2026-01-24 22:45:42,055 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,056 utils (0.001) SELECT * FROM `airline_name_codes` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,057 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,060 utils (0.003) SHOW INDEX FROM `airline_name_codes`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,062 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,062 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'airline_name_codes'
            ; args=['airline_name_codes']; alias=default
DEBUG 2026-01-24 22:45:42,063 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,064 utils (0.000) SELECT * FROM `airline_name_codes` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,064 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,065 utils (0.001) SHOW INDEX FROM `airline_name_codes`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,066 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'airline_name_codes'
            ; args=['airline_name_codes']; alias=default
DEBUG 2026-01-24 22:45:42,066 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,067 utils (0.000) SELECT * FROM `airline_name_codes` LIMIT 1; args=None; alias=default


class AirlineNameCodes(models.Model):
    id = models.BigAutoField(primary_key=True)
    airlinename = models.CharField(db_column='airlineName', max_length=100)  # Field name made lowercase.
    countryname = models.CharField(db_column='countryName', max_length=100)  # Field name made lowercase.
    carriercode = models.CharField(db_column='carrierCode', max_length=10)  # Field name made lowercase.
    iatacode = models.CharField(db_column='iataCode', max_length=10)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'airline_name_codes'
DEBUG 2026-01-24 22:45:42,068 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'assign_call_recording_followups'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['assign_call_recording_followups']; alias=default
DEBUG 2026-01-24 22:45:42,069 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,070 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'assign_call_recording_followups'
            ; args=['assign_call_recording_followups']; alias=default
DEBUG 2026-01-24 22:45:42,071 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,071 utils (0.000) SELECT * FROM `assign_call_recording_followups` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,072 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,074 utils (0.002) SHOW INDEX FROM `assign_call_recording_followups`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,076 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,076 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'assign_call_recording_followups'
            ; args=['assign_call_recording_followups']; alias=default
DEBUG 2026-01-24 22:45:42,077 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,077 utils (0.000) SELECT * FROM `assign_call_recording_followups` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,078 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,079 utils (0.001) SHOW INDEX FROM `assign_call_recording_followups`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,080 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'assign_call_recording_followups'
            ; args=['assign_call_recording_followups']; alias=default
DEBUG 2026-01-24 22:45:42,081 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,081 utils (0.000) SELECT * FROM `assign_call_recording_followups` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,082 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'auth_group'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['auth_group']; alias=default
DEBUG 2026-01-24 22:45:42,083 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,084 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group'
            ; args=['auth_group']; alias=default
DEBUG 2026-01-24 22:45:42,085 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,085 utils (0.001) SELECT * FROM `auth_group` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,086 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,090 utils (0.004) SHOW INDEX FROM `auth_group`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,092 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,093 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group'
            ; args=['auth_group']; alias=default
DEBUG 2026-01-24 22:45:42,094 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,094 utils (0.000) SELECT * FROM `auth_group` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,094 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,095 utils (0.001) SHOW INDEX FROM `auth_group`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,096 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group'
            ; args=['auth_group']; alias=default
DEBUG 2026-01-24 22:45:42,096 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,097 utils (0.000) SELECT * FROM `auth_group` LIMIT 1; args=None; alias=default


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'
DEBUG 2026-01-24 22:45:42,098 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'auth_group_permissions'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['auth_group_permissions']; alias=default
DEBUG 2026-01-24 22:45:42,101 utils (0.003) 
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
DEBUG 2026-01-24 22:45:42,101 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group_permissions'
            ; args=['auth_group_permissions']; alias=default
DEBUG 2026-01-24 22:45:42,102 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,104 utils (0.002) SELECT * FROM `auth_group_permissions` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,105 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,115 utils (0.010) SHOW INDEX FROM `auth_group_permissions`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,118 utils (0.003) 
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
DEBUG 2026-01-24 22:45:42,119 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group_permissions'
            ; args=['auth_group_permissions']; alias=default
DEBUG 2026-01-24 22:45:42,119 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,119 utils (0.000) SELECT * FROM `auth_group_permissions` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,120 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,121 utils (0.001) SHOW INDEX FROM `auth_group_permissions`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,121 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group_permissions'
            ; args=['auth_group_permissions']; alias=default
DEBUG 2026-01-24 22:45:42,122 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,122 utils (0.000) SELECT * FROM `auth_group_permissions` LIMIT 1; args=None; alias=default


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
DEBUG 2026-01-24 22:45:42,124 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,125 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group'
            ; args=['auth_group']; alias=default
DEBUG 2026-01-24 22:45:42,125 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,125 utils (0.000) SELECT * FROM `auth_group` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,126 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,126 utils (0.001) SHOW INDEX FROM `auth_group`; args=None; alias=default
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
DEBUG 2026-01-24 22:45:42,129 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,129 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_permission'
            ; args=['auth_permission']; alias=default
DEBUG 2026-01-24 22:45:42,130 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,131 utils (0.001) SELECT * FROM `auth_permission` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,132 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,138 utils (0.006) SHOW INDEX FROM `auth_permission`; args=None; alias=default
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)
DEBUG 2026-01-24 22:45:42,139 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'auth_permission'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['auth_permission']; alias=default
DEBUG 2026-01-24 22:45:42,142 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,142 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_permission'
            ; args=['auth_permission']; alias=default
DEBUG 2026-01-24 22:45:42,144 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,144 utils (0.000) SELECT * FROM `auth_permission` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,145 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,146 utils (0.001) SHOW INDEX FROM `auth_permission`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,149 utils (0.003) 
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
DEBUG 2026-01-24 22:45:42,151 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_permission'
            ; args=['auth_permission']; alias=default
DEBUG 2026-01-24 22:45:42,152 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,152 utils (0.000) SELECT * FROM `auth_permission` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,153 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,153 utils (0.001) SHOW INDEX FROM `auth_permission`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,154 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_permission'
            ; args=['auth_permission']; alias=default
DEBUG 2026-01-24 22:45:42,155 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,155 utils (0.000) SELECT * FROM `auth_permission` LIMIT 1; args=None; alias=default


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
DEBUG 2026-01-24 22:45:42,157 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,158 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_content_type'
            ; args=['django_content_type']; alias=default
DEBUG 2026-01-24 22:45:42,158 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,159 utils (0.000) SELECT * FROM `django_content_type` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,159 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,165 utils (0.005) SHOW INDEX FROM `django_content_type`; args=None; alias=default
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)
DEBUG 2026-01-24 22:45:42,166 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'auth_user'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['auth_user']; alias=default
DEBUG 2026-01-24 22:45:42,168 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,168 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user'
            ; args=['auth_user']; alias=default
DEBUG 2026-01-24 22:45:42,169 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,170 utils (0.001) SELECT * FROM `auth_user` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,172 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,176 utils (0.004) SHOW INDEX FROM `auth_user`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,178 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,178 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user'
            ; args=['auth_user']; alias=default
DEBUG 2026-01-24 22:45:42,179 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,179 utils (0.000) SELECT * FROM `auth_user` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,180 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,181 utils (0.001) SHOW INDEX FROM `auth_user`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,181 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user'
            ; args=['auth_user']; alias=default
DEBUG 2026-01-24 22:45:42,182 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,182 utils (0.000) SELECT * FROM `auth_user` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,183 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'auth_user_groups'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['auth_user_groups']; alias=default
DEBUG 2026-01-24 22:45:42,186 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,186 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user_groups'
            ; args=['auth_user_groups']; alias=default
DEBUG 2026-01-24 22:45:42,187 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,188 utils (0.001) SELECT * FROM `auth_user_groups` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,188 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,195 utils (0.007) SHOW INDEX FROM `auth_user_groups`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,200 utils (0.005) 
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
DEBUG 2026-01-24 22:45:42,201 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user_groups'
            ; args=['auth_user_groups']; alias=default
DEBUG 2026-01-24 22:45:42,201 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,202 utils (0.000) SELECT * FROM `auth_user_groups` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,202 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,203 utils (0.001) SHOW INDEX FROM `auth_user_groups`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,203 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user_groups'
            ; args=['auth_user_groups']; alias=default
DEBUG 2026-01-24 22:45:42,204 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,204 utils (0.000) SELECT * FROM `auth_user_groups` LIMIT 1; args=None; alias=default


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
DEBUG 2026-01-24 22:45:42,206 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,206 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user'
            ; args=['auth_user']; alias=default
DEBUG 2026-01-24 22:45:42,207 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,207 utils (0.000) SELECT * FROM `auth_user` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,208 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,208 utils (0.001) SHOW INDEX FROM `auth_user`; args=None; alias=default
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
DEBUG 2026-01-24 22:45:42,212 utils (0.004) 
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
DEBUG 2026-01-24 22:45:42,214 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_group'
            ; args=['auth_group']; alias=default
DEBUG 2026-01-24 22:45:42,215 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,216 utils (0.000) SELECT * FROM `auth_group` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,217 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,219 utils (0.002) SHOW INDEX FROM `auth_group`; args=None; alias=default
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)
DEBUG 2026-01-24 22:45:42,220 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'auth_user_user_permissions'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['auth_user_user_permissions']; alias=default
DEBUG 2026-01-24 22:45:42,226 utils (0.005) 
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
DEBUG 2026-01-24 22:45:42,227 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user_user_permissions'
            ; args=['auth_user_user_permissions']; alias=default
DEBUG 2026-01-24 22:45:42,229 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,231 utils (0.002) SELECT * FROM `auth_user_user_permissions` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,232 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,248 utils (0.015) SHOW INDEX FROM `auth_user_user_permissions`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,251 utils (0.003) 
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
DEBUG 2026-01-24 22:45:42,251 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user_user_permissions'
            ; args=['auth_user_user_permissions']; alias=default
DEBUG 2026-01-24 22:45:42,252 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,252 utils (0.000) SELECT * FROM `auth_user_user_permissions` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,253 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,253 utils (0.001) SHOW INDEX FROM `auth_user_user_permissions`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,254 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user_user_permissions'
            ; args=['auth_user_user_permissions']; alias=default
DEBUG 2026-01-24 22:45:42,254 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,255 utils (0.000) SELECT * FROM `auth_user_user_permissions` LIMIT 1; args=None; alias=default


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
DEBUG 2026-01-24 22:45:42,256 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,257 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user'
            ; args=['auth_user']; alias=default
DEBUG 2026-01-24 22:45:42,257 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,257 utils (0.000) SELECT * FROM `auth_user` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,258 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,259 utils (0.001) SHOW INDEX FROM `auth_user`; args=None; alias=default
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
DEBUG 2026-01-24 22:45:42,261 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,261 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_permission'
            ; args=['auth_permission']; alias=default
DEBUG 2026-01-24 22:45:42,262 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,262 utils (0.000) SELECT * FROM `auth_permission` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,262 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,263 utils (0.001) SHOW INDEX FROM `auth_permission`; args=None; alias=default
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)
DEBUG 2026-01-24 22:45:42,264 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'bank_details'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['bank_details']; alias=default
DEBUG 2026-01-24 22:45:42,266 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,266 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'bank_details'
            ; args=['bank_details']; alias=default
DEBUG 2026-01-24 22:45:42,267 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,267 utils (0.000) SELECT * FROM `bank_details` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,268 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,270 utils (0.002) SHOW INDEX FROM `bank_details`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,272 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,272 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'bank_details'
            ; args=['bank_details']; alias=default
DEBUG 2026-01-24 22:45:42,273 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,273 utils (0.000) SELECT * FROM `bank_details` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,273 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,274 utils (0.000) SHOW INDEX FROM `bank_details`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,274 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'bank_details'
            ; args=['bank_details']; alias=default
DEBUG 2026-01-24 22:45:42,275 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,275 utils (0.000) SELECT * FROM `bank_details` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,276 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'branches'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['branches']; alias=default
DEBUG 2026-01-24 22:45:42,277 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,278 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'branches'
            ; args=['branches']; alias=default
DEBUG 2026-01-24 22:45:42,278 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,278 utils (0.000) SELECT * FROM `branches` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,279 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,284 utils (0.004) SHOW INDEX FROM `branches`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,286 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,286 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'branches'
            ; args=['branches']; alias=default
DEBUG 2026-01-24 22:45:42,287 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,287 utils (0.000) SELECT * FROM `branches` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,288 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,289 utils (0.001) SHOW INDEX FROM `branches`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,289 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'branches'
            ; args=['branches']; alias=default
DEBUG 2026-01-24 22:45:42,290 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,290 utils (0.000) SELECT * FROM `branches` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,291 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'call_recordings'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['call_recordings']; alias=default
DEBUG 2026-01-24 22:45:42,292 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,293 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'call_recordings'
            ; args=['call_recordings']; alias=default
DEBUG 2026-01-24 22:45:42,293 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,294 utils (0.000) SELECT * FROM `call_recordings` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,294 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,322 utils (0.028) SHOW INDEX FROM `call_recordings`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,324 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,325 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'call_recordings'
            ; args=['call_recordings']; alias=default
DEBUG 2026-01-24 22:45:42,325 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,326 utils (0.000) SELECT * FROM `call_recordings` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,326 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,327 utils (0.001) SHOW INDEX FROM `call_recordings`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,327 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'call_recordings'
            ; args=['call_recordings']; alias=default
DEBUG 2026-01-24 22:45:42,328 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,328 utils (0.000) SELECT * FROM `call_recordings` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,329 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'cms_callback_queries'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['cms_callback_queries']; alias=default
DEBUG 2026-01-24 22:45:42,330 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,331 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_callback_queries'
            ; args=['cms_callback_queries']; alias=default
DEBUG 2026-01-24 22:45:42,332 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,332 utils (0.000) SELECT * FROM `cms_callback_queries` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,333 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,337 utils (0.004) SHOW INDEX FROM `cms_callback_queries`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,339 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,339 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_callback_queries'
            ; args=['cms_callback_queries']; alias=default
DEBUG 2026-01-24 22:45:42,340 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,340 utils (0.000) SELECT * FROM `cms_callback_queries` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,340 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,341 utils (0.000) SHOW INDEX FROM `cms_callback_queries`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,341 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_callback_queries'
            ; args=['cms_callback_queries']; alias=default
DEBUG 2026-01-24 22:45:42,342 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,342 utils (0.000) SELECT * FROM `cms_callback_queries` LIMIT 1; args=None; alias=default


class CmsCallbackQueries(models.Model):
    id = models.BigAutoField(primary_key=True)
DEBUG 2026-01-24 22:45:42,343 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,344 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'customers'
            ; args=['customers']; alias=default
DEBUG 2026-01-24 22:45:42,344 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,345 utils (0.000) SELECT * FROM `customers` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,345 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,348 utils (0.002) SHOW INDEX FROM `customers`; args=None; alias=default
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
DEBUG 2026-01-24 22:45:42,348 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'cms_faqs'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['cms_faqs']; alias=default
DEBUG 2026-01-24 22:45:42,350 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,350 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_faqs'
            ; args=['cms_faqs']; alias=default
DEBUG 2026-01-24 22:45:42,351 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,351 utils (0.000) SELECT * FROM `cms_faqs` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,351 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,354 utils (0.003) SHOW INDEX FROM `cms_faqs`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,356 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,356 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_faqs'
            ; args=['cms_faqs']; alias=default
DEBUG 2026-01-24 22:45:42,357 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,357 utils (0.000) SELECT * FROM `cms_faqs` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,357 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,358 utils (0.000) SHOW INDEX FROM `cms_faqs`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,358 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_faqs'
            ; args=['cms_faqs']; alias=default
DEBUG 2026-01-24 22:45:42,358 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,359 utils (0.000) SELECT * FROM `cms_faqs` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,359 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'cms_visa_durations'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['cms_visa_durations']; alias=default
DEBUG 2026-01-24 22:45:42,360 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,361 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_durations'
            ; args=['cms_visa_durations']; alias=default
DEBUG 2026-01-24 22:45:42,361 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,362 utils (0.001) SELECT * FROM `cms_visa_durations` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,363 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,368 utils (0.005) SHOW INDEX FROM `cms_visa_durations`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,370 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,371 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_durations'
            ; args=['cms_visa_durations']; alias=default
DEBUG 2026-01-24 22:45:42,371 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,371 utils (0.000) SELECT * FROM `cms_visa_durations` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,372 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,372 utils (0.000) SHOW INDEX FROM `cms_visa_durations`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,373 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_durations'
            ; args=['cms_visa_durations']; alias=default
DEBUG 2026-01-24 22:45:42,373 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,374 utils (0.000) SELECT * FROM `cms_visa_durations` LIMIT 1; args=None; alias=default


class CmsVisaDurations(models.Model):
DEBUG 2026-01-24 22:45:42,375 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,375 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_packages'
            ; args=['cms_visa_packages']; alias=default
DEBUG 2026-01-24 22:45:42,376 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,377 utils (0.001) SELECT * FROM `cms_visa_packages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,377 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,381 utils (0.004) SHOW INDEX FROM `cms_visa_packages`; args=None; alias=default
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
DEBUG 2026-01-24 22:45:42,382 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'cms_visa_packages'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['cms_visa_packages']; alias=default
DEBUG 2026-01-24 22:45:42,383 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,384 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_packages'
            ; args=['cms_visa_packages']; alias=default
DEBUG 2026-01-24 22:45:42,384 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,385 utils (0.000) SELECT * FROM `cms_visa_packages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,385 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,386 utils (0.000) SHOW INDEX FROM `cms_visa_packages`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,387 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,387 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_packages'
            ; args=['cms_visa_packages']; alias=default
DEBUG 2026-01-24 22:45:42,388 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,389 utils (0.000) SELECT * FROM `cms_visa_packages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,389 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,390 utils (0.001) SHOW INDEX FROM `cms_visa_packages`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,390 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'cms_visa_packages'
            ; args=['cms_visa_packages']; alias=default
DEBUG 2026-01-24 22:45:42,391 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,391 utils (0.000) SELECT * FROM `cms_visa_packages` LIMIT 1; args=None; alias=default


class CmsVisaPackages(models.Model):
DEBUG 2026-01-24 22:45:42,392 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,393 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'content_pages'
            ; args=['content_pages']; alias=default
DEBUG 2026-01-24 22:45:42,393 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,394 utils (0.000) SELECT * FROM `content_pages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,394 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,399 utils (0.004) SHOW INDEX FROM `content_pages`; args=None; alias=default
    cmscontentid = models.ForeignKey('ContentPages', models.DO_NOTHING, db_column='cmsContentId')  # Field name made lowercase.
    countryname = models.CharField(db_column='countryName', max_length=255)  # Field name made lowercase.
    packageurl = models.CharField(db_column='packageUrl', max_length=255, blank=True, null=True)  # Field name made lowercase.
    toururl = models.CharField(db_column='tourUrl', max_length=255, blank=True, null=True)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'cms_visa_packages'
DEBUG 2026-01-24 22:45:42,400 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'content_pages'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['content_pages']; alias=default
DEBUG 2026-01-24 22:45:42,401 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,401 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'content_pages'
            ; args=['content_pages']; alias=default
DEBUG 2026-01-24 22:45:42,402 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,402 utils (0.000) SELECT * FROM `content_pages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,403 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,403 utils (0.000) SHOW INDEX FROM `content_pages`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,405 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,405 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'content_pages'
            ; args=['content_pages']; alias=default
DEBUG 2026-01-24 22:45:42,406 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,406 utils (0.000) SELECT * FROM `content_pages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,407 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,407 utils (0.000) SHOW INDEX FROM `content_pages`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,408 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'content_pages'
            ; args=['content_pages']; alias=default
DEBUG 2026-01-24 22:45:42,408 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,408 utils (0.000) SELECT * FROM `content_pages` LIMIT 1; args=None; alias=default


class ContentPages(models.Model):
DEBUG 2026-01-24 22:45:42,410 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,411 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'parent_pages'
            ; args=['parent_pages']; alias=default
DEBUG 2026-01-24 22:45:42,411 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,412 utils (0.001) SELECT * FROM `parent_pages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,413 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,433 utils (0.019) SHOW INDEX FROM `parent_pages`; args=None; alias=default
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
DEBUG 2026-01-24 22:45:42,433 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'currencies'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['currencies']; alias=default
DEBUG 2026-01-24 22:45:42,435 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,435 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'currencies'
            ; args=['currencies']; alias=default
DEBUG 2026-01-24 22:45:42,436 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,436 utils (0.000) SELECT * FROM `currencies` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,436 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,439 utils (0.002) SHOW INDEX FROM `currencies`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,440 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,440 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'currencies'
            ; args=['currencies']; alias=default
DEBUG 2026-01-24 22:45:42,441 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,441 utils (0.000) SELECT * FROM `currencies` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,441 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,442 utils (0.000) SHOW INDEX FROM `currencies`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,442 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'currencies'
            ; args=['currencies']; alias=default
DEBUG 2026-01-24 22:45:42,443 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,443 utils (0.000) SELECT * FROM `currencies` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,443 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'customers'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['customers']; alias=default
DEBUG 2026-01-24 22:45:42,444 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,445 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'customers'
            ; args=['customers']; alias=default
DEBUG 2026-01-24 22:45:42,446 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,446 utils (0.000) SELECT * FROM `customers` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,446 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,447 utils (0.001) SHOW INDEX FROM `customers`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,449 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,449 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'customers'
            ; args=['customers']; alias=default
DEBUG 2026-01-24 22:45:42,450 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,450 utils (0.000) SELECT * FROM `customers` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,450 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,451 utils (0.000) SHOW INDEX FROM `customers`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,451 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'customers'
            ; args=['customers']; alias=default
DEBUG 2026-01-24 22:45:42,452 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,452 utils (0.000) SELECT * FROM `customers` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,452 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'django_admin_log'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['django_admin_log']; alias=default
DEBUG 2026-01-24 22:45:42,454 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,454 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_admin_log'
            ; args=['django_admin_log']; alias=default
DEBUG 2026-01-24 22:45:42,455 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,455 utils (0.001) SELECT * FROM `django_admin_log` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,456 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,482 utils (0.023) SHOW INDEX FROM `django_admin_log`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,484 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,484 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_admin_log'
            ; args=['django_admin_log']; alias=default
DEBUG 2026-01-24 22:45:42,485 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,485 utils (0.000) SELECT * FROM `django_admin_log` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,485 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,486 utils (0.000) SHOW INDEX FROM `django_admin_log`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,486 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_admin_log'
            ; args=['django_admin_log']; alias=default
DEBUG 2026-01-24 22:45:42,487 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,487 utils (0.000) SELECT * FROM `django_admin_log` LIMIT 1; args=None; alias=default


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
DEBUG 2026-01-24 22:45:42,489 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,489 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_content_type'
            ; args=['django_content_type']; alias=default
DEBUG 2026-01-24 22:45:42,490 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,490 utils (0.000) SELECT * FROM `django_content_type` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,490 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,491 utils (0.000) SHOW INDEX FROM `django_content_type`; args=None; alias=default
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
DEBUG 2026-01-24 22:45:42,492 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,492 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'auth_user'
            ; args=['auth_user']; alias=default
DEBUG 2026-01-24 22:45:42,493 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,493 utils (0.000) SELECT * FROM `auth_user` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,493 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,494 utils (0.000) SHOW INDEX FROM `auth_user`; args=None; alias=default
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'
DEBUG 2026-01-24 22:45:42,494 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'django_content_type'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['django_content_type']; alias=default
DEBUG 2026-01-24 22:45:42,496 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,496 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_content_type'
            ; args=['django_content_type']; alias=default
DEBUG 2026-01-24 22:45:42,497 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,497 utils (0.000) SELECT * FROM `django_content_type` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,498 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,499 utils (0.000) SHOW INDEX FROM `django_content_type`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,500 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,500 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_content_type'
            ; args=['django_content_type']; alias=default
DEBUG 2026-01-24 22:45:42,501 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,501 utils (0.000) SELECT * FROM `django_content_type` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,502 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,502 utils (0.000) SHOW INDEX FROM `django_content_type`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,502 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_content_type'
            ; args=['django_content_type']; alias=default
DEBUG 2026-01-24 22:45:42,503 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,503 utils (0.000) SELECT * FROM `django_content_type` LIMIT 1; args=None; alias=default


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)
DEBUG 2026-01-24 22:45:42,504 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'django_migrations'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['django_migrations']; alias=default
DEBUG 2026-01-24 22:45:42,505 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,505 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_migrations'
            ; args=['django_migrations']; alias=default
DEBUG 2026-01-24 22:45:42,505 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,506 utils (0.001) SELECT * FROM `django_migrations` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,507 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,510 utils (0.003) SHOW INDEX FROM `django_migrations`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,511 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,511 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_migrations'
            ; args=['django_migrations']; alias=default
DEBUG 2026-01-24 22:45:42,512 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,512 utils (0.000) SELECT * FROM `django_migrations` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,513 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,514 utils (0.001) SHOW INDEX FROM `django_migrations`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,514 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_migrations'
            ; args=['django_migrations']; alias=default
DEBUG 2026-01-24 22:45:42,515 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,515 utils (0.000) SELECT * FROM `django_migrations` LIMIT 1; args=None; alias=default


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'
DEBUG 2026-01-24 22:45:42,515 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'django_session'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['django_session']; alias=default
DEBUG 2026-01-24 22:45:42,516 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,517 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_session'
            ; args=['django_session']; alias=default
DEBUG 2026-01-24 22:45:42,517 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,517 utils (0.000) SELECT * FROM `django_session` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,518 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,523 utils (0.005) SHOW INDEX FROM `django_session`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,525 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,525 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_session'
            ; args=['django_session']; alias=default
DEBUG 2026-01-24 22:45:42,526 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,526 utils (0.000) SELECT * FROM `django_session` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,526 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,527 utils (0.000) SHOW INDEX FROM `django_session`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,527 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'django_session'
            ; args=['django_session']; alias=default
DEBUG 2026-01-24 22:45:42,528 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,528 utils (0.000) SELECT * FROM `django_session` LIMIT 1; args=None; alias=default


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'
DEBUG 2026-01-24 22:45:42,529 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'failed_jobs'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['failed_jobs']; alias=default
DEBUG 2026-01-24 22:45:42,530 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,531 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'failed_jobs'
            ; args=['failed_jobs']; alias=default
DEBUG 2026-01-24 22:45:42,532 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,532 utils (0.000) SELECT * FROM `failed_jobs` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,533 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,536 utils (0.004) SHOW INDEX FROM `failed_jobs`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,538 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,538 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'failed_jobs'
            ; args=['failed_jobs']; alias=default
DEBUG 2026-01-24 22:45:42,539 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,539 utils (0.000) SELECT * FROM `failed_jobs` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,539 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,540 utils (0.000) SHOW INDEX FROM `failed_jobs`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,540 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'failed_jobs'
            ; args=['failed_jobs']; alias=default
DEBUG 2026-01-24 22:45:42,541 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,541 utils (0.000) SELECT * FROM `failed_jobs` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,541 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'flight_booking_references'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['flight_booking_references']; alias=default
DEBUG 2026-01-24 22:45:42,542 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,543 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_booking_references'
            ; args=['flight_booking_references']; alias=default
DEBUG 2026-01-24 22:45:42,543 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,543 utils (0.000) SELECT * FROM `flight_booking_references` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,544 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,546 utils (0.002) SHOW INDEX FROM `flight_booking_references`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,547 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,548 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_booking_references'
            ; args=['flight_booking_references']; alias=default
DEBUG 2026-01-24 22:45:42,548 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,549 utils (0.000) SELECT * FROM `flight_booking_references` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,549 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,550 utils (0.001) SHOW INDEX FROM `flight_booking_references`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,550 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_booking_references'
            ; args=['flight_booking_references']; alias=default
DEBUG 2026-01-24 22:45:42,551 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,551 utils (0.000) SELECT * FROM `flight_booking_references` LIMIT 1; args=None; alias=default


class FlightBookingReferences(models.Model):
    bookingrefid = models.IntegerField(db_column='bookingRefId')  # Field name made lowercase.
    response = models.TextField(db_collation='utf8mb4_bin')
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'flight_booking_references'
DEBUG 2026-01-24 22:45:42,552 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'flight_itinerary_infos'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['flight_itinerary_infos']; alias=default
DEBUG 2026-01-24 22:45:42,554 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,555 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_infos'
            ; args=['flight_itinerary_infos']; alias=default
DEBUG 2026-01-24 22:45:42,556 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,557 utils (0.001) SELECT * FROM `flight_itinerary_infos` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,557 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,560 utils (0.002) SHOW INDEX FROM `flight_itinerary_infos`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,561 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,561 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_infos'
            ; args=['flight_itinerary_infos']; alias=default
DEBUG 2026-01-24 22:45:42,562 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,563 utils (0.001) SELECT * FROM `flight_itinerary_infos` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,564 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,565 utils (0.001) SHOW INDEX FROM `flight_itinerary_infos`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,565 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_infos'
            ; args=['flight_itinerary_infos']; alias=default
DEBUG 2026-01-24 22:45:42,566 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,567 utils (0.000) SELECT * FROM `flight_itinerary_infos` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,568 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'flight_itinerary_leg_infos'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['flight_itinerary_leg_infos']; alias=default
DEBUG 2026-01-24 22:45:42,569 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,569 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_leg_infos'
            ; args=['flight_itinerary_leg_infos']; alias=default
DEBUG 2026-01-24 22:45:42,570 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,570 utils (0.000) SELECT * FROM `flight_itinerary_leg_infos` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,571 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,573 utils (0.002) SHOW INDEX FROM `flight_itinerary_leg_infos`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,574 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,574 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_leg_infos'
            ; args=['flight_itinerary_leg_infos']; alias=default
DEBUG 2026-01-24 22:45:42,575 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,575 utils (0.000) SELECT * FROM `flight_itinerary_leg_infos` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,576 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,576 utils (0.000) SHOW INDEX FROM `flight_itinerary_leg_infos`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,577 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_leg_infos'
            ; args=['flight_itinerary_leg_infos']; alias=default
DEBUG 2026-01-24 22:45:42,577 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,577 utils (0.000) SELECT * FROM `flight_itinerary_leg_infos` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,578 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'flight_itinerary_person_infos'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['flight_itinerary_person_infos']; alias=default
DEBUG 2026-01-24 22:45:42,580 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,581 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_person_infos'
            ; args=['flight_itinerary_person_infos']; alias=default
DEBUG 2026-01-24 22:45:42,582 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,583 utils (0.001) SELECT * FROM `flight_itinerary_person_infos` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,583 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,586 utils (0.002) SHOW INDEX FROM `flight_itinerary_person_infos`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,587 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,588 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_person_infos'
            ; args=['flight_itinerary_person_infos']; alias=default
DEBUG 2026-01-24 22:45:42,589 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,589 utils (0.000) SELECT * FROM `flight_itinerary_person_infos` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,590 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,590 utils (0.000) SHOW INDEX FROM `flight_itinerary_person_infos`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,591 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itinerary_person_infos'
            ; args=['flight_itinerary_person_infos']; alias=default
DEBUG 2026-01-24 22:45:42,592 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,592 utils (0.000) SELECT * FROM `flight_itinerary_person_infos` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,595 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'flight_itineraryref_markup_infos'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['flight_itineraryref_markup_infos']; alias=default
DEBUG 2026-01-24 22:45:42,597 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,597 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itineraryref_markup_infos'
            ; args=['flight_itineraryref_markup_infos']; alias=default
DEBUG 2026-01-24 22:45:42,598 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,598 utils (0.000) SELECT * FROM `flight_itineraryref_markup_infos` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,599 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,601 utils (0.002) SHOW INDEX FROM `flight_itineraryref_markup_infos`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,602 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,602 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itineraryref_markup_infos'
            ; args=['flight_itineraryref_markup_infos']; alias=default
DEBUG 2026-01-24 22:45:42,603 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,603 utils (0.000) SELECT * FROM `flight_itineraryref_markup_infos` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,604 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,604 utils (0.000) SHOW INDEX FROM `flight_itineraryref_markup_infos`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,604 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'flight_itineraryref_markup_infos'
            ; args=['flight_itineraryref_markup_infos']; alias=default
DEBUG 2026-01-24 22:45:42,605 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,605 utils (0.000) SELECT * FROM `flight_itineraryref_markup_infos` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,606 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'followup_user_logs'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['followup_user_logs']; alias=default
DEBUG 2026-01-24 22:45:42,607 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,608 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'followup_user_logs'
            ; args=['followup_user_logs']; alias=default
DEBUG 2026-01-24 22:45:42,608 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,608 utils (0.000) SELECT * FROM `followup_user_logs` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,609 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,612 utils (0.003) SHOW INDEX FROM `followup_user_logs`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,613 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,614 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'followup_user_logs'
            ; args=['followup_user_logs']; alias=default
DEBUG 2026-01-24 22:45:42,615 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,615 utils (0.000) SELECT * FROM `followup_user_logs` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,615 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,616 utils (0.001) SHOW INDEX FROM `followup_user_logs`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,616 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'followup_user_logs'
            ; args=['followup_user_logs']; alias=default
DEBUG 2026-01-24 22:45:42,617 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,617 utils (0.000) SELECT * FROM `followup_user_logs` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,617 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'followups'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['followups']; alias=default
DEBUG 2026-01-24 22:45:42,618 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,619 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'followups'
            ; args=['followups']; alias=default
DEBUG 2026-01-24 22:45:42,619 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,620 utils (0.000) SELECT * FROM `followups` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,620 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,623 utils (0.003) SHOW INDEX FROM `followups`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,625 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,626 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'followups'
            ; args=['followups']; alias=default
DEBUG 2026-01-24 22:45:42,627 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,627 utils (0.000) SELECT * FROM `followups` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,628 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,633 utils (0.001) SHOW INDEX FROM `followups`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,634 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'followups'
            ; args=['followups']; alias=default
DEBUG 2026-01-24 22:45:42,634 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,635 utils (0.000) SELECT * FROM `followups` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,635 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'inoutbounds'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['inoutbounds']; alias=default
DEBUG 2026-01-24 22:45:42,637 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,637 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'inoutbounds'
            ; args=['inoutbounds']; alias=default
DEBUG 2026-01-24 22:45:42,638 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,638 utils (0.000) SELECT * FROM `inoutbounds` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,639 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,643 utils (0.004) SHOW INDEX FROM `inoutbounds`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,644 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,645 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'inoutbounds'
            ; args=['inoutbounds']; alias=default
DEBUG 2026-01-24 22:45:42,645 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,646 utils (0.000) SELECT * FROM `inoutbounds` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,647 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,647 utils (0.001) SHOW INDEX FROM `inoutbounds`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,648 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'inoutbounds'
            ; args=['inoutbounds']; alias=default
DEBUG 2026-01-24 22:45:42,649 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,649 utils (0.000) SELECT * FROM `inoutbounds` LIMIT 1; args=None; alias=default


class Inoutbounds(models.Model):
    id = models.BigAutoField(primary_key=True)
DEBUG 2026-01-24 22:45:42,651 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,651 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'agents'
            ; args=['agents']; alias=default
DEBUG 2026-01-24 22:45:42,652 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,652 utils (0.000) SELECT * FROM `agents` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,653 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,653 utils (0.000) SHOW INDEX FROM `agents`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,654 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'jobs'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['jobs']; alias=default
DEBUG 2026-01-24 22:45:42,655 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,655 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'jobs'
            ; args=['jobs']; alias=default
DEBUG 2026-01-24 22:45:42,656 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,656 utils (0.000) SELECT * FROM `jobs` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,656 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,660 utils (0.004) SHOW INDEX FROM `jobs`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,662 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,662 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'jobs'
            ; args=['jobs']; alias=default
DEBUG 2026-01-24 22:45:42,663 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,663 utils (0.000) SELECT * FROM `jobs` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,665 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,665 utils (0.001) SHOW INDEX FROM `jobs`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,666 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'jobs'
            ; args=['jobs']; alias=default
DEBUG 2026-01-24 22:45:42,666 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,666 utils (0.000) SELECT * FROM `jobs` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,667 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'markup_and_markdowns'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['markup_and_markdowns']; alias=default
DEBUG 2026-01-24 22:45:42,669 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,669 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'markup_and_markdowns'
            ; args=['markup_and_markdowns']; alias=default
DEBUG 2026-01-24 22:45:42,670 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,670 utils (0.000) SELECT * FROM `markup_and_markdowns` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,671 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,675 utils (0.004) SHOW INDEX FROM `markup_and_markdowns`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,676 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,677 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'markup_and_markdowns'
            ; args=['markup_and_markdowns']; alias=default
DEBUG 2026-01-24 22:45:42,677 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,678 utils (0.000) SELECT * FROM `markup_and_markdowns` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,678 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,679 utils (0.001) SHOW INDEX FROM `markup_and_markdowns`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,680 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'markup_and_markdowns'
            ; args=['markup_and_markdowns']; alias=default
DEBUG 2026-01-24 22:45:42,681 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,681 utils (0.000) SELECT * FROM `markup_and_markdowns` LIMIT 1; args=None; alias=default


class MarkupAndMarkdowns(models.Model):
    id = models.BigAutoField(primary_key=True)
DEBUG 2026-01-24 22:45:42,682 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,683 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'agents'
            ; args=['agents']; alias=default
DEBUG 2026-01-24 22:45:42,683 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,684 utils (0.000) SELECT * FROM `agents` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,684 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,685 utils (0.000) SHOW INDEX FROM `agents`; args=None; alias=default
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
DEBUG 2026-01-24 22:45:42,686 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'migrations'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['migrations']; alias=default
DEBUG 2026-01-24 22:45:42,687 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,687 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'migrations'
            ; args=['migrations']; alias=default
DEBUG 2026-01-24 22:45:42,688 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,688 utils (0.000) SELECT * FROM `migrations` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,689 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,691 utils (0.002) SHOW INDEX FROM `migrations`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,693 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,693 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'migrations'
            ; args=['migrations']; alias=default
DEBUG 2026-01-24 22:45:42,694 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,694 utils (0.000) SELECT * FROM `migrations` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,695 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,695 utils (0.000) SHOW INDEX FROM `migrations`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,696 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'migrations'
            ; args=['migrations']; alias=default
DEBUG 2026-01-24 22:45:42,697 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,697 utils (0.000) SELECT * FROM `migrations` LIMIT 1; args=None; alias=default


class Migrations(models.Model):
    migration = models.CharField(max_length=255)
    batch = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'migrations'
DEBUG 2026-01-24 22:45:42,698 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'parent_pages'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['parent_pages']; alias=default
DEBUG 2026-01-24 22:45:42,699 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,700 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'parent_pages'
            ; args=['parent_pages']; alias=default
DEBUG 2026-01-24 22:45:42,700 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,701 utils (0.000) SELECT * FROM `parent_pages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,701 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,702 utils (0.001) SHOW INDEX FROM `parent_pages`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,703 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,703 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'parent_pages'
            ; args=['parent_pages']; alias=default
DEBUG 2026-01-24 22:45:42,704 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,704 utils (0.000) SELECT * FROM `parent_pages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,704 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,705 utils (0.001) SHOW INDEX FROM `parent_pages`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,706 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'parent_pages'
            ; args=['parent_pages']; alias=default
DEBUG 2026-01-24 22:45:42,706 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,707 utils (0.000) SELECT * FROM `parent_pages` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,708 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'password_resets'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['password_resets']; alias=default
DEBUG 2026-01-24 22:45:42,708 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,709 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'password_resets'
            ; args=['password_resets']; alias=default
DEBUG 2026-01-24 22:45:42,709 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,709 utils (0.000) SELECT * FROM `password_resets` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,710 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,731 utils (0.019) SHOW INDEX FROM `password_resets`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,735 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,736 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'password_resets'
            ; args=['password_resets']; alias=default
DEBUG 2026-01-24 22:45:42,736 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,736 utils (0.000) SELECT * FROM `password_resets` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,737 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,738 utils (0.001) SHOW INDEX FROM `password_resets`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,739 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'password_resets'
            ; args=['password_resets']; alias=default
DEBUG 2026-01-24 22:45:42,739 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,739 utils (0.000) SELECT * FROM `password_resets` LIMIT 1; args=None; alias=default


class PasswordResets(models.Model):
    email = models.CharField(max_length=255)
    token = models.CharField(max_length=255)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'password_resets'
DEBUG 2026-01-24 22:45:42,740 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'payments'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['payments']; alias=default
DEBUG 2026-01-24 22:45:42,741 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,741 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'payments'
            ; args=['payments']; alias=default
DEBUG 2026-01-24 22:45:42,742 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,743 utils (0.000) SELECT * FROM `payments` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,743 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,746 utils (0.002) SHOW INDEX FROM `payments`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,747 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,748 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'payments'
            ; args=['payments']; alias=default
DEBUG 2026-01-24 22:45:42,749 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,749 utils (0.000) SELECT * FROM `payments` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,749 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,750 utils (0.000) SHOW INDEX FROM `payments`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,750 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'payments'
            ; args=['payments']; alias=default
DEBUG 2026-01-24 22:45:42,751 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,751 utils (0.000) SELECT * FROM `payments` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,752 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'permission_assigns'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['permission_assigns']; alias=default
DEBUG 2026-01-24 22:45:42,753 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,753 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_assigns'
            ; args=['permission_assigns']; alias=default
DEBUG 2026-01-24 22:45:42,754 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,754 utils (0.000) SELECT * FROM `permission_assigns` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,754 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,758 utils (0.004) SHOW INDEX FROM `permission_assigns`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,759 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,760 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_assigns'
            ; args=['permission_assigns']; alias=default
DEBUG 2026-01-24 22:45:42,760 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,760 utils (0.000) SELECT * FROM `permission_assigns` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,761 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,761 utils (0.000) SHOW INDEX FROM `permission_assigns`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,762 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_assigns'
            ; args=['permission_assigns']; alias=default
DEBUG 2026-01-24 22:45:42,762 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,763 utils (0.000) SELECT * FROM `permission_assigns` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,764 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'permission_types'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['permission_types']; alias=default
DEBUG 2026-01-24 22:45:42,765 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,765 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_types'
            ; args=['permission_types']; alias=default
DEBUG 2026-01-24 22:45:42,766 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,766 utils (0.001) SELECT * FROM `permission_types` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,767 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,773 utils (0.007) SHOW INDEX FROM `permission_types`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,775 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,776 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_types'
            ; args=['permission_types']; alias=default
DEBUG 2026-01-24 22:45:42,777 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,777 utils (0.000) SELECT * FROM `permission_types` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,778 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,778 utils (0.001) SHOW INDEX FROM `permission_types`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,779 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_types'
            ; args=['permission_types']; alias=default
DEBUG 2026-01-24 22:45:42,781 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,782 utils (0.000) SELECT * FROM `permission_types` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,783 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'permissions'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['permissions']; alias=default
DEBUG 2026-01-24 22:45:42,784 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,785 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permissions'
            ; args=['permissions']; alias=default
DEBUG 2026-01-24 22:45:42,785 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,786 utils (0.000) SELECT * FROM `permissions` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,786 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,793 utils (0.006) SHOW INDEX FROM `permissions`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,794 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,795 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permissions'
            ; args=['permissions']; alias=default
DEBUG 2026-01-24 22:45:42,795 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,796 utils (0.000) SELECT * FROM `permissions` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,797 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,798 utils (0.001) SHOW INDEX FROM `permissions`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,798 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permissions'
            ; args=['permissions']; alias=default
DEBUG 2026-01-24 22:45:42,799 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,799 utils (0.000) SELECT * FROM `permissions` LIMIT 1; args=None; alias=default


class Permissions(models.Model):
    title = models.CharField(max_length=255)
    moduletype = models.CharField(db_column='moduleType', max_length=255)  # Field name made lowercase.
    agentid = models.IntegerField(db_column='agentId')  # Field name made lowercase.
    parentid = models.IntegerField(db_column='parentId')  # Field name made lowercase.
    userid = models.IntegerField(db_column='userId')  # Field name made lowercase.
DEBUG 2026-01-24 22:45:42,802 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,803 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'permission_types'
            ; args=['permission_types']; alias=default
DEBUG 2026-01-24 22:45:42,804 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,804 utils (0.000) SELECT * FROM `permission_types` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,805 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,806 utils (0.001) SHOW INDEX FROM `permission_types`; args=None; alias=default
    permissiontypeid = models.ForeignKey(PermissionTypes, models.DO_NOTHING, db_column='permissionTypeId')  # Field name made lowercase.
    assigntype = models.CharField(db_column='assignType', max_length=5)  # Field name made lowercase.
    postbyid = models.IntegerField(db_column='postbyId')  # Field name made lowercase.
    postbytype = models.CharField(db_column='postbyType', max_length=5)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'permissions'
DEBUG 2026-01-24 22:45:42,807 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'personal_access_tokens'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['personal_access_tokens']; alias=default
DEBUG 2026-01-24 22:45:42,809 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,809 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'personal_access_tokens'
            ; args=['personal_access_tokens']; alias=default
DEBUG 2026-01-24 22:45:42,810 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,810 utils (0.000) SELECT * FROM `personal_access_tokens` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,811 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,824 utils (0.012) SHOW INDEX FROM `personal_access_tokens`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,825 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,826 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'personal_access_tokens'
            ; args=['personal_access_tokens']; alias=default
DEBUG 2026-01-24 22:45:42,827 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,827 utils (0.000) SELECT * FROM `personal_access_tokens` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,828 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,829 utils (0.001) SHOW INDEX FROM `personal_access_tokens`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,829 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'personal_access_tokens'
            ; args=['personal_access_tokens']; alias=default
DEBUG 2026-01-24 22:45:42,833 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,834 utils (0.000) SELECT * FROM `personal_access_tokens` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,834 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'premium_airlines'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['premium_airlines']; alias=default
DEBUG 2026-01-24 22:45:42,836 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,836 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'premium_airlines'
            ; args=['premium_airlines']; alias=default
DEBUG 2026-01-24 22:45:42,837 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,837 utils (0.000) SELECT * FROM `premium_airlines` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,838 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,842 utils (0.004) SHOW INDEX FROM `premium_airlines`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,844 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,844 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'premium_airlines'
            ; args=['premium_airlines']; alias=default
DEBUG 2026-01-24 22:45:42,845 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,845 utils (0.000) SELECT * FROM `premium_airlines` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,846 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,847 utils (0.001) SHOW INDEX FROM `premium_airlines`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,847 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'premium_airlines'
            ; args=['premium_airlines']; alias=default
DEBUG 2026-01-24 22:45:42,848 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,848 utils (0.000) SELECT * FROM `premium_airlines` LIMIT 1; args=None; alias=default


class PremiumAirlines(models.Model):
    id = models.BigAutoField(primary_key=True)
DEBUG 2026-01-24 22:45:42,850 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,850 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'agents'
            ; args=['agents']; alias=default
DEBUG 2026-01-24 22:45:42,851 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,851 utils (0.000) SELECT * FROM `agents` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,852 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,853 utils (0.000) SHOW INDEX FROM `agents`; args=None; alias=default
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
DEBUG 2026-01-24 22:45:42,853 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'rest_api_credentials'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['rest_api_credentials']; alias=default
DEBUG 2026-01-24 22:45:42,854 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,855 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'rest_api_credentials'
            ; args=['rest_api_credentials']; alias=default
DEBUG 2026-01-24 22:45:42,855 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,855 utils (0.000) SELECT * FROM `rest_api_credentials` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,856 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,858 utils (0.002) SHOW INDEX FROM `rest_api_credentials`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,859 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,860 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'rest_api_credentials'
            ; args=['rest_api_credentials']; alias=default
DEBUG 2026-01-24 22:45:42,861 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,861 utils (0.000) SELECT * FROM `rest_api_credentials` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,861 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,862 utils (0.000) SHOW INDEX FROM `rest_api_credentials`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,864 utils (0.002) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'rest_api_credentials'
            ; args=['rest_api_credentials']; alias=default
DEBUG 2026-01-24 22:45:42,882 utils (0.017) 
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
DEBUG 2026-01-24 22:45:42,883 utils (0.001) SELECT * FROM `rest_api_credentials` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,896 utils (0.011) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'sectors'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['sectors']; alias=default
DEBUG 2026-01-24 22:45:42,913 utils (0.016) 
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
DEBUG 2026-01-24 22:45:42,935 utils (0.022) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'sectors'
            ; args=['sectors']; alias=default
DEBUG 2026-01-24 22:45:42,940 utils (0.004) 
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
DEBUG 2026-01-24 22:45:42,940 utils (0.001) SELECT * FROM `sectors` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,941 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,945 utils (0.003) SHOW INDEX FROM `sectors`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,947 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,948 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'sectors'
            ; args=['sectors']; alias=default
DEBUG 2026-01-24 22:45:42,950 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,951 utils (0.000) SELECT * FROM `sectors` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:42,953 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,954 utils (0.001) SHOW INDEX FROM `sectors`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,954 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'sectors'
            ; args=['sectors']; alias=default
DEBUG 2026-01-24 22:45:42,955 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,955 utils (0.000) SELECT * FROM `sectors` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,961 utils (0.004) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'tour_images'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['tour_images']; alias=default
DEBUG 2026-01-24 22:45:42,990 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,991 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_images'
            ; args=['tour_images']; alias=default
DEBUG 2026-01-24 22:45:42,991 utils (0.001) 
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
DEBUG 2026-01-24 22:45:42,992 utils (0.001) SELECT * FROM `tour_images` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:42,993 utils (0.000) 
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
DEBUG 2026-01-24 22:45:42,997 utils (0.004) SHOW INDEX FROM `tour_images`; args=None; alias=default
DEBUG 2026-01-24 22:45:42,999 utils (0.002) 
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
DEBUG 2026-01-24 22:45:42,999 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_images'
            ; args=['tour_images']; alias=default
DEBUG 2026-01-24 22:45:43,000 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,000 utils (0.000) SELECT * FROM `tour_images` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,001 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,001 utils (0.001) SHOW INDEX FROM `tour_images`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,002 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_images'
            ; args=['tour_images']; alias=default
DEBUG 2026-01-24 22:45:43,002 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,003 utils (0.000) SELECT * FROM `tour_images` LIMIT 1; args=None; alias=default


class TourImages(models.Model):
DEBUG 2026-01-24 22:45:43,004 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,005 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_packages'
            ; args=['tour_packages']; alias=default
DEBUG 2026-01-24 22:45:43,005 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,006 utils (0.000) SELECT * FROM `tour_packages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,006 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,015 utils (0.009) SHOW INDEX FROM `tour_packages`; args=None; alias=default
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
DEBUG 2026-01-24 22:45:43,016 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'tour_packages'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['tour_packages']; alias=default
DEBUG 2026-01-24 22:45:43,017 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,018 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_packages'
            ; args=['tour_packages']; alias=default
DEBUG 2026-01-24 22:45:43,018 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,019 utils (0.000) SELECT * FROM `tour_packages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,019 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,020 utils (0.001) SHOW INDEX FROM `tour_packages`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,021 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,022 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_packages'
            ; args=['tour_packages']; alias=default
DEBUG 2026-01-24 22:45:43,022 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,023 utils (0.000) SELECT * FROM `tour_packages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,023 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,024 utils (0.001) SHOW INDEX FROM `tour_packages`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,024 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'tour_packages'
            ; args=['tour_packages']; alias=default
DEBUG 2026-01-24 22:45:43,025 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,025 utils (0.000) SELECT * FROM `tour_packages` LIMIT 1; args=None; alias=default


class TourPackages(models.Model):
    id = models.BigAutoField(primary_key=True)
DEBUG 2026-01-24 22:45:43,027 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,027 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'content_pages'
            ; args=['content_pages']; alias=default
DEBUG 2026-01-24 22:45:43,028 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,029 utils (0.000) SELECT * FROM `content_pages` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,030 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,034 utils (0.001) SHOW INDEX FROM `content_pages`; args=None; alias=default
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
DEBUG 2026-01-24 22:45:43,035 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_booking_customers'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_booking_customers']; alias=default
DEBUG 2026-01-24 22:45:43,037 utils (0.002) 
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
DEBUG 2026-01-24 22:45:43,037 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_customers'
            ; args=['umrah_booking_customers']; alias=default
DEBUG 2026-01-24 22:45:43,038 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,038 utils (0.000) SELECT * FROM `umrah_booking_customers` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,039 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,049 utils (0.010) SHOW INDEX FROM `umrah_booking_customers`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,051 utils (0.002) 
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
DEBUG 2026-01-24 22:45:43,053 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_customers'
            ; args=['umrah_booking_customers']; alias=default
DEBUG 2026-01-24 22:45:43,055 utils (0.002) 
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
DEBUG 2026-01-24 22:45:43,055 utils (0.000) SELECT * FROM `umrah_booking_customers` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,056 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,057 utils (0.001) SHOW INDEX FROM `umrah_booking_customers`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,057 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_customers'
            ; args=['umrah_booking_customers']; alias=default
DEBUG 2026-01-24 22:45:43,058 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,058 utils (0.000) SELECT * FROM `umrah_booking_customers` LIMIT 1; args=None; alias=default


class UmrahBookingCustomers(models.Model):
    id = models.BigAutoField(primary_key=True)
DEBUG 2026-01-24 22:45:43,060 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,060 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'customers'
            ; args=['customers']; alias=default
DEBUG 2026-01-24 22:45:43,061 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,061 utils (0.000) SELECT * FROM `customers` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,062 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,062 utils (0.001) SHOW INDEX FROM `customers`; args=None; alias=default
    customerid = models.ForeignKey(Customers, models.DO_NOTHING, db_column='customerId')  # Field name made lowercase.
    umrahvisaprice = models.FloatField(db_column='umrahVisaPrice')  # Field name made lowercase.
DEBUG 2026-01-24 22:45:43,064 utils (0.002) 
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
DEBUG 2026-01-24 22:45:43,065 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_transport_sectors'
            ; args=['umrah_transport_sectors']; alias=default
DEBUG 2026-01-24 22:45:43,066 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,066 utils (0.001) SELECT * FROM `umrah_transport_sectors` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,067 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,069 utils (0.002) SHOW INDEX FROM `umrah_transport_sectors`; args=None; alias=default
    umrahsectorid = models.ForeignKey('UmrahTransportSectors', models.DO_NOTHING, db_column='umrahSectorId')  # Field name made lowercase.
DEBUG 2026-01-24 22:45:43,071 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,071 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicles'
            ; args=['umrah_vehicles']; alias=default
DEBUG 2026-01-24 22:45:43,072 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,072 utils (0.000) SELECT * FROM `umrah_vehicles` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,073 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,075 utils (0.002) SHOW INDEX FROM `umrah_vehicles`; args=None; alias=default
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
DEBUG 2026-01-24 22:45:43,075 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_booking_hotel_room'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_booking_hotel_room']; alias=default
DEBUG 2026-01-24 22:45:43,077 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,077 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_hotel_room'
            ; args=['umrah_booking_hotel_room']; alias=default
DEBUG 2026-01-24 22:45:43,078 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,078 utils (0.000) SELECT * FROM `umrah_booking_hotel_room` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,078 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,080 utils (0.002) SHOW INDEX FROM `umrah_booking_hotel_room`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,082 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,082 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_hotel_room'
            ; args=['umrah_booking_hotel_room']; alias=default
DEBUG 2026-01-24 22:45:43,083 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,083 utils (0.000) SELECT * FROM `umrah_booking_hotel_room` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,083 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,084 utils (0.000) SHOW INDEX FROM `umrah_booking_hotel_room`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,084 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_hotel_room'
            ; args=['umrah_booking_hotel_room']; alias=default
DEBUG 2026-01-24 22:45:43,085 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,085 utils (0.000) SELECT * FROM `umrah_booking_hotel_room` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:43,085 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_bookings'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_bookings']; alias=default
DEBUG 2026-01-24 22:45:43,087 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,087 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_bookings'
            ; args=['umrah_bookings']; alias=default
DEBUG 2026-01-24 22:45:43,088 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,088 utils (0.001) SELECT * FROM `umrah_bookings` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,089 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,094 utils (0.006) SHOW INDEX FROM `umrah_bookings`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,096 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,097 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_bookings'
            ; args=['umrah_bookings']; alias=default
DEBUG 2026-01-24 22:45:43,097 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,097 utils (0.000) SELECT * FROM `umrah_bookings` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,098 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,099 utils (0.001) SHOW INDEX FROM `umrah_bookings`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,099 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_bookings'
            ; args=['umrah_bookings']; alias=default
DEBUG 2026-01-24 22:45:43,099 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,100 utils (0.000) SELECT * FROM `umrah_bookings` LIMIT 1; args=None; alias=default


class UmrahBookings(models.Model):
    id = models.BigAutoField(primary_key=True)
    location = models.CharField(max_length=20)
DEBUG 2026-01-24 22:45:43,102 utils (0.002) 
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
DEBUG 2026-01-24 22:45:43,102 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_booking_customers'
            ; args=['umrah_booking_customers']; alias=default
DEBUG 2026-01-24 22:45:43,102 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,103 utils (0.000) SELECT * FROM `umrah_booking_customers` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,103 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,104 utils (0.001) SHOW INDEX FROM `umrah_booking_customers`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,104 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_hotel_images'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_hotel_images']; alias=default
DEBUG 2026-01-24 22:45:43,105 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,106 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_images'
            ; args=['umrah_hotel_images']; alias=default
DEBUG 2026-01-24 22:45:43,106 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,107 utils (0.000) SELECT * FROM `umrah_hotel_images` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,107 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,112 utils (0.005) SHOW INDEX FROM `umrah_hotel_images`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,113 utils (0.002) 
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
DEBUG 2026-01-24 22:45:43,114 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_images'
            ; args=['umrah_hotel_images']; alias=default
DEBUG 2026-01-24 22:45:43,115 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,115 utils (0.000) SELECT * FROM `umrah_hotel_images` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,115 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,116 utils (0.000) SHOW INDEX FROM `umrah_hotel_images`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,116 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_images'
            ; args=['umrah_hotel_images']; alias=default
DEBUG 2026-01-24 22:45:43,117 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,117 utils (0.000) SELECT * FROM `umrah_hotel_images` LIMIT 1; args=None; alias=default


class UmrahHotelImages(models.Model):
    id = models.BigAutoField(primary_key=True)
DEBUG 2026-01-24 22:45:43,118 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,118 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotels'
            ; args=['umrah_hotels']; alias=default
DEBUG 2026-01-24 22:45:43,119 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,119 utils (0.000) SELECT * FROM `umrah_hotels` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,120 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,123 utils (0.003) SHOW INDEX FROM `umrah_hotels`; args=None; alias=default
    hotelid = models.ForeignKey('UmrahHotels', models.DO_NOTHING, db_column='hotelId')  # Field name made lowercase.
    hotelimage = models.CharField(db_column='hotelImage', max_length=255, blank=True, null=True)  # Field name made lowercase.
    hotelroomtype = models.CharField(db_column='hotelRoomType', max_length=6)  # Field name made lowercase.
    hotelroomimagestatus = models.CharField(db_column='hotelRoomImageStatus', max_length=1)  # Field name made lowercase.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'umrah_hotel_images'
DEBUG 2026-01-24 22:45:43,124 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_hotel_room_periods'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_hotel_room_periods']; alias=default
DEBUG 2026-01-24 22:45:43,125 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,125 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_room_periods'
            ; args=['umrah_hotel_room_periods']; alias=default
DEBUG 2026-01-24 22:45:43,126 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,126 utils (0.000) SELECT * FROM `umrah_hotel_room_periods` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,127 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,131 utils (0.004) SHOW INDEX FROM `umrah_hotel_room_periods`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,132 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,133 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_room_periods'
            ; args=['umrah_hotel_room_periods']; alias=default
DEBUG 2026-01-24 22:45:43,133 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,134 utils (0.000) SELECT * FROM `umrah_hotel_room_periods` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,134 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,134 utils (0.000) SHOW INDEX FROM `umrah_hotel_room_periods`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,135 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_room_periods'
            ; args=['umrah_hotel_room_periods']; alias=default
DEBUG 2026-01-24 22:45:43,135 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,136 utils (0.000) SELECT * FROM `umrah_hotel_room_periods` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:43,136 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_hotel_room_prices'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_hotel_room_prices']; alias=default
DEBUG 2026-01-24 22:45:43,137 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,138 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_room_prices'
            ; args=['umrah_hotel_room_prices']; alias=default
DEBUG 2026-01-24 22:45:43,138 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,138 utils (0.000) SELECT * FROM `umrah_hotel_room_prices` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,139 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,146 utils (0.007) SHOW INDEX FROM `umrah_hotel_room_prices`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,147 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,148 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_room_prices'
            ; args=['umrah_hotel_room_prices']; alias=default
DEBUG 2026-01-24 22:45:43,148 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,149 utils (0.000) SELECT * FROM `umrah_hotel_room_prices` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,149 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,150 utils (0.000) SHOW INDEX FROM `umrah_hotel_room_prices`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,150 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotel_room_prices'
            ; args=['umrah_hotel_room_prices']; alias=default
DEBUG 2026-01-24 22:45:43,150 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,151 utils (0.000) SELECT * FROM `umrah_hotel_room_prices` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,151 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_hotels'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_hotels']; alias=default
DEBUG 2026-01-24 22:45:43,153 utils (0.002) 
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
DEBUG 2026-01-24 22:45:43,154 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotels'
            ; args=['umrah_hotels']; alias=default
DEBUG 2026-01-24 22:45:43,154 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,154 utils (0.000) SELECT * FROM `umrah_hotels` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,155 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,156 utils (0.000) SHOW INDEX FROM `umrah_hotels`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,157 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,157 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotels'
            ; args=['umrah_hotels']; alias=default
DEBUG 2026-01-24 22:45:43,158 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,158 utils (0.000) SELECT * FROM `umrah_hotels` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,158 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,159 utils (0.000) SHOW INDEX FROM `umrah_hotels`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,159 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_hotels'
            ; args=['umrah_hotels']; alias=default
DEBUG 2026-01-24 22:45:43,160 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,160 utils (0.000) SELECT * FROM `umrah_hotels` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:43,160 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_transport_sectors'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_transport_sectors']; alias=default
DEBUG 2026-01-24 22:45:43,161 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,162 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_transport_sectors'
            ; args=['umrah_transport_sectors']; alias=default
DEBUG 2026-01-24 22:45:43,162 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,162 utils (0.000) SELECT * FROM `umrah_transport_sectors` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,163 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,163 utils (0.000) SHOW INDEX FROM `umrah_transport_sectors`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,165 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,165 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_transport_sectors'
            ; args=['umrah_transport_sectors']; alias=default
DEBUG 2026-01-24 22:45:43,166 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,166 utils (0.000) SELECT * FROM `umrah_transport_sectors` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,166 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,167 utils (0.000) SHOW INDEX FROM `umrah_transport_sectors`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,167 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_transport_sectors'
            ; args=['umrah_transport_sectors']; alias=default
DEBUG 2026-01-24 22:45:43,167 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,167 utils (0.000) SELECT * FROM `umrah_transport_sectors` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:43,168 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_vehicle_prices'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_vehicle_prices']; alias=default
DEBUG 2026-01-24 22:45:43,169 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,169 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicle_prices'
            ; args=['umrah_vehicle_prices']; alias=default
DEBUG 2026-01-24 22:45:43,170 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,170 utils (0.000) SELECT * FROM `umrah_vehicle_prices` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,170 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,175 utils (0.005) SHOW INDEX FROM `umrah_vehicle_prices`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,176 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,177 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicle_prices'
            ; args=['umrah_vehicle_prices']; alias=default
DEBUG 2026-01-24 22:45:43,177 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,178 utils (0.000) SELECT * FROM `umrah_vehicle_prices` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,178 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,178 utils (0.000) SHOW INDEX FROM `umrah_vehicle_prices`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,179 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicle_prices'
            ; args=['umrah_vehicle_prices']; alias=default
DEBUG 2026-01-24 22:45:43,179 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,180 utils (0.000) SELECT * FROM `umrah_vehicle_prices` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:43,180 utils (0.001) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_vehicles'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_vehicles']; alias=default
DEBUG 2026-01-24 22:45:43,182 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,182 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicles'
            ; args=['umrah_vehicles']; alias=default
DEBUG 2026-01-24 22:45:43,183 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,183 utils (0.000) SELECT * FROM `umrah_vehicles` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,183 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,184 utils (0.000) SHOW INDEX FROM `umrah_vehicles`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,185 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,185 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicles'
            ; args=['umrah_vehicles']; alias=default
DEBUG 2026-01-24 22:45:43,185 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,186 utils (0.000) SELECT * FROM `umrah_vehicles` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,186 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,186 utils (0.000) SHOW INDEX FROM `umrah_vehicles`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,187 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_vehicles'
            ; args=['umrah_vehicles']; alias=default
DEBUG 2026-01-24 22:45:43,187 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,187 utils (0.000) SELECT * FROM `umrah_vehicles` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:43,188 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'umrah_visas'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['umrah_visas']; alias=default
DEBUG 2026-01-24 22:45:43,189 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,189 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_visas'
            ; args=['umrah_visas']; alias=default
DEBUG 2026-01-24 22:45:43,190 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,190 utils (0.000) SELECT * FROM `umrah_visas` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,191 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,195 utils (0.004) SHOW INDEX FROM `umrah_visas`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,196 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,196 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_visas'
            ; args=['umrah_visas']; alias=default
DEBUG 2026-01-24 22:45:43,198 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,198 utils (0.000) SELECT * FROM `umrah_visas` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,198 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,199 utils (0.000) SHOW INDEX FROM `umrah_visas`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,200 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'umrah_visas'
            ; args=['umrah_visas']; alias=default
DEBUG 2026-01-24 22:45:43,200 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,200 utils (0.000) SELECT * FROM `umrah_visas` LIMIT 1; args=None; alias=default


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
DEBUG 2026-01-24 22:45:43,201 utils (0.000) 
            SELECT column_name, referenced_column_name, referenced_table_name
            FROM information_schema.key_column_usage
            WHERE table_name = 'users'
                AND table_schema = DATABASE()
                AND referenced_table_name IS NOT NULL
                AND referenced_column_name IS NOT NULL
            ; args=['users']; alias=default
DEBUG 2026-01-24 22:45:43,203 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,203 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'users'
            ; args=['users']; alias=default
DEBUG 2026-01-24 22:45:43,204 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,205 utils (0.000) SELECT * FROM `users` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,205 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,214 utils (0.009) SHOW INDEX FROM `users`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,224 utils (0.009) 
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
DEBUG 2026-01-24 22:45:43,234 utils (0.001) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'users'
            ; args=['users']; alias=default
DEBUG 2026-01-24 22:45:43,239 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,239 utils (0.000) SELECT * FROM `users` LIMIT 1; args=None; alias=default
DEBUG 2026-01-24 22:45:43,240 utils (0.000) 
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
DEBUG 2026-01-24 22:45:43,241 utils (0.001) SHOW INDEX FROM `users`; args=None; alias=default
DEBUG 2026-01-24 22:45:43,241 utils (0.000) 
            SELECT  table_collation
            FROM    information_schema.tables
            WHERE   table_schema = DATABASE()
            AND     table_name = 'users'
            ; args=['users']; alias=default
DEBUG 2026-01-24 22:45:43,242 utils (0.001) 
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
DEBUG 2026-01-24 22:45:43,242 utils (0.000) SELECT * FROM `users` LIMIT 1; args=None; alias=default


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
