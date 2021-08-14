import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/form/editItemInfos.dart';

class ManageButton extends StatelessWidget {
  final Item item;

  const ManageButton({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaletteButton('Manage', () => editInfos(context),
        minWidth: 40,
        maxWidth: 150,
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
