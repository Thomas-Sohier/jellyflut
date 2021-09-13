part of 'sections.dart';

Offset? tapXY;
RenderBox? overlay;

class InterfaceSection extends StatelessWidget {
  const InterfaceSection({Key? key}) : super(key: key);

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'interface'.tr(),
      titleTextStyle: Theme.of(context).textTheme.headline6,
      tiles: [
        SettingsTile(
          title: 'language'.tr(),
          subtitle: context.locale.toLanguageTag(),
          titleTextStyle: TextStyle(color: Colors.white),
          subtitleTextStyle: TextStyle(color: Colors.white60),
          trailing: PopupMenuButton<Locale>(
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              initialValue: context.locale,
              onSelected: (Locale? locale) {
                if (locale != null) context.setLocale(locale);
              },
              itemBuilder: (BuildContext c) => _localeListTile(c)),
        ),
      ],
    );
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
