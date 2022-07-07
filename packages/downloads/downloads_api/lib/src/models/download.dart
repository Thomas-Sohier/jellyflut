import 'dart:typed_data';

import 'package:downloads_api/src/models/uint8list_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'json_map.dart';

part 'download.g.dart';

/// {@template download}
/// A single download item.
///
/// Contains a [itemId], [cancel] and [downloadValueWatcher]
///
/// [itemId] need to exist or it will provoke errors.
///
/// [Download]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@JsonSerializable()
class Download extends Equatable {
  /// The unique identifier of the item.
  ///
  /// Cannot be empty.
  final String id;

  /// The name of the item
  ///
  /// Can be empty
  final String? name;

  /// Download path of the item
  ///
  /// Cannot be empty
  final String path;

  /// The primary image of the item
  ///
  /// Can be empty
  @Uint8ListConverter()
  final Uint8List? primary;

  /// The backdrop image of the item
  ///
  /// Can be empty
  @Uint8ListConverter()
  final Uint8List? backdrop;

  /// The complete item infos, useful to show data while offline
  ///
  /// Cannot be empty
  final Item item;

  /// {@macro download}
  const Download({
    required this.id,
    this.name,
    required this.path,
    this.primary,
    this.backdrop,
    required this.item,
  });

  /// Returns a copy of this todo with the given values updated.
  ///
  /// {@macro download}
  Download copyWith({String? id, String? name, String? path, Uint8List? primary, Uint8List? backdrop, Item? item}) {
    return Download(
        id: id ?? this.id,
        name: name ?? this.name,
        path: path ?? this.path,
        item: item ?? this.item,
        primary: primary ?? this.primary,
        backdrop: backdrop ?? this.backdrop);
  }

  /// Deserializes the given [JsonMap] into a [Download].
  static Download fromJson(JsonMap json) => _$DownloadFromJson(json);

  /// Converts this [Download] into a [JsonMap].
  JsonMap toJson() => _$DownloadToJson(this);

  @override
  List<Object> get props => [id, path, item];
}
