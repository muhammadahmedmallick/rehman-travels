"""
Ticketing serializers
"""
from rest_framework import serializers
from apps.ticketing.models import (
    AirlineNameCodes,
    FlightBookingReferences,
    FlightItineraryInfos,
    FlightItineraryLegInfos,
    FlightItineraryPersonInfos,
    FlightItineraryrefMarkupInfos,
    Inoutbounds,
    PremiumAirlines
)


class AirlineNameCodesSerializer(serializers.ModelSerializer):
    """
    Serializer for AirlineNameCodes model
    """
    class Meta:
        model = AirlineNameCodes
        fields = '__all__'


class FlightBookingReferencesSerializer(serializers.ModelSerializer):
    """
    Serializer for FlightBookingReferences model
    """
    class Meta:
        model = FlightBookingReferences
        fields = '__all__'


class FlightItineraryInfosSerializer(serializers.ModelSerializer):
    """
    Serializer for FlightItineraryInfos model
    """
    class Meta:
        model = FlightItineraryInfos
        fields = '__all__'


class FlightItineraryLegInfosSerializer(serializers.ModelSerializer):
    """
    Serializer for FlightItineraryLegInfos model
    """
    class Meta:
        model = FlightItineraryLegInfos
        fields = '__all__'


class FlightItineraryPersonInfosSerializer(serializers.ModelSerializer):
    """
    Serializer for FlightItineraryPersonInfos model
    """
    class Meta:
        model = FlightItineraryPersonInfos
        fields = '__all__'


class FlightItineraryrefMarkupInfosSerializer(serializers.ModelSerializer):
    """
    Serializer for FlightItineraryrefMarkupInfos model
    """
    class Meta:
        model = FlightItineraryrefMarkupInfos
        fields = '__all__'


class InoutboundsSerializer(serializers.ModelSerializer):
    """
    Serializer for Inoutbounds model
    """
    class Meta:
        model = Inoutbounds
        fields = '__all__'


class PremiumAirlinesSerializer(serializers.ModelSerializer):
    """
    Serializer for PremiumAirlines model
    """
    class Meta:
        model = PremiumAirlines
        fields = '__all__'


