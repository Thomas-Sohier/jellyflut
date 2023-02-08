extension StringExtension on String? {
  String capitalize() {
    return '${this?[0].toUpperCase()}${this?.substring(1)}';
  }

  bool equalsIgnoreCase(String? a) =>
      (a == null && this == null) || (a != null && this != null && a.toLowerCase() == this!.toLowerCase());
}
