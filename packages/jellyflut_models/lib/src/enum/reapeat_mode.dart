enum RepeatMode {
  repeatNone('RepeatNone'),
  repeatAll('RepeatAll'),
  repeatOne('RepeatOne');

  final String _value;

  String get value => _value;

  const RepeatMode(this._value);

  static RepeatMode fromString(String value) {
    return RepeatMode.values.firstWhere((v) => v.value == value);
  }
}
