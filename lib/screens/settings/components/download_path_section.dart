part of 'sections.dart';

class DownloadPathSection extends StatelessWidget {
  const DownloadPathSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(title: 'download'.tr(), titleTextStyle: Theme.of(context).textTheme.titleLarge, tiles: [
      SettingsTile(
        title: 'download_path'.tr(),
        onPressed: selectFolder,
        trailing: Row(
          children: [
            BlocBuilder<SettingsBloc, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.databaseSetting.downloadPath != current.databaseSetting.downloadPath,
                builder: (_, state) => Text(state.databaseSetting.downloadPath ?? 'No path set', maxLines: 2)),
            const SizedBox(width: 8),
            const Icon(Icons.folder_outlined)
          ],
        ),
      )
    ]);
  }

  void selectFolder(BuildContext context) async {
    final path = await FilePicker.platform.getDirectoryPath(lockParentWindow: true);
    context
        .read<SettingsBloc>()
        .add(SettingsUpdateRequested(databaseSettingDto: DatabaseSettingDto(downloadPath: path)));
  }
}
