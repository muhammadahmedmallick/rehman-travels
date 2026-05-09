import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Two available agent identities for the Exalted API. The active set
/// is controlled by [ExaltedApiClient.useWebClient] — flip it when you
/// want to hit the backend as the web agent instead of the mobile one.
class _ExaltedCreds {
  final String clientId;
  final String secretId;
  final String clientSecret;
  final String password;
  const _ExaltedCreds({
    required this.clientId,
    required this.secretId,
    required this.clientSecret,
    required this.password,
  });
}

/// Mobile agent (1185, `mobileapp@rehmantravel.com`) — what the app
/// has always shipped with. Confirmed working against prod.
const _mobileCreds = _ExaltedCreds(
  clientId: 'mobileapp@rehmantravel.com',
  secretId: r'$2y$10$fCNL7UyM6RcNQ44EYN/ckua7Rp6mpVW6MfVpgkb5XmC1kQYf1QT8W',
  clientSecret: r'$2y$10$qt2rQn0AJluk7wCH/paZ2OFQWZMlNcwwUmYZdxwy2gQqNQQG/jr2.',
  password: r'$2y$10$ROwVcvhMVe9Ff65TWc/p4O8BGAgGNXm3jm.n3cLAkwZUXk/Vy07Pu',
);



class ExaltedApiClient {
  /// Flip to `true` to authenticate as the web agent (1182) for the
  /// next request. The client drops the cached token on change so the
  /// next call re-authenticates with the newly selected creds.
  static bool useWebClient = false;

  final HttpClient _client = HttpClient();
  String? _accessToken;
  bool _isAuthenticated = false;
  bool? _lastUsedWebClient;

  static const String _baseUrl = 'https://exaltedrestapi.exaltedsystem.com/api';
  static const String _grantType = 'exaltedsys_api';
  static const String _userType = 'agent';

  _ExaltedCreds get _creds =>  _mobileCreds;

  ExaltedApiClient() {
    _client.connectionTimeout = const Duration(seconds: 30);
  }

  void _setAuthHeaders(HttpClientRequest req) {
    final c = _creds;
    req.headers.set('Content-Type', 'application/json');
    req.headers.set('Accept', 'application/json');
    req.headers.set('secretId', c.secretId);
    req.headers.set('clientSecret', c.clientSecret);
    req.headers.set('grantType', _grantType);
    req.headers.set('usertype', _userType);
    req.headers.set('password', c.password);
    req.headers.set('clientid', c.clientId);
    if (_accessToken != null) {
      req.headers.set('Authorization', 'Bearer $_accessToken');
    }
  }

  Future<void> authenticate() async {
    final c = _creds;
    if (kDebugMode) {
      print('=== Exalted: Authenticating as ${c.clientId}...');
    }

    final req = await _client.postUrl(Uri.parse('$_baseUrl/authenticate'));
    req.headers.set('Content-Type', 'application/json');
    req.write(jsonEncode({
      'clientId': c.clientId,
      'grantType': _grantType,
      'userType': _userType,
      'secretId': c.secretId,
      'clientSecret': c.clientSecret,
      'password': c.password,
    }));

    final resp = await req.close();
    final body = await resp.transform(utf8.decoder).join();
    final data = jsonDecode(body);

    if (data is Map<String, dynamic> && data['data'] != null && data['data']['access_token'] != null) {
      _accessToken = data['data']['access_token'].toString();
      _isAuthenticated = true;
      _lastUsedWebClient = useWebClient;
      if (kDebugMode) print('=== Exalted: Token acquired (${_accessToken!.length} chars)');
    } else {
      throw Exception('Authentication failed: $body');
    }
  }

  Future<void> _ensureAuthenticated() async {
    // If the active credential set changed since the cached token was
    // issued, drop it so the next call re-authenticates under the new
    // agent identity.
    if (_lastUsedWebClient != null && _lastUsedWebClient != useWebClient) {
      _accessToken = null;
      _isAuthenticated = false;
    }
    if (!_isAuthenticated || _accessToken == null) {
      await authenticate();
    }
  }

  Future<ExaltedResponse> post(String path, {dynamic data}) async {
    await _ensureAuthenticated();

    final url = '$_baseUrl$path';
    if (kDebugMode) {
      print('EXALTED[POST] => $url');
      print(_buildCurl(url: url, body: data));
    }

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

  /// Builds a copy-pasteable `curl` command for the given POST so
  /// debugging the flight-search API is one click away. Only invoked
  /// in debug mode — the auth secrets are real, so don't paste the
  /// output anywhere public.
  String _buildCurl({required String url, dynamic body}) {
    final c = _creds;
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'secretId': c.secretId,
      'clientSecret': c.clientSecret,
      'grantType': _grantType,
      'usertype': _userType,
      'password': c.password,
      'clientid': c.clientId,
      if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
    };
    final headerLines =
        headers.entries.map((e) => "  -H '${e.key}: ${e.value}'").join(' \\\n');
    final dataLine = body == null
        ? ''
        : " \\\n  -d '${jsonEncode(body).replaceAll(r"'", r"'\''")}'";
    return '\n--- curl ---\ncurl -X POST \\\n  \'$url\' \\\n$headerLines$dataLine\n------------\n';
  }
}

class ExaltedResponse {
  final int statusCode;
  final dynamic data;
  const ExaltedResponse({required this.statusCode, required this.data});
}

final exaltedApiClientProvider = Provider<ExaltedApiClient>((ref) => ExaltedApiClient());
