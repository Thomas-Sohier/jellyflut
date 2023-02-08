// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:jellyflut_models/jellyflut_models.dart';

class DownloadDto {
  final String id;
  final String? name;
  final String? path;
  final Uint8List? primary;
  final Uint8List? backdrop;
  final Item? item;

  const DownloadDto._({required this.id, this.name, required this.path, this.primary, this.backdrop, this.item});

  DownloadDto.toInsert({required this.id, this.name, required this.path, this.primary, this.backdrop, this.item})
      : assert(path != null && path.isNotEmpty, 'Download path needs to be set'),
        assert(id.isNotEmpty, 'Id needs to be set and equals to an item id');

  DownloadDto.toUpdate({required this.id, this.name, this.path, this.primary, this.backdrop, this.item})
      : assert(path != null && path.isNotEmpty, 'Download path needs to be set');
}
