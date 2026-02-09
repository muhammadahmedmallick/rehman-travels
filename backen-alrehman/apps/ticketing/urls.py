"""
Ticketing URL Configuration
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from apps.ticketing.views import (
    AirlineNameCodesViewSet,
    FlightBookingReferencesViewSet,
    FlightItineraryInfosViewSet,
    FlightItineraryLegInfosViewSet,
    FlightItineraryPersonInfosViewSet,
    FlightItineraryrefMarkupInfosViewSet,
    InoutboundsViewSet,
    PremiumAirlinesViewSet
)

router = DefaultRouter()
router.register(r'airline-name-codes', AirlineNameCodesViewSet, basename='airline-name-codes')
router.register(r'flight-booking-references', FlightBookingReferencesViewSet, basename='flight-booking-references')
router.register(r'flight-itinerary-infos', FlightItineraryInfosViewSet, basename='flight-itinerary-infos')
router.register(r'flight-itinerary-leg-infos', FlightItineraryLegInfosViewSet, basename='flight-itinerary-leg-infos')
router.register(r'flight-itinerary-person-infos', FlightItineraryPersonInfosViewSet, basename='flight-itinerary-person-infos')
router.register(r'flight-itineraryref-markup-infos', FlightItineraryrefMarkupInfosViewSet, basename='flight-itineraryref-markup-infos')
router.register(r'inoutbounds', InoutboundsViewSet, basename='inoutbounds')
router.register(r'premium-airlines', PremiumAirlinesViewSet, basename='premium-airlines')

urlpatterns = [
    path('', include(router.urls)),
]
