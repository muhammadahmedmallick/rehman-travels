import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExaltedApiClient {
  final HttpClient _client = HttpClient();
  String? _accessToken;
  bool _isAuthenticated = false;

  static const String _baseUrl = 'https://exaltedrestapi.exaltedsystem.com/api';
  static const String _clientId = 'mobileapp@rehmantravel.com';
  static const String _grantType = 'exaltedsys_api';
  static const String _userType = 'agent';
  static const String _secretId = r'$2y$10$fCNL7UyM6RcNQ44EYN/ckua7Rp6mpVW6MfVpgkb5XmC1kQYf1QT8W';
  static const String _clientSecret = r'$2y$10$qt2rQn0AJluk7wCH/paZ2OFQWZMlNcwwUmYZdxwy2gQqNQQG/jr2.';
  static const String _password = r'$2y$10$ROwVcvhMVe9Ff65TWc/p4O8BGAgGNXm3jm.n3cLAkwZUXk/Vy07Pu';

  ExaltedApiClient() {
    _client.connectionTimeout = const Duration(seconds: 30);
  }

  void _setAuthHeaders(HttpClientRequest req) {
    req.headers.set('Content-Type', 'application/json');
    req.headers.set('Accept', 'application/json');
    req.headers.set('secretId', _secretId);
    req.headers.set('clientSecret', _clientSecret);
    req.headers.set('grantType', _grantType);
    req.headers.set('usertype', _userType);
    req.headers.set('password', _password);
    req.headers.set('clientid', _clientId);
    if (_accessToken != null) {
      req.headers.set('Authorization', 'Bearer $_accessToken');
    }
  }

  Future<void> authenticate() async {
    if (kDebugMode) print('=== Exalted: Authenticating...');

    final req = await _client.postUrl(Uri.parse('$_baseUrl/authenticate'));
    req.headers.set('Content-Type', 'application/json');
    req.write(jsonEncode({
      'clientId': _clientId,
      'grantType': _grantType,
      'userType': _userType,
      'secretId': _secretId,
      'clientSecret': _clientSecret,
      'password': _password,
    }));

    final resp = await req.close();
    final body = await resp.transform(utf8.decoder).join();
    final data = jsonDecode(body);

    if (data is Map<String, dynamic> && data['data'] != null && data['data']['access_token'] != null) {
      _accessToken = data['data']['access_token'].toString();
      _isAuthenticated = true;
      if (kDebugMode) print('=== Exalted: Token acquired (${_accessToken!.length} chars)');
    } else {
      throw Exception('Authentication failed: $body');
    }
  }

  Future<void> _ensureAuthenticated() async {
    if (!_isAuthenticated || _accessToken == null) {
      await authenticate();
    }
  }

  Future<ExaltedResponse> post(String path, {dynamic data}) async {
    await _ensureAuthenticated();

    final url = '$_baseUrl$path';
    if (kDebugMode) print('EXALTED[POST] => $url');

    final req = await _client.postUrl(Uri.parse(url));
    _setAuthHeaders(req);
    if (data != null) req.write(jsonEncode(data));

    final resp = await req.close();
    final body = await resp.transform(utf8.decoder).join();

    if (kDebugMode) print('EXALTED[${resp.statusCode}] => $url');

    dynamic parsed;
    try {
      parsed = jsonDecode(body);
    } catch (_) {
      parsed = body;
    }

    // Retry on 401
    if (resp.statusCode == 401) {
      _isAuthenticated = false;
      await _ensureAuthenticated();
      return post(path, data: data);
    }

    return ExaltedResponse(statusCode: resp.statusCode, data: parsed);
  }

  Future<ExaltedResponse> get(String path, {Map<String, dynamic>? queryParameters}) async {
    await _ensureAuthenticated();

    var uri = Uri.parse('$_baseUrl$path');
    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters.map((k, v) => MapEntry(k, v.toString())));
    }

    if (kDebugMode) print('EXALTED[GET] => $uri');

    final req = await _client.getUrl(uri);
    _setAuthHeaders(req);

    final resp = await req.close();
    final body = await resp.transform(utf8.decoder).join();

    if (kDebugMode) print('EXALTED[${resp.statusCode}] => $uri');

    dynamic parsed;
    try {
      parsed = jsonDecode(body);
    } catch (_) {
      parsed = body;
    }

    return ExaltedResponse(statusCode: resp.statusCode, data: parsed);
  }
}

class ExaltedResponse {
  final int statusCode;
  final dynamic data;
  const ExaltedResponse({required this.statusCode, required this.data});
}

final exaltedApiClientProvider = Provider<ExaltedApiClient>((ref) => ExaltedApiClient());
