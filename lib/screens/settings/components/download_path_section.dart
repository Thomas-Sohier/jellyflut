part of 'sections.dart';

class DownloadPathSection extends StatelessWidget {
  final Setting setting;
  final String? downloadPath;
  final Database database;
  const DownloadPathSection(
      {Key? key,
      required this.setting,
      required this.database,
      required this.downloadPath})
      : super(key: key);

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'download'.tr(),
      titleTextStyle: Theme.of(context).textTheme.headline6,
      tiles: [
        SettingsTile(
          title: 'download_path'.tr(),
          onPressed: (_) => selectFolder(),
          trailing: LayoutBuilder(builder: ((context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.6),
              child: Row(
                children: [
                  Flexible(
                      child: Text(downloadPath ?? 'No path set', maxLines: 2)),
                  const SizedBox(width: 8),
                  Icon(Icons.folder_outlined)
                ],
              ),
            );
          })),
        ),
      ],
    );
  }

  void selectFolder() async {
    final path =
        await FilePicker.platform.getDirectoryPath(lockParentWindow: true);
    final s = setting.toCompanion(true).copyWith(downloadPath: Value(path));
    await database.settingsDao.updateSettings(s);
  }
}
