part of 'sections.dart';

class AudioPlayerSection extends StatelessWidget {
  final Setting setting;
  final Database database;
  final GlobalKey<PopupMenuButtonState<String>> _audioButton = GlobalKey();

  AudioPlayerSection({Key? key, required this.setting, required this.database})
      : super(key: key);

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'audio_player'.tr(),
      titleTextStyle: Theme.of(context).textTheme.headline6,
      tiles: [
        SettingsTile(
            title: 'preferred_player'.tr(),
            onPressed: (context) => _audioButton.currentState?.showButtonMenu(),
            trailing: TranscodeCodecPopupButton(
              popupButtonKey: _audioButton,
              database: database,
              setting: setting,
            )),
        SettingsTile(
          title: 'max_bitrate'.tr(),
          subtitle: setting.maxAudioBitrate.toString(),
          titleTextStyle: TextStyle(color: Colors.white),
          subtitleTextStyle: TextStyle(color: Colors.white60),
          enabled: false,
          trailing: Container(
            height: 0,
            width: 0,
          ),
        ),
      ],
    );
  }
}
