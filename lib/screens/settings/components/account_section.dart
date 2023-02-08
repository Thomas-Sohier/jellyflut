part of 'sections.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'account'.tr(),
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      tiles: [
        SettingsTile(
            title: 'change_server'.tr(),
            onPressed: (_) => context.router.root.navigate(r.ServersPage()),
            trailing: Icon(Icons.arrow_forward)),
        SettingsTile(
            title: 'deconnect'.tr(),
            subtitle: context.read<AuthenticationRepository>().currentUser.username,
            onPressed: (_) {
              context.read<AuthBloc>().add(LogoutRequested());
            },
            trailing: UserIcon()),
      ],
    );
  }
}
