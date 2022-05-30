part of 'sections.dart';

class InfosSection extends StatelessWidget {
  final String? version;

  const InfosSection({super.key, this.version});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'infos'.tr(),
      titleTextStyle: Theme.of(context).textTheme.headline6,
      tiles: [
        SettingsTile(
            title: 'version'.tr(), trailing: Text(version ?? 'unknown'.tr()))
      ],
    );
  }
}
