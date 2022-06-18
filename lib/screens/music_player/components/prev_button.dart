import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

class PrevButton extends StatefulWidget {
  const PrevButton({super.key});

  @override
  State<PrevButton> createState() => _PrevButtonState();
}

class _PrevButtonState extends State<PrevButton> {
  late final MusicProvider musicProvider;
  late ThemeData theme;
  final List<BoxShadow> shadows = [
    BoxShadow(color: Colors.black45, blurRadius: 4, spreadRadius: 2)
  ];

  @override
  void initState() {
    musicProvider = MusicProvider();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;

    return OutlinedButtonSelector(
        onPressed: () => musicProvider.previous(),
        shape: const RoundedRectangleBorder(
          borderRadius: borderRadiusButton,
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: primary,
              boxShadow: shadows,
              borderRadius: borderRadiusButton),
          child: Icon(
            Icons.skip_previous,
            color: onPrimary,
            size: 32,
          ),
        ));
  }
}
