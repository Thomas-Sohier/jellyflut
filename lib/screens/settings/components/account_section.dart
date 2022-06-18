part of 'sections.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'account'.tr(),
      titleTextStyle: Theme.of(context).textTheme.headline6,
      tiles: [
        SettingsTile(
            title: 'change_server'.tr(),
            onPressed: (_) => customRouter.navigate(ServersRoute()),
            trailing: Icon(Icons.arrow_forward)),
        SettingsTile(
            title: 'deconnect'.tr(),
            subtitle: userApp?.name ?? 'Unknown'.tr(),
            onPressed: (_) async => await AuthService.logout(),
            trailing: UserIcon()),
      ],
    );
  }
}
