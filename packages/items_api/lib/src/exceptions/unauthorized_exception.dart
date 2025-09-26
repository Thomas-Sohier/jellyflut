class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Unauthorized access - invalid credentials']);

  @override
  String toString() => 'UnauthorizedException: $message';
}
