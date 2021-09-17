import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';
import 'package:jellyflut/screens/form/forms/buttons/buttons.dart';
import 'package:jellyflut/screens/form/forms/epub_form.dart';

class SettingButton extends StatefulWidget {
  SettingButton({Key? key}) : super(key: key);

  @override
  _SettingButtonState createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {
  late final FocusNode _node;
  @override
  void initState() {
    _node = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => editInfos(context),
        shape: CircleBorder(),
        node: _node,
        child: Icon(Icons.settings));
  }

  void editInfos(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('edit_infos'.tr()),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CancelButton(onPressed: customRouter.pop),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SubmitButton(onPressed: () => {}))
            ],
            content: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: 300,
                    maxHeight: 700,
                    minWidth: 350,
                    maxWidth: 500),
                child: EpubForm(
                  backgroundColor: Colors.yellow.shade100,
                  fontColor: Colors.grey.shade900,
                  fontSize: 18,
                ))));
  }
}
