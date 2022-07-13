import 'package:freezed_annotation/freezed_annotation.dart';

import 'session_infos.dart';
import 'user.dart';

part 'authentication_response.freezed.dart';
part 'authentication_response.g.dart';

/// {@template authenticationResponse}
/// A single authenticationResponse item.
///
/// Contains a [user], [sessionInfo], [accessToken] and [serverId]
///
///
/// [AuthenticationResponse]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
/// @Freezed()
@immutable
@Freezed()
class AuthenticationResponse with _$AuthenticationResponse {
  const factory AuthenticationResponse({User? user, SessionInfo? sessionInfo, String? accessToken, String? serverId}) =
      _AuthenticationResponse;

  /// Deserializes the given [JsonMap] into a [AuthByName].
  factory AuthenticationResponse.fromJson(Map<String, Object?> json) => _$AuthenticationResponseFromJson(json);
}
