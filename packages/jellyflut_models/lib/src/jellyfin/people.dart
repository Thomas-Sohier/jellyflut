import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jellyflut_models/src/enum/item_type.dart';
import 'package:jellyflut_models/src/jellyfin/item.dart';

import 'image_blur_hashes.dart';

part 'people.freezed.dart';
part 'people.g.dart';

@Freezed()
class People with _$People {
  People._();

  factory People(
      {required String id,
      String? name,
      String? role,
      String? type,
      String? primaryImageTag,
      ImageBlurHashes? imageBlurHashes}) = _People;

  factory People.fromJson(Map<String, Object?> json) => _$PeopleFromJson(json);

  Item asItem() => Item(id: id, name: name, imageBlurHashes: imageBlurHashes, type: ItemType.Person);
}
