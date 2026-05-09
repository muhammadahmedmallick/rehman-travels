"""
Management command to seed FilterSortConfig data
Usage: python manage.py seed_filter_configs
"""
import json
from django.core.management.base import BaseCommand
from django.db import connection
from apps.core.models import FilterSortConfig


class Command(BaseCommand):
    help = 'Creates sample FilterSortConfig entries for flights and hotels'

    def handle(self, *args, **kwargs):
        # Note: Table is created via Django migrations in PostgreSQL (default database)
        # No manual table creation needed

        # Flight config
        flight_config = {
            "calculation_config": {
                "factors": {
                    "price": {
                        "weight": 0.40,
                        "formula": "RATIO_INVERSE",
                        "description": "Lower price = higher score"
                    },
                    "duration": {
                        "weight": 0.30,
                        "formula": "RATIO_INVERSE",
                        "description": "Shorter duration = higher score"
                    },
                    "stops": {
                        "weight": 0.20,
                        "formula": "LOOKUP",
                        "lookup_table": {
                            "0": 100,
                            "1": 70,
                            "2": 40,
                            "3+": 10
                        },
                        "description": "Direct flights preferred"
                    },
                    "layover_quality": {
                        "weight": 0.05,
                        "formula": "CUSTOM",
                        "description": "1-2 hour layover ideal, overnight penalty"
                    },
                    "timing": {
                        "weight": 0.03,
                        "formula": "CUSTOM",
                        "description": "6AM-10PM good, red-eye penalty"
                    },
                    "airline_rating": {
                        "weight": 0.02,
                        "formula": "DIRECT",
                        "description": "Airline reputation score"
                    }
                },
                "ranking_rules": {
                    "best_rank": {
                        "sort_by": "best_score",
                        "order": "DESC",
                        "description": "Overall best value"
                    },
                    "cheapest_rank": {
                        "sort_by": "price",
                        "order": "ASC",
                        "description": "Lowest price first"
                    },
                    "fastest_rank": {
                        "sort_by": "duration_minutes",
                        "order": "ASC",
                        "description": "Shortest duration first"
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
                        "dynamic": True
                    },
                    "departure_time": {
                        "type": "range",
                        "label": "Departure Time",
                        "ranges": [
                            {"value": "morning", "label": "Morning (6AM-12PM)", "start": "06:00", "end": "12:00"},
                            {"value": "afternoon", "label": "Afternoon (12PM-6PM)", "start": "12:00", "end": "18:00"},
                            {"value": "evening", "label": "Evening (6PM-12AM)", "start": "18:00", "end": "23:59"},
                            {"value": "night", "label": "Night (12AM-6AM)", "start": "00:00", "end": "06:00"}
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

        # Create or update flights config (using default PostgreSQL DB)
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
        self.stdout.write(self.style.SUCCESS(f'{action} FilterSortConfig for "flights" - ID: {flights_obj.id}'))

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
        self.stdout.write(self.style.SUCCESS(f'{action} FilterSortConfig for "hotels" - ID: {hotels_obj.id}'))

        self.stdout.write(self.style.SUCCESS('\nAll configs created successfully!'))
        self.stdout.write('\nTest the API:')
        self.stdout.write('  GET http://localhost:8000/api/core/filter-config/flights/')
        self.stdout.write('  GET http://localhost:8000/api/core/filter-config/hotels/')
        self.stdout.write('  GET http://localhost:8000/api/core/filter-sort-configs/by-listing/flights/')
