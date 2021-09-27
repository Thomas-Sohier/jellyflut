extension StringExtension on Enum {
  String getValue() {
    final value = this;
    return value.toString().substring(value.toString().indexOf('.') + 1);
  }
}
