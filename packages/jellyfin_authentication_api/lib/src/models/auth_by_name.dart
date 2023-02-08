import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_by_name.freezed.dart';
part 'auth_by_name.g.dart';

/// {@template authByName}
/// A single AuthByName item.
///
/// Contains a [username] and [password]
///
///
/// [AuthByName]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
/// @Freezed()
@immutable
@Freezed()
class AuthByName with _$AuthByName {
  const factory AuthByName(
      {@JsonKey(name: 'Username') final String? username, @JsonKey(name: 'Pw') final String? password}) = _AuthByName;

  /// Deserializes the given [JsonMap] into a [AuthByName].
  factory AuthByName.fromJson(Map<String, Object?> json) => _$AuthByNameFromJson(json);
}
