import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/enum/collectionType.dart';

IconData getRightIconForCollectionType(CollectionType? collectionType) {
  switch (collectionType) {
    case CollectionType.BOOKS:
      return Icons.book_outlined;
    case CollectionType.TVSHOWS:
      return Icons.tv_outlined;
    case CollectionType.BOXSETS:
      return Icons.account_box_outlined;
    case CollectionType.MOVIES:
      return Icons.movie_outlined;
    case CollectionType.MUSIC:
      return Icons.music_note_outlined;
    case CollectionType.HOMEVIDEOS:
      return Icons.video_camera_back_outlined;
    case CollectionType.MUSICVIDEOS:
      return Icons.music_video_outlined;
    case CollectionType.MIXED:
      return Icons.blender_outlined;
    default:
      return Icons.tv;
  }
}
