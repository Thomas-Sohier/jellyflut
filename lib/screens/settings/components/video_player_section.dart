part of 'sections.dart';

class VideoPlayerSection extends StatelessWidget {
  final Setting setting;
  final Database database;
  final GlobalKey<PopupMenuButtonState<String>> _playerButton = GlobalKey();
  final GlobalKey<_VideoBitrateValueEditorState> _bitrateEditorButton =
      GlobalKey();

  VideoPlayerSection({Key? key, required this.setting, required this.database})
      : super(key: key);

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'video_player'.tr(),
      titleTextStyle: Theme.of(context).textTheme.headline6,
      tiles: [
        SettingsTile(
            title: 'preferred_player'.tr(),
            onPressed: (context) =>
                _playerButton.currentState?.showButtonMenu(),
            trailing: VideoPlayerPopupButton(
              popupButtonKey: _playerButton,
              database: database,
              setting: setting,
            )),
        SettingsTile(
          title: 'max_bitrate'.tr(),
          subtitle: 'Edit max video bitrate value',
          onPressed: (c) =>
              _bitrateEditorButton.currentState?.editBitrateValue(c),
          trailing: VideoBitrateValueEditor(
              key: _bitrateEditorButton, database: database),
        ),
      ],
    );
  }
}
