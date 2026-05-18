/// Called when the API indicates the current session is no longer valid.
typedef UnauthorizedCallback = void Function(
  String? message, {
  String? requestPath,
});

/// API Configuration class
class ApiConfig {
  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final Duration timeout;
  final bool enableLogging;
  final UnauthorizedCallback? onUnauthorized;

  const ApiConfig({
    required this.baseUrl,
    this.defaultHeaders = const {},
    this.timeout = const Duration(seconds: 30),
    this.enableLogging = false,
    this.onUnauthorized,
  });

  ApiConfig copyWith({
    String? baseUrl,
    Map<String, String>? defaultHeaders,
    Duration? timeout,
    bool? enableLogging,
    UnauthorizedCallback? onUnauthorized,
  }) {
    return ApiConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
      timeout: timeout ?? this.timeout,
      enableLogging: enableLogging ?? this.enableLogging,
      onUnauthorized: onUnauthorized ?? this.onUnauthorized,
    );
  }
}

