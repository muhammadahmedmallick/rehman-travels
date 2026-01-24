# Rehman Travels Django API Documentation

## Base URL
```
http://localhost:8000/api/
```

## Authentication

The API uses JWT (JSON Web Token) authentication.

### Obtain Token
```bash
POST /api/token/
Content-Type: application/json

{
    "username": "your_username",
    "password": "your_password"
}
```

Response:
```json
{
    "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

### Refresh Token
```bash
POST /api/token/refresh/
Content-Type: application/json

{
    "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

### Using the Token
Include the access token in the Authorization header:
```bash
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...
```

## API Endpoints

### Accounts Module
Base: `/api/accounts/`

#### Agents
- `GET /api/accounts/agents/` - List all agents (1,084 records)
- `POST /api/accounts/agents/` - Create new agent
- `GET /api/accounts/agents/{id}/` - Get agent details
- `PUT /api/accounts/agents/{id}/` - Update agent
- `PATCH /api/accounts/agents/{id}/` - Partial update agent
- `DELETE /api/accounts/agents/{id}/` - Delete agent

Query Parameters:
- `search` - Search by email, username
- `ordering` - Sort by id, created_at
- `id` - Filter by ID

#### Users
- `GET /api/accounts/users/` - List all users (5 records)
- `POST /api/accounts/users/` - Create new user
- `GET /api/accounts/users/{id}/` - Get user details
- `PUT /api/accounts/users/{id}/` - Update user
- `PATCH /api/accounts/users/{id}/` - Partial update user
- `DELETE /api/accounts/users/{id}/` - Delete user

#### Permissions
- `GET /api/accounts/permissions/` - List all permissions
- `POST /api/accounts/permissions/` - Create permission
- `GET /api/accounts/permissions/{id}/` - Get permission details
- `PUT /api/accounts/permissions/{id}/` - Update permission
- `DELETE /api/accounts/permissions/{id}/` - Delete permission

#### Permission Assigns
- `GET /api/accounts/permission-assigns/` - List permission assignments
- `POST /api/accounts/permission-assigns/` - Assign permission
- `GET /api/accounts/permission-assigns/{id}/` - Get assignment details
- `DELETE /api/accounts/permission-assigns/{id}/` - Remove assignment

#### Permission Types
- `GET /api/accounts/permission-types/` - List permission types
- `POST /api/accounts/permission-types/` - Create permission type
- `GET /api/accounts/permission-types/{id}/` - Get type details
- `PUT /api/accounts/permission-types/{id}/` - Update type
- `DELETE /api/accounts/permission-types/{id}/` - Delete type

---

### Core Module
Base: `/api/core/`

#### Administrative Settings
- `GET /api/core/administrative-settings/` - List settings
- `POST /api/core/administrative-settings/` - Create setting
- `GET /api/core/administrative-settings/{id}/` - Get setting
- `PUT /api/core/administrative-settings/{id}/` - Update setting

#### Bank Details
- `GET /api/core/bank-details/` - List bank details
- `POST /api/core/bank-details/` - Create bank detail
- `GET /api/core/bank-details/{id}/` - Get details
- `PUT /api/core/bank-details/{id}/` - Update details

#### Branches
- `GET /api/core/branches/` - List branches
- `POST /api/core/branches/` - Create branch
- `GET /api/core/branches/{id}/` - Get branch
- `PUT /api/core/branches/{id}/` - Update branch

#### Currencies
- `GET /api/core/currencies/` - List currencies
- `POST /api/core/currencies/` - Create currency
- `GET /api/core/currencies/{id}/` - Get currency
- `PUT /api/core/currencies/{id}/` - Update currency

#### Customers
- `GET /api/core/customers/` - List customers (827 records)
- `POST /api/core/customers/` - Create customer
- `GET /api/core/customers/{id}/` - Get customer
- `PUT /api/core/customers/{id}/` - Update customer
- `DELETE /api/core/customers/{id}/` - Delete customer

#### REST API Credentials
- `GET /api/core/rest-api-credentials/` - List API credentials
- `POST /api/core/rest-api-credentials/` - Create credentials
- `GET /api/core/rest-api-credentials/{id}/` - Get credentials
- `PUT /api/core/rest-api-credentials/{id}/` - Update credentials

#### Sectors
- `GET /api/core/sectors/` - List flight sectors
- `POST /api/core/sectors/` - Create sector
- `GET /api/core/sectors/{id}/` - Get sector
- `PUT /api/core/sectors/{id}/` - Update sector

---

### Ticketing Module
Base: `/api/ticketing/`

#### Airline Name Codes
- `GET /api/ticketing/airline-name-codes/` - List airlines
- `POST /api/ticketing/airline-name-codes/` - Create airline
- `GET /api/ticketing/airline-name-codes/{id}/` - Get airline

#### Flight Booking References
- `GET /api/ticketing/flight-booking-references/` - List bookings
- `POST /api/ticketing/flight-booking-references/` - Create booking
- `GET /api/ticketing/flight-booking-references/{id}/` - Get booking

#### Flight Itinerary Infos
- `GET /api/ticketing/flight-itinerary-infos/` - List itineraries (311 records)
- `POST /api/ticketing/flight-itinerary-infos/` - Create itinerary
- `GET /api/ticketing/flight-itinerary-infos/{id}/` - Get itinerary
- `PUT /api/ticketing/flight-itinerary-infos/{id}/` - Update itinerary

#### Flight Itinerary Leg Infos
- `GET /api/ticketing/flight-itinerary-leg-infos/` - List flight legs
- `POST /api/ticketing/flight-itinerary-leg-infos/` - Create leg
- `GET /api/ticketing/flight-itinerary-leg-infos/{id}/` - Get leg

#### Flight Itinerary Person Infos
- `GET /api/ticketing/flight-itinerary-person-infos/` - List passengers
- `POST /api/ticketing/flight-itinerary-person-infos/` - Create passenger
- `GET /api/ticketing/flight-itinerary-person-infos/{id}/` - Get passenger

#### Flight Itineraryref Markup Infos
- `GET /api/ticketing/flight-itineraryref-markup-infos/` - List markup info
- `POST /api/ticketing/flight-itineraryref-markup-infos/` - Create markup
- `GET /api/ticketing/flight-itineraryref-markup-infos/{id}/` - Get markup

#### Inoutbounds
- `GET /api/ticketing/inoutbounds/` - List inoutbounds
- `POST /api/ticketing/inoutbounds/` - Create inoutbound
- `GET /api/ticketing/inoutbounds/{id}/` - Get inoutbound

#### Premium Airlines
- `GET /api/ticketing/premium-airlines/` - List premium airlines
- `POST /api/ticketing/premium-airlines/` - Create premium airline
- `GET /api/ticketing/premium-airlines/{id}/` - Get premium airline

---

### Umrah Module
Base: `/api/umrah/`

#### CMS Visa Durations
- `GET /api/umrah/cms-visa-durations/` - List visa durations
- `POST /api/umrah/cms-visa-durations/` - Create duration
- `GET /api/umrah/cms-visa-durations/{id}/` - Get duration

#### CMS Visa Packages
- `GET /api/umrah/cms-visa-packages/` - List visa packages
- `POST /api/umrah/cms-visa-packages/` - Create package
- `GET /api/umrah/cms-visa-packages/{id}/` - Get package

#### Tour Images
- `GET /api/umrah/tour-images/` - List tour images
- `POST /api/umrah/tour-images/` - Upload image
- `GET /api/umrah/tour-images/{id}/` - Get image

#### Tour Packages
- `GET /api/umrah/tour-packages/` - List tour packages
- `POST /api/umrah/tour-packages/` - Create package
- `GET /api/umrah/tour-packages/{id}/` - Get package

#### Umrah Booking Customers
- `GET /api/umrah/umrah-booking-customers/` - List bookings
- `POST /api/umrah/umrah-booking-customers/` - Create booking
- `GET /api/umrah/umrah-booking-customers/{id}/` - Get booking

#### Umrah Booking Hotel Room
- `GET /api/umrah/umrah-booking-hotel-room/` - List hotel bookings
- `POST /api/umrah/umrah-booking-hotel-room/` - Create booking
- `GET /api/umrah/umrah-booking-hotel-room/{id}/` - Get booking

#### Umrah Bookings
- `GET /api/umrah/umrah-bookings/` - List all bookings
- `POST /api/umrah/umrah-bookings/` - Create booking
- `GET /api/umrah/umrah-bookings/{id}/` - Get booking

#### Umrah Hotel Images
- `GET /api/umrah/umrah-hotel-images/` - List hotel images
- `POST /api/umrah/umrah-hotel-images/` - Upload image
- `GET /api/umrah/umrah-hotel-images/{id}/` - Get image

#### Umrah Hotel Room Periods
- `GET /api/umrah/umrah-hotel-room-periods/` - List room periods
- `POST /api/umrah/umrah-hotel-room-periods/` - Create period
- `GET /api/umrah/umrah-hotel-room-periods/{id}/` - Get period

#### Umrah Hotel Room Prices
- `GET /api/umrah/umrah-hotel-room-prices/` - List room prices
- `POST /api/umrah/umrah-hotel-room-prices/` - Create price
- `GET /api/umrah/umrah-hotel-room-prices/{id}/` - Get price

#### Umrah Hotels
- `GET /api/umrah/umrah-hotels/` - List hotels (419 records)
- `POST /api/umrah/umrah-hotels/` - Create hotel
- `GET /api/umrah/umrah-hotels/{id}/` - Get hotel
- `PUT /api/umrah/umrah-hotels/{id}/` - Update hotel

#### Umrah Transport Sectors
- `GET /api/umrah/umrah-transport-sectors/` - List transport sectors
- `POST /api/umrah/umrah-transport-sectors/` - Create sector
- `GET /api/umrah/umrah-transport-sectors/{id}/` - Get sector

#### Umrah Vehicle Prices
- `GET /api/umrah/umrah-vehicle-prices/` - List vehicle prices
- `POST /api/umrah/umrah-vehicle-prices/` - Create price
- `GET /api/umrah/umrah-vehicle-prices/{id}/` - Get price

#### Umrah Vehicles
- `GET /api/umrah/umrah-vehicles/` - List vehicles
- `POST /api/umrah/umrah-vehicles/` - Create vehicle
- `GET /api/umrah/umrah-vehicles/{id}/` - Get vehicle

#### Umrah Visas
- `GET /api/umrah/umrah-visas/` - List visas
- `POST /api/umrah/umrah-visas/` - Create visa
- `GET /api/umrah/umrah-visas/{id}/` - Get visa

---

### Payments Module
Base: `/api/payments/`

#### Payments
- `GET /api/payments/payments/` - List payments
- `POST /api/payments/payments/` - Create payment
- `GET /api/payments/payments/{id}/` - Get payment
- `PUT /api/payments/payments/{id}/` - Update payment

#### Markup and Markdowns
- `GET /api/payments/markup-and-markdowns/` - List markups
- `POST /api/payments/markup-and-markdowns/` - Create markup
- `GET /api/payments/markup-and-markdowns/{id}/` - Get markup
- `PUT /api/payments/markup-and-markdowns/{id}/` - Update markup

---

### CMS Module
Base: `/api/cms/`

#### Assign Call Recording Followups
- `GET /api/cms/assign-call-recording-followups/` - List assignments
- `POST /api/cms/assign-call-recording-followups/` - Create assignment
- `GET /api/cms/assign-call-recording-followups/{id}/` - Get assignment

#### Call Recordings
- `GET /api/cms/call-recordings/` - List recordings
- `POST /api/cms/call-recordings/` - Create recording
- `GET /api/cms/call-recordings/{id}/` - Get recording

#### CMS Callback Queries
- `GET /api/cms/cms-callback-queries/` - List queries
- `POST /api/cms/cms-callback-queries/` - Create query
- `GET /api/cms/cms-callback-queries/{id}/` - Get query

#### CMS FAQs
- `GET /api/cms/cms-faqs/` - List FAQs
- `POST /api/cms/cms-faqs/` - Create FAQ
- `GET /api/cms/cms-faqs/{id}/` - Get FAQ
- `PUT /api/cms/cms-faqs/{id}/` - Update FAQ

#### Content Pages
- `GET /api/cms/content-pages/` - List pages
- `POST /api/cms/content-pages/` - Create page
- `GET /api/cms/content-pages/{id}/` - Get page
- `PUT /api/cms/content-pages/{id}/` - Update page

#### Parent Pages
- `GET /api/cms/parent-pages/` - List parent pages
- `POST /api/cms/parent-pages/` - Create parent page
- `GET /api/cms/parent-pages/{id}/` - Get parent page

#### Followup User Logs
- `GET /api/cms/followup-user-logs/` - List logs
- `POST /api/cms/followup-user-logs/` - Create log
- `GET /api/cms/followup-user-logs/{id}/` - Get log

#### Followups
- `GET /api/cms/followups/` - List followups
- `POST /api/cms/followups/` - Create followup
- `GET /api/cms/followups/{id}/` - Get followup
- `PUT /api/cms/followups/{id}/` - Update followup

---

## Example Requests

### List Agents with Filtering
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  "http://localhost:8000/api/accounts/agents/?search=john&ordering=-created_at"
```

### Get Single Agent
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  "http://localhost:8000/api/accounts/agents/1/"
```

### Create New Customer
```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}' \
  "http://localhost:8000/api/core/customers/"
```

### Update Agent
```bash
curl -X PATCH \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"accountstatus": "active"}' \
  "http://localhost:8000/api/accounts/agents/1/"
```

---

## Response Format

### Success Response (List)
```json
{
    "count": 1084,
    "next": "http://localhost:8000/api/accounts/agents/?page=2",
    "previous": null,
    "results": [
        {
            "id": 1,
            "username": "agent1",
            "email": "agent1@example.com",
            "companyname": "Company Name",
            "accountstatus": "active",
            "created_at": "2024-01-01T00:00:00Z",
            ...
        }
    ]
}
```

### Success Response (Detail)
```json
{
    "id": 1,
    "username": "agent1",
    "email": "agent1@example.com",
    "companyname": "Company Name",
    "accountstatus": "active",
    "created_at": "2024-01-01T00:00:00Z",
    ...
}
```

### Error Response
```json
{
    "detail": "Not found."
}
```

---

## Admin Panel

Django Admin is available at:
```
http://localhost:8000/admin/
```

Default credentials (if created):
- Username: admin
- Password: admin123

---

## Notes

- All endpoints support pagination (25 items per page by default)
- Use `?page=2` to navigate pages
- All timestamps are in ISO 8601 format
- Authentication is required for all API endpoints
- CORS is enabled for cross-origin requests
