import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProviderButton extends StatelessWidget {
  final String providerName;
  final String providerUrl;

  const ProviderButton({super.key, required this.providerUrl, required this.providerName});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _launchURL(providerUrl),
      style:
          TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                alignment: Alignment.center,
                side: BorderSide(width: 1, style: BorderStyle.solid, color: Theme.of(context).colorScheme.onSurface),
              )
              .copyWith(backgroundColor: buttonBackground(context))
              .copyWith(foregroundColor: buttonForeground(context))
              .copyWith(overlayColor: buttonBackground(context)),
      child: Text(providerName, style: TextStyle(fontFamily: 'Quicksand')),
    );
  }

  void _launchURL(String url) async =>
      await canLaunchUrlString(url) ? await launchUrlString(url) : throw 'cannot_open.'.tr(args: [url]);

  WidgetStateProperty<Color> buttonBackground(BuildContext context) {
    return WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
        return Theme.of(context).colorScheme.onSurface;
      } else if (states.contains(WidgetState.pressed)) {
        return Theme.of(context).colorScheme.onSurface.withOpacity(0.1);
      }
      return Colors.transparent;
    });
  }

  WidgetStateProperty<Color> buttonForeground(BuildContext context) {
    return WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
        return ColorUtil.invert(Theme.of(context).colorScheme.onSurface);
      }
      return Theme.of(context).colorScheme.onSurface;
    });
  }
}
