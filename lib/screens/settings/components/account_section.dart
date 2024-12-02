part of 'sections.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: Text('account'.tr()),
      tiles: [
        SettingsTile(
            title: Text('change_server'.tr()),
            onPressed: (_) => context.router.root.navigate(r.ServersPage()),
            trailing: Icon(Icons.arrow_forward)),
        SettingsTile(
            title: Text('deconnect'.tr()),
            onPressed: (_) {
              context.read<AuthBloc>().add(LogoutRequested());
            },
            trailing: UserIcon()),
      ],
    );
  }
}
