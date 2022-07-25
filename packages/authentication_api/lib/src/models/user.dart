import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'uint8list_converter.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// {@template user}
/// A single user item.
///
/// Contains a [id], [username], [token] and [profilePicture]
///
/// Represent a jellyfin remote user, not one from database
///
/// [User]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@Freezed()
class User with _$User {
  const User._();

  const factory User({
    /// The unique identifier of the user
    ///
    /// Cannot be empty.
    required final String id,

    /// The username of the user
    ///
    /// Cannot be empty
    required final String username,

    /// The token of the user
    ///
    /// Can be empty
    final String? token,

    /// The primary image of the item
    ///
    /// Can be empty
    @Uint8ListConverter() final Uint8List? profilePicture,
  }) = _User;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '', username: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  /// Deserializes the given [JsonMap] into a [Download].
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
