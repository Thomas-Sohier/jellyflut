part of 'sections.dart';

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
            trailing: LocaleButtonSelector()),
      ],
    );
  }
}
