enum PlayMethod {
  transcode('Transcode'),
  directStream('DirectStream'),
  directPlay('DirectPlay');

  final String _value;

  String get value => _value;

  const PlayMethod(this._value);

  static PlayMethod fromString(String value) {
    return PlayMethod.values.firstWhere((v) => v.value == value);
  }
}
