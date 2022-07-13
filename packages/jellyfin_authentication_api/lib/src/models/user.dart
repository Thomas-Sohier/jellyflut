import 'package:freezed_annotation/freezed_annotation.dart';

import 'configuration.dart';
import 'policy.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// {@template user}
/// A single user item.
///
/// Contains a [user], [sessionInfo], [accessToken] and [serverId]
///
///
/// [User]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@Freezed()
class User with _$User {
  const factory User({
    required String id,
    String? name,
    String? serverId,
    String? serverName,
    String? primaryImageTag,
    double? primaryImageAspectRatio,
    required bool hasPassword,
    required bool hasConfiguredPassword,
    required bool hasConfiguredEasyPassword,
    bool? enableAutoLogin,
    DateTime? lastLoginDate,
    DateTime? lastActivityDate,
    Configuration? configuration,
    Policy? policy,
  }) = _User;

  /// Deserializes the given [JsonMap] into a [AuthByName].
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
