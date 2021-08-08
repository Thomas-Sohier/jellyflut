import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';

class CommonPlayerAssetsAudioPlayer {
  static Future<Audio> createAudioNetwork(Item item) async {
    var url = await contructAudioURL(itemId: item.id);
    return Audio.network(
      url,
      metas: Metas(
        id: item.id,
        title: item.name,
        artist: item.artists!.map((e) => e.name).join(', ').toString(),
        album: item.album,
        image: MetasImage.network(getItemImageUrl(
            item.correctImageId(), item.correctImageTags(),
            imageBlurHashes: item.imageBlurHashes)),
      ),
    );
  }

  // String currentMusicTitle() {
  //   if (_musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value.current !=
  //       null) {
  //     return _musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value.current!
  //         .audio.audio.metas.title!;
  //   }
  //   return 'msuic playing';
  // }

  // String currentMusicArtist() {
  //   if (_musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value.current !=
  //       null) {
  //     return _musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value.current!
  //         .audio.audio.metas.artist!;
  //   }
  //   return 'No';
  // }

  // double currentMusicMaxDuration() {
  //   if (_musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value.current !=
  //       null) {
  //     return _musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value.current!
  //         .audio.duration.inMilliseconds
  //         .toDouble();
  //   }
  //   return 0;
  // }

  // double currentMusicDuration() {
  //   if (_musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value.current !=
  //       null) {
  //     return _musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value
  //         .currentPosition.inMilliseconds
  //         .toDouble();
  //   }
  //   return 0;
  // }

  // String? getCurrentAudioImagePath() {
  //   if (_musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value.current !=
  //       null) {
  //     return assetsAudioPlayer.current.value!.audio.audio.metas.image!.path;
  //   }
  //   return null;
  // }

  // void addPlaylist(Item item, int index) async {
  //   var audio = await _createAudioNetwork(item);
  //   if (assetsAudioPlayer.playlist == null) {
  //     await assetsAudioPlayer.open(audio);
  //   } else {
  //     assetsAudioPlayer.playlist!.insert(index, audio);
  //   }
  // }

  // void playAtIndex(int index) {
  //   assetsAudioPlayer.playlistPlayAtIndex(index);
  //   notifyListeners();
  // }

  // void removePlaylistItemAtIndex(int index) {
  //   assetsAudioPlayer.playlist!.removeAtIndex(index);
  //   notifyListeners();
  // }

  // void play() {
  //   _musicPlayer.assetsAudioPlayer.play();
  //   notifyListeners();
  // }

  // void pause() {
  //   _musicPlayer.assetsAudioPlayer.pause();
  //   notifyListeners();
  // }

  // Future<void> toggle() async {
  //   _musicPlayer.assetsAudioPlayer.isPlaying.value
  //       ? await _musicPlayer.assetsAudioPlayer.pause()
  //       : await _musicPlayer.assetsAudioPlayer.play();
  //   notifyListeners();
  // }

  // void playPlaylist(String parentId) {
  //   assetsAudioPlayer.playlist?.audios.clear();
  //   getItems(parentId: parentId).then((value) {
  //     value.items
  //         .where((_item) => _item.isFolder == false)
  //         .toList()
  //         .sort((a, b) => a.indexNumber!.compareTo(b.indexNumber!));
  //     value.items.asMap().forEach((index, Item _item) async {
  //       addPlaylist(_item, index);
  //     });
  //   }).then((_) => assetsAudioPlayer.playlistPlayAtIndex(0));
  // }

  // void playRemoteItem(Item item) async {
  //   _item = item;
  //   await getItem(item.id).then((Item _item) async => {
  //         _musicPlayer.assetsAudioPlayer
  //             .open(
  //               await _createAudioNetwork(item),
  //               showNotification: true,
  //             )
  //             .then((_) => notifyListeners())
  //       });
  // }
}
