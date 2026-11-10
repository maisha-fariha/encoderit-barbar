import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../utils/api_response.dart';

/// Authentication data model
class AuthData {
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final Map<String, dynamic>? userData;

  AuthData({
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.userData,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt?.toIso8601String(),
      'userData': userData,
    };
  }

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      userData: json['userData'] as Map<String, dynamic>?,
    );
  }
}

/// Authentication Service
class AuthService {
  final ApiService apiService;
  final SharedPreferences prefs;
  static const String _authKey = 'gems_auth_data';

  AuthService(this.apiService, this.prefs);

  /// Login
  Future<ApiResponse<AuthData>> login({
    required String email,
    required String password,
    String endpoint = '/auth/login',
  }) async {
    final response = await apiService.post<Map<String, dynamic>>(
      endpoint,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.success && response.data != null) {
      final authData = _parseAuthResponse(response.data!);
      await _saveAuthData(authData);
      apiService.setAuthToken(authData.accessToken);
      return ApiResponse.success(authData);
    }

    return ApiResponse.error(
      response.message ?? 'Login failed',
      statusCode: response.statusCode,
    );
  }

  /// Register
  Future<ApiResponse<AuthData>> register({
    required Map<String, dynamic> data,
    String endpoint = '/auth/register',
  }) async {
    final response = await apiService.post<Map<String, dynamic>>(
      endpoint,
      data: data,
    );

    if (response.success && response.data != null) {
      final authData = _parseAuthResponse(response.data!);
      // OTP registration may return success without a token yet.
      if (authData.accessToken.isNotEmpty) {
        await _saveAuthData(authData);
        apiService.setAuthToken(authData.accessToken);
      }
      return ApiResponse.success(authData);
    }

    return ApiResponse.error(
      response.message ?? 'Registration failed',
      statusCode: response.statusCode,
    );
  }

  /// Verify email OTP (`POST /auth/verify-otp`).
  ///
  /// When the response includes an access token (registration flow), the session
  /// is saved. Forgot-password OTP may succeed without a token.
  Future<ApiResponse<AuthData?>> verifyOtp({
    required String email,
    required String otp,
    String endpoint = '/auth/verify-otp',
  }) async {
    final response = await apiService.post<Map<String, dynamic>>(
      endpoint,
      data: {
        'email': email,
        'otp': otp,
      },
    );

    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'OTP verification failed',
        statusCode: response.statusCode,
        errors: response.errors,
      );
    }

    final raw = response.data;
    if (raw != null) {
      final map = Map<String, dynamic>.from(raw);
      final authData = _parseAuthResponse(map);
      if (authData.accessToken.isNotEmpty) {
        await _saveAuthData(authData);
        apiService.setAuthToken(authData.accessToken);
        return ApiResponse.success(
          authData,
          message: response.message,
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.success(
      null,
      message: response.message,
      statusCode: response.statusCode,
    );
  }

  /// Refresh token
  Future<ApiResponse<AuthData>> refreshToken({
    String? refreshToken,
    String endpoint = '/auth/refresh',
  }) async {
    final storedAuth = await getStoredAuth();
    final token = refreshToken ?? storedAuth?.refreshToken;

    if (token == null) {
      return ApiResponse.error('No refresh token available');
    }

    final response = await apiService.post<Map<String, dynamic>>(
      endpoint,
      data: {'refreshToken': token},
    );

    if (response.success && response.data != null) {
      final authData = _parseAuthResponse(response.data!);
      await _saveAuthData(authData);
      apiService.setAuthToken(authData.accessToken);
      return ApiResponse.success(authData);
    }

    return ApiResponse.error(
      response.message ?? 'Token refresh failed',
      statusCode: response.statusCode,
    );
  }

  /// Persists [authData] and sets the API bearer token.
  ///
  /// Use after parsing a remote auth response, or when a local auth
  /// implementation mints a JWT-compatible session you want stored the same way.
  Future<void> applySession(AuthData authData) async {
    await _saveAuthData(authData);
    apiService.setAuthToken(authData.accessToken);
  }

  /// Logout
  Future<void> logout() async {
    await prefs.remove(_authKey);
    apiService.setAuthToken(null);
  }

  /// Get stored auth data
  Future<AuthData?> getStoredAuth() async {
    final authJson = prefs.getString(_authKey);
    if (authJson == null) return null;

    try {
      return AuthData.fromJson(
        Map<String, dynamic>.from(
          jsonDecode(authJson) as Map,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final authData = await getStoredAuth();
    if (authData == null) return false;

    if (authData.isExpired) {
      final refresh = authData.refreshToken?.trim();
      if (refresh != null && refresh.isNotEmpty) {
        final refreshResponse = await refreshToken();
        return refreshResponse.success;
      }
      await logout();
      return false;
    }

    apiService.setAuthToken(authData.accessToken);
    return true;
  }

  /// Initialize auth (call on app start)
  Future<void> initialize() async {
    final authData = await getStoredAuth();
    if (authData != null && !authData.isExpired) {
      apiService.setAuthToken(authData.accessToken);
    } else if (authData != null && authData.refreshToken != null) {
      await refreshToken();
    }
  }

  /// Parse auth response
  AuthData _parseAuthResponse(Map<String, dynamic> data) {
    final payload = data['data'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(data['data'] as Map<String, dynamic>)
        : data['data'] is Map
            ? Map<String, dynamic>.from(data['data'] as Map)
            : data;

    // Some APIs nest the token under `token` / `auth` objects.
    final nestedToken = payload['token'] is Map
        ? Map<String, dynamic>.from(payload['token'] as Map)
        : payload['auth'] is Map
            ? Map<String, dynamic>.from(payload['auth'] as Map)
            : null;

    final userPayload = payload['user'] ??
        payload['userData'] ??
        data['user'] ??
        data['userData'];
    DateTime? expiresAt;
    final expiresAtRaw = payload['expiresAt'] ??
        payload['expires_at'] ??
        data['expiresAt'] ??
        data['expires_at'];
    final expiresInRaw = payload['expiresIn'] ??
        payload['expires_in'] ??
        data['expiresIn'] ??
        data['expires_in'];
    if (expiresAtRaw is String && expiresAtRaw.isNotEmpty) {
      try {
        expiresAt = DateTime.parse(expiresAtRaw);
      } catch (_) {}
    } else if (expiresInRaw is int) {
      expiresAt = DateTime.now().add(Duration(seconds: expiresInRaw));
    } else if (expiresInRaw is num) {
      expiresAt = DateTime.now().add(Duration(seconds: expiresInRaw.toInt()));
    }

    String readToken(Map<String, dynamic> map) {
      for (final key in <String>[
        'accessToken',
        'access_token',
        'token',
        'plainTextToken',
        'plain_text_token',
      ]) {
        final value = map[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
      return '';
    }

    final accessToken = readToken(payload).isNotEmpty
        ? readToken(payload)
        : (nestedToken != null && readToken(nestedToken).isNotEmpty
            ? readToken(nestedToken)
            : readToken(data));

    final refreshRaw = payload['refreshToken'] ??
        payload['refresh_token'] ??
        nestedToken?['refreshToken'] ??
        nestedToken?['refresh_token'] ??
        data['refreshToken'] ??
        data['refresh_token'];

    return AuthData(
      accessToken: accessToken,
      refreshToken: refreshRaw is String && refreshRaw.trim().isNotEmpty
          ? refreshRaw.trim()
          : null,
      expiresAt: expiresAt,
      userData: _normalizeUserPayload(userPayload),
    );
  }

  /// Flattens nested `user_details` into the top-level user map used by the app.
  Map<String, dynamic>? _normalizeUserPayload(dynamic userPayload) {
    if (userPayload is! Map) return null;
    final user = Map<String, dynamic>.from(userPayload);
    final details = user['user_details'] ?? user['userDetails'] ?? user['profile'];
    if (details is Map) {
      for (final e in Map<String, dynamic>.from(details).entries) {
        if (e.value == null) continue;
        if (e.value is String && (e.value as String).trim().isEmpty) continue;
        // Nested details fill gaps; keep existing top-level values.
        final existing = user[e.key];
        final missing = existing == null ||
            (existing is String && existing.trim().isEmpty);
        if (missing) {
          user[e.key] = e.value;
        }
      }
    }
    return user;
  }

  /// Save auth data to local storage
  Future<void> _saveAuthData(AuthData authData) async {
    await prefs.setString(_authKey, jsonEncode(authData.toJson()));
  }
}
