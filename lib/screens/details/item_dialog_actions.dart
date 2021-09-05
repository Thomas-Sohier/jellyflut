import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/shared/toast.dart';

class ItemDialogActions extends StatelessWidget {
  final Item item;
  final VoidCallback? switchWidget;

  const ItemDialogActions(this.item, this.switchWidget);

  @override
  Widget build(BuildContext context) {
    var fToast = FToast();
    fToast.init(context);
    var _fontSize = 18.0;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        item.type == ItemType.AUDIO
            ? _dialogListField(
                'Add to playlist', () => _addItemToPlaylist(item, context),
                fontSize: _fontSize, icon: Icons.playlist_add)
            : Container(),
        _dialogListField('Edit Infos', switchWidget,
            fontSize: _fontSize, icon: Icons.info_outline),
        item.type == ItemType.AUDIO
            ? _dialogListField('See artist', () async {
                var artist = await getArtist(item);
                if (artist == null) {
                  showToast('Canno get artist', fToast);
                } else {
                  await customRouter
                      .replace(DetailsRoute(item: artist, heroTag: ''));
                }
              }, fontSize: _fontSize, icon: Icons.person_outline)
            : Container(),
        item.type == ItemType.AUDIO
            ? _dialogListField('See album', () async {
                var album = await getAlbum(item);
                await customRouter
                    .replace(DetailsRoute(item: album, heroTag: ''));
              }, fontSize: _fontSize, icon: Icons.album_outlined)
            : Container(),
        _dialogListField(
            'Delete',
            () => deleteDialogItem(item, context).then((value) {
                  if (value != null) {
                    ItemService.deleteItem(item.id).then((int statusCode) {
                      if (statusCode == HttpStatus.noContent) {
                        customRouter.pop();
                      } else {
                        AlertDialog(
                          content: Text('Error, cannot delete item...'),
                        );
                      }
                    });
                  }
                }),
            fontSize: _fontSize,
            icon: Icons.delete_outline,
            splashColor: Colors.red[200]!,
            fontColor: Colors.red[800]!),
      ],
    );
  }

  void _addItemToPlaylist(Item _item, BuildContext context) async {
    // musicPlayer.addPlaylist(
    //     item, musicPlayer.assetsAudioPlayer.playlist!.audios.length);
    await customRouter.pop();
    var fToast = FToast();
    fToast.init(context);
    showToast('${_item.name} added to playlist', fToast);
  }

  Widget _dialogListField(String text, VoidCallback? onTap,
      {required IconData icon,
      Color? splashColor,
      Color? fontColor,
      double paddingTop = 10,
      double paddingBottom = 10,
      double fontSize = 18}) {
    return InkWell(
      onTap: onTap,
      splashColor: splashColor,
      child: Row(
        children: [
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

Future<bool?> deleteDialogItem(Item item, BuildContext context) async {
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
                        customRouter.pop(false);
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(
                            'No',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                    SimpleDialogOption(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        customRouter.pop(true);
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                              color: Colors.red[600],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: InkWell(
                              child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ))),
                    ),
                  ],
                ),
              )
            ]);
      });
}

Future<Item> getAlbum(Item item) async {
  return await ItemService.getItem(item.albumId!);
}

Future<Item?> getArtist(Item item) async {
  var val = item.artistItems?.first.artistItems['Id'];
  return await ItemService.getItem(val);
}
