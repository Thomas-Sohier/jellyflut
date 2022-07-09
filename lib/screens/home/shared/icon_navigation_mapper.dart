import 'package:flutter/material.dart';

import 'package:jellyflut_models/jellyflut_models.dart';

IconData getRightIconForCollectionType(CollectionType? collectionType) {
  switch (collectionType) {
    case CollectionType.books:
      return Icons.book_outlined;
    case CollectionType.tvshows:
      return Icons.tv_outlined;
    case CollectionType.boxsets:
      return Icons.account_box_outlined;
    case CollectionType.movies:
      return Icons.movie_outlined;
    case CollectionType.music:
      return Icons.music_note_outlined;
    case CollectionType.homevideos:
      return Icons.video_camera_back_outlined;
    case CollectionType.musicvideos:
      return Icons.music_video_outlined;
    case CollectionType.mixed:
      return Icons.blender_outlined;
    default:
      return Icons.tv;
  }
}
