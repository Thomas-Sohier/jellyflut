class JsonDeserializer {
  static dynamic jellyfinDeserializer(dynamic key, dynamic value) {
    if (key == 'ImageTags' && value is List) {
      final map = value[0] as Map?;
      if (map != null && map.isNotEmpty) {
        if (map.keys.elementAt(0) == 'ImageType') {
          return <String, String>{
            map.values.elementAt(0): map.values.elementAt(1)
          };
        } else {
          return map;
        }
      }
    }
    return value;
  }
}
