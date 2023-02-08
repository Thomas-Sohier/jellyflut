part of 'sections.dart';

class InfosSection extends StatelessWidget {
  const InfosSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'infos'.tr(),
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      tiles: [SettingsTile(title: 'version'.tr(), trailing: Text(context.read<SettingsBloc>().state.version))],
    );
  }
}
