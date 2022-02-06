import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:jellyflut/components/back_button.dart' as bb;
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/screens/settings/components/sections.dart';
import 'package:jellyflut/services/file/file_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  PackageInfo? packageInfo;
  String? downloadPath;
  late Setting setting;
  late Database db;
  late Future<dynamic> settingsInfosFuture;

  @override
  void initState() {
    db = AppDatabase().getDatabase;
    settingsInfosFuture = getSettingsInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'settings'.tr(),
              style: Theme.of(context).textTheme.headline5,
            ),
            leading: bb.BackButton()),
        body: FutureBuilder(
            future: settingsInfosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: SettingsList(
                      contentPadding: EdgeInsets.only(bottom: 30),
                      backgroundColor: Theme.of(context).colorScheme.background,
                      darkBackgroundColor: Theme.of(context).primaryColorDark,
                      lightBackgroundColor: Theme.of(context).primaryColorLight,
                      sections: [
                        VideoPlayerSection(setting: setting, database: db)
                            .build(context),
                        AudioPlayerSection(setting: setting, database: db)
                            .build(context),
                        InfosSection(version: packageInfo?.version)
                            .build(context),
                        DownloadPathSection(
                                setting: setting,
                                database: db,
                                downloadPath: downloadPath)
                            .build(context),
                        InterfaceSection().build(context),
                        ThemeSwitcherSection().build(context),
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
    downloadPath = await FileService.getUserStoragePath();
  }
}
