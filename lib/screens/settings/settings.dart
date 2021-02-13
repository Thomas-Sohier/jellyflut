import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/models/settingsDB.dart';
import 'package:jellyflut/models/streamingSoftware.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SettingsDB settingsDB;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF252525),
        appBar: AppBar(
          backgroundColor: Color(0xFF252525),
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Text('Settings'),
        ),
        body: FutureBuilder<SettingsDB>(
            future: getSettingsDB(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                settingsDB = snapshot.data;
                return SettingsList(
                  backgroundColor: Color(0xFF252525),
                  darkBackgroundColor: Color(0xFF252525),
                  sections: [
                    SettingsSection(
                      tiles: [
                        SettingsTile(
                          title: 'Preferred player',
                          subtitle: settingsDB.preferredPlayer,
                          titleTextStyle: TextStyle(color: Colors.white),
                          subtitleTextStyle: TextStyle(color: Colors.white60),
                          leading: Icon(Icons.play_arrow_outlined,
                              color: Colors.white),
                          onPressed: (BuildContext context) =>
                              selectVideoPlayer(),
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

  // TODO rework that shit
  Future<SettingsDB> getSettingsDB() async {
    var x = await DatabaseService().getSettings(0);
    return x;
  }

  void selectVideoPlayer() async {
    var selectedEnum = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF252525),
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
      settingsDB.id = 0;
      await DatabaseService().updateSettings(settingsDB);
      setState(() {});
    }
  }
}
