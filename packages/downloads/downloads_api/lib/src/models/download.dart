import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

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
  final int itemId;

  /// The method which can cancel the current download
  final void Function() cancel;

  /// The current download percentage
  final BehaviorSubject<int> downloadValueWatcher;

  /// {@macro download}
  const Download({
    required this.itemId,
    required this.cancel,
    required this.downloadValueWatcher,
  });

  /// Returns a copy of this todo with the given values updated.
  ///
  /// {@macro download}
  Download copyWith(
      {int? itemId,
      void Function()? cancel,
      BehaviorSubject<int>? downloadValueWatcher}) {
    return Download(
        itemId: itemId ?? this.itemId,
        cancel: cancel ?? this.cancel,
        downloadValueWatcher:
            downloadValueWatcher ?? this.downloadValueWatcher);
  }

  /// Deserializes the given [JsonMap] into a [Deserializes].
  static Download fromJson(JsonMap json) => _$DownloadFromJson(json);

  /// Converts this [Deserializes] into a [JsonMap].
  JsonMap toJson() => _$DownloadToJson(this);

  @override
  List<Object> get props => [itemId, cancel, downloadValueWatcher];
}
