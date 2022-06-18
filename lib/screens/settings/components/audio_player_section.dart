part of 'sections.dart';

class AudioPlayerSection extends StatelessWidget {
  final Setting setting;
  final Database database;
  final GlobalKey<PopupMenuButtonState<String>> _audioButton = GlobalKey();
  final GlobalKey<_AudioBitrateValueEditorState> _bitrateEditorButton =
      GlobalKey();

  AudioPlayerSection(
      {super.key, required this.setting, required this.database});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'audio_player'.tr(),
      titleTextStyle: Theme.of(context).textTheme.headline6,
      tiles: [
        SettingsTile(
            title: 'preferred_audio_codec'.tr(),
            onPressed: (context) => _audioButton.currentState?.showButtonMenu(),
            trailing: TranscodeCodecPopupButton(
              popupButtonKey: _audioButton,
              database: database,
              setting: setting,
            )),
        SettingsTile(
          title: 'max_bitrate'.tr(),
          subtitle: 'Edit max audio bitrate value',
          onPressed: (c) =>
              _bitrateEditorButton.currentState?.editBitrateValue(c),
          trailing: AudioBitrateValueEditor(
              key: _bitrateEditorButton, database: database),
        ),
      ],
    );
  }
}
