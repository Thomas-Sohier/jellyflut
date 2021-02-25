class UserDB {
  UserDB({
    this.id,
    this.name,
    this.settingsId,
    this.serverId,
    this.apiKey,
  });

  int id;
  int settingsId;
  int serverId;
  String name;
  String apiKey;

  factory UserDB.fromMap(Map<String, dynamic> map) => UserDB(
      id: map['id'],
      settingsId: map['settingsId'],
      serverId: map['serverId'],
      name: map['name'],
      apiKey: map['apiKey']);

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'settingsId': settingsId,
      'serverId': serverId,
      'name': name,
      'apiKey': apiKey
    };
  }
}
