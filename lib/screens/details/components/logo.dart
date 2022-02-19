import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/async_image.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class Logo extends StatelessWidget {
  final Item item;
  final actions = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<Intent>(
      onInvoke: (Intent intent) => customRouter.pop(),
    ),
  };

  Logo({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: (() => showDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(0.64),
            builder: (_) {
              return GestureDetector(
                onTap: () => customRouter.pop(),
                child: FocusableActionDetector(
                  autofocus: true,
                  descendantsAreFocusable: false,
                  mouseCursor: SystemMouseCursors.click,
                  actions: actions,
                  child: Center(
                      child: logo(
                          context,
                          BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width / 2,
                              maxHeight:
                                  MediaQuery.of(context).size.height / 2))),
                ),
              );
            })),
        child: logo(context, BoxConstraints(maxHeight: 100)));
  }

  Widget logo(BuildContext context, BoxConstraints constraints) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        constraints: constraints,
        child: AsyncImage(
          item: item,
          showParent: true,
          boxFit: BoxFit.contain,
          errorWidget: SizedBox(),
          placeholder: SizedBox(),
          tag: ImageType.LOGO,
        ));
  }
}
