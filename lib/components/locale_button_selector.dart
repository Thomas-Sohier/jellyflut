import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocaleButtonSelector extends StatelessWidget {
  final bool showCurrentValue;
  final GlobalKey<PopupMenuButtonState<Locale>>? localeKey;
  const LocaleButtonSelector({super.key, this.localeKey, this.showCurrentValue = false});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      key: localeKey,
      initialValue: context.locale,
      onSelected: (Locale? locale) {
        if (locale != null) context.setLocale(locale);
      },
      itemBuilder: (BuildContext c) => _localeListTile(c),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(context.locale.toLanguageTag()),
        Icon(Icons.arrow_drop_down),
      ]),
    );
  }

  List<PopupMenuEntry<Locale>> _localeListTile(BuildContext context) {
    final languageItems = <PopupMenuEntry<Locale>>[];
    for (var locale in context.supportedLocales) {
      languageItems.add(CheckedPopupMenuItem(
        value: locale,
        checked: context.locale == locale,
        child: Text(locale.toLanguageTag()),
      ));
    }
    return languageItems;
  }
}
