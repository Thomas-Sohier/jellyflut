import 'package:flutter/services.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/item_image_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:moor/moor.dart';

class AudioMetadata {
  final String? album;
  final String artist;
  final String title;
  final String? artworkUrl;
  final Uint8List artworkByte;
  final Item item;

  AudioMetadata({
    required this.album,
    required this.artist,
    required this.title,
    required this.artworkUrl,
    required this.artworkByte,
    required this.item,
  });

  static Future<AudioSource> parseFromItem(String url, Item item) async {
    final urlImage = ItemImageService.getItemImageUrl(
        item.correctImageId(), item.correctImageTags());
    return AudioSource.uri(Uri.parse(url),
        tag: AudioMetadata(
            item: item,
            album: item.album,
            title: item.name,
            artist: item.artists != null && item.artists!.isNotEmpty
                ? item.artists!.map((e) => e.name.trim()).join(', ').toString()
                : '',
            artworkUrl: null,
            artworkByte:
                (await NetworkAssetBundle(Uri.parse(urlImage)).load(urlImage))
                    .buffer
                    .asUint8List()));
  }
}
