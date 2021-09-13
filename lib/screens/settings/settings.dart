import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/settings/components/sections.dart';
import 'package:jellyflut/services/auth/auth_service.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/transcode_audio_codec.dart';
import 'package:jellyflut/models/enum/streaming_software.dart';
import 'package:jellyflut/screens/details/template/components/user_icon.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/components/back_button.dart' as bb;
import 'package:moor/moor.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late Setting setting;
  late Database db;
  PackageInfo? packageInfo;
  late Future<dynamic> settingsInfosFuture;

  @override
  void initState() {
    db = AppDatabase().getDatabase;
    settingsInfosFuture = getSettingsInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: Text('settings'.tr()), leading: bb.BackButton()),
        body: FutureBuilder(
            future: settingsInfosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: SettingsList(
                      contentPadding: EdgeInsets.only(top: 20),
                      backgroundColor: Theme.of(context).backgroundColor,
                      darkBackgroundColor: Theme.of(context).primaryColorDark,
                      lightBackgroundColor: Theme.of(context).primaryColorLight,
                      sections: [
                        SettingsSection(
                          title: 'video_player'.tr(),
                          titleTextStyle: theme.textTheme.headline6,
                          tiles: [
                            SettingsTile(
                              title: 'preferred_player'.tr(),
                              subtitle: setting.preferredPlayer,
                              titleTextStyle: TextStyle(color: Colors.white),
                              subtitleTextStyle:
                                  TextStyle(color: Colors.white60),
                              onPressed: (BuildContext context) =>
                                  selectVideoPlayer(),
                            ),
                            SettingsTile(
                              title: 'max_bitrate'.tr(),
                              subtitle: setting.maxVideoBitrate.toString(),
                              titleTextStyle: TextStyle(color: Colors.white),
                              subtitleTextStyle:
                                  TextStyle(color: Colors.white60),
                              enabled: false,
                              trailing: Container(
                                height: 0,
                                width: 0,
                              ),
                            ),
                          ],
                        ),
                        SettingsSection(
                          title: 'audio_player'.tr(),
                          titleTextStyle: theme.textTheme.headline6,
                          tiles: [
                            SettingsTile(
                              title: 'transcode_codec'.tr(),
                              subtitle: setting.preferredTranscodeAudioCodec,
                              titleTextStyle: TextStyle(color: Colors.white),
                              subtitleTextStyle:
                                  TextStyle(color: Colors.white60),
                              onPressed: (BuildContext context) =>
                                  selectTranscodeAudioCodec(),
                            ),
                            SettingsTile(
                              title: 'max_bitrate'.tr(),
                              subtitle: setting.maxAudioBitrate.toString(),
                              titleTextStyle: TextStyle(color: Colors.white),
                              subtitleTextStyle:
                                  TextStyle(color: Colors.white60),
                              enabled: false,
                              trailing: Container(
                                height: 0,
                                width: 0,
                              ),
                              // onPressed: (BuildContext context) =>
                              //     selectVideoPlayer(),
                            ),
                          ],
                        ),
                        InfosSection(version: packageInfo?.version)
                            .build(context),
                        InterfaceSection().build(context),
                        AccountSection().build(context)
                      ],
                    ),
                  ),
                );
              }
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ));
            }));
  }

  Future<void> getSettingsInfos() async {
    setting = await db.settingsDao.getSettingsById(userApp!.settingsId);
    packageInfo = await PackageInfo.fromPlatform();
  }

  void selectVideoPlayer() async {
    var selectedEnum = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          elevation: 2,
          title: Text('select_preferred_video_player'.tr(),
              style: TextStyle(color: Colors.white)),
          content: Container(
            width: 250,
            constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
            child: ListView.builder(
              itemCount: StreamingSoftwareName.values.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    index < StreamingSoftwareName.values.length
                        ? getEnumValue(StreamingSoftwareName.values
                            .elementAt(index)
                            .toString())
                        : 'disable'.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    customRouter.pop(
                      index < StreamingSoftwareName.values.length
                          ? getEnumValue(StreamingSoftwareName.values
                              .elementAt(index)
                              .toString())
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
          .copyWith(preferredPlayer: Value(selectedValue));
      await db.settingsDao.updateSettings(newSetting);
      setState(() {});
    }
  }

  void selectTranscodeAudioCodec() async {
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
                        ? getEnumValue(TranscodeAudioCodecName.values
                            .elementAt(index)
                            .toString())
                        : 'disable'.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    customRouter.pop(
                      index < TranscodeAudioCodecName.values.length
                          ? getEnumValue(TranscodeAudioCodecName.values
                              .elementAt(index)
                              .toString())
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
      await db.settingsDao.updateSettings(newSetting);
      setState(() {});
    }
  }
}
