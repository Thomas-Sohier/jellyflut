class SettingsDB {
  SettingsDB({
    this.preferredPlayer,
  });

  int id;
  String preferredPlayer;

  SettingsDB.fromMap(Map<String, dynamic> map)
      : assert(map['preferredPlayer'] != null),
        id = map['id'],
        preferredPlayer = map['preferredPlayer'];

  Map<String, dynamic> toMap() {
    return {'id': id, 'preferredPlayer': preferredPlayer};
  }
}
