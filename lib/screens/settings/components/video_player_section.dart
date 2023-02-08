part of 'sections.dart';

class VideoPlayerSection extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<String>> _playerButton = GlobalKey();
  final GlobalKey<_VideoBitrateValueEditorState> _bitrateEditorButton = GlobalKey();

  VideoPlayerSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'video_player'.tr(),
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      tiles: [
        SettingsTile(
            title: 'preferred_player'.tr(),
            onPressed: (context) => _playerButton.currentState?.showButtonMenu(),
            trailing: VideoPlayerPopupButton(popupButtonKey: _playerButton)),
        SettingsTile(
          title: 'max_bitrate'.tr(),
          subtitle: 'Edit max video bitrate value',
          onPressed: (c) => _bitrateEditorButton.currentState?.editBitrateValue(c),
          trailing: VideoBitrateValueEditor(key: _bitrateEditorButton),
        ),
        SettingsTile(
          title: 'direct_play'.tr(),
          subtitle: 'Force playing directly without transcoding',
          trailing: const DirectPlaySwitch(),
        ),
      ],
    );
  }
}
