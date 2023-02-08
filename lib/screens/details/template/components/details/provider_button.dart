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
      style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
              alignment: Alignment.center,
              side: BorderSide(width: 1, style: BorderStyle.solid, color: Theme.of(context).colorScheme.onBackground))
          .copyWith(backgroundColor: buttonBackground(context))
          .copyWith(foregroundColor: buttonForeground(context))
          .copyWith(overlayColor: buttonBackground(context)),
      child: Text(
        providerName,
        style: TextStyle(fontFamily: 'Quicksand'),
      ),
    );
  }

  void _launchURL(String url) async =>
      await canLaunchUrlString(url) ? await launchUrlString(url) : throw 'cannot_open.'.tr(args: [url]);

  MaterialStateProperty<Color> buttonBackground(BuildContext context) {
    return MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
        return Theme.of(context).colorScheme.onBackground;
      } else if (states.contains(MaterialState.pressed)) {
        return Theme.of(context).colorScheme.onBackground.withOpacity(0.1);
      }
      return Colors.transparent;
    });
  }

  MaterialStateProperty<Color> buttonForeground(BuildContext context) {
    return MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
        return ColorUtil.invert(Theme.of(context).colorScheme.onBackground);
      }
      return Theme.of(context).colorScheme.onBackground;
    });
  }
}
