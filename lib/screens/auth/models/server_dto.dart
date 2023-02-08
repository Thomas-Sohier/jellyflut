class ServerDto {
  final String name;
  final String url;

  const ServerDto({required this.name, required this.url});

  /// Empty user which represents an empty server.
  static const empty = ServerDto(name: '', url: '');

  /// Convenience getter to determine whether the current server is empty.
  bool get isEmpty => this == ServerDto.empty;

  /// Convenience getter to determine whether the current server is not empty.
  bool get isNotEmpty => this != ServerDto.empty;
}
