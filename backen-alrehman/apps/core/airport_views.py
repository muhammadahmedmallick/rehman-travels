"""
Airport Search API View
Public endpoint matching Laravel's AirportController functionality
"""
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.db.models import Case, When, Value, IntegerField, Q
from apps.core.models import Sectors


class AirportSearchViewSet(viewsets.ViewSet):
    """
    Public API for Airport/Sector Search

    Matches Laravel's AirportController with relevance-based ranking

    Endpoint:
    - GET /api/core/airports/search/?query=ISB - Search airports with relevance ranking
    """
    permission_classes = [AllowAny]

    def list(self, request):
        """
        Search airports/sectors with relevance-based ranking

        Query Parameters:
        - query (required): Search term (e.g., "ISB", "Islamabad", "Pakistan")

        Returns top 10 results ordered by relevance:
        1. Exact match on code (highest priority)
        2. Partial match on code
        3. Partial match on city (airport name)
        4. Partial match on country

        Example:
        GET /api/core/airports/search/?query=ISB

        Response:
        [
            {
                "id": 123,
                "code": "ISB",
                "city": "Islamabad",
                "country": "Pakistan",
                "sectorType": "Int",
                "allowType": "",
                "relevance": 1
            }
        ]
        """
        search_query = request.query_params.get('query', '').strip()

        if not search_query:
            return Response(
                {'error': 'Query parameter is required'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Build relevance-based query matching Laravel's logic
        results = Sectors.objects.annotate(
            relevance=Case(
                # Priority 1: Exact match on code (case-insensitive)
                When(code__iexact=search_query, then=Value(1)),
                # Priority 2: Partial match on code (starts with or contains)
                When(code__icontains=search_query, then=Value(2)),
                # Priority 3: Partial match on city/airport name
                When(city__icontains=search_query, then=Value(3)),
                # Priority 4: Partial match on country
                When(country__icontains=search_query, then=Value(4)),
                # Default: Other matches
                default=Value(6),
                output_field=IntegerField()
            )
        ).filter(
            Q(code__icontains=search_query) |
            Q(city__icontains=search_query) |
            Q(country__icontains=search_query)
        ).order_by('relevance').values(
            'id',
            'code',
            'city',
            'country',
            'sectortype',
            'allowtype',
            'relevance'
        )[:10]

        # Convert to list and format response to match Laravel output
        # Note: The live Laravel API returns 'airport' field which contains airport name
        # In our database, 'city' contains the airport name (e.g., "Jinnah Intl Airport")
        response_data = []
        for item in results:
            response_data.append({
                'id': item['id'],
                'code': item['code'],
                'airport': item['city'],  # Map city to airport for compatibility
                'city': item['city'],     # Keep city as well
                'country': item['country'],
                'sectorType': item['sectortype'],
                'allowType': item['allowtype'],
                'relevance': item['relevance']
            })

        return Response(response_data)
