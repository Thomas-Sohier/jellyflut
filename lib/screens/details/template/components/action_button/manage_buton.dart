import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/form/form.dart';
import 'package:jellyflut/screens/form/forms/buttons/buttons.dart';
import 'package:jellyflut/shared/responsive_builder.dart';

class ManageButton extends StatelessWidget {
  final Item item;
  final double maxWidth;

  const ManageButton({Key? key, required this.item, this.maxWidth = 150})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaletteButton('Manage',
        onPressed: () => dialog(context),
        minWidth: 40,
        maxWidth: maxWidth,
        borderRadius: 4,
        icon: Icon(Icons.settings, color: Colors.black87));
  }

  void dialog(BuildContext context) {
    showDialog(
      builder: (BuildContext context) => ResponsiveBuilder.builder(
          mobile: () => editInfosFullscreen(context),
          tablet: () => editInfos(context),
          desktop: () => editInfos(context)),
      context: context,
    );
  }

  Widget editInfos(BuildContext context) {
    return AlertDialog(
        title: Text('Edit infos'),
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
                minHeight: 300, maxHeight: 700, minWidth: 350, maxWidth: 500),
            child: FormBuilder(item: item)));
  }

  Widget editInfosFullscreen(BuildContext context) {
    return AlertDialog(
        title: Text('Edit infos'),
        insetPadding: EdgeInsets.zero,
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
                minHeight: double.maxFinite,
                maxHeight: double.maxFinite,
                minWidth: double.maxFinite,
                maxWidth: double.maxFinite),
            child: FormBuilder(item: item)));
  }
}
