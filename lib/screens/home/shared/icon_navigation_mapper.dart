import 'package:flutter/material.dart';

import 'package:jellyflut_models/jellyflut_models.dart';

IconData getRightIconForCollectionType(CollectionType? collectionType) {
  switch (collectionType) {
    case CollectionType.Books:
      return Icons.book_outlined;
    case CollectionType.TvShows:
      return Icons.tv_outlined;
    case CollectionType.BoxSets:
      return Icons.account_box_outlined;
    case CollectionType.Movies:
      return Icons.movie_outlined;
    case CollectionType.Music:
      return Icons.music_note_outlined;
    case CollectionType.HomeVideos:
      return Icons.video_camera_back_outlined;
    case CollectionType.MusicVideos:
      return Icons.music_video_outlined;
    case CollectionType.Mixed:
      return Icons.blender_outlined;
    default:
      return Icons.tv;
  }
}
