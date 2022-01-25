part of 'sections.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({Key? key}) : super(key: key);

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'account'.tr(),
      titleTextStyle: Theme.of(context).textTheme.headline6,
      tiles: [
        SettingsTile(
            title: 'change_server'.tr(),
            titleTextStyle: TextStyle(color: Colors.white),
            subtitleTextStyle: TextStyle(color: Colors.white60),
            onPressed: (_) => customRouter.navigate(ServersRoute()),
            trailing: Icon(Icons.arrow_forward)),
        SettingsTile(
            title: 'deconnect'.tr(),
            subtitle: userApp?.name ?? 'Unknown'.tr(),
            titleTextStyle: TextStyle(color: Colors.white),
            subtitleTextStyle: TextStyle(color: Colors.white60),
            onPressed: (_) async => await AuthService.logout(),
            trailing: UserIcon()),
      ],
    );
  }
}
