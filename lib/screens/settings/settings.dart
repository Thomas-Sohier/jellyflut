import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/TranscodeAudioCodec.dart';
import 'package:jellyflut/models/settingsDB.dart';
import 'package:jellyflut/models/streamingSoftware.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:package_info/package_info.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SettingsDB settingsDB;
  PackageInfo packageInfo;
  DatabaseService databaseService;

  @override
  void initState() {
    databaseService = DatabaseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF252525),
        appBar: AppBar(
          title: Text('Settings'),
          brightness: Brightness.dark,
          backgroundColor: Color(0xFF252525),
        ),
        body: FutureBuilder(
            future: getSettingsInfos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SettingsList(
                  contentPadding: EdgeInsets.only(top: 20),
                  backgroundColor: Color(0xFF252525),
                  darkBackgroundColor: Color(0xFF252525),
                  sections: [
                    SettingsSection(
                      title: 'Video Player',
                      titleTextStyle: TextStyle(
                          color: jellyLightBLue, fontWeight: FontWeight.bold),
                      tiles: [
                        SettingsTile(
                          title: 'Preferred player',
                          subtitle: settingsDB.preferredPlayer,
                          titleTextStyle: TextStyle(color: Colors.white),
                          subtitleTextStyle: TextStyle(color: Colors.white60),
                          onPressed: (BuildContext context) =>
                              selectVideoPlayer(),
                        ),
                        SettingsTile(
                          title: 'Max bitrate',
                          subtitle: settingsDB.maxVideoBitrate.toString(),
                          titleTextStyle: TextStyle(color: Colors.white),
                          subtitleTextStyle: TextStyle(color: Colors.white60),
                          enabled: false,
                          // onPressed: (BuildContext context) =>
                          //     selectVideoPlayer(),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: 'Audio player',
                      titleTextStyle: TextStyle(
                          color: jellyLightBLue, fontWeight: FontWeight.bold),
                      tiles: [
                        SettingsTile(
                          title: 'Transcode codec',
                          subtitle: settingsDB.preferredTranscodeAudioCodec,
                          titleTextStyle: TextStyle(color: Colors.white),
                          subtitleTextStyle: TextStyle(color: Colors.white60),
                          onPressed: (BuildContext context) =>
                              selectTranscodeAudioCodec(),
                        ),
                        SettingsTile(
                          title: 'Max bitrate',
                          subtitle: settingsDB.maxAudioBitrate.toString(),
                          titleTextStyle: TextStyle(color: Colors.white),
                          subtitleTextStyle: TextStyle(color: Colors.white60),
                          enabled: false,
                          // onPressed: (BuildContext context) =>
                          //     selectVideoPlayer(),
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: 'Infos',
                      titleTextStyle: TextStyle(
                          color: jellyLightBLue, fontWeight: FontWeight.bold),
                      tiles: [
                        SettingsTile(
                          title: 'Version',
                          subtitle: packageInfo.version,
                          titleTextStyle: TextStyle(color: Colors.white),
                          subtitleTextStyle: TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ],
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
    settingsDB = await databaseService.getSettings(userDB.settingsId);
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
            width: double.maxFinite,
            height: 250,
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
                    Navigator.pop(
                      context,
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
      settingsDB.preferredPlayer = selectedValue;
      await databaseService.updateSettings(settingsDB);
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
            width: double.maxFinite,
            height: 250,
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
                    Navigator.pop(
                      context,
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
      settingsDB.preferredTranscodeAudioCodec = selectedValue;
      await databaseService.updateSettings(settingsDB);
      setState(() {});
    }
  }
}
