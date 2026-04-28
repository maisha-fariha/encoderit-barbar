import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:gems_data_layer/gems_data_layer.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Single entry for auth: local (bcrypt + prefs) or remote ([AuthService]).
abstract class AppAuthGateway {
  ApiService get apiService;

  Future<ApiResponse<AuthData>> login({
    required String email,
    required String password,
    String endpoint = '/auth/login',
  });

  Future<ApiResponse<AuthData>> register({
    required Map<String, dynamic> data,
    String endpoint = '/auth/register',
  });

  Future<void> logout();

  Future<AuthData?> getStoredAuth();

  Future<bool> isAuthenticated();
}

/// Delegates to [AuthService] (network + same storage as production).
class RemoteAppAuthGateway implements AppAuthGateway {
  RemoteAppAuthGateway(this._auth);

  final AuthService _auth;

  @override
  ApiService get apiService => _auth.apiService;

  @override
  Future<ApiResponse<AuthData>> login({
    required String email,
    required String password,
    String endpoint = '/auth/login',
  }) =>
      _auth.login(email: email, password: password, endpoint: endpoint);

  @override
  Future<ApiResponse<AuthData>> register({
    required Map<String, dynamic> data,
    String endpoint = '/auth/register',
  }) =>
      _auth.register(data: data, endpoint: endpoint);

  @override
  Future<void> logout() => _auth.logout();

  @override
  Future<AuthData?> getStoredAuth() => _auth.getStoredAuth();

  @override
  Future<bool> isAuthenticated() => _auth.isAuthenticated();
}

/// Local accounts: passwords stored as bcrypt hashes only; session uses [AuthData] like the API path.
class LocalAppAuthGateway implements AppAuthGateway {
  LocalAppAuthGateway(this._auth, this._prefs);

  final AuthService _auth;
  final SharedPreferences _prefs;

  static const _accountsKey = 'encoderit_local_auth_accounts_v1';

  @override
  ApiService get apiService => _auth.apiService;

  Map<String, dynamic> _readAccounts() {
    final raw = _prefs.getString(_accountsKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw);
      if (map is Map<String, dynamic>) return Map<String, dynamic>.from(map);
      if (map is Map) {
        return map.map((k, v) => MapEntry(k.toString(), v));
      }
    } catch (_) {}
    return {};
  }

  Future<void> _writeAccounts(Map<String, dynamic> accounts) async {
    await _prefs.setString(_accountsKey, jsonEncode(accounts));
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  AuthData _mintSession({
    required String email,
    String? name,
    String? phone,
  }) {
    final expiresAt = DateTime.now().add(const Duration(days: 7));
    final payload = <String, dynamic>{
      'sub': email,
      'typ': 'local_dev',
      'exp': expiresAt.millisecondsSinceEpoch ~/ 1000,
    };
    final token =
        'local.${base64Url.encode(utf8.encode(jsonEncode(payload))).replaceAll('=', '')}';
    return AuthData(
      accessToken: token,
      refreshToken: null,
      expiresAt: expiresAt,
      userData: <String, dynamic>{
        'email': email,
        if (name != null && name.isNotEmpty) 'name': name,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      },
    );
  }

  @override
  Future<ApiResponse<AuthData>> login({
    required String email,
    required String password,
    String endpoint = '/auth/login',
  }) async {
    final key = _normalizeEmail(email);
    if (key.isEmpty) {
      return ApiResponse.error('Email is required', statusCode: 400);
    }
    final accounts = _readAccounts();
    final row = accounts[key];
    if (row is! Map) {
      return ApiResponse.error('Invalid email or password', statusCode: 401);
    }
    final map = Map<String, dynamic>.from(row);
    final hash = map['passwordHash'] as String?;
    if (hash == null || !BCrypt.checkpw(password, hash)) {
      return ApiResponse.error('Invalid email or password', statusCode: 401);
    }
    final name = map['name'] as String?;
    final phone = map['phone'] as String?;
    final session = _mintSession(email: key, name: name, phone: phone);
    await _auth.applySession(session);
    return ApiResponse.success(session, statusCode: 200);
  }

  @override
  Future<ApiResponse<AuthData>> register({
    required Map<String, dynamic> data,
    String endpoint = '/auth/register',
  }) async {
    final emailRaw = data['email'] as String? ?? '';
    final password = data['password'] as String? ?? '';
    final key = _normalizeEmail(emailRaw);
    if (key.isEmpty || !key.contains('@')) {
      return ApiResponse.error('Valid email is required', statusCode: 400);
    }
    if (password.length < 6) {
      return ApiResponse.error('Password must be at least 6 characters', statusCode: 400);
    }
    final accounts = _readAccounts();
    if (accounts.containsKey(key)) {
      return ApiResponse.error('An account already exists for this email', statusCode: 409);
    }
    final salt = BCrypt.gensalt();
    final passwordHash = BCrypt.hashpw(password, salt);
    final name = data['name'] as String? ?? data['fullName'] as String?;
    final phone = data['phone'] as String?;
    accounts[key] = <String, dynamic>{
      'passwordHash': passwordHash,
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
    };
    await _writeAccounts(accounts);
    final session = _mintSession(
      email: key,
      name: name?.trim(),
      phone: phone?.trim(),
    );
    await _auth.applySession(session);
    return ApiResponse.success(session, statusCode: 201);
  }

  @override
  Future<void> logout() => _auth.logout();

  @override
  Future<AuthData?> getStoredAuth() => _auth.getStoredAuth();

  @override
  Future<bool> isAuthenticated() => _auth.isAuthenticated();
}
