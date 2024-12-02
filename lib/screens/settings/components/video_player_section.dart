part of 'sections.dart';

class VideoPlayerSection extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<String>> _playerButton = GlobalKey();
  final GlobalKey<_VideoBitrateValueEditorState> _bitrateEditorButton =
      GlobalKey();

  VideoPlayerSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: Text('video_player'.tr(),
          style: Theme.of(context).textTheme.titleLarge),
      tiles: [
        SettingsTile(
            title: Text('preferred_player'.tr()),
            onPressed: (context) =>
                _playerButton.currentState?.showButtonMenu(),
            trailing: VideoPlayerPopupButton(popupButtonKey: _playerButton)),
        SettingsTile(
          title: Text('max_bitrate'.tr()),
          onPressed: (c) =>
              _bitrateEditorButton.currentState?.editBitrateValue(c),
          trailing: VideoBitrateValueEditor(key: _bitrateEditorButton),
        ),
        SettingsTile(
          title: Text('direct_play'.tr()),
          trailing: const DirectPlaySwitch(),
        ),
      ],
    );
  }
}
