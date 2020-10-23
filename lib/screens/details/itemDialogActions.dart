import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/api.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/shared/shared.dart';

import '../../globals.dart';

class ItemDialogActions extends StatelessWidget {
  final Item item;
  final VoidCallback switchWidget;

  const ItemDialogActions(this.item, this.switchWidget);

  @override
  Widget build(BuildContext context) {
    var _fontSize = 18.0;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dialogListField(
            'Add to playlist', () => _addItemToPlaylist(item, context),
            fontSize: _fontSize, icon: Icons.playlist_add),
        _dialogListField('Edit Infos', switchWidget,
            fontSize: _fontSize, icon: Icons.info_outline),
        _dialogListField('See artist', () {},
            fontSize: _fontSize, icon: Icons.person_outline),
        _dialogListField('See album', () {},
            fontSize: _fontSize, icon: Icons.album_outlined),
        _dialogListField('Delete', () {},
            fontSize: _fontSize,
            icon: Icons.delete_outline,
            splashColor: Colors.red[200],
            fontColor: Colors.red[800]),
      ],
    );
  }

  void _addItemToPlaylist(Item _item, BuildContext context) async {
    var url = await _createURL(_item.id);
    MusicPlayer().addPlaylist(
        url,
        _item.id,
        _item.name,
        _item.artists.first.name,
        _item.album,
        MetasImage.network(getItemImageUrl(
            _item.id, _item.imageTags.primary, _item.imageBlurHashes)));
    Navigator.pop(context);
    showToast('${_item.name} added to playlist');
  }

  Future<String> _createURL(String itemId) async {
    var device = await deviceInfo();
    var url =
        '${server.url}/Audio/${itemId}/universal?UserId=${user.id}&DeviceId=${device.id}&Container=opus,mp3|mp3,aac,m4a,m4b|aac,flac,webma,webm,wav,ogg&TranscodingContainer=ts&TranscodingProtocol=hls&AudioCodec=aac&api_key=${apiKey}&StartTimeTicks=0&EnableRedirection=true&EnableRemoteMedia=false';
    return url;
  }

  Widget _dialogListField(String text, VoidCallback onTap,
      {double paddingTop = 10,
      double paddingBottom = 10,
      Color splashColor,
      Color fontColor,
      IconData icon,
      double fontSize = 18}) {
    return InkWell(
      onTap: onTap,
      splashColor: splashColor,
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                icon,
                color: fontColor,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
            child: Text(
              text,
              style: TextStyle(fontSize: fontSize, color: fontColor),
            ),
          ),
        ],
      ),
    );
  }
}
