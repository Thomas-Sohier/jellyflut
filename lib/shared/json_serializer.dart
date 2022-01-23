import 'package:jellyflut/models/jellyfin/genre_item.dart';
import 'package:jellyflut/models/jellyfin/identification.dart';
import 'package:jellyflut/models/jellyfin/image_tag.dart';
import 'package:jellyflut/models/jellyfin/person.dart';
import 'package:jellyflut/models/jellyfin/studio.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';

class JsonSerializer {
  static dynamic jellyfinSerializer(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String().toString();
    } else if (object is int) {
      return object.toString();
    } else if (object is Enum) {
      return object.getValue();
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
