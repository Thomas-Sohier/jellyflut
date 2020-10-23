import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/animateSwitchDialog.dart';

class ItemDialog {
  final Item _item;
  final BuildContext _buildContext;
  bool _first = true;

  ItemDialog(this._item, this._buildContext);

  Future<void> showMusicDialog() async {
    await showDialog(
        context: _buildContext,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(
                'Actions for ${_item.name} ?',
                style: TextStyle(),
              ),
              titlePadding: EdgeInsets.all(20),
              children: <Widget>[
                Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: AnimateSwitchDialog(_item)),
              ]);
        });
  }
}
