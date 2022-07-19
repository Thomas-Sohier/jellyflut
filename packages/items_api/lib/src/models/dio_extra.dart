class DioExtra {
  final String jellyfinUserId;

  const DioExtra({required this.jellyfinUserId});

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('jellyfinUserId', jellyfinUserId);
    return val;
  }

  static DioExtra fromJson(Map<String, dynamic> json) => DioExtra(jellyfinUserId: json['jellyfinUserId'] as String);
}
