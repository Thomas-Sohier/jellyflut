class DatabaseUserDto {
  final int? id;
  final String? name;
  final String? password;
  final String? apiKey;
  final String? jellyfinUserId;
  final int? settingsId;
  final int? serverId;

  const DatabaseUserDto(
      {this.id, this.name, this.password, this.apiKey, this.jellyfinUserId, this.settingsId, this.serverId});
}
