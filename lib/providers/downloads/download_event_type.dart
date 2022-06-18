enum DownloadEventType {
  ADDED('added'),
  DELETED('deleted');

  final String _value;
  const DownloadEventType(this._value);

  String get value => _value;
}
