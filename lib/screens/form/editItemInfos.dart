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
    var _itemMap = item.toMap();
    _itemMap.removeWhere((key, value) => !getEditableField().contains(key));
    var keys = _itemMap.keys.toList();
    return SizedBox(
      width: double.maxFinite,
      child: Form(
          child: ListView.builder(
        itemCount: _itemMap.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var key = keys[index];
          var val = _itemMap[keys[index]] ?? '';
          return TextField(
            decoration: InputDecoration(
              hintText: key.toString(),
            ),
            controller: TextEditingController(text: val.toString()),
          );
        },
      )),
    );
  }
}
