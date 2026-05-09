import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoints.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Data classes
// ──────────────────────────────────────────────────────────────────────────────

/// A single field-level validation error returned by the engine.
class FieldError {
  final String code;
  final String message;

  const FieldError({required this.code, required this.message});

  factory FieldError.fromJson(Map<String, dynamic> json) => FieldError(
        code: json['code'] as String? ?? '',
        message: json['message'] as String? ?? '',
      );

  @override
  String toString() => '[$code] $message';
}

/// The full result of a [ValidationService.validate] call.
class ValidationResult {
  /// True when the payload passed every rule.
  final bool valid;

  /// Schema type echoed back from the server (e.g. "process_payment").
  final String schemaType;

  /// Field-name → list of errors. Empty when [valid] is true.
  final Map<String, List<FieldError>> errors;

  const ValidationResult({
    required this.valid,
    required this.schemaType,
    required this.errors,
  });

  /// Shortcut: first error message for [field], or null.
  String? firstMessage(String field) => errors[field]?.first.message;

  /// Shortcut: first error code for [field], or null.
  String? firstCode(String field) => errors[field]?.first.code;

  factory ValidationResult.fromJson(Map<String, dynamic> json) {
    final rawErrors = json['errors'] as Map<String, dynamic>? ?? {};
    final errors = rawErrors.map((field, list) {
      final errs = (list as List)
          .map((e) => FieldError.fromJson(e as Map<String, dynamic>))
          .toList();
      return MapEntry(field, errs);
    });

    return ValidationResult(
      valid: json['valid'] as bool? ?? false,
      schemaType: json['schema_type'] as String? ?? '',
      errors: errors,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Service
// ──────────────────────────────────────────────────────────────────────────────

/// Communicates with the backend validation engine.
///
/// Usage:
/// ```dart
/// final svc = ValidationService();
///
/// final result = await svc.validate(
///   schemaType: 'process_payment',
///   fields: {
///     'name':        'John Doe',
///     'amount':      '1500',
///     'currency':    'PKR',
///     'booking_pnr': 'ABC123',
///   },
/// );
///
/// if (!result.valid) {
///   final msg = result.firstMessage('name'); // show under name field
/// }
/// ```
class ValidationService {
  ValidationService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  static final Uri _baseUri = Uri.parse(ApiEndpoints.coreApiBaseUrl);

  // ── public API ────────────────────────────────────────────────────────────

  /// Validates [fields] against the [schemaType] rule set.
  ///
  /// Returns a [ValidationResult] whether the server responded 200 or 422.
  /// Throws a [ValidationServiceException] on network/server errors.
  Future<ValidationResult> validate({
    required String schemaType,
    required Map<String, String> fields,
  }) async {
    final uri = _baseUri.replace(path: ApiEndpoints.validate);
    final body = jsonEncode({
      'data': {
        'type': schemaType,
        'fields': fields,
      },
    });

    late http.Response response;
    try {
      response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
    } catch (e) {
      throw ValidationServiceException('Network error: $e');
    }

    if (response.statusCode == 200 || response.statusCode == 422) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ValidationResult.fromJson(json);
    }

    if (response.statusCode == 404) {
      throw ValidationServiceException(
        'Schema "$schemaType" not found on server.',
      );
    }

    throw ValidationServiceException(
      'Unexpected server response ${response.statusCode}: ${response.body}',
    );
  }

  /// Fetches schema metadata for [schemaType] — useful for debugging or
  /// displaying rule hints in the UI.
  ///
  /// Returns raw JSON map, or throws [ValidationServiceException].
  Future<Map<String, dynamic>> fetchSchema(String schemaType) async {
    final uri = _baseUri.replace(
      path: ApiEndpoints.validationSchema(schemaType),
    );

    late http.Response response;
    try {
      response = await _client.get(
        uri,
        headers: {'Accept': 'application/json'},
      );
    } catch (e) {
      throw ValidationServiceException('Network error: $e');
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw ValidationServiceException(
      'Could not fetch schema "$schemaType": ${response.statusCode}',
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Exception
// ──────────────────────────────────────────────────────────────────────────────

class ValidationServiceException implements Exception {
  final String message;
  const ValidationServiceException(this.message);

  @override
  String toString() => 'ValidationServiceException: $message';
}
