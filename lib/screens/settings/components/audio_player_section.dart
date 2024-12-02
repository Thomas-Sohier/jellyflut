part of 'sections.dart';

class AudioPlayerSection extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<String>> _audioButton = GlobalKey();
  final GlobalKey<_AudioBitrateValueEditorState> _bitrateEditorButton =
      GlobalKey();

  AudioPlayerSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: Text('audio_player'.tr(),
          style: Theme.of(context).textTheme.titleLarge),
      tiles: [
        SettingsTile(
            title: Text('preferred_audio_codec'.tr()),
            onPressed: (context) => _audioButton.currentState?.showButtonMenu(),
            trailing: TranscodeCodecPopupButton(popupButtonKey: _audioButton)),
        SettingsTile(
          title: Text('max_bitrate'.tr()),
          onPressed: (c) =>
              _bitrateEditorButton.currentState?.editBitrateValue(c),
          trailing: AudioBitrateValueEditor(key: _bitrateEditorButton),
        ),
      ],
    );
  }
}
