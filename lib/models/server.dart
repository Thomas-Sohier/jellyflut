List<Server> serverFromList(List<Map> datas) =>
    List<Server>.from(datas.map((x) => Server.fromMap(x)));

class Server {
  Server({this.url, this.name});

  String url;
  String name;

  Server.fromMap(Map<String, dynamic> map)
      : assert(map["url"] != null),
        assert(map["name"] != null),
        url = map["url"],
        name = map["name"];

  Map<String, dynamic> toMap() {
    return {"url": this.url, "name": this.name};
  }
}
