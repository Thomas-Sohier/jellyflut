part of 'sections.dart';

class AudioPlayerSection extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<String>> _audioButton = GlobalKey();
  final GlobalKey<_AudioBitrateValueEditorState> _bitrateEditorButton = GlobalKey();

  AudioPlayerSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'audio_player'.tr(),
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      tiles: [
        SettingsTile(
            title: 'preferred_audio_codec'.tr(),
            onPressed: (context) => _audioButton.currentState?.showButtonMenu(),
            trailing: TranscodeCodecPopupButton(popupButtonKey: _audioButton)),
        SettingsTile(
          title: 'max_bitrate'.tr(),
          subtitle: 'Edit max audio bitrate value',
          onPressed: (c) => _bitrateEditorButton.currentState?.editBitrateValue(c),
          trailing: AudioBitrateValueEditor(key: _bitrateEditorButton),
        ),
      ],
    );
  }
}
