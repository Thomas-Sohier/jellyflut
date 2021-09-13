part of 'sections.dart';

class InfosSection extends StatelessWidget {
  final String? version;

  const InfosSection({Key? key, this.version}) : super(key: key);

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'infos'.tr(),
      titleTextStyle: Theme.of(context).textTheme.headline6,
      tiles: [
        SettingsTile(
          title: 'version'.tr(),
          subtitle: version ?? 'unknown'.tr(),
          titleTextStyle: TextStyle(color: Colors.white),
          subtitleTextStyle: TextStyle(color: Colors.white60),
          trailing: Container(
            height: 0,
            width: 0,
          ),
        ),
      ],
    );
  }
}
