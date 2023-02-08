class TokenInterceptor {
  final Map<String, dynamic> headers;
  final Map<String, dynamic> queryParameters;
  TokenInterceptor({
    required this.headers,
    required this.queryParameters,
  });
}
