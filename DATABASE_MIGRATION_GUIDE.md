# Database Migration Guide: Rehman Travels MySQL to Django

## Database Overview

**Source Database**: `rgttravelsrve1_maindb`
**Database Type**: MySQL 8.0.39
**Backup File**: `rgttravelsrve1_maindb.sql`
**Database Size**: 6.3 MB
**Total Tables**: 50
**Character Set**: utf8mb4
**Collation**: utf8mb4_0900_ai_ci / utf8mb4_unicode_ci
**Storage Engine**: InnoDB
**Backup Date**: January 20, 2026 at 11:36 PM

---

## Table of Contents

1. [Pre-Migration Checklist](#pre-migration-checklist)
2. [Environment Setup](#environment-setup)
3. [Database Import Process](#database-import-process)
4. [Django Model Generation](#django-model-generation)
5. [Model Refinement](#model-refinement)
6. [Data Validation](#data-validation)
7. [Foreign Key Relationships](#foreign-key-relationships)
8. [Index Migration](#index-migration)
9. [Testing Strategy](#testing-strategy)
10. [Rollback Plan](#rollback-plan)

---

## Complete Table List (50 Tables)

### Core Authentication & Users (3 tables)
- `agents` - Travel agent accounts
- `users` - Backend system users
- `personal_access_tokens` - API tokens

### Permissions & Access (3 tables)
- `permissions` - Permission definitions
- `permission_assigns` - User/agent permission mappings
- `permission_types` - Permission categories

### Flight Ticketing (6 tables)
- `flight_itinerary_infos` - Main flight booking records
- `flight_itinerary_person_infos` - Passenger details
- `flight_itinerary_leg_infos` - Flight segments
- `flight_booking_references` - Booking references
- `flight_itineraryref_markup_infos` - Markup information
- `sectors` - Route/sector definitions

### Umrah Packages (10 tables)
- `umrah_hotels` - Umrah destination hotels
- `umrah_hotel_images` - Hotel room images
- `umrah_hotel_room_periods` - Availability periods
- `umrah_hotel_room_prices` - Dynamic pricing
- `umrah_bookings` - Package bookings
- `umrah_booking_customers` - Customer details
- `umrah_booking_hotel_room` - Room assignments
- `umrah_vehicles` - Transportation options
- `umrah_vehicle_prices` - Vehicle pricing
- `umrah_transport_sectors` - Transport routes
- `umrah_visas` - Visa pricing

### CMS & Content (7 tables)
- `content_pages` - Dynamic website pages
- `parent_pages` - Page hierarchy
- `cms_visa_packages` - Visa package listings
- `cms_visa_durations` - Visa duration options
- `cms_faqs` - FAQ content
- `tour_packages` - Tour offerings
- `tour_images` - Tour package images

### Customer Management (4 tables)
- `customers` - Customer/lead records
- `cms_callback_queries` - Customer inquiries
- `call_recordings` - Call records
- `assign_call_recording_followups` - Call assignments

### Follow-up System (3 tables)
- `followups` - Follow-up tasks
- `followup_user_logs` - Follow-up logs
- `inoutbounds` - Inbound/outbound tracking

### Payments & Finance (2 tables)
- `payments` - Transaction records
- `bank_details` - Bank account information

### Configuration & Settings (8 tables)
- `administrative_settings` - System settings
- `branches` - Business locations
- `currencies` - Currency reference
- `premium_airlines` - Flight provider configuration
- `airline_name_codes` - Airline reference
- `markup_and_markdowns` - Pricing configuration
- `rest_api_credentials` - API credentials
- `migrations` - Laravel migrations log

### System Tables (4 tables)
- `failed_jobs` - Failed queue jobs
- `jobs` - Queue jobs
- `password_resets` - Password reset tokens
- (Total 50 tables)

---

## 1. Pre-Migration Checklist

### Before Starting

- [ ] **Backup verification**: Verify SQL dump is complete and uncorrupted
- [ ] **Database credentials**: Obtain production database credentials (if needed)
- [ ] **Django project**: Ensure Django project structure is created
- [ ] **Virtual environment**: Python virtual environment activated
- [ ] **Dependencies**: All required packages installed
- [ ] **Disk space**: Ensure at least 500MB free space
- [ ] **Database permissions**: Verify MySQL user has CREATE/DROP privileges

### Verify Backup File Integrity

```bash
# Check file exists and is readable
ls -lh rgttravelsrve1_maindb.sql

# Expected output: -rw-r--r-- 6.3M

# Count tables in backup
grep -c "^CREATE TABLE" rgttravelsrve1_maindb.sql
# Expected: 50

# Verify no corruption
head -20 rgttravelsrve1_maindb.sql
tail -20 rgttravelsrve1_maindb.sql
```

---

## 2. Environment Setup

### 2.1 Install Required Software

**On macOS:**

```bash
# Install MySQL (if not already installed)
brew install mysql@8.0

# Start MySQL service
brew services start mysql@8.0

# Or start manually
mysql.server start

# Verify MySQL is running
mysql --version
# Expected: mysql  Ver 8.0.x
```

**On Ubuntu/Debian:**

```bash
sudo apt update
sudo apt install mysql-server mysql-client
sudo systemctl start mysql
sudo systemctl enable mysql
```

### 2.2 Create Django MySQL Database

```bash
# Login to MySQL as root
mysql -u root -p

# Or if no password set
mysql -u root
```

**Run these SQL commands:**

```sql
-- Create database with UTF-8 support
CREATE DATABASE rehman_travels_django
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

-- Create Django user with privileges
CREATE USER 'django_user'@'localhost' IDENTIFIED BY 'secure_password_here';

-- Grant all privileges
GRANT ALL PRIVILEGES ON rehman_travels_django.* TO 'django_user'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;

-- Verify database created
SHOW DATABASES;

-- Exit
EXIT;
```

### 2.3 Install Python MySQL Driver

```bash
# Activate your Django virtual environment
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Install MySQL driver
pip install mysqlclient

# Alternative: PyMySQL (pure Python)
pip install PyMySQL

# If using PyMySQL, add to manage.py and wsgi.py:
# import pymysql
# pymysql.install_as_MySQLdb()
```

### 2.4 Configure Django Database Settings

**File**: `config/settings/base.py`

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'rehman_travels_django',
        'USER': 'django_user',
        'PASSWORD': 'secure_password_here',
        'HOST': 'localhost',
        'PORT': '3306',
        'OPTIONS': {
            'charset': 'utf8mb4',
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
        },
    }
}
```

---

## 3. Database Import Process

### 3.1 Import Laravel Database Backup

**Option A: Import to Temporary Database (Recommended)**

This allows you to inspect and migrate gradually without affecting production.

```bash
# Create temporary database for Laravel data
mysql -u root -p -e "CREATE DATABASE rehman_travels_laravel
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;"

# Import the backup
mysql -u root -p rehman_travels_laravel < rgttravelsrve1_maindb.sql

# This may take 1-2 minutes depending on data volume

# Verify import
mysql -u root -p rehman_travels_laravel -e "SHOW TABLES;"
# Should show 50 tables

# Check row counts
mysql -u root -p rehman_travels_laravel -e "
  SELECT
    table_name,
    table_rows
  FROM information_schema.tables
  WHERE table_schema = 'rehman_travels_laravel'
  ORDER BY table_rows DESC
  LIMIT 10;
"
```

**Option B: Import Directly to Django Database**

Use this if you want Django to work directly with existing data.

```bash
# Import directly to Django database
mysql -u django_user -p rehman_travels_django < rgttravelsrve1_maindb.sql

# Verify
mysql -u django_user -p rehman_travels_django -e "SHOW TABLES;"
```

### 3.2 Verify Data Import

```bash
# Connect to database
mysql -u root -p rehman_travels_laravel

# Or for Django database
mysql -u django_user -p rehman_travels_django
```

**Run verification queries:**

```sql
-- Check all tables exist
SHOW TABLES;
-- Expected: 50 tables

-- Check key tables have data
SELECT COUNT(*) FROM agents;
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM flight_itinerary_infos;
SELECT COUNT(*) FROM umrah_hotels;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM content_pages;

-- Check character set
SHOW VARIABLES LIKE 'character_set%';
SHOW VARIABLES LIKE 'collation%';

-- Sample data from key tables
SELECT id, userName, email, markupType FROM agents LIMIT 5;
SELECT id, itineraryRef, tripType, departureDate FROM flight_itinerary_infos LIMIT 5;
SELECT id, hotelName, location, hotelType FROM umrah_hotels LIMIT 5;

EXIT;
```

### 3.3 Handle Import Issues

**Issue: Character encoding errors**

```sql
-- If you see garbled text, reimport with explicit charset
mysql -u root -p --default-character-set=utf8mb4 rehman_travels_laravel < rgttravelsrve1_maindb.sql
```

**Issue: Foreign key errors**

```sql
-- Disable foreign key checks during import
SET FOREIGN_KEY_CHECKS=0;
SOURCE rgttravelsrve1_maindb.sql;
SET FOREIGN_KEY_CHECKS=1;
```

**Issue: Duplicate entry errors**

```bash
# Clean the SQL file first
sed 's/INSERT INTO/INSERT IGNORE INTO/g' rgttravelsrve1_maindb.sql > rgttravelsrve1_maindb_clean.sql

# Then import
mysql -u root -p rehman_travels_laravel < rgttravelsrve1_maindb_clean.sql
```

---

## 4. Django Model Generation

### 4.1 Use inspectdb to Generate Models

Django's `inspectdb` command reads the database schema and generates model classes.

```bash
# Navigate to Django project root
cd rehman-travels-django

# Generate models for entire database
python manage.py inspectdb --database=default > inspected_models.py

# Or generate for specific tables
python manage.py inspectdb agents users flight_itinerary_infos > inspected_models_partial.py

# Review the generated file
cat inspected_models.py | head -100
```

**Expected output structure:**

```python
# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set
#   * Remove `managed = False` lines if you wish to allow Django migrations

from django.db import models

class AdministrativeSetting(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=50)
    email = models.CharField(max_length=25)
    # ... etc

    class Meta:
        managed = False
        db_table = 'administrative_settings'
```

### 4.2 Organize Models by Django App

Distribute the generated models across your Django apps:

**Step 1: Create base model structure**

```bash
# Create models directory structure
mkdir -p apps/accounts/models
mkdir -p apps/ticketing/models
mkdir -p apps/hotels/models
mkdir -p apps/umrah/models
mkdir -p apps/payments/models
mkdir -p apps/cms/models
mkdir -p apps/core/models
```

**Step 2: Extract and place models**

From `inspected_models.py`, extract models to appropriate apps:

**`apps/accounts/models.py`**:
```python
# Extract: Agent, User, Permission, PermissionAssign, PermissionType, PersonalAccessToken
```

**`apps/ticketing/models.py`**:
```python
# Extract: FlightItineraryInfo, FlightItineraryPersonInfo, FlightItineraryLegInfo,
#          FlightBookingReference, FlightItineraryrefMarkupInfo, Sector, PremiumAirline
```

**`apps/umrah/models.py`**:
```python
# Extract: UmrahHotel, UmrahHotelImage, UmrahHotelRoomPeriod, UmrahHotelRoomPrice,
#          UmrahBooking, UmrahBookingCustomer, UmrahBookingHotelRoom,
#          UmrahVehicle, UmrahVehiclePrice, UmrahTransportSector, UmrahVisa
```

**`apps/cms/models.py`**:
```python
# Extract: ContentPage, ParentPage, CmsVisaPackage, CmsVisaDuration, CmsFaq,
#          TourPackage, TourImage
```

**`apps/core/models.py`**:
```python
# Extract: Customer, CmsCallbackQuery, Currency, Branch, BankDetail,
#          AdministrativeSetting, MarkupAndMarkdown, RestApiCredential
```

**`apps/payments/models.py`**:
```python
# Extract: Payment
```

---

## 5. Model Refinement

### 5.1 Critical Manual Edits Required

After `inspectdb`, you MUST manually edit each model:

#### A. Remove `managed = False`

**Before:**
```python
class Agent(models.Model):
    # ... fields ...

    class Meta:
        managed = False  # Remove this!
        db_table = 'agents'
```

**After:**
```python
class Agent(models.Model):
    # ... fields ...

    class Meta:
        db_table = 'agents'
```

**Why**: `managed = False` prevents Django migrations from managing the table.

#### B. Add `on_delete` to ForeignKey Fields

**Before:**
```python
parent = models.ForeignKey('self', models.DO_NOTHING, blank=True, null=True)
```

**After:**
```python
parent = models.ForeignKey(
    'self',
    on_delete=models.SET_NULL,  # Choose appropriate behavior
    blank=True,
    null=True,
    related_name='children'
)
```

**on_delete options**:
- `CASCADE` - Delete child when parent deleted (use for bookings → rooms)
- `SET_NULL` - Set to NULL (use for optional relationships)
- `PROTECT` - Prevent deletion (use for critical references)
- `SET_DEFAULT` - Set to default value

#### C. Fix Field Names to Follow Python Conventions

**Before (from Laravel):**
```python
class Agent(models.Model):
    parentId = models.BigIntegerField()  # camelCase
    userName = models.CharField(max_length=255)
    companyName = models.CharField(max_length=255)
```

**After (Django convention):**
```python
class Agent(models.Model):
    parent_id = models.BigIntegerField(db_column='parentId')  # snake_case
    user_name = models.CharField(max_length=255, db_column='userName')
    company_name = models.CharField(max_length=255, db_column='companyName')
```

**Or keep original (easier migration):**
```python
class Agent(models.Model):
    parentId = models.BigIntegerField()  # Keep as-is
    userName = models.CharField(max_length=255)
    companyName = models.CharField(max_length=255)

    # Use properties for Python-friendly access
    @property
    def parent_id(self):
        return self.parentId
```

#### D. Add Auto Fields for Timestamps

**Before:**
```python
created_at = models.DateTimeField(blank=True, null=True)
updated_at = models.DateTimeField(blank=True, null=True)
```

**After:**
```python
created_at = models.DateTimeField(auto_now_add=True)  # Set on creation
updated_at = models.DateTimeField(auto_now=True)      # Update on save
```

#### E. Use Abstract Base Classes

Create reusable base models:

**`apps/core/models.py`**:

```python
from django.db import models

class TimestampedModel(models.Model):
    """Abstract base class with created_at and updated_at"""
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True

class SoftDeleteModel(models.Model):
    """Abstract base class with soft delete"""
    deleted_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        abstract = True

    def delete(self, using=None, keep_parents=False):
        """Soft delete: set deleted_at instead of removing"""
        self.deleted_at = timezone.now()
        self.save()

    def hard_delete(self):
        """Actual delete from database"""
        super().delete()
```

**Use in models:**

```python
class Agent(TimestampedModel, SoftDeleteModel):
    # ... fields ...
    # Automatically gets: created_at, updated_at, deleted_at, delete(), hard_delete()
```

### 5.2 Laravel to Django Field Type Mapping

Complete mapping reference:

| Laravel Migration | MySQL Type | Django Field | Notes |
|------------------|------------|--------------|-------|
| `bigIncrements()` | BIGINT UNSIGNED AUTO_INCREMENT | `BigAutoField(primary_key=True)` | Primary key |
| `increments()` | INT UNSIGNED AUTO_INCREMENT | `AutoField(primary_key=True)` | Primary key |
| `string('name', 255)` | VARCHAR(255) | `CharField(max_length=255)` | |
| `text('description')` | TEXT | `TextField()` | Unlimited length |
| `integer('count')` | INT | `IntegerField()` | |
| `bigInteger('id')` | BIGINT | `BigIntegerField()` | Large numbers |
| `decimal('price', 8, 2)` | DECIMAL(8,2) | `DecimalField(max_digits=8, decimal_places=2)` | For money |
| `double('amount', 20, 2)` | DOUBLE(20,2) | `DecimalField(max_digits=20, decimal_places=2)` | High precision |
| `float('rate')` | FLOAT | `FloatField()` | Approximate |
| `boolean('active')` | TINYINT(1) | `BooleanField()` | True/False |
| `date('birth_date')` | DATE | `DateField()` | |
| `dateTime('created_at')` | DATETIME | `DateTimeField()` | |
| `timestamp('updated_at')` | TIMESTAMP | `DateTimeField()` | Auto-update |
| `time('start_time')` | TIME | `TimeField()` | |
| `json('metadata')` | JSON | `JSONField()` | MySQL 5.7+ |
| `enum('status', [...])` | ENUM | `CharField(max_length=X, choices=[...])` | Use choices |
| `foreignId('user_id')` | BIGINT UNSIGNED | `ForeignKey(User, on_delete=...)` | Relationship |

**Special Cases:**

**Enum Fields:**
```python
# Laravel: enum('status', ['pending', 'active', 'inactive'])
# Django:
status = models.CharField(
    max_length=10,
    choices=[
        ('pending', 'Pending'),
        ('active', 'Active'),
        ('inactive', 'Inactive'),
    ],
    default='pending'
)
```

**JSON Fields:**
```python
# Laravel: json('metadata')
# Django:
metadata = models.JSONField(default=dict, blank=True)

# Access in Python
obj.metadata = {'key': 'value'}
obj.save()
```

**Nullable Fields:**
```python
# Laravel: ->nullable()
# Django:
field = models.CharField(max_length=255, null=True, blank=True)
# null=True: Database allows NULL
# blank=True: Form validation allows empty
```

**Default Values:**
```python
# Laravel: ->default('value')
# Django:
status = models.CharField(max_length=10, default='pending')
```

---

## 6. Data Validation

### 6.1 Run Data Integrity Checks

After importing, verify data integrity:

```sql
-- Connect to database
mysql -u root -p rehman_travels_laravel

-- Check for orphaned foreign keys
-- Example: Agents without valid parent
SELECT a.id, a.userName, a.parentId
FROM agents a
LEFT JOIN agents parent ON a.parentId = parent.id
WHERE a.parentId != 1 AND parent.id IS NULL;

-- Check for NULL in NOT NULL columns
SELECT * FROM agents WHERE email IS NULL OR email = '';

-- Check for invalid date ranges
SELECT * FROM umrah_hotel_room_periods
WHERE periodFrom > periodTo;

-- Check for negative prices
SELECT * FROM umrah_hotel_room_prices
WHERE onDayPrice < 0 OR offDayPrice < 0;

-- Check duplicate emails
SELECT email, COUNT(*)
FROM agents
GROUP BY email
HAVING COUNT(*) > 1;
```

### 6.2 Data Cleanup Scripts

Create Python scripts to clean data:

**`scripts/clean_data.py`**:

```python
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings.development')
django.setup()

from apps.accounts.models import Agent
from apps.umrah.models import UmrahHotelRoomPeriod

# Fix NULL emails
agents_without_email = Agent.objects.filter(email__isnull=True)
for agent in agents_without_email:
    agent.email = f'agent_{agent.id}@placeholder.com'
    agent.save()

# Fix invalid date ranges
invalid_periods = UmrahHotelRoomPeriod.objects.filter(
    periodFrom__gt=models.F('periodTo')
)
for period in invalid_periods:
    # Swap dates
    period.periodFrom, period.periodTo = period.periodTo, period.periodFrom
    period.save()

print("Data cleanup complete!")
```

**Run the script:**
```bash
python scripts/clean_data.py
```

---

## 7. Foreign Key Relationships

### 7.1 Identify All Foreign Keys

Extract foreign key relationships from SQL:

```bash
# Extract all foreign key constraints
grep -i "FOREIGN KEY" rgttravelsrve1_maindb.sql

# Or check in MySQL
mysql -u root -p rehman_travels_laravel -e "
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'rehman_travels_laravel'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
"
```

### 7.2 Define Relationships in Django Models

**Example: Agent Model with Relationships**

```python
from django.db import models

class Agent(models.Model):
    id = models.BigAutoField(primary_key=True)

    # Self-referential FK (agent hierarchy)
    parent = models.ForeignKey(
        'self',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='sub_agents',
        db_column='parentId'
    )

    # FK to Branch
    branch = models.ForeignKey(
        'Branch',
        on_delete=models.PROTECT,  # Don't allow deleting branches with agents
        related_name='agents',
        db_column='branchId'
    )

    # Fields...
    userName = models.CharField(max_length=255)
    email = models.EmailField(unique=True)

    class Meta:
        db_table = 'agents'

    def __str__(self):
        return self.userName
```

**Example: Flight Itinerary with Multiple FKs**

```python
class FlightItineraryInfo(models.Model):
    id = models.BigAutoField(primary_key=True)
    itineraryRef = models.CharField(max_length=255, unique=True)

    # FK to Agent
    agent = models.ForeignKey(
        Agent,
        on_delete=models.PROTECT,
        related_name='flight_itineraries',
        db_column='agentId'
    )

    # FK to Payment
    payment = models.ForeignKey(
        'payments.Payment',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='flight_bookings',
        db_column='paymentId'
    )

    # Reverse relationships for inline objects
    # passengers = reverse FK from FlightItineraryPersonInfo
    # legs = reverse FK from FlightItineraryLegInfo

    class Meta:
        db_table = 'flight_itinerary_infos'
```

**Example: Umrah Booking with Inlines**

```python
class UmrahBooking(models.Model):
    id = models.BigAutoField(primary_key=True)

    # FK to customer
    customer = models.ForeignKey(
        'UmrahBookingCustomer',
        on_delete=models.CASCADE,  # Delete bookings if customer deleted
        related_name='bookings',
        db_column='customerId'
    )

    # FK to hotel
    hotel = models.ForeignKey(
        'UmrahHotel',
        on_delete=models.PROTECT,
        related_name='bookings',
        db_column='hotelId'
    )

    class Meta:
        db_table = 'umrah_bookings'
```

### 7.3 Test Relationships

```python
# In Django shell
python manage.py shell

# Test queries
from apps.accounts.models import Agent

# Get agent with parent
agent = Agent.objects.select_related('parent', 'branch').first()
print(agent.parent.userName if agent.parent else "No parent")
print(agent.branch.branchName)

# Get agent's sub-agents (reverse FK)
owner = Agent.objects.get(id=1)
sub_agents = owner.sub_agents.all()
print(f"Owner has {sub_agents.count()} sub-agents")

# Get flight itineraries for an agent
from apps.ticketing.models import FlightItineraryInfo
itineraries = FlightItineraryInfo.objects.filter(agent=agent)
```

---

## 8. Index Migration

### 8.1 Identify Existing Indexes

```sql
-- Show indexes for all tables
SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'rehman_travels_laravel'
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;
```

### 8.2 Add Indexes in Django Models

```python
class FlightItineraryInfo(models.Model):
    itineraryRef = models.CharField(max_length=255, unique=True)
    agentId = models.BigIntegerField()
    departureDate = models.DateField()

    class Meta:
        db_table = 'flight_itinerary_infos'
        indexes = [
            models.Index(fields=['agentId', 'departureDate'], name='idx_agent_dept_date'),
            models.Index(fields=['itineraryRef'], name='idx_itinerary_ref'),
            models.Index(fields=['-departureDate'], name='idx_dept_date_desc'),
        ]
```

---

## 9. Testing Strategy

### 9.1 Migration Tests

**Create test file**: `tests/test_migration.py`

```python
import pytest
from django.db import connection
from apps.accounts.models import Agent, User
from apps.ticketing.models import FlightItineraryInfo
from apps.umrah.models import UmrahHotel

@pytest.mark.django_db
class TestDatabaseMigration:

    def test_all_tables_exist(self):
        """Verify all 50 tables exist"""
        with connection.cursor() as cursor:
            cursor.execute("SHOW TABLES")
            tables = [row[0] for row in cursor.fetchall()]

        expected_tables = [
            'agents', 'users', 'flight_itinerary_infos',
            'umrah_hotels', 'payments', 'customers',
            # ... list all 50
        ]

        for table in expected_tables:
            assert table in tables, f"Table {table} missing"

    def test_data_counts_match(self):
        """Verify record counts match backup"""
        # Get counts from original backup
        # Compare with Django ORM counts

        agent_count = Agent.objects.count()
        assert agent_count > 0, "No agents found"

        # Add specific count checks if known
        # assert agent_count == EXPECTED_COUNT

    def test_relationships_work(self):
        """Test foreign key relationships"""
        agent = Agent.objects.select_related('parent', 'branch').first()
        assert agent is not None

        # Test parent relationship
        if agent.parent:
            assert isinstance(agent.parent, Agent)

        # Test branch relationship
        assert agent.branch is not None

    def test_unique_constraints(self):
        """Verify unique constraints"""
        # Emails should be unique
        agents = Agent.objects.values('email').annotate(count=models.Count('id'))
        duplicates = agents.filter(count__gt=1)
        assert duplicates.count() == 0, "Duplicate emails found"
```

**Run tests:**
```bash
pytest tests/test_migration.py -v
```

### 9.2 Data Validation Tests

```python
@pytest.mark.django_db
class TestDataIntegrity:

    def test_no_null_required_fields(self):
        """Check required fields aren't NULL"""
        agents_with_null_email = Agent.objects.filter(email__isnull=True)
        assert agents_with_null_email.count() == 0

    def test_valid_date_ranges(self):
        """Check date ranges are valid"""
        from apps.umrah.models import UmrahHotelRoomPeriod

        invalid_periods = UmrahHotelRoomPeriod.objects.filter(
            periodFrom__gt=models.F('periodTo')
        )
        assert invalid_periods.count() == 0

    def test_positive_prices(self):
        """Check no negative prices"""
        from apps.umrah.models import UmrahHotelRoomPrice

        negative_prices = UmrahHotelRoomPrice.objects.filter(
            models.Q(onDayPrice__lt=0) | models.Q(offDayPrice__lt=0)
        )
        assert negative_prices.count() == 0
```

---

## 10. Rollback Plan

### 10.1 Backup Before Migration

```bash
# Backup current Django database BEFORE any changes
mysqldump -u django_user -p rehman_travels_django > backup_before_migration_$(date +%Y%m%d_%H%M%S).sql

# Backup with compression
mysqldump -u django_user -p rehman_travels_django | gzip > backup_before_migration_$(date +%Y%m%d_%H%M%S).sql.gz
```

### 10.2 Rollback Procedure

If migration fails:

```bash
# Step 1: Drop Django database
mysql -u root -p -e "DROP DATABASE rehman_travels_django;"

# Step 2: Recreate empty database
mysql -u root -p -e "CREATE DATABASE rehman_travels_django
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;"

# Step 3: Restore from backup
mysql -u django_user -p rehman_travels_django < backup_before_migration_TIMESTAMP.sql

# Or restore from compressed
gunzip < backup_before_migration_TIMESTAMP.sql.gz | mysql -u django_user -p rehman_travels_django

# Step 4: Verify restoration
mysql -u django_user -p rehman_travels_django -e "SHOW TABLES; SELECT COUNT(*) FROM agents;"
```

### 10.3 Point-in-Time Recovery

Keep multiple backups:

```bash
# Create backup schedule
# Daily backups
0 2 * * * mysqldump -u django_user -p'password' rehman_travels_django | gzip > /backups/daily_$(date +\%Y\%m\%d).sql.gz

# Weekly backups (keep 4 weeks)
0 3 * * 0 mysqldump -u django_user -p'password' rehman_travels_django | gzip > /backups/weekly_$(date +\%Y\%m\%d).sql.gz

# Cleanup old backups (older than 30 days)
find /backups -name "daily_*.sql.gz" -mtime +30 -delete
```

---

## Step-by-Step Migration Workflow

### Complete End-to-End Process

```bash
# ============================================================
# PHASE 1: PREPARATION (30 minutes)
# ============================================================

# 1. Verify backup file
ls -lh rgttravelsrve1_maindb.sql
grep -c "CREATE TABLE" rgttravelsrve1_maindb.sql  # Should be 50

# 2. Install MySQL and create databases
mysql -u root -p
```

```sql
CREATE DATABASE rehman_travels_laravel DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE rehman_travels_django DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'django_user'@'localhost' IDENTIFIED BY 'YourSecurePassword';
GRANT ALL PRIVILEGES ON rehman_travels_django.* TO 'django_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```bash
# 3. Import Laravel backup to temporary database
mysql -u root -p rehman_travels_laravel < rgttravelsrve1_maindb.sql

# 4. Verify import
mysql -u root -p rehman_travels_laravel -e "SHOW TABLES; SELECT COUNT(*) FROM agents;"

# ============================================================
# PHASE 2: DJANGO SETUP (1 hour)
# ============================================================

# 5. Install Python dependencies
pip install mysqlclient Django djangorestframework

# 6. Configure Django database settings
# Edit config/settings/base.py with database credentials

# 7. Test Django connection
python manage.py dbshell
# Type: SHOW DATABASES; EXIT;

# ============================================================
# PHASE 3: MODEL GENERATION (2 hours)
# ============================================================

# 8. Generate models from existing database
# Point Django to rehman_travels_laravel temporarily
python manage.py inspectdb > inspected_models.py

# 9. Review generated models
less inspected_models.py

# 10. Organize models into Django apps
# Manually split inspected_models.py into:
# - apps/accounts/models.py
# - apps/ticketing/models.py
# - apps/umrah/models.py
# - apps/payments/models.py
# - apps/cms/models.py
# - apps/core/models.py

# 11. Refine models
# - Remove managed = False
# - Add on_delete to ForeignKeys
# - Add __str__ methods
# - Configure Meta options

# ============================================================
# PHASE 4: MIGRATION (1 hour)
# ============================================================

# 12. Create initial migrations
python manage.py makemigrations

# 13. Review migration files
cat apps/accounts/migrations/0001_initial.py

# 14. Run migrations (creates tables in rehman_travels_django)
python manage.py migrate

# 15. Verify tables created
python manage.py dbshell
SHOW TABLES;  # Should show 50+ tables (including django_ tables)
EXIT;

# ============================================================
# PHASE 5: DATA COPY (if using separate databases)
# ============================================================

# 16. Copy data from Laravel DB to Django DB (if needed)
# Option A: Use mysqldump per table
for table in $(mysql -u root -p -N -e "SHOW TABLES FROM rehman_travels_laravel"); do
  mysqldump -u root -p rehman_travels_laravel $table | mysql -u django_user -p rehman_travels_django
done

# Option B: Direct insert (faster for large datasets)
mysql -u root -p rehman_travels_django -e "
  INSERT INTO agents SELECT * FROM rehman_travels_laravel.agents;
  INSERT INTO users SELECT * FROM rehman_travels_laravel.users;
  -- ... repeat for all tables
"

# ============================================================
# PHASE 6: VALIDATION (1 hour)
# ============================================================

# 17. Run data validation tests
python manage.py test tests.test_migration

# 18. Check data counts match
python manage.py shell
```

```python
from apps.accounts.models import Agent
from apps.ticketing.models import FlightItineraryInfo
print(f"Agents: {Agent.objects.count()}")
print(f"Flights: {FlightItineraryInfo.objects.count()}")
```

```bash
# 19. Test relationships
python manage.py shell
```

```python
from apps.accounts.models import Agent
agent = Agent.objects.select_related('parent', 'branch').first()
print(agent.parent)
print(agent.branch)
```

```bash
# ============================================================
# PHASE 7: DJANGO ADMIN SETUP (2 hours)
# ============================================================

# 20. Create superuser
python manage.py createsuperuser

# 21. Register models in admin
# Edit apps/*/admin.py files

# 22. Test admin interface
python manage.py runserver
# Visit: http://localhost:8000/admin/

# ============================================================
# PHASE 8: FINAL VERIFICATION (30 minutes)
# ============================================================

# 23. Run full test suite
pytest tests/ -v --cov

# 24. Performance check
python manage.py shell
```

```python
import time
from apps.ticketing.models import FlightItineraryInfo

start = time.time()
itineraries = FlightItineraryInfo.objects.select_related('agent').all()[:100]
for i in itineraries:
    _ = i.agent.userName
print(f"Time: {time.time() - start:.2f}s")
```

```bash
# 25. Create final backup
mysqldump -u django_user -p rehman_travels_django | gzip > final_migration_backup_$(date +%Y%m%d).sql.gz

# ============================================================
# MIGRATION COMPLETE!
# ============================================================
```

---

## Troubleshooting Common Issues

### Issue 1: Character Encoding Problems

**Symptom**: Non-English characters appear as `???` or garbled text.

**Solution**:
```sql
-- Check current charset
SHOW VARIABLES LIKE 'character_set%';

-- If not utf8mb4, convert table
ALTER TABLE agents CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- For all tables
SELECT CONCAT('ALTER TABLE ', table_name, ' CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;')
FROM information_schema.tables
WHERE table_schema = 'rehman_travels_django';
```

### Issue 2: Migration Fails with Foreign Key Errors

**Symptom**: `Cannot add foreign key constraint`

**Solution**:
```python
# In Django migration file, change:
operations = [
    migrations.RunSQL('SET FOREIGN_KEY_CHECKS=0;'),
    # ... your migrations ...
    migrations.RunSQL('SET FOREIGN_KEY_CHECKS=1;'),
]
```

### Issue 3: Slow Queries

**Symptom**: Django ORM queries are slow.

**Solution**:
```python
# Use select_related for ForeignKey
agents = Agent.objects.select_related('parent', 'branch').all()

# Use prefetch_related for reverse ForeignKey
from django.db.models import Prefetch
agents = Agent.objects.prefetch_related('sub_agents').all()

# Add database indexes in models
class Meta:
    indexes = [
        models.Index(fields=['email']),
        models.Index(fields=['created_at']),
    ]
```

### Issue 4: inspectdb Generates Incorrect Types

**Symptom**: Decimal fields become CharField, etc.

**Solution**: Manually review and fix field types based on actual usage.

---

## Post-Migration Checklist

- [ ] All 50 tables imported successfully
- [ ] Data counts match original database
- [ ] All foreign key relationships work
- [ ] Django admin can view all models
- [ ] No orphaned foreign keys
- [ ] Character encoding is UTF-8
- [ ] Indexes are created
- [ ] Queries perform well (< 500ms)
- [ ] Backup created and verified
- [ ] Test suite passes
- [ ] Documentation updated

---

## Maintenance Scripts

### Daily Health Check

**`scripts/db_health_check.py`**:

```python
#!/usr/bin/env python
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings.production')
django.setup()

from django.db import connection
from apps.accounts.models import Agent
from apps.ticketing.models import FlightItineraryInfo

def check_database_health():
    print("=" * 50)
    print("DATABASE HEALTH CHECK")
    print("=" * 50)

    # Check connection
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
        print("✓ Database connection OK")
    except Exception as e:
        print(f"✗ Database connection failed: {e}")
        return

    # Check table counts
    tables = {
        'Agents': Agent.objects.count(),
        'Flights': FlightItineraryInfo.objects.count(),
    }

    for name, count in tables.items():
        print(f"  {name}: {count:,} records")

    # Check for orphaned records
    orphaned_agents = Agent.objects.filter(
        parent__isnull=False
    ).exclude(
        parent__in=Agent.objects.all()
    ).count()

    if orphaned_agents > 0:
        print(f"⚠ Found {orphaned_agents} orphaned agent records")
    else:
        print("✓ No orphaned records")

    print("=" * 50)

if __name__ == '__main__':
    check_database_health()
```

**Run daily via cron**:
```bash
0 6 * * * cd /path/to/project && /path/to/venv/bin/python scripts/db_health_check.py
```

---

## Summary

This guide provides a complete workflow for migrating your MySQL database from Laravel to Django:

1. ✅ Import existing MySQL backup (`rgttravelsrve1_maindb.sql`)
2. ✅ Generate Django models using `inspectdb`
3. ✅ Refine models and add relationships
4. ✅ Create migrations and verify data integrity
5. ✅ Set up Django admin interface
6. ✅ Test and validate all functionality

**Estimated Total Time**: 8-12 hours for complete migration

**Key Success Factors**:
- Keep original database as backup
- Test thoroughly at each phase
- Use version control for all code changes
- Document any custom modifications

For questions or issues during migration, refer to:
- Django Database Documentation: https://docs.djangoproject.com/en/4.2/ref/databases/
- MySQL to Django Migration Guide: https://docs.djangoproject.com/en/4.2/howto/legacy-databases/
