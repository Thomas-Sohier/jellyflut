import 'package:jellyflut_models/jellyflut_models.dart';

class JsonSerializer {
  static dynamic jellyfinSerializer(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String().toString();
    } else if (object is int) {
      return object.toString();
    } else if (object is Enum) {
      return object.name;
    } else if (object is Person) {
      return object.toMap();
    } else if (object is GenreItem) {
      return object.name;
    } else if (object is ImageTag) {
      return object.toMap();
    } else if (object is Studio) {
      return object.toMap();
    }
    return object;
  }
}
