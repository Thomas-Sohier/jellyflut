part of 'sections.dart';

class InterfaceSection extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<Locale>> _localeKey = GlobalKey();
  InterfaceSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'interface'.tr(),
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      tiles: [
        SettingsTile(
            title: 'language'.tr(),
            onPressed: (context) => _localeKey.currentState?.showButtonMenu(),
            trailing: LocaleButtonSelector(localeKey: _localeKey)),
      ],
    );
  }
}
