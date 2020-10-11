class UserDB {
  UserDB({
    this.name,
    this.apiKey,
  });

  int id;
  String name;
  String apiKey;

  UserDB.fromMap(Map<String, dynamic> map)
      : assert(map["name"] != null),
        assert(map["apiKey"] != null),
        name = map["name"],
        apiKey = map["apiKey"];

  Map<String, dynamic> toMap() {
    return {"name": this.name, "apiKey": this.apiKey};
  }
}
