import 'package:freezed_annotation/freezed_annotation.dart';

part 'server.freezed.dart';
part 'server.g.dart';

/// {@template server}
/// A single server item.
///
/// Contains a [id], [name], [host], [port] and [scheme]
///
///
/// [Server]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@Freezed()
class Server with _$Server {
  const Server._();

  const factory Server({
    /// The unique identifier of the server
    ///
    /// Cannot be empty.
    required final int id,

    /// The server name
    ///
    /// Cannot be empty
    required final String name,

    /// The server url host
    /// example value : [example.remote.org]
    ///
    /// Cannot be empty
    required final String host,

    /// The server url host
    /// example value : [8888]
    ///
    /// Can be empty
    final int? port,

    /// The server url scheme
    /// possible value : [http, https]
    ///
    /// Cannot be empty
    required final String scheme,
  }) = _Server;

  /// Empty server which represents an empty server.
  static const empty = Server(id: 0, name: '', host: '', scheme: '');

  /// Convenience getter to determine whether the current server is empty.
  bool get isEmpty => this == Server.empty;

  /// Convenience getter to determine whether the current server is not empty.
  bool get isNotEmpty => this != Server.empty;

  String get url => Uri(host: host, port: port, scheme: scheme).toString();

  /// Deserializes the given [JsonMap] into a [Server].
  factory Server.fromJson(Map<String, Object?> json) => _$ServerFromJson(json);
}
