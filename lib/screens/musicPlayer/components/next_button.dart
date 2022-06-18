import 'package:flutter/material.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/music_provider.dart';

class NextButton extends StatefulWidget {
  const NextButton({super.key});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  late ThemeData theme;
  late final MusicProvider musicProvider;
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
        onPressed: () => musicProvider.next(),
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
            Icons.skip_next,
            color: onPrimary,
            size: 32,
          ),
        ));
  }
}
