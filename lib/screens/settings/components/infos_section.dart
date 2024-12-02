part of 'sections.dart';

class InfosSection extends StatelessWidget {
  const InfosSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: Text('infos'.tr()),
      tiles: [
        SettingsTile(
            title: Text('version'.tr()),
            trailing: Text(context.read<SettingsBloc>().state.version))
      ],
    );
  }
}
