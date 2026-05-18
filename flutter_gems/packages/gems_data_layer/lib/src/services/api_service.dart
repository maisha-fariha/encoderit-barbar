import 'package:dio/dio.dart';
import '../utils/api_config.dart';
import '../utils/api_response.dart';

/// REST API Service for CRUD operations
class ApiService {
  late Dio _dio;
  final ApiConfig config;
  String? _authToken;

  ApiService(this.config) {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...config.defaultHeaders,
        },
        connectTimeout: config.timeout,
        receiveTimeout: config.timeout,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          if (_authToken != null && _authToken!.trim().isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          } else {
            options.headers.remove('Authorization');
          }

          // Let Dio set multipart boundary (matches Postman form-data / File uploads).
          if (options.data is FormData) {
            options.headers.remove(Headers.contentTypeHeader);
          }

          if (config.enableLogging) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
            print('Headers: ${options.headers}');
            if (options.data != null) {
              print('Data: ${options.data}');
            }
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (config.enableLogging) {
            print(
                'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
            print('Data: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (config.enableLogging) {
            print(
                'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
            final data = error.response?.data;
            if (data is Map && data['message'] != null) {
              print('Message: ${data['message']}');
            } else {
              print('Message: ${error.message}');
            }
          }
          final responseData = error.response?.data;
          final responseMap = responseData is Map
              ? Map<String, dynamic>.from(responseData)
              : null;
          _notifyUnauthorizedIfNeeded(
            statusCode: error.response?.statusCode,
            message: _extractApiErrorMessage(responseMap),
            requestPath: error.requestOptions.path,
          );
          return handler.next(error);
        },
      ),
    );
  }

  /// Set authentication token
  void setAuthToken(String? token) {
    final normalized = token?.trim();
    _authToken = (normalized == null || normalized.isEmpty) ? null : normalized;
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Handle successful response
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      try {
        final data =
            fromJson != null ? fromJson(response.data) : response.data as T;
        return ApiResponse.success(
          data,
          statusCode: response.statusCode,
        );
      } catch (e) {
        return ApiResponse.error(
          'Failed to parse response: $e',
          statusCode: response.statusCode,
        );
      }
    }

    final responseMap =
        response.data is Map ? Map<String, dynamic>.from(response.data) : null;
    final message = _extractApiErrorMessage(responseMap) ?? 'Request failed';
    _notifyUnauthorizedIfNeeded(
      statusCode: response.statusCode,
      message: message,
      requestPath: response.requestOptions.path,
    );

    return ApiResponse.error(
      message,
      statusCode: response.statusCode,
      errors: responseMap?['errors'] is Map<String, dynamic>
          ? responseMap!['errors'] as Map<String, dynamic>
          : responseMap?['errors'] is Map
              ? Map<String, dynamic>.from(responseMap!['errors'] as Map)
              : null,
    );
  }

  /// Handle error response
  ApiResponse<T> _handleError<T>(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      final responseMap =
          responseData is Map ? Map<String, dynamic>.from(responseData) : null;
      final responseErrors = responseMap?['errors'];

      // Handle different error types
      String message;
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        message = 'Connection timeout. Please check your internet connection.';
      } else if (error.type == DioExceptionType.connectionError) {
        message = 'Connection error. Unable to reach the server.';
      } else if (error.type == DioExceptionType.badResponse) {
        message = _extractApiErrorMessage(responseMap) ??
            error.message ??
            'Server error occurred';
      } else {
        message = error.message ?? 'Network error occurred';
      }

      _notifyUnauthorizedIfNeeded(
        statusCode: statusCode,
        message: message,
        requestPath: error.requestOptions.path,
      );

      return ApiResponse.error(
        message,
        statusCode: statusCode ?? 500,
        errors: responseErrors is Map<String, dynamic>
            ? responseErrors
            : responseErrors is Map
                ? Map<String, dynamic>.from(responseErrors)
                : null,
      );
    }

    return ApiResponse.error(
      error.toString(),
      statusCode: 500,
    );
  }

  void _notifyUnauthorizedIfNeeded({
    int? statusCode,
    String? message,
    String? requestPath,
  }) {
    final callback = config.onUnauthorized;
    if (callback == null) return;
    if (!_shouldTreatAsUnauthorized(statusCode, message, requestPath)) return;
    callback(message, requestPath: requestPath);
  }

  bool _shouldTreatAsUnauthorized(
    int? statusCode,
    String? message,
    String? requestPath,
  ) {
    if (_isAuthRequestPath(requestPath)) return false;
    if (statusCode == 401) return true;
    return _isUnauthenticatedMessage(message);
  }

  bool _isAuthRequestPath(String? path) {
    if (path == null || path.isEmpty) return false;
    final normalized = path.toLowerCase();
    return normalized.contains('/auth/login') ||
        normalized.contains('/auth/register') ||
        normalized.contains('/auth/verify-otp') ||
        normalized.contains('/auth/forgot-password') ||
        normalized.contains('/auth/reset-password');
  }

  bool _isUnauthenticatedMessage(String? message) {
    if (message == null || message.trim().isEmpty) return false;
    final normalized = message.trim().toLowerCase();
    return normalized.contains('unauthenticated') ||
        normalized.contains('unauthorized') ||
        normalized.contains('token expired') ||
        normalized.contains('session expired');
  }

  String? _extractApiErrorMessage(Map<String, dynamic>? data) {
    if (data == null) return null;

    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    final errors = data['errors'];
    if (errors is Map) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty && value.first is String) {
          final first = (value.first as String).trim();
          if (first.isNotEmpty) return first;
        }
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }

    return null;
  }
}
