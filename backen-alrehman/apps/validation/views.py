"""
Validation API views.
"""
import logging

from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.validation.engine import ValidationEngine
from apps.validation.models import ErrorCode

logger = logging.getLogger(__name__)


class ValidateView(APIView):
    """
    POST /api/validation/validate/

    Validates a set of fields against a stored schema.

    Request body
    ------------
    {
        "data": {
            "type":   "process_payment",
            "fields": {
                "name":     "",
                "amount":   "15000",
                "currency": "PKR"
            }
        }
    }

    Success response (HTTP 200, all fields valid)
    ---------------------------------------------
    {
        "valid":       true,
        "schema_type": "process_payment",
        "errors":      {}
    }

    Failure response (HTTP 422, validation errors)
    -----------------------------------------------
    {
        "valid":       false,
        "schema_type": "process_payment",
        "errors": {
            "name": [
                { "code": "FIELD_REQUIRED", "message": "name is required." }
            ],
            "currency": [
                { "code": "INVALID_CHOICE", "message": "currency must be one of: PKR,USD,EUR." }
            ]
        }
    }

    System error response (HTTP 400 / 404)
    ---------------------------------------
    {
        "valid":       false,
        "schema_type": "unknown_type",
        "errors": {
            "__all__": [
                { "code": "SCHEMA_NOT_FOUND", "message": "No active validation schema found for type \\"unknown_type\\"." }
            ]
        }
    }
    """

    def post(self, request):
        # ── Parse payload ────────────────────────────────────────────────────
        data = request.data.get('data')

        if not isinstance(data, dict):
            return Response(
                {
                    'valid': False,
                    'schema_type': '',
                    'errors': {
                        '__all__': [{
                            'code':    ErrorCode.INVALID_PAYLOAD,
                            'message': 'Request body must contain a "data" object.',
                        }]
                    },
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

        schema_type = data.get('type', '').strip()
        fields      = data.get('fields', {})

        if not schema_type:
            return Response(
                {
                    'valid': False,
                    'schema_type': '',
                    'errors': {
                        '__all__': [{
                            'code':    ErrorCode.INVALID_PAYLOAD,
                            'message': 'data.type is required.',
                        }]
                    },
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

        if not isinstance(fields, dict):
            return Response(
                {
                    'valid': False,
                    'schema_type': schema_type,
                    'errors': {
                        '__all__': [{
                            'code':    ErrorCode.INVALID_PAYLOAD,
                            'message': 'data.fields must be an object.',
                        }]
                    },
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

        # ── Run engine ───────────────────────────────────────────────────────
        result = ValidationEngine.validate(schema_type=schema_type, fields=fields)

        # Determine HTTP status:
        #   200 → valid
        #   404 → schema not found
        #   422 → validation errors
        if result.valid:
            http_status = status.HTTP_200_OK
        elif ErrorCode.SCHEMA_NOT_FOUND in str(result.errors):
            http_status = status.HTTP_404_NOT_FOUND
        else:
            http_status = status.HTTP_422_UNPROCESSABLE_ENTITY

        return Response(result.to_response(), status=http_status)


class SchemaInfoView(APIView):
    """
    GET /api/validation/schema/<schema_type>/

    Returns the field rules defined for a schema — useful for client-side
    pre-validation hints or documentation.

    Response (HTTP 200)
    -------------------
    {
        "schema_type": "process_payment",
        "description": "Validates payment initiation fields.",
        "fail_fast":   true,
        "fields": {
            "name":   [{ "rule_type": "required", "rule_value": "", "error_code": "FIELD_REQUIRED" }, ...],
            "amount": [...]
        }
    }
    """

    def get(self, request, schema_type: str):
        info = ValidationEngine.get_schema_info(schema_type)
        if info is None:
            return Response(
                {
                    'code':    ErrorCode.SCHEMA_NOT_FOUND,
                    'message': f'No active schema found for type "{schema_type}".',
                },
                status=status.HTTP_404_NOT_FOUND,
            )
        return Response(info, status=status.HTTP_200_OK)
