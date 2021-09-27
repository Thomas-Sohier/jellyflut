part of 'sections.dart';

class AudioPlayerSection extends StatelessWidget {
  final Setting setting;
  final Database database;

  const AudioPlayerSection(
      {Key? key, required this.setting, required this.database})
      : super(key: key);

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'audio_player'.tr(),
      titleTextStyle: Theme.of(context).textTheme.headline6,
      tiles: [
        SettingsTile(
          title: 'transcode_codec'.tr(),
          subtitle: setting.preferredTranscodeAudioCodec,
          titleTextStyle: TextStyle(color: Colors.white),
          subtitleTextStyle: TextStyle(color: Colors.white60),
          onPressed: (BuildContext context) =>
              selectTranscodeAudioCodec(context),
        ),
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
          // onPressed: (BuildContext context) =>
          //     selectVideoPlayer(),
        ),
      ],
    );
  }

  void selectTranscodeAudioCodec(BuildContext context) async {
    var selectedEnum = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          elevation: 2,
          title: Text('select_preferred_audio_player'.tr(),
              style: TextStyle(color: Colors.white)),
          content: Container(
            width: 250,
            constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
            child: ListView.builder(
              itemCount: TranscodeAudioCodecName.values.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    index < TranscodeAudioCodecName.values.length
                        ? TranscodeAudioCodecName.values
                            .elementAt(index)
                            .getValue()
                        : 'disable'.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    customRouter.pop(
                      index < TranscodeAudioCodecName.values.length
                          ? TranscodeAudioCodecName.values
                              .elementAt(index)
                              .getValue()
                          : -1,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
    if (selectedEnum != null) {
      var selectedValue = selectedEnum.toLowerCase();
      var newSetting = setting
          .toCompanion(true)
          .copyWith(preferredTranscodeAudioCodec: Value(selectedValue));
      await database.settingsDao.updateSettings(newSetting);
    }
  }
}
