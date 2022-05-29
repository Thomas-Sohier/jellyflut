import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/mixins/absorb_action.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';

import '../async_image.dart';

class Poster extends StatefulWidget {
  final ImageType tag;
  final BoxFit boxFit;
  final Item item;
  final double? height;
  final double? width;
  final bool backup;
  final bool showParent;
  final bool dropShadow;
  final bool clickable;
  final String? heroTag;
  final Widget Function(BuildContext)? placeholder;

  const Poster(
      {super.key,
      this.showParent = false,
      this.dropShadow = false,
      this.backup = true,
      this.height,
      this.placeholder,
      this.width,
      this.heroTag,
      this.clickable = true,
      required this.tag,
      required this.boxFit,
      required this.item});
  @override
  _PosterState createState() => _PosterState();
}

class _PosterState extends State<Poster> with AbsordAction {
  late final FocusNode node;

  @override
  void initState() {
    node = FocusNode();
    super.initState();
  }

  Future<void> redirection() {
    return customRouter
        .push(DetailsRoute(item: widget.item, heroTag: widget.heroTag));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clickable) {
      return OutlinedButton(
        onPressed: () => action(redirection),
        autofocus: false,
        focusNode: node,
        style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                backgroundColor: Colors.transparent)
            .copyWith(shadowColor: buttonShadow())
            .copyWith(side: buttonBorderSide())
            .copyWith(padding: buttonPadding())
            .copyWith(elevation: buttonElevation()),
        child: poster(),
      );
    }
    return poster();
  }

  Widget poster() {
    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        child: dropShadowBuilder(AsyncImage(
            item: widget.item,
            tag: widget.tag,
            placeholder: widget.placeholder,
            boxFit: widget.boxFit,
            width: widget.width,
            height: widget.height,
            backup: widget.backup,
            showParent: widget.showParent)),
      );
    }
    return dropShadowBuilder(AsyncImage(
        item: widget.item,
        tag: widget.tag,
        boxFit: widget.boxFit,
        showParent: widget.showParent));
  }

  Widget dropShadowBuilder(Widget child) {
    if (widget.dropShadow) {
      return DropShadow(
          blurRadius: 8, spread: 1, offset: const Offset(0, 0), child: child);
    }
    return child;
  }

  MaterialStateProperty<Color> buttonShadow() {
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return Theme.of(context).colorScheme.secondary;
        }
        return Colors.transparent; // defer to the default
      },
    );
  }

  MaterialStateProperty<double> buttonElevation() {
    return MaterialStateProperty.resolveWith<double>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return 8;
        }
        return 0; // defer to the default
      },
    );
  }

  MaterialStateProperty<BorderSide> buttonBorderSide() {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.onBackground,
          );
        }
        return BorderSide(
            width: 0, color: Colors.transparent); // defer to the default
      },
    );
  }

  MaterialStateProperty<EdgeInsetsGeometry> buttonPadding() {
    return MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.focused)) {
        return EdgeInsets.all(4);
      }
      return EdgeInsets.zero;
    });
  }
}
