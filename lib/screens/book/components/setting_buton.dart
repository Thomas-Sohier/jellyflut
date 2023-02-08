import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/screens/form/forms/epub_form.dart';

class SettingButton extends StatefulWidget {
  SettingButton({super.key});

  @override
  State<SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => editInfos(context),
        shape: CircleBorder(),
        child: Icon(
          Icons.settings,
          color: Theme.of(context).colorScheme.onBackground,
        ));
  }

  void editInfos(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('edit_infos'.tr()),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextButton(onPressed: context.router.root.pop, child: Text('cancel'.tr())),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextButton(onPressed: () => {}, child: Text('save'.tr())))
            ],
            content: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 300, maxHeight: 700, minWidth: 350, maxWidth: 500),
                child: EpubForm(
                  backgroundColor: Colors.yellow.shade100,
                  fontColor: Colors.grey.shade900,
                  fontSize: 18,
                ))));
  }
}
