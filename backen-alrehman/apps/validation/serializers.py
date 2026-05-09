"""
Validation app serializers (admin / management use only).
The validate endpoint returns raw dicts from the engine — no DRF serializer needed.
"""
from rest_framework import serializers
from apps.validation.models import FieldRule, ValidationSchema


class FieldRuleSerializer(serializers.ModelSerializer):
    class Meta:
        model = FieldRule
        fields = [
            'id', 'schema', 'field_name', 'rule_type', 'rule_value',
            'error_code', 'error_message', 'order', 'is_active',
        ]


class ValidationSchemaSerializer(serializers.ModelSerializer):
    rules = FieldRuleSerializer(many=True, read_only=True)

    class Meta:
        model = ValidationSchema
        fields = [
            'id', 'schema_type', 'description', 'fail_fast',
            'is_active', 'created_at', 'updated_at', 'rules',
        ]
