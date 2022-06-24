enum MediaType {
  LOCAL('Local'),
  REMOTE('Remote');

  final String _value;

  String get value => _value;

  const MediaType(this._value);
}
