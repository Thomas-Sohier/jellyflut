import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/async_item_image/async_item_image.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class Logo extends StatelessWidget {
  final Item item;
  final bool selectable;
  final EdgeInsets padding;
  final BoxConstraints constraints;

  const Logo({
    super.key,
    required this.item,
    this.selectable = true,
    this.padding = const EdgeInsets.all(0),
    this.constraints = const BoxConstraints(maxHeight: 100),
  });

  @override
  Widget build(BuildContext context) {
    if (selectable) {
      return OutlinedButtonSelector(padding: padding, onPressed: () => logoDialog(context), child: logo(context));
    }
    return logo(context);
  }

  void logoDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.64),
        builder: (_) {
          return GestureDetector(
            onTap: () => context.router.root.pop(),
            child: FocusableActionDetector(
                autofocus: true,
                descendantsAreFocusable: false,
                mouseCursor: SystemMouseCursors.click,
                actions: <Type, Action<Intent>>{
                  ActivateIntent: CallbackAction<Intent>(
                    onInvoke: (Intent intent) => context.router.pop(),
                  ),
                },
                child: Center(child: logo(context, BoxConstraints(maxWidth: 960)))),
          );
        });
  }

  Widget logo(BuildContext context, [BoxConstraints? overridedConstraints]) {
    return ConstrainedBox(
        constraints: overridedConstraints ?? constraints,
        child: AsyncImage(
          item: item,
          showParent: true,
          boxFit: BoxFit.contain,
          imageType: ImageType.Logo,
        ));
  }
}
