class JsonSerializer {
  static dynamic jellyfinSerializer(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String().toString();
    } else if (object is int) {
      return object.toString();
    }
    return object;
  }
}
