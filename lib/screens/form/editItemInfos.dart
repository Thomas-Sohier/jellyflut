import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

class EditItemInfos extends StatelessWidget {
  final Item item;

  const EditItemInfos(this.item);

  List<String> getEditableField() {
    return ['Name', 'OriginalTitle', 'DateCreated', 'PremiereDate', 'Overview'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Center(child: Text('Not yet done')),
    );
  }
}
