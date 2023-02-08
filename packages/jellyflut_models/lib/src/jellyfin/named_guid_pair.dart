import 'package:freezed_annotation/freezed_annotation.dart';

part 'named_guid_pair.freezed.dart';
part 'named_guid_pair.g.dart';

@Freezed()
class NamedGuidPair with _$NamedGuidPair {
  factory NamedGuidPair({
    String? name,
    String? id,
  }) = _NamedGuidPair;

  factory NamedGuidPair.fromJson(Map<String, Object?> json) => _$NamedGuidPairFromJson(json);
}
