import 'dart:io';

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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        item.type == 'Music'
            ? _dialogListField(
                'Add to playlist', () => _addItemToPlaylist(item, context),
                fontSize: _fontSize, icon: Icons.playlist_add)
            : Container(),
        _dialogListField('Edit Infos', switchWidget,
            fontSize: _fontSize, icon: Icons.info_outline),
        item.type == 'Music'
            ? _dialogListField('See artist', () {},
                fontSize: _fontSize, icon: Icons.person_outline)
            : Container(),
        item.type == 'Music'
            ? _dialogListField('See album', () {},
                fontSize: _fontSize, icon: Icons.album_outlined)
            : Container(),
        _dialogListField(
            'Delete',
            () => deleteDialogItem(item, context).then((value) {
                  if (value) {
                    deleteItem(item.id).then((int statusCode) {
                      if (statusCode == HttpStatus.noContent) {
                        Navigator.pop(context);
                      } else {
                        AlertDialog(
                          content: Text("Error, cannot delete item..."),
                        );
                      }
                    });
                  }
                }),
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
        MetasImage.network(getItemImageUrl(_item.id, _item.imageTags.primary,
            imageBlurHashes: _item.imageBlurHashes)));
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

Future<bool> deleteDialogItem(Item item, BuildContext context) async {
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
            title: Text(
              'Delete ${item.name} ?',
              style: TextStyle(),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Text(
                  'This action cannot be reversed !',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SimpleDialogOption(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(
                            'no',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                    SimpleDialogOption(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                              color: Colors.red[700],
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 4,
                                    color: Colors.black26,
                                    spreadRadius: 2)
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: InkWell(
                              child: const Text(
                            'Yes',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                  ],
                ),
              )
            ]);
      });
}
