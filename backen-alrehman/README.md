# Rehman Travels Django Backend

Complete Django REST API backend for the Rehman Travels platform, migrated from Laravel.

## 🚀 Quick Start

### Using Docker (Recommended)

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f web

# Access Django shell
make shell

# Access container bash
make exec
```

### Services Running

- **Django Web**: http://localhost:8000
- **Django Admin**: http://localhost:8000/admin/
- **Swagger UI**: http://localhost:8000/swagger/
- **ReDoc**: http://localhost:8000/redoc/
- **MySQL**: localhost:3307
- **Redis**: localhost:6380

## 📚 API Documentation

### Interactive Documentation (Swagger UI)

Access the interactive API documentation at:
```
http://localhost:8000/swagger/
```

**Features:**
- Browse all 92 API endpoints
- Try out API calls directly from the browser
- View request/response schemas
- See all available parameters and filters
- JWT authentication testing

### Alternative Documentation (ReDoc)

For a cleaner, single-page documentation:
```
http://localhost:8000/redoc/
```

### OpenAPI Schema

Download the OpenAPI schema:
- JSON: http://localhost:8000/swagger.json
- YAML: http://localhost:8000/swagger.yaml

## 🔐 Authentication

The API uses JWT (JSON Web Token) authentication.

### 1. Obtain Token

```bash
curl -X POST http://localhost:8000/api/token/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "your_username",
    "password": "your_password"
  }'
```

Response:
```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

### 2. Use Token

Include the access token in all API requests:
```bash
curl -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  http://localhost:8000/api/accounts/agents/
```

### 3. Refresh Token

When the access token expires:
```bash
curl -X POST http://localhost:8000/api/token/refresh/ \
  -H "Content-Type: application/json" \
  -d '{"refresh": "YOUR_REFRESH_TOKEN"}'
```

### Using Swagger UI for Authentication

1. Go to http://localhost:8000/swagger/
2. Click the "Authorize" button (lock icon)
3. Obtain a token from `/api/token/`
4. Enter: `Bearer YOUR_ACCESS_TOKEN`
5. Click "Authorize"
6. Now you can try all endpoints!

## 📊 API Statistics

- **Total Endpoints**: 92 paths
- **Total Operations**: 364 (GET, POST, PUT, PATCH, DELETE)
- **Models**: 45 across 6 apps
- **Database Records**: 3,000+ imported from Laravel

## 🗂️ API Modules

### Accounts (`/api/accounts/`)
- Agents (1,084 records)
- Users (5 records)
- Permissions
- Permission Assigns
- Permission Types

### Core (`/api/core/`)
- Customers (827 records)
- Administrative Settings
- Bank Details
- Branches
- Currencies
- REST API Credentials
- Sectors

### Ticketing (`/api/ticketing/`)
- Flight Itinerary Infos (311 records)
- Flight Booking References
- Flight Itinerary Leg Infos
- Flight Itinerary Person Infos
- Airline Name Codes
- Premium Airlines
- Inoutbounds
- Markup Infos

### Umrah (`/api/umrah/`)
- Umrah Hotels (419 records)
- Umrah Bookings
- Umrah Booking Customers
- Tour Packages
- CMS Visa Packages
- CMS Visa Durations
- Hotel Images
- Tour Images
- And 7 more endpoints...

### Payments (`/api/payments/`)
- Payments
- Markup and Markdowns

### CMS (`/api/cms/`)
- CMS FAQs
- Content Pages
- Parent Pages
- CMS Callback Queries
- Call Recordings
- Followups
- Followup User Logs
- Assign Call Recording Followups

## 💻 Development

### Common Make Commands

```bash
# Build Docker images
make build

# Start all containers
make up

# Stop all containers
make down

# Restart containers
make restart

# View logs
make logs
make logs-web
make logs-db

# Django shell
make shell

# Container bash
make bash

# Run migrations
make migrate
make makemigrations

# Create superuser
make createsuperuser

# Collect static files
make collectstatic

# Run tests
make test

# Clean containers and volumes
make clean
```

### Database Operations

```bash
# Import SQL backup
make db-import

# Create database backup
make db-backup

# Access MySQL shell
make db-shell

# Generate models from database
make inspectdb
```

### Django Management

```bash
# Check Django configuration
docker-compose exec web python manage.py check

# Run migrations
docker-compose exec web python manage.py migrate

# Create superuser
docker-compose exec web python manage.py createsuperuser

# Access Django shell
docker-compose exec web python manage.py shell
```

## 🏗️ Project Structure

```
backen-alrehman/
├── apps/                          # Django apps
│   ├── accounts/                  # User & agent management
│   │   ├── models.py             # 5 models
│   │   ├── serializers.py        # 5 serializers
│   │   ├── views.py              # 5 ViewSets
│   │   ├── admin.py              # Admin config
│   │   └── urls.py               # API routes
│   ├── core/                      # Core functionality (7 models)
│   ├── ticketing/                 # Flight bookings (8 models)
│   ├── umrah/                     # Umrah packages (15 models)
│   ├── payments/                  # Payments (2 models)
│   └── cms/                       # Content management (8 models)
├── config/                        # Django settings
│   ├── settings/
│   │   ├── base.py               # Base settings
│   │   ├── development.py        # Dev settings
│   │   └── production.py         # Prod settings
│   ├── urls.py                   # Main URL config
│   └── wsgi.py                   # WSGI config
├── docker-compose.yml             # Docker services
├── Dockerfile                     # Web container
├── requirements.txt               # Python dependencies
├── Makefile                       # Convenient commands
├── API_DOCUMENTATION.md           # Detailed API docs
└── README.md                      # This file
```

## 🔧 Configuration

### Environment Variables

Key variables in `.env`:

```env
# Django
DEBUG=True
SECRET_KEY=your-secret-key
ALLOWED_HOSTS=localhost,127.0.0.1

# Database
DB_NAME=rehman_travels_laravel
DB_USER=root
DB_PASSWORD=click123
DB_HOST=localhost  # or 'db' in Docker
DB_PORT=3306

# External APIs
EXTERNAL_API_URL=http://exaltedrestapiandrehmantravel.local/api/
AGENT_ID=1182

# Payment Gateways
STRIPE_SECRET_KEY=your-stripe-key
HBL_USER_ID=your-hbl-user-id
HBL_PASSWORD=your-hbl-password

# Redis
REDIS_URL=redis://127.0.0.1:6379/1

# Celery
CELERY_BROKER_URL=redis://127.0.0.1:6379/0
CELERY_RESULT_BACKEND=redis://127.0.0.1:6379/0
```

## 📱 Example API Requests

### List Agents with Pagination

```bash
curl -H "Authorization: Bearer TOKEN" \
  "http://localhost:8000/api/accounts/agents/?page=1"
```

### Search Agents

```bash
curl -H "Authorization: Bearer TOKEN" \
  "http://localhost:8000/api/accounts/agents/?search=john"
```

### Filter and Order

```bash
curl -H "Authorization: Bearer TOKEN" \
  "http://localhost:8000/api/accounts/agents/?ordering=-created_at&id=1"
```

### Create Customer

```bash
curl -X POST \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}' \
  "http://localhost:8000/api/core/customers/"
```

### Get Flight Itinerary

```bash
curl -H "Authorization: Bearer TOKEN" \
  "http://localhost:8000/api/ticketing/flight-itinerary-infos/1/"
```

### Update Agent Status

```bash
curl -X PATCH \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"accountstatus": "active"}' \
  "http://localhost:8000/api/accounts/agents/1/"
```

## 🎯 Key Features

### API Features
- ✅ RESTful API design
- ✅ JWT authentication
- ✅ Pagination (25 items/page)
- ✅ Search functionality
- ✅ Filtering by fields
- ✅ Ordering/sorting
- ✅ CORS enabled
- ✅ OpenAPI/Swagger documentation
- ✅ Interactive API testing

### Admin Features
- ✅ Django Admin interface
- ✅ All 45 models registered
- ✅ Search and filters
- ✅ Date hierarchy
- ✅ Custom list displays
- ✅ Inline editing

### Infrastructure
- ✅ Docker containerization
- ✅ MySQL 8.0 database
- ✅ Redis caching
- ✅ Celery task queue
- ✅ Celery beat scheduler
- ✅ Health checks
- ✅ Volume persistence

## 🧪 Testing

### Manual Testing via Swagger

1. Open http://localhost:8000/swagger/
2. Click "Authorize" and add your JWT token
3. Navigate to any endpoint
4. Click "Try it out"
5. Fill in parameters
6. Click "Execute"
7. View the response

### cURL Testing

See examples above or refer to `API_DOCUMENTATION.md`

## 🔄 Migration from Laravel

This Django backend maintains full compatibility with the existing Laravel database:

- ✅ All 60 Laravel tables mapped
- ✅ 45 models organized into Django apps
- ✅ 3,000+ records migrated
- ✅ Foreign key relationships preserved
- ✅ Data integrity maintained
- ✅ Original table names retained
- ✅ Column names preserved

## 📖 Additional Documentation

- **API Documentation**: See `API_DOCUMENTATION.md`
- **Database Migration**: See `DATABASE_MIGRATION_GUIDE.md`
- **Migration Plan**: See `.claude/plans/dapper-launching-hopper.md`
- **Docker Guide**: See `README_DOCKER.md`

## 🐛 Troubleshooting

### Container Issues

```bash
# Check container status
docker-compose ps

# View logs
docker-compose logs web

# Restart containers
docker-compose restart

# Rebuild containers
docker-compose down && docker-compose build && docker-compose up -d
```

### Database Issues

```bash
# Check database connection
docker-compose exec web python manage.py check --database default

# Access MySQL
make db-shell

# Re-import database
make db-import
```

### Swagger Not Loading

```bash
# Collect static files
docker-compose exec web python manage.py collectstatic --noinput

# Restart web container
docker-compose restart web
```

## 📞 Support

For issues or questions:
- Check the Swagger documentation at http://localhost:8000/swagger/
- Review API_DOCUMENTATION.md
- Check container logs: `docker-compose logs web`

## 📝 License

Proprietary - Rehman Travels

---

**Last Updated**: January 2024
**Django Version**: 4.2.8
**DRF Version**: 3.14.0
**Python Version**: 3.11
