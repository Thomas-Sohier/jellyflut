import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/form/editItemInfos.dart';

class ManageButton extends StatelessWidget {
  final Item item;
  final double maxWidth;

  const ManageButton({Key? key, required this.item, this.maxWidth = 150})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaletteButton('Manage',
        onPressed: () => editInfos(context),
        minWidth: 40,
        maxWidth: maxWidth,
        borderRadius: 4,
        icon: Icon(Icons.settings, color: Colors.black87));
  }

  void editInfos(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Edit infos'),
              content: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: 100,
                      maxHeight: 600,
                      minWidth: 250,
                      maxWidth: 500),
                  child: EditItemInfos(item)));
        });
  }
}
