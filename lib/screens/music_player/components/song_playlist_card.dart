import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

class SongPlaylistCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets margin;
  const SongPlaylistCard(
      {super.key,
      this.child = const SizedBox(),
      this.margin = const EdgeInsets.fromLTRB(12, 18, 18, 18)});

  @override
  State<SongPlaylistCard> createState() => _SongPlaylistCardState();
}

class _SongPlaylistCardState extends State<SongPlaylistCard> {
  late ThemeData theme;
  late Color backgroundColor;
  late Color shadowColor;

  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    backgroundColor =
        ColorUtil.darken(Theme.of(context).colorScheme.background);
    shadowColor = Theme.of(context).shadowColor.withAlpha(150);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.margin,
        child: DecoratedBox(
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                boxShadow: [
                  BoxShadow(color: shadowColor, blurRadius: 6, spreadRadius: 2)
                ]),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('playlist'.tr(),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline5),
                  ),
                  Expanded(child: widget.child)
                ])));
  }
}
