import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/services/auth/authService.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/TranscodeAudioCodec.dart';
import 'package:jellyflut/models/enum/streamingSoftware.dart';
import 'package:jellyflut/screens/details/template/components/userIcon.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/components/BackButton.dart' as bb;
import 'package:moor/moor.dart';
import 'package:package_info/package_info.dart';
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
        appBar: AppBar(title: Text('Settings'), leading: bb.BackButton()),
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
                          title: 'Video Player',
                          titleTextStyle: theme.textTheme.headline6,
                          tiles: [
                            SettingsTile(
                              title: 'Preferred player',
                              subtitle: setting.preferredPlayer,
                              titleTextStyle: TextStyle(color: Colors.white),
                              subtitleTextStyle:
                                  TextStyle(color: Colors.white60),
                              onPressed: (BuildContext context) =>
                                  selectVideoPlayer(),
                            ),
                            SettingsTile(
                              title: 'Max bitrate',
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
                          title: 'Audio player',
                          titleTextStyle: theme.textTheme.headline6,
                          tiles: [
                            SettingsTile(
                              title: 'Transcode codec',
                              subtitle: setting.preferredTranscodeAudioCodec,
                              titleTextStyle: TextStyle(color: Colors.white),
                              subtitleTextStyle:
                                  TextStyle(color: Colors.white60),
                              onPressed: (BuildContext context) =>
                                  selectTranscodeAudioCodec(),
                            ),
                            SettingsTile(
                              title: 'Max bitrate',
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
                        SettingsSection(
                          title: 'Infos',
                          titleTextStyle: theme.textTheme.headline6,
                          tiles: [
                            SettingsTile(
                              title: 'Version',
                              subtitle: packageInfo?.version ?? 'Unknown',
                              titleTextStyle: TextStyle(color: Colors.white),
                              subtitleTextStyle:
                                  TextStyle(color: Colors.white60),
                              trailing: Container(
                                height: 0,
                                width: 0,
                              ),
                            ),
                          ],
                        ),
                        SettingsSection(
                          title: 'Account',
                          titleTextStyle: theme.textTheme.headline6,
                          tiles: [
                            SettingsTile(
                                title: 'Deconnect',
                                subtitle: userApp!.name,
                                titleTextStyle: TextStyle(color: Colors.white),
                                subtitleTextStyle:
                                    TextStyle(color: Colors.white60),
                                onPressed: (_) async =>
                                    await AuthService.logout(),
                                trailing: UserIcon()),
                          ],
                        ),
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
          title: Text('Select preferred video player',
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
                        : 'Disable',
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
          title: Text('Select preferred transcode audio codec',
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
                        : 'Disable',
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
