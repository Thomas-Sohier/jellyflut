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
                        VideoPlayerSection(setting: setting, database: db)
                            .build(context),
                        AudioPlayerSection(setting: setting, database: db)
                            .build(context),
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
}
