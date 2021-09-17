import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LocaleButtonSelector extends StatelessWidget {
  final Color foregroundColor;
  final bool showCurrentValue;
  final GlobalKey<PopupMenuButtonState<Locale>>? localeKey;
  const LocaleButtonSelector(
      {Key? key,
      this.localeKey,
      this.foregroundColor = Colors.white,
      this.showCurrentValue = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
        key: localeKey,
        initialValue: context.locale,
        onSelected: (Locale? locale) {
          if (locale != null) context.setLocale(locale);
        },
        itemBuilder: (BuildContext c) => _localeListTile(c),
        child: Row(children: [
          if (showCurrentValue)
            Text(context.locale.toLanguageTag(),
                style: TextStyle(color: foregroundColor)),
          Icon(Icons.arrow_drop_down, color: foregroundColor),
        ]));
  }

  List<PopupMenuEntry<Locale>> _localeListTile(BuildContext context) {
    final languageItems = <PopupMenuEntry<Locale>>[];
    context.supportedLocales
        .forEach((Locale locale) => languageItems.add(CheckedPopupMenuItem(
              value: locale,
              checked: context.locale == locale,
              child: Text(locale.toLanguageTag()),
            )));
    return languageItems;
  }
}
