part of 'sections.dart';

class InterfaceSection extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<Locale>> _localeKey = GlobalKey();
  InterfaceSection({Key? key}) : super(key: key);

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'interface'.tr(),
      titleTextStyle: Theme.of(context).textTheme.headline6,
      tiles: [
        SettingsTile(
            title: 'language'.tr(),
            onPressed: (context) => _localeKey.currentState?.showButtonMenu(),
            titleTextStyle: TextStyle(color: Colors.white),
            subtitleTextStyle: TextStyle(color: Colors.white60),
            trailing: LocaleButtonSelector(localeKey: _localeKey)),
      ],
    );
  }
}
