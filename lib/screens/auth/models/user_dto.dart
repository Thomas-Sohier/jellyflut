class UserDto {
  final String username;
  final String password;

  const UserDto({required this.username, required this.password});

  /// Empty user which represents an unauthenticated user.
  static const empty = UserDto(username: '', password: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserDto.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserDto.empty;
}
