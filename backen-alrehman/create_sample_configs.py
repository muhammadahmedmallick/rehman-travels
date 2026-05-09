"""
Script to create sample FilterSortConfig entries
Run with: python manage.py shell < create_sample_configs.py
"""
import json
from apps.core.models import FilterSortConfig

# Flight config
with open('sample_flight_config.json', 'r') as f:
    flight_config = json.load(f)

# Create or update flights config
flights_obj, created = FilterSortConfig.objects.update_or_create(
    listing_name='flights',
    defaults={
        'config_data': flight_config,
        'version': '1.0',
        'is_active': True,
        'description': 'Flight listing filter and sort configuration with Best/Cheapest/Fastest scoring',
        'created_by': 'system'
    }
)

action = "Created" if created else "Updated"
print(f"{action} FilterSortConfig for 'flights' - ID: {flights_obj.id}")

# Hotels config (simplified example)
hotels_config = {
    "calculation_config": {
        "factors": {
            "price": {"weight": 0.50, "formula": "RATIO_INVERSE"},
            "rating": {"weight": 0.30, "formula": "DIRECT"},
            "distance_to_center": {"weight": 0.20, "formula": "RATIO_INVERSE"}
        },
        "ranking_rules": {
            "best_rank": {"sort_by": "best_score", "order": "DESC"},
            "cheapest_rank": {"sort_by": "price", "order": "ASC"},
            "highest_rated": {"sort_by": "rating", "order": "DESC"}
        },
        "tag_rules": [
            {"tag": "BEST", "condition": "best_rank == 1", "badge_color": "#28a745"},
            {"tag": "CHEAPEST", "condition": "cheapest_rank == 1", "badge_color": "#007bff"}
        ],
        "filters": {
            "star_rating": {
                "type": "checkbox",
                "label": "Star Rating",
                "options": [
                    {"value": "5", "label": "5 Star"},
                    {"value": "4", "label": "4 Star"},
                    {"value": "3", "label": "3 Star"}
                ]
            },
            "amenities": {
                "type": "multi-select",
                "label": "Amenities",
                "options": [
                    {"value": "wifi", "label": "Free WiFi"},
                    {"value": "pool", "label": "Swimming Pool"},
                    {"value": "breakfast", "label": "Breakfast Included"}
                ]
            }
        }
    }
}

hotels_obj, created = FilterSortConfig.objects.update_or_create(
    listing_name='hotels',
    defaults={
        'config_data': hotels_config,
        'version': '1.0',
        'is_active': True,
        'description': 'Hotel listing configuration',
        'created_by': 'system'
    }
)

action = "Created" if created else "Updated"
print(f"{action} FilterSortConfig for 'hotels' - ID: {hotels_obj.id}")

print("\nAll configs created successfully!")
print("\nTest the API:")
print("  GET /api/core/filter-config/flights/")
print("  GET /api/core/filter-config/hotels/")
print("  GET /api/core/filter-sort-configs/by-listing/flights/")
