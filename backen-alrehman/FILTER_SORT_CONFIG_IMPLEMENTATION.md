# Filter & Sort Configuration Implementation

## Overview
A dynamic filter and sort configuration system for managing listing filters and sorting logic (flights, hotels, etc.) via Django backend and Admin CMS. Frontend apps (Flutter) can fetch these configs via API and apply them dynamically.

## Backend Implementation

### 1. Database Model
**File**: `apps/core/models.py`

```python
class FilterSortConfig(LegacyModel):
    """
    Dynamic filter and sort configuration for listings
    """
    id = models.BigAutoField(primary_key=True)
    listing_name = models.CharField(max_length=50, unique=True, choices=[...])
    config_data = models.JSONField()
    is_active = models.BooleanField(default=True)
    version = models.CharField(max_length=20, default="1.0")
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)
    created_by = models.CharField(max_length=100, blank=True, null=True)
```

**Database**: `filter_sort_configs` table in PostgreSQL (default database)

### 2. API Endpoints

#### Public Endpoints (No Authentication)

**Option 1**: Simple endpoint
```
GET /api/core/filter-config/{listing_name}/

Example: GET /api/core/filter-config/flights/
```

**Option 2**: ViewSet action
```
GET /api/core/filter-sort-configs/by-listing/{listing_name}/

Example: GET /api/core/filter-sort-configs/by-listing/flights/
```

**Response Format**:
```json
{
  "listing_name": "flights",
  "config_data": { ... },
  "version": "1.0"
}
```

#### Admin Endpoints (Authentication Required)

```
GET    /api/core/filter-sort-configs/         # List all configs
POST   /api/core/filter-sort-configs/         # Create config
GET    /api/core/filter-sort-configs/{id}/    # Retrieve config
PUT    /api/core/filter-sort-configs/{id}/    # Update config
DELETE /api/core/filter-sort-configs/{id}/    # Delete config
```

### 3. Admin Interface

Access via Django Admin: `/admin/core/filtersortconfig/`

Features:
- List view with status badges (Active/Inactive)
- Search by listing name, description, version
- Filter by listing type, active status, creation date
- JSON editor for config_data
- Auto-populated created_by field

### 4. Management Command

**Seed sample data**:
```bash
python manage.py seed_filter_configs
```

This creates sample configurations for flights and hotels.

## Configuration Schema

### Flight Configuration Example

```json
{
  "calculation_config": {
    "factors": {
      "price": {
        "weight": 0.40,
        "formula": "RATIO_INVERSE",
        "description": "Lower price = higher score"
      },
      "duration": {
        "weight": 0.30,
        "formula": "RATIO_INVERSE"
      },
      "stops": {
        "weight": 0.20,
        "formula": "LOOKUP",
        "lookup_table": {
          "0": 100,
          "1": 70,
          "2": 40,
          "3+": 10
        }
      },
      "layover_quality": {
        "weight": 0.05,
        "formula": "CUSTOM"
      },
      "timing": {
        "weight": 0.03,
        "formula": "CUSTOM"
      },
      "airline_rating": {
        "weight": 0.02,
        "formula": "DIRECT"
      }
    },
    "ranking_rules": {
      "best_rank": {
        "sort_by": "best_score",
        "order": "DESC"
      },
      "cheapest_rank": {
        "sort_by": "price",
        "order": "ASC"
      },
      "fastest_rank": {
        "sort_by": "duration_minutes",
        "order": "ASC"
      }
    },
    "tag_rules": [
      {
        "tag": "BEST",
        "condition": "best_rank == 1",
        "badge_color": "#28a745",
        "icon": "star"
      },
      {
        "tag": "CHEAPEST",
        "condition": "cheapest_rank == 1",
        "badge_color": "#007bff",
        "icon": "dollar"
      },
      {
        "tag": "FASTEST",
        "condition": "fastest_rank == 1",
        "badge_color": "#ffc107",
        "icon": "bolt"
      }
    ],
    "filters": {
      "stops": {
        "type": "checkbox",
        "label": "Stops",
        "options": [
          {"value": "0", "label": "Direct"},
          {"value": "1", "label": "1 Stop"},
          {"value": "2+", "label": "2+ Stops"}
        ]
      },
      "airlines": {
        "type": "multi-select",
        "label": "Airlines",
        "dynamic": true
      },
      "departure_time": {
        "type": "range",
        "label": "Departure Time",
        "ranges": [
          {
            "value": "morning",
            "label": "Morning (6AM-12PM)",
            "start": "06:00",
            "end": "12:00"
          }
        ]
      },
      "price_range": {
        "type": "slider",
        "label": "Price Range",
        "min_field": "price_min",
        "max_field": "price_max",
        "currency": "PKR"
      }
    },
    "round_to_decimals": 2
  }
}
```

## Frontend Integration Plan (Flutter)

### High-Level Architecture

1. **Config Fetching Service**
   - Fetch filter/sort configs from API on listing page load
   - Cache configs locally
   - Handle version updates

2. **Dynamic Filter Builder**
   - Parse JSON config
   - Build UI components dynamically based on filter types:
     - Checkbox filters (stops, amenities)
     - Multi-select filters (airlines)
     - Range filters (departure time)
     - Slider filters (price range)

3. **Score Calculator**
   - Implement scoring algorithm based on backend config
   - Calculate weighted scores for each flight/hotel
   - Apply formulas:
     - `RATIO_INVERSE`: score = (min_value / this_value) × 100
     - `DIRECT`: score = value itself
     - `LOOKUP`: score from lookup table
     - `CUSTOM`: custom logic implemented in Flutter

4. **Sort/Filter State Manager**
   - Manage active filters and sorting preferences
   - Apply filters to results
   - Sort by selected criteria (best, cheapest, fastest)

5. **Tag Display**
   - Show badges (BEST, CHEAPEST, FASTEST) on flight/hotel cards
   - Use badge colors and icons from config

### Key Components (To Be Implemented in Flutter)

```dart
// 1. FilterConfigService
class FilterConfigService {
  Future<FilterSortConfig> getConfig(String listingName);
  void cacheConfig(FilterSortConfig config);
}

// 2. DynamicFilterWidget
class DynamicFilterWidget extends StatelessWidget {
  final Map<String, dynamic> filterConfig;
  final Function(Map<String, dynamic>) onFilterChange;
}

// 3. FlightScoringEngine
class FlightScoringEngine {
  double calculateBestScore(Flight flight, Map<String, dynamic> factors);
  List<Flight> rankFlights(List<Flight> flights, String rankingType);
}

// 4. SortingController
class SortingController {
  void applySort(String sortType); // 'best', 'cheapest', 'fastest'
  List<String> getActiveTags(Flight flight);
}
```

### API Integration Example

```dart
// Fetch config on page load
final config = await FilterConfigService().getConfig('flights');

// Build dynamic filters
final filters = DynamicFilterBuilder.buildFromConfig(
  config.configData['calculation_config']['filters']
);

// Calculate scores
final scoringEngine = FlightScoringEngine(
  factors: config.configData['calculation_config']['factors']
);

for (var flight in flights) {
  flight.bestScore = scoringEngine.calculateBestScore(flight);
  flight.tags = TagCalculator.getTags(flight, config.tagRules);
}

// Sort and display
flights.sort((a, b) => b.bestScore.compareTo(a.bestScore));
```

## Testing

### Test API Endpoints

```bash
# Test flights config
curl http://localhost:8000/api/core/filter-config/flights/ | jq

# Test hotels config
curl http://localhost:8000/api/core/filter-sort-configs/by-listing/hotels/ | jq

# Test admin endpoints (requires authentication)
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8000/api/core/filter-sort-configs/
```

### Verify Data

```bash
# Via Django shell
python manage.py shell
>>> from apps.core.models import FilterSortConfig
>>> FilterSortConfig.objects.all()
>>> config = FilterSortConfig.objects.get(listing_name='flights')
>>> print(config.config_data)
```

## Files Modified/Created

### Backend
1. `apps/core/models.py` - Added FilterSortConfig model
2. `apps/core/serializers.py` - Added serializers
3. `apps/core/views.py` - Added viewsets and API views
4. `apps/core/urls.py` - Added URL routes
5. `apps/core/admin.py` - Added admin interface
6. `apps/core/management/commands/seed_filter_configs.py` - Seed command
7. `apps/core/migrations/0002_filtersortconfig.py` - Database migration

### Documentation
1. `sample_flight_config.json` - Sample configuration
2. `create_sample_configs.py` - Sample data script
3. `FILTER_SORT_CONFIG_IMPLEMENTATION.md` - This document

## Database Schema

**PostgreSQL Schema** (managed by Django migrations):

```sql
CREATE TABLE filter_sort_configs (
  id SERIAL PRIMARY KEY,
  listing_name VARCHAR(50) UNIQUE NOT NULL,
  config_data JSONB NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  version VARCHAR(20) DEFAULT '1.0',
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by VARCHAR(100)
);
```

**Note**: This table is in the **default PostgreSQL database**, not the legacy MySQL database. Django manages the schema via migrations.

## Next Steps

### Backend (Completed ✓)
- [x] Django model created
- [x] API endpoints implemented
- [x] Admin interface configured
- [x] Sample data seeded
- [x] Documentation created

### Frontend (Pending - Flutter Implementation)
- [ ] Create FilterConfigService
- [ ] Implement Dynamic Filter Builder UI
- [ ] Implement Scoring Engine
- [ ] Create SortingController
- [ ] Add Tag/Badge Display
- [ ] Write unit tests
- [ ] Integration testing

### React CMS (If needed)
- Admin interface is already available via Django Admin
- Can be enhanced with custom React UI if needed

## Support

For issues or questions:
- Check Django logs: `docker logs rehman_travels_web`
- Test API endpoints using curl/Postman
- Verify data in Django admin
- Check migration status: `python manage.py showmigrations core`
